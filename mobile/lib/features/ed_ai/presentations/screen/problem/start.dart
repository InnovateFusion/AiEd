import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/ed_ai/domains/entities/problem.dart';
import 'package:mobile/features/ed_ai/presentations/bloc/quiz/quiz_bloc.dart';
import 'package:mobile/features/ed_ai/presentations/bloc/timer/timer_bloc.dart';
import 'package:mobile/features/ed_ai/presentations/screen/onboarding/bubble.dart';
import 'package:mobile/features/ed_ai/presentations/screen/problem/question.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../../bloc/problem/problem_bloc.dart';
import '../../widget/timer/circular_timer.dart';

class QuizStarter extends StatefulWidget {
  const QuizStarter({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QuizStarterState();
}

class _QuizStarterState extends State<QuizStarter> {
  @override
  void initState() {
    super.initState();
  }

  List<Problem> problems = [];
  QuizState quizState = QuizState();
  int duration = 60;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: AdaptiveTheme.of(context).mode.isDark
          ? Brightness.light
          : Brightness.dark,
    ));

    void onReadyQuiz(List<Problem> problems, QuizMode mode) {
      context.read<QuizBloc>().add(TakeQuiz(problems: problems, mode: mode));
    }

    void onStartQuiz(QuizState state) {
      context.read<TimerBloc>().add(TimerStarted(duration: state.duration));

      PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
        context,
        settings: const RouteSettings(name: '/problem/question'),
        screen: const Question(),
        withNavBar: false,
        pageTransitionAnimation: PageTransitionAnimation.cupertino,
      );
    }

    void onContinueQuiz(QuizState state) {
      PersistentNavBarNavigator.pushNewScreenWithRouteSettings(
        context,
        settings: const RouteSettings(name: '/problem/question'),
        screen: const Question(),
        withNavBar: false,
        pageTransitionAnimation: PageTransitionAnimation.cupertino,
      );
    }

    return BlocListener<ProblemBloc, ProblemState>(
      listener: (contextY, stateY) {
        if (stateY.problems.isNotEmpty) {
          problems = stateY.problems;
        }
      },
      child: Scaffold(
          body: BlocListener<QuizBloc, QuizState>(
        listener: (context, state) {
          if (state.progress == QuizProgress.ready) {
            if (duration != state.duration) {
              setState(() {
                duration = state.duration;
              });
            }
            quizState = state;
            onStartQuiz(state);
          }
        },
        child: BlocListener<TimerBloc, TimerState>(
          listener: (contextX, stateX) {
            if (stateX.status == TimerStatus.finished) {
              print('finished');
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AdaptiveTheme.of(context).mode.isDark
                  ? const Color.fromRGBO(28, 27, 32, 1)
                  : const Color.fromRGBO(244, 247, 252, 1),
            ),
            child: SafeArea(
              child: Center(
                child: Stack(fit: StackFit.passthrough, children: [
                  const BubbleScreen(
                      numberOfBubbles: 4,
                      maxBubbleSize: 90,
                      color: Color.fromRGBO(107, 87, 146, 0.047)),
                  if (quizState.progress == QuizProgress.ready)
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularTimerWidget(second: duration),
                          const SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  onContinueQuiz(quizState);
                                },
                                child: Text(
                                  'Continue',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                    color: AdaptiveTheme.of(context).mode.isDark
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  if (quizState.progress == QuizProgress.notReady)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'What kind of quiz mode do you want to play?',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AdaptiveTheme.of(context).mode.isDark
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
                              onReadyQuiz(problems, QuizMode.learning);
                            },
                            child: Text(
                              'Learning',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: AdaptiveTheme.of(context).mode.isDark
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
                              onReadyQuiz(problems, QuizMode.marathon);
                            },
                            child: Text(
                              'Marathon',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: AdaptiveTheme.of(context).mode.isDark
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
                              onReadyQuiz(problems, QuizMode.killAndPass);
                            },
                            child: Text(
                              'Kill and Pass',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: AdaptiveTheme.of(context).mode.isDark
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ]),
              ),
            ),
          ),
        ),
      )),
    );
  }
}
