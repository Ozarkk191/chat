import 'package:chat/src/base_compoments/dialog/admin_dialog.dart';
import 'package:flutter/material.dart';

class DialogHelper {
  static adminDialog(
    context,
    String profileUrl,
    String username,
    String coverUrl,
  ) =>
      showDialog(
        context: context,
        builder: (context) => AdminDialog(
          title1: 'Chat',
          title2: 'Block and Ban',
          title3: 'Delete',
          pathIcon1: 'assets/images/ic_chat.png',
          pathIcon2: 'assets/images/ic_block.png',
          pathIcon3: 'assets/images/ic_trash.png',
          callbackItem1: () {},
          callbackItem2: () {},
          callbackItem3: () {},
          coverUrl: coverUrl,
          profileUrl: profileUrl,
          username: username,
          status: 'เข้าใช้งานเมื่อ 3 นาทีที่แล้ว',
        ),
      );
}
