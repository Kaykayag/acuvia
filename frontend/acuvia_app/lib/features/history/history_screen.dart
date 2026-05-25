// lib/features/history/presentation/screens/history_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// ════════════════════════════════════════════════════════════════════════════════
// MODELS
// ════════════════════════════════════════════════════════════════════════════════

enum AssessmentSeverity { critical, urgent, moderate, low }

extension SeverityTheme on AssessmentSeverity {
  String get label {
    switch (this) {
      case AssessmentSeverity.critical: return 'Critical';
      case AssessmentSeverity.urgent:   return 'Urgent';
      case AssessmentSeverity.moderate: return 'Moderate';
      case AssessmentSeverity.low:      return 'Low';
    }
  }

  Color get accentColor {
    switch (this) {
      case AssessmentSeverity.critical: return const Color(0xFFE53935);
      case AssessmentSeverity.urgent:   return const Color(0xFFFF8F00);
      case AssessmentSeverity.moderate: return const Color(0xFFFDD835);
      case AssessmentSeverity.low:      return const Color(0xFF43A047);
    }
  }

  Color get badgeColor {
    switch (this) {
      case AssessmentSeverity.critical: return const Color(0xFFE53935);
      case AssessmentSeverity.urgent:   return const Color(0xFFFF8F00);
      case AssessmentSeverity.moderate: return const Color(0xFFFDD835);
      case AssessmentSeverity.low:      return const Color(0xFF43A047);
    }
  }

  Color get badgeTextColor {
    switch (this) {
      case AssessmentSeverity.moderate: return const Color(0xFF5D4037);
      default:                          return Colors.white;
    }
  }

  IconData get icon {
    switch (this) {
      case AssessmentSeverity.critical: return Icons.error_outline_rounded;
      case AssessmentSeverity.urgent:   return Icons.warning_amber_rounded;
      case AssessmentSeverity.moderate: return Icons.access_time_rounded;
      case AssessmentSeverity.low:      return Icons.check_circle_outline_rounded;
    }
  }
}

class AssessmentTimeline {
  final DateTime startedAt;
  final DateTime? completedAt;
  final String? duration;
  const AssessmentTimeline({
    required this.startedAt,
    this.completedAt,
    this.duration,
  });
}

class Assessment {
  final String id;
  final String title;
  final DateTime dateTime;
  final AssessmentSeverity severity;
  final String? triageLevel;
  final String? duration;
  final List<String> symptoms;
  final String? recommendedAction;
  final String? clinicalNote;
  final AssessmentTimeline? timeline;

  const Assessment({
    required this.id,
    required this.title,
    required this.dateTime,
    required this.severity,
    this.triageLevel,
    this.duration,
    this.symptoms = const [],
    this.recommendedAction,
    this.clinicalNote,
    this.timeline,
  });
}

// ─── Sample data ──────────────────────────────────────────────────────────────

