import 'package:flutter/material.dart';
import 'package:frastraited/Precentation/ui/utility/app_colors.dart';
import 'package:frastraited/Precentation/ui/widgets/empty_container_view.dart';
import 'package:frastraited/screen/service/database_service.dart';
import 'package:frastraited/screen/service/models/book_apointment_model.dart';
import 'package:frastraited/screen/service/models/users.dart';
import 'package:frastraited/screen/widgets/bodyBackground.dart';

class UserHistoryScreen extends StatefulWidget {
  const UserHistoryScreen({super.key});

  @override
  State<UserHistoryScreen> createState() => _UserHistoryScreenState();
}

class _UserHistoryScreenState extends State<UserHistoryScreen> {
  List<UsersModel> userList = [];
  UsersModel? selectedUser;

  bool isGetUserLoading = false;
  List<BookAppointmentModel> historyList = [];

  @override
  void initState() {
    _getUserList();
    super.initState();
  }

  void _getUserList() async {
    final result = await DatabaseService.instance.getUserList();
    userList = result;
    setState(() {});
  }

  void _getSelectedUserHistory(UsersModel user) async {
    final result = await DatabaseService.instance.getUserHistory(user);
    historyList.clear();
    isGetUserLoading = false;
    historyList = result;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.primaryColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: const Text(
          'User History',
          style: TextStyle(
            color: AppColors.primaryColor,
            fontWeight: FontWeight.w500,
            fontSize: 20,
          ),
        ),
      ),
      body: BodyBackground(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              color: Colors.black12,
              padding: const EdgeInsetsDirectional.symmetric(horizontal: 20),
              child: DropdownButton<UsersModel>(
                value: selectedUser,
                hint: const Text("Select a user"),
                isExpanded: true,
                onChanged: (UsersModel? newValue) {
                  if (newValue != null) {
                    _getSelectedUserHistory(newValue);
                    selectedUser = newValue;
                    isGetUserLoading = true;
                    setState(() {});
                  }
                },
                items: userList.map<DropdownMenuItem<UsersModel>>((UsersModel model) {
                  return DropdownMenuItem<UsersModel>(
                    value: model,
                    child: Text("${model.firstName} ${model.lastName} (${model.medicalId})"),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(child: _view),
          ],
        ),
      ),
    );
  }

  Widget get _view {
    if (isGetUserLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (historyList.isEmpty) {
      return const Center(child: EmptyContainerView());
    }
    return SingleChildScrollView(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...List.generate(historyList.length, (index) {
            final appointment = historyList[index];
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
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Booked by: ${appointment.user.firstName} ${appointment.user.lastName}',
                    style: const TextStyle(fontSize: 18, color: AppColors.primaryColor),
                  ),
                  if (appointment.doctor.isNotEmpty)
                    Text(
                      'With Doctor:  ${appointment.doctor["name"]}',
                      style: const TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  if (appointment.paymentCategory.isNotEmpty)
                    Text(
                      'Pay For:   ${appointment.paymentCategory}',
                      style: const TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  Text(
                    'Transaction Id:   ${appointment.transactionId}',
                    style: const TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  Text(
                    'Status: ${appointment.status}',
                    style: const TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
