import 'package:flutter/material.dart';
import 'package:sm_widget/sm_widget.dart';

import 'm_debugger_console.dart';
import 'm_debugger_feature.dart';

class MDebuggerSheet extends MBottomSheet {
  const MDebuggerSheet({super.key, super.animationController});

  List<String> get tabs => [
        '功能',
        '调试控制台',
        '说明',
      ];

  @override
  BoxConstraints? get constraints => const BoxConstraints.expand();

  @override
  Widget? get child => DefaultTabController(
        length: tabs.length,
        child: Column(
          children: [
            Expanded(
              child: TabBarView(
                children: tabs.asMap().entries.map(
                  (e) {
                    switch (e.key) {
                      case 0:
                        return const MDebuggerFeature();
                      case 1:
                        return const MDebuggerConsole();
                      default:
                        return MContainer(
                          child: Text(e.value),
                        );
                    }
                  },
                ).toList(),
              ),
            ),
            TabBar(
              tabs: tabs
                  .map(
                    (e) => Tab(text: e),
                  )
                  .toList(),
            ),
          ],
        ),
      );
}
