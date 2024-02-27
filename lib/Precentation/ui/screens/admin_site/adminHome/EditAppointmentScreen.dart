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
              padding:EdgeInsets.all(MediaQuery.of(context).size.width * 0.025),
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
                 SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                 Text(
                    'Appointment List',
                    style: TextStyle(
                        fontSize:  MediaQuery.of(context).size.width * 0.06,
                        fontWeight: FontWeight.bold),
                  ),
                   SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  ...List.generate(appointmentList.length, (index) {
                    final appointment = appointmentList[index];
                    return Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 3,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Booked by: ${appointment.user.firstName} ${appointment.user.lastName}',
                                style: TextStyle(
                                    fontSize: MediaQuery.of(context).size.height * 0.019,
                                    color: AppColors.primaryColor),
                              ),
                              Text(
                                'With Doctor:  ${appointment.doctor["name"]}',
                                style: TextStyle(
                                    fontSize: MediaQuery.of(context).size.height * 0.017,
                                    color: Colors.black),
                              ),
                              Text(
                                'Transaction Id:   ${appointment.transactionId}',
                                style:TextStyle
                                  (fontSize: MediaQuery.of(context).size.height * 0.017,
                                    color: Colors.grey),
                              ),
                              Text(
                                'Status: ${appointment.status}',
                                style:TextStyle(
                                    fontSize: MediaQuery.of(context).size.height * 0.017,
                                    color: Colors.grey),
                              ),
                            ],
                          ),
                          if (appointment.status.toLowerCase() == "Pending".toLowerCase())
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.redAccent,
                                  ),
                                  onPressed: () {
                                    // Show dialog box for providing schedule
                                    _showScheduleDialog(context, false, "Reject", appointment);
                                  },
                                  child: const Text(
                                    'Reject',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                SizedBox(width: MediaQuery.of(context).size.height * 0.005),
                                ElevatedButton(
                                  onPressed: () {
                                    // Show dialog box for providing schedule
                                    _showScheduleDialog(context, true, "Accept", appointment);
                                  },
                                  child: const Text(
                                    'Accept',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
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
          return AlertDialog(
            title: const Text('Provide Schedule'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  onChanged: (value) {
                    setState(() {
                      // _selectedDate = value;
                    });
                  },
                  decoration: const InputDecoration(labelText: 'Date'),
                ),
                const SizedBox(height: 10),
                TextField(
                  onChanged: (value) {
                    setState(() {
                      // _selectedTime = value;
                    });
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
