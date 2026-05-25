// lib/features/learn/presentation/screens/learn_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'learn_data.dart';
import 'learn_detail_screen.dart';

class LearnScreen extends StatefulWidget {
  const LearnScreen({super.key});

  static const List<_NavItem> _navItems = [
    _NavItem(label: 'Home', asset: 'assets/Home.png'),
    _NavItem(label: 'History', asset: 'assets/Clipboard.png'),
    _NavItem(label: 'Learn', asset: 'assets/Book open.png'),
    _NavItem(label: 'Profile', asset: 'assets/person.png'),
  ];

  @override
  State<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends State<LearnScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  int? _expandedIndex;
  int _currentIndex = 2; // default to Learn

  // Colors used by bottom nav (copied from HomeScreen)
  static const Color _bgColor = Colors.white;
  static const Color _primaryColor = Color(0xFF1A7A9B);
  static const Color _navInactive = Color(0xFFB0BEC5);

  List<LearnCategory> get _filtered {
    final q = _searchQuery.toLowerCase();
    if (q.isEmpty) return LearnData.categories;
    return LearnData.categories
        .where((c) =>
            c.title.toLowerCase().contains(q) ||
            c.subtitle.toLowerCase().contains(q) ||
            c.subItems.any((s) => s.title.toLowerCase().contains(q)))
        .toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: _buildBottomNav(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildSearchBar(),
            Expanded(child: _buildList()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Health Resources',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 2),
          Text(
            'Educational content & guides',
            style: TextStyle(fontSize: 13, color: Colors.black45),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
      child: TextField(
        controller: _searchController,
        onChanged: (v) => setState(() {
          _searchQuery = v;
          _expandedIndex = null;
        }),
        decoration: InputDecoration(
          hintText: 'Search resources...',
          hintStyle: const TextStyle(color: Colors.black38, fontSize: 14),
          prefixIcon: const Icon(Icons.search, color: Colors.black38, size: 20),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.close, size: 18, color: Colors.black38),
                  onPressed: () {
                    _searchController.clear();
                    setState(() => _searchQuery = '');
                  },
                )
              : null,
          filled: true,
          fillColor: const Color(0xFFF3F4F6),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildList() {
    final items = _filtered;
    if (items.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 48, color: Colors.black26),
            SizedBox(height: 12),
            Text('No resources found',
                style: TextStyle(color: Colors.black45, fontSize: 15)),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final cat = items[index];
        final isExpanded = _expandedIndex == index;
        return _CategoryCard(
          key: ValueKey(cat.title),
          category: cat,
          isExpanded: isExpanded,
          onHeaderTap: () =>
              setState(() => _expandedIndex = isExpanded ? null : index),
          onSubItemTap: (sub) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => LearnDetailScreen(
                  subItem: sub,
                  accentColor: cat.color,
                  categoryTitle: cat.title,
                ),
              ),
            );
          },
        );
      },
    );
  }
  
  // ── Bottom nav — icons only, no labels ───────────────────────────────────
  Widget _buildBottomNav() {
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
            children: List.generate(LearnScreen._navItems.length, (index) {
              final item = LearnScreen._navItems[index];
              final isActive = _currentIndex == index;

              return GestureDetector(
                onTap: () {
                  setState(() => _currentIndex = index);
                  switch (index) {
                    case 0:
                      context.go('/home');
                      break;
                    case 1:
                      context.go('/history');
                      break;
                    case 2:
                      context.go('/learn');
                      break;
                    case 3:
                      context.go('/profile');
                      break;
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


// ─── Category card with animated expand ──────────────────────────────────────

class _CategoryCard extends StatelessWidget {
  final LearnCategory category;
  final bool isExpanded;
  final VoidCallback onHeaderTap;
  final void Function(LearnSubItem) onSubItemTap;

  const _CategoryCard({
    super.key,
    required this.category,
    required this.isExpanded,
    required this.onHeaderTap,
    required this.onSubItemTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isExpanded
              ? category.color
              : category.color.withValues(alpha: 0.35),
          width: isExpanded ? 1.8 : 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: category.color.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Column(
          children: [
            // ── Header row ──
            InkWell(
              onTap: onHeaderTap,
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: category.color,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child:
                          Icon(category.icon, color: Colors.white, size: 22),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            category.title,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            category.subtitle,
                            style: const TextStyle(
                                fontSize: 12.5, color: Colors.black45),
                          ),
                        ],
                      ),
                    ),
                    AnimatedRotation(
                      turns: isExpanded ? 0.25 : 0,
                      duration: const Duration(milliseconds: 220),
                      child: const Icon(Icons.chevron_right,
                          color: Colors.black38, size: 22),
                    ),
                  ],
                ),
              ),
            ),

            // ── Sub-items (animated) ──
            AnimatedCrossFade(
              firstChild: const SizedBox.shrink(),
              secondChild: _buildSubItems(),
              crossFadeState: isExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 250),
              sizeCurve: Curves.easeInOut,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubItems() {
    return Column(
      children: [
        Divider(
            height: 1,
            thickness: 1,
            color: category.color.withValues(alpha: 0.2)),
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
          child: Column(
            children: List.generate(category.subItems.length, (i) {
              final sub = category.subItems[i];
              return Padding(
                padding: EdgeInsets.only(
                    bottom: i < category.subItems.length - 1 ? 8 : 0),
                child: _SubItemTile(
                  sub: sub,
                  color: category.color,
                  onTap: () => onSubItemTap(sub),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}

class _SubItemTile extends StatelessWidget {
  final LearnSubItem sub;
  final Color color;
  final VoidCallback onTap;

  const _SubItemTile({
    required this.sub,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color.withValues(alpha: 0.06),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        splashColor: color.withValues(alpha: 0.15),
        child: Container(
          padding:
              const EdgeInsets.symmetric(vertical: 11, horizontal: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border:
                Border.all(color: color.withValues(alpha: 0.18), width: 1),
          ),
          child: Row(
            children: [
              Icon(sub.icon, color: color, size: 18),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  sub.title,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ),
              Icon(Icons.chevron_right,
                  color: color.withValues(alpha: 0.7), size: 18),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Nav item model ────────────────────────────────────────────────────────────
class _NavItem {
  final String label;
  final String asset;
  const _NavItem({required this.label, required this.asset});
}