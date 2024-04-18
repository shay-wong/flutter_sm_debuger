import 'package:flutter/material.dart';
import 'package:sm_widget/sm_widget.dart';

enum Env {
  release,
  dev,
  test,
}

extension EnvExtension on Env {
  Color get color {
    switch (this) {
      case Env.release:
        return Colors.green;
      case Env.dev:
        return Colors.blue;
      case Env.test:
        return Colors.red;
    }
  }
}

class MDebuggerFeature extends StatefulWidget {
  const MDebuggerFeature({super.key});

  @override
  State<MDebuggerFeature> createState() => _MDebuggerFeatureState();
}

class _MDebuggerFeatureState extends State<MDebuggerFeature> {
  Env? selectedEnv = Env.release;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 10),
      itemBuilder: (context, index) {
        switch (index) {
          case 0:
            return MListTile(
              titleText: '切换环境',
              trailing: DropdownButton<Env>(
                value: selectedEnv,
                // controller: colorController,
                items: Env.values.map<DropdownMenuItem<Env>>(
                  (Env env) {
                    return DropdownMenuItem<Env>(
                      value: env,
                      child: MText(
                        env.name,
                        style: TextStyle(
                          color: env.color,
                        ),
                      ),
                      onTap: () {},
                    );
                  },
                ).toList(),
                onChanged: (Env? env) {
                  setState(() {
                    selectedEnv = env;
                  });
                },
              ),
            );
          case 1:
            return const MListTile(
              titleText: '切换账号',
            );
          default:
            return const MListTile(
              titleText: '切换环境',
            );
        }
      },
      separatorBuilder: (context, index) {
        return const Divider();
      },
      itemCount: 10,
    );
  }
}
