import 'dart:async';
import 'package:flourish/utils/app_theme.dart';
import 'package:flutter/material.dart';

class SearchWidget extends StatefulWidget {
  const SearchWidget({
    super.key,
    required this.controller,
    required this.onSubmit,
  });

  final TextEditingController controller;
  final void Function() onSubmit;

  @override
  _SearchWidgetState createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  Timer? _debounce;

  void _onChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 300), () {
      widget.onSubmit();
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: TextInputType.text,
      onFieldSubmitted: (_) {
        FocusManager.instance.primaryFocus?.unfocus();
        widget.onSubmit();
      },
      maxLines: 1,
      showCursor: true,
      cursorColor: AppTheme.of(context).primary,
      decoration: InputDecoration(
        hintText: 'Search',
        filled: true,
        fillColor: Colors.white,
        hintStyle: AppTheme.of(context).labelSmall.copyWith(
              color: const Color(0xFF414141),
            ),
        prefixIcon: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 14.0,
          ),
          child: InkWell(
            onTap: widget.onSubmit,
            child: Icon(
              Icons.search,
              color: const Color(0xFF000000),
              weight: 300,
              size: 32,
            ),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.transparent,
            width: 0,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.transparent,
            width: 0,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      style: AppTheme.of(context).primaryMedium,
      onChanged: _onChanged,
      onTapOutside: (_) {
        FocusManager.instance.primaryFocus?.unfocus();
        widget.onSubmit();
      },
    );
  }
}
