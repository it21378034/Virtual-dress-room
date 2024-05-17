import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ShippingDetailsPage extends StatefulWidget {
  @override
  _ShippingDetailsPageState createState() => _ShippingDetailsPageState();
}

class _ShippingDetailsPageState extends State<ShippingDetailsPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _firstName = '';
  String _lastName = '';
  String _mobileNumber = '';
  String _addressLine1 = '';
  String _addressLine2 = '';
  String _town = '';
  String _postalCode = '';
  String _district = '';
  String _selectedCountryCode = '+1'; // Default country code
  List<String> _countryCodes = [
    '+1',
    '+91',
    '+44',
    '+61'
  ]; // Sample country codes

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: Colors.blue,
        title: Text('Add Shipping Address'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'First Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your first name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _firstName = value ?? '';
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Last Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your last name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _lastName = value ?? '';
                },
              ),
              SizedBox(height: 10),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Code',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter country code';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _selectedCountryCode = value ?? '';
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    flex: 3,
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Mobile Number',
                        hintText: 'Enter your mobile number',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your mobile number';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _mobileNumber = value ?? '';
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Address Line 1',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your address';
                  }
                  return null;
                },
                onSaved: (value) {
                  _addressLine1 = value ?? '';
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Address Line 2',
                  border: OutlineInputBorder(),
                ),
                onSaved: (value) {
                  _addressLine2 = value ?? '';
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Town',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your town';
                  }
                  return null;
                },
                onSaved: (value) {
                  _town = value ?? '';
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Postal Code',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your postal code';
                  }
                  return null;
                },
                onSaved: (value) {
                  _postalCode = value ?? '';
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'District',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your district';
                  }
                  return null;
                },
                onSaved: (value) {
                  _district = value ?? '';
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    _formKey.currentState?.save();
                    _saveAddressToFirebase();
                  }
                },
                child: Text('Save Address'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveAddressToFirebase() {
    // Save the address data to Firebase Firestore
    FirebaseFirestore.instance.collection('addresses').add({
      'firstName': _firstName,
      'lastName': _lastName,
      'mobileNumber': _mobileNumber,
      'addressLine1': _addressLine1,
      'addressLine2': _addressLine2,
      'town': _town,
      'postalCode': _postalCode,
      'district': _district,
      'countryCode': _selectedCountryCode,
    }).then((value) {
      // Show a success message or navigate to another screen
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Address saved successfully'),
        ),
      );
    }).catchError((error) {
      // Handle errors
      print('Failed to save address: $error');
    });
  }
}
