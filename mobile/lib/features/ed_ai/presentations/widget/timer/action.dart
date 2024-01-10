import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/ed_ai/presentations/bloc/timer/timer_bloc.dart';

class TimerActions extends StatelessWidget {
  const TimerActions({super.key, required this.second});

  final int second;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TimerBloc, TimerState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            if (state.status == TimerStatus.initial)
              GestureDetector(
                onTap: () {
                  context.read<TimerBloc>().add(TimerStarted(duration: second));
                },
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: AdaptiveTheme.of(context).mode.isDark
                        ? Colors.white.withOpacity(0.05)
                        : const Color.fromARGB(255, 0, 69, 104),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Icon(Icons.play_arrow,
                      color: AdaptiveTheme.of(context).mode.isDark
                          ? Colors.white.withOpacity(0.8)
                          : Colors.white),
                ),
              ),
            if (state.status == TimerStatus.running)
              GestureDetector(
                onTap: () {
                  context.read<TimerBloc>().add(const TimerPaused());
                },
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: AdaptiveTheme.of(context).mode.isDark
                        ? Colors.white.withOpacity(0.05)
                        : const Color.fromARGB(255, 0, 69, 104),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Icon(Icons.play_arrow,
                      color: AdaptiveTheme.of(context).mode.isDark
                          ? Colors.white.withOpacity(0.8)
                          : Colors.white),
                ),
              ),
            if (state.status == TimerStatus.paused)
              GestureDetector(
                onTap: () {
                  context.read<TimerBloc>().add(const TimerResumed());
                },
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: AdaptiveTheme.of(context).mode.isDark
                        ? Colors.white.withOpacity(0.05)
                        : const Color.fromARGB(255, 0, 69, 104),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Icon(Icons.pause,
                      color: AdaptiveTheme.of(context).mode.isDark
                          ? Colors.white.withOpacity(0.8)
                          : Colors.white),
                ),
              ),
            if (state.status == TimerStatus.paused ||
                state.status == TimerStatus.finished ||
                state.status == TimerStatus.running)
              GestureDetector(
                onTap: () {
                  context.read<TimerBloc>().add(const TimerReset());
                },
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                    color: AdaptiveTheme.of(context).mode.isDark
                        ? Colors.white.withOpacity(0.05)
                        : const Color.fromARGB(255, 0, 69, 104),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Icon(Icons.replay,
                      color: AdaptiveTheme.of(context).mode.isDark
                          ? Colors.white.withOpacity(0.8)
                          : Colors.white),
                ),
              ),
          ],
        );
      },
    );
  }
}
