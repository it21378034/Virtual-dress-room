import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:virtual_dress_room/componets/Payment/bankdetails.dart';
import 'package:virtual_dress_room/componets/Payment/payment_home.dart';

class BankDetailsPage extends StatefulWidget {
  const BankDetailsPage({Key? key, required String selectedAddressId})
      : super(key: key);

  @override
  State<BankDetailsPage> createState() => _BankDetailsPageState();
}

class _BankDetailsPageState extends State<BankDetailsPage> {
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
        await FirebaseFirestore.instance.collection('payment_details').get();

    return querySnapshot.docs;
  }

  void _navigateToEditScreen(String addressId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BankDetailsEditScreen(addressId: addressId),
      ),
    ).then((_) {
      // Refresh address list after returning from edit screen
      setState(() {
        _addressList = _getAddressList();
      });
    });
  }

  void _deleteAddress(String addressId) async {
    await FirebaseFirestore.instance
        .collection('payment_details')
        .doc(addressId)
        .delete();

    // Refresh address list after deletion
    setState(() {
      _addressList = _getAddressList();
    });
  }

  void _navigateToAddScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentDetailsPage(),
      ),
    ).then((_) {
      // Refresh address list after returning from add screen
      setState(() {
        _addressList = _getAddressList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: Colors.blue,
        title: Text('Bank Details'),
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
                        String addressLine1 = addressData['branchName'] ?? '';
                        String town = addressData['pinCode'] ?? '';

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
                                    _navigateToEditScreen(addressId);
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () {
                                    _deleteAddress(addressId);
                                  },
                                ),
                              ],
                            ),
                            onTap: () {},
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
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PaymentPage(
                            selectedAddressId: '',
                          )));
            },
            child: Text('Next'),
          ),
          SizedBox(height: 50),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddScreen,
        child: Icon(Icons.add),
      ),
    );
  }
}

class BankDetailsEditScreen extends StatefulWidget {
  final String addressId;

  const BankDetailsEditScreen({required this.addressId});

  @override
  _BankDetailsEditScreenState createState() => _BankDetailsEditScreenState();
}

class _BankDetailsEditScreenState extends State<BankDetailsEditScreen> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _branchNameController;
  late TextEditingController _pinCodeController;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _branchNameController = TextEditingController();
    _pinCodeController = TextEditingController();
    _loadData();
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _branchNameController.dispose();
    _pinCodeController.dispose();
    super.dispose();
  }

  void _loadData() async {
    // Load data for the specified addressId from Firestore and set the state
    DocumentSnapshot docSnapshot = await FirebaseFirestore.instance
        .collection('payment_details')
        .doc(widget.addressId)
        .get();

    var addressData = docSnapshot.data() as Map<String, dynamic>;
    setState(() {
      _firstNameController.text = addressData['firstName'] ?? '';
      _lastNameController.text = addressData['lastName'] ?? '';
      _branchNameController.text = addressData['branchName'] ?? '';
      _pinCodeController.text = addressData['pinCode'] ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Bank Details'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _firstNameController,
              decoration: InputDecoration(labelText: 'First Name'),
            ),
            TextFormField(
              controller: _lastNameController,
              decoration: InputDecoration(labelText: 'Last Name'),
            ),
            TextFormField(
              controller: _branchNameController,
              decoration: InputDecoration(labelText: 'Branch Name'),
            ),
            TextFormField(
              controller: _pinCodeController,
              decoration: InputDecoration(labelText: 'Pin Code'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _updateBankDetails();
              },
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }

  void _updateBankDetails() async {
    // Update data in Firestore with the new values
    await FirebaseFirestore.instance
        .collection('payment_details')
        .doc(widget.addressId)
        .update({
      'firstName': _firstNameController.text,
      'lastName': _lastNameController.text,
      'branchName': _branchNameController.text,
      'pinCode': _pinCodeController.text,
    });

    Navigator.pop(context); // Navigate back to the BankDetailsPage after update
  }
}
