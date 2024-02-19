import 'package:flutter/material.dart';
import 'package:frastraited/Precentation/ui/utility/app_colors.dart';
import 'package:frastraited/screen/service/database_service.dart';
import 'package:frastraited/screen/service/models/book_apointment_model.dart';
import 'package:frastraited/screen/service/models/payment_model.dart';
import 'package:frastraited/screen/service/models/users.dart';
import 'package:frastraited/screen/widgets/bodyBackground.dart';
//import 'package:intl/intl.dart'; // Import DateFormat for date formatting

class PaymentsScreen extends StatelessWidget {
  final String category;
  final String type;
  final String payable;
  final Map<String, dynamic>? doctor;
  final UsersModel? user;

  const PaymentsScreen({
    super.key,
    required this.category,
    required this.type,
    required this.payable,
    this.doctor,
    this.user,
  });

  void _showPaymentForm(BuildContext context) {
    TextEditingController nameEditController = TextEditingController();
    TextEditingController emailEditController = TextEditingController();
    TextEditingController transactionEditController = TextEditingController();
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Enter Payment Information',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: nameEditController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: emailEditController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: transactionEditController,
                decoration: const InputDecoration(labelText: 'Transaction ID'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final name = transactionEditController.text;
                  final email = transactionEditController.text;
                  final transactionId = transactionEditController.text;
                  final currentTime = DateTime.now().toString();
                  BookAppointmentModel appointment = BookAppointmentModel(
                    id: "",
                    doctor: doctor ?? {},
                    user: user ?? UsersModel.empty(),
                    currentDateTime: currentTime,
                    name: name,
                    email: email,
                    transactionId: transactionId,
                  );
                  PaymentModel payment = PaymentModel(
                    id: "",
                    user: user ?? UsersModel.empty(),
                    paymentCategory: category,
                    paymentAmount: payable,
                    paymentStatus: "Pending",
                    currentDateTime: currentTime,
                  );
                  await DatabaseService.instance.addNewAppointment(appointment);
                  await DatabaseService.instance.addNewPayment(payment);
                  Navigator.pop(context, {
                    'category': category,
                    'type': type,
                    'payable': payable,
                  });
                },
                child: const Text(
                  '   Confirm Payment   ',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
    );
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
                  const SizedBox(height: 40),
                  const Text(
                    'Payment Details',
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Category:  $category',
                          style: const TextStyle(fontSize: 18, color: AppColors.primaryColor),
                        ),
                        Text(
                          'Type:   $type',
                          style: const TextStyle(fontSize: 18, color: Colors.black),
                        ),
                        Text(
                          'Payable:   $payable',
                          style: const TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    " Pay BDT $payable by Bkash and fatch the Transaction ID! ",
                    style: const TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      _showPaymentForm(context);
                    },
                    child: const Text(
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
}
