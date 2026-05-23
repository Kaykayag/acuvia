import 'package:go_router/go_router.dart';
import '../auth/login_screen.dart';
import '../features/home/home_screen.dart';
import '../auth/register_screen.dart';
import '../auth/forgot_password_screen.dart';
import '../features/assessment/start_assessment_screen.dart';
import '../features/history/history_screen.dart'; 
import '/features/learn/learn_screen.dart';
import '/features/profile/profile_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/home',
  routes: [
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/assessment',
      builder: (context, state) => const StartAssessmentScreen(),
    ),
    GoRoute(
      path: '/history',
      builder: (context, state) => const HistoryScreen(), // add this
    ),
    GoRoute(
      path: '/learn',
      builder: (context, state) => const LearnScreen(),
      routes: [
        // 2. Added as a child route. The full path becomes '/learn/detail'
        GoRoute(
          path: 'detail', 
          builder: (context, state) {
            // If your LearnDetailScreen takes a custom data object, you can pass it via extra:
            // final sectionData = state.extra as LearnSection;
            // return LearnDetailScreen(data: sectionData);
            
            return const LearnScreen();
          },
        ),
      ],
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
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