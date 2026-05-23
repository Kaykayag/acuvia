import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  // ── Colors ──────────────────────────────────────────────────────────────
  static const Color _bgColor      = Colors.white;
  static const Color _primaryColor = Color(0xFF1A7A9B);
  static const Color _bubbleBg     = Color(0xFFEAEAF5);
  static const Color _textDark     = Color(0xFF1A1A2E);
  static const Color _textSub      = Color(0xFF5A6A72);
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
      backgroundColor: _bgColor,
      bottomNavigationBar: _buildBottomNav(),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Top bar: logo + welcome ──────────────────────────────────
            _buildTopBar(),

            // ── Scrollable content ───────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),

                    // ── Illustration ─────────────────────────────────────
                    _buildIllustration(),

                    // ── Headline + subtitle ──────────────────────────────
                    Padding(
                      padding: const EdgeInsets.fromLTRB(28, 24, 28, 0),
                      child: _buildHeadline(),
                    ),

                    // ── Buttons ──────────────────────────────────────────
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
                      child: _buildButtons(context),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Top bar ───────────────────────────────────────────────────────────────
  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Logo
          Image.asset(
            'assets/acuvia_logo.png',
            height: 36,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 10),

          // Welcome text
          const Text(
            'Welcome, John!',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: _primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  // ── Illustration ──────────────────────────────────────────────────────────
  Widget _buildIllustration() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final circleSize = width * 0.70;
        final figureHeight = circleSize * 1.12;

        return SizedBox(
          height: circleSize + 16,
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              // Lavender circle
              Center(
                child: Container(
                  width: circleSize,
                  height: circleSize,
                  decoration: const BoxDecoration(
                    color: _bubbleBg,
                    shape: BoxShape.circle,
                  ),
                ),
              ),

              // Guy holding phone
              Positioned(
                bottom: 0,
                child: Image.asset(
                  'assets/guy on phone.png',
                  height: figureHeight,
                  fit: BoxFit.contain,
                ),
              ),

              // Heart bubble — top right, overlapping shoulder
              
            ],
          ),
        );
      },
    );
  }

  // ── Headline + subtitle ───────────────────────────────────────────────────
  Widget _buildHeadline() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'How are you\nfeeling today?',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w800,
            color: _textDark,
            height: 1.2,
          ),
        ),
        SizedBox(height: 12),
        Text(
          "Answer a few simple questions about your symptoms and we'll assess the urgency.",
          style: TextStyle(
            fontSize: 14,
            color: _textSub,
            height: 1.55,
          ),
        ),
      ],
    );
  }

  // ── Two CTA buttons ───────────────────────────────────────────────────────
  Widget _buildButtons(BuildContext context) {
    return Column(
      children: [
        // Start Assessment
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: () {
              context.go('/assessment');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32),
              ),
              elevation: 0,
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Start Assessment',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.chevron_right_rounded, size: 22),
              ],
            ),
          ),
        ),

        const SizedBox(height: 14),

        // Acuvia Assistant
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: () {
              // TODO: context.go('/assistant');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32),
              ),
              elevation: 0,
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Acuvia Assistant',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.chevron_right_rounded, size: 22),
              ],
            ),
          ),
        ),
      ],
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
            children: List.generate(_navItems.length, (index) {
              final item = _navItems[index];
              final isActive = _currentIndex == index;

              return GestureDetector(
                onTap: () {
                  setState(() => _currentIndex = index);
                  switch (index) {
                    case 0: context.go('/home'); break;
                    case 1: context.go('/history'); break;
                    case 2: context.go('/learn'); break; // TODO: implement learn route
                    case 3: context.go('/profile'); break; // TODO: implement profile route
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
                      // Label — shown in screenshot so keeping it small
                      Text(
                        item.label,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: isActive
                              ? FontWeight.w700
                              : FontWeight.w400,
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

// ── Nav item model ────────────────────────────────────────────────────────────
class _NavItem {
  final String label;
  final String asset;
  const _NavItem({required this.label, required this.asset});
}