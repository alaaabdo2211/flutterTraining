import 'package:flutter/material.dart';
import 'package:flutter_application_1/profile_screen.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';


void main() {
  runApp(ProfilePage());
}

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profile Page',
    
      home: ProfileScreen(),
    );
  }
}


