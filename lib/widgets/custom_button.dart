import 'package:flutter/material.dart';

class CustomButton extends StatefulWidget {
  final String text;
  final Color color;
  final double width;
  final double height;
  final double borderRadius;
  final double elevation;
  final TextStyle? textStyle;
  final VoidCallback onPressed;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.color = Colors.blue,
    this.width = double.infinity,
    this.height = 50.0,
    this.borderRadius = 16.0,
    this.elevation = 5.0,
    this.textStyle,
  }) : super(key: key);

  @override
  State<CustomButton> createState() => _CustomButtonState();
}

class _CustomButtonState extends State<CustomButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: _isPressed ? widget.color.withOpacity(0.8) : widget.color,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          boxShadow: [
            if (!_isPressed)
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                offset: Offset(0, widget.elevation),
                blurRadius: widget.elevation * 2,
              ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          widget.text,
          style: widget.textStyle ??
              TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
        ),
      ),
    );
  }
}
