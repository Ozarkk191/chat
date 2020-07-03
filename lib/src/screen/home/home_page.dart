import 'package:chat/app_strings/menu_settings.dart';
import 'package:chat/helpers/dialoghelper.dart';
import 'package:chat/helpers/group_dialog_helper.dart';
import 'package:chat/helpers/user_dialog_helper.dart';
import 'package:chat/src/base_compoments/card/profile_card.dart';
import 'package:chat/src/base_compoments/group_item/list_admin_item.dart';
import 'package:chat/src/base_compoments/group_item/list_group_item.dart';
import 'package:chat/src/base_compoments/group_item/list_user_item.dart';
import 'package:chat/src/base_compoments/text/text_and_line.dart';
import 'package:chat/src/base_compoments/textfield/search_textfield.dart';
import 'package:chat/src/screen/settingpage/edit_profile_page.dart';
import 'package:chat/src/screen/settingpage/setting_page.dart';
import 'package:chat/src/screen/waitting/waitting_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff202020),
      appBar: AppBar(
        title: Text('Home'),
        backgroundColor: Color(0xff242424),
        actions: <Widget>[
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SettingPage()));
            },
            child: Image.asset('assets/images/ic_setting.png'),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              SearchField(),
              buildMyProfile(
                profileUrl: AppString.photoUrl,
                context: context,
                displayName: AppString.displayName,
              ),
              TextAndLine(
                title: 'Admin',
              ),
              Container(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        DialogHelper.adminDialog(context);
                      },
                      child: ListAdminItem(
                        profileUrl:
                            'https://sites.google.com/site/prawatiswntawpay/_/rsrc/1455021870334/hma-phi-thbul/images.jpg?height=266&width=400',
                        adminName: 'Admin Name',
                        callback: () {},
                        status: 'online',
                      ),
                    );
                  },
                  itemCount: 3,
                ),
              ),
              TextAndLine(title: '"Waitting list"'),
              SizedBox(
                height: 5,
              ),
              InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => WaittingPage()));
                },
                child: Row(
                  children: <Widget>[
                    ProfileCard(
                      profileUrl:
                          'https://i.pinimg.com/736x/0f/c3/e7/0fc3e7cea3075c7a5c231ca73e60a6e9.jpg',
                      width: 50,
                      height: 50,
                    ),
                    Expanded(
                      child: Text(
                        'user1200,user1122,user2500...20+',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
              TextAndLine(title: 'Group'),
              SizedBox(
                height: 5,
              ),
              Container(
                height: 160,
                child: ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          GroupDialogHelper.adminDialog(
                            context,
                            'Group',
                            'Delete',
                            'assets/images/ic_group.png',
                            'assets/images/ic_trash.png',
                          );
                        },
                        child: ListGroupItem(
                          imgCoverUrl:
                              'https://i.pinimg.com/originals/a8/b2/6a/a8b26abdd653ad71d19ca2b63db68dae.jpg',
                          imgGroupUrl:
                              'https://wallpapercave.com/wp/w1fkwPh.jpg',
                          nameGroup: 'Group name',
                          numberUser: '9,999',
                        ),
                      );
                    },
                    itemCount: 6,
                    scrollDirection: Axis.horizontal),
              ),
              SizedBox(
                height: 5,
              ),
              TextAndLine(title: 'User'),
              SizedBox(
                height: 5,
              ),
              Container(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        UserDialogHelper.adminDialog(context);
                      },
                      child: ListUserItem(
                        profileUrl:
                            'https://i.pinimg.com/736x/0f/c3/e7/0fc3e7cea3075c7a5c231ca73e60a6e9.jpg',
                        userName: 'User Name',
                        callback: () {},
                      ),
                    );
                  },
                  itemCount: 5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container buildMyProfile(
      {String profileUrl, BuildContext context, String displayName}) {
    return Container(
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          ProfileCard(
            profileUrl: profileUrl,
            width: 70,
            height: 70,
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  '$displayName',
                  style: TextStyle(color: Colors.grey, fontSize: 18),
                ),
                Text(
                  'Full Premission',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => EditProfilPage()));
            },
            child: Container(
              width: 40,
              height: 20,
              child: Center(
                child: Text(
                  'edit',
                  style: TextStyle(color: Colors.grey, fontSize: 10),
                ),
              ),
              decoration: BoxDecoration(
                color: Color(0xff202020),
                border: Border.all(width: 1, color: Color(0xff9B9B9B)),
                borderRadius: new BorderRadius.all(Radius.circular(5.0)),
              ),
            ),
          )
        ],
      ),
    );
  }
}
