import 'dart:convert';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latext/latext.dart';
import 'package:mobile/features/ed_ai/domains/entities/submission.dart';
import 'package:mobile/features/ed_ai/presentations/bloc/quiz/quiz_bloc.dart';
import 'package:mobile/features/ed_ai/presentations/screen/problem/question_set.dart';
import 'package:mobile/features/ed_ai/presentations/screen/problem/textTimer.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../../../domains/entities/problem.dart';

class Question extends StatefulWidget {
  const Question({
    Key? key,
  }) : super(key: key);

  static const routeName = '/problem/question';

  @override
  State<Question> createState() => _QuestionState();
}

class _QuestionState extends State<Question> {
  _QuestionState();

  late final List<Problem> questions;
  int currentQuestion = 0;
  final ScrollController _scrollController = ScrollController();
  double scrollPosition = 0.0;
  final TextEditingController _textEditingController = TextEditingController();
  late final submissions = {};

  @override
  void initState() {
    super.initState();
    barColor();
    questions = context.read<QuizBloc>().state.problems.values.toList();
    context.read<QuizBloc>().state.submissions.forEach((key, value) {
      if (submissions.containsKey(key)) {
        if (context.read<QuizBloc>().state.mode == QuizMode.marathon) {
          submissions[key] = value;
        }
      } else {
        submissions[key] = value;
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  void barColor() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
      ),
    );
  }

  void onSelectedQuestion(int index) {
    if (index < 0 || index > questions.length - 1) {
      return;
    }

    setState(() {
      currentQuestion = index;
    });
  }

  Submission isAnswered() {
    final Problem problem = questions[currentQuestion];

    if (submissions.containsKey(problem.id)) {
      return submissions[problem.id]!;
    }
    return Submission(
      userId: '',
      problemId: problem.id,
      point: 0,
      isCorrect: false,
      submissionOn: SubmissionOn.quiz,
      answer: '',
      attemptedAt: DateTime.now(),
    );
  }

  void onChangeShortAnser(String answer) {
    final Problem problem = questions[currentQuestion];
    if (problem.answer.type == 'short') {
      final Submission submission = Submission(
        userId: '1',
        problemId: problem.id,
        point: problem.correctPoint,
        isCorrect: problem.answer.short == answer,
        submissionOn: SubmissionOn.quiz,
        answer: answer,
        attemptedAt: DateTime.now(),
      );
      context.read<QuizBloc>().add(SubmitAnswer(submission: submission));
    }
  }

  void onChangeTrueFalse(bool answer) {
    final Problem problem = questions[currentQuestion];

    if (problem.answer.type == 'trueFalse') {
      final Submission submission = Submission(
        userId: '1',
        problemId: problem.id,
        point: problem.answer.trueFalse == answer
            ? problem.correctPoint
            : problem.wrongPoint,
        isCorrect: problem.answer.trueFalse! == answer,
        submissionOn: SubmissionOn.quiz,
        answer: answer ? 'true' : 'false',
        attemptedAt: DateTime.now(),
      );

      context.read<QuizBloc>().add(SubmitAnswer(submission: submission));
    }
  }

  void onChangeChoice(int index) {
    final Problem problem = questions[currentQuestion];

    if (problem.answer.type == 'options' && problem.answer.option != null) {
      final Submission submission = Submission(
        userId: '1',
        problemId: problem.id,
        point: problem.answer.option![index].correct
            ? problem.correctPoint
            : problem.wrongPoint,
        isCorrect: problem.answer.option![index].correct,
        submissionOn: SubmissionOn.quiz,
        answer: jsonEncode(problem.answer.option![index].toJson()),
        attemptedAt: DateTime.now(),
      );

      context.read<QuizBloc>().add(SubmitAnswer(submission: submission));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (submissions.containsKey(questions[currentQuestion].id)) {
      print(submissions[questions[currentQuestion].id]!.answer);
    }

    return BlocListener<QuizBloc, QuizState>(
      listener: (context, state) {
        setState(() {
          state.submissions.forEach((key, value) {
            if (submissions.containsKey(key)) {
              if (context.read<QuizBloc>().state.mode == QuizMode.marathon) {
                submissions[key] = value;
              }
            } else {
              submissions[key] = value;
            }
          });
        });
      },
      child: Scaffold(
        backgroundColor: AdaptiveTheme.of(context).mode.isDark
            ? const Color.fromRGBO(28, 27, 32, 1)
            : const Color.fromARGB(255, 0, 69, 104),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                SystemChrome.setSystemUIOverlayStyle(
                                  const SystemUiOverlayStyle(
                                    statusBarIconBrightness: Brightness.dark,
                                  ),
                                );
                                Navigator.pop(context);
                              },
                              child: Icon(
                                Icons.arrow_back_rounded,
                                size: 40,
                                color: AdaptiveTheme.of(context).mode.isDark
                                    ? Colors.white.withOpacity(0.8)
                                    : Colors.white,
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundColor:
                                      AdaptiveTheme.of(context).mode.isDark
                                          ? Colors.white.withOpacity(0.8)
                                          : Colors.white,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'General Knowledge',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: AdaptiveTheme.of(context)
                                                  .mode
                                                  .isDark
                                              ? Colors.white.withOpacity(0.8)
                                              : Colors.white,
                                        ),
                                      ),
                                      Text(
                                        '20.1k participants',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w300,
                                          color: AdaptiveTheme.of(context)
                                                  .mode
                                                  .isDark
                                              ? Colors.white.withOpacity(0.5)
                                              : Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                        GestureDetector(
                          onTap: () async {},
                          child: Icon(
                            Icons.more_vert_rounded,
                            size: 35,
                            color: AdaptiveTheme.of(context).mode.isDark
                                ? Colors.white.withOpacity(0.8)
                                : Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            GestureDetector(
                              onTap: () async {
                                await PersistentNavBarNavigator
                                    .pushNewScreenWithRouteSettings(
                                  context,
                                  settings: const RouteSettings(
                                      name: '/contest/question-set'),
                                  screen: const QuestionSet(),
                                  pageTransitionAnimation:
                                      PageTransitionAnimation.cupertino,
                                );
                                barColor();
                              },
                              child: Icon(
                                Icons.list_alt_rounded,
                                size: 30,
                                color: AdaptiveTheme.of(context).mode.isDark
                                    ? Colors.white.withOpacity(0.8)
                                    : Colors.white,
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Text(
                              'Question ${currentQuestion + 1}'
                              '/${questions.length}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: AdaptiveTheme.of(context).mode.isDark
                                    ? Colors.white.withOpacity(0.8)
                                    : Colors.white,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.timer_outlined,
                              size: 16,
                              color: AdaptiveTheme.of(context).mode.isDark
                                  ? Colors.white.withOpacity(0.8)
                                  : Colors.white,
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            const TextTimer()
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                  ],
                ),
              ),
              questions.isEmpty
                  ? Expanded(
                      child: Container(
                          decoration: BoxDecoration(
                            color: AdaptiveTheme.of(context).mode.isDark
                                ? Colors.white.withOpacity(0.03)
                                : const Color.fromARGB(255, 237, 246, 250),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                            ),
                          ),
                          padding: const EdgeInsets.all(20),
                          clipBehavior: Clip.hardEdge,
                          child: Center(
                              child: Text('No Questions ${questions.length}'))),
                    )
                  : Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: AdaptiveTheme.of(context).mode.isDark
                              ? Colors.white.withOpacity(0.03)
                              : const Color.fromARGB(255, 237, 246, 250),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: Container(
                          color: AdaptiveTheme.of(context).mode.isDark
                              ? Colors.white.withOpacity(0.03)
                              : const Color.fromARGB(255, 237, 246, 250),
                          child: GestureDetector(
                            onHorizontalDragEnd: (details) {
                              if (details.primaryVelocity! > 0) {
                                if (currentQuestion > 0) {
                                  onSelectedQuestion(currentQuestion - 1);
                                  scrollPosition =
                                      _scrollController.position.pixels - 50;
                                  _scrollController.jumpTo(scrollPosition);
                                }
                              } else {
                                if (currentQuestion < questions.length - 1) {
                                  onSelectedQuestion(currentQuestion + 1);
                                  scrollPosition =
                                      _scrollController.position.pixels + 50;
                                  _scrollController.jumpTo(scrollPosition);
                                }
                              }
                            },
                            child: ListView(
                              padding: const EdgeInsets.all(20),
                              children: [
                                for (int index = 0;
                                    index <
                                        questions[currentQuestion]
                                            .question
                                            .length;
                                    index++)
                                  questions[currentQuestion]
                                              .question[index]
                                              .type ==
                                          'text'
                                      ? Builder(
                                          builder: (context) => LaTexT(
                                            laTeXCode: Text(
                                              questions[currentQuestion]
                                                  .question[index]
                                                  .value,
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w400,
                                                color: AdaptiveTheme.of(context)
                                                        .mode
                                                        .isDark
                                                    ? Colors.white
                                                        .withOpacity(0.8)
                                                    : Colors.black,
                                              ),
                                            ),
                                          ),
                                        )
                                      : questions[currentQuestion]
                                                  .question[index]
                                                  .type ==
                                              'image'
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Image.network(
                                                questions[currentQuestion]
                                                    .question[index]
                                                    .value,
                                                fit: BoxFit.cover,
                                              ),
                                            )
                                          : Container(),
                                const SizedBox(height: 20),
                                if (questions[currentQuestion].answer.option !=
                                    null)
                                  for (int index = 0;
                                      index <
                                          questions[currentQuestion]
                                              .answer
                                              .option!
                                              .length;
                                      index++)
                                    ListTile(
                                      onTap: () {
                                        onChangeChoice(index);
                                      },
                                      leading: Container(
                                        width: 30,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          color: QuizMode.marathon ==
                                                  context
                                                      .read<QuizBloc>()
                                                      .state
                                                      .mode
                                              ? isAnswered().userId != '' &&
                                                      isAnswered().answer ==
                                                          jsonEncode(questions[
                                                                  currentQuestion]
                                                              .answer
                                                              .option![index])
                                                  ? AdaptiveTheme.of(context)
                                                          .mode
                                                          .isDark
                                                      ? Colors.white
                                                          .withOpacity(0.1)
                                                      : const Color.fromARGB(
                                                          255, 0, 69, 104)
                                                  : Colors.transparent
                                              : Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          border: Border.all(
                                            color: QuizMode.marathon ==
                                                    context
                                                        .read<QuizBloc>()
                                                        .state
                                                        .mode
                                                ? AdaptiveTheme.of(context)
                                                        .mode
                                                        .isDark
                                                    ? Colors.white
                                                        .withOpacity(0.1)
                                                    : const Color.fromARGB(
                                                        255, 0, 69, 104)
                                                : (isAnswered().userId != ''
                                                    ? (isAnswered().answer ==
                                                            jsonEncode(
                                                                questions[currentQuestion]
                                                                        .answer
                                                                        .option![
                                                                    index]))
                                                        ? Colors.transparent
                                                        : questions[currentQuestion]
                                                                .answer
                                                                .option![index]
                                                                .correct
                                                            ? Colors.transparent
                                                            : AdaptiveTheme.of(context)
                                                                    .mode
                                                                    .isDark
                                                                ? Colors.white
                                                                    .withOpacity(
                                                                        0.1)
                                                                : const Color.fromARGB(
                                                                    255, 0, 69, 104)
                                                    : AdaptiveTheme.of(context)
                                                            .mode
                                                            .isDark
                                                        ? Colors.white
                                                            .withOpacity(0.1)
                                                        : const Color.fromARGB(
                                                            255, 0, 69, 104)),
                                            width: 1,
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                        child: QuizMode.marathon ==
                                                context
                                                    .read<QuizBloc>()
                                                    .state
                                                    .mode
                                            ? isAnswered().userId != '' &&
                                                    isAnswered().answer ==
                                                        jsonEncode(questions[
                                                                currentQuestion]
                                                            .answer
                                                            .option![index])
                                                ? Text(
                                                    String.fromCharCode(
                                                        65 + index),
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: AdaptiveTheme.of(
                                                                  context)
                                                              .mode
                                                              .isDark
                                                          ? Colors.white
                                                              .withOpacity(0.8)
                                                          : Colors.white,
                                                    ),
                                                  )
                                                : Text(
                                                    String.fromCharCode(
                                                        65 + index),
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: AdaptiveTheme.of(
                                                                  context)
                                                              .mode
                                                              .isDark
                                                          ? Colors.white
                                                              .withOpacity(0.8)
                                                          : const Color
                                                              .fromARGB(
                                                              255, 0, 69, 104),
                                                    ),
                                                  )
                                            : isAnswered().userId != ''
                                                ? isAnswered().answer ==
                                                        jsonEncode(questions[
                                                                currentQuestion]
                                                            .answer
                                                            .option![index])
                                                    ? isAnswered().isCorrect
                                                        ? const Icon(
                                                            Icons
                                                                .check_circle_outline,
                                                            color: Colors.green,
                                                          )
                                                        : const Icon(
                                                            Icons
                                                                .cancel_outlined,
                                                            color: Colors.red,
                                                          )
                                                    : questions[currentQuestion]
                                                            .answer
                                                            .option![index]
                                                            .correct
                                                        ? const Icon(
                                                            Icons
                                                                .check_circle_outline,
                                                            color: Colors.green,
                                                          )
                                                        : Text(
                                                            String.fromCharCode(
                                                                65 + index),
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color: AdaptiveTheme.of(
                                                                          context)
                                                                      .mode
                                                                      .isDark
                                                                  ? Colors.white
                                                                      .withOpacity(
                                                                          0.8)
                                                                  : const Color
                                                                      .fromARGB(
                                                                      255,
                                                                      0,
                                                                      69,
                                                                      104),
                                                            ),
                                                          )
                                                : Text(
                                                    String.fromCharCode(
                                                        65 + index),
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: AdaptiveTheme.of(
                                                                  context)
                                                              .mode
                                                              .isDark
                                                          ? Colors.white
                                                              .withOpacity(0.8)
                                                          : const Color
                                                              .fromARGB(
                                                              255, 0, 69, 104),
                                                    ),
                                                  ),
                                      ),
                                      title: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: questions[currentQuestion]
                                            .answer
                                            .option![index]
                                            .data
                                            .map((data) {
                                          return data.type == 'text'
                                              ? Builder(
                                                  builder: (context) => LaTexT(
                                                    laTeXCode: Text(
                                                      data.value,
                                                      textAlign: TextAlign.left,
                                                      style: TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        color: AdaptiveTheme.of(
                                                                    context)
                                                                .mode
                                                                .isDark
                                                            ? Colors.white
                                                                .withOpacity(
                                                                    0.8)
                                                            : Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : data.type == 'image'
                                                  ? Image.network(
                                                      data.value,
                                                      fit: BoxFit.cover,
                                                    )
                                                  : Container();
                                        }).toList(),
                                      ),
                                    ),
                                if (questions[currentQuestion]
                                        .answer
                                        .trueFalse !=
                                    null)
                                  for (int index = 0; index < 2; index++)
                                    ListTile(
                                      onTap: () {
                                        onChangeTrueFalse(index == 0);
                                      },
                                      leading: Container(
                                        width: 30,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          color: QuizMode.marathon ==
                                                  context
                                                      .read<QuizBloc>()
                                                      .state
                                                      .mode
                                              ? isAnswered().userId != '' &&
                                                      isAnswered().answer ==
                                                          jsonEncode(questions[
                                                                  currentQuestion]
                                                              .answer
                                                              .option![index])
                                                  ? AdaptiveTheme.of(context)
                                                          .mode
                                                          .isDark
                                                      ? Colors.white
                                                          .withOpacity(0.1)
                                                      : const Color.fromARGB(
                                                          255, 0, 69, 104)
                                                  : Colors.transparent
                                              : Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          border: Border.all(
                                            color: QuizMode.marathon ==
                                                    context
                                                        .read<QuizBloc>()
                                                        .state
                                                        .mode
                                                ? AdaptiveTheme.of(context)
                                                        .mode
                                                        .isDark
                                                    ? Colors.white
                                                        .withOpacity(0.1)
                                                    : const Color.fromARGB(
                                                        255, 0, 69, 104)
                                                : (isAnswered().userId != ''
                                                    ? isAnswered().userId != '' &&
                                                            isAnswered().answer ==
                                                                (index == 0
                                                                    ? 'true'
                                                                    : 'false')
                                                        ? Colors.transparent
                                                        : questions[currentQuestion]
                                                                .answer
                                                                .trueFalse!
                                                            ? Colors.transparent
                                                            : AdaptiveTheme.of(
                                                                        context)
                                                                    .mode
                                                                    .isDark
                                                                ? Colors.white
                                                                    .withOpacity(
                                                                        0.1)
                                                                : const Color.fromARGB(
                                                                    255,
                                                                    0,
                                                                    69,
                                                                    104)
                                                    : AdaptiveTheme.of(context)
                                                            .mode
                                                            .isDark
                                                        ? Colors.white
                                                            .withOpacity(0.1)
                                                        : const Color.fromARGB(
                                                            255, 0, 69, 104)),
                                            width: 1,
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                        child: QuizMode.marathon ==
                                                context
                                                    .read<QuizBloc>()
                                                    .state
                                                    .mode
                                            ? isAnswered().userId != '' &&
                                                    isAnswered().answer ==
                                                        (index == 0
                                                            ? 'true'
                                                            : 'false')
                                                ? Text(
                                                    String.fromCharCode(
                                                        65 + index),
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: AdaptiveTheme.of(
                                                                  context)
                                                              .mode
                                                              .isDark
                                                          ? Colors.white
                                                              .withOpacity(0.8)
                                                          : Colors.white,
                                                    ),
                                                  )
                                                : Text(
                                                    String.fromCharCode(
                                                        65 + index),
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: AdaptiveTheme.of(
                                                                  context)
                                                              .mode
                                                              .isDark
                                                          ? Colors.white
                                                              .withOpacity(0.8)
                                                          : const Color
                                                              .fromARGB(
                                                              255, 0, 69, 104),
                                                    ),
                                                  )
                                            : isAnswered().userId != ''
                                                ? index == 0
                                                    ? isAnswered().answer ==
                                                            'true'
                                                        ? isAnswered().isCorrect
                                                            ? const Icon(
                                                                Icons
                                                                    .check_circle_outline,
                                                                color: Colors
                                                                    .green,
                                                              )
                                                            : const Icon(
                                                                Icons
                                                                    .cancel_outlined,
                                                                color:
                                                                    Colors.red,
                                                              )
                                                        : Text(
                                                            String.fromCharCode(
                                                                65 + index),
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color: AdaptiveTheme.of(
                                                                          context)
                                                                      .mode
                                                                      .isDark
                                                                  ? Colors.white
                                                                      .withOpacity(
                                                                          0.8)
                                                                  : const Color
                                                                      .fromARGB(
                                                                      255,
                                                                      0,
                                                                      69,
                                                                      104),
                                                            ),
                                                          )
                                                    : isAnswered().answer ==
                                                            'false'
                                                        ? isAnswered().isCorrect
                                                            ? const Icon(
                                                                Icons
                                                                    .check_circle_outline,
                                                                color: Colors
                                                                    .green,
                                                              )
                                                            : const Icon(
                                                                Icons
                                                                    .cancel_outlined,
                                                                color:
                                                                    Colors.red,
                                                              )
                                                        : Text(
                                                            String.fromCharCode(
                                                                65 + index),
                                                            style: TextStyle(
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color: AdaptiveTheme.of(
                                                                          context)
                                                                      .mode
                                                                      .isDark
                                                                  ? Colors.white
                                                                      .withOpacity(
                                                                          0.8)
                                                                  : const Color
                                                                      .fromARGB(
                                                                      255,
                                                                      0,
                                                                      69,
                                                                      104),
                                                            ),
                                                          )
                                                : Text(
                                                    String.fromCharCode(
                                                        65 + index),
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: AdaptiveTheme.of(
                                                                  context)
                                                              .mode
                                                              .isDark
                                                          ? Colors.white
                                                              .withOpacity(0.8)
                                                          : const Color
                                                              .fromARGB(
                                                              255, 0, 69, 104),
                                                    ),
                                                  ),
                                      ),
                                      title: Text(
                                        index % 1 == index ? "True" : "False",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w400,
                                          color: AdaptiveTheme.of(context)
                                                  .mode
                                                  .isDark
                                              ? Colors.white.withOpacity(0.8)
                                              : Colors.black,
                                        ),
                                      ),
                                    ),
                                if (questions[currentQuestion].answer.short !=
                                    null)
                                  SizedBox(
                                    height: 60,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            top: 16,
                                          ),
                                          child: Icon(Icons.question_answer,
                                              size: 30,
                                              color: AdaptiveTheme.of(context)
                                                      .mode
                                                      .isDark
                                                  ? Colors.white
                                                      .withOpacity(0.8)
                                                  : const Color.fromARGB(
                                                      255, 0, 69, 104)),
                                        ),
                                        const SizedBox(width: 10),
                                        SizedBox(
                                          width: 300,
                                          child: TextField(
                                            onChanged: onChangeShortAnser,
                                            style: TextStyle(
                                              color: AdaptiveTheme.of(context)
                                                      .mode
                                                      .isDark
                                                  ? Colors.white
                                                      .withOpacity(0.8)
                                                  : Colors.black,
                                            ),
                                            decoration: InputDecoration(
                                              hintText:
                                                  'Type your answer here...',
                                              hintStyle: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                                color: AdaptiveTheme.of(context)
                                                        .mode
                                                        .isDark
                                                    ? Colors.white
                                                        .withOpacity(0.5)
                                                    : Colors.black
                                                        .withOpacity(0.5),
                                              ),
                                            ),
                                            controller: _textEditingController,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                const SizedBox(height: 40),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                decoration: BoxDecoration(
                  color: AdaptiveTheme.of(context).mode.isDark
                      ? const Color.fromRGBO(28, 27, 32, 1)
                      : const Color.fromRGBO(244, 247, 252, 1),
                ),
                alignment: Alignment.center,
                child: SizedBox(
                  height: 35,
                  child: ListView.builder(
                    controller: _scrollController,
                    itemCount: questions.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          onSelectedQuestion(index);
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 9),
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: index == currentQuestion
                                ? AdaptiveTheme.of(context).mode.isDark
                                    ? const Color.fromRGBO(28, 27, 32, 1)
                                    : const Color.fromARGB(255, 0, 69, 104)
                                : AdaptiveTheme.of(context).mode.isDark
                                    ? Colors.transparent
                                    : Colors.white.withOpacity(0.8),
                            border: Border.all(
                              color: index == currentQuestion
                                  ? AdaptiveTheme.of(context).mode.isDark
                                      ? Colors.white.withOpacity(0.1)
                                      : const Color.fromARGB(255, 0, 69, 104)
                                  : AdaptiveTheme.of(context).mode.isDark
                                      ? Colors.white.withOpacity(0.8)
                                      : const Color.fromARGB(255, 0, 69, 104),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: index == currentQuestion
                                  ? AdaptiveTheme.of(context).mode.isDark
                                      ? Colors.white.withOpacity(0.8)
                                      : Colors.white
                                  : AdaptiveTheme.of(context).mode.isDark
                                      ? Colors.white.withOpacity(0.8)
                                      : const Color.fromARGB(255, 0, 69, 104),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
