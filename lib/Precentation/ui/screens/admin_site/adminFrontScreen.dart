import 'package:flutter/material.dart';
import 'package:frastraited/Precentation/ui/screens/admin_site/adminVarificationScreen.dart';
import 'package:frastraited/screen/onboarding/loginScreen.dart';
import 'package:frastraited/screen/widgets/bodyBackground.dart';

class AdminFront extends StatefulWidget {
  const AdminFront({super.key});

  @override
  State<AdminFront> createState() => _AdminFrontState();
}

class _AdminFrontState extends State<AdminFront> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BodyBackground(
        child: Center(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AdminVerificationScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero
                        ),
                      ),
                      child: Text('Patient Site',
                        style: TextStyle(color: Colors.white),),
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigate to Patient Site
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero
                        ),
                      ),
                      child: Text('Researcher Site',
                        style: TextStyle(color: Colors.white),),
                    ),

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
