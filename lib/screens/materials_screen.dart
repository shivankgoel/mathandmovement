import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mathandmovement/blocs/data/data_bloc.dart';
import 'package:mathandmovement/utils/defaultscreens.dart';
import 'package:mathandmovement/utils/next_screen.dart';
import 'package:mathandmovement/screens/details_screen.dart';

import '../main.dart';

class MaterialsScreen extends StatefulWidget {
  final GlobalKey _myTabbedPageKey;
  MaterialsScreen(this._myTabbedPageKey);
  @override
  _MaterialsScreenState createState() => _MaterialsScreenState();
}

class _MaterialsScreenState extends State<MaterialsScreen> {
  List data;
  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    DataBloc db = DataBloc();
    db.add(GetAllData());
    return BlocListener(
      bloc: db,
      listener: (context, state) {},
      child: BlocBuilder(
        bloc: db,
        builder: (context, state) {
          if (state is DataInitial) {
            return GiveScaffoldCPI();
          }
          if (state is DataLoaded) {
            data = state.data;
            return Scaffold(
              body: Column(
                children: <Widget>[
                  Flexible(
                    flex: 8,
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          _buildList(data),
                        ],
                      ),
                    ),
                  ),
                  Flexible(
                    flex: 1,
                    child: Center(
                      child: GestureDetector(
                        onTap: () {
                          //widget._myTabbedPageKey.currentState.tabController.animateTo(1);
                        },
                        child: Container(
                          width: 250,
                          decoration: BoxDecoration(
                            color: themeData.primaryColor,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          margin: EdgeInsets.symmetric(vertical: 5),
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            'Take a Brain Break!',
                            style: themeData.textTheme.bodyText1
                                .apply(color: Colors.white),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return GiveScaffoldCenterText("Unknown Data State");
        },
      ),
    );
  }

  Widget _buildList(d) {
    return ListView.separated(
      shrinkWrap: true,
      padding: EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 20),
      physics: NeverScrollableScrollPhysics(),
      itemCount: d.length,
      separatorBuilder: (BuildContext context, int index) {
        return SizedBox(
          height: 10,
        );
      },
      itemBuilder: (BuildContext context, int index) {
        return InkWell(
          child: Container(
              height: 130,
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.grey[300],
                        blurRadius: 10,
                        offset: Offset(3, 3))
                  ]),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Flexible(
                        flex: 5,
                        child: Column(
                          children: <Widget>[
                            Text(
                              data[index]['title'],
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey[800],
                                  fontWeight: FontWeight.w500),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              data[index]['description'],
                              style: TextStyle(
                                  fontSize: 13, color: Colors.black54),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: <Widget>[
                                Icon(
                                  FontAwesomeIcons.dollarSign,
                                  color: Colors.grey,
                                  size: 10,
                                ),
                                SizedBox(
                                  width: 2,
                                ),
                                Text(
                                  data[index]['price'].toString(),
                                  style: TextStyle(
                                      color: Colors.grey[600], fontSize: 13),
                                ),
                                Spacer(),
                                Icon(
                                  Icons.favorite,
                                  color: Colors.grey,
                                  size: 20,
                                ),
                                SizedBox(
                                  width: 3,
                                ),
                                Text(data[index]['loves'].toString(),
                                    style: TextStyle(
                                        color: Colors.black38, fontSize: 13)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        flex: 3,
                        child: Hero(
                          tag: 'dataitem$index',
                          child: Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color: Colors.grey[200],
                                      blurRadius: 1,
                                      offset: Offset(1, 1))
                                ],
                                image: DecorationImage(
                                    image:
                                        NetworkImage(data[index]['image url']),
                                    fit: BoxFit.cover)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              )),
          onTap: () {
            nextScreen(
                context,
                DetailsScreen(
                  tag: 'dataitem$index',
                  category: d[index]['tags'][0],
                  date: d[index]['price'].toString(),
                  description: d[index]['description'],
                  imageUrl: d[index]['image url'],
                  loves: d[index]['loves'],
                  timestamp: d[index]['timestamp'],
                  title: d[index]['title'],
                ));
          },
        );
      },
    );
  }
}
