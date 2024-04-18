import 'package:flutter/widgets.dart';

import 'm_debugger_global.dart';

class MDebuggerConsole extends StatefulWidget {
  const MDebuggerConsole({super.key});

  @override
  State<MDebuggerConsole> createState() => _MDebuggerConsoleState();
}

class _MDebuggerConsoleState extends State<MDebuggerConsole> {
  @override
  void initState() {
    super.initState();
  }

  void saveLog(String message) {
    // 处理日志的保存或传输
    // print("Log saved: $message"); // 这里只是示例，实际不应在这里使用 print
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 10),
      reverse: true,
      itemBuilder: (context, index) {
        return Text(MDebuggerGlobal().console[MDebuggerGlobal().console.length - index - 1].toString());
      },
      itemCount: MDebuggerGlobal().console.length,
    );
  }
}
