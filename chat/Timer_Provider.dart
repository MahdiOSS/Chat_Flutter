import 'dart:async';

import 'package:flutter/material.dart';

class TimerProvider extends InheritedWidget {
  final Timer timer;

  const TimerProvider({
    Key? key,
    required this.timer,
    Widget child = const SizedBox(),
  }) : super(key: key, child: child);

  static TimerProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<TimerProvider>()!;
  }

  @override
  bool updateShouldNotify(TimerProvider oldWidget) {
    return timer != oldWidget.timer;
  }
}