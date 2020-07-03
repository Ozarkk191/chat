import 'package:chat/bloc/validate_bloc/validate_bloc.dart';
import 'package:chat/services/authservice.dart';
import 'package:chat/src/base_compoments/button/gradient_button.dart';
import 'package:chat/src/base_compoments/textfield/custom_textfield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final FirebaseMessaging _messaging = FirebaseMessaging();

  String _firstname = "";
  String _lastname = "";
  String _email = "";
  String _phoneNo, verificationId, smsCode;
  bool codeSent = false;

  @override
  void initState() {
    super.initState();
    _messaging.getToken().then((token) {
      print("token :: $token");
    });
  }

  @override
  Widget build(BuildContext context) {
    //ignore: close_sinks
    final ValidateBloc _bloc = context.bloc<ValidateBloc>();
    return Scaffold(
      backgroundColor: Color(0xff202020),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 100,
              ),
              Container(
                alignment: Alignment.center,
                width: 120,
                child: Image.asset('assets/images/logo.png'),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                'Register',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              SizedBox(
                height: 30,
              ),
              BlocBuilder<ValidateBloc, ValidateState>(
                builder: (BuildContext context, ValidateState state) {
                  if (state is FirstnameErrorField) {
                    return CustomTextField(
                      hint: 'first name',
                      onChanged: (value) {
                        _bloc.add(FirstnameField(value: value));
                        setState(() {
                          _firstname = value;
                        });
                      },
                      errorText: state.errorText,
                    );
                  } else {
                    return CustomTextField(
                      hint: 'first name',
                      onChanged: (value) {
                        _bloc.add(FirstnameField(value: value));
                        setState(() {
                          _firstname = value;
                        });
                      },
                    );
                  }
                },
              ),
              SizedBox(
                height: 10,
              ),
              BlocBuilder<ValidateBloc, ValidateState>(
                builder: (BuildContext context, ValidateState state) {
                  if (state is LastnameErrorField) {
                    return CustomTextField(
                      hint: 'last name',
                      onChanged: (value) {
                        _bloc.add(LastnameField(value: value));
                        setState(() {
                          _lastname = value;
                        });
                      },
                      errorText: state.errorText,
                    );
                  } else {
                    return CustomTextField(
                      hint: 'last name',
                      onChanged: (value) {
                        _bloc.add(LastnameField(value: value));
                        setState(() {
                          _lastname = value;
                        });
                      },
                    );
                  }
                },
              ),
              SizedBox(
                height: 10,
              ),
              BlocBuilder<ValidateBloc, ValidateState>(
                builder: (BuildContext context, ValidateState state) {
                  if (state is PhoneErrorField) {
                    return CustomTextField(
                      hint: 'phone',
                      keyboardType: TextInputType.phone,
                      onChanged: (value) {
                        _bloc.add(PhoneField(value: value));
                        setState(() {
                          if (value.length == 10) {
                            this._phoneNo = "+66${value.substring(1, 10)}";
                            print("${this._phoneNo}");
                          }
                        });
                      },
                      errorText: state.errorText,
                    );
                  } else {
                    return CustomTextField(
                      hint: 'phone',
                      keyboardType: TextInputType.phone,
                      onChanged: (value) {
                        _bloc.add(PhoneField(value: value));
                        setState(() {
                          if (value.length == 10) {
                            this._phoneNo = "+66${value.substring(1, 10)}";
                            print("${this._phoneNo}");
                          }
                        });
                      },
                    );
                  }
                },
              ),
              SizedBox(
                height: 10,
              ),
              BlocBuilder<ValidateBloc, ValidateState>(
                builder: (BuildContext context, ValidateState state) {
                  if (state is EmailErrorField) {
                    return CustomTextField(
                      hint: 'e-mail',
                      onChanged: (value) {
                        _bloc.add(EmailField(value: value));
                        setState(() {
                          _email = value;
                        });
                      },
                      errorText: state.errorText,
                    );
                  } else {
                    return CustomTextField(
                      hint: 'e-mail',
                      onChanged: (value) {
                        _bloc.add(EmailField(value: value));
                        setState(() {
                          _email = value;
                        });
                      },
                    );
                  }
                },
              ),
              SizedBox(
                height: 30,
              ),
              GradientButton(
                title: 'Submit',
                callBack: !_check()
                    ? null
                    : () {
                        verifyPhone(_phoneNo);
                      },
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _check() {
    if (_email == "" || _firstname == "" || _lastname == "" || _phoneNo == "") {
      return false;
    } else {
      return true;
    }
  }

  Future<void> verifyPhone(phoneNo) async {
    final PhoneVerificationCompleted verified = (AuthCredential authResult) {
      AuthService().signIn(authResult);
    };

    final PhoneVerificationFailed verificationfailed =
        (AuthException authException) {
      print('${authException.message}');
    };

    final PhoneCodeSent smsSent = (String verId, [int forceResend]) {
      this.verificationId = verId;
      setState(() {
        this.codeSent = true;
      });
    };

    final PhoneCodeAutoRetrievalTimeout autoTimeout = (String verId) {
      this.verificationId = verId;
    };

    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNo,
        timeout: const Duration(seconds: 5),
        verificationCompleted: verified,
        verificationFailed: verificationfailed,
        codeSent: smsSent,
        codeAutoRetrievalTimeout: autoTimeout);
  }
}
