import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sokasokoo/models/user.dart';
import 'package:sokasokoo/providers/user_provider.dart';
import 'package:sokasokoo/repositories/api.dart';
import 'package:sokasokoo/screens/Main/user_info.dart';

class PlayerList extends StatefulWidget {
  PlayerList({Key? key, required this.age}) : super(key: key);
  String age;

  @override
  _PlayerListState createState() => _PlayerListState();
}

class _PlayerListState extends State<PlayerList> {
  @override
  Widget build(BuildContext context) {
    var user = Provider.of<UserProvider>(context).currentUser;
    return FutureBuilder(
        builder: (ctx, snapshot) {
          // Checking if future is resolved or not
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
              // Extracting data from snapshot object
              var data = snapshot.data as List;

              if (data.isNotEmpty) {
                return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Card(
                          child: ListTile(
                            onTap: () {
                              var currentUser =
                                  User.fromJson(data[index]['player']);
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
                                  '${data[index]['player']['profileImage']}'),
                            ),
                            title: Text(
                                '${data[index]['player']['firstName']} ${data[index]['player']['lastName']}'),
                            trailing: const Icon(Icons.arrow_forward_ios),
                          ),
                        ),
                      );
                    });
              }

              return const Center(
                child: Text(
                  'No player registered',
                  style: TextStyle(fontSize: 18),
                ),
              );
            }
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        },

        // Future that needs to be resolved
        // inorder to display something on the Canvas
        future: Api().getAcademy(widget.age, user.sId ?? ''));
  }
}
