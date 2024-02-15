import 'package:flutter/material.dart';
import 'package:frastraited/Precentation/ui/utility/app_colors.dart';
import 'package:frastraited/Precentation/ui/widgets/app_logo.dart';
import 'package:frastraited/screen/onboarding/loginScreen.dart';
import 'package:frastraited/screen/onboarding/resetPasswordScreen.dart';
import 'package:frastraited/screen/widgets/bodyBackground.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class pinVerificationScreen extends StatefulWidget {
  const pinVerificationScreen({super.key});

  @override
  State<pinVerificationScreen> createState() => _pinVarificationScreenState();
}

class _pinVarificationScreenState extends State<pinVerificationScreen> {
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
                  Text("PIN Verification",
                      style: Theme.of(context).textTheme.titleLarge
                  ),
                  const SizedBox(
                    height: 8,
                  ),

                  Text("A 6 digit varification pin send to your email",
                      style: Theme.of(context).textTheme.bodySmall,


                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  PinCodeTextField(
                    length: 4,
                    obscureText: false,
                    animationType: AnimationType.fade,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    keyboardType: TextInputType.number,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(2),
                      fieldHeight: 50,
                      fieldWidth: 40,
                      activeFillColor: Colors.transparent,
                      activeColor: Colors.green,
                      selectedFillColor: Colors.transparent,
                      inactiveFillColor: Colors.transparent,
                      inactiveColor: AppColors.primaryColor,
                      selectedColor: Colors.purple,
                    ),
                    animationDuration: const Duration(milliseconds: 300),
                    enableActiveFill: true,
                    onCompleted: (v) {
                      print("Completed");
                    },
                    onChanged: (value) {

                    },
                    beforeTextPaste: (text) {
                      return true;
                    },appContext: context,
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
                            builder: (context) => const resetPasswordScreen(),
                          ),
                        );

                      },
                      child: const Text('Verify',
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
                  const SizedBox(
                    height: 20,
                  ),
                  const Text('The code will expire in 120s',
                  style: TextStyle(color: Colors.grey),),
                  const SizedBox(
                    height: 8,
                  ),
                  TextButton(onPressed: (){}, child: Text('Resend Code')),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
