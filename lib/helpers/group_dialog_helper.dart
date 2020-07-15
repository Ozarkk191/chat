import 'package:chat/src/base_compoments/dialog/group_dialog.dart';
import 'package:flutter/material.dart';

class GroupDialogHelper {
  static adminDialog({
    context,
    String titleLeft,
    String titleRight,
    String pathIconLeft,
    String pathIconRight,
    String profileUrl,
    String groupName,
    String member,
    String coverUrl,
    String statusGroup,
  }) =>
      showDialog(
        context: context,
        builder: (context) => GroupDialog(
          title1: titleLeft,
          title2: titleRight,
          pathIcon1: pathIconLeft,
          pathIcon2: pathIconRight,
          callbackItem1: () {},
          callbackItem2: () {},
          coverUrl: coverUrl,
          profileUrl: profileUrl,
          groupName: groupName,
          numberUser: member,
          statusGroup: statusGroup,
        ),
      );
}
