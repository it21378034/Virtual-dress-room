import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:virtual_dress_room/componets/logging/forgot.dart';
import 'package:virtual_dress_room/componets/pages/home.dart';
import 'package:virtual_dress_room/componets/register/signup.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.1,
        backgroundColor: Colors.blue,
        title: Text("Login"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              //crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Welcome!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                _buildInputField(Icons.email, "Email", emailController),
                SizedBox(height: 20),
                _buildPasswordField(Icons.lock, "Password", passwordController),
                SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => Get.to(Forgot()),
                    child: Text("Forgot password ?"),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => signIn(),
                  child: Text("Login"),
                ),
                SizedBox(height: 30),
                TextButton(
                  onPressed: () => Get.to(Signup()),
                  child: Text("Register now"),
                ),
                SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    signInWithGoogle();
                  },
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.white,
                    ),
                    child: Center(
                      child: SizedBox(
                          height: 30, child: Image.asset('asset/google.png')),
                    ),
                  ),
                ),
                // ElevatedButton.icon(
                //   onPressed: () => signInWithGoogle(),
                //   icon: Icon(Icons.account_circle_outlined),
                //   label: Text("Sign in with Google"),
                //   style: ElevatedButton.styleFrom(
                //     foregroundColor: Colors.white,
                //     backgroundColor: Colors.red,
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(20),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(
      IconData icon, String hintText, TextEditingController controller) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: hintText,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
      ),
    );
  }

  Widget _buildPasswordField(
      IconData icon, String hintText, TextEditingController controller) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: hintText,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        obscureText: true,
      ),
    );
  }

  Future<void> signIn() async {
    setState(() {
      isLoading = true;
    });
    try {
      await _auth.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      Get.offAll(
          HomePage()); // Navigate to HomePage and remove all previous routes
    } on FirebaseAuthException catch (e) {
      Get.snackbar("Error", e.message ?? "An error occurred");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> signInWithGoogle() async {
    setState(() {
      isLoading = true;
    });
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
        final UserCredential authResult =
            await _auth.signInWithCredential(credential);
        final User? user = authResult.user;
        if (user != null) {
          Get.offAll(
              HomePage()); // Navigate to HomePage and remove all previous routes
        }
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
}
