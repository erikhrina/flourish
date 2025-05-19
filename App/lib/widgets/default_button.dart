import 'package:flourish/utils/app_theme.dart';
import 'package:flutter/material.dart';

class ButtonWrapper extends StatelessWidget {
  const ButtonWrapper({super.key, required this.onTap, required this.text});

  final void Function() onTap;
  final String text;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14.0),
          backgroundColor: AppTheme.of(context).secondary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontFamily: 'Inter',
            fontSize: 32,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
