// lib/features/splash/splash_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {

  late final AnimationController _logoCtrl;
  late final AnimationController _nameCtrl;
  late final AnimationController _tagInCtrl;
  late final AnimationController _tagOutCtrl;
  late final AnimationController _logoUpCtrl;
  late final AnimationController _screenFadeCtrl;

  // Logo in
  late final Animation<double> _logoFade;
  late final Animation<double> _logoScale;

  // Name in
  late final Animation<double> _nameFade;
  late final Animation<double> _nameSlideX;

  // Tagline in
  late final Animation<double> _tagFade;
  late final Animation<double> _tagSlideY;

  // Tagline out
  late final Animation<double> _tagOutFade;
  late final Animation<double> _tagOutSlideY;

  // Logo up + fade out
  late final Animation<double> _logoMoveY;
  late final Animation<double> _logoAndNameFadeOut;

  // Screen fade out
  late final Animation<double> _screenFade;

  bool _showName = false;
  bool _showTag  = false;
  bool _tagOut   = false;
  bool _logoUp   = false;
  bool _fadingOut = false;

  @override
  void initState() {
    super.initState();

    _logoCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    _logoFade  = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _logoCtrl, curve: Curves.easeIn));
    _logoScale = Tween<double>(begin: 0.3, end: 1).animate(CurvedAnimation(parent: _logoCtrl, curve: Curves.elasticOut));

    _nameCtrl  = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _nameFade  = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _nameCtrl, curve: Curves.easeIn));
    _nameSlideX = Tween<double>(begin: 40, end: 0).animate(CurvedAnimation(parent: _nameCtrl, curve: Curves.easeOut));

    _tagInCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _tagFade   = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _tagInCtrl, curve: Curves.easeIn));
    _tagSlideY = Tween<double>(begin: 20, end: 0).animate(CurvedAnimation(parent: _tagInCtrl, curve: Curves.easeOut));

    _tagOutCtrl   = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _tagOutFade   = Tween<double>(begin: 1, end: 0).animate(CurvedAnimation(parent: _tagOutCtrl, curve: Curves.easeIn));
    _tagOutSlideY = Tween<double>(begin: 0, end: 24).animate(CurvedAnimation(parent: _tagOutCtrl, curve: Curves.easeIn));

    // Logo moves up AND fades out simultaneously
    _logoUpCtrl          = AnimationController(vsync: this, duration: const Duration(milliseconds: 650));
    _logoMoveY           = Tween<double>(begin: 0, end: -280).animate(CurvedAnimation(parent: _logoUpCtrl, curve: Curves.easeInBack));
    _logoAndNameFadeOut  = Tween<double>(begin: 1, end: 0).animate(CurvedAnimation(parent: _logoUpCtrl, curve: Curves.easeIn));

    // Screen fade to white before navigate
    _screenFadeCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 350));
    _screenFade     = Tween<double>(begin: 1, end: 0).animate(CurvedAnimation(parent: _screenFadeCtrl, curve: Curves.easeIn));

    _runSequence();
  }

  Future<void> _runSequence() async {
    // 1. Logo pops in
    await Future.delayed(const Duration(milliseconds: 400));
    await _logoCtrl.forward();

    // 2. "ACUVIA" slides in
    await Future.delayed(const Duration(milliseconds: 200));
    if (!mounted) return;
    setState(() => _showName = true);
    await _nameCtrl.forward();

    // 3. Tagline slides up
    await Future.delayed(const Duration(milliseconds: 350));
    if (!mounted) return;
    setState(() => _showTag = true);
    await _tagInCtrl.forward();

    // 4. Tagline slides back out
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    setState(() => _tagOut = true);
    await _tagOutCtrl.forward();
    if (!mounted) return;
    setState(() => _showTag = false);

    // 5. Logo + name move up AND fade out together
    await Future.delayed(const Duration(milliseconds: 150));
    if (!mounted) return;
    setState(() => _logoUp = true);
    await _logoUpCtrl.forward();

    // 6. Screen fades to white
    if (!mounted) return;
    setState(() => _fadingOut = true);
    await _screenFadeCtrl.forward();

    // 7. Navigate
    await Future.delayed(const Duration(milliseconds: 100));
    if (mounted) context.go('/login');
  }

  @override
  void dispose() {
    _logoCtrl.dispose();
    _nameCtrl.dispose();
    _tagInCtrl.dispose();
    _tagOutCtrl.dispose();
    _logoUpCtrl.dispose();
    _screenFadeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AnimatedBuilder(
        animation: Listenable.merge([
          _logoCtrl, _nameCtrl, _tagInCtrl,
          _tagOutCtrl, _logoUpCtrl, _screenFadeCtrl,
        ]),
        builder: (context, _) {
          return Opacity(
            opacity: _fadingOut ? _screenFade.value : 1.0,
            child: SizedBox.expand(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  // ── Logo + ACUVIA block ─────────────────────────────────
                  Opacity(
                    opacity: _logoUp
                        ? _logoAndNameFadeOut.value
                        : 1.0,
                    child: Transform.translate(
                      offset: Offset(0, _logoUp ? _logoMoveY.value : 0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [

                          // Logo
                          Opacity(
                            opacity: _logoFade.value,
                            child: Transform.scale(
                              scale: _logoScale.value,
                              child: Image.asset(
                                'assets/acuvia_logo.png',
                                width: 130,
                                height: 130,
                                fit: BoxFit.contain,
                                errorBuilder: (_, _, _) => _FallbackLogo(),
                              ),
                            ),
                          ),

                          const SizedBox(height: 10), // ← tighter gap

                          // "ACUVIA" text
                          if (_showName)
                            Opacity(
                              opacity: _nameFade.value,
                              child: Transform.translate(
                                offset: Offset(_nameSlideX.value, 0),
                                child: ShaderMask(
                                  shaderCallback: (bounds) =>
                                      const LinearGradient(
                                    colors: [
                                      Color(0xFF1A7A9B),
                                      Color(0xFF26A69A),
                                    ],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ).createShader(bounds),
                                  child: const Text(
                                    'ACUVIA',
                                    style: TextStyle(
                                      fontSize: 42,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                      letterSpacing: 8,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          else
                            const SizedBox(height: 50),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20), // ← tagline sits close below

                  // ── Tagline ─────────────────────────────────────────────
                  if (_showTag)
                    Opacity(
                      opacity: _tagOut ? _tagOutFade.value : _tagFade.value,
                      child: Transform.translate(
                        offset: Offset(
                          0,
                          _tagOut ? _tagOutSlideY.value : _tagSlideY.value,
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 40),
                          child: Text(
                            'Know what matters. Act on time.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF5A6A72),
                              fontStyle: FontStyle.italic,
                              letterSpacing: 0.3,
                              height: 1.6,
                            ),
                          ),
                        ),
                      ),
                    )
                  else
                    const SizedBox(height: 22),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// ── Fallback logo ──────────────────────────────────────────────────────────────
class _FallbackLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      height: 130,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1A7A9B), Color(0xFF26A69A)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
      ),
      child: const Center(
        child: Text('A',
            style: TextStyle(
                fontSize: 64,
                fontWeight: FontWeight.w800,
                color: Colors.white)),
      ),
    );
  }
}