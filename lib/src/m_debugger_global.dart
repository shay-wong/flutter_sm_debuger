import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class MDebuggerGlobal {
  MDebuggerGlobal._();
  static final MDebuggerGlobal _instance = MDebuggerGlobal._();
  factory MDebuggerGlobal() => _instance;

  List<Object> console = [];
}

void runAppDebugger(
  Widget app, {
  bool debug = false,
}) {
  if (kDebugMode || debug) {
    runZoned(
      () => runApp(app),
      zoneSpecification: ZoneSpecification(
        print: (Zone self, ZoneDelegate parent, Zone zone, String line) {
          parent.print(zone, line);
          MDebuggerGlobal().console.add(line);
        },
        handleUncaughtError: (self, parent, zone, error, stackTrace) {
          MDebuggerGlobal().console.add(error);
        },
      ),
    );
  } else {
    runApp(app);
  }
}
