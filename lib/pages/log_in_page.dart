import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:recipe_app/constants.dart';
import 'package:recipe_app/helper/snackbar.dart';
import 'package:recipe_app/pages/home_page.dart';
import 'package:recipe_app/pages/sign_up_page.dart';
import 'package:recipe_app/widgets/custom_button.dart';
import 'package:recipe_app/widgets/custom_text_field.dart';

class LogInPage extends StatefulWidget {
  const LogInPage({super.key});
  static String id = "logInPage";

  @override
  State<LogInPage> createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  String? email, password;
  final GlobalKey<FormState> formState = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      color: Colors.black,
      inAsyncCall: isLoading,
      progressIndicator: const CircularProgressIndicator(color: Colors.black),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(
            "Foudiy",
            style: GoogleFonts.epilogue(
              color: kTitleColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Form(
          key: formState,
          child: ListView(
            children: [
              Image.asset(
                "assets/secound_one.png",
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 20),
              Text(
                "Welcome Back",
                style: GoogleFonts.epilogue(
                  fontSize: 30,
                  color: kTitleColor,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              CustomTextField(
                label: "Email",
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your email";
                  }
                  return null;
                },
                onChanged: (data) => email = data,
              ),
              const SizedBox(height: 12),
              CustomTextField(
                label: "Password",
                obscure: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your password";
                  }
                  return null;
                },
                onChanged: (data) => password = data,
              ),
              const SizedBox(height: 15),
              GestureDetector(
                onTap: () {
                  // Handle Forgot Password
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18),
                  child: Text(
                    "Forget password?",
                    style: TextStyle(
                      color: Color(0xff8A7361),
                      fontSize: 16,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 13),
                child: CustomButtonLogIn(
                  text: "Log in",
                  onTap: _handleLogin,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("New User? ",
                      style: TextStyle(color: Colors.black, fontSize: 16)),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, SignUpPage.id),
                    child: Text(
                      "Sign Up",
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

  Future<void> _handleLogin() async {
    if (formState.currentState == null || !formState.currentState!.validate()) {
      showSnackBarr(context, "Please fill all fields correctly.", 'Error',
          ContentType.failure);
      return;
    }

    try {
      setState(() => isLoading = true);
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email!,
        password: password!,
      );

      // ignore: use_build_context_synchronously
      showSnackBarr(context, 'Successfully logged in!', 'Welcome to Foudiy',
          ContentType.success);
      // ignore: use_build_context_synchronously
      Navigator.pushNamed(context, Home.id, arguments: email);
    } on FirebaseAuthException catch (e) {
      setState(() => isLoading = false);

      if (e.code == 'user-not-found') {
        // ignore: use_build_context_synchronously
        showSnackBarr(context, "No user found for that email.", 'Error',
            ContentType.failure);
      } else if (e.code == 'wrong-password') {
        showSnackBarr(
            // ignore: use_build_context_synchronously
            context, "Incorrect password.", 'Error', ContentType.failure);
      } else {
        // ignore: use_build_context_synchronously
        showSnackBarr(context, e.message ?? 'Unknown error occurred.', 'Error',
            ContentType.failure);
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
