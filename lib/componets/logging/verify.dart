import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:virtual_dress_room/componets/pages/wrapper.dart';

class Verify extends StatefulWidget {
  const Verify({Key? key}) : super(key: key);

  @override
  State<Verify> createState() => _VerifyState();
}

class _VerifyState extends State<Verify> {
  bool _emailSent =
      false; // Track whether the email verification link has been sent

  @override
  void initState() {
    super.initState();
    _sendVerifyLink(); // Call the method to send verification link
  }

  // Method to send email verification link
  Future<void> _sendVerifyLink() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && !user.emailVerified) {
      try {
        await user.sendEmailVerification();
        setState(() {
          _emailSent =
              true; // Set _emailSent to true after sending the verification email
        });
        Get.snackbar('Link sent', 'A link has been sent to your email',
            margin: EdgeInsets.all(30), snackPosition: SnackPosition.BOTTOM);
      } catch (e) {
        print('Error sending verification link: $e');
        Get.snackbar('Error',
            'Failed to send verification link. Please try again later.',
            margin: EdgeInsets.all(30), snackPosition: SnackPosition.BOTTOM);
      }
    } else {
      print('User is either null or already verified.');
    }
  }

  // Method to reload the page after verification
  void _reload() async {
    await FirebaseAuth.instance.currentUser!.reload();
    Get.offAll(Wrapper());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Verification"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(28.0),
        child: Center(
          child: _emailSent
              ? Text(
                  'An email verification link has been sent to your email. Please verify your email & reload this page.')
              : CircularProgressIndicator(), // Show a CircularProgressIndicator while waiting for the email to be sent
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _reload(),
        child: Icon(Icons.restart_alt_rounded),
      ),
    );
  }
}
