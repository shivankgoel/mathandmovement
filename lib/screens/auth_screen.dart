import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mathandmovement/models/icons_data.dart';
import 'package:mathandmovement/blocs/login/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mathandmovement/utils/toast.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  ThemeData themeData;
  final LoginBloc loginBloc = LoginBloc();
  var formKey = GlobalKey<FormState>();
  var _scaffoldKey = new GlobalKey<ScaffoldState>();
  var emailCtrl = TextEditingController();
  var passCtrl = TextEditingController();
  var nameCtrl = TextEditingController();
  bool offsecureText = true;
  Icon lockIcon = LockIcon().lock;
  String email;
  String pass;
  String name;

  void lockPressed() {
    setState(() {
      offsecureText = !offsecureText;
      lockIcon = offsecureText ? LockIcon().lock : LockIcon().open;
    });
  }

  bool signInStart = false;
  bool signInComplete = false;
  var isLogin = true;

  String beautifyName(String x) {
    if (isLogin) return x;
    String ans = "";
    for (String a in x.trim().split(' ')) {
      ans += a[0].toUpperCase() + a.substring(1).toLowerCase();
      ans += " ";
    }
    return ans.trim();
  }

  void submitForm() {
    String _name = beautifyName(name);
    String _email = email.trim().toLowerCase();
    String _pass = pass.trim();
    if (isLogin) {
      loginBloc.add(EmailLoginEvent(_email, _pass));
    } else {
      loginBloc.add(EmailSignUpEvent(_name, _email, _pass));
    }
  }

  void trysubmit() {
    FocusScope.of(context).unfocus();
    final isValid = formKey.currentState.validate();
    if (isValid) {
      formKey.currentState.save();
      submitForm();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginBloc>.value(
      value: loginBloc,
      child: BlocListener(
        bloc: loginBloc,
        listener: (context, state) {
          if (state is SignUpCompleteState || state is LoginCompleteState) {
            setState(() {
              signInComplete = true;
              signInStart = false;
            });
          }
          if (state is AuthErrorState) {
            openToast(context, state.message);
            setState(() {
              signInStart = false;
              signInComplete = false;
            });
          }
          if (state is LoginStartState) {
            setState(() {
              signInStart = true;
              signInComplete = false;
            });
          }
        },
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(title: Text('Math & Movement')),
          backgroundColor: Colors.white,
          body: AuthUI(),
        ),
      ),
    );
  }

  Widget AuthUI() {
    themeData = Theme.of(context);
    var mainText = isLogin ? 'Sign In' : 'Sign Up';
    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.only(left: 30, right: 30, bottom: 0),
        child: ListView(
          children: <Widget>[
            SizedBox(height: 50),
            Text(mainText,
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900)),
            Text('Follow the simple steps',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey)),
            SizedBox(height: 60),
            if (!isLogin)
              TextFormField(
                controller: nameCtrl,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  labelText: 'Name',
                  hintText: 'Enter Name',
                  //prefixIcon: Icon(Icons.person)
                ),
                validator: (String value) {
                  if (value.length < 2)
                    return "Name must have atleast 2 letters";
                  return null;
                },
                onChanged: (String value) {
                  setState(() {
                    name = value;
                  });
                },
              ),
            SizedBox(height: 20),
            TextFormField(
              decoration: InputDecoration(
                  hintText: 'username@mail.com',
                  //prefixIcon: Icon(Icons.email),
                  labelText: 'Email'),
              controller: emailCtrl,
              keyboardType: TextInputType.emailAddress,
              validator: (String value) {
                if (value.length < 3 || !value.contains('@'))
                  return "Email address invalid";
                return null;
              },
              onChanged: (String value) {
                setState(() {
                  email = value;
                });
              },
            ),
            SizedBox(height: 20),
            TextFormField(
              obscureText: offsecureText,
              controller: passCtrl,
              decoration: InputDecoration(
                labelText: 'Password',
                hintText: 'Enter Password',
                //prefixIcon: Icon(Icons.vpn_key),
                suffixIcon: IconButton(
                    icon: lockIcon,
                    onPressed: () {
                      lockPressed();
                    }),
              ),
              validator: (String value) {
                if (value.length < 6)
                  return "Password must be atleast 6 characters long";
                return null;
              },
              onChanged: (String value) {
                setState(() {
                  pass = value;
                });
              },
            ),
            SizedBox(height: 50),
            Container(
              alignment: Alignment.centerRight,
              child: FlatButton(
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(color: themeData.primaryColor),
                ),
                onPressed: () {},
              ),
            ),
            Container(
              height: 45,
              child: RaisedButton(
                  color: themeData.primaryColor,
                  child: signInStart == false
                      ? Text(
                          mainText,
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        )
                      : signInComplete == false
                          ? CircularProgressIndicator()
                          : Text(mainText + ' Successful!',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white)),
                  onPressed: trysubmit),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(isLogin
                    ? "Don't have an account?"
                    : "Already have an account?"),
                FlatButton(
                  child: Text(isLogin ? 'Sign Up' : 'Sign In',
                      style: TextStyle(color: themeData.primaryColor)),
                  onPressed: () {
                    setState(() {
                      isLogin = !isLogin;
                    });
                  },
                )
              ],
            ),
            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
