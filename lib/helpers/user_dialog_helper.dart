import 'package:chat/src/base_compoments/dialog/delete_account_dialog.dart';
import 'package:chat/src/base_compoments/dialog/user_dialog.dart';
import 'package:flutter/material.dart';

class UserDialogHelper {
  static adminDialog(context) => showDialog(
        context: context,
        builder: (context) => UserDialog(
          title1: 'Group',
          title2: 'Delete',
          pathIcon1: 'assets/images/ic_group.png',
          pathIcon2: 'assets/images/ic_trash.png',
          callbackItem1: () {},
          callbackItem2: () {},
          coverUrl:
              'https://img.kaidee.com/prd/20180718/340041334/b/505c55d5-a967-4188-addc-b234df442c00.jpg',
          profileUrl:
              'https://sites.google.com/site/prawatiswntawpay/_/rsrc/1455021870334/hma-phi-thbul/images.jpg?height=266&width=400',
          username: 'User name',
        ),
      );
}

class DeleteAccountDialogHelpers {
  static delete(context) =>
      showDialog(context: context, builder: (context) => DeleteAccountDialog());
}
