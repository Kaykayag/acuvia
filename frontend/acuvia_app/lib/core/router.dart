import 'package:go_router/go_router.dart';
import '../auth/login_screen.dart';
import '../auth/register_screen.dart';
import '../auth/forgot_password_screen.dart';
import '../features/home/home_screen.dart';
import '../features/assessment/start_assessment_screen.dart';
<<<<<<< HEAD
import '../features/assessment/ai_analysis_screen.dart';
import '../features/chatbot/chatbot_screen.dart';
import '../features/history/history_screen.dart';
import '../features/learn/learn_screen.dart';
import '../features/learn/learn_detail_screen.dart';
import '../features/locator/hospital_locator_screen.dart';
import '../features/profile/profile_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/login',
=======
import '../features/history/history_screen.dart'; 
import '/features/learn/learn_screen.dart';
import '/features/profile/profile_screen.dart';
import '../features/splash/splash_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/splash', //splash if final na 
>>>>>>> 4ae2460 (feat:added splash)
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),

    // ── Assessment flow ──────────────────────────────────────────────────────
    GoRoute(
      path: '/assessment',
      builder: (context, state) => const StartAssessmentScreen(),
      routes: [
        GoRoute(
          path: 'analysis',  // full path: /assessment/analysis
          builder: (context, state) {
            // Receives the patient data passed via extra from symptom input screen
            final data = state.extra as Map<String, dynamic>;
            return AiAnalysisScreen(
              symptoms:   List<String>.from(data['symptoms'] ?? []),
              age:        data['age'] as int,
              sex:        data['sex'] as String,
              freeText:   data['free_text'] as String? ?? '',
              conditions: List<String>.from(data['conditions'] ?? []),
            );
          },
        ),
      ],
    ),

    // ── Chatbot ──────────────────────────────────────────────────────────────
    GoRoute(
      path: '/chatbot',
      builder: (context, state) => const ChatbotScreen(),
    ),

    // ── History ──────────────────────────────────────────────────────────────
    GoRoute(
      path: '/history',
<<<<<<< HEAD
      builder: (context, state) => const HistoryScreen(),
=======
      builder: (context, state) => const HistoryScreen(), 
>>>>>>> 4ae2460 (feat:added splash)
    ),

    // ── Learn ────────────────────────────────────────────────────────────────
    GoRoute(
      path: '/learn',
      builder: (context, state) => const LearnScreen(),
      routes: [
        GoRoute(
          path: '/detail',   // full path: /learn/detail
          builder: (context, state) {
            final data = state.extra;
            if (data is Map<String, dynamic>) {
              return LearnDetailScreen(
                subItem: data['subItem'],
                accentColor: data['accentColor'],
                categoryTitle: data['categoryTitle'] ?? '',
              );
            }
            // Fallback to the main Learn screen if no detail data provided
            return const LearnScreen();
          },
        ),
      ],
    ),

    // ── Hospital locator ─────────────────────────────────────────────────────
    GoRoute(
      path: '/locator',
      builder: (context, state) => const HospitalLocatorScreen(),
    ),

    // ── Profile ──────────────────────────────────────────────────────────────
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),

    // ── Auth ─────────────────────────────────────────────────────────────────
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/forgot-password',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
  ],
);