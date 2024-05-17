import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _userNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  bool _isDataChanged = false;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _userNameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();

    // Fetch user data
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot userData = await FirebaseFirestore.instance
            .collection('user')
            .doc(user.uid)
            .get();
        if (userData.exists) {
          setState(() {
            _firstNameController.text = userData['firstName'];
            _lastNameController.text = userData['lastName'];
            _userNameController.text = userData['userName'];
            _emailController.text = userData['email'];
            _phoneController.text = userData['phone'];
          });
        }
      }
    } catch (error) {
      print('Error fetching user data: $error');
    }
  }

  Future<void> _updateUserData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        if (_isDataChanged) {
          await FirebaseFirestore.instance
              .collection('user')
              .doc(user.uid)
              .update({
            'firstName': _firstNameController.text,
            'lastName': _lastNameController.text,
            'userName': _userNameController.text,
            'email': _emailController.text,
            'phone': _phoneController.text,
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('User data updated successfully')),
          );
          setState(() {
            _isDataChanged = false;
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('No changes detected')),
          );
        }
      }
    } catch (error) {
      print('Error updating user data: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Error updating user data. Please try again later.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: Colors.blue,
        title: Text(
          'Account',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            TextField(
              controller: _firstNameController,
              decoration: InputDecoration(
                labelText: 'First Name',
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => setState(() => _isDataChanged = true),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _lastNameController,
              decoration: InputDecoration(
                labelText: 'Last Name',
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => setState(() => _isDataChanged = true),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _userNameController,
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => setState(() => _isDataChanged = true),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => setState(() => _isDataChanged = true),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
              ),
              onChanged: (_) => setState(() => _isDataChanged = true),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateUserData,
              child: Text('Update'),
              style: ElevatedButton.styleFrom(
                backgroundColor: _isDataChanged ? Colors.blue : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _userNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}
