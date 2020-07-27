import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mathandmovement/utils/defaultscreens.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mathandmovement/blocs/activemath/active_math_data_bloc.dart';
import 'package:mathandmovement/utils/next_screen.dart';
import 'package:mathandmovement/widgets/youtube_full_screen.dart';

class MusicScreen extends StatefulWidget {
  @override
  _MusicScreenState createState() => _MusicScreenState();
}

class _MusicScreenState extends State<MusicScreen> {
  YoutubePlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = YoutubePlayerController(
      initialVideoId: 'cCNJGYvBdnA',
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
        loop: false,
        isLive: false,
        disableDragSeek: false,
        forceHD: false,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);
    List data;
    String desc1 =
        "Active math movements give students physical exercise while practicing one-to-one correspondence or skip counting. "
        "These are perfect for short brain breaks throughout your school day! ";
    TextStyle headingTextStyle =
        TextStyle(fontSize: 19, fontWeight: FontWeight.w600);
    ActiveMathDataBloc db = ActiveMathDataBloc();
    db.add(GetAllActiveMathData());
    return BlocListener(
      bloc: db,
      listener: (context, state) {},
      child: BlocBuilder(
        bloc: db,
        builder: (context, state) {
          if (state is ActiveMathDataInitial) {
            return GiveScaffoldCPI();
          }
          if (state is ActiveMathDataLoaded) {
            data = state.data;
            return Scaffold(
              backgroundColor: Colors.white,
              body: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      child: YoutubePlayerBuilder(
                        onExitFullScreen: () {},
                        onEnterFullScreen: () {},
                        player: YoutubePlayer(
                          controller: _controller,
                          showVideoProgressIndicator: true,
                        ),
                        builder: (context, player) {
                          return Column(
                            children: <Widget>[player],
                          );
                        },
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(height: 10),
                          Text(
                            "Active Math Movements",
                            style: themeData.textTheme.subtitle1,
                          ),
                          SizedBox(height: 10),
                          Text(
                            desc1,
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: Colors.black54),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 10),
                          _buildList(data),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          }
          return GiveScaffoldCenterText("Unknown Data State");
        },
      ),
    );
  }

  Widget _buildList(data) {
    return ListView.separated(
      shrinkWrap: true,
      padding: EdgeInsets.only(top: 5, left: 5, right: 5, bottom: 20),
      physics: NeverScrollableScrollPhysics(),
      itemCount: data.length,
      separatorBuilder: (BuildContext context, int index) {
        return SizedBox(
          height: 10,
        );
      },
      itemBuilder: (BuildContext context, int index) {
        return InkWell(
          child: Container(
            height: 290,
            width: MediaQuery.of(context).size.width,
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
                Hero(
                  tag: 'active_math_$index',
                  child: Container(
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8)),
                        image: DecorationImage(
                            image: NetworkImage(data[index]['image url']),
                            fit: BoxFit.cover)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        data[index]['title'],
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey[800]),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        data[index]['description'],
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: Colors.black54),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          onTap: () {},
        );
      },
    );
  }
}
