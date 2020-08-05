import 'package:chat/src/screen/scan_qr/scan_qrcode_page.dart';
import 'package:flutter/material.dart';

class SearchField extends StatelessWidget {
  final bool enable;
  final Function onChanged;
  final Function callback;
  final TextEditingController controller;

  const SearchField({
    Key key,
    this.enable = true,
    this.onChanged,
    this.controller,
    this.callback,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 1.2,
      decoration: BoxDecoration(
          color: Color(0xff707070),
          borderRadius: BorderRadius.all(Radius.circular(5))),
      height: 40,
      child: Stack(
        children: <Widget>[
          InkWell(
            onTap: enable ? null : callback,
            child: TextField(
              enabled: enable,
              controller: controller,
              textAlign: TextAlign.justify,
              cursorColor: Colors.black,
              onChanged: onChanged,
              decoration: InputDecoration(
                  hintText: 'ค้นหา',
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.black,
                  ),
                  filled: false,
                  border: InputBorder.none,
                  focusColor: Colors.black),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: InkWell(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ScanQRcodePage()));
              },
              child: Container(
                  margin: EdgeInsets.only(right: 10),
                  child: Image.asset('assets/images/ic_scan_qrcode.png')),
            ),
          ),
        ],
      ),
    );
  }
}
