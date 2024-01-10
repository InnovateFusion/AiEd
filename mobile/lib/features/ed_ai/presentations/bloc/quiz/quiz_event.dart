part of 'quiz_bloc.dart';

sealed class QuizEvent extends Equatable {
  const QuizEvent();

  @override
  List<Object> get props => [];
}

final class TakeQuiz extends QuizEvent {
  final List<Problem> problems;
  final QuizMode mode;

  const TakeQuiz({
    required this.problems,
    required this.mode,
  });

  @override
  List<Object> get props => [problems, mode];
}

final class StartQuiz extends QuizEvent {}

final class ContinueQuiz extends QuizEvent {}

final class SubmitAnswer extends QuizEvent {
  final Submission submission;

  const SubmitAnswer({
    required this.submission,
  });

  @override
  List<Object> get props => [submission];
}
