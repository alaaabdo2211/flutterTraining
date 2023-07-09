import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';


class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    getPermission();
    getCurrentLocation();
    requestGalleryPermission();
    requestCameraPermission();
  }

  File? _image;
  String _latitude = "";
  String _longitude = "";
  TextEditingController _dateController = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                _showImageSelectionDialog();

              },
              child: CircleAvatar(
                radius: 60,
                backgroundImage: _image != null ? FileImage(_image!) as ImageProvider<Object> : const AssetImage('assets/images/profile_photo.jpg'),
                backgroundColor: Colors.transparent,
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: Padding(
                padding: EdgeInsets.all(50.0),
                child: TextField(
                  controller: _dateController,
                  decoration: InputDecoration(
                    labelText: 'Select Date of Birth',
                    prefixIcon: Icon(Icons.date_range),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  readOnly: true,
                  onTap: () => _selectDate(context),
                ),
              ),
            ),

            const SizedBox(height: 10),
            Text(
              'Current Location: $_latitude $_longitude ',
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      // Format the selected date
      String formattedDate = DateFormat('yyyy-MM-dd').format(picked);

      // Update the text controller and display the selected date
      _dateController.text = formattedDate;
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: source);

    setState(() {
      if (pickedImage != null) {
        _image = File(pickedImage.path);
      }
    });
  }

  void getPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      // Handle the case when the user permanently denies location permission
      return;
    }

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      // Permission granted, fetch the current location
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _latitude = position.latitude.toString().substring(0, 8);
        _longitude = position.longitude.toString().substring(0, 8);
      });
    }
  }

  void getCurrentLocation() async {
    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      _latitude = position.latitude.toString().substring(0, 8);
      _longitude = position.longitude.toString().substring(0, 8);
    });
    print('Latitude: $_latitude, Longitude: $_longitude');
  }

  Future<void> requestGalleryPermission() async {
    PermissionStatus status = await Permission.photos.request();

    if (status.isGranted) {
      // Permission granted
      // Proceed with gallery access
    } else if (status.isDenied) {
      // Permission denied
      // Handle permission denied scenario
    } else if (status.isPermanentlyDenied) {
      // Permission permanently denied
      // Open app settings to allow permission manually
      openAppSettings();
    }
  }

  Future<void> requestCameraPermission() async {
    PermissionStatus status = await Permission.camera.request();

    if (status.isGranted) {
      // Permission granted
      // Proceed with camera access
    } else if (status.isDenied) {
      // Permission denied
      // Handle permission denied scenario
    } else if (status.isPermanentlyDenied) {
      // Permission permanently denied
      // Open app settings to allow permission manually
      openAppSettings();
    }
  }


  Future<void> _showImageSelectionDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Image'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                GestureDetector(
                  child: Text('Gallery'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.gallery);
                  },
                ),
                SizedBox(height: 16.0),
                GestureDetector(
                  child: Text('Camera'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
