import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:recipe_app/constants.dart';
import 'package:recipe_app/helper/snackbar.dart';
import 'package:recipe_app/pages/home_page.dart';
import 'package:recipe_app/widgets/custom_button.dart';
import 'package:recipe_app/widgets/custom_text_field.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});
  static String id = "signUpPage";

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  String? email, password, number, username;
  final users = FirebaseFirestore.instance.collection("users");
  final GlobalKey<FormState> formState = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      color: Colors.black,
      progressIndicator: const CircularProgressIndicator(color: Colors.black),
      child: Scaffold(
        body: Form(
          key: formState,
          child: ListView(
            children: [
              Image.asset(
                "assets/third_one.png",
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 15),

              // Header Row
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back),
                  ),
                  const Spacer(flex: 3),
                  Text(
                    "Sign Up",
                    style: GoogleFonts.epilogue(
                      fontSize: 20,
                      color: kTitleColor,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const Spacer(flex: 4),
                ],
              ),
              const SizedBox(height: 15),

              // Username
              CustomTextField(
                label: "Username",
                onChanged: (data) => username = data,
                validator: (value) => value == null || value.isEmpty
                    ? "Username is required"
                    : null,
              ),
              const SizedBox(height: 12),

              // Email
              CustomTextField(
                label: "Email",
                onChanged: (data) => email = data,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Email is required";
                  }
                  if (!RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(value)) {
                    return "Enter a valid email";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // Phone Number
              CustomTextField(
                label: "Phone Number",
                type: TextInputType.phone,
                onChanged: (data) => number = data,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Phone number is required";
                  }
                  if (!RegExp(r"^[0-9]{10}$").hasMatch(value)) {
                    return "Enter a valid 10-digit phone number";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              // Password
              CustomTextField(
                label: "Password",
                obscure: true,
                onChanged: (data) => password = data,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Password is required";
                  }
                  if (value.length < 6) {
                    return "Password must be at least 6 characters long";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),

              // Sign-Up Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: CustomButtonLogIn(
                  text: "Sign Up",
                  onTap: _signUpUser,
                ),
              ),
              const SizedBox(height: 12),

              // Already Have Account
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already Have an Account? ",
                    style: GoogleFonts.epilogue(
                      color: kTitleColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Text(
                      "Log in",
                      style: GoogleFonts.epilogue(
                        color: kTitleColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _signUpUser() async {
    if (formState.currentState == null || !formState.currentState!.validate()) {
      showSnackBarr(context, "Please fill all fields correctly.", 'Error',
          ContentType.failure);
      return;
    }

    try {
      setState(() => isLoading = true);

      // Register user with Firebase Authentication
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email!,
        password: password!,
      );

      // Save additional user details in Firestore
      await users.doc(userCredential.user!.uid).set({
        'username': username,
        'favorites': [],
        'email': email,
        'phone': number,
      });

      // ignore: use_build_context_synchronously
      showSnackBarr(context, 'Account created successfully.',
          'Welcome to Foudiy', ContentType.success);

      // ignore: use_build_context_synchronously
      Navigator.pushNamed(context, Home.id, arguments: email);
    } on FirebaseAuthException catch (e) {
      setState(() => isLoading = false);
      if (e.code == "invalid-email") {
        // ignore: use_build_context_synchronously
        showSnackBarr(context, 'Invalid Email.', 'Error', ContentType.failure);
      } else if (e.code == 'weak-password') {
        showSnackBarr(
            // ignore: use_build_context_synchronously
            context, 'Password is too weak.', 'Error', ContentType.failure);
      } else if (e.code == 'email-already-in-use') {
        showSnackBarr(
            // ignore: use_build_context_synchronously
            context, 'Email already exists.', 'Error', ContentType.failure);
      } else {
        // ignore: use_build_context_synchronously
        showSnackBarr(context, e.message ?? 'An unknown error occurred.',
            'Error', ContentType.failure);
      }
    } catch (e) {
      setState(() => isLoading = false);
      showSnackBarr(
          // ignore: use_build_context_synchronously
          context, "Error: ${e.toString()}", 'Error', ContentType.failure);
    } finally {
      setState(() => isLoading = false);
    }
  }
}
