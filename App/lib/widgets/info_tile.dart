import 'package:flourish/utils/app_theme.dart';
import 'package:flutter/material.dart';

class InfoTile extends StatelessWidget {
  const InfoTile({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
  });

  final String title;
  final String description;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Container(
        constraints: const BoxConstraints(minHeight: 60),
        decoration: BoxDecoration(
          color: AppTheme.of(context).tertiaryBackground,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Icon(
                icon,
                color: Colors.black,
                size: 34,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTheme.of(context).titleSmall),
                    Text(
                      description,
                      style: AppTheme.of(context).primaryMedium,
                      overflow: TextOverflow.clip,
                      maxLines: null,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
