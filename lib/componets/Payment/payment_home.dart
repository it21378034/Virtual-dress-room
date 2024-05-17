import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:virtual_dress_room/componets/Payment/payment.dart';

import 'constants.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({Key? key, required String selectedAddressId})
      : super(key: key);

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  TextEditingController amountController = TextEditingController();
  TextEditingController fnameController = TextEditingController();
  TextEditingController lnameController = TextEditingController();
  TextEditingController bankController = TextEditingController();
  TextEditingController branchController = TextEditingController();
  TextEditingController branchnameController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();

  final formkey = GlobalKey<FormState>();
  final formkey1 = GlobalKey<FormState>();
  final formkey2 = GlobalKey<FormState>();
  final formkey3 = GlobalKey<FormState>();
  final formkey4 = GlobalKey<FormState>();
  final formkey5 = GlobalKey<FormState>();
  final formkey6 = GlobalKey<FormState>();

  List<String> currencyList = <String>[
    'USD',
    'INR',
    'EUR',
    'JPY',
    'GBP',
    'AED'
  ];
  String selectedCurrency = 'USD';

  bool hasDonated = false;

  Future<void> initPaymentSheet() async {
    try {
      // 1. create payment intent on the client side by calling stripe api
      final data = await createPaymentIntent(
        // convert string to double
        amount: (int.parse(amountController.text) * 100).toString(),
        currency: selectedCurrency,
        fname: fnameController.text,
        lname: lnameController.text,
        bank: bankController.text,
        branch: branchController.text,
        branchname: branchnameController.text,
        pin: pincodeController.text,
      );

      // 2. initialize the payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          // Set to true for custom flow
          customFlow: false,
          // Main params
          merchantDisplayName: 'Test Merchant',
          paymentIntentClientSecret: data['client_secret'],
          // Customer keys
          customerEphemeralKeySecret: data['ephemeralKey'],
          customerId: data['id'],

          style: ThemeMode.dark,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      rethrow;
    }
  }

  Future<void> addPaymentDetailsToFirestore(
      Map<String, dynamic> paymentData) async {
    try {
      await FirebaseFirestore.instance
          .collection('payment_details')
          .add(paymentData);
      print('Payment details added successfully');
    } catch (e) {
      print('Error adding payment details: $e');
      // Handle error
    }
  }

  Future<void> updatePaymentDetailsInFirestore(
      String docId, Map<String, dynamic> updatedData) async {
    try {
      await FirebaseFirestore.instance
          .collection('payment_details')
          .doc(docId)
          .update(updatedData);
      print('Payment details updated successfully');
    } catch (e) {
      print('Error updating payment details: $e');
      // Handle error
    }
  }

  Future<void> deletePaymentDetailsFromFirestore(String docId) async {
    try {
      await FirebaseFirestore.instance
          .collection('payment_details')
          .doc(docId)
          .delete();
      print('Payment details deleted successfully');
    } catch (e) {
      print('Error deleting payment details: $e');
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: Colors.blue,
        title: Text('Payment'),
        // Commented out navigation
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back),
        //   onPressed: () {
        //     Navigator.pop(context);
        //   },
        // ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                const Image(
                  image: AssetImage("images/c1.jpg"),
                  height: 300,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                hasDonated
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Thanks for your ${amountController.text} $selectedCurrency Payment",
                              style: const TextStyle(
                                  fontSize: 28, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            const Text(
                              "We appreciate your support",
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            SizedBox(
                              height: 50,
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Colors.blueAccent.shade400),
                                child: const Text(
                                  "Pay again",
                                  style: TextStyle(
                                      color: Colors.white,
                                      // fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                onPressed: () {
                                  setState(() {
                                    hasDonated = false;
                                    amountController.clear();
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Please Enter Bank Details",
                                style: TextStyle(
                                    fontSize: 28, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(
                                height: 6,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 5,
                                    child: ReusableTextField(
                                        formkey: formkey,
                                        controller: amountController,
                                        isNumber: true,
                                        title: "Amount",
                                        hint: "amount"),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  DropdownMenu<String>(
                                    inputDecorationTheme: InputDecorationTheme(
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                              vertical: 20, horizontal: 0),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ),
                                    initialSelection: currencyList.first,
                                    onSelected: (String? value) {
                                      // This is called when the user selects an item.
                                      setState(() {
                                        selectedCurrency = value!;
                                      });
                                    },
                                    dropdownMenuEntries: currencyList
                                        .map<DropdownMenuEntry<String>>(
                                            (String value) {
                                      return DropdownMenuEntry<String>(
                                          value: value, label: value);
                                    }).toList(),
                                  )
                                ],
                              ),
                              // const SizedBox(
                              //   height: 10,
                              // ),
                              // ReusableTextField(
                              //   formkey: formkey1,
                              //   title: "First Name",
                              //   hint: "Ex. John Doe",
                              //   controller: fnameController,
                              // ),
                              // const SizedBox(
                              //   height: 10,
                              // ),
                              // ReusableTextField(
                              //   formkey: formkey2,
                              //   title: "Last Name",
                              //   hint: "Ex. 123 Main St",
                              //   controller: lnameController,
                              // ),
                              // const SizedBox(
                              //   height: 10,
                              // ),
                              // Row(
                              //   children: [
                              //     Expanded(
                              //         flex: 5,
                              //         child: ReusableTextField(
                              //           formkey: formkey3,
                              //           title: "Bank",
                              //           hint: "Ex. New Delhi",
                              //           controller: bankController,
                              //         )),
                              //   const SizedBox(
                              //     width: 10,
                              //   ),
                              //   Expanded(
                              //       flex: 5,
                              //       child: ReusableTextField(
                              //         formkey: formkey4,
                              //         title: "Branch",
                              //         hint: "Ex. DL for Delhi",
                              //         controller: branchController,
                              //       )),
                              // ],
                              // ),
                              // const SizedBox(
                              //   height: 10,
                              // ),
                              // Row(
                              //   children: [
                              //     Expanded(
                              //         flex: 5,
                              //         child: ReusableTextField(
                              //           formkey: formkey5,
                              //           title: "Branch Name",
                              //           hint: "Ex. IN for India",
                              //           controller: branchnameController,
                              //         )),
                              //   const SizedBox(
                              //     width: 10,
                              //   ),
                              //   Expanded(
                              //       flex: 5,
                              //       child: ReusableTextField(
                              //         formkey: formkey6,
                              //         title: "Pincode",
                              //         hint: "Ex. 123456",
                              //         controller: pincodeController,
                              //         isNumber: true,
                              //       )),
                              // ],
                              // ),
                              // const SizedBox(
                              //   height: 12,
                              // ),
                              SizedBox(
                                height: 50,
                                width: double.infinity,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Colors.blueAccent.shade400),
                                  child: const Text(
                                    "Proceed to Pay",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                  onPressed: () async {
                                    if (formkey.currentState!.validate()
                                        // formkey1.currentState!.validate() &&
                                        // formkey2.currentState!.validate() &&
                                        // formkey3.currentState!.validate() &&
                                        // formkey4.currentState!.validate() &&
                                        // formkey5.currentState!.validate() &&
                                        // formkey6.currentState!.validate()
                                        ) {
                                      await initPaymentSheet();

                                      try {
                                        await Stripe.instance
                                            .presentPaymentSheet();

                                        // Store payment details in Firestore
                                        await addPaymentDetailsToFirestore({
                                          'amount': amountController.text,
                                          'currency': selectedCurrency,
                                          'fname': fnameController.text,
                                          'lname': lnameController.text,
                                          'bank': bankController.text,
                                          'branch': branchController.text,
                                          'branchname':
                                              branchnameController.text,
                                          'pincode': pincodeController.text,
                                        });

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                          content: Text(
                                            "Payment Done",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          backgroundColor: Colors.green,
                                        ));

                                        //   setState(() {
                                        //     hasDonated = true;
                                        //   });
                                        //   fnameController.clear();
                                        //   lnameController.clear();
                                        //   bankController.clear();
                                        //   branchController.clear();
                                        //   branchnameController.clear();
                                        //   pincodeController.clear();
                                      } catch (e) {
                                        print("payment sheet failed");
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                          content: Text(
                                            "Payment Failed",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          backgroundColor: Colors.redAccent,
                                        ));
                                      }
                                    }
                                  },
                                ),
                              ),
                            ]),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
