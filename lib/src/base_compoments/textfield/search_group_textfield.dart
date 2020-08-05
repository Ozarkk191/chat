import 'package:flutter/material.dart';

class SearchGroupTextField extends StatelessWidget {
  final TextEditingController controller;
  final Function callback;
  final Function onSubmitted;

  const SearchGroupTextField({
    Key key,
    this.controller,
    this.callback,
    this.onSubmitted,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 1.2,
      decoration: BoxDecoration(
          color: Color(0xffffffff),
          border: Border.all(
              width: 1,
              color: Colors.black //                   <--- border width here
              ),
          borderRadius: BorderRadius.all(Radius.circular(5))),
      height: 40,
      child: Stack(
        children: <Widget>[
          InkWell(
            child: TextField(
              controller: controller,
              textInputAction: TextInputAction.search,
              textAlign: TextAlign.center,
              cursorColor: Colors.black,
              onSubmitted: onSubmitted,
              decoration: InputDecoration(
                  hintText: 'ค้นหา',
                  filled: false,
                  border: InputBorder.none,
                  focusColor: Colors.black),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: callback,
              child: Container(
                margin: EdgeInsets.only(right: 10),
                child: Icon(
                  Icons.search,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
