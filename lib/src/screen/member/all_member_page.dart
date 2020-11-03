import 'package:chat/models/user_model.dart';
import 'package:chat/src/base_compoments/group_item/row_profile_with_name.dart';
import 'package:chat/src/base_compoments/textfield/search_textfield.dart';
import 'package:flutter/material.dart';

class AllMemberPage extends StatefulWidget {
  final List<UserModel> memberList;

  const AllMemberPage({Key key, this.memberList}) : super(key: key);
  @override
  _AllMemberPageState createState() => _AllMemberPageState();
}

class _AllMemberPageState extends State<AllMemberPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff292929),
      appBar: AppBar(
        title: Text('สมาชิกทั้งหมด'),
        backgroundColor: Color(0xff202020),
        leading: InkWell(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.arrow_back_ios)),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 20),
              SearchField(),
              SizedBox(height: 10),
              widget.memberList.length != 0
                  ? Container(
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: widget.memberList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return RowProfileWithName(
                            profileUrl: widget.memberList[index].avatarUrl,
                            displayName: widget.memberList[index].displayName,
                          );
                        },
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
