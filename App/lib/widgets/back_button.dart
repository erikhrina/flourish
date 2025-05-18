import 'package:flourish/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:icons_plus/icons_plus.dart';

class BackButtonWidget extends StatelessWidget {
  const BackButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent, // Ensure transparency for splash effect
      child: Ink(
        decoration: BoxDecoration(
          color: AppTheme.of(context).primaryBackground,
          borderRadius: BorderRadius.circular(25),
        ),
        child: InkWell(
          onTap: () => Navigator.of(context).pop(),
          borderRadius: BorderRadius.circular(25),
          splashColor: AppTheme.of(context).primary.withAlpha(160),
          child: SizedBox(
            height: 42,
            width: 42,
            child: Center(
              child: Icon(
                MingCute.left_line,
                color: AppTheme.of(context).primaryText,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
