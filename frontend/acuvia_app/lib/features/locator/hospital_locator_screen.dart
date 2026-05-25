import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

// ── Hospital model ────────────────────────────────────────────────────────────
class _Hospital {
  final String  name;
  final LatLng  position;
  final String? address;
  final String? phone;
  final String? openingHours;
  final bool?   isOpen;         // null = unknown
  final double  distanceKm;

  const _Hospital({
    required this.name,
    required this.position,
    this.address,
    this.phone,
    this.openingHours,
    this.isOpen,
    required this.distanceKm,
  });
}

// ── Opening hours parser ──────────────────────────────────────────────────────
// Parses basic OSM opening_hours strings like "Mo-Fr 08:00-17:00"
// Returns true = open, false = closed, null = unknown
bool? _parseIsOpen(String? raw) {
  if (raw == null) return null;
  final lower = raw.toLowerCase().trim();

  // 24/7
  if (lower == '24/7') return true;

  try {
    final now      = DateTime.now();
    final weekdays = ['mo', 'tu', 'we', 'th', 'fr', 'sa', 'su'];
    final todayIdx = now.weekday - 1; // 0=Mon … 6=Sun
    final today    = weekdays[todayIdx];

    // Split rules by semicolon
    for (final rule in lower.split(';')) {
      final part = rule.trim();
      if (part.isEmpty) continue;

      // Check if today's day is in the rule
      bool dayMatch = false;

      // Pattern: "mo-fr" or "mo,we,fr" or "mo" or no day (applies to all)
      final timeRegex = RegExp(r'(\d{2}:\d{2})-(\d{2}:\d{2})');
      final dayPart   = part.replaceAll(timeRegex, '').trim();

      if (dayPart.isEmpty || dayPart == part) {
        // No day specifier — applies to all days
        dayMatch = true;
      } else if (dayPart.contains('-')) {
        // Range like "mo-fr"
        final parts    = dayPart.split('-');
        if (parts.length == 2) {
          final startIdx = weekdays.indexOf(parts[0].trim().substring(0, 2));
          final endIdx   = weekdays.indexOf(parts[1].trim().substring(0, 2));
          if (startIdx != -1 && endIdx != -1) {
            dayMatch = todayIdx >= startIdx && todayIdx <= endIdx;
          }
        }
      } else {
        // List like "mo,we,fr"
        for (final d in dayPart.split(',')) {
          if (d.trim().startsWith(today)) {
            dayMatch = true;
            break;
          }
        }
      }

      if (!dayMatch) continue;

      // Extract time range
      final match = timeRegex.firstMatch(part);
      if (match == null) continue;

      final open  = match.group(1)!.split(':');
      final close = match.group(2)!.split(':');

      final openTime  = TimeOfDay(hour: int.parse(open[0]),  minute: int.parse(open[1]));
      final closeTime = TimeOfDay(hour: int.parse(close[0]), minute: int.parse(close[1]));
      final nowTime   = TimeOfDay(hour: now.hour, minute: now.minute);

      final openMins  = openTime.hour * 60  + openTime.minute;
      final closeMins = closeTime.hour * 60 + closeTime.minute;
      final nowMins   = nowTime.hour * 60   + nowTime.minute;

      return nowMins >= openMins && nowMins < closeMins;
    }
  } catch (_) {
    return null;
  }
  return null;
}

// ─────────────────────────────────────────────────────────────────────────────
// HospitalLocatorScreen
// ─────────────────────────────────────────────────────────────────────────────
class HospitalLocatorScreen extends StatefulWidget {
  const HospitalLocatorScreen({super.key});

  @override
  State<HospitalLocatorScreen> createState() => _HospitalLocatorScreenState();
}

class _HospitalLocatorScreenState extends State<HospitalLocatorScreen> {
  // ── Acuvia color scheme ───────────────────────────────────────────────────
  static const Color _primary  = Color(0xFF1A7A9B);
  static const Color _teal     = Color(0xFF26C6A6);
  static const Color _bgColor  = Color(0xFFF5F6FA);
  static const Color _textDark = Color(0xFF1A1A2E);
  static const Color _textSub  = Color(0xFF7A8A92);

  final MapController _mapController = MapController();

