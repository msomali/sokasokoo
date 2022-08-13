import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sokasokoo/providers/user_provider.dart';
import 'package:sokasokoo/screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [ChangeNotifierProvider(create: (_) => UserProvider())],
        child: MaterialApp(
          title: 'SokaSoko',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              appBarTheme: AppBarTheme(color: Colors.cyan.shade600),
              scaffoldBackgroundColor: Colors.blueGrey.shade50),
          home: const HomeScreen(),
        ));
  }
}
