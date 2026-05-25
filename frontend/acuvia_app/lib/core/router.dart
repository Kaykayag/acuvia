import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../auth/login_screen.dart';
import '../auth/register_screen.dart';
import '../auth/forgot_password_screen.dart';
import '../features/home/home_screen.dart';
import '../features/assessment/start_assessment_screen.dart';
import '../features/assessment/ai_analysis_screen.dart';
import '../features/chatbot/chatbot_screen.dart';
import '../features/history/history_screen.dart';
import '../features/learn/learn_screen.dart';
import '../features/learn/learn_detail_screen.dart';
import '../features/locator/hospital_locator_screen.dart';
import '../features/profile/profile_screen.dart';
import '../features/splash/splash_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/assessment',
      builder: (context, state) => const StartAssessmentScreen(),
      routes: [
        GoRoute(
          path: 'analysis',
          builder: (context, state) {
            final data = state.extra as Map<String, dynamic>;
            return AiAnalysisScreen(
              symptoms: List<String>.from(data['symptoms'] ?? []),
              age: data['age'] as int,
              sex: data['sex'] as String,
              freeText: data['free_text'] as String? ?? '',
              conditions: List<String>.from(data['conditions'] ?? []),
            );
          },
        ),
      ],
    ),
    GoRoute(
      path: '/chatbot',
      builder: (context, state) => const ChatbotScreen(),
    ),
    GoRoute(
      path: '/history',
      builder: (context, state) => const HistoryScreen(),
    ),
    GoRoute(
      path: '/learn',
      builder: (context, state) => const LearnScreen(),
      routes: [
        GoRoute(
          path: 'detail',
          builder: (context, state) {
            final data = state.extra;
            if (data is Map<String, dynamic>) {
              return LearnDetailScreen(
                subItem: data['subItem'],
                accentColor: data['accentColor'],
                categoryTitle: data['categoryTitle'] ?? '',
              );
            }
            return const LearnScreen();
          },
        ),
      ],
    ),
    GoRoute(
      path: '/locator',
      builder: (context, state) => const HospitalLocatorScreen(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
    GoRoute(
      path: '/login',
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const LoginScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
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
