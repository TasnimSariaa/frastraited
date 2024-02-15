import 'package:flutter/material.dart';
import 'package:frastraited/Precentation/ui/screens/admin_site/adminHome/EditActiveDoctorsScreen.dart';
import 'package:frastraited/Precentation/ui/screens/admin_site/adminHome/EditAppointmentScreen.dart';
import 'package:frastraited/Precentation/ui/screens/admin_site/adminHome/EditDonationScreen.dart';
import 'package:frastraited/Precentation/ui/screens/admin_site/adminHome/EditOperationScreen.dart';
import 'package:frastraited/Precentation/ui/screens/admin_site/adminHome/EditPandingTestScreen.dart';
import 'package:frastraited/Precentation/ui/screens/admin_site/adminHome/EditReportCollectionScreen.dart';
import 'package:frastraited/Precentation/ui/screens/admin_site/adminHome/EditVaccineScreen.dart';
import 'package:frastraited/Precentation/ui/screens/history_screen.dart';
import 'package:frastraited/Precentation/ui/screens/profile_screen.dart';
import 'package:frastraited/Precentation/ui/utility/app_colors.dart';
import 'package:frastraited/Precentation/ui/utility/assets_path.dart';
import 'package:frastraited/Precentation/ui/widgets/home/circle_Icon_button.dart';
import 'package:frastraited/screen/homeCardsScreens/activeDoctor_screen.dart';
import 'package:frastraited/screen/homeCardsScreens/appointment_screen.dart';
import 'package:frastraited/screen/homeCardsScreens/donation_screen.dart';
import 'package:frastraited/screen/homeCardsScreens/operatinPac_screen.dart';
import 'package:frastraited/screen/homeCardsScreens/pandingTests_screen.dart';
import 'package:frastraited/screen/homeCardsScreens/reportCollection_screen.dart';
import 'package:frastraited/screen/homeCardsScreens/vaccinePac_screen.dart';
import 'package:frastraited/screen/widgets/bodyBackground.dart';

class HomeScreen extends StatefulWidget {
  final bool admin;

  const HomeScreen({Key? key, required this.admin}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, dynamic>> categories = [
    {'category': 'Active doctors', 'icon': Icons.person},
    {'category': 'Operation Packages', 'icon': Icons.personal_injury_outlined},
    {'category': 'Vaccine Packages', 'icon': Icons.medical_services},
    {'category': 'Appointment', 'icon': Icons.event},
    {'category': 'Collect Reports', 'icon': Icons.receipt},
    {'category': 'Donation', 'icon': Icons.real_estate_agent_outlined},
    {'category': 'Pending Tests', 'icon': Icons.hourglass_bottom},
  ];

  int _selectedIndex = 0;

  List<Widget> get _screens {
    if (widget.admin) {
      return const [
        EditActiveDoctors(),
        EditOperation(),
        EditVaccine(),
        EditAppointment(),
        EditReportCollection(),
        EditDonation(),
        EditPendingTest(),
      ];
    } else {
      return const [
        ActiveDoctor(),
        OperationScreen(),
        VaccineScreen(),
        Appointment(),
        ReportCollection(),
        Donation(),
        PendingTests(),
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: BodyBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 8),
                  searchTextField,
                  const SizedBox(height: 16),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 1,
                      mainAxisSpacing: 1,
                    ),
                    itemCount: categories.length,
                    itemBuilder: (BuildContext context, int index) {
                      return _buildCategoryCard(
                        category: categories[index]['category'],
                        icon: categories[index]['icon'],
                        onTap: () {
                          setState(() {
                            _selectedIndex = index;
                          });
                          navigateToScreen(index);
                        },
                        isSelected: _selectedIndex == index,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard({
    required String category,
    required IconData icon,
    required VoidCallback onTap,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: Colors.white,
        elevation: 3,
        shape: RoundedRectangleBorder(
          side: isSelected
              ? BorderSide(color: AppColors.primaryColor, width: 2)
              : BorderSide.none,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: AppColors.primaryColor, size: 36),
                const SizedBox(height: 8),
                Text(
                  category,
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void navigateToScreen(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => _screens[index]),
    );
  }

  TextFormField get searchTextField {
    return TextFormField(
      decoration: InputDecoration(
        hintText: 'Search',
        filled: true,
        fillColor: Colors.grey.shade200,
        prefixIcon: const Icon(Icons.search, color: Colors.grey),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(10),
        ),
        errorBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
      ),
    );
  }

  AppBar get appBar {
    return AppBar(
      backgroundColor: Colors.transparent,
      actions: [
        const SizedBox(width: 8),
        CircleIconButton(
          onTap: () {},
          iconData: Icons.call,
        ),
        const SizedBox(width: 8),
        CircleIconButton(
          onTap: () {},
          iconData: Icons.notifications_active_outlined,
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}
