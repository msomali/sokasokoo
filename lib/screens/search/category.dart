import 'package:flutter/material.dart';

class SearchCategory extends StatefulWidget {
  SearchCategory({Key? key}) : super(key: key);

  @override
  _SearchCategoryState createState() => _SearchCategoryState();
}

final ButtonStyle mainButton = ElevatedButton.styleFrom(
    fixedSize: const Size(180, 50),
    padding: const EdgeInsets.all(8),
    primary: Colors.blue[400],
    textStyle: const TextStyle(
        color: Color(0xFFFFFEFE), fontSize: 20, fontWeight: FontWeight.w600),
    // elevation: 0,
    enableFeedback: true);

class _SearchCategoryState extends State<SearchCategory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: Column(
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
                    'Select Search Category',
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        style: mainButton,
                        onPressed: () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //       builder: (context) => const PlayerFormOne(
                          //             type: 'PLAYER',
                          //           )),
                          // );
                        },
                        child: const Text('PLAYERS')),
                    const SizedBox(
                      height: 15,
                    ),
                    ElevatedButton(
                        style: mainButton,
                        onPressed: () {},
                        child: const Text('ACADEMIES')),
                    const SizedBox(
                      height: 15,
                    ),
                    ElevatedButton(
                        style: mainButton,
                        onPressed: () {},
                        child: const Text('GUARDIANS')),
                    const SizedBox(
                      height: 15,
                    ),
                    ElevatedButton(
                        style: mainButton,
                        onPressed: () {},
                        child: const Text('COACHES'))
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
