import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PaymentDetailsPage extends StatefulWidget {
  @override
  _PaymentDetailsPageState createState() => _PaymentDetailsPageState();
}

class _PaymentDetailsPageState extends State<PaymentDetailsPage> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _bankController;
  late TextEditingController _branchController;
  late TextEditingController _branchNameController;
  late TextEditingController _pinCodeController;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _bankController = TextEditingController();
    _branchController = TextEditingController();
    _branchNameController = TextEditingController();
    _pinCodeController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: Colors.blue,
        title: Text('Payment Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField("First Name", _firstNameController),
            _buildTextField("Last Name", _lastNameController),
            _buildTextField("Bank", _bankController),
            _buildTextField("Branch", _branchController),
            _buildTextField("Branch Name", _branchNameController),
            _buildTextField("PIN Code", _pinCodeController),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                _savePaymentDetails();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // background color
              ),
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Container(
      margin: EdgeInsets.only(bottom: 15.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        onChanged: (value) {
          setState(() {});
        },
      ),
    );
  }

  void _savePaymentDetails() {
    String firstName = _firstNameController.text.trim();
    String lastName = _lastNameController.text.trim();
    String bank = _bankController.text.trim();
    String branch = _branchController.text.trim();
    String branchName = _branchNameController.text.trim();
    String pinCode = _pinCodeController.text.trim();

    if (firstName.isNotEmpty &&
        lastName.isNotEmpty &&
        bank.isNotEmpty &&
        branch.isNotEmpty &&
        branchName.isNotEmpty &&
        pinCode.isNotEmpty) {
      FirebaseFirestore.instance.collection('payment_details').add({
        'firstName': firstName,
        'lastName': lastName,
        'bank': bank,
        'branch': branch,
        'branchName': branchName,
        'pinCode': pinCode,
      }).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Payment details saved successfully.'),
        ));
        _clearTextFields();
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to save payment details: $error'),
        ));
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please fill in all fields.'),
      ));
    }
  }

  void _clearTextFields() {
    _firstNameController.clear();
    _lastNameController.clear();
    _bankController.clear();
    _branchController.clear();
    _branchNameController.clear();
    _pinCodeController.clear();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _bankController.dispose();
    _branchController.dispose();
    _branchNameController.dispose();
    _pinCodeController.dispose();
    super.dispose();
  }
}

void main() {
  runApp(MaterialApp(
    home: PaymentDetailsPage(),
  ));
}
