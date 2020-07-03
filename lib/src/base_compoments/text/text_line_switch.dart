import 'package:custom_switch_button/custom_switch_button.dart';
import 'package:flutter/material.dart';

class TextLineSwitch extends StatelessWidget {
  final BuildContext context;
  final String title;
  final Function onTap;
  final bool isChecked;

  const TextLineSwitch({
    Key key,
    @required this.context,
    @required this.title,
    @required this.isChecked,
    @required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              Container(
                height: 20,
                child: InkWell(
                  onTap: onTap,
                  child: CustomSwitchButton(
                    animationDuration: Duration(milliseconds: 400),
                    backgroundColor: isChecked ? Colors.green : Colors.grey,
                    unCheckedColor: Colors.white,
                    checkedColor: Colors.white,
                    checked: isChecked,
                  ),
                ),
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
}
