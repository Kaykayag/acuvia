import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/providers/triage_provider.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Priority config helper
// ─────────────────────────────────────────────────────────────────────────────
class _PriorityStyle {
  final Color background;
  final Color border;
  final Color text;
  final IconData icon;
  final String defaultTagline;

  const _PriorityStyle({
    required this.background,
    required this.border,
    required this.text,
    required this.icon,
    required this.defaultTagline,
  });
}

_PriorityStyle _styleFor(String? priority) {
  switch (priority) {
    case 'Emergency':
      return const _PriorityStyle(
        background: Color(0xFFFFF0F0),
        border:     Color(0xFFE53935),
        text:       Color(0xFFE53935),
        icon:       Icons.crisis_alert_rounded,
        defaultTagline: 'Call emergency services now!',
      );
    case 'Urgent':
      return const _PriorityStyle(
        background: Color(0xFFFFF8F0),
        border:     Color(0xFFF57C00),
        text:       Color(0xFFF57C00),
        icon:       Icons.warning_amber_rounded,
        defaultTagline: 'Seek medical care soon',
      );
    default:
      return const _PriorityStyle(
        background: Color(0xFFF0FFF4),
        border:     Color(0xFF43A047),
        text:       Color(0xFF43A047),
        icon:       Icons.check_circle_outline_rounded,
        defaultTagline: 'Monitor symptoms at home',
      );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Expandable card widget
// ─────────────────────────────────────────────────────────────────────────────
class _ExpandableCard extends StatefulWidget {
  final String title;
  final Widget child;

  const _ExpandableCard({required this.title, required this.child});

  @override
  State<_ExpandableCard> createState() => _ExpandableCardState();
}

class _ExpandableCardState extends State<_ExpandableCard>
    with SingleTickerProviderStateMixin {
  bool _expanded = true;
  late AnimationController _ctrl;
  late Animation<double> _rotation;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200));
    _rotation = Tween<double>(begin: 0, end: 0.5).animate(
        CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
    _ctrl.forward(); // starts expanded
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _expanded = !_expanded);
    _expanded ? _ctrl.forward() : _ctrl.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
            child: Text(widget.title,
                style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1A1A2E))),
          ),
          AnimatedCrossFade(
            firstChild: Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
              child: widget.child,
            ),
            secondChild: const SizedBox(width: double.infinity),
            crossFadeState: _expanded
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            duration: const Duration(milliseconds: 200),
          ),
          // Chevron
          GestureDetector(
            onTap: _toggle,
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 10),
              alignment: Alignment.center,
              child: RotationTransition(
                turns: _rotation,
                child: const Icon(Icons.keyboard_arrow_down_rounded,
                    color: Color(0xFF9E9E9E)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Main ResultScreen
// ─────────────────────────────────────────────────────────────────────────────
class ResultScreen extends ConsumerWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final result = ref.watch(triageResultProvider);

    if (result == null) {
      return const Scaffold(
        backgroundColor: Color(0xFFF5F6FA),
        body: Center(child: Text('No result available.')),
      );
    }

    final style = _styleFor(result.priority);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      // ── App bar ────────────────────────────────────────────────────────────
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1A1A2E)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Column(
          children: [
            Text('Results',
                style: TextStyle(
                    color: Color(0xFF1A1A2E),
                    fontSize: 17,
                    fontWeight: FontWeight.w700)),
            Text('Step 2 of 2',
                style: TextStyle(
                    color: Color(0xFF9E9E9E),
                    fontSize: 12,
                    fontWeight: FontWeight.w400)),
          ],
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Container(
              height: 4,
              // Full width green progress bar (step 2 of 2 = complete)
              decoration: const BoxDecoration(
                color: Color(0xFF26C6A6),
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(2),
                    bottomRight: Radius.circular(2)),
              ),
            ),
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Priority badge ──────────────────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
              decoration: BoxDecoration(
                color: style.background,
                border: Border.all(color: style.border, width: 1.5),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Icon(style.icon, color: style.text, size: 48),
                  const SizedBox(height: 10),
                  Text(
                    result.priority,
                    style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: style.text),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    result.tagline ?? style.defaultTagline,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: style.text.withValues(alpha: 0.85)),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── Symptoms / Reason card ──────────────────────────────────────
            if (result.reason != null)
              _ExpandableCard(
                title: 'Symptoms',
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    result.reason!,
                    style: const TextStyle(
                        fontSize: 14,
                        height: 1.55,
                        color: Color(0xFF424242)),
                  ),
                ),
              ),

            const SizedBox(height: 16),

            // ── Next steps card ─────────────────────────────────────────────
            if (result.nextSteps.isNotEmpty)
              _ExpandableCard(
                title: 'Next steps',
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: result.nextSteps
                        .map(
                          (step) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('· ',
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xFF424242),
                                        height: 1.4)),
                                Expanded(
                                  child: Text(
                                    step,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        height: 1.4,
                                        color: Color(0xFF424242)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
          ],
        ),
      ),

      // ── Bottom action buttons ─────────────────────────────────────────────
      bottomSheet: Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                // Find Hospital
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () =>
                        Navigator.pushNamed(context, '/locator'),
                    icon: const Icon(Icons.location_on_outlined, size: 18),
                    label: const Text('Find Hospital'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF26C6A6),
                      side: const BorderSide(color: Color(0xFF26C6A6)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Save Report
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // TODO: implement save/export report
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Report saved!')),
                      );
                    },
                    icon: const Icon(Icons.save_alt_outlined, size: 18),
                    label: const Text('Save Report'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF26C6A6),
                      side: const BorderSide(color: Color(0xFF26C6A6)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text(
              'For guidance only · not a diagnosis',
              style: TextStyle(fontSize: 11, color: Color(0xFFBDBDBD)),
            ),
          ],
        ),
      ),
    );
  }
}