final _sampleAssessments = <Assessment>[
  Assessment(
    id: '1',
    title: 'Severe chest pain',
    dateTime: DateTime(2026, 5, 5, 14, 30),
    severity: AssessmentSeverity.critical,
    triageLevel: 'Level 1 - Immediate',
    duration: '1 hour',
    symptoms: ['Severe chest pain', 'Shortness of breath', 'Sweating'],
    recommendedAction: 'Same-day appointment scheduled',
    clinicalNote: 'Patient was immediately referred to ED. Cardiac event ruled out.',
    timeline: AssessmentTimeline(
      startedAt: DateTime(2026, 5, 5, 14, 30),
      completedAt: DateTime(2026, 5, 5, 16, 30),
      duration: '2 hours',
    ),
  ),
  Assessment(
    id: '2',
    title: 'Persistent headache',
    dateTime: DateTime(2026, 4, 20, 9, 15),
    severity: AssessmentSeverity.urgent,
    triageLevel: 'Level 2 - Emergency',
    duration: '45 min',
    symptoms: ['Persistent headache', 'Nausea', 'Light sensitivity'],
    recommendedAction: 'Follow-up within 24 hours',
    clinicalNote: 'Possible migraine episode. Prescribed pain relief.',
    timeline: AssessmentTimeline(
      startedAt: DateTime(2026, 4, 20, 9, 15),
      completedAt: DateTime(2026, 4, 20, 10, 0),
      duration: '45 minutes',
    ),
  ),
  Assessment(
    id: '3',
    title: 'Mild fever',
    dateTime: DateTime(2026, 3, 12, 16, 45),
    severity: AssessmentSeverity.moderate,
    triageLevel: 'Level 3 - Urgent',
    duration: '30 min',
    symptoms: ['Mild fever', 'Fatigue', 'Sore throat'],
    recommendedAction: 'Monitor at home, return if worsens',
    clinicalNote: 'Viral infection suspected. Rest and fluids advised.',
    timeline: AssessmentTimeline(
      startedAt: DateTime(2026, 3, 12, 16, 45),
      completedAt: DateTime(2026, 3, 12, 17, 15),
      duration: '30 minutes',
    ),
  ),
  Assessment(
    id: '4',
    title: 'Minor Cut',
    dateTime: DateTime(2026, 2, 8, 11, 20),
    severity: AssessmentSeverity.low,
    triageLevel: 'Level 5 - Non-urgent',
    duration: '15 min',
    symptoms: ['Minor cut on left hand'],
    recommendedAction: 'Self-care at home',
    clinicalNote: 'Wound cleaned and dressed. No stitches required.',
    timeline: AssessmentTimeline(
      startedAt: DateTime(2026, 2, 8, 11, 20),
      completedAt: DateTime(2026, 2, 8, 11, 35),
      duration: '15 minutes',
    ),
  ),
];

// ════════════════════════════════════════════════════════════════════════════════
// BOTTOM NAV ITEM MODEL  (same as HomeScreen)
// ════════════════════════════════════════════════════════════════════════════════

class _NavItem {
  final String label;
  final String asset;
  const _NavItem({required this.label, required this.asset});
}

