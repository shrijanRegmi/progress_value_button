library progress_button;

import 'package:flutter/material.dart';

class ProgressButton extends StatefulWidget {
  final double value;
  final Color backgroundColor;
  final Color progressColor;
  final Function(double) onPressed;
  final double? borderRadius;
  final Widget? child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? margin;
  final Function(double)? onValueChange;

  const ProgressButton({
    Key? key,
    required this.value,
    required this.onPressed,
    this.backgroundColor = const Color(0xffd6d6d6),
    this.progressColor = Colors.green,
    this.child,
    this.width,
    this.height,
    this.margin,
    this.onValueChange,
    this.borderRadius = 4.0,
  }) : super(key: key);

  @override
  _ProgressButtonState createState() => _ProgressButtonState();
}

class _ProgressButtonState extends State<ProgressButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  late Tween<double> _tween;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2000),
    );
    _tween = Tween<double>(begin: 0.0, end: widget.value);
    _animation = _tween.animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutSine,
    ));
    _animationController.forward();
  }

  @override
  void didUpdateWidget(covariant ProgressButton oldWidget) {
    _changeVal();
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _changeVal() {
    _animationController.reset();
    _tween.begin = _tween.end;
    _tween.end = widget.value;
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final _width = widget.width ?? MediaQuery.of(context).size.width;
    final _height = widget.height ?? 50.0;

    return Padding(
      padding: widget.margin ?? EdgeInsets.all(0.0),
      child: GestureDetector(
        onTap: () => widget.onPressed(_animation.value),
        child: Container(
          height: _height,
          width: _width,
          decoration: BoxDecoration(boxShadow: []),
          child: Center(
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                if (widget.onValueChange != null)
                  widget.onValueChange!(_animation.value);
                return CustomPaint(
                  painter: _ButtonPainter(
                    _animation.value,
                    widget.backgroundColor,
                    widget.progressColor,
                    widget.borderRadius ?? 4.0,
                  ),
                  child: child,
                );
              },
              child: Center(
                child: widget.child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ButtonPainter extends CustomPainter {
  final double value;
  final Color backgroundColor;
  final Color progressColor;
  final double borderRadius;

  _ButtonPainter(
    this.value,
    this.backgroundColor,
    this.progressColor,
    this.borderRadius,
  );

  @override
  void paint(Canvas canvas, Size size) {
    final _paintBG = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;
    final _paintPG = Paint()
      ..color = progressColor
      ..style = PaintingStyle.fill;

    final _progress = value / 100 * size.width;
    final _rectBG = RRect.fromRectAndRadius(
      Offset(0, 0) & Size(size.width, size.height),
      Radius.circular(borderRadius),
    );
    final _rectPG = RRect.fromRectAndRadius(
      Offset(0, 0) & Size(_progress, size.height),
      Radius.circular(borderRadius),
    );

    canvas.drawRRect(_rectBG, _paintBG);
    canvas.drawRRect(_rectPG, _paintPG);
  }

  @override
  bool shouldRepaint(_ButtonPainter oldDelegate) => true;

  @override
  bool shouldRebuildSemantics(_ButtonPainter oldDelegate) => true;
}
