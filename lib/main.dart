import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
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
        statusBarColor: Color(0xf202020),
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

        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          DefaultCupertinoLocalizations.delegate,
          GlobalCupertinoLocalizations
              .delegate, // Add global cupertino localiztions.
        ],
        locale: Locale('th', 'TH'), // Current locale
        supportedLocales: [
          const Locale('en', 'US'), // English
          const Locale('th', 'TH'), // Thai
        ],
        title: 'Flutter Demo',
        initialRoute: '/splash',
        routes: {
          '/splash': (context) => SplashPage(),
          '/login': (context) => LoginPage(),
          '/register': (context) => RegisterPage(),
          '/home': (context) => HomePage(),
          '/editprofile': (context) => EditProfilPage(),
          '/navhome': (context) => TestNav(),
          '/navuserhome': (context) => UserNavBottom(),
          '/data': (context) => DataCollectPage(),
          '/setting': (context) => SettingPage(),
        },
        theme: ThemeData(
          primarySwatch: Colors.blue,
          accentColor: Colors.green,
          // brightness: Brightness.dark,
          canvasColor: Colors.transparent,
        ),
      ),
    );
  }
}
