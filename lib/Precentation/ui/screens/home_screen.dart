import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:frastraited/Precentation/ui/screens/admin_site/adminHome/EditActiveDoctorsScreen.dart';
import 'package:frastraited/Precentation/ui/screens/admin_site/adminHome/EditAppointmentScreen.dart';
import 'package:frastraited/Precentation/ui/screens/admin_site/adminHome/EditDonationScreen.dart';
import 'package:frastraited/Precentation/ui/screens/admin_site/adminHome/EditOperationScreen.dart';
import 'package:frastraited/Precentation/ui/screens/admin_site/adminHome/EditPandingTestScreen.dart';
import 'package:frastraited/Precentation/ui/screens/admin_site/adminHome/EditReportCollectionScreen.dart';
import 'package:frastraited/Precentation/ui/screens/admin_site/adminHome/EditVaccineScreen.dart';
import 'package:frastraited/Precentation/ui/screens/notification_screen.dart';
import 'package:frastraited/Precentation/ui/utility/app_colors.dart';
import 'package:frastraited/Precentation/ui/utility/search_field.dart';
import 'package:frastraited/Precentation/ui/widgets/home/circle_Icon_button.dart';
import 'package:frastraited/screen/homeCardsScreens/activeDoctor_screen.dart';
import 'package:frastraited/screen/homeCardsScreens/appointment_screen.dart';
import 'package:frastraited/screen/homeCardsScreens/donation_screen.dart';
import 'package:frastraited/screen/homeCardsScreens/operatinPac_screen.dart';
import 'package:frastraited/screen/homeCardsScreens/pendingTests_screen.dart';
import 'package:frastraited/screen/homeCardsScreens/reportCollection_screen.dart';
import 'package:frastraited/screen/homeCardsScreens/vaccinePac_screen.dart';
import 'package:frastraited/screen/service/database_service.dart';
import 'package:frastraited/screen/service/models/users.dart';
import 'package:frastraited/screen/widgets/bodyBackground.dart';
// Import the SearchField widget

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

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
  int _hoveredIndex = -1;

  bool isAdmin = false;

  UsersModel userModel = UsersModel.empty();

  @override
  void initState() {
    super.initState();
    if (FirebaseAuth.instance.currentUser != null) {
      _getUser(FirebaseAuth.instance.currentUser!.uid);
    }
  }

  void _getUser(String uid) async {
    final user = await DatabaseService.instance.getUserInfo(uid);
    setState(() {
      userModel = user;
      isAdmin = user.userType.toLowerCase() == "admin";
    });
  }

  List<Widget> get _screens {
    if (isAdmin) {
      return const [
        EditActiveDoctors(),
        EditOperation(),
        EditVaccine(),
        EditAppointment(
          category: '',
          type: '',
          payable: '',
        ),
        EditReportCollection(),
        EditDonation(),
        EditPendingTest(),
      ];
    } else {
      return [
        const ActiveDoctor(),
        const OperationScreen(),
        const VaccineScreen(),
        Appointment(user: userModel),
        const ReportCollection(),
        const Donation(),
        const PendingTests(),
      ];
    }
  }

  TextEditingController searchController = TextEditingController();

  List<Map<String, dynamic>> get filteredCategories {
    String query = searchController.text.toLowerCase();
    return categories.where((cat) => cat['category'].toLowerCase().contains(query)).toList();
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
                  SearchField(
                    controller: searchController,
                    onTextChanged: (value) {
                      setState(() {}); // Trigger rebuild on text change
                    },
                  ), // Use the SearchField widget
                  const SizedBox(height: 16),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 1,
                      mainAxisSpacing: 1,
                    ),
                    itemCount: filteredCategories.length,
                    itemBuilder: (BuildContext context, int index) {
                      final category = filteredCategories[index];
                      return _buildCategoryCard(
                        category: category['category'],
                        icon: category['icon'],
                        onTap: () {
                          setState(() {
                            _selectedIndex = index;
                          });
                          navigateToScreen(index);
                        },
                        isSelected: _selectedIndex == index,
                        isHovered: _hoveredIndex == index,
                        onHover: (value) {
                          setState(() {
                            _hoveredIndex = value ? index : -1;
                          });
                        },
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
    required bool isHovered,
    required ValueChanged<bool> onHover,
  }) {
    return MouseRegion(
      onEnter: (_) => onHover(true),
      onExit: (_) => onHover(false),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 50,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          // Example margin values
          decoration: BoxDecoration(
            color: isHovered ? Colors.grey.shade100 : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? AppColors.primaryColor : Colors.transparent,
              width: 2,
            ),
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
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
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

  AppBar get appBar {
    return AppBar(
      backgroundColor: AppColors.primaryColor,
      actions: [
        const SizedBox(width: 8),
        CircleIconButton(
          onTap: () {},
          iconData: Icons.call,
        ),
        const SizedBox(width: 8),
        CircleIconButton(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const NotificationScreen(category: '', type: '', payable: ''),
              ),
            );
          },
          iconData: Icons.notifications_active_outlined,
        ),
        const SizedBox(width: 8),
      ],
    );
  }
}
