import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vehicle_parts_store/HomeScreen.dart';
import 'package:vehicle_parts_store/log_in.dart';

class Mainscreen extends StatelessWidget {
  const Mainscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder:(context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(),);

        }
        else if (snapshot.hasData) {
          return HomeScreen();
        }else {
          return LogInScreen();
        }
      },
    );
  }
}