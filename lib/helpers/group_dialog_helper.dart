import 'package:chat/src/base_compoments/dialog/group_dialog.dart';
import 'package:flutter/material.dart';

class GroupDialogHelper {
  static adminDialog({
    BuildContext context,
    String titleLeft,
    String pathIconLeft,
    String profileUrl,
    String groupName,
    String member,
    String coverUrl,
    String statusGroup,
    Function callbackItem1,
  }) =>
      showDialog(
        context: context,
        builder: (context) => GroupDialog(
          title1: titleLeft,
          pathIcon1: pathIconLeft,
          callbackItem1: callbackItem1,
          coverUrl: coverUrl,
          profileUrl: profileUrl,
          groupName: groupName,
          numberUser: member,
          statusGroup: statusGroup,
        ),
      );
}
