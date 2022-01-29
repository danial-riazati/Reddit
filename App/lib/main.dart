import 'package:application/pages/home_page.dart';
import 'package:application/pages/login_page.dart';
import 'package:application/pages/my_communities_page.dart';
import 'package:application/pages/new_post_page.dart';
import 'package:application/pages/register_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: {
        '/': (context) => const LoginPage(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/home': (context) => const HomePage(),
        '/newpost': (context) => const NewPostPage(),
        '/mycommunities': (context) => const MyCommunitiesPage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
