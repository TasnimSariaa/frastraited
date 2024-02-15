import 'package:flutter/material.dart';
import 'package:frastraited/Precentation/ui/utility/app_colors.dart';
import 'package:frastraited/Precentation/ui/widgets/app_logo.dart';
import 'package:frastraited/screen/onboarding/pinVerificationScreen.dart';
import 'package:frastraited/screen/widgets/bodyBackground.dart';

class forgotPasswordScreen extends StatefulWidget {
  const forgotPasswordScreen({super.key});

  @override
  State<forgotPasswordScreen> createState() => _forgotPasswordScreenState();
}

class _forgotPasswordScreenState extends State<forgotPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
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
                  Text("Your Email Address",
                      style: Theme.of(context).textTheme.titleLarge
                  ),
                  const SizedBox(
                    height: 8,
                  ),

                  Text("A 8 digit varification pin will dasend to your email",
                    style: Theme.of(context).textTheme.bodySmall,

                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      hintText: 'Email',
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const pinVerificationScreen(),
                          ),
                        );

                      },
                      child: const Text('Next',
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
                          Navigator.pop(context);
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
