import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:sokasokoo/models/user.dart';
import 'package:sokasokoo/providers/user_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sokasokoo/repositories/api.dart';
import 'package:sokasokoo/screens/Main/academy_players.dart';
import 'package:sokasokoo/screens/Main/agent_players.dart';
import 'package:sokasokoo/screens/Main/my_players.dart';
import 'package:sokasokoo/screens/Main/user_cv.dart';
import 'package:sokasokoo/screens/Main/user_files.dart';
import 'package:sokasokoo/screens/academy/edit_academy_profile.dart';
import 'package:sokasokoo/screens/agent/edit_agent_profile.dart';
import 'package:sokasokoo/screens/coach/edit_coach_profile.dart';
import 'package:sokasokoo/screens/guardian/add_player.dart';
import 'package:sokasokoo/screens/guardian/edit_guardian_profile.dart';
import 'package:sokasokoo/screens/home_screen.dart';
import 'package:sokasokoo/screens/player/edit_player_profile.dart';
import 'package:sokasokoo/screens/referee/edit_referee_profile.dart';
import 'package:sokasokoo/screens/sponsor/entity_sponsor_edit_profile.dart';
import 'package:sokasokoo/screens/sponsor/sponsor_edit_profile.dart';
import 'package:sokasokoo/screens/vendor/edit_vendor_profile.dart';
import 'package:sokasokoo/utils.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ImagePicker _picker = ImagePicker();
  var uploading = false;

  void _handleImagePicker(id) async {
    try {
      final file = await _picker.pickImage(
          source: ImageSource.camera,
          maxHeight: 200,
          maxWidth: 200,
          imageQuality: 90);
      setState(() {
        uploading = true;
      });
      String? fileName = file!.path.split('/').last;
      FormData formData = FormData.fromMap({
        'profileImage':
            await MultipartFile.fromFile(file.path, filename: fileName),
      });

      var response = await Api().uploadImage(id, formData);

      Provider.of<UserProvider>(context, listen: false)
          .changeProfileImage(response.data['profileImage']);

      Fluttertoast.showToast(
          msg: 'Profile image upload succesfully',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    } on DioError catch (e) {
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
        uploading = false;
      });
    }
  }

  List<SpeedDialChild> guardianAction() {
    var user = Provider.of<UserProvider>(context, listen: false).currentUser;
    return [
      SpeedDialChild(
        child: const Icon(Icons.person_add_outlined),
        label: 'Add Player',
        backgroundColor: Colors.blueAccent,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddPlayer()),
          );
        },
      ),
      SpeedDialChild(
        child: const Icon(Icons.supervised_user_circle_sharp),
        label: 'List of Players',
        backgroundColor: Colors.blueAccent,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MyPlayers()),
          );
        },
      ),
      SpeedDialChild(
        child: const Icon(Icons.edit),
        label: 'Edit Profile',
        backgroundColor: Colors.blueAccent,
        onTap: () {
          if (user.type == 'GUARDIAN') {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EditGuardianProfile(user: user)),
            );
          }
        },
      ),
    ];
  }

  List<SpeedDialChild> academyAction() {
    var user = Provider.of<UserProvider>(context, listen: false).currentUser;
    return [
      SpeedDialChild(
        child: const Icon(Icons.content_copy_rounded),
        label: 'Files',
        backgroundColor: Colors.blueAccent,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MyFiles()),
          );
        },
      ),
      user.type == 'ACADEMY'
          ? SpeedDialChild(
              child: const Icon(Icons.supervised_user_circle_outlined),
              label: 'Academy Players',
              backgroundColor: Colors.blueAccent,
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => AcademyPlayers()));
              },
            )
          : SpeedDialChild(),
      SpeedDialChild(
        child: const Icon(Icons.edit),
        label: 'Edit Profile',
        backgroundColor: Colors.blueAccent,
        onTap: () {
          if (user.type == 'ACADEMY') {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EditAcademyProfile(user: user)),
            );
          }
        },
      ),
    ];
  }

  List<SpeedDialChild> otherAction() {
    var user = Provider.of<UserProvider>(context, listen: false).currentUser;
    return [
      SpeedDialChild(
        child: const Icon(Icons.content_copy_rounded),
        label: 'Files',
        backgroundColor: Colors.blueAccent,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MyFiles()),
          );
        },
      ),
      SpeedDialChild(
        child: const Icon(Icons.description_outlined),
        label: 'Cv',
        backgroundColor: Colors.blueAccent,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MyCv()),
          );
        },
      ),
      // SpeedDialChild(
      //   child: const Icon(Icons.supervised_user_circle_outlined),
      //   label: 'Agent',
      //   backgroundColor: Colors.blueAccent,
      //   onTap: () {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(builder: (context) => const AddAgent()),
      //     );
      //   },
      // ),
      SpeedDialChild(
        child: const Icon(Icons.edit),
        label: 'Edit Profile',
        backgroundColor: Colors.blueAccent,
        onTap: () {
          if (user.type == 'PLAYER') {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EditPlayerProfile(user: user)),
            );
          } else if (user.type == 'COACH') {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EditCoachProfile(user: user)),
            );
          } else if (user.type == 'VENDOR') {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EditVendorProfile(user: user)),
            );
          } else if (user.type == 'REFEREE') {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EditRefereeProfile(user: user)),
            );
          } else if (user.type == 'AGENT') {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EditAgentProfile(user: user)),
            );
          } else if (user.type == 'SPONSOR' && user.sponsorType == 'Entity') {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EditEntitySponsorProfile(user: user)),
            );
          } else if (user.type == 'SPONSOR' &&
              user.sponsorType == 'Individual') {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      EditIndividualSponsorProfile(user: user)),
            );
          }
        },
      ),
    ];
  }

  List<SpeedDialChild> agentAction() {
    var user = Provider.of<UserProvider>(context, listen: false).currentUser;
    return [
      SpeedDialChild(
        child: const Icon(Icons.content_copy_rounded),
        label: 'Files',
        backgroundColor: Colors.blueAccent,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MyFiles()),
          );
        },
      ),
      user.type == 'AGENT'
          ? SpeedDialChild(
              child: const Icon(Icons.supervised_user_circle_outlined),
              label: 'Agent Players',
              backgroundColor: Colors.blueAccent,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AgentPlayers(
                              agentId: user.sId,
                            )));
              },
            )
          : SpeedDialChild(),
      SpeedDialChild(
        child: const Icon(Icons.edit),
        label: 'Edit Profile',
        backgroundColor: Colors.blueAccent,
        onTap: () {
          if (user.type == 'PLAYER') {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EditPlayerProfile(user: user)),
            );
          } else if (user.type == 'COACH') {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EditCoachProfile(user: user)),
            );
          } else if (user.type == 'VENDOR') {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EditVendorProfile(user: user)),
            );
          } else if (user.type == 'REFEREE') {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EditRefereeProfile(user: user)),
            );
          } else if (user.type == 'AGENT') {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EditAgentProfile(user: user)),
            );
          } else if (user.type == 'SPONSOR' && user.sponsorType == 'Entity') {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EditEntitySponsorProfile(user: user)),
            );
          } else if (user.type == 'SPONSOR' &&
              user.sponsorType == 'Individual') {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      EditIndividualSponsorProfile(user: user)),
            );
          }
        },
      ),
    ];
  }

  @override
  void initState() {
    super.initState();
    setUser();
  }

  void setUser() async {
    var currentId =
        Provider.of<UserProvider>(context, listen: false).currentId.toString();
    var data = await Api().currentUser(userId: currentId);
    Provider.of<UserProvider>(context, listen: false).setUser(data);
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<UserProvider>(context, listen: true);
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
                onPressed: () {
                  SharedPrefs.removeUser();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                  );
                },
                icon: const Icon(Icons.logout_outlined))
          ],
        ),
        floatingActionButton: SpeedDial(
            icon: Icons.add_circle,
            foregroundColor: Colors.white,
            backgroundColor: Colors.blue,
            children: user.currentUser.type == 'GUARDIAN'
                ? guardianAction()
                : user.currentUser.type == 'ACADEMY'
                    ? academyAction()
                    : user.currentUser.type == 'AGENT'
                        ? agentAction()
                        : otherAction()),
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: Column(
            children: [
              buildProfileImage(user.currentUser),
              buildDetails('Full Name', user.currentUser.getName()),
              buildDetails('Account Number', user.currentUser.accountNumber),
              buildDetails('Phone Number', user.currentUser.phone),
              buildDetails('Region', user.currentUser.region),
              buildDetails('District', user.currentUser.district),
              buildDetails('Ward', user.currentUser.ward),
              buildDetails('Type', user.currentUser.type),
              buildDetails('Date of Birth', user.currentUser.getFormatDob()),
              (user.currentUser.type == 'PLAYER' &&
                      user.currentUser.academy != null)
                  ? TextButton(
                      onPressed: () async {
                        try {
                          var academyId = user.currentUser.academy?.sId;

                          var userId =
                              Provider.of<UserProvider>(context, listen: false)
                                  .currentUser
                                  .sId;

                          await Api().deleteAcademy(academyId);
                          var refreshUser = await Api()
                              .currentUser(userId: userId.toString());

                          Provider.of<UserProvider>(context, listen: false)
                              .setUser(refreshUser);

                          Fluttertoast.showToast(
                              msg: 'Academy remove successfully',
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
                      child: const Text(
                        'Remove from Academy',
                        style: TextStyle(color: Colors.red),
                      ))
                  : Container()
            ],
          ),
        )));
  }

  Widget buildUserAction(type) {
    return Container(
      height: 100,
      margin: const EdgeInsets.symmetric(vertical: 10),
      width: double.infinity,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            buildAddPlayer(type),
            buildListPlayers(type),
            buildAddFiles(type),
            buildAddCv(type)
          ],
        ),
      ),
    );
  }

  Widget buildDetails(key, value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        width: double.infinity,
        height: 30,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text('$key'), Text('$value')],
        ),
      ),
    );
  }

  Widget buildListPlayers(type) {
    return type == 'GUARDIAN'
        ? GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyPlayers()),
              );
            },
            child: Container(
              width: 100,
              height: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30), //border corner radius
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5), //color of shadow
                    spreadRadius: 5, //spread radius
                    blurRadius: 7, // blur radius
                    offset: const Offset(0, 2), // changes position of shadow
                  ),
                  //you can set more BoxShadow() here
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.supervised_user_circle_sharp,
                    size: 40,
                    color: Colors.blue.shade600,
                  ),
                  Text(
                    'My Players',
                    style: TextStyle(fontSize: 18, color: Colors.blue.shade600),
                  )
                ],
              ),
            ),
          )
        : Container();
  }

  Widget buildAddCv(type) {
    return type != 'GUARDIAN'
        ? GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyCv()),
              );
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              width: 100,
              height: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30), //border corner radius
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5), //color of shadow
                    spreadRadius: 5, //spread radius
                    blurRadius: 7, // blur radius
                    offset: const Offset(0, 2), // changes position of shadow
                    //first paramerter of offset is left-right
                    //second parameter is top to down
                  ),
                  //you can set more BoxShadow() here
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.description_outlined,
                    size: 40,
                    color: Colors.blue.shade600,
                  ),
                  Text(
                    'My Cv',
                    style: TextStyle(fontSize: 18, color: Colors.blue.shade600),
                  )
                ],
              ),
            ),
          )
        : Container();
  }

  Widget buildAddFiles(type) {
    return type != 'GUARDIAN'
        ? GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyFiles()),
              );
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              width: 100,
              height: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30), //border corner radius
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5), //color of shadow
                    spreadRadius: 5, //spread radius
                    blurRadius: 7, // blur radius
                    offset: const Offset(0, 2), // changes position of shadow
                    //first paramerter of offset is left-right
                    //second parameter is top to down
                  ),
                  //you can set more BoxShadow() here
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.content_copy_rounded,
                    size: 40,
                    color: Colors.blue.shade600,
                  ),
                  Text(
                    'My Files',
                    style: TextStyle(fontSize: 18, color: Colors.blue.shade600),
                  )
                ],
              ),
            ),
          )
        : Container();
  }

  Widget buildAddPlayer(type) {
    return type == 'GUARDIAN'
        ? GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddPlayer()),
              );
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10),
              width: 100,
              height: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30), //border corner radius
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5), //color of shadow
                    spreadRadius: 5, //spread radius
                    blurRadius: 7, // blur radius
                    offset: const Offset(0, 2), // changes position of shadow
                    //first paramerter of offset is left-right
                    //second parameter is top to down
                  ),
                  //you can set more BoxShadow() here
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.person_add_outlined,
                    size: 40,
                    color: Colors.blue.shade600,
                  ),
                  Text(
                    'Add Player',
                    style: TextStyle(fontSize: 18, color: Colors.blue.shade600),
                  )
                ],
              ),
            ),
          )
        : Container();
  }

  Widget buildProfileImage(User user) {
    return Container(
      width: double.infinity,
      height: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              height: 150,
              width: 150,
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2.5),
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(user.getProfileImage())))),
          SizedBox(
            height: 30,
            child: uploading == true
                ? const CircularProgressIndicator()
                : OutlinedButton(
                    onPressed: () {
                      _handleImagePicker(user.sId);
                    },
                    child: const Text('Change Profile Image')),
          )
        ],
      ),
    );
  }
}
