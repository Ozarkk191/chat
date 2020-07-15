// import 'package:chat/models/group_model.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class CreateGroup extends StatefulWidget {
//   @override
//   _CreateGroupState createState() => _CreateGroupState();
// }

// class _CreateGroupState extends State<CreateGroup> {
//   List<String> _memberUID = List<String>();
//   String _nameGroup = "";
//   @override
//   void initState() {
//     super.initState();
//     _createGroup();
//   }

//   void _createGroup() {
//     _memberUID.add('value1');
//     _memberUID.add('value2');
//     _memberUID.add('value3');
//     var now = new DateTime.now();
//     var now2 = now.toString().replaceAll(" ", "_");
//     var group = GroupModel(
//       avatarGroup:
//           'https://www.mangozero.com/wp-content/uploads/2017/07/things-to-know-about-peanuts-cartoon-6.jpg',
//       nameGroup: _nameGroup,
//       memberUIDList: _memberUID,
//     );
//     Firestore.instance
//         .collection('Rooms')
//         .document('chats')
//         .collection('Group')
//         .document(now2)
//         .setData(group.toJson());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xff292929),
//       body: SafeArea(
//         child: Column(
//           children: <Widget>[
//             AppBar(
//               backgroundColor: Color(0xff202020),
//               title: Text("สร้างกลุ่มใหม่"),
//               leading: InkWell(
//                 onTap: () {
//                   Navigator.pop(context);
//                 },
//                 child: Icon(Icons.arrow_back_ios),
//               ),
//               actions: <Widget>[
//                 InkWell(
//                   onTap: () {},
//                   child: Padding(
//                     padding: const EdgeInsets.all(20),
//                     child: Icon(Icons.person_add),
//                   ),
//                 )
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
