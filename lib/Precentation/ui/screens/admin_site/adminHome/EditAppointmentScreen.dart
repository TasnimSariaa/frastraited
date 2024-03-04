import 'package:flutter/material.dart';
import 'package:frastraited/Precentation/ui/utility/app_colors.dart';
import 'package:frastraited/screen/service/database_service.dart';
import 'package:frastraited/screen/service/models/book_apointment_model.dart';
import 'package:frastraited/screen/widgets/bodyBackground.dart';

class EditAppointment extends StatefulWidget {
  final String category;
  final String type;
  final String payable;

  const EditAppointment({
    required this.category,
    required this.type,
    required this.payable,
    super.key,
  });

  @override
  State<EditAppointment> createState() => _EditAppointmentState();
}

class _EditAppointmentState extends State<EditAppointment> {
  List<BookAppointmentModel> appointmentList = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getDoctorList();
  }

  void _getDoctorList() async {
    appointmentList.clear();
    final result = await DatabaseService.instance.getAdminBookAppointment();
    appointmentList.addAll(result);
    isLoading = false;
    setState(() {});
  }

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
                  const SizedBox(height: 10),
                  const Text(
                    'Appointment List',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 40),
                  ...List.generate(appointmentList.length, (index) {
                    final appointment = appointmentList[index];
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      margin: const EdgeInsetsDirectional.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Booked by: ${appointment.user.firstName} ${appointment.user.lastName}',
                            style: const TextStyle(fontSize: 18, color: AppColors.primaryColor),
                          ),
                          Text(
                            'With Doctor:  ${appointment.doctor["name"]}',
                            style: const TextStyle(fontSize: 18, color: Colors.black),
                          ),
                          Text(
                            'Transaction Id:   ${appointment.transactionId}',
                            style: const TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                          Text(
                            'Status: ${appointment.status}',
                            style: const TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                          if (appointment.status.toLowerCase() == "Pending".toLowerCase()) ...[
                            const SizedBox(height: 10),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.redAccent,
                                    ),
                                    onPressed: () {
                                      // Show dialog box for providing schedule
                                      _showScheduleDialog(context, false, "Rejected", appointment);
                                    },
                                    child: const Text(
                                      'Reject',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // Show dialog box for providing schedule
                                      _showScheduleDialog(context, true, "Accepted", appointment);
                                    },
                                    child: const Text(
                                      'Accept',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showScheduleDialog(BuildContext context, bool isShow, String value, BookAppointmentModel model) async {
    if (!isShow) {
      await DatabaseService.instance.updateAppointmentStatus(model.copyWith(status: value));
      _getDoctorList();
    } else {
      showDialog(
        context: context,
        builder: (context) {
          TextEditingController dateController = TextEditingController();
          TextEditingController timeController = TextEditingController();
          DateTime selected = DateTime.now();
          DateTime initial = DateTime(2000);
          DateTime last = DateTime(2025);
          return AlertDialog(
            title: const Text('Provide Schedule'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  readOnly: true,
                  controller: dateController,
                  onTap: () async {
                    final selectedDate = await showDatePicker(
                      context: context,
                      initialDate: selected,
                      firstDate: initial,
                      lastDate: last,
                    );
                    if (selectedDate != null) {
                      dateController.text = selectedDate.toLocal().toString().split(" ")[0];
                      setState(() {});
                    }
                  },
                  decoration: const InputDecoration(labelText: 'Date'),
                ),
                const SizedBox(height: 10),
                TextField(
                  readOnly: true,
                  controller: timeController,
                  onTap: () async {
                    TimeOfDay? selectedTime24Hour = await showTimePicker(
                      context: context,
                      initialTime: const TimeOfDay(hour: 10, minute: 47),
                      builder: (BuildContext context, Widget? child) {
                        return MediaQuery(
                          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
                          child: child!,
                        );
                      },
                    );
                    if (selectedTime24Hour != null) {
                      timeController.text = selectedTime24Hour.format(context);
                      setState(() {});
                    }
                  },
                  decoration: const InputDecoration(labelText: 'Time'),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () async {
                  // Perform your action here with the selected date and time

                  await DatabaseService.instance.updateAppointmentStatus(model.copyWith(status: value));
                  _getDoctorList();
                  Navigator.pop(context);
                  // You can use _selectedDate and _selectedTime for further actions
                },
                child: const Text('Confirm'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
            ],
          );
        },
      );
    }
  }
}