// ════════════════════════════════════════════════════════════════════════════════
// HISTORY SCREEN
// ════════════════════════════════════════════════════════════════════════════════

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String? _expandedId;

  // History tab is index 1
  int _currentIndex = 1;

  static const Color _primaryColor = Color(0xFF1A7A9B);
  static const Color _navInactive  = Color(0xFFB0BEC5);

  static const List<_NavItem> _navItems = [
    _NavItem(label: 'Home',    asset: 'assets/Home.png'),
    _NavItem(label: 'History', asset: 'assets/Clipboard.png'),
    _NavItem(label: 'Learn',   asset: 'assets/Book open.png'),
    _NavItem(label: 'Profile', asset: 'assets/person.png'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: _buildBottomNav(context),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            Expanded(child: _buildList()),
          ],
        ),
      ),
    );
  }

  // ── Header ──────────────────────────────────────────────────────────────────

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Medical History',
            style: TextStyle(
              color: Color(0xFF111111),
              fontSize: 26,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${_sampleAssessments.length} assessments',
            style: const TextStyle(color: Color(0xFF9E9E9E), fontSize: 13),
          ),
        ],
      ),
    );
  }

  // ── List ────────────────────────────────────────────────────────────────────

  Widget _buildList() {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(14, 10, 14, 24),
      itemCount: _sampleAssessments.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final a = _sampleAssessments[index];
        final isExpanded = _expandedId == a.id;
        return _AssessmentCard(
          assessment: a,
          isExpanded: isExpanded,
          onTap: () => setState(() => _expandedId = isExpanded ? null : a.id),
        );
      },
    );
  }

  // ── Bottom nav (matches HomeScreen exactly) ──────────────────────────────────

  Widget _buildBottomNav(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 16,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_navItems.length, (index) {
              final item = _navItems[index];
              final isActive = _currentIndex == index;

              return GestureDetector(
                onTap: () {
                  setState(() => _currentIndex = index);
                  switch (index) {
                    case 0: context.go('/home'); break;
                    case 1: context.go('/history'); break;
                    case 2: context.go('/learn'); break;
                    case 3: context.go('/profile'); break;
                  }
                },
                behavior: HitTestBehavior.opaque,
                child: SizedBox(
                  width: 64,
                  height: 60,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ColorFiltered(
                        colorFilter: ColorFilter.mode(
                          isActive ? _primaryColor : _navInactive,
                          BlendMode.srcIn,
                        ),
                        child: Image.asset(
                          item.asset,
                          height: 26,
                          width: 26,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.label,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
                          color: isActive ? _primaryColor : _navInactive,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════════
// ASSESSMENT CARD
// ════════════════════════════════════════════════════════════════════════════════

class _AssessmentCard extends StatelessWidget {
  final Assessment assessment;
  final bool isExpanded;
  final VoidCallback onTap;

  const _AssessmentCard({
    required this.assessment,
    required this.isExpanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final s = assessment.severity;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: s.accentColor, width: 1.4),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(13),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(13),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(14, 14, 12, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(s.icon, color: s.accentColor, size: 20),
                        const SizedBox(width: 8),
                        _SeverityBadge(severity: s),
                        const Spacer(),
                        AnimatedRotation(
                          turns: isExpanded ? 0.5 : 0,
                          duration: const Duration(milliseconds: 300),
                          child: const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: Color(0xFF9E9E9E),
                            size: 22,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      assessment.title,
                      style: const TextStyle(
                        color: Color(0xFF111111),
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today_outlined,
                            color: Color(0xFF9E9E9E), size: 14),
                        const SizedBox(width: 6),
                        Text(
                          _fmtDateTime(assessment.dateTime),
                          style: const TextStyle(
                              color: Color(0xFF9E9E9E), fontSize: 13),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (isExpanded) _DetailSection(assessment: assessment),
          ],
        ),
      ),
    );
  }

  static String _fmtDateTime(DateTime dt) =>
      '${dt.year}-${_p(dt.month)}-${_p(dt.day)}   ${_p(dt.hour)}:${_p(dt.minute)}';
  static String _p(int v) => v.toString().padLeft(2, '0');
}

// ════════════════════════════════════════════════════════════════════════════════
// DETAIL SECTION
// ════════════════════════════════════════════════════════════════════════════════

class _DetailSection extends StatelessWidget {
  final Assessment assessment;
  const _DetailSection({required this.assessment});

  @override
  Widget build(BuildContext context) {
    final s  = assessment.severity;
    final tl = assessment.timeline;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(color: s.accentColor.withValues(alpha: 0.3), height: 1),
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Triage + Duration
              if (assessment.triageLevel != null || assessment.duration != null) ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (assessment.triageLevel != null)
                      Expanded(
                        child: _InfoBox(
                          label: 'Triage Level',
                          value: assessment.triageLevel!,
                          valueColor: s.accentColor,
                        ),
                      ),
                    if (assessment.triageLevel != null && assessment.duration != null)
                      const SizedBox(width: 10),
                    if (assessment.duration != null)
                      _InfoBox(
                        label: 'Duration',
                        value: assessment.duration!,
                        icon: Icons.access_time_rounded,
                      ),
                  ],
                ),
                const SizedBox(height: 14),
              ],

              // Symptoms
              if (assessment.symptoms.isNotEmpty) ...[
                const _SectionLabel('All symptoms'),
                const SizedBox(height: 8),
                ...assessment.symptoms.asMap().entries.map(
                  (e) => _SymptomRow(
                    index: e.key + 1,
                    symptom: e.value,
                    accentColor: s.accentColor,
                  ),
                ),
                const SizedBox(height: 14),
              ],

              // Recommended action
              if (assessment.recommendedAction != null) ...[
                const _SectionLabel('Recommended Action'),
                const SizedBox(height: 6),
                _TagChip(
                  label: assessment.recommendedAction!,
                  color: const Color(0xFFBBDEFB),
                  textColor: const Color(0xFF1565C0),
                ),
                const SizedBox(height: 14),
              ],

              // Clinical notes
              if (assessment.clinicalNote != null) ...[
                const _SectionLabel('Clinical Notes'),
                const SizedBox(height: 6),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF9C4),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.warning_amber_rounded,
                          color: Color(0xFFFF8F00), size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          assessment.clinicalNote!,
                          style: const TextStyle(
                              color: Color(0xFF5D4037), fontSize: 12.5, height: 1.4),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
              ],

              // Timeline
              if (tl != null) ...[
                const _SectionLabel('Timeline'),
                const SizedBox(height: 10),
                _TimelineRow(
                  dot: const Color(0xFF1E88E5),
                  title: 'Assessment Started',
                  subtitle: '${_fmtDate(tl.startedAt)} at ${_fmtTime(tl.startedAt)}',
                ),
                const SizedBox(height: 10),
                if (tl.completedAt != null)
                  _TimelineRow(
                    dot: const Color(0xFF43A047),
                    title: 'Assessment Completed',
                    subtitle: 'Duration: ${tl.duration ?? '—'}',
                  ),
                const SizedBox(height: 14),
              ],

              // Download report
              InkWell(
                onTap: () {},
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFFBDBDBD)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.description_outlined,
                          size: 16, color: Color(0xFF616161)),
                      SizedBox(width: 6),
                      Text(
                        'Download Report',
                        style: TextStyle(
                            color: Color(0xFF616161),
                            fontSize: 13,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 4),
            ],
          ),
        ),
      ],
    );
  }

  static String _fmtDate(DateTime dt) =>
      '${dt.year}-${_p(dt.month)}-${_p(dt.day)}';
  static String _fmtTime(DateTime dt) => '${_p(dt.hour)}:${_p(dt.minute)}';
  static String _p(int v) => v.toString().padLeft(2, '0');
}

