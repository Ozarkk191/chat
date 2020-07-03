import 'package:chat/src/base_compoments/button/gradient_button.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OTPRequest extends StatefulWidget {
  @override
  _OTPRequestState createState() => _OTPRequestState();
}

class _OTPRequestState extends State<OTPRequest> {
  var onTapRecognizer;

  @override
  void initState() {
    onTapRecognizer = TapGestureRecognizer()
      ..onTap = () {
        Navigator.pop(context);
      };

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff202020),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 100,
            ),
            Text(
              'Register',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Please enter the OTP code',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: 200,
              // child: PinCodeTextField(
              //   length: 6,
              //   obsecureText: false,
              //   animationType: AnimationType.fade,
              //   shape: PinCodeFieldShape.box,
              //   animationDuration: Duration(milliseconds: 300),
              //   borderRadius: BorderRadius.circular(5),
              //   fieldHeight: 50,
              //   fieldWidth: 40,
              //   onChanged: (value) {
              //     setState(() {
              //       // currentText = value;
              //     });
              //   },
              // ),
              child: PinCodeTextField(
                // enableActiveFill: true,
                length: 4,
                onChanged: (String value) {},
                shape: PinCodeFieldShape.underline,
                backgroundColor: Color(0xff202020),
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                textInputType: TextInputType.number,
                textStyle: TextStyle(color: Colors.white, fontSize: 18),
                inactiveColor: Colors.white,
                disabledColor: Colors.white,
                activeColor: Colors.white,
                selectedColor: Colors.green,
              ),
            ),
            SizedBox(
              height: 50,
            ),
            GradientButton(
                title: 'Submit OTP',
                callBack: () {
                  Navigator.of(context).pushReplacementNamed('/home');
                }),
          ],
        ),
      ),
    );
  }
}
