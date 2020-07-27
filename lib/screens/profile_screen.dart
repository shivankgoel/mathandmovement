import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mathandmovement/blocs/login/bloc.dart';
import 'package:mathandmovement/blocs/user/bloc.dart';
import 'package:provider/provider.dart';
import 'package:mathandmovement/utils/defaultscreens.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String userImage = "";
  String userName = "";
  String userEmail = "";
  String userId = "";

  @override
  Widget build(BuildContext context) {
    final LoginBloc lb = Provider.of<LoginBloc>(context);
    final UserBloc ub = Provider.of<UserBloc>(context);
    return BlocListener(
      bloc: ub,
      listener: (context, state) {
        if (state is UserImageUpdatedState) {
          setState(() {
            userImage = state.userImage;
          });
        }
      },
      child: BlocBuilder(
        bloc: ub,
        builder: (context, state) {
          if (state is FetchingUserDataState) {
            return GiveScaffoldCenterText("Fetching User Data");
          } else if (state is UserDataLoadedState) {
            userName = state.userName;
            userEmail = state.userEmail;
            userImage = state.userImage;
            userId = state.userId;
            return MainScaffold(userImage, userName, userEmail);
          }
          return GiveScaffoldCenterText("Unknown User Profile State");
        },
      ),
    );
  }
}

class MainScaffold extends StatelessWidget {
  final String userImage;
  final String userName;
  final String userEmail;
  final List titles = [
    'Contact Us',
    'Rate & Review',
  ];
  final List icons = [
    Icons.email,
    Icons.star_half,
  ];
  final List subtitles = [
    'dummyemail@gmail.com',
    'Rate this app on Google Play',
  ];

  MainScaffold(this.userImage, this.userName, this.userEmail);

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    final UserBloc ub = Provider.of<UserBloc>(context);
    final LoginBloc lb = Provider.of<LoginBloc>(context);
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Colors.grey[100],
            pinned: true,
            actions: <Widget>[],
            expandedHeight: 270,
            flexibleSpace: FlexibleSpaceBar(
              background: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor: Colors.grey[200],
                    backgroundImage: userImage == null || userImage == ""
                        ? null
                        : NetworkImage(userImage),
                    radius: 45,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(userName == null ? "" : userName,
                      style:
                          TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
                  Text(userEmail == null ? "" : userEmail,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[600])),
                  SizedBox(height: 10),
                  FlatButton.icon(
                    color: Colors.grey[300],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    onPressed: () {
                      lb.add(LogoutEvent());
                    },
                    icon: Icon(Icons.exit_to_app),
                    label: Text('Log out'),
                    textColor: Colors.grey[900],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
          SliverFillRemaining(
              hasScrollBody: true,
              child: Stack(
                children: <Widget>[
                  Container(
                    height: double.infinity,
                    width: double.infinity,
                    color: Colors.white,
                    child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.all(10),
                      itemCount: titles.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Column(
                          children: <Widget>[
                            ListTile(
                              contentPadding: EdgeInsets.only(
                                left: 15,
                              ),
                              leading: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                    color: themeData.primaryColor,
                                    borderRadius: BorderRadius.circular(8)),
                                child: Icon(icons[index],
                                    color: Colors.white, size: 25),
                              ),
                              title: Text(
                                titles[index],
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey[800]),
                              ),
                              subtitle: Text(subtitles[index],
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.black45)),
                              onTap: () {
                                if (index == 0) {
                                } else if (index == 1) {
                                } else if (index == 2) {
                                } else if (index == 3) {}
                              },
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 40,
                      margin: EdgeInsets.all(20),
                      child: FlatButton.icon(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        color: themeData.primaryColor,
                        icon: Icon(Icons.edit, color: Colors.white),
                        label: Text('Edit Picture',
                            style: TextStyle(color: Colors.white)),
                        onPressed: () {
                          ub.add(UpdateUserImageEvent());
                        },
                      ),
                    ),
                  )
                ],
              ))
        ],
      ),
    );
  }
}
