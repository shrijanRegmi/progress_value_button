library progress_button;

import 'package:flutter/material.dart';

/// Creates a progress button with the supplied value in percentage.
///
/// The [value] and [onPressed] parameters should not be null.
///
/// Example:
/// ```dart
/// ProgressButton(
///   value: 90.0,
///   height: 65.0,
///   onPressed: (progress) {},
///   margin: const EdgeInsets.all(10.0),
///   child: Text(
///     "Uploading...",
///     style: TextStyle(
///     fontWeight: FontWeight.bold,
///     color: Colors.white,
///     fontSize: 18.0,
///   ),
/// ),
/// ```
class ProgressButton extends StatefulWidget {
  /// The percentage value of the progress indicator.
  ///
  /// The [value] parameter should not be null.
  final double value;

  /// The background color of the progress button.
  ///
  /// If null the [backgroundColor] defaults to Color(0xffd6d6d6).
  final Color backgroundColor;

  /// The color of the progress indicator.
  ///
  /// If null the [progressColor] defaults to Colors.green.
  final Color progressColor;

  /// The function that will be called when user taps on the button.
  ///
  /// The [onPressed] parameter must not be null.
  ///
  /// The [onPressed] function is called with the progress in percentage.
  final Function(double) onPressed;

  /// The active state of the button.
  ///
  /// When set to false, the progress of the button won't change.
  ///
  /// If null the [active] parameter defaults to true.
  final bool? active;

  /// The animation duration of the progress animation.
  ///
  /// If null the [animationDuration] parameter defaults to 2000 milliseconds
  final Duration? animationDuration;

  /// The curve of the progress animation.
  ///
  /// If null the [animationCurve] parameter defaults to Curves.easeOutSine
  final Curve animationCurve;

  /// The border radius of the button.
  ///
  /// If null the [borderRadius] parameter defaults to 4.0.
  final double? borderRadius;

  /// The widget that is displayed in the center of the progress button.
  /// It is usually a text widget.
  ///
  /// If null the progress button won't contain anything.
  final Widget? child;

  /// The width of the progress button.
  ///
  /// If null the [width] parameter defaults to width of the screen.
  final double? width;

  /// The height of the progress button.
  ///
  /// If null the [height] parameter defaults to 50.0.
  final double? height;

  /// The margin around the progress button.
  ///
  /// If null the [margin] parameter defaults to no margin.
  final EdgeInsetsGeometry? margin;

  /// The function that will be called everytime the progress of the button changes.
  ///
  /// The [onValueChange] function is called with the progress in percentage.
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
    this.active = true,
    this.animationDuration = const Duration(milliseconds: 2000),
    this.animationCurve = Curves.easeOutSine,
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
      duration: widget.animationDuration,
    );
    _tween = Tween<double>(begin: 0.0, end: widget.value);
    _animation = _tween.animate(CurvedAnimation(
      parent: _animationController,
      curve: widget.animationCurve,
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
