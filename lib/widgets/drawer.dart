import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mathandmovement/blocs/user/bloc.dart';
import 'package:mathandmovement/screens/profile_screen.dart';
import 'package:mathandmovement/utils/defaultscreens.dart';
import 'package:mathandmovement/utils/next_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mathandmovement/blocs/login/bloc.dart';
import 'package:mathandmovement/blocs/user/user_bloc.dart';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    final UserBloc ub = Provider.of<UserBloc>(context);
    final LoginBloc lb = Provider.of<LoginBloc>(context);

    final List titles = [
      'Categories',
      'Bookmark',
      'Notifications',
      'Profile',
      'Logout'
    ];
    final List icons = [
      Icons.category,
      Icons.bookmark_border,
      Icons.notifications_none,
      Icons.verified_user,
      FontAwesomeIcons.signOutAlt,
    ];
    return Drawer(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
              color: Colors.grey[200],
              padding: EdgeInsets.all(15),
              height: 180,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                    flex: 1,
                    child: CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.grey[400],
                      backgroundImage: NetworkImage(ub.userImage),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    flex: 3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          ub.userName,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        Text(ub.userEmail)
                      ],
                    ),
                  )
                ],
              )),
          Container(
            height: 350,
            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: titles.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(
                    titles[index],
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                        color: Colors.grey[700]),
                  ),
                  leading: CircleAvatar(
                      backgroundColor: Colors.grey[300],
                      child: Icon(
                        icons[index],
                        color: Colors.black87,
                      )),
                  onTap: () {
                    Navigator.pop(context);
                    if (index == 0) {
                    } else if (index == 1) {
                    } else if (index == 2) {
                    } else if (index == 3) {
                      nextScreen(context, ProfileScreen());
                    } else if (index == 4) {
                      lb.add(LogoutEvent());
                    }
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
