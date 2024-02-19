import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frastraited/Precentation/ui/screens/Payments_screen.dart';
import 'package:frastraited/Precentation/ui/screens/history_screen.dart';
import 'package:frastraited/Precentation/ui/screens/home_screen.dart';
import 'package:frastraited/Precentation/ui/screens/profile_screen.dart';
import 'package:frastraited/Precentation/ui/utility/app_colors.dart';
import 'package:frastraited/screen/service/database_service.dart';

class MainBottomNavScreen extends StatefulWidget {
  const MainBottomNavScreen({super.key});

  @override
  State<MainBottomNavScreen> createState() => _MainBottomNavScreenState();
}

class _MainBottomNavScreenState extends State<MainBottomNavScreen> {
  int _selectedIndex = 0;
  List<Widget> _adminScreens = [];
  List<Widget> _usersScreens = [];
  bool isAdmin = false;

  @override
  void initState() {
    super.initState();
    if (FirebaseAuth.instance.currentUser != null) {
      _getUser(FirebaseAuth.instance.currentUser!.uid);
    }
    _adminScreens = [
      const HomeScreen(),
      const ProfileScreen(),
    ];
    _usersScreens = [
      const HomeScreen(),
      const HistoryScreen(paymentInfo: {}),
      PaymentsScreen(category: '', type: '', payable: ''),
      const ProfileScreen(),
    ];
  }

  void _getUser(String uid) async {
    final user = await DatabaseService.instance.getUserInfo(uid);
    setState(() {
      isAdmin = user.userType.toLowerCase() == "admin";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isAdmin ? _adminScreens[_selectedIndex] : _usersScreens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.primaryColor,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          const BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
          if (!isAdmin) const BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          if (!isAdmin) const BottomNavigationBarItem(icon: Icon(Icons.attach_money), label: 'Payments'),
          const BottomNavigationBarItem(icon: Icon(Icons.account_circle_rounded), label: 'Profile'),
        ],
      ),
    );
  }
}
