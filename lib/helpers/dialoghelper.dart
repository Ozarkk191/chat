import 'package:chat/src/base_compoments/dialog/admin_dialog.dart';
import 'package:flutter/material.dart';

class DialogHelper {
  static adminDialog(context) => showDialog(
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
          coverUrl:
              'https://img.kaidee.com/prd/20180718/340041334/b/505c55d5-a967-4188-addc-b234df442c00.jpg',
          profileUrl:
              'https://sites.google.com/site/prawatiswntawpay/_/rsrc/1455021870334/hma-phi-thbul/images.jpg?height=266&width=400',
          username: 'Admin name19',
          status: 'เข้าใช้งานเมื่อ 3 นาทีที่แล้ว',
        ),
      );
}
