import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:sokasokoo/models/user.dart';
import 'package:sokasokoo/providers/user_provider.dart';
import 'package:sokasokoo/repositories/api.dart';
import 'package:sokasokoo/screens/Main/user_info.dart';

class AgentPlayers extends StatefulWidget {
  AgentPlayers({Key? key, required this.agentId}) : super(key: key);
  String? agentId;

  @override
  _AgentPlayersState createState() => _AgentPlayersState();
}

class _AgentPlayersState extends State<AgentPlayers> {
  var players = [];
  var isLoading = false;

  @override
  void initState() {
    super.initState();
    getPlayers();
  }

  Future getPlayers() async {
    var user = Provider.of<UserProvider>(context, listen: false).currentUser;
    setState(() {
      isLoading = true;
    });

    try {
      var id = widget.agentId ?? user.sId;
      var data = await Api().getAgentPlayers(id!);
      players.clear();
      players = data;
      print(players);
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

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
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
                      var user = User.fromJson(players[index]);
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Card(
                          child: ListTile(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => UserInfo(
                                          user: user,
                                          hide: true,
                                        )),
                              );
                            },
                            minVerticalPadding: 20,
                            leading: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(user.getProfileImage()),
                            ),
                            title: Text('${user.firstName} ${user.lastName}'),
                            trailing: const Icon(Icons.arrow_forward_ios),
                          ),
                        ),
                      );
                    }));
  }
}
