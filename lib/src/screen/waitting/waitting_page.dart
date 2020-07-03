import 'package:chat/src/base_compoments/group_item/list_waitting_item.dart';
import 'package:chat/src/base_compoments/textfield/search_textfield.dart';
import 'package:flutter/material.dart';

class WaittingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff292929),
      appBar: AppBar(
        title: Text('Waitting list'),
        backgroundColor: Color(0xff202020),
        leading: InkWell(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.arrow_back_ios)),
        actions: <Widget>[
          InkWell(
            onTap: () {},
            child: Container(
              width: 70,
              margin: EdgeInsets.only(right: 10),
              child: Center(
                child: Text('รับทั้งหมด'),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 20),
              SearchField(),
              Container(
                margin: EdgeInsets.fromLTRB(20, 10, 20, 0),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                        child: ListWaittingItem(
                      profileUrl:
                          'https://image.freepik.com/free-vector/cartoon-pug-dog-prisoner-costume-with-sign-illustration_41984-336.jpg',
                      name: 'User Name',
                      groupName: 'Group Name',
                    ));
                  },
                  itemCount: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
