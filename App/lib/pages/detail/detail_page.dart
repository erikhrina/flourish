import 'package:flourish/models/plant_model.dart';
import 'package:flourish/services/objectbox_service.dart';
import 'package:flourish/utils/app_theme.dart';
import 'package:flourish/widgets/back_button.dart';
import 'package:flourish/widgets/default_button.dart';
import 'package:flourish/widgets/info_tile.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:icons_plus/icons_plus.dart';

class DetailPage extends StatefulWidget {
  final PlantModel plant;

  const DetailPage(this.plant, {super.key});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final _objectboxService = GetIt.instance<ObjectboxService>();
  late PlantModel plant;

  @override
  void initState() {
    plant = widget.plant;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          alignment: Alignment(0, -1),
          children: [
            Align(
              alignment: Alignment(-1, -1),
              child: BackButtonWidget(),
            ),
            Image.asset('assets/images/logo.png'),
            Positioned(
              top: 16.0,
              left: 16.0,
              right: 16.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BackButtonWidget(),
                  IconButton(
                    onPressed: () {
                      plant.saved = !plant.saved;
                      if (!plant.saved) plant.lastWatered = null;

                      _objectboxService.savePlant(plant);
                      setState(() {});
                    },
                    icon: Icon(
                      plant.saved
                          ? MingCute.bookmark_fill
                          : MingCute.bookmark_line,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment(0, 1),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: MediaQuery.of(context).size.height / 1.3,
                  minHeight: MediaQuery.of(context).size.height / 1.55,
                ),
                child: IntrinsicHeight(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppTheme.of(context).secondaryBackground,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16.0),
                        topRight: Radius.circular(16.0),
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: 110,
                                height: 2.5,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 26.0,
                            vertical: 20.0,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        plant.name,
                                        style: AppTheme.of(context).titleLarge,
                                      ),
                                      const SizedBox(height: 8.0),
                                      Text(
                                        plant.latin,
                                        style: AppTheme.of(context).titleSmall,
                                      ),
                                    ],
                                  ),
                                  if (plant.lastWatered != null)
                                    _LastWateredWidget(),
                                ],
                              ),
                              const SizedBox(height: 16.0),
                              Column(
                                children: [
                                  InfoTile(
                                    title: 'Category',
                                    description: plant.category,
                                    icon: MingCute.leaf_line,
                                  ),
                                  InfoTile(
                                    title: 'Lighting',
                                    description:
                                        'Ideally: ${plant.idealLight}. Tolerates: ${plant.toleratedLight}.',
                                    icon: MingCute.sun_line,
                                  ),
                                  InfoTile(
                                    title: 'Temperature',
                                    description:
                                        'Min: ${plant.tempMin}°C. Max: ${plant.tempMin}°C.',
                                    icon: MingCute.thermometer_line,
                                  ),
                                  InfoTile(
                                    title: 'Watering',
                                    description: plant.watering,
                                    icon: MingCute.pot_line,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16.0),
                              if (plant.saved)
                                ButtonWrapper(
                                  onTap: () {
                                    plant.lastWatered = 'Today';
                                    _objectboxService.savePlant(plant);
                                    setState(() {});
                                  },
                                  text: 'Water',
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LastWateredWidget extends StatelessWidget {
  const _LastWateredWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      width: 110,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF21AAEF),
            Color(0xFF53BDFF),
            Color(0xFFA9DEFF),
            Colors.white,
          ],
          stops: [0.0, 0.1, 0.5, 1.0],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Last watered',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 12,
                color: Color(0xFF323232),
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              '7 days ago',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
