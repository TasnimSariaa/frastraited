import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frastraited/Precentation/ui/utility/app_colors.dart';
import 'package:frastraited/screen/onboarding/loginScreen.dart';
import 'package:frastraited/screen/service/database_service.dart';
import 'package:frastraited/screen/service/models/users.dart';
import 'package:frastraited/screen/widgets/bodyBackground.dart';
import 'package:get/get.dart';

class signUpScreen extends StatefulWidget {
  const signUpScreen({super.key});

  @override
  State<signUpScreen> createState() => _signUpScreenState();
}

class _signUpScreenState extends State<signUpScreen> {
  bool isLoading = false;

  // _signUpScreenState() {
  //   selectedType = userType[0];
  // }

  // final userType = ['User', 'Doctor'];
  // String? selectedType = "User";

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _signUp(String email, String firstName, String lastName, String phone, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);

      await userCredential.user?.updateDisplayName(firstName);

      final model = UsersModel(
        firstName: firstName,
        lastName: lastName,
        userType: "User",
        phone: phone,
        email: email,
        userid: userCredential.user?.uid ?? "",
        medicalId: "${userCredential.user?.uid.substring(0, 8).toUpperCase()}",
      );
      await DatabaseService.instance.setUserInformation(model);
      isLoading = false;
      setState(() {});
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) {
          return const loginScreen();
        }),
      );
    } on FirebaseAuthException catch (e) {
      isLoading = false;
      setState(() {});
      print('FirebaseAuthException: $e');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Registration Failed"),
            content: Text(e.message ?? "An error occurred."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }

  TextEditingController useremailController = TextEditingController();
  TextEditingController userfirstNameController = TextEditingController();
  TextEditingController userlastNameController = TextEditingController();
  TextEditingController userphoneController = TextEditingController();
  TextEditingController userpasswordController = TextEditingController();

  User? currentUser = FirebaseAuth.instance.currentUser;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BodyBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.arrow_back,
                            color: AppColors.primaryColor,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 80,
                    ),
                    Text("Join With Us", style: Theme.of(context).textTheme.titleLarge),
                    const SizedBox(
                      height: 24,
                    ),
                    TextFormField(
                      controller: useremailController,
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
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      controller: userfirstNameController,
                      decoration: const InputDecoration(
                        hintText: 'First Name',
                      ),
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return "Field is required";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      controller: userlastNameController,
                      decoration: const InputDecoration(
                        hintText: 'Last Name',
                      ),
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return "Field is required";
                        }
                        return null;
                      },
                    ),
                    // const SizedBox(
                    //   height: 20,
                    // ),
                    // DropdownButtonFormField(
                    //   value: selectedType,
                    //   items: userType.map((e) {
                    //     return DropdownMenuItem(
                    //       value: e,
                    //       child: Text(e),
                    //     );
                    //   }).toList(),
                    //   onChanged: (val) {
                    //     setState(() {
                    //       selectedType = val as String;
                    //     });
                    //   },
                    //   decoration: InputDecoration(labelText: "User Type ", labelStyle: TextStyle(color: Colors.black)),
                    //   style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500, fontSize: 16),
                    // ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      controller: userphoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        hintText: 'Phone Number',
                      ),
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return "Field is required";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      controller: userpasswordController,
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
                    const SizedBox(
                      height: 16,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          final isValid = formKey.currentState?.validate() ?? false;
                          if (!isValid) return;

                          isLoading = true;
                          setState(() {});
                          _signUp(
                            useremailController.text.trim(),
                            userfirstNameController.text.trim(),
                            userlastNameController.text.trim(),
                            userphoneController.text.trim(),
                            userpasswordController.text.trim(),
                          );
                        },
                        child: isLoading
                            ? const CircularProgressIndicator(color: Colors.white,)
                            : const Text(
                                'Next',
                                style: TextStyle(color: Colors.white),
                              ),
                      ),
                    ),
                    const SizedBox(
                      height: 48,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have an acccount?",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black54,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            'Sign In',
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
      ),
    );
  }
}
