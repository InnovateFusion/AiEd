import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:latext/latext.dart';
import 'package:mobile/features/ed_ai/presentations/screen/contest/question_set.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../../../domains/entities/problem.dart';

class Question extends StatefulWidget {
  const Question({
    required this.questions,
    Key? key,
  }) : super(key: key);

  final List<Problem> questions;

  static const routeName = '/problem/question';

  @override
  State<Question> createState() => _QuestionState();
}

class _QuestionState extends State<Question> {
  int currentQuestion = 0;
  final ScrollController _scrollController = ScrollController();
  double scrollPosition = 0.0;

  @override
  void initState() {
    super.initState();
  }

  void barColor() {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light),
    );
  }

  void onSelectedQuestion(int index) {
    if (index < 0 || index > widget.questions.length - 1) {
      return;
    }

    setState(() {
      currentQuestion = index;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    barColor();

    return Scaffold(
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
                                  crossAxisAlignment: CrossAxisAlignment.start,
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
                                withNavBar: true,
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
                            '/${widget.questions.length}',
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
                          Text(
                            '00:20:01',
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
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  )
                ],
              ),
            ),
            widget.questions.isEmpty
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
                            child: Text(
                                'No Questions ${widget.questions.length}'))),
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
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        reverseDuration: const Duration(milliseconds: 500),
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                          const begin = Offset(1, 0.0);
                          const end = Offset.zero;
                          var tween = Tween(begin: begin, end: end);
                          var curvedAnimation = CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeIn,
                            reverseCurve: Curves.easeOut,
                          );
                          var slideAnimation = tween.animate(curvedAnimation);

                          return SlideTransition(
                            position: slideAnimation,
                            child: child,
                          );
                        },
                        child: Container(
                          key: ValueKey<bool>(currentQuestion % 2 == 0),
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
                                if (currentQuestion <
                                    widget.questions.length - 1) {
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
                                        widget.questions[currentQuestion]
                                            .question.length;
                                    index++)
                                  widget.questions[currentQuestion]
                                              .question[index].type ==
                                          'text'
                                      ? Builder(
                                          builder: (context) => LaTexT(
                                            laTeXCode: Text(
                                              widget.questions[currentQuestion]
                                                  .question[index].value,
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
                                      : widget.questions[currentQuestion]
                                                  .question[index].type ==
                                              'image'
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Image.network(
                                                widget
                                                    .questions[currentQuestion]
                                                    .question[index]
                                                    .value,
                                                fit: BoxFit.cover,
                                              ),
                                            )
                                          : Container(),
                                const SizedBox(height: 20),
                                if (widget.questions[currentQuestion].answer
                                        .option !=
                                    null)
                                  for (int index = 0;
                                      index <
                                          widget.questions[currentQuestion]
                                              .answer.option!.length;
                                      index++)
                                    ListTile(
                                      onTap: () {},
                                      leading: Container(
                                        width: 30,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          color: index == 2
                                              ? AdaptiveTheme.of(context)
                                                      .mode
                                                      .isDark
                                                  ? const Color.fromRGBO(
                                                      28, 27, 32, 1)
                                                  : const Color.fromARGB(
                                                      255, 0, 69, 104)
                                              : Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          border: Border.all(
                                            color: index == 2
                                                ? AdaptiveTheme.of(context)
                                                        .mode
                                                        .isDark
                                                    ? Colors.white
                                                        .withOpacity(0.1)
                                                    : const Color.fromARGB(
                                                        255, 0, 69, 104)
                                                : AdaptiveTheme.of(context)
                                                        .mode
                                                        .isDark
                                                    ? Colors.white
                                                        .withOpacity(0.8)
                                                    : const Color.fromARGB(
                                                        255, 0, 69, 104),
                                            width: 1,
                                          ),
                                        ),
                                        alignment: Alignment.center,
                                        child: Text(
                                          String.fromCharCode(65 + index),
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: index == 2
                                                ? AdaptiveTheme.of(context)
                                                        .mode
                                                        .isDark
                                                    ? Colors.white
                                                        .withOpacity(0.8)
                                                    : Colors.white
                                                : AdaptiveTheme.of(context)
                                                        .mode
                                                        .isDark
                                                    ? Colors.white
                                                        .withOpacity(0.8)
                                                    : const Color.fromARGB(
                                                        255, 0, 69, 104),
                                          ),
                                        ),
                                      ),
                                      title: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: widget
                                            .questions[currentQuestion]
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
                                if (widget.questions[currentQuestion].answer
                                        .trueFalse !=
                                    null)
                                  const SizedBox(height: 20),
                                const SizedBox(height: 40),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
                  itemCount: widget.questions.length,
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
    );
  }
}
