import 'package:flutter/material.dart';
import 'package:frastraited/Precentation/ui/utility/app_colors.dart';
import 'package:frastraited/screen/widgets/bodyBackground.dart';

class AppointmentBooking extends StatefulWidget {
  final Map<String, dynamic> selectedDoctor;

  const AppointmentBooking({Key? key, required this.selectedDoctor}) : super(key: key);

  @override
  State<AppointmentBooking> createState() => _AppointmentBookingState();
}

class _AppointmentBookingState extends State<AppointmentBooking> {
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
                        icon: Icon(
                          Icons.arrow_back,
                          color: AppColors.primaryColor,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Book Appointment',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 40),
                  _buildDoctorInfo(),
                  const SizedBox(height: 20),
                  _buildPatientInfoForm(),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _bookAppointment,
                    child: Text(' Book Appointment ',
                      style: TextStyle(color: Colors.white),),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDoctorInfo() {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(15),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "Appointment With:",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey,
                  ),
                ),
                Text(
                  ' ${widget.selectedDoctor['name']}',
                  style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700),
                ),
                Text(
                  '(${widget.selectedDoctor['specialty']})',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            // You can add more details as needed
          ],
        ),
      ),
    );
  }

  Widget _buildPatientInfoForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Provide your details: ',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          decoration: InputDecoration(labelText: 'Name'),
        ),
        const SizedBox(height: 10),
        TextFormField(
          decoration: InputDecoration(labelText: 'Medical ID'),
        ),
        const SizedBox(height: 10),
        TextFormField(
          decoration: InputDecoration(labelText: 'Phone Number'),
        ),
        // Add more fields for patient info as needed
      ],
    );
  }

  void _bookAppointment() {
    // Show payment confirmation dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Payment Confirmation'),
        content: Text('You have to pay BDT 200 for the appointment.'),
        actions: [
          TextButton(
            onPressed: () {
              // Perform payment logic
              Navigator.pop(context);
            },
            child: Text('Pay'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }
}
