import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:virtual_dress_room/componets/logging/login.dart';
import 'package:virtual_dress_room/componets/pages/wrapper.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _agreedToTerms = false;

  File? _image;

  final ImagePicker _picker = ImagePicker();

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
    });
  }

  Future<void> _getImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<String?> _uploadImage(File imageFile) async {
    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('profile_images/${_emailController.text}.jpg');
      await ref.putFile(imageFile);
      return await ref.getDownloadURL();
    } catch (e) {
      print('Error uploading image: $e');
      return null;
    }
  }

  void _signUp() async {
    if (!_agreedToTerms) {
      Get.snackbar("Error", "Please agree to the terms");
      return;
    }

    try {
      final UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      if (userCredential.user != null) {
        String? imageUrl;
        if (_image != null) {
          imageUrl = await _uploadImage(_image!);
        }

        await FirebaseFirestore.instance
            .collection('user')
            .doc(userCredential.user!.uid)
            .set({
          'firstName': _firstNameController.text,
          'lastName': _lastNameController.text,
          'userName': _userNameController.text,
          'email': _emailController.text,
          'phone': _phoneController.text,
          'password': _passwordController.text,
          'profileImage': imageUrl,
        });

        await userCredential.user!.updateDisplayName(_userNameController.text);

        Get.offAll(Wrapper());
      }
    } catch (error) {
      Get.snackbar("Error", error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: Colors.blue,
        title: Text("Create Your Account"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Get.off(Login());
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 10),
            GestureDetector(
              onTap: _getImage,
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 70,
                    backgroundColor: Color.fromARGB(255, 240, 229, 229),
                    backgroundImage: _image != null ? FileImage(_image!) : null,
                    child: Icon(Icons.person, size: 70, color: Colors.grey),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.add, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: _buildInputField(
                    Icons.person,
                    "First Name",
                    _firstNameController,
                    padding: EdgeInsets.only(right: 5.0),
                  ),
                ),
                Expanded(
                  child: _buildInputField(
                    Icons.person,
                    "Last Name",
                    _lastNameController,
                    padding: EdgeInsets.only(left: 5.0),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            _buildInputField(
              Icons.person,
              "Username",
              _userNameController,
            ),
            SizedBox(height: 10),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                hintText: "Email",
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                hintText: "Phone Number",
                prefixIcon: Icon(Icons.phone),
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                hintText: "Password",
                prefixIcon: Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(_isPasswordVisible
                      ? Icons.visibility
                      : Icons.visibility_off),
                  onPressed: _togglePasswordVisibility,
                ),
                border: OutlineInputBorder(),
              ),
              obscureText: !_isPasswordVisible,
            ),
            SizedBox(height: 10),
            TextField(
              controller: _confirmPasswordController,
              decoration: InputDecoration(
                hintText: "Confirm Password",
                prefixIcon: Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(_isConfirmPasswordVisible
                      ? Icons.visibility
                      : Icons.visibility_off),
                  onPressed: _toggleConfirmPasswordVisibility,
                ),
                border: OutlineInputBorder(),
              ),
              obscureText: !_isConfirmPasswordVisible,
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Checkbox(
                  value: _agreedToTerms,
                  onChanged: (value) {
                    setState(() {
                      _agreedToTerms = value!;
                    });
                  },
                ),
                Text("I agree to the terms and conditions"),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _agreedToTerms ? _signUp : null,
              child: Text(
                'Create Account',
                style: TextStyle(
                  color: const Color.fromARGB(255, 172, 134, 134),
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
            ),
            SizedBox(height: 20),
            Text("Sign up with"),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(
    IconData icon,
    String hintText,
    TextEditingController controller, {
    EdgeInsets padding = EdgeInsets.zero,
  }) {
    return Padding(
      padding: padding,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            children: [
              Icon(icon),
              SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: hintText,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
