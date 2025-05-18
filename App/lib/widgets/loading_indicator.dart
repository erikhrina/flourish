import 'package:flourish/utils/app_theme.dart';
import 'package:flutter/material.dart';

class LoadingIndicatorWrapper extends StatelessWidget {
  const LoadingIndicatorWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      color: AppTheme.of(context).primary,
    );
  }
}
