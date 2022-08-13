import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sokasokoo/models/user.dart';
import 'package:sokasokoo/providers/user_provider.dart';
import 'package:sokasokoo/repositories/api.dart';
import 'package:sokasokoo/screens/Main/user_info.dart';

class MyPlayers extends StatelessWidget {
  MyPlayers({Key? key, this.userId}) : super(key: key);
  String? userId;

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<UserProvider>(context, listen: true).currentUser;
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
        future: Api().getUsersOfGuardian(userId ?? user.sId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return const Text('Error');
            } else if (snapshot.hasData) {
              var items = snapshot.data as List;
              return ListView.builder(
                itemCount: items.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Card(
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UserInfo(
                                      user: items[index],
                                      hide: true,
                                    )),
                          );
                        },
                        leading: CircleAvatar(
                          backgroundImage:
                              NetworkImage('${items[index].profileImage}'),
                        ),
                        title: Text(
                            '${items[index].firstName} ${items[index].lastName}'),
                        // subtitle: Text('${items[index].description}'),
                        trailing: const Icon(Icons.arrow_forward_ios),
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Text('Ooops! Sorry no player added');
            }
          } else {
            return Text('State: ${snapshot.connectionState}');
          }
        },
      ),
    );
  }
}
