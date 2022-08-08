import 'package:flutter/material.dart';

class TileWidgetContent {
  static List<Widget> contentList(List<String> content, Function redirect) {
    List<Widget> subExpansionTileWidget = [];
    for (int i = 0; i < content.length; i++) {
      subExpansionTileWidget.add(
        TextButton(
          onPressed: () {
            redirect(content[i]);
          },
          child: Text(
            content[i],
            style: const TextStyle(color: Colors.white),
          ),
        ),
      );
    }
    return subExpansionTileWidget;
  }
}
