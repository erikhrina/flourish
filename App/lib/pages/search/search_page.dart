import 'package:flourish/models/plant_model.dart';
import 'package:flourish/objectbox.g.dart';
import 'package:flourish/pages/detail/detail_page.dart';
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

  bool isSearching = false;

  @override
  void initState() {
    _searchController = TextEditingController();
    results = _fetchData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                        isSearching ? 'Results' : 'Recent',
                        style: AppTheme.of(context).titleLarge,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: GenericList(
                    results,
                    enableRefresh: false,
                    showRemove: !isSearching,
                    onTap: (PlantModel model, bool remove) {
                      model.recent = !remove;
                      _objectboxService.savePlant(model);
                      results = _fetchData();

                      if (!remove) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailPage(model),
                          ),
                        ).then((_) => setState(() {}));
                      } else {
                        setState(() {});
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: NavigationBarWrapper('search'),
      ),
    );
  }

  List<PlantModel> _fetchData() {
    String searchText = _searchController.text;
    if (searchText.isNotEmpty && searchText.length >= 3) {
      isSearching = true;
      return _objectboxService.getPlants(
        condition: PlantModel_.name
            .contains(
              searchText,
              caseSensitive: false,
            )
            .or(
              PlantModel_.latin.contains(
                searchText,
                caseSensitive: false,
              ),
            ),
      );
    } else {
      isSearching = false;
      return _objectboxService.getPlants(
        condition: PlantModel_.recent.equals(true),
      );
    }
  }
}
