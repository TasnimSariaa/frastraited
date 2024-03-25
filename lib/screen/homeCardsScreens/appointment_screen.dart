import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frastraited/Precentation/ui/screens/Payments_screen.dart';
import 'package:frastraited/Precentation/ui/utility/app_colors.dart';
import 'package:frastraited/Precentation/ui/widgets/empty_container_view.dart';
import 'package:frastraited/screen/service/database_service.dart';
import 'package:frastraited/screen/service/models/doctors.dart';
import 'package:frastraited/screen/utils/custom_string_constants.dart';
import 'package:frastraited/screen/widgets/bodyBackground.dart';

class Appointment extends StatefulWidget {
  const Appointment({super.key});

  @override
  State<Appointment> createState() => _AppointmentState();
}

class _AppointmentState extends State<Appointment> {
  DoctorModel selectedDoctor = DoctorModel.empty();
  List<DoctorModel> activeDoctors = [];
  bool isLoading = true;

  bool get isDoctorNotSelected => selectedDoctor == DoctorModel.empty();

  void onDoctorSelectListener(DoctorModel doctor) {
    setState(() => selectedDoctor = doctor);
  }

  @override
  void initState() {
    super.initState();
    _getDoctorList();
  }

  void _getDoctorList() async {
    final result = await DatabaseService.instance.getDoctorInformation();
    activeDoctors.clear();
    activeDoctors.addAll(result);
    isLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BodyBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.arrow_back,
                        color: AppColors.primaryColor,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Stack(
                  children: [
                    Container(
                      height: 230,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    Positioned(
                      top: 45,
                      right: 44,
                      child: Container(
                        width: 175,
                        height: 163,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 60,
                      right: 40,
                      child: SvgPicture.asset(
                        'assets/images/appointment(11).svg',
                        width: 150,
                        height: 150,
                      ),
                    ),
                    const Positioned(
                      left: 20,
                      top: 47,
                      child: Text(
                        "Book",
                        style: TextStyle(fontSize: 27, color: Colors.white),
                      ),
                    ),
                    const Positioned(
                      left: 20,
                      top: 70,
                      child: Text(
                        "Appointment",
                        style: TextStyle(fontSize: 27, color: Colors.white),
                      ),
                    ),
                    Positioned(
                      left: 20,
                      bottom: 53,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: () {
                          if (!isDoctorNotSelected) {
                            _showAppointmentConfirmationDialog(context);
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Error'),
                                content: const Text('Please choose a doctor from the list.'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Close'),
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                        child: const Text(
                          "  Book Appointment  ",
                          style: TextStyle(fontSize: 18, color: AppColors.primaryColor),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                const Text(
                  ' Doctor List ',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 10),
                _view,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget get _view {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (activeDoctors.isEmpty) {
      return const Center(child: EmptyContainerView());
    } else {
      return Expanded(
        child: ListView.builder(
          itemCount: activeDoctors.length,
          itemBuilder: (context, index) {
            final doctor = activeDoctors[index];
            return GestureDetector(
              onTap: () => onDoctorSelectListener(doctor),
              child: Card(
                borderOnForeground: true,
                color: Colors.white,
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: selectedDoctor == doctor ? const BorderSide(color: AppColors.primaryColor, width: 2) : BorderSide.none,
                ),
                child: Container(
                  height: 120,
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      Container(
                        width: 120,
                        height: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: NetworkImage(doctor.profileImageUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              doctor.name,
                              style: const TextStyle(fontSize: 18, color: AppColors.primaryColor),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              doctor.speciality,
                              style: const TextStyle(color: Colors.grey),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Fees: ${doctor.visitingFee}',
                              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      );
    }
  }

  void _showAppointmentConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Appointment Confirmation'),
        content: Text('You have to pay ${selectedDoctor.visitingFee} for the appointment.'),
        actions: [
          TextButton(
            onPressed: () {
              // Navigate to Payment Screen with required information
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PaymentsScreen(
                    category: 'Appointment',
                    type: selectedDoctor.name,
                    payable: selectedDoctor.visitingFee,
                    doctor: selectedDoctor.toJson(),
                    screenName: CustomStringConstants.appointmentScreen,
                  ),
                ),
              );
            },
            child: const Text('Pay'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
