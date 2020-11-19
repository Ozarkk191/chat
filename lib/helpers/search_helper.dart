import 'package:chat/src/base_compoments/dialog/search_dialog.dart';
import 'package:flutter/material.dart';

class SearchDialogHP {
  static searchDialog({
    BuildContext context,
  }) =>
      showDialog(
        context: context,
        builder: (context) => SearchDialog(),
      );
}
