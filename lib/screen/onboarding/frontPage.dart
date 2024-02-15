import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frastraited/Precentation/ui/screens/admin_site/adminFrontScreen.dart';
import 'package:frastraited/screen/onboarding/loginScreen.dart';
import 'package:frastraited/screen/widgets/bodyBackground.dart';

class frontPage extends StatefulWidget {
  const frontPage({Key? key}) : super(key: key);

  @override
  State<frontPage> createState() => _frontPageState();
}

class _frontPageState extends State<frontPage> {
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
                  SvgPicture.asset(
                    'assets/images/medical1.svg',
                    width: 400,
                    //height: double.infinity,
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const loginScreen(),
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
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AdminFront(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero
                        ),
                      ),
                      child: Text('Assistant Register',
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