import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sokasokoo/screens/Main/main_home.dart';
import 'package:sokasokoo/screens/auth/auth_signin.dart';
import 'package:sokasokoo/screens/roles_screen.dart';

import '../utils.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    isNewUser();
  }

  void isNewUser() async {
    var user = await SharedPrefs.getUser();

    if (user != null) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const MainHome()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/images/entry.jpg'), fit: BoxFit.cover),
        ),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        fixedSize: const Size(100, 50),
                        padding: const EdgeInsets.all(8),
                        primary: Colors.blue[400],
                        textStyle: const TextStyle(
                            color: Color(0xFFFFFEFE),
                            fontSize: 20,
                            fontWeight: FontWeight.w600),
                        // elevation: 0,
                        enableFeedback: true),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SignIn()),
                      );
                    },
                    child: const Text('SIGN IN')),
                const SizedBox(
                  width: 40,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        fixedSize: const Size(100, 50),
                        padding: const EdgeInsets.all(8),
                        primary: Colors.blue[400],
                        textStyle: const TextStyle(
                            color: Color(0xFFFFFEFE),
                            fontSize: 20,
                            fontWeight: FontWeight.w600),
                        // elevation: 0,
                        enableFeedback: true),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RolesScreen()),
                      );
                    },
                    child: const Text('SIGN UP'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
