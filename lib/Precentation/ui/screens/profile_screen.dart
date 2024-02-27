import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:frastraited/Precentation/ui/screens/settings_screen.dart';
import 'package:frastraited/Precentation/ui/utility/app_colors.dart';
import 'package:frastraited/screen/service/database_service.dart';
import 'package:frastraited/screen/service/models/users.dart';
import 'package:frastraited/screen/widgets/bodyBackground.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UsersModel user = UsersModel.empty();

  String _downloadUrl = '';

  late File _image;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (FirebaseAuth.instance.currentUser != null) {
      _getUser(FirebaseAuth.instance.currentUser!.uid);
    }
  }

  void _getUser(String uid) async {
    user = await DatabaseService.instance.getUserInfo(uid);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.primaryColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: const Text(
          'Profile',
          style: TextStyle(
            color: AppColors.primaryColor,
            fontWeight: FontWeight.w500,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.settings,
              color: AppColors.primaryColor,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: BodyBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  // Profile Picture, Full Name, and Medical ID
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Stack(
                        alignment: Alignment.bottomLeft,
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundColor: Colors.grey[300],
                            backgroundImage: NetworkImage(user.profileUrl), // Set the profile picture URL
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: IconButton(
                              icon: const Icon(
                                Icons.camera_alt_outlined,
                                color: AppColors.primaryColor,
                              ),
                              onPressed: () {
                                // Handle updating profile picture
                                _getImage(_picker);
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 13),
                      Text(
                        '${user.firstName} ${user.lastName}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Medical ID: ${user.medicalId}',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      height: 400,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            _buildInfoField('First Name', user.firstName),
                            const Divider(color: Colors.grey),
                            _buildInfoField('Last Name', user.lastName),
                            const Divider(color: Colors.grey),
                            _buildInfoField('Email', user.email),
                            const Divider(color: Colors.grey),
                            _buildInfoField('Phone Number', user.phone),
                            const SizedBox(height: 20),
                            const Divider(color: Colors.grey),
                            _buildInfoField('Your Medical ID', user.medicalId, editable: false),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Widget for building information fields
  Widget _buildInfoField(String label, String value, {bool editable = true}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.primaryColor,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value,
                    style: editable ? const TextStyle(color: Colors.grey) : const TextStyle(color: Colors.black),
                  ),
                ),
                if (editable)
                  IconButton(
                    icon: const Icon(Icons.edit, color: AppColors.primaryColor),
                    onPressed: () {
                      // Handle edit button tap
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Edit $label'),
                          content: TextFormField(
                            initialValue: value,
                            onChanged: (newValue) {
                              setState(() {
                                value = newValue;
                              });
                            },
                            decoration: InputDecoration(
                              hintText: 'Enter new $label',
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                // Update the corresponding variable with the new value
                                // setState(() {
                                //   switch (label) {
                                //     case 'First Name':
                                //       _firstName = value;
                                //       break;
                                //     case 'Last Name':
                                //       _lastName = value;
                                //       break;
                                //     case 'Email':
                                //       _email = value;
                                //       break;
                                //     case 'Phone Number':
                                //       _phoneNumber = value;
                                //       break;
                                //   }
                                // });
                                Navigator.pop(context);
                              },
                              child: const Text('Save'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _getImage(ImagePicker picker) async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (image != null) {
        _image = File(image.path);
        _uploadImage(File(image.path));
      }
    });
  }

  void _uploadImage(File file) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    final storage = FirebaseStorage.instance;
    final Reference storageRef = storage.ref().child('images/${currentUser?.uid}/${DateTime.now().toString()}');
    final UploadTask uploadTask = storageRef.putFile(file);
    await uploadTask.whenComplete(() async {
      _downloadUrl = await storageRef.getDownloadURL();
      user = await DatabaseService.instance.updateUserInformation(user.copyWith(profileUrl: _downloadUrl));
    });
    setState(() {});
  }
}
