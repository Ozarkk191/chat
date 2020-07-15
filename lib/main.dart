import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/validate_bloc/validate_bloc.dart';
import 'src/screen/home/home_page.dart';
import 'src/screen/login/login_page.dart';
import 'src/screen/navigator/text_nav.dart';
import 'src/screen/navigator/user_nav_bottom.dart';

import 'src/screen/register/data_collect_page.dart';
import 'src/screen/register/register_page.dart';
import 'src/screen/settingpage/edit_profire/edit_profile_page.dart';
import 'src/screen/settingpage/setting_page.dart';
import 'src/screen/splash/splash_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) => ValidateBloc(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        initialRoute: '/splash',
        routes: {
          '/splash': (context) => SplashPage(),
          '/login': (context) => LoginPage(),
          '/register': (context) => RegisterPage(),
          // '/otp': (context) => OTPRequest(),
          '/home': (context) => HomePage(),
          '/editprofile': (context) => EditProfilPage(),
          '/navhome': (context) => TestNav(),
          '/navuserhome': (context) => UserNavBottom(),
          '/data': (context) => DataCollectPage(),
          '/setting': (context) => SettingPage(),
        },
        theme: ThemeData(
          primarySwatch: Colors.blue,
          canvasColor: Colors.transparent,
        ),
      ),
    );
  }
}
