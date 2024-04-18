// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sm_widget/sm_widget.dart';

import 'm_debugger_sheet.dart';

class MDebugger extends StatefulWidget {
  const MDebugger({
    super.key,
    double? size,
    double? width,
    double? height,
    required this.child,
    this.icon,
    this.isHiding = true,
    this.isAdsorb = true,
    this.hideDuration = const Duration(seconds: 3),
    this.position = Offset.zero,
  })  : width = width ?? size,
        height = height ?? size;

  final Widget child;
  final double? height;
  final Duration hideDuration;
  final IconData? icon;
  final bool isHiding;
  final double? width;

  /// 是否吸附
  final bool isAdsorb;

  // 控件的位置
  final Offset position;

  @override
  State<MDebugger> createState() => _MDebuggerState();
}

class _MDebuggerState extends State<MDebugger> with SingleTickerProviderStateMixin {
  bool _isAnimated = false;
  bool _isHide = false;
  double _opacity = 1.0;
  late Offset _position;

  Timer? _timer;

  @override
  void dispose() {
    _cancelTimer();
    _animationController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _position = widget.position;
    if (widget.isHiding) {
      _resetTimer();
    }
  }

  double get height => widget.height ?? 60;
  bool get isHide => _isHide;
  double get screenHeight => screenSize.height;
  Size get screenSize => MediaQuery.of(context).size;
  double get screenWidth => screenSize.width;
  double get width => widget.width ?? 60;

  void adsorbPositioned() {
    // 如果拖动结束后，位置超出了屏幕，就将位置放到屏幕边缘
    final double dy = _position.dy.clamp(0, screenSize.height - height);
    double dx = _position.dx.clamp(0, screenSize.width - width);
    if (widget.isAdsorb) {
      _isAnimated = true;
      dx = dx > (screenWidth - width) / 2 ? screenWidth - width : 0;
    }

    _position = Offset(dx, dy);
  }

  set isHide(bool value) {
    if (_isHide != value) {
      _isHide = value;
      _opacity = value ? 0.15 : 1.0;
      if (widget.isAdsorb) {
        _isAnimated = true;
        final offset = Offset(width / 2, 0);
        if ((_position.dx == 0 && value) || (_position.dx == screenWidth - (width / 2) && !value)) {
          _position -= offset;
        } else {
          _position += offset;
        }
      }
    }
  }

  late final AnimationController _animationController = MBottomSheet.createAnimationController(this);

  /// 取消计时器
  void _cancelTimer() {
    if (_timer != null) {
      _timer?.cancel();
      _timer == null;
    }
  }

  /// 重置计时器
  void _resetTimer() {
    // 取消之前的计时器（如果有）
    _cancelTimer();
    // 创建一个新的计时器，3秒后将值设为false
    _timer = Timer(const Duration(seconds: 3), () {
      setState(() {
        isHide = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget child = SizedBox(
      width: width,
      height: height,
      child: IconButton(
        style: IconButton.styleFrom(
          backgroundColor: Colors.lightGreenAccent,
        ),
        onPressed: () {
          _resetTimer();
          setState(() {
            isHide = false;
          });
          showModalBottomSheet(
            context: context,
            // isScrollControlled: true,
            constraints: const BoxConstraints.expand(),
            builder: (context) {
              return MDebuggerSheet(
                animationController: _animationController,
              );
            },
          );
        },
        icon: const Icon(
          Icons.build,
        ),
      ),
    );

    child = Draggable(
      onDragStarted: () {
        debugPrint('-- onDragStarted $_isAnimated');
        _cancelTimer();
        setState(() {
          isHide = false;
          _isAnimated = false;
        });
      },
      onDragUpdate: (details) {
        setState(() {
          _position += details.delta;
        });
      },
      onDragEnd: (details) {
        debugPrint('-- onDragEnd ${details.velocity}, ${details.offset}');
        setState(() {
          adsorbPositioned();
        });
      },
      onDragCompleted: () {
        debugPrint('-- onDragCompleted');
      },
      onDraggableCanceled: (velocity, offset) {
        debugPrint('-- onDraggableCanceled $velocity, $offset');
      },
      feedback: child,
      childWhenDragging: const SizedBox.shrink(),
      child: child,
    );

    child = AnimatedPositioned(
      left: _position.dx,
      top: _position.dy,
      duration: _isAnimated ? const Duration(milliseconds: 300) : Duration.zero,
      child: AnimatedOpacity(
        opacity: _opacity,
        duration: const Duration(milliseconds: 300),
        child: child,
      ),
      onEnd: () {
        _isAnimated = false;
        if (widget.isHiding && !isHide) {
          _resetTimer();
        }
      },
    );

    return Material(
      child: Stack(
        children: [
          widget.child,
          child,
        ],
      ),
    );
  }
}
