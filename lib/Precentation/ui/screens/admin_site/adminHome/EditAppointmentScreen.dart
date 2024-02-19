import 'package:flutter/material.dart';
import 'package:frastraited/Precentation/ui/utility/app_colors.dart';
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
  String? _selectedDate;
  String? _selectedTime;

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
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Booked ${widget.category}',
                              style: const TextStyle(fontSize: 18, color: AppColors.primaryColor),
                            ),
                            Text(
                              'With Doctor:  ${widget.type}',
                              style: const TextStyle(fontSize: 18, color: Colors.black),
                            ),
                            Text(
                              'Paid:   ${widget.payable}',
                              style: const TextStyle(fontSize: 18, color: Colors.grey),
                            ),
                            Text(
                              'Status: Pending',
                              style: const TextStyle(fontSize: 18, color: Colors.grey),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.redAccent,
                              ),
                              onPressed: () {
                                // Show dialog box for providing schedule
                                _showScheduleDialog(context, false, "Reject");
                              },
                              child: const Text(
                                'Reject',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            const SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: () {
                                // Show dialog box for providing schedule
                                _showScheduleDialog(context, true, "Accept");
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
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showScheduleDialog(BuildContext context, bool isShow, String value) {
    if (!isShow) {
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
                      _selectedDate = value;
                    });
                  },
                  decoration: const InputDecoration(labelText: 'Date'),
                ),
                const SizedBox(height: 10),
                TextField(
                  onChanged: (value) {
                    setState(() {
                      _selectedTime = value;
                    });
                  },
                  decoration: const InputDecoration(labelText: 'Time'),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  // Perform your action here with the selected date and time
                  Navigator.pop(context);
                  // You can use _selectedDate and _selectedTime for further actions
                },
                child: const Text('Confirm'),
              ),
              TextButton(
                onPressed: () {
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
