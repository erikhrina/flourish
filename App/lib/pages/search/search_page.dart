import 'package:flourish/models/plant_model.dart';
import 'package:flourish/objectbox.g.dart';
import 'package:flourish/services/objectbox_service.dart';
import 'package:flourish/utils/app_theme.dart';
import 'package:flourish/widgets/generic_list.dart';
import 'package:flourish/widgets/navigation_bar.dart';
import 'package:flourish/widgets/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _objectboxService = GetIt.instance<ObjectboxService>();
  late TextEditingController _searchController;
  List<PlantModel> results = [];

  @override
  void initState() {
    _searchController = TextEditingController();
    results = _fetchData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.of(context).primaryBackground,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 32.0,
            left: 16.0,
            right: 16.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SearchWidget(
                controller: _searchController,
                onSubmit: () {
                  results = _fetchData();
                  setState(() {});
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Recent',
                      style: AppTheme.of(context).titleLarge,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: GenericList(
                  results,
                  enableRefresh: false,
                  showRemove: true,
                  onTap: (PlantModel model, bool remove) {
                    model.recent = !remove;
                    _objectboxService.savePlant(model);
                    results = _fetchData();
                    setState(() {});
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: NavigationBarWrapper('search'),
    );
  }

  List<PlantModel> _fetchData() {
    if (_searchController.text.isNotEmpty &&
        _searchController.text.length >= 3) {
      return _objectboxService.getPlants(
        condition: PlantModel_.name.contains(
          _searchController.text,
          caseSensitive: false,
        ),
      );
    } else {
      return _objectboxService.getPlants(
        condition: PlantModel_.recent.equals(true),
      );
    }
  }
}
