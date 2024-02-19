import 'package:flutter/material.dart';
import 'package:frastraited/Precentation/ui/utility/app_colors.dart';
import 'package:frastraited/screen/service/database_service.dart';
import 'package:frastraited/screen/service/models/payment_model.dart';
import 'package:frastraited/screen/widgets/bodyBackground.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatefulWidget {
  final Map<String, dynamic> paymentInfo;

  const HistoryScreen({super.key, required this.paymentInfo});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  List<PaymentModel> historyList = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getDoctorList();
  }

  void _getDoctorList() async {
    historyList.clear();
    final result = await DatabaseService.instance.getHistory();
    historyList.addAll(result);
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
                    height: 40,
                  ),
                  ...List.generate(historyList.length, (index) {
                    final history = historyList[index];
                    return Container(
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
                            'Category:  ${history.paymentCategory}',
                            style: TextStyle(fontSize: 18, color: AppColors.primaryColor),
                          ),
                          Text(
                            'Payment Status:   ${history.paymentStatus}',
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                          Text(
                            'Payable:   ${history.paymentAmount}',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                          SizedBox(height: 20),
                          Text(
                            'Date: ${DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.parse(history.currentDateTime))}',
                            style: TextStyle(fontSize: 18, color: Colors.blue),
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
}
