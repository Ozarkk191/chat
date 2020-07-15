import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat/app_strings/menu_settings.dart';
import 'package:chat/src/base_compoments/button/gradient_button.dart';
import 'package:flutter/material.dart';

class EditProfilPage extends StatefulWidget {
  @override
  _EditProfilPageState createState() => _EditProfilPageState();
}

class _EditProfilPageState extends State<EditProfilPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff292929),
      appBar: AppBar(
        title: Text('Setting'),
        backgroundColor: Color(0xff242424),
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              buildProfile(
                context: context,
                coverUrl: AppString.coverUrl,
                profileUrl: AppString.photoUrl,
              ),
              buildItemProfile(
                  context: context,
                  title: 'ชื่อผู้ใช้',
                  data: AppString.displayName),
              buildItemProfile(
                  context: context, title: 'เพศ', data: AppString.gender),
              buildItemProfile(
                  context: context,
                  title: 'วันเกิด',
                  data: AppString.birthDate),
              buildItemProfile(
                  context: context,
                  title: 'เบอร์โทรศัพท์',
                  data: AppString.phoneNumber),
              buildItemProfile(
                  context: context, title: 'E-mail', data: AppString.email),
              // buildItemProfile(context: context, title: 'รหัสผ่าน', data: '>'),
              SizedBox(height: 50),
              GradientButton(title: 'Submit', callBack: () {}),
            ],
          ),
        ),
      ),
    );
  }

  Container buildItemProfile({
    BuildContext context,
    String title,
    String data,
  }) {
    return Container(
      margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Column(
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                '$title',
                style: TextStyle(color: Colors.grey),
              ),
              Text(
                '$data',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 1,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }

  Container buildProfile({
    Key key,
    BuildContext context,
    String coverUrl,
    String profileUrl,
  }) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 200,
      child: Stack(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: 200,
            child: CachedNetworkImage(
              imageUrl: coverUrl,
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 100,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(1),
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.black.withOpacity(0), Colors.black]),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              width: 100,
              height: 100,
              child: Card(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(100),
                  ),
                ),
                child: Stack(
                  children: <Widget>[
                    Container(
                      width: 100,
                      height: 100,
                      child: CachedNetworkImage(
                        imageUrl: profileUrl,
                        imageBuilder: (context, imageProvider) => Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: imageProvider,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        placeholder: (context, url) =>
                            CircularProgressIndicator(),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 30,
                        width: 100,
                        color: Colors.black.withOpacity(0.7),
                        child: Center(
                          child: Text(
                            'Edit image',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  child: Text(
                    'Edit image',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                  ),
                ),
                Container(
                  width: 40,
                  height: 40,
                  child: Image.asset('assets/images/ic_edit.png'),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