  LatLng?         _userLocation;
  List<_Hospital> _hospitals    = [];
  _Hospital?      _selected;
  bool            _locating     = true;
  bool            _searching    = false;
  String?         _error;

  // Filter: 'all' | 'open'
  String _filter = 'all';

  List<_Hospital> get _filtered => _filter == 'open'
      ? _hospitals.where((h) => h.isOpen == true).toList()
      : _hospitals;

  // Suggestion: nearest open hospital
  _Hospital? get _suggestion {
    if (_hospitals.isEmpty) return null;
    final open = _hospitals.where((h) => h.isOpen == true).toList();
    // Prefer the nearest open hospital, otherwise return the nearest overall
    return open.isNotEmpty ? open.first : _hospitals.first;
  }

  @override
  void initState() {
    super.initState();
    _initLocation();
  }

  // ── Location ──────────────────────────────────────────────────────────────
  Future<void> _initLocation() async {
    setState(() { _locating = true; _error = null; });

    LocationPermission perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
    }
    if (perm == LocationPermission.deniedForever ||
        perm == LocationPermission.denied) {
      setState(() {
        _locating = false;
        _error    = 'Location permission denied. '
            'Please enable it in your device settings.';
      });
      return;
    }

    try {
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high),
      );
      final loc = LatLng(pos.latitude, pos.longitude);
      setState(() { _userLocation = loc; _locating = false; });
      _mapController.move(loc, 14);
      await _fetchNearbyHospitals(loc);
    } catch (e) {
      setState(() {
        _locating = false;
        _error    = 'Could not get your location. Please try again.';
      });
    }
  }

  // ── Overpass API ──────────────────────────────────────────────────────────
  Future<void> _fetchNearbyHospitals(LatLng center) async {


    setState(() { _searching = true; });

    // Radius is in meters: 15km for all, 5km if strictly looking for open
    final int radius = _filter == 'all' ? 15000 : 5000; 

    final query = '''
[out:json][timeout:25];
(
  node["amenity"="hospital"](around:$radius,${center.latitude},${center.longitude});
  way["amenity"="hospital"](around:$radius,${center.latitude},${center.longitude});
  node["amenity"="clinic"](around:$radius,${center.latitude},${center.longitude});
  way["amenity"="clinic"](around:$radius,${center.latitude},${center.longitude});
  node["healthcare"="hospital"](around:$radius,${center.latitude},${center.longitude});
  node["healthcare"="clinic"](around:$radius,${center.latitude},${center.longitude});
);
out center;
''';
try {
      final res = await http.post(
        Uri.parse('https://overpass-api.de/api/interpreter'),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
          'User-Agent': 'AcuviaApp/1.0 (Student Project)', // <-- This tells the server not to block you!
        },
        body: 'data=${Uri.encodeComponent(query)}',
      );
      if (res.statusCode != 200) throw Exception('API error');

      final data     = jsonDecode(res.body) as Map<String, dynamic>;
      final elements = data['elements'] as List<dynamic>;
      final hospitals = <_Hospital>[];

      for (final el in elements) {
        final tags = el['tags'] as Map<String, dynamic>?;
        if (tags == null) continue;

        final name  = tags['name'] as String?;
        if (name == null || name.isEmpty) continue;

        double? lat;
        double? lon;

        if (el['type'] == 'node') {
          lat = (el['lat'] as num?)?.toDouble();
          lon = (el['lon'] as num?)?.toDouble();
        } else if (el['type'] == 'way') {
          final c = el['center'] as Map<String, dynamic>?;
          lat = (c?['lat'] as num?)?.toDouble();
          lon = (c?['lon'] as num?)?.toDouble();
        }
        if (lat == null || lon == null) continue;

        final pos  = LatLng(lat, lon);
        final dist = const Distance().as(LengthUnit.Kilometer, center, pos);
        
        // Default to 24/7 if OSM is missing the opening hours tag for a hospital
        final hours = tags['opening_hours'] as String? ?? '24/7';

        hospitals.add(_Hospital(
          name:         name,
          position:     pos,
          address:      tags['addr:full'] as String? ??
                        tags['addr:street'] as String?,
          phone:        tags['phone'] as String? ??
                        tags['contact:phone'] as String?,
          openingHours: hours,
          isOpen:       _parseIsOpen(hours),
          distanceKm:   dist,
        ));
      }

      hospitals.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
      setState(() { _hospitals = hospitals; _searching = false; });
      
      if (hospitals.isNotEmpty) {
        _mapController.move(hospitals.first.position, 13.5);
      }
    } catch (e) {
      setState(() {
        _searching = false;
        _error     = 'Could not load nearby hospitals. Check your connection.';
      });
    }
  }

  // ── Directions ────────────────────────────────────────────────────────────
  Future<void> _openDirections(_Hospital hospital) async {
    final lat = hospital.position.latitude;
    final lon = hospital.position.longitude;
    final uri = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$lat,$lon');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  // ── Bottom sheet ──────────────────────────────────────────────────────────
  void _showHospitalSheet(_Hospital hospital) {
    setState(() => _selected = hospital);
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _HospitalSheet(
        hospital:     hospital,
        primaryColor: _primary,
        tealColor:    _teal,
        onDirections: () {
          Navigator.pop(context);
          _openDirections(hospital);
        },
      ),
    ).whenComplete(() => setState(() => _selected = null));
  }

  // ── Build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: _textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Nearby Hospitals',
          style: TextStyle(
              color: _textDark, fontSize: 17, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
        actions: [
          if (_userLocation != null)
            IconButton(
              icon: const Icon(Icons.my_location_rounded, color: _primary),
              onPressed: () => _mapController.move(_userLocation!, 14),
              tooltip: 'My location',
            ),
        ],
      ),
      body: _locating
          ? _buildLoadingView()
          : _error != null && _userLocation == null
              ? _buildErrorView()
              : _buildMapView(),
    );
  }

  // ── Loading ───────────────────────────────────────────────────────────────
  Widget _buildLoadingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: _primary),
          const SizedBox(height: 20),
          const Text('Getting your location…',
              style: TextStyle(
                  fontSize: 15, color: _textSub, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  // ── Error ─────────────────────────────────────────────────────────────────
  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.location_off_rounded,
                size: 64, color: Color(0xFFE53935)),
            const SizedBox(height: 20),
            Text(_error ?? 'Something went wrong.',
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 15, color: _textSub, height: 1.5)),
            const SizedBox(height: 28),
            ElevatedButton.icon(
              onPressed: _initLocation,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                    horizontal: 28, vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Map view ──────────────────────────────────────────────────────────────
  Widget _buildMapView() {
    final suggestion = _suggestion;

    return Stack(
      children: [
        // ── Map ──────────────────────────────────────────────────────────
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter:
                _userLocation ?? const LatLng(10.3157, 123.8854),
            initialZoom: 14,
            onTap: (_, _) => setState(() => _selected = null),
          ),
          children: [
            TileLayer(
              urlTemplate:
                  'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.acuvia_app',
            ),
            MarkerLayer(
              markers: [
                // User marker
                if (_userLocation != null)
                  Marker(
                    point: _userLocation!,
                    width: 48,
                    height: 48,
                    child: Container(
                      decoration: BoxDecoration(
                        color: _primary.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                        border: Border.all(color: _primary, width: 2.5),
                      ),
                      child: const Icon(Icons.person_pin_circle_rounded,
                          color: _primary, size: 28),
                    ),
                  ),
                // Hospital markers
                ..._filtered.map((h) => Marker(
                      point:  h.position,
                      width:  44,
                      height: 44,
                      child: GestureDetector(
                        onTap: () => _showHospitalSheet(h),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            // Green if open, red if closed, primary if unknown
                            color: _selected == h
                                ? _teal
                                : h.isOpen == true
                                    ? const Color(0xFF43A047)
                                    : h.isOpen == false
                                        ? const Color(0xFFE53935)
                                        : _primary,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: (_selected == h
                                        ? _teal
                                        : _primary)
                                    .withValues(alpha: 0.4),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: const Icon(
                              Icons.local_hospital_rounded,
                              color: Colors.white,
                              size: 22),
                        ),
                      ),
                    )),
              ],
            ),
          ],
        ),

        // ── Top area: filter + status ─────────────────────────────────────
        Positioned(
          top: 12,
          left: 12,
          right: 12,
          child: Column(
            
            children: [
              // Filter toggle
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _FilterChip(
                    label: 'All',
                    selected: _filter == 'all',
                    color: _primary,
                    onTap: () async {
                      setState(() => _filter = 'all');
                      if (_userLocation != null) await _fetchNearbyHospitals(_userLocation!);
                    },
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: '🟢 Open Now',
                    selected: _filter == 'open',
                    color: const Color(0xFF43A047),
                    onTap: () async {
                      setState(() => _filter = 'open');
                      if (_userLocation != null) await _fetchNearbyHospitals(_userLocation!);
                    },
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Status badge
              if (_searching)
                _StatusBadge(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: _primary),
                      ),
                      const SizedBox(width: 8),
                      Text('Finding nearby hospitals…',
                          style: TextStyle(
                              fontSize: 12,
                              color: _textDark,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                )
              else if (_hospitals.isNotEmpty)
                _StatusBadge(
                  color: _teal,
                  child: Text(
                    '${_hospitals.length} found · '
                    '${_hospitals.where((h) => h.isOpen == true).length} open now',
                    style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                  ),
                ),

              // ── Suggestion banner ────────────────────────────────────
              if (!_searching && suggestion != null) ...[
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: () {
                    _mapController.move(suggestion.position, 16);
                    _showHospitalSheet(suggestion);
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                          color: suggestion.isOpen == true ? const Color(0xFF43A047) : _primary, width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.07),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: (suggestion.isOpen == true ? const Color(0xFF43A047) : _primary).withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.recommend_rounded,
                              color: Color(0xFF43A047), size: 18),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                suggestion.isOpen == true ? 'Nearest Open Hospital' : 'Nearest Hospital',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: suggestion.isOpen == true ? const Color(0xFF43A047) : _primary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                suggestion.name,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: _textDark,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                '${suggestion.distanceKm.toStringAsFixed(1)} km away',
                                style: const TextStyle(
                                    fontSize: 11, color: _textSub),
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right_rounded,
                            color: _textSub, size: 20),
                      ],
                    ),
                  ),
                ),
              ],

              // No hospitals found
              if (!_searching &&
                  _hospitals.isEmpty &&
                  _userLocation != null)
                _StatusBadge(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.info_outline_rounded,
                          color: _textSub, size: 16),
                      const SizedBox(width: 6),
                      Text(
                          'No hospitals found within ${_filter == 'all' ? 15 : 5} km.',
                          style: const TextStyle(fontSize: 12, color: _textSub)),
                    ],
                  ),
                ),
            ],
          ),
        ),

        // ── Legend ───────────────────────────────────────────────────────
        if (!_searching && _hospitals.isNotEmpty)
          Positioned(
            right: 12,
            bottom: 175,
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _LegendDot(color: Color(0xFF43A047), label: 'Open'),
                  SizedBox(height: 4),
                  _LegendDot(color: Color(0xFFE53935), label: 'Closed'),
                  SizedBox(height: 4),
                  _LegendDot(color: Color(0xFF1A7A9B), label: 'Unknown'),
                ],
              ),
            ),
          ),

        // ── Hospital list (bottom) ────────────────────────────────────────
        if (!_searching && _filtered.isNotEmpty)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildHospitalList(),
          ),
      ],
    );
  }

  // ── Bottom hospital list ──────────────────────────────────────────────────
  Widget _buildHospitalList() {
    return Container(
      height: 160,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 12,
            offset: Offset(0, -3),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.only(top: 10),
            width: 36,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFFDDDDDD),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _filtered.length,
              separatorBuilder: (_, _) => const SizedBox(width: 12),
              itemBuilder: (_, i) => _buildHospitalCard(_filtered[i]),
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  // ── Hospital card ─────────────────────────────────────────────────────────
  Widget _buildHospitalCard(_Hospital h) {
    final isSelected = _selected == h;

    Color statusColor;
    String statusLabel;
    if (h.isOpen == true) {
      statusColor = const Color(0xFF43A047);
      statusLabel = 'Open';
    } else if (h.isOpen == false) {
      statusColor = const Color(0xFFE53935);
      statusLabel = 'Closed';
    } else {
      statusColor = _textSub;
      statusLabel = 'Hours unknown';
    }

    return GestureDetector(
      onTap: () {
        _mapController.move(h.position, 16);
        _showHospitalSheet(h);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 220,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected ? _primary.withValues(alpha: 0.08) : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? _primary : const Color(0xFFEEEEEE),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: _primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.local_hospital_rounded,
                      color: _primary, size: 16),
                ),
                const SizedBox(width: 6),
                // Open/Closed badge
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 7, vertical: 3),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(statusLabel,
                      style: TextStyle(
                          fontSize: 10,
                          color: statusColor,
                          fontWeight: FontWeight.w700)),
                ),
                const Spacer(),
                // Distance
                Text(
                  '${h.distanceKm.toStringAsFixed(1)}km',
                  style: TextStyle(
                      fontSize: 10,
                      color: _teal,
                      fontWeight: FontWeight.w700),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              h.name,
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: _textDark),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            if (h.address != null) ...[
              const SizedBox(height: 4),
              Text(h.address!,
                  style: const TextStyle(fontSize: 11, color: _textSub),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis),
            ],
          ],
        ),
      ),
    );
  }
}

