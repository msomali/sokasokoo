// ignore_for_file: unnecessary_new

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';
import 'package:sokasokoo/models/user.dart';
import 'package:sokasokoo/providers/user_provider.dart';
import 'package:sokasokoo/screens/Main/filter_form.dart';
import 'package:sokasokoo/screens/Main/user_info.dart';
import 'package:sokasokoo/screens/search/category.dart';
import 'package:sokasokoo/screens/search/filter_academy.dart';
import 'package:sokasokoo/screens/search/filter_agent.dart';
import 'package:sokasokoo/screens/search/filter_coaches.dart';
import 'package:sokasokoo/screens/search/filter_guardian.dart';
import 'package:sokasokoo/screens/search/filter_referee.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  Icon customIcon = const Icon(Icons.search);
  Widget customSearchBar = const Text('');
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      loadUsers();
    });
  }

  void loadUsers() async {
    Provider.of<UserProvider>(context, listen: false).fetchUser();
  }

  void onSubmitted(String value) {
    print('Values $value');
  }

  @override
  Widget build(BuildContext context) {
    var users = Provider.of<UserProvider>(context, listen: true).users;
    var loading = Provider.of<UserProvider>(context, listen: true).isLoading;

    return Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0,
            title: customSearchBar,
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () {
                  setState(() {
                    if (customIcon.icon == Icons.search) {
                      customIcon = const Icon(Icons.cancel);
                      customSearchBar = ListTile(
                        title: TextField(
                          onChanged: (String value) {
                            if (value.isNotEmpty) {
                              Provider.of<UserProvider>(context, listen: false)
                                  .onSearch(value);
                            }
                          },
                          cursorColor: Colors.white,
                          decoration: const InputDecoration(
                            hintText: 'Search members',
                            hintStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                            border: InputBorder.none,
                          ),
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      );
                    } else {
                      customIcon = const Icon(Icons.search);
                      customSearchBar = const Text('');
                    }
                  });
                },
                icon: customIcon,
              )
            ]),
        floatingActionButton: SpeedDial(
          icon: Icons.filter_list_rounded,
          label: const Text('FILTERS'),
          foregroundColor: Colors.white,
          backgroundColor: Colors.blue,
          children: [
            SpeedDialChild(
              child: const Icon(Icons.account_circle_outlined),
              label: 'Players',
              backgroundColor: Colors.blueAccent,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FilterForm()),
                );
              },
            ),
            SpeedDialChild(
              child: const Icon(Icons.group),
              label: 'Academies',
              backgroundColor: Colors.blueAccent,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FilterToolAcademy()),
                );
              },
            ),
            SpeedDialChild(
              child: const Icon(Icons.all_inclusive_rounded),
              label: 'Coaches',
              backgroundColor: Colors.blueAccent,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FilterToolCoaches()),
                );
              },
            ),
            SpeedDialChild(
              child: const Icon(Icons.supervised_user_circle),
              label: 'Guardians',
              backgroundColor: Colors.blueAccent,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FilterToolGuardian()),
                );
              },
            ),
            SpeedDialChild(
              child: const Icon(Icons.supervised_user_circle),
              label: 'Referee',
              backgroundColor: Colors.blueAccent,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FilterToolReferee()),
                );
              },
            ),
            SpeedDialChild(
              child: const Icon(Icons.supervised_user_circle),
              label: 'Agent',
              backgroundColor: Colors.blueAccent,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FilterToolAgent()),
                );
              },
            )
          ],
        ),
        // floatingActionButton: FloatingActionButton.extended(
        //     onPressed: () {
        //       Navigator.push(
        //         context,
        //         MaterialPageRoute(builder: (context) => SearchCategory()),
        //       );
        //     },
        //     icon: const Icon(Icons.filter_list_rounded),
        //     label: Text('Filter'.toUpperCase())),
        body: loading
            ? const Center(child: CircularProgressIndicator.adaptive())
            : users.isEmpty
                ? const Center(child: Text('Ooops!! No data'))
                : GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    itemCount: users.length,
                    itemBuilder: (BuildContext context, int index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UserInfo(
                                      user: users[index],
                                      hide: false,
                                    )),
                          );
                        },
                        child: Container(
                          height: 200,
                          width: 200,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(
                                      users[index].getProfileImage()),
                                  fit: BoxFit.cover)),
                        ),
                      );
                    }));
  }
}
