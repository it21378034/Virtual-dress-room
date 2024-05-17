import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:virtual_dress_room/componets/Payment/bank_details_page.dart';
import 'package:virtual_dress_room/componets/shipping/shipping_details.dart';

class SelectPaymentAddressPage extends StatefulWidget {
  @override
  _SelectPaymentAddressPageState createState() =>
      _SelectPaymentAddressPageState();
}

class _SelectPaymentAddressPageState extends State<SelectPaymentAddressPage> {
  late Future<List<DocumentSnapshot>> _addressList;
  String? _selectedAddressId;

  @override
  void initState() {
    super.initState();
    _addressList = _getAddressList();
  }

  Future<List<DocumentSnapshot>> _getAddressList() async {
    // Fetch addresses from Firestore
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('addresses').get();

    return querySnapshot.docs;
  }

  void _handleAddressSelection(Map<String, dynamic>? selectedAddress) {
    if (selectedAddress != null) {
      // Navigate to the payment home page with the selected address ID
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              PaymentHomePage(selectedAddressId: _selectedAddressId!),
        ),
      );
    }
  }

  void _navigateToAddAddressPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ShippingDetailsPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: Colors.blue,
        title: Text('Select Address'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: _addressList,
              builder:
                  (context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        var addressData = snapshot.data![index].data()
                            as Map<String, dynamic>;

                        String addressId = snapshot.data![index].id;
                        String firstName = addressData['firstName'] ?? '';
                        String lastName = addressData['lastName'] ?? '';
                        String addressLine1 = addressData['addressLine1'] ?? '';
                        String town = addressData['town'] ?? '';

                        return Card(
                          margin:
                              EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                          child: ListTile(
                            title: Text('$firstName $lastName'),
                            subtitle: Text('$addressLine1, $town'),
                            leading: Radio(
                              value: addressId,
                              groupValue: _selectedAddressId,
                              onChanged: (value) {
                                setState(() {
                                  _selectedAddressId = value.toString();
                                });
                              },
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    _navigateToUpdatePage(
                                        addressData, addressId);
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    _confirmDeleteAddress(addressId);
                                  },
                                ),
                              ],
                            ),
                            onTap: () {
                              _handleAddressSelection(addressData);
                            },
                          ),
                        );
                      },
                    );
                  }
                }
              },
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              _proceedToPaymentConfirmation();
            },
            child: Text('Next'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddAddressPage,
        tooltip: 'Add Address',
        child: Icon(Icons.add),
      ),
    );
  }

  void _navigateToUpdatePage(
      Map<String, dynamic> addressData, String addressId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UpdateAddressPage(
          addressData: addressData,
          addressId: addressId,
        ),
      ),
    );
  }

  void _proceedToPaymentConfirmation() {
    if (_selectedAddressId != null) {
      // Navigate to the page you created (replace YourCustomPage with your actual page name)
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              BankDetailsPage(selectedAddressId: _selectedAddressId!),
        ),
      );
    } else {
      // Show a snackbar or dialog to prompt the user to select an address
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please select an address to proceed.'),
      ));
    }
  }

  void _confirmDeleteAddress(String addressId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this address?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _deleteAddress(addressId);
                Navigator.of(context).pop();
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _deleteAddress(String addressId) {
    FirebaseFirestore.instance
        .collection('addresses')
        .doc(addressId)
        .delete()
        .then((_) {
      print('Address deleted successfully');
      // You might want to refresh the address list after deletion
      setState(() {
        _addressList = _getAddressList();
      });
    }).catchError((error) {
      print('Failed to delete address: $error');
      // You can show an error message to the user if needed
    });
  }
}

class UpdateAddressPage extends StatefulWidget {
  final Map<String, dynamic> addressData;
  final String addressId;

  UpdateAddressPage({required this.addressData, required this.addressId});

  @override
  _UpdateAddressPageState createState() => _UpdateAddressPageState();
}

class _UpdateAddressPageState extends State<UpdateAddressPage> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _addressLine1Controller;
  late TextEditingController _townController;

  @override
  void initState() {
    super.initState();
    _firstNameController =
        TextEditingController(text: widget.addressData['firstName']);
    _lastNameController =
        TextEditingController(text: widget.addressData['lastName']);
    _addressLine1Controller =
        TextEditingController(text: widget.addressData['addressLine1']);
    _townController = TextEditingController(text: widget.addressData['town']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: Colors.blue,
        title: Text('Update Address'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _firstNameController,
              decoration: InputDecoration(labelText: 'First Name'),
            ),
            TextField(
              controller: _lastNameController,
              decoration: InputDecoration(labelText: 'Last Name'),
            ),
            TextField(
              controller: _addressLine1Controller,
              decoration: InputDecoration(labelText: 'Address Line 1'),
            ),
            TextField(
              controller: _townController,
              decoration: InputDecoration(labelText: 'Town'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _updateAddress();
              },
              child: Text('Update Address'),
            ),
          ],
        ),
      ),
    );
  }

  void _updateAddress() {
    // Get the updated data from text controllers
    String firstName = _firstNameController.text;
    String lastName = _lastNameController.text;
    String addressLine1 = _addressLine1Controller.text;
    String town = _townController.text;

    // Create a map with the updated data
    Map<String, dynamic> updatedData = {
      'firstName': firstName,
      'lastName': lastName,
      'addressLine1': addressLine1,
      'town': town,
    };

    // Get the document reference of the address to update
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection('addresses')
        .doc(widget.addressId);

    // Update the document in Firestore
    documentReference.update(updatedData).then((value) {
      // Successful update
      print('Address updated successfully');

      // Navigate back to the previous page
      Navigator.pop(context);
    }).catchError((error) {
      // Failed to update
      print('Failed to update address: $error');
      // You can show an error message to the user if needed
    });
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _addressLine1Controller.dispose();
    _townController.dispose();
    super.dispose();
  }
}

class PaymentHomePage extends StatelessWidget {
  final String selectedAddressId;

  PaymentHomePage({required this.selectedAddressId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Home'),
      ),
      body: Center(
        child: Text('Payment Home Page with Address ID: $selectedAddressId'),
      ),
    );
  }
}

class PaymentHome extends StatelessWidget {
  final String selectedAddressId;

  PaymentHome({required this.selectedAddressId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Home'),
      ),
      body: Center(
        child: Text('Payment Home Page with Address ID: $selectedAddressId'),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: SelectPaymentAddressPage(),
  ));
}
