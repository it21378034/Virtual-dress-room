import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

Future createPaymentIntent(
    {required String fname,
    required String lname,
    required String pin,
    required String bank,
    required String branch,
    required String branchname,
    required String currency,
    required String amount}) async {
  final url = Uri.parse('https://api.stripe.com/v1/payment_intents');
  final secretKey = dotenv.env["STRIPE_SECRET_KEY"]!;
  final body = {
    'amount': amount,
    'currency': currency.toLowerCase(),
    'automatic_payment_methods[enabled]': 'true',
    'description': "Test Donation",
    'shipping[name]': fname,
    'shipping[address][line1]': lname,
    'shipping[address][postal_code]': pin,
    'shipping[address][city]': bank,
    'shipping[address][state]': branch,
    'shipping[address][country]': branchname
  };

  final response = await http.post(url,
      headers: {
        "Authorization": "Bearer $secretKey",
        'Content-Type': 'application/x-www-form-urlencoded'
      },
      body: body);

  print(body);

  if (response.statusCode == 200) {
    var json = jsonDecode(response.body);
    print(json);
    return json;
  } else {
    print("error in calling payment intent");
  }
}
