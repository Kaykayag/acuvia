import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class StartAssessmentScreen extends StatefulWidget {
  const StartAssessmentScreen({super.key});

  @override
  State<StartAssessmentScreen> createState() => _StartAssessmentScreenState();
}

class _StartAssessmentScreenState extends State<StartAssessmentScreen> {
  // ── Colors ─────────────────────────────────────────────────────────────
  static const Color _bgColor      = Colors.white;
  static const Color _primaryColor = Color(0xFF1A7A9B);
  static const Color _textDark     = Color(0xFF1A1A2E);
  static const Color _textSub      = Color(0xFF7A8A92);
  static const Color _checkboxBg   = Color(0xFFDDDDDD);
  static const Color _progressBg   = Color(0xFFDDDDDD);
  static const Color _rowDivider   = Color(0xFFF0F0F0);

  final TextEditingController _othersController = TextEditingController();

  bool get _othersSelected =>
      _symptoms.isNotEmpty && _symptoms.last.selected;

  final List<_Symptom> _symptoms = [
    _Symptom(label: 'Fever',               asset: 'assets/temperature 1.png'),
    _Symptom(label: 'Severe Headache',     asset: 'assets/headache 1.png'),
    _Symptom(label: 'Chest Pains',         asset: 'assets/heart 1.png'),
    _Symptom(label: 'Shortness of Breath', asset: 'assets/lungs 1.png'),
    _Symptom(label: 'Nausea or Vomiting',  asset: 'assets/nausea 1.png'),
    _Symptom(label: 'Dizziness',           asset: 'assets/dizziness 1.png'),
    _Symptom(label: 'Others',              asset: 'assets/other.png'),
  ];

  @override
  void dispose() {
    _othersController.dispose();
    super.dispose();
  }

  // ── Submit ────────────────────────────────────────────────────────────────
  void _handleSubmit() {
    // Collect checked symptoms, skip the 'Others' label itself
    final selected = _symptoms
        .where((s) => s.selected && s.label != 'Others')
        .map((s) => s.label)
        .toList();

    // If 'Others' is checked and user typed something, include that text
    final othersText = _othersController.text.trim();
    if (_othersSelected && othersText.isNotEmpty) {
      selected.add(othersText);
    }

    if (selected.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select at least one symptom'),
        ),
      );
      return;
    }

    // Navigate to AI analysis screen — passes symptoms to MedGemma
    context.go('/assessment/analysis', extra: {
      'symptoms':   selected,
      'age':        0,           // not collected on this screen
      'sex':        'Unknown',   // not collected on this screen
      'free_text':  othersText,
      'conditions': <String>[],
    });
  }

  // ── Build ─────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ───────────────────────────────────────────────────
            _buildHeader(context),

            // ── Progress ─────────────────────────────────────────────────
            _buildProgressBar(),
            const SizedBox(height: 20),

            // ── Subtitle ─────────────────────────────────────────────────
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Please choose all that apply',
                style: TextStyle(fontSize: 13, color: _textSub),
              ),
            ),
            const SizedBox(height: 10),

            // ── Symptom list ─────────────────────────────────────────────
            Expanded(
              child: ListView.separated(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                itemCount: _symptoms.length,
                separatorBuilder: (_, _) => const Divider(
                  color: _rowDivider,
                  height: 1,
                  thickness: 1,
                ),
                itemBuilder: (_, index) =>
                    _buildSymptomRow(_symptoms[index]),
              ),
            ),

            // ── Describe panel — only when Others is checked ──────────────
            AnimatedSize(
              duration: const Duration(milliseconds: 260),
              curve: Curves.easeInOut,
              child: _othersSelected
                  ? _buildDescribePanel()
                  : const SizedBox.shrink(),
            ),

            // ── Submit button ─────────────────────────────────────────────
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  // ── Header ────────────────────────────────────────────────────────────────
  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 24, 8),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => context.go('/home'),
            child:
                const Icon(Icons.arrow_back, size: 24, color: _textDark),
          ),
          const Expanded(
            child: Text(
              'Select your symptoms',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: _textDark,
              ),
            ),
          ),
          const SizedBox(width: 24),
        ],
      ),
    );
  }

  // ── Progress bar ──────────────────────────────────────────────────────────
  Widget _buildProgressBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const Text(
            'Step 1 of 2',
            style: TextStyle(
              fontSize: 12,
              color: _textSub,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: 0.5,
              minHeight: 6,
              backgroundColor: _progressBg,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(_primaryColor),
            ),
          ),
        ],
      ),
    );
  }

  // ── Symptom row ───────────────────────────────────────────────────────────
  Widget _buildSymptomRow(_Symptom symptom) {
    return InkWell(
      onTap: () => setState(() => symptom.selected = !symptom.selected),
      splashColor: _primaryColor.withValues(alpha: 0.08),
      highlightColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            // Icon
            SizedBox(
              width: 36,
              height: 36,
              child: Image.asset(symptom.asset, fit: BoxFit.contain),
            ),
            const SizedBox(width: 16),

            // Label
            Expanded(
              child: Text(
                symptom.label,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: _textDark,
                ),
              ),
            ),

            // Checkbox
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                color: symptom.selected ? _primaryColor : _checkboxBg,
                borderRadius: BorderRadius.circular(5),
              ),
              child: symptom.selected
                  ? const Icon(Icons.check, color: Colors.white, size: 15)
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  // ── Describe your symptoms panel ──────────────────────────────────────────
  Widget _buildDescribePanel() {
    return Container(
      width: double.infinity,
      color: _bgColor,
      padding: const EdgeInsets.fromLTRB(24, 8, 24, 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Describe your symptoms',
                  style: TextStyle(
                    fontSize: 12,
                    color: _textSub,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                TextField(
                  controller: _othersController,
                  style: const TextStyle(
                    fontSize: 13,
                    color: _textDark,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'e.g. Persistent cough and a sore throat',
                    hintStyle: TextStyle(
                      fontSize: 13,
                      color: Color(0xFFAAAAAA),
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xFFCCCCCC), width: 1),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: _primaryColor, width: 1.5),
                    ),
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 8),
                  ),
                  maxLines: 1,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => FocusScope.of(context).unfocus(),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),

          // Send icon — dismisses keyboard
          GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: const Icon(
              Icons.send_rounded,
              size: 22,
              color: _primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  // ── Submit button ─────────────────────────────────────────────────────────
  Widget _buildSubmitButton() {
    final hasSelection = _symptoms.any((s) => s.selected);

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
      child: SizedBox(
        width: double.infinity,
        height: 54,
        child: ElevatedButton(
          onPressed: _handleSubmit,
          style: ElevatedButton.styleFrom(
            backgroundColor: hasSelection
                ? _primaryColor
                : _primaryColor.withValues(alpha: 0.4),
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
                'Submit Symptoms',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3,
                ),
              ),
              SizedBox(width: 10),
              Icon(Icons.chevron_right_rounded, size: 22),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Symptom model ─────────────────────────────────────────────────────────────
class _Symptom {
  final String label;
  final String asset;
  bool selected;

  _Symptom({
    required this.label,
    required this.asset,
  }) : selected = false;
}