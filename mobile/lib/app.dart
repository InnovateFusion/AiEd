import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/core/utils/ticker.dart';
import 'package:mobile/features/ed_ai/presentations/bloc/problem/problem_bloc.dart';
import 'package:mobile/features/ed_ai/presentations/bloc/quiz/quiz_bloc.dart';
import 'package:mobile/features/ed_ai/presentations/bloc/scroll/scroll_bloc.dart';
import 'package:mobile/features/ed_ai/presentations/bloc/timer/timer_bloc.dart';
import 'package:mobile/features/ed_ai/presentations/screen/contest/info.dart';
import 'package:mobile/features/ed_ai/presentations/screen/contest/standing.dart';
import 'package:mobile/features/ed_ai/presentations/screen/layout.dart';
import 'package:mobile/features/ed_ai/presentations/screen/login/layout.dart';
import 'package:mobile/features/ed_ai/presentations/screen/onboarding/layout.dart';
import 'package:mobile/injection_container.dart';

class MyApp extends StatelessWidget {
  final AdaptiveThemeMode? savedThemeMode;

  const MyApp({super.key, this.savedThemeMode});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => QuizBloc(),
        ),
       
         BlocProvider(
          create: (context) => ScrollBloc(),
        ),
        BlocProvider(
          create: (context) => sl<ProblemBloc>(),
        ),
        BlocProvider(
          create: (context) => TimerBloc(ticker: const Ticker()),
        ),
      ],
      child: AdaptiveTheme(
        light: ThemeData(
          useMaterial3: true,
          brightness: Brightness.light,
        ),
        dark: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
        ),
        initial: savedThemeMode ?? AdaptiveThemeMode.light,
        builder: (theme, darkTheme) => MaterialApp(
          theme: theme,
          darkTheme: darkTheme,
          home: const OnboardingLayout(),
          debugShowCheckedModeBanner: false,
          routes: {
            '/onboarding': (context) => const OnboardingLayout(),
            '/EntranceLayout': (context) => const EntranceLayout(),
            '/home': (context) => const Layout(),
            '/contest/contest-info': (context) => const ContestInfo(),
            '/contest/standing': (context) => const ContestStanding(),
          },
        ),
      ),
    );
  }
}
