import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'src/screen/home/home_page.dart';
import 'src/screen/login/login_page.dart';
import 'src/screen/navigator/text_nav.dart';
import 'src/screen/navigator/user_nav_bottom.dart';

import 'src/screen/register/data_collect_page.dart';
import 'src/screen/settingpage/edit_profire/edit_profile_page.dart';
import 'src/screen/settingpage/setting_page.dart';
import 'src/screen/splash/splash_page.dart';

void main() async {
  runApp(
    MyApp(),
  );
}

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

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        DefaultCupertinoLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: Locale('th', 'TH'),
      supportedLocales: [
        const Locale('en', 'US'),
        const Locale('th', 'TH'),
      ],
      title: 'Secret Chat',
      initialRoute: '/',
      routes: {
        '/': (context) => SplashPage(),
        '/login': (context) => LoginPage(),
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
        canvasColor: Colors.transparent,
      ),
    );
  }
}
