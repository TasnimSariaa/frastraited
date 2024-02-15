import 'package:flutter/material.dart';
import 'package:frastraited/Precentation/ui/utility/app_colors.dart';
import 'package:frastraited/Precentation/ui/widgets/app_logo.dart';
import 'package:frastraited/screen/onboarding/loginScreen.dart';
import 'package:frastraited/screen/widgets/bodyBackground.dart';

class resetPasswordScreen extends StatefulWidget {
  const resetPasswordScreen({super.key});

  @override
  State<resetPasswordScreen> createState() => _resetPasswordScreenState();
}

class _resetPasswordScreenState extends State<resetPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BodyBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back,
                          color: AppColors.primaryColor,),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 80,
                  ),
                  const AppLogo(
                    height: 80,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text("Set New Password",
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    'Minimum lenth of the password should be 8 letters',
                    style: Theme.of(context).textTheme.bodySmall,

                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  TextFormField(
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: 'New Password',
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  TextFormField(
                    obscureText: true,
                    decoration: const InputDecoration(
                      hintText: 'Confirm Password',
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) => const pinVerificationScreen(),
                        //   ),
                        // );
                      },
                      child: const Text('Confirm',
                        style: TextStyle(color: Colors.white),),
                    ),
                  ),
                  const SizedBox(
                    height: 48,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "have an acccount?",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black54,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const loginScreen()),
                              (route) => false);
                        },
                        child: Text('Sign In',
                            style: TextStyle(
                              color: AppColors.primaryColor,
                              fontSize: 16,
                            )),
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
