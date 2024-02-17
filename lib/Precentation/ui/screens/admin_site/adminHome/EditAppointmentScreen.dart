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
    Key? key,
  }) : super(key: key);

  @override
  State<EditAppointment> createState() => _EditAppointmentState();
}

class _EditAppointmentState extends State<EditAppointment> {
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
                  const SizedBox(height: 40),
                  Text(
                    'Payment Details',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 40),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Category:  ${widget.category}',
                          style: TextStyle(fontSize: 18, color: AppColors.primaryColor),
                        ),
                        Text(
                          'Type:   ${widget.type}',
                          style: TextStyle(fontSize: 18, color: Colors.black),
                        ),
                        Text(
                          'Payable:   ${widget.payable}',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    " Pay BDT ${widget.payable} by Bkash and fetch the Transaction ID! ",
                    style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Handle payment confirmation without navigation
                      _confirmPayment(context);
                    },
                    child: Text(
                      '  Next  ',
                      style: TextStyle(color: Colors.white),
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

  void _confirmPayment(BuildContext context) {
    // Update appointment information in PaymentsScreen
    Navigator.pop(context, {'category': widget.category, 'type': widget.type, 'payable': widget.payable});
  }
}