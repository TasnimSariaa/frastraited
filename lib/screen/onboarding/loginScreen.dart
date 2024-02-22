import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frastraited/Precentation/ui/screens/main_bottom_nav_screen.dart';
import 'package:frastraited/Precentation/ui/utility/app_colors.dart';
import 'package:frastraited/screen/onboarding/forgotPasswordScreen.dart';
import 'package:frastraited/screen/onboarding/signUpScreen.dart';
import 'package:frastraited/screen/widgets/bodyBackground.dart';
import 'package:get/get.dart';

class loginScreen extends StatefulWidget {
  const loginScreen({Key? key}) : super(key: key);

  @override
  State<loginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  TextEditingController loginemailController = TextEditingController();
  TextEditingController loginpasswordController = TextEditingController();

  bool isLoading = false;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BodyBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  SvgPicture.asset(
                    'assets/images/medical_care_logo.svg',
                    height: 220,
                    width: 220,
                    //height: double.infinity,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    "Welcome Back",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Please enter your logged in Email Address",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: loginemailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: 'Email',
                    ),
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return "Field is required";
                      }
                      if (val.isNotEmpty && !val.isEmail) {
                        return "Invalid email address";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: loginpasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: 'Password',
                    ),
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return "Field is required";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        final isValid = formKey.currentState?.validate() ?? false;
                        if (!isValid) return;

                        isLoading = true;
                        setState(() {});
                        var loginEmail = loginemailController.text.trim();
                        var loginPass = loginpasswordController.text.trim();
                        try {
                          final User? firebaseUser = (await FirebaseAuth.instance.signInWithEmailAndPassword(email: loginEmail, password: loginPass)).user;
                          if (firebaseUser != null) {
                            // final user = await DatabaseService.instance.getUserInfo(firebaseUser.uid);
                            isLoading = false;
                            setState(() {});
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MainBottomNavScreen(),
                              ),
                            );
                          } else {
                            isLoading = false;
                            setState(() {});
                            print("Check Email and password");
                          }
                        } on FirebaseAuthException catch (e) {
                          isLoading = false;
                          setState(() {});
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Authentication Error'),
                                content: Text(e.message ?? 'An error occurred'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(); // Close the dialog
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      },
                      child: isLoading
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(color: Colors.white),
                            )
                          : const Text(
                              'Next',
                              style: TextStyle(color: Colors.white),
                            ),
                    ),
                  ),
                  const SizedBox(height: 48),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const forgotPasswordScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'Forgot Password?',
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an acccount?",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black54,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const signUpScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
