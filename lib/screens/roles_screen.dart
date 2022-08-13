import 'package:flutter/material.dart';
import 'package:sokasokoo/screens/academy/form_one.dart';
import 'package:sokasokoo/screens/agent/agent_form_one.dart';
import 'package:sokasokoo/screens/guardian/form_one.dart';
import 'package:sokasokoo/screens/player/form_one.dart';
import 'package:sokasokoo/screens/sponsor/entity_sponsor_form_one.dart';
import 'package:sokasokoo/screens/sponsor/sponsor_form_one.dart';
import 'package:sokasokoo/screens/vendor/vendors_form_one.dart';

import 'coach/form_one.dart';
import 'referee/referee_form_one.dart';

final ButtonStyle mainButton = ElevatedButton.styleFrom(
    fixedSize: const Size(180, 50),
    padding: const EdgeInsets.all(8),
    primary: Colors.blue[400],
    textStyle: const TextStyle(
        color: Color(0xFFFFFEFE), fontSize: 20, fontWeight: FontWeight.w600),
    // elevation: 0,
    enableFeedback: true);

final ButtonStyle subButton = ElevatedButton.styleFrom(
    fixedSize: const Size(180, 50),
    padding: const EdgeInsets.all(8),
    primary: Colors.grey[400],
    textStyle: const TextStyle(
        color: Color(0xFFFFFEFE), fontSize: 20, fontWeight: FontWeight.w600),
    // elevation: 0,
    enableFeedback: true);

class RolesScreen extends StatelessWidget {
  const RolesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/sign_up.jpg'),
                fit: BoxFit.cover)),
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 50,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'Role',
                      style: TextStyle(fontSize: 30),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                          style: mainButton,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const PlayerFormOne(
                                        type: 'PLAYER',
                                      )),
                            );
                          },
                          child: const Text('PLAYER')),
                      ElevatedButton(
                          style: mainButton,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const CoachFormOne(
                                        type: 'COACH',
                                      )),
                            );
                          },
                          child: const Text('COACH')),
                      ElevatedButton(
                          style: mainButton,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const GuardianFormOne(
                                        type: 'GUARDIAN',
                                      )),
                            );
                          },
                          child: const Text('GUARDIAN')),
                      ElevatedButton(
                          style: mainButton,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const AcademyFormOne(
                                        type: 'ACADEMY',
                                      )),
                            );
                          },
                          child: const Text('ACADEMY')),
                      ElevatedButton(
                          style: mainButton,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const VendorFormOne(
                                        type: 'VENDOR',
                                      )),
                            );
                          },
                          child: const Text('VENDOR')),
                      ElevatedButton(
                          style: mainButton,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const RefereeFormOne(
                                        type: 'REFEREE',
                                      )),
                            );
                          },
                          child: const Text('REFEREE')),
                      ElevatedButton(
                          style: mainButton,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const AgentFormOne(
                                        type: 'AGENT',
                                      )),
                            );
                          },
                          child: const Text('AGENT')),
                      ElevatedButton(
                          style: mainButton,
                          onPressed: () {
                            showModalBottomSheet(
                                backgroundColor: Colors.grey.shade200,
                                context: context,
                                builder: (context) {
                                  return Wrap(
                                    children: [
                                      ListTile(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const IndividualSponsorFormOne(
                                                      type: 'SPONSOR',
                                                      sponsor_type:
                                                          'Individual',
                                                    )),
                                          );
                                        },
                                        leading: const Icon(
                                            Icons.account_circle_sharp),
                                        title: const Text('As an Individual'),
                                      ),
                                      ListTile(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const EntitySponsorFormOne(
                                                      type: 'SPONSOR',
                                                      sponsor_type: 'Entity',
                                                    )),
                                          );
                                        },
                                        leading: const Icon(
                                            Icons.supervisor_account_sharp),
                                        title: const Text('As an Entity'),
                                      )
                                    ],
                                  );
                                });
                          },
                          child: const Text('SPONSOR')),
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
