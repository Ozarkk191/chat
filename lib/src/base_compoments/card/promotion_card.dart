import 'package:flutter/material.dart';

import 'profile_card.dart';

class PromotionCard extends StatelessWidget {
  final String imageUrlGroup;
  final String imageUrlPromotion;
  final String nameGroup;
  final String status;
  final String description;
  final Function callback;

  const PromotionCard({
    Key key,
    @required this.imageUrlGroup,
    @required this.imageUrlPromotion,
    @required this.nameGroup,
    @required this.status,
    @required this.description,
    @required this.callback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        child: Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Container(
                width: MediaQuery.of(context).size.width,
                height: 80,
                margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    ProfileCard(
                      profileUrl: imageUrlGroup,
                      width: 50,
                      height: 50,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            nameGroup,
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            status,
                            style: TextStyle(fontSize: 10, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 80,
                      child: RaisedButton(
                        onPressed: callback,
                        color: Colors.black,
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.add,
                              size: 12,
                              color: Colors.white,
                            ),
                            Text(
                              'เข้ากลุ่ม',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 10),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 1,
                color: Colors.grey,
                margin: EdgeInsets.fromLTRB(20, 0, 20, 10),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.fromLTRB(20, 0, 20, 10),
                child: Text(
                  description,
                  style: TextStyle(fontSize: 12),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                height: 250,
                margin: EdgeInsets.fromLTRB(20, 0, 20, 20),
                child: Image.network(
                  imageUrlPromotion,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
