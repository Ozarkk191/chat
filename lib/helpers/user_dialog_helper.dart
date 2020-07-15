import 'package:chat/src/base_compoments/dialog/delete_account_dialog.dart';
import 'package:chat/src/base_compoments/dialog/user_dialog.dart';
import 'package:flutter/material.dart';

class UserDialogHelper {
  static adminDialog({
    BuildContext context,
    String profileUrl,
    String username,
  }) =>
      showDialog(
        context: context,
        builder: (context) => UserDialog(
          title1: 'Group',
          title2: 'Delete',
          pathIcon1: 'assets/images/ic_group.png',
          pathIcon2: 'assets/images/ic_trash.png',
          callbackItem1: () {},
          callbackItem2: () {},
          coverUrl:
              'https://firebasestorage.googleapis.com/v0/b/chat-ae407.appspot.com/o/2020-07-13_15%3A55%3A08.422616?alt=media&token=99b504a0-6eba-42f0-875d-7afed05c2130',
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
