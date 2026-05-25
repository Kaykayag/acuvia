import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/providers/triage_provider.dart';
import '../../../data/models/triage.dart';
import 'package:go_router/go_router.dart'; 

// ─────────────────────────────────────────────────────────────────────────────
// Priority style helper
// ─────────────────────────────────────────────────────────────────────────────
class _PriorityStyle {
  final Color background;
  final Color border;
  final Color text;
  final String assetPath;
  final String defaultTagline;

  const _PriorityStyle({
    required this.background,
    required this.border,
    required this.text,
    required this.assetPath,
    required this.defaultTagline,
  });
}

_PriorityStyle _styleFor(String? priority) {
  switch (priority) {
    case 'Emergency':
      return const _PriorityStyle(
        background:     Color(0xFFFFF0F0),
        border:         Color(0xFFE53935),
        text:           Color(0xFFE53935),
        assetPath:      'assets/alert 1.png',
        defaultTagline: 'Call emergency services now!',
      );
    case 'Urgent':
      return const _PriorityStyle(
        background:     Color(0xFFFFF8F0),
        border:         Color(0xFFF57C00),
        text:           Color(0xFFF57C00),
        assetPath:      'assets/danger.png',
        defaultTagline: 'Seek medical care soon',
      );
    default:
      return const _PriorityStyle(
        background:     Color(0xFFF0FFF4),
        border:         Color(0xFF43A047),
        text:           Color(0xFF43A047),
        assetPath:      'assets/Check circle.png',
        defaultTagline: 'Monitor symptoms at home',
      );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Expandable card
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
    _rotation = Tween<double>(begin: 0, end: 0.5)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
    _ctrl.forward();
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
            child: Text(
              widget.title,
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A2E)),
            ),
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
// Loading view — shown while MedGemma is processing
// ─────────────────────────────────────────────────────────────────────────────
class _LoadingView extends StatefulWidget {
  const _LoadingView();

  @override
  State<_LoadingView> createState() => _LoadingViewState();
}

class _LoadingViewState extends State<_LoadingView>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900))
      ..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _pulse,
              builder: (_, _) => Opacity(
                opacity: 0.35 + 0.65 * _pulse.value,
                child: const Icon(
                  Icons.medical_services_outlined,
                  size: 80,
                  color: Color(0xFF26C6A6),
                ),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Analysing your symptoms…',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A2E)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              'MedGemma AI is reviewing your case.\nThis may take a few seconds.',
              style: TextStyle(
                  fontSize: 14, color: Color(0xFF9E9E9E), height: 1.5),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 36),
            const SizedBox(
              width: 36,
              height: 36,
              child: CircularProgressIndicator(
                color: Color(0xFF26C6A6),
                strokeWidth: 3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Result view — shown after MedGemma responds
// ─────────────────────────────────────────────────────────────────────────────
class _ResultView extends StatelessWidget {
  final TriageResult result;

  const _ResultView({required this.result});

  @override
  Widget build(BuildContext context) {
    final style = _styleFor(result.priority);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Priority badge ────────────────────────────────────────────────
          Container(
            width: double.infinity,
            padding:
                const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
            decoration: BoxDecoration(
              color: style.background,
              border: Border.all(color: style.border, width: 1.5),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Image.asset(style.assetPath, width: 56, height: 56),
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

          // ── Symptoms / Reason card ────────────────────────────────────────
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

          // ── Next steps card ───────────────────────────────────────────────
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
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// AiAnalysisScreen — entry point (loading → result, same screen)
// ─────────────────────────────────────────────────────────────────────────────
class AiAnalysisScreen extends ConsumerStatefulWidget {
  final List<String> symptoms;
  final int age;
  final String sex;
  final String freeText;
  final List<String> conditions;

  const AiAnalysisScreen({
    super.key,
    required this.symptoms,
    required this.age,
    required this.sex,
    this.freeText = '',
    this.conditions = const [],
  });

  @override
  ConsumerState<AiAnalysisScreen> createState() => _AiAnalysisScreenState();
}

class _AiAnalysisScreenState extends ConsumerState<AiAnalysisScreen> {
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _runAnalysis();
  }

  Future<void> _runAnalysis() async {
    try {
      await ref.read(triageControllerProvider).submit(
            symptoms:   widget.symptoms,
            age:        widget.age,
            sex:        widget.sex,
            freeText:   widget.freeText,
            conditions: widget.conditions,
          );
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
      return;
    }
    // On success — switch to result view on the same screen
    if (mounted) setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    final result = ref.watch(triageResultProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),

      // ── App bar ────────────────────────────────────────────────────────────
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1A1A2E)),
          onPressed: () {
            ref.read(triageControllerProvider).clear();
            Navigator.pop(context);
          },
        ),
        title: Column(
          children: [
            const Text(
              'Results',
              style: TextStyle(
                  color: Color(0xFF1A1A2E),
                  fontSize: 17,
                  fontWeight: FontWeight.w700),
            ),
            Text(
              _loading ? 'Analysing…' : 'Step 2 of 2',
              style: const TextStyle(
                  color: Color(0xFF9E9E9E),
                  fontSize: 12,
                  fontWeight: FontWeight.w400),
            ),
          ],
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4),
          child: Stack(
            children: [
              // grey track
              Container(height: 4, color: const Color(0xFFE0E0E0)),
              // teal fill — full when done, half while loading
              AnimatedFractionallySizedBox(
                duration: const Duration(milliseconds: 400),
                widthFactor: _loading ? 0.5 : 1.0,
                child: Container(
                  height: 4,
                  decoration: const BoxDecoration(
                    color: Color(0xFF26C6A6),
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(2),
                        bottomRight: Radius.circular(2)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),

      // ── Body — switches between loading / error / result ───────────────────
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 400),
        child: _error != null
            ? _ErrorView(
                error: _error!,
                onRetry: () {
                  setState(() {
                    _error = null;
                    _loading = true;
                  });
                  _runAnalysis();
                },
              )
            : _loading
                ? const _LoadingView()
                : _ResultView(result: result!),
      ),

      // ── Bottom buttons — only shown when result is ready ───────────────────
      bottomSheet: _loading || _error != null
          ? null
          : Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () =>
                            context.push('/locator'),
                          icon: const Icon(Icons.location_on_outlined,
                              size: 18),
                          label: const Text('Find Hospital'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF26C6A6),
                            side: const BorderSide(
                                color: Color(0xFF26C6A6)),
                            padding: const EdgeInsets.symmetric(
                                vertical: 14),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(30)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            // TODO: implement PDF export / share sheet
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Report saved!')),
                            );
                          },
                          icon: const Icon(Icons.save_alt_outlined,
                              size: 18),
                          label: const Text('Save Report'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF26C6A6),
                            side: const BorderSide(
                                color: Color(0xFF26C6A6)),
                            padding: const EdgeInsets.symmetric(
                                vertical: 14),
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.circular(30)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'For guidance only · not a diagnosis',
                    style:
                        TextStyle(fontSize: 11, color: Color(0xFFBDBDBD)),
                  ),
                ],
              ),
            ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Error view
// ─────────────────────────────────────────────────────────────────────────────
class _ErrorView extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;

  const _ErrorView({required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline_rounded,
                size: 64, color: Color(0xFFE53935)),
            const SizedBox(height: 20),
            const Text(
              'Analysis failed',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1A1A2E)),
            ),
            const SizedBox(height: 10),
            Text(
              error,
              style: const TextStyle(
                  fontSize: 13, color: Color(0xFF9E9E9E), height: 1.5),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF26C6A6),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                    horizontal: 32, vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}