// ════════════════════════════════════════════════════════════════════════════════
// SMALL REUSABLE WIDGETS
// ════════════════════════════════════════════════════════════════════════════════

class _SeverityBadge extends StatelessWidget {
  final AssessmentSeverity severity;
  const _SeverityBadge({required this.severity});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: severity.badgeColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        severity.label,
        style: TextStyle(
          color: severity.badgeTextColor,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: const TextStyle(
            color: Color(0xFF111111),
            fontSize: 13,
            fontWeight: FontWeight.w600));
  }
}

class _InfoBox extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final IconData? icon;

  const _InfoBox({
    required this.label,
    required this.value,
    this.valueColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(color: Color(0xFF9E9E9E), fontSize: 11)),
          const SizedBox(height: 3),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 13, color: valueColor ?? const Color(0xFF111111)),
                const SizedBox(width: 4),
              ],
              Text(value,
                  style: TextStyle(
                      color: valueColor ?? const Color(0xFF111111),
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }
}

class _SymptomRow extends StatelessWidget {
  final int index;
  final String symptom;
  final Color accentColor;

  const _SymptomRow({
    required this.index,
    required this.symptom,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: accentColor.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: accentColor.withValues(alpha: 0.15)),
        ),
        child: Row(
          children: [
            Icon(Icons.error_outline_rounded, size: 15, color: accentColor),
            const SizedBox(width: 8),
            Text(symptom,
                style: const TextStyle(color: Color(0xFF424242), fontSize: 13)),
          ],
        ),
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  final String label;
  final Color color;
  final Color textColor;

  const _TagChip({
    required this.label,
    required this.color,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
          color: color, borderRadius: BorderRadius.circular(8)),
      child: Text(label,
          style: TextStyle(
              color: textColor, fontSize: 12.5, fontWeight: FontWeight.w500)),
    );
  }
}

class _TimelineRow extends StatelessWidget {
  final Color dot;
  final String title;
  final String subtitle;

  const _TimelineRow({
    required this.dot,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 4),
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: dot, shape: BoxShape.circle),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    color: Color(0xFF111111),
                    fontSize: 13,
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 2),
            Text(subtitle,
                style: const TextStyle(color: Color(0xFF757575), fontSize: 12)),
          ],
        ),
      ],
    );
  }
}