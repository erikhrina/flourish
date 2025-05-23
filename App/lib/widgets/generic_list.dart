import 'package:flourish/models/plant_model.dart';
import 'package:flourish/utils/app_theme.dart';
import 'package:flourish/widgets/keep_alive_wrapper.dart';
import 'package:flourish/widgets/list_tile.dart';
import 'package:flutter/material.dart';

class GenericList extends StatefulWidget {
  final List<dynamic> data;
  final void Function(PlantModel model, bool remove) onTap;
  final bool enableRefresh;
  final void Function()? notifyParent;
  final bool showRemove;

  const GenericList(
    this.data, {
    required this.onTap,
    this.enableRefresh = false,
    this.notifyParent,
    this.showRemove = false,
    super.key,
  });

  @override
  State<GenericList> createState() => _GenericListState();
}

class _GenericListState extends State<GenericList> {
  @override
  Widget build(BuildContext context) {
    return KeepAliveWidgetWrapper(
      builder: (context) => widget.enableRefresh
          ? RefreshIndicator(
              color: AppTheme.of(context).primary,
              backgroundColor: Colors.white,
              elevation: 0,
              onRefresh: () async {
                if (widget.notifyParent != null) {
                  widget.notifyParent!();
                }
              },
              child: _buildListView(),
            )
          : _buildListView(),
    );
  }

  Widget _buildListView() {
    return widget.data.isNotEmpty
        ? ListView(
            padding: EdgeInsets.zero,
            addAutomaticKeepAlives: true,
            children: List.generate(
              widget.data.length,
              (index) => KeepAliveWidgetWrapper(
                builder: (context) => ListTileWidget(
                  widget.data[index],
                  showRemove: widget.showRemove,
                  onTap: widget.onTap,
                ),
              ),
            ),
          )
        : _NoDataPlaceholder();
  }
}

class _NoDataPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: AlwaysScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.only(top: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Nothing in here...',
              style: AppTheme.of(context).primaryLarge,
            ),
          ],
        ),
      ),
    );
  }
}
