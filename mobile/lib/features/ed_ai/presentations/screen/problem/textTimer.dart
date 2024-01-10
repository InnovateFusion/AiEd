import 'dart:async';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile/features/ed_ai/presentations/bloc/timer/timer_bloc.dart';

class TextTimer extends StatefulWidget {
  const TextTimer({
    Key? key,
  }) : super(key: key);

  @override
  State<TextTimer> createState() => _TextTimerState();
}

class _TextTimerState extends State<TextTimer> {
  late StreamSubscription<int> _currentTimeSubscription;
  int _currentTime = 0;

  @override
  void initState() {
    super.initState();

    _currentTimeSubscription =
        context.read<TimerBloc>().timerDataStream.listen((currentTime) {
      setState(() {
        _currentTime = currentTime;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _currentTimeSubscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    var duration = _currentTime;
    var hoursStr = (duration ~/ 3600).toString().padLeft(2, '0');
    var minutesStr = ((duration ~/ 60) % 60).toString().padLeft(2, '0');
    var secondsStr = (duration % 60).toString().padLeft(2, '0');
    var timeText = '$hoursStr:$minutesStr:$secondsStr';

    return Text(
      timeText,
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AdaptiveTheme.of(context).mode.isDark
            ? Colors.white.withOpacity(0.8)
            : Colors.white,
      ),
    );
  }
}
