import 'package:flutter/material.dart';
import 'package:frastraited/Precentation/ui/utility/app_colors.dart';
import 'package:frastraited/Precentation/ui/utility/assets_path.dart';
import 'package:frastraited/screen/widgets/bodyBackground.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:   Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back,
                color: AppColors.primaryColor,),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            InkWell(
              onTap: () {},
              borderRadius: BorderRadius.circular(15),
              child: CircleAvatar(
                radius: 15,
                backgroundColor: Colors.grey.shade300,
                child: Icon(
                  Icons.person,
                  color: Colors.grey,
                ),
              ),
            )
          ],
        ),
      ),
      body: BodyBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [





                ],
              ),
            ),
          ),
        ),
      ),
    );
      Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: AppColors.primaryColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(15),
            child: CircleAvatar(
              radius: 15,
              backgroundColor: Colors.grey.shade300,
              child: Icon(
                Icons.person,
                color: Colors.grey,
              ),
            ),
          )
        ],
      ),
    );
  }
}
