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
import 'package:frastraited/admin/screen/notification/admin_notification_screen.dart';
import 'package:frastraited/screen/homeCardsScreens/activeDoctor_screen.dart';
import 'package:frastraited/screen/homeCardsScreens/appointment_screen.dart';
import 'package:frastraited/screen/homeCardsScreens/donation_screen.dart';
import 'package:frastraited/screen/homeCardsScreens/operatinPac_screen.dart';
import 'package:frastraited/screen/homeCardsScreens/pendingTests_screen.dart';
import 'package:frastraited/screen/homeCardsScreens/reportCollection_screen.dart';
import 'package:frastraited/screen/homeCardsScreens/vaccinePac_screen.dart';
import 'package:frastraited/screen/service/database_service.dart';
import 'package:frastraited/screen/widgets/bodyBackground.dart';
import 'package:url_launcher/url_launcher.dart';
// Import the SearchField widget

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> tempCategoriesList = [];
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

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (FirebaseAuth.instance.currentUser != null) {
      _getUser(FirebaseAuth.instance.currentUser!.uid);
    }
    searchController.addListener(_onSearchChanged);
    tempCategoriesList = categories;
  }

  void _getUser(String uid) async {
    final user = await DatabaseService.instance.getUserInfo(uid);
    setState(() {
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
        const Appointment(),
        const ReportCollection(),
        const Donation(),
        const PendingTests(),
      ];
    }
  }

  void _onSearchChanged() {
    String query = searchController.text.toLowerCase();
    if (query.isEmpty) {
      tempCategoriesList = categories;
    } else {
      tempCategoriesList = categories.where((searchValue) {
        String name = searchValue['category'].toLowerCase();
        return name.contains(query);
      }).toList();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: BodyBackground(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsetsDirectional.only(start: 20, end: 20),
              child: SearchField(
                controller: searchController,
                onTextChanged: (val) {},
              ),
            ), // Use the SearchField widget
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                ),
                padding: const EdgeInsetsDirectional.only(start: 20, end: 20, bottom: 40),
                itemCount: tempCategoriesList.length,
                itemBuilder: (BuildContext context, int index) {
                  final category = tempCategoriesList[index];
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
            ),
          ],
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
          decoration: BoxDecoration(
            color: isHovered ? Colors.grey.shade100 : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? AppColors.primaryColor : Colors.transparent,
              width: 2,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
    );
  }

  void navigateToScreen(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => _screens[index]),
    );
  }

  Future<void> _launchUrl() async {
    final _url = Uri(
      scheme: 'tel',
      path: '01615644044',
    );
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  AppBar get appBar {
    return AppBar(
      backgroundColor: AppColors.primaryColor,
      automaticallyImplyLeading: false,
      actions: [
        const SizedBox(width: 8),
        CircleIconButton(
          onTap: () => _launchUrl(),
          iconData: Icons.call,
        ),
        const SizedBox(width: 8),
        CircleIconButton(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => isAdmin ? const AdminNotificationScreen() : const NotificationScreen(category: '', type: '', payable: ''),
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
