import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:sokasokoo/models/advert.dart';
import 'package:sokasokoo/models/cv.dart';
import 'package:sokasokoo/models/user.dart';
import 'package:sokasokoo/providers/user_provider.dart';
import 'package:sokasokoo/repositories/api.dart';
import 'package:sokasokoo/screens/Main/academy_players.dart';
import 'package:sokasokoo/screens/Main/all_info.dart';
import 'package:sokasokoo/screens/Main/my_players.dart';
import 'package:sokasokoo/screens/Main/user_cv.dart';
import 'package:sokasokoo/screens/Main/user_files.dart';
import 'package:sokasokoo/screens/Main/view_media.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../utils.dart';

class UserInfo extends StatefulWidget {
  UserInfo({Key? key, required this.user, required this.hide})
      : super(key: key);
  User user;
  bool hide;

  @override
  _UserInfoState createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  var level;
  var loading = false;
  Future<void> _addPlayer(User academy) async {
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Text(
                'Associate player ${widget.user.firstName} ${widget.user.lastName} to Academy?'),
            content: SingleChildScrollView(
              child: ListBody(
                children: Utils.levels
                    .map((e) => ListTile(
                          leading: Radio<String>(
                            value: e.toString(),
                            groupValue: level,
                            onChanged: (value) {
                              setState(() {
                                level = value!;
                              });
                            },
                          ),
                          title: Text(e),
                        ))
                    .toList(),
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: loading
                    ? const CircularProgressIndicator()
                    : const Text('CONFIRM'),
                onPressed: () async {
                  print(level);
                  setState(() {
                    loading = true;
                  });
                  await Api()
                      .addToAcademy(widget.user, academy, level)
                      .then((_) => {
                            Fluttertoast.showToast(
                                msg: 'Player Added Successfully',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.green,
                                textColor: Colors.white,
                                fontSize: 16.0)
                          })
                      .catchError((_) => {
                            Fluttertoast.showToast(
                                msg: 'An Error occured associating player',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.yellow,
                                textColor: Colors.white70,
                                fontSize: 16.0)
                          })
                      .whenComplete(() {
                    setState(() {
                      loading = false;
                    });
                    Navigator.of(context).pop();
                  });
                },
              ),
            ],
          );
        });
      },
    );
  }

  Future<void> _addAgent(User user) async {
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Text(
                'Associate player ${widget.user.firstName} ${widget.user.lastName} to Agent?'),
            actions: <Widget>[
              TextButton(
                child: const Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: loading
                    ? const CircularProgressIndicator()
                    : const Text('CONFIRM'),
                onPressed: () async {
                  print(level);
                  setState(() {
                    loading = true;
                  });
                  await Api()
                      .addToAgent(widget.user, user)
                      .then((_) => {
                            Fluttertoast.showToast(
                                msg: 'Player Added Successfully',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.green,
                                textColor: Colors.white,
                                fontSize: 16.0)
                          })
                      .catchError((_) => {
                            Fluttertoast.showToast(
                                msg: 'An Error occured associating player',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.yellow,
                                textColor: Colors.white70,
                                fontSize: 16.0)
                          })
                      .whenComplete(() {
                    setState(() {
                      loading = false;
                    });
                    Navigator.of(context).pop();
                  });
                },
              ),
            ],
          );
        });
      },
    );
  }

  Future<void> _removeAgent(User user) async {
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Text(
                'De-Associate player ${widget.user.firstName} ${widget.user.lastName} to Agent?'),
            actions: <Widget>[
              TextButton(
                child: const Text('CANCEL'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: loading
                    ? const CircularProgressIndicator()
                    : const Text('CONFIRM'),
                onPressed: () async {
                  print(level);
                  setState(() {
                    loading = true;
                  });
                  await Api()
                      .removeAgent(widget.user)
                      .then((_) => {
                            Fluttertoast.showToast(
                                msg: 'Player Removed Successfully',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.green,
                                textColor: Colors.white,
                                fontSize: 16.0)
                          })
                      .catchError((_) => {
                            Fluttertoast.showToast(
                                msg: 'An Error occured removing player',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.yellow,
                                textColor: Colors.white70,
                                fontSize: 16.0)
                          })
                      .whenComplete(() {
                    setState(() {
                      loading = false;
                    });
                    Navigator.of(context).pop();
                  });
                },
              ),
            ],
          );
        });
      },
    );
  }

  // Check if current user is player or coach and is agent then show (currentUser and Widget User)
  bool checkAgent(User user) {
    return user.type == 'AGENT' &&
            ['PLAYER', 'COACH'].contains(widget.user.type) &&
            widget.user.agent == null
        ? true
        : false;
  }

  bool checkRemoveAgent(User user) {
    bool isAgent =
        widget.user.agent != null && widget.user.agent!.sId == user.sId
            ? true
            : false;
    return (user.type == 'AGENT' && isAgent) ? true : false;
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<UserProvider>(context).currentUser;
    var userType = user.type;

    return Scaffold(
      backgroundColor: const Color(0xffFEFEFF),
      appBar: AppBar(
        elevation: 0,
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Wrap(
          direction: Axis.horizontal,
          children: [
            checkAgent(user)
                ? FloatingActionButton(
                    onPressed: () async => _addAgent(user),
                    child: const Icon(Icons.add_circle_rounded),
                  )
                : checkRemoveAgent(user)
                    ? FloatingActionButton(
                        onPressed: () async => _removeAgent(user),
                        child: const Icon(Icons.remove_circle_outline_outlined),
                      )
                    : Container(),
            (widget.user.type == 'PLAYER' &&
                    widget.user.academy == null &&
                    userType == 'ACADEMY' &&
                    widget.hide != true)
                ? FloatingActionButton(
                    onPressed: () async => _addPlayer(user),
                    child: const Icon(Icons.add),
                  )
                : ((widget.user.type == 'PLAYER' || userType == 'ACADEMY') &&
                        widget.hide != true &&
                        widget.user.academy != null)
                    ? FloatingActionButton(
                        onPressed: () async {
                          try {
                            var academyId = widget.user.academy?.sId;

                            await Api().deleteAcademy(academyId);

                            Fluttertoast.showToast(
                                msg: 'Player removed successfully',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.green,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          } catch (e) {
                            Fluttertoast.showToast(
                                msg: 'Error on Academy Deassociation',
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0);
                          }
                        },
                        child: const Icon(Icons.minimize),
                      )
                    : Container(),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(color: Colors.blue[50]),
              height: 180,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                        height: 120,
                        width: 120,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white, width: 2.5),
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                    widget.user.getProfileImage())))),
                  ),
                  Expanded(
                      child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Container(
                        margin: const EdgeInsets.only(left: 4),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${widget.user.getName()}',
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            widget.user.type == 'ACADEMY'
                                ? Text('Region: ${widget.user.region}',
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500))
                                : Container(),
                            widget.user.type == 'ACADEMY'
                                ? Text('TAFOCA: ${widget.user.tafoca ?? 'NO'}',
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500))
                                : Container(),
                            Text('${widget.user.accountNumber}',
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w500)),
                            widget.user.type == 'PLAYER'
                                ? widget.user.academy == null
                                    ? const Text('Free',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500))
                                    : Text(
                                        '${widget.user.academy!.academyName}',
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500))
                                : Container(),
                            widget.user.dob == null
                                ? Container()
                                : Text(
                                    '${widget.user.type == 'ACADEMY' ? 'Est' : ''} ${widget.user.getDobYear()}',
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500)),
                            TextButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AllInfo(
                                              user: widget.user,
                                            )),
                                  );
                                },
                                style: TextButton.styleFrom(
                                    side: BorderSide(
                                        color: Colors.blue.shade100, width: 2)),
                                child: const Text('More Info'))
                          ],
                        )),
                  ))
                ],
              ),
            ),
          ),
          Expanded(
              flex: 4,
              child: Container(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Column(
                    children: [
                      (widget.user.type == 'PLAYER' ||
                              widget.user.type == 'COACH')
                          ? ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => MyCv(
                                            id: widget.user.sId,
                                          )),
                                );
                              },
                              child: const Center(
                                child: Text('View CV'),
                              ))
                          : Container(),
                      (widget.user.type == 'ACADEMY' ||
                              widget.user.type == 'GUARDIAN')
                          ? ElevatedButton(
                              onPressed: () {
                                if (widget.user.type == 'ACADEMY') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AcademyPlayers(
                                            academyId: widget.user.sId)),
                                  );
                                } else if (widget.user.type == 'GUARDIAN') {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => MyPlayers(
                                              userId:
                                                  widget.user.sId.toString(),
                                            )),
                                  );
                                }
                              },
                              child: const Center(
                                child: Text('View Players'),
                              ))
                          : Container(),
                      Expanded(flex: 1, child: advertSection()),
                      Expanded(
                        flex: 3,
                        child: Container(
                          child: Column(
                            children: [
                              Container(
                                width: 80,
                                child: Divider(
                                  color: Colors.blueGrey.shade200,
                                  thickness: 2,
                                ),
                              ),
                              Container(
                                height: 40,
                                width: double.infinity,
                                child: Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton(
                                        style: TextButton.styleFrom(
                                            side: BorderSide(
                                                color: Colors.blue.shade100,
                                                width: 2)),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => MyFiles(
                                                      id: widget.user.sId,
                                                    )),
                                          );
                                        },
                                        child: const Text('View Files'))),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Expanded(child: mediaSection())
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10))),
              ))
        ],
      ),
    );
  }

  Widget mediaSection() {
    var videoLink =
        Provider.of<UserProvider>(context).currentUser.advertVideo ??
            'https://www.youtube.com/watch?v=ui3bUGnNPqw';
    String? myVideoId = YoutubePlayer.convertUrlToId(videoLink);
    YoutubePlayerController _controller = YoutubePlayerController(
      initialVideoId: myVideoId ?? 'ui3bUGnNPqw',
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
    return FutureBuilder(
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // If we got an error
          if (snapshot.hasError) {
            return Center(
              child: Text(
                '${snapshot.error} occured',
                style: const TextStyle(fontSize: 18),
              ),
            );

            // if we got our data
          } else if (snapshot.hasData) {
            var data = snapshot.data as List;

            var ytLink = data[1][0]['link'];

            var mandatory = data[1][0]['mandatory'];

            if (mandatory == true) {
              String? myVideoId = YoutubePlayer.convertUrlToId(ytLink);
              YoutubePlayerController _controller1 = YoutubePlayerController(
                initialVideoId: myVideoId ?? 'ui3bUGnNPqw',
                flags: const YoutubePlayerFlags(
                  autoPlay: false,
                  mute: false,
                ),
              );
              return Container(
                height: 80,
                width: MediaQuery.of(context).size.width,
                child: YoutubePlayer(
                  controller: _controller1,
                  liveUIColor: Colors.amber,
                ),
              );
            }

            if (data[0].isEmpty) {
              return Container(
                height: 80,
                width: MediaQuery.of(context).size.width,
                child: YoutubePlayer(
                  controller: _controller,
                  liveUIColor: Colors.amber,
                ),
              );
            }

            return Padding(
                padding: const EdgeInsets.all(8.0),
                child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WebViewMedia(
                                  url: data[0][0]['url'],
                                )),
                      );
                    },
                    child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width - 30,
                        decoration: BoxDecoration(
                            color: Colors.blue[600],
                            borderRadius:
                                const BorderRadius.all(Radius.circular(15))),
                        child: const Center(
                          child: Text('View Player Video',
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white)),
                        ))));
          }
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      },
      future: Future.wait(
          [Api().getUserCurrentMedia(widget.user.sId), Api().getYTVideo()]),
    );
  }

  Widget advertSection() {
    var advertTimer =
        Provider.of<UserProvider>(context).currentUser.advertDuration;
    return FutureBuilder(
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // If we got an error
          if (snapshot.hasError) {
            return Center(
              child: Text(
                '${snapshot.error} occured',
                style: const TextStyle(fontSize: 18),
              ),
            );

            // if we got our data
          } else if (snapshot.hasData) {
            var data = snapshot.data as List<Advert>;

            if (data.isEmpty) {
              return Container(
                height: 80,
                width: MediaQuery.of(context).size.width,
                child: const Center(child: Text('No adverts provided')),
              );
            }

            return CarouselSlider(
                items: data.map((payload) {
                  return Builder(builder: (BuildContext context) {
                    return Column(
                      children: [
                        Flexible(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            decoration: const BoxDecoration(
                              color: Colors.transparent,
                            ),
                            child: Image.network(
                              payload.getCoverImage(),
                              height: 100,
                              width: 200,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ],
                    );
                  });
                }).toList(),
                options: CarouselOptions(
                    viewportFraction: 0.9,
                    autoPlay: true,
                    height: 200,
                    enlargeCenterPage: false,
                    autoPlayInterval: Duration(minutes: advertTimer!.toInt())));
          }
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      },
      future: Api().getAdverts(),
    );
  }

  Widget playerSection() {
    return FutureBuilder(
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // If we got an error
          if (snapshot.hasError) {
            return Center(
              child: Text(
                '${snapshot.error} occured',
                style: const TextStyle(fontSize: 18),
              ),
            );

            // if we got our data
          } else if (snapshot.hasData) {
            var data = snapshot.data as List;

            if (data.isEmpty) {
              return const Center(
                child: Text(
                  'No Players registered yet',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              );
            }

            var player = User.fromJson(data[0]['player']);

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {},
                child: Container(
                  height: 80,
                  width: MediaQuery.of(context).size.width - 30,
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundImage:
                              NetworkImage(player.getProfileImage()),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Flexible(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${player.firstName} ${player.lastName}',
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w700)),
                            Text('Level: ${data[0]['level']}',
                                style: const TextStyle(fontSize: 16))
                          ],
                        ))
                      ],
                    ),
                  ),
                  decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10))),
                ),
              ),
            );
          }
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      },
      future: Api().getAcademy('', widget.user.sId.toString()),
    );
  }

  Widget cvSection() {
    return FutureBuilder(
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // If we got an error
          if (snapshot.hasError) {
            return Center(
              child: Text(
                '${snapshot.error} occured',
                style: const TextStyle(fontSize: 18),
              ),
            );

            // if we got our data
          } else if (snapshot.hasData) {
            var data = snapshot.data as List;

            if (data.isEmpty) {
              return const Center(
                child: Text(
                  'Not Current Team Set',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              );
            }
            var userCv = Cv.fromJson(data[0]);

            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    const Text(
                      'Team Name:',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      '${userCv.name}',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w600),
                    )
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      'Start Date:',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      Utils.getFormattedDate(userCv.startDate.toString()),
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w600),
                    )
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      'Contact Person:',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      '${userCv.person}',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w600),
                    )
                  ],
                ),
                Row(
                  children: [
                    const Text(
                      'Contact Person #:',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      '${userCv.phone}',
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w600),
                    )
                  ],
                )
              ],
            );
          }
        }

        return const Center(
          child: CircularProgressIndicator(),
        );
      },
      future: Api().getUserCurrentCvs(widget.user.sId),
    );
  }
}
