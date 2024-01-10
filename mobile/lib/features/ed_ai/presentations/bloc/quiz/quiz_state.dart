part of 'quiz_bloc.dart';

enum QuizProgress {
  notReady,
  ready,
  start,
  inProgress,
  end,
}

enum QuizMode {
  learning,
  marathon,
  killAndPass,
}

class QuizState extends Equatable {
  final QuizProgress progress;
  final Map<String, Problem> problems;
  final Map<String, Submission> submissions;
  final DateTime? startsAt;
  final int duration;
  final QuizMode mode;
  QuizState({
    this.progress = QuizProgress.notReady,
    this.problems = const {},
    this.submissions = const {},
    this.duration = 0,
    this.mode = QuizMode.learning,
    DateTime? startsAt,
  }) : startsAt = startsAt ?? DateTime.now();

  @override
  List<Object?> get props => [
        progress,
        problems,
        submissions,
        startsAt,
        duration,
        mode,
      ];

  QuizState copyWith({
    QuizProgress? progress,
    Map<String, Problem>? problems,
    Map<String, Submission>? submissions,
    DateTime? startsAt,
    int? duration,
    QuizMode? mode,
  }) {
    return QuizState(
      progress: progress ?? this.progress,
      problems: problems ?? this.problems,
      submissions: submissions ?? this.submissions,
      startsAt: startsAt ?? this.startsAt,
      duration: duration ?? this.duration,
      mode: mode ?? this.mode,
    );
  }
}
