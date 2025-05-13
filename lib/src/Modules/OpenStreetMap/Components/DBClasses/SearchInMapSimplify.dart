import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pointer_interceptor/pointer_interceptor.dart';


class SearchInMap extends StatefulWidget {
  final MapController controller;
  final FocusNode searchFocusNode;
  final Function(String) onSearch;
  final String? hintText;
  final bool? isDeparture;

  const SearchInMap({
    super.key,
    required this.searchFocusNode,
    required this.onSearch,
    required this.controller,
    this.hintText,
    this.isDeparture,d
  });

  @override
  State<StatefulWidget> createState() => _SearchInMapState();
}

class _SearchInMapState extends State<SearchInMap> {
  final textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    textController.addListener(onTextChanged);
    widget.searchFocusNode.addListener(() {
      if (widget.searchFocusNode.hasFocus) {
        textController.selection = TextSelection(
          baseOffset: 0,
          extentOffset: textController.text.length,
        );
      }
    });
    print('SearchInMap initialized with controller: ${widget.controller}');
  }

  void onTextChanged() {}

  @override
  void dispose() {
    textController.removeListener(onTextChanged);
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('Building SearchInMap');
    return PointerInterceptor(
      child: GestureDetector(
        onTap: () {
          print('SearchInMap GestureDetector tapped');
          FocusScope.of(context).requestFocus(widget.searchFocusNode);
        },
        child: SizedBox(
          height: 48,
          child: Card(
            color: Colors.white,
            elevation: 2,
            shape: const StadiumBorder(),
            child: TextField(
              controller: textController,
              focusNode: widget.searchFocusNode,
              onSubmitted: (query) {
                print('SearchInMap onSubmitted: $query');
                widget.onSearch(query);
              },
              maxLines: 1, 
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                filled: false,
                isDense: true,
                hintText: widget.hintText ?? 'search',
                prefixIcon: const Icon(
                  Icons.search,
                  size: 22,
                ),
                border: const OutlineInputBorder(
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
