import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:mobile/features/ed_ai/domains/entities/problem.dart';
import 'package:mobile/features/ed_ai/domains/entities/submission.dart';
import 'package:stream_transform/stream_transform.dart';

part 'quiz_event.dart';
part 'quiz_state.dart';

const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class QuizBloc extends Bloc<QuizEvent, QuizState> {
  QuizBloc() : super(QuizState()) {
    on<TakeQuiz>(_takeQuiz, transformer: throttleDroppable(throttleDuration));
    on<StartQuiz>(_startQuiz, transformer: throttleDroppable(throttleDuration));
    on<SubmitAnswer>(_submitAnswer,
        transformer: throttleDroppable(throttleDuration));
    on<ContinueQuiz>(_continueQuiz,
        transformer: throttleDroppable(throttleDuration));
  }

  Future<void> _takeQuiz(
    TakeQuiz event,
    Emitter<QuizState> emit,
  ) async {
    Map<String, Problem> problemsMap = {};
    int duration = 0;
    for (var problem in event.problems) {
      problemsMap[problem.id] = problem;
      if (problem.courses.contains('math')) {
        duration += 180;
      } else if (problem.courses.contains('physics')) {
        duration += 120;
      } else {
        duration += 60;
      }
    }

    emit(
      state.copyWith(
        progress: QuizProgress.ready,
        problems: problemsMap,
        startsAt: DateTime.now(),
        duration: duration,
        mode: event.mode,
        submissions: const {},
      ),
    );
  }

  Future<void> _startQuiz(
    StartQuiz event,
    Emitter<QuizState> emit,
  ) async {
    emit(
      state.copyWith(
        progress: QuizProgress.start,
      ),
    );
  }

  Future<void> _submitAnswer(
    SubmitAnswer event,
    Emitter<QuizState> emit,
  ) async {
    if (!state.submissions.containsKey(event.submission.problemId) ||
        state.mode == QuizMode.marathon) {
      final submissions = {...state.submissions};
      submissions[event.submission.problemId] = event.submission;
      emit(state.copyWith(
          submissions: submissions, progress: QuizProgress.inProgress));
    }
  }

  Future<void> _continueQuiz(
    ContinueQuiz event,
    Emitter<QuizState> emit,
  ) async {
    emit(state.copyWith(progress: QuizProgress.inProgress));
  }
}
