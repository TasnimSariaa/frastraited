import 'package:flutter/material.dart';
import 'package:frastraited/Precentation/ui/utility/app_colors.dart';
import 'package:frastraited/screen/widgets/bodyBackground.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  Color? _hoverColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BodyBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        icon: Icon(
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
                    height: 40,
                  ),
                  ListView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      Material(
                        color: _hoverColor ?? Colors.white,
                        child: InkWell(
                          onTap: () {
                            // Handle Change Password
                          },
                          onHover: (value) {
                            setState(() {
                              _hoverColor = value ? Colors.grey[200] : null;
                            });
                          },
                          child: ListTile(
                            leading: Icon(
                              Icons.lock,
                              color: AppColors.primaryColor,
                            ),
                            title: Text(
                              'Change Password',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Material(
                        color: _hoverColor ?? Colors.white,
                        child: InkWell(
                          onTap: () {
                            // Handle Log Out
                          },
                          onHover: (value) {
                            setState(() {
                              _hoverColor = value ? Colors.grey[200] : null;
                            });
                          },
                          child: ListTile(
                            leading: Icon(
                              Icons.exit_to_app,
                              color: AppColors.primaryColor,
                            ),
                            title: Text(
                              ' Log out ',
                              style: TextStyle(color: Colors.black),
                            ),
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
