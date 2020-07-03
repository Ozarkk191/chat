// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:ui_work/models/user_model.dart';

// abstract class UserRepository {
//   Future<List<UserModel>> getUsers();
// }

// class UserRepositoryImp  {
//   final databaseReference = Firestore.instance;
//   List<UserModel> getUsers;
//   @override
//   Future<List<UserModel>> getUsers() async {
//     databaseReference
//       .collection("Users")
//       .getDocuments()
//       .then((QuerySnapshot snapshot) {
//     snapshot.documents.forEach((f) => {

//     });

//   });
//   }
// }
