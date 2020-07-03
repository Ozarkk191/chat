import 'package:chat/src/screen/scan_qr/scan_qrcode_page.dart';
import 'package:flutter/material.dart';

class SearchField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 1.2,
      height: 40,
      child: Stack(
        children: <Widget>[
          TextField(
            decoration: InputDecoration(
              hintText: 'ค้นหา',
              prefixIcon: Icon(
                Icons.search,
              ),
              filled: true,
              fillColor: Color(0xff707070),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(5.0),
                ),
                borderSide: BorderSide(style: BorderStyle.none, width: 0),
              ),
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
