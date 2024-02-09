import 'package:flutter/material.dart';
import 'package:frastraited/Precentation/ui/screens/history_screen.dart';
import 'package:frastraited/Precentation/ui/screens/home_screen.dart';
import 'package:frastraited/Precentation/ui/screens/profile_screen.dart';
import 'package:frastraited/Precentation/ui/utility/app_colors.dart';

class MainBottomNavScreen extends StatefulWidget {
  const MainBottomNavScreen({super.key});

  @override
  State<MainBottomNavScreen> createState() => _MainBottomNavScreenState();
}

class _MainBottomNavScreenState extends State<MainBottomNavScreen> {
int _selectedIndex =0;
final List<Widget> _screens= const[
  HomeScreen(),
  HistoryScreen(),
  HomeScreen(),
  ProfileScreen(),
];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _screens[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          selectedItemColor: AppColors.primaryColor,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          onTap: (index){
            _selectedIndex=index;
            if (mounted){
              setState((){});
            }
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
            BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
            BottomNavigationBarItem(icon: Icon(Icons.account_circle_rounded), label: 'Profile'),
          ],
        ),
      );
  }
}
