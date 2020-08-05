import 'package:chat/src/base_compoments/dialog/delete_account_dialog.dart';
import 'package:chat/src/base_compoments/dialog/user_dialog.dart';
import 'package:flutter/material.dart';

class UserDialogHelper {
  static adminDialog({
    BuildContext context,
    String profileUrl,
    String username,
    String coverUrl,
    Function callbackItem1,
    Function callbackItem2,
  }) =>
      showDialog(
        context: context,
        builder: (context) => UserDialog(
          title1: 'Group',
          title2: 'Delete',
          pathIcon1: 'assets/images/ic_group.png',
          pathIcon2: 'assets/images/ic_trash.png',
          callbackItem1: callbackItem1,
          callbackItem2: callbackItem2,
          coverUrl: coverUrl,
          profileUrl: profileUrl,
          username: username,
        ),
      );
}

class DeleteAccountDialogHelpers {
  static delete(context) => showDialog(
        context: context,
        builder: (context) => DeleteAccountDialog(),
      );
}