// ── Reusable widgets ──────────────────────────────────────────────────────────

class _FilterChip extends StatelessWidget {
  final String   label;
  final bool     selected;
  final Color    color;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? color : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: selected ? color : const Color(0xFFDDDDDD)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.07),
              blurRadius: 6,
            ),
          ],
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : const Color(0xFF7A8A92),
          ),
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final Widget child;
  final Color  color;

  const _StatusBadge({required this.child, this.color = Colors.white});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color  color;
  final String label;

  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label,
            style: const TextStyle(fontSize: 11, color: Color(0xFF7A8A92))),
      ],
    );
  }
}

// ── Hospital bottom sheet ─────────────────────────────────────────────────────
class _HospitalSheet extends StatelessWidget {
  final _Hospital    hospital;
  final Color        primaryColor;
  final Color        tealColor;
  final VoidCallback onDirections;

  const _HospitalSheet({
    required this.hospital,
    required this.primaryColor,
    required this.tealColor,
    required this.onDirections,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    String statusLabel;
    IconData statusIcon;

    if (hospital.isOpen == true) {
      statusColor = const Color(0xFF43A047);
      statusLabel = 'Open Now';
      statusIcon  = Icons.check_circle_outline_rounded;
    } else if (hospital.isOpen == false) {
      statusColor = const Color(0xFFE53935);
      statusLabel = 'Closed';
      statusIcon  = Icons.cancel_outlined;
    } else {
      statusColor = const Color(0xFF7A8A92);
      statusLabel = 'Hours Unknown';
      statusIcon  = Icons.help_outline_rounded;
    }

    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 20,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Handle
          Center(
            child: Container(
              width: 36, height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFDDDDDD),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Name + distance
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.local_hospital_rounded,
                    color: primaryColor, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(hospital.name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1A1A2E),
                        )),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: tealColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${hospital.distanceKm.toStringAsFixed(2)} km away',
                            style: TextStyle(
                                fontSize: 11,
                                color: tealColor,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                        const SizedBox(width: 6),
                        // Open/Closed status
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: statusColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(statusIcon,
                                  color: statusColor, size: 11),
                              const SizedBox(width: 3),
                              Text(statusLabel,
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: statusColor,
                                      fontWeight: FontWeight.w700)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Opening hours
          if (hospital.openingHours != null) ...[
            Row(
              children: [
                Icon(Icons.schedule_rounded,
                    size: 16, color: Colors.grey.shade500),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(hospital.openingHours!,
                      style: TextStyle(
                          fontSize: 13, color: Colors.grey.shade600)),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],

          // Address
          if (hospital.address != null) ...[
            Row(
              children: [
                Icon(Icons.location_on_outlined,
                    size: 16, color: Colors.grey.shade500),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(hospital.address!,
                      style: TextStyle(
                          fontSize: 13, color: Colors.grey.shade600)),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],

          // Phone
          if (hospital.phone != null) ...[
            Row(
              children: [
                Icon(Icons.phone_outlined,
                    size: 16, color: Colors.grey.shade500),
                const SizedBox(width: 6),
                Text(hospital.phone!,
                    style: TextStyle(
                        fontSize: 13, color: Colors.grey.shade600)),
              ],
            ),
            const SizedBox(height: 8),
          ],

          const SizedBox(height: 16),

          // Get Directions
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onDirections,
              icon: const Icon(Icons.directions_rounded, size: 18),
              label: const Text('Get Directions',
                  style: TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w700)),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
                elevation: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}