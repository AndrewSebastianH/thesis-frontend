import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isOutlined;
  final Color? color;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isOutlined = false,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final defaultColor = color ?? const Color(0xFFFF7F50); // Coral

    return isOutlined
        ? OutlinedButton(
          style: OutlinedButton.styleFrom(
            foregroundColor: defaultColor,
            side: BorderSide(color: defaultColor),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: onPressed,
          child: Text(
            text,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        )
        : ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: defaultColor,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: onPressed,
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        );
  }
}
