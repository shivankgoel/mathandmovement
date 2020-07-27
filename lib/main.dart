import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:ui';
import 'package:mathandmovement/screens/auth_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mathandmovement/screens/home_screen.dart';
import 'package:mathandmovement/screens/profile_screen.dart';
import 'package:provider/provider.dart';
import 'package:mathandmovement/blocs/user/bloc.dart';
import 'package:mathandmovement/blocs/login/bloc.dart';
import 'package:mathandmovement/utils/defaultscreens.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(
          create: (BuildContext context) => LoginBloc(),
        ),
        BlocProvider<UserBloc>(
          create: (BuildContext context) => UserBloc(),
        ),
      ],
      child: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  static Map<int, Color> maincolor = {
    50: Color.fromRGBO(68, 98, 173, .1),
    100: Color.fromRGBO(68, 98, 173, .2),
    200: Color.fromRGBO(68, 98, 173, .3),
    300: Color.fromRGBO(68, 98, 173, .4),
    400: Color.fromRGBO(68, 98, 173, .5),
    500: Color.fromRGBO(68, 98, 173, .6),
    600: Color.fromRGBO(68, 98, 173, .7),
    700: Color.fromRGBO(68, 98, 173, .8),
    800: Color.fromRGBO(68, 98, 173, .9),
    900: Color.fromRGBO(68, 98, 173, 1),
  };
  static final TextTheme darkTextTheme = TextTheme(
    headline1: GoogleFonts.ibmPlexSans(
        textStyle: TextStyle(fontSize: 102, color: Colors.white)),
    headline2: GoogleFonts.ibmPlexSans(
        textStyle: TextStyle(fontSize: 64, color: Colors.white)),
    headline3: GoogleFonts.ibmPlexSans(
        textStyle: TextStyle(fontSize: 51, color: Colors.white)),
    headline4: GoogleFonts.ibmPlexSans(
        textStyle: TextStyle(fontSize: 36, color: Colors.white)),
    headline5: GoogleFonts.ibmPlexSans(
        textStyle: TextStyle(fontSize: 25, color: Colors.white)),
    headline6: GoogleFonts.ibmPlexSans(
        textStyle: TextStyle(fontSize: 18, color: Colors.white)),
    subtitle1: GoogleFonts.ibmPlexSans(
        textStyle: TextStyle(fontSize: 17, color: Colors.white)),
    subtitle2: GoogleFonts.ibmPlexSans(
        textStyle: TextStyle(fontSize: 15, color: Colors.white)),
    bodyText1: GoogleFonts.ibmPlexSans(
        textStyle: TextStyle(fontSize: 16, color: Colors.white)),
    bodyText2: GoogleFonts.ibmPlexSans(
        textStyle: TextStyle(fontSize: 14, color: Colors.white)),
    button: GoogleFonts.ibmPlexSans(
        textStyle: TextStyle(fontSize: 15, color: Colors.white)),
    caption: GoogleFonts.ibmPlexSans(
        textStyle: TextStyle(fontSize: 13, color: Colors.white)),
    overline: GoogleFonts.ibmPlexSans(
        textStyle: TextStyle(fontSize: 11, color: Colors.white)),
  );
  static final TextTheme darkAppBarTextTheme = TextTheme(
    headline1: GoogleFonts.ibmPlexSans(
        textStyle: TextStyle(fontSize: 102, color: Color(0xffffffff))),
    headline2: GoogleFonts.ibmPlexSans(
        textStyle: TextStyle(fontSize: 64, color: Color(0xffffffff))),
    headline3: GoogleFonts.ibmPlexSans(
        textStyle: TextStyle(fontSize: 51, color: Color(0xffffffff))),
    headline4: GoogleFonts.ibmPlexSans(
        textStyle: TextStyle(fontSize: 36, color: Color(0xffffffff))),
    headline5: GoogleFonts.ibmPlexSans(
        textStyle: TextStyle(fontSize: 25, color: Color(0xffffffff))),
    headline6: GoogleFonts.ibmPlexSans(
        textStyle: TextStyle(fontSize: 20, color: Color(0xffffffff))),
    subtitle1: GoogleFonts.ibmPlexSans(
        textStyle: TextStyle(fontSize: 17, color: Color(0xffffffff))),
    subtitle2: GoogleFonts.ibmPlexSans(
        textStyle: TextStyle(fontSize: 15, color: Color(0xffffffff))),
    bodyText1: GoogleFonts.ibmPlexSans(
        textStyle: TextStyle(fontSize: 16, color: Color(0xffffffff))),
    bodyText2: GoogleFonts.ibmPlexSans(
        textStyle: TextStyle(fontSize: 14, color: Color(0xffffffff))),
    button: GoogleFonts.ibmPlexSans(
        textStyle: TextStyle(fontSize: 15, color: Color(0xffffffff))),
    caption: GoogleFonts.ibmPlexSans(
        textStyle: TextStyle(fontSize: 13, color: Color(0xffffffff))),
    overline: GoogleFonts.ibmPlexSans(
        textStyle: TextStyle(fontSize: 11, color: Color(0xffffffff))),
  );
  MaterialColor myColorCustom = MaterialColor(0xFF4462ad, maincolor);

  @override
  Widget build(BuildContext context) {
    final LoginBloc lb = Provider.of<LoginBloc>(context);
    UserBloc ub = Provider.of<UserBloc>(context);
    return StreamBuilder(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (BuildContext context, snapshot) {
        if (snapshot.hasData) {
          lb.add(GetLoginInfoEvent());
        }
        return MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            appBarTheme: AppBarTheme(
              textTheme: darkAppBarTextTheme,
            ),
            primaryTextTheme: darkTextTheme,
            primaryColor: Color.fromRGBO(68, 98, 173, 1),
            primarySwatch: myColorCustom,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: BlocBuilder(
            bloc: lb,
            builder: (context, state) {
              if (state is InitialLoginState) {
                return AuthScreen();
              }
              if (state is LoginStartState) {
                return GiveScaffoldCPI();
              }
              if (state is LoginCompleteState) {
                ub.add(GetCurrentUserDataEvent());
                return HomeScreen();
              }
              return GiveScaffoldCenterText("Unknown Login State");
            },
          ),
        );
      },
    );
  }
}
