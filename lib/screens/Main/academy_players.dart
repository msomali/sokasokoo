import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:sokasokoo/models/user.dart';
import 'package:sokasokoo/providers/user_provider.dart';
import 'package:sokasokoo/repositories/api.dart';
import 'package:sokasokoo/screens/Main/user_info.dart';

class AcademyPlayers extends StatefulWidget {
  AcademyPlayers({Key? key, this.academyId}) : super(key: key);
  String? academyId;

  @override
  _AcademyPlayersState createState() => _AcademyPlayersState();
}

class _AcademyPlayersState extends State<AcademyPlayers> {
  var levels = ['ALL', 'U20', 'U17', 'U15', 'U13', 'U11', 'U9'];
  var players = [];
  var isLoading = false;

  @override
  void initState() {
    super.initState();
    getPlayers('');
  }

  Future getPlayers(age) async {
    var user = Provider.of<UserProvider>(context, listen: false).currentUser;
    setState(() {
      isLoading = true;
    });

    var ageLevel = age == 'ALL' ? '' : age;

    try {
      var id = widget.academyId ?? user.sId;
      var data = await Api().getAcademy(ageLevel, id!);
      players.clear();
      players = data;
    } catch (e) {
      Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0);
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // var user = Provider.of<UserProvider>(context).currentUser;
    void _showModalSheet() {
      showModalBottomSheet(
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          context: context,
          builder: (builder) {
            return Container(
              height: 250.0,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: levels
                      .map((e) => TextButton(
                          onPressed: () {
                            getPlayers(e);
                            Navigator.pop(context);
                          },
                          child: Text(e)))
                      .toList(),
                ),
              ),
            );
          });
    }

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          actions: [
            IconButton(
                onPressed: () => _showModalSheet(),
                icon: const Icon(Icons.filter_list_rounded))
          ],
        ),
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : players.isEmpty
                ? const Center(
                    child: Text('No player registed yet'),
                  )
                : ListView.builder(
                    itemCount: players.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Card(
                          child: ListTile(
                            onTap: () {
                              var currentUser =
                                  User.fromJson(players[index]['player']);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => UserInfo(
                                          user: currentUser,
                                          hide: true,
                                        )),
                              );
                            },
                            minVerticalPadding: 20,
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(
                                  '${players[index]['player']['profileImage']}'),
                            ),
                            title: Text(
                                '${players[index]['player']['firstName']} ${players[index]['player']['lastName']}'),
                            trailing: const Icon(Icons.arrow_forward_ios),
                          ),
                        ),
                      );
                    }));
  }
}
