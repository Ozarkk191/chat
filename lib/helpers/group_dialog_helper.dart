import 'package:chat/src/base_compoments/dialog/group_dialog.dart';
import 'package:flutter/material.dart';

class GroupDialogHelper {
  static adminDialog(
    context,
    String titleLeft,
    String titleRight,
    String pathIconLeft,
    String pathIconRight,
  ) =>
      showDialog(
        context: context,
        builder: (context) => GroupDialog(
          title1: titleLeft,
          title2: titleRight,
          pathIcon1: pathIconLeft,
          pathIcon2: pathIconRight,
          callbackItem1: () {},
          callbackItem2: () {},
          coverUrl:
              'https://img.kaidee.com/prd/20180718/340041334/b/505c55d5-a967-4188-addc-b234df442c00.jpg',
          profileUrl:
              'https://sites.google.com/site/prawatiswntawpay/_/rsrc/1455021870334/hma-phi-thbul/images.jpg?height=266&width=400',
          groupName: 'Group Name',
          numberUser: '9,999',
        ),
      );
}
