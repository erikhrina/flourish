import 'package:flourish/models/plant_model.dart';
import 'package:flourish/services/objectbox_service.dart';
import 'package:flourish/utils/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:icons_plus/icons_plus.dart';

class ListTileWidget extends StatelessWidget {
  const ListTileWidget(
    this.plantModel, {
    required this.onTap,
    this.showRemove = false,
    super.key,
  });

  final PlantModel plantModel;
  final bool showRemove;
  final void Function(PlantModel model, bool remove) onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 4.0,
        horizontal: 8.0,
      ),
      child: InkWell(
        onTap: () => onTap(plantModel, false),
        splashFactory: InkRipple.splashFactory,
        splashColor: AppTheme.of(context).primary.withAlpha(160),
        borderRadius: BorderRadius.circular(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                child: Row(
                  children: [
                    Container(
                      height: 90,
                      width: 90,
                      decoration: BoxDecoration(
                        color: AppTheme.of(context).primaryBackground,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: _buildPlantImage(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            plantModel.name,
                            style: AppTheme.of(context).labelSmall,
                          ),
                          if (plantModel.saved)
                            Text(
                              plantModel.lastWatered ?? 'Not watered yet',
                              style: AppTheme.of(context).primaryMedium,
                            ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              if (showRemove)
                IconButton(
                  onPressed: () => onTap(plantModel, true),
                  splashRadius: 20,
                  splashColor: AppTheme.of(context).primary.withAlpha(160),
                  icon: Icon(
                    MingCute.close_line,
                    size: 16,
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlantImage() {
    final plantImagePath = 'assets/images/${plantModel.name}.jpg';
    final fallbackImagePath = 'assets/images/logo.png';

    return Image.asset(
      plantImagePath,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Image.asset(
          fallbackImagePath,
          fit: BoxFit.cover,
        );
      },
    );
  }
}
