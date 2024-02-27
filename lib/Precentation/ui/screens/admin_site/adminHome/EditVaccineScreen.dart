import 'package:flutter/material.dart';
import 'package:frastraited/Precentation/ui/utility/app_colors.dart';
import 'package:frastraited/Precentation/ui/utility/search_field.dart';
import 'package:frastraited/screen/service/database_service.dart';
import 'package:frastraited/screen/service/models/vaccines.dart';
import 'package:frastraited/screen/widgets/bodyBackground.dart';

class EditVaccine extends StatefulWidget {
  const EditVaccine({super.key});

  @override
  State<EditVaccine> createState() => _EditVaccineState();
}

class _EditVaccineState extends State<EditVaccine> {
  List<VaccineModel> vaccineList = [];

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _getVaccineList();
    searchController.addListener(_onSearchChanged);
  }

  void _getVaccineList() async {
    vaccineList.clear();
    final result = await DatabaseService.instance.getVaccineInformation();
    vaccineList.addAll(result);
    isLoading = false;
    setState(() {});
  }

  TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    String query = searchController.text.toLowerCase();
    setState(() {
      vaccineList = vaccineList.where((vaccine) {
        String vaccineName = vaccine.name.toLowerCase();
        return vaccineName.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BodyBackground(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
        :vaccineList.isEmpty
          ? const Center(child: Text("List is Empty"))
            : SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
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
                       SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        Text(
                          'Available Vaccines',
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.06,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryColor,
                          ),
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                        SearchField(
                          controller: searchController,
                          onTextChanged: (value) {
                            setState(() {});
                          },
                        ),
                       SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: vaccineList.length,
                          itemBuilder: (BuildContext context, int index) {
                            final vaccine = vaccineList[index];
                            return Column(
                              children: [
                                Container(
                                  height: MediaQuery.of(context).size.width * 0.4,
                                  margin: const EdgeInsets.symmetric(vertical: 10),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 1,
                                        blurRadius: 4,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10),
                                        width: 120,
                                        height: double.infinity,
                                        decoration: BoxDecoration(
                                          borderRadius: const BorderRadius.only(
                                            topLeft: Radius.circular(12),
                                            bottomLeft: Radius.circular(12),
                                          ),
                                          image: DecorationImage(
                                            image: NetworkImage(vaccine.vaccineImageUrl),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 20),
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              vaccine.name,
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: AppColors.primaryColor,
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              'Available at: ${vaccine.place}',
                                              style: const TextStyle(
                                                color: Colors.black54,
                                                fontSize: 14,
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              'Price: ${vaccine.price}',
                                              style: const TextStyle(
                                                color: Colors.blueGrey,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.more_vert),
                                        onPressed: () {
                                          _showEditDialog(context, vaccine);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddBottomSheet(context);
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: AppColors.primaryColor,
      ),
    );
  }

  void _showEditDialog(BuildContext context, VaccineModel vaccine) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Modify Vaccine'),
          content: const Text('Do you want to modify Vaccine list?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _showEditBottomSheet(context, vaccine);
              },
              child: const Text('Update'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                _showDeleteAlertDialog(context, vaccine);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteAlertDialog(BuildContext context, VaccineModel vaccine) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Vaccine?"),
          content: const Text("Do you want to delete the vaccine from the list?"),
          actions: [
            TextButton(
              onPressed: () async {
                vaccineList.remove(vaccine);
                await DatabaseService.instance.deleteVaccine(vaccine);
                _getVaccineList();
                setState(() {});

                Navigator.of(context).pop();
              },
              child: const Text(
                "Delete",
                style: TextStyle(color: Colors.white),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(AppColors.primaryColor),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  void _showEditBottomSheet(BuildContext context, VaccineModel vaccine) {
    TextEditingController nameController = TextEditingController(text: vaccine.name);
    TextEditingController imageUrlController = TextEditingController(text: vaccine.vaccineImageUrl);
    TextEditingController placeController = TextEditingController(text: vaccine.place);
    TextEditingController priceController = TextEditingController(text: vaccine.price);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: imageUrlController,
                    decoration: const InputDecoration(labelText: 'Image URL'),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: placeController,
                    decoration: const InputDecoration(labelText: 'Place'),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: priceController,
                    decoration: const InputDecoration(labelText: 'Price'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      final name = nameController.text;
                      final imageUrl = imageUrlController.text;
                      final price = priceController.text;
                      final place = placeController.text;
                      final model = vaccine.copyWith(name: name, vaccineImageUrl: imageUrl, place: place, price: price);
                      await DatabaseService.instance.updateVaccineInformation(model);
                      _getVaccineList();
                      Navigator.pop(context);
                    },
                    child: const Text('Update', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showAddBottomSheet(BuildContext context) {
    TextEditingController nameController = TextEditingController();
    TextEditingController imageUrlController = TextEditingController();
    TextEditingController placeController = TextEditingController();
    TextEditingController priceController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Container(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(labelText: 'Name'),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: imageUrlController,
                    decoration: const InputDecoration(labelText: 'Image URL'),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: placeController,
                    decoration: const InputDecoration(labelText: 'Place'),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: priceController,
                    decoration: const InputDecoration(labelText: 'Price'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () async {
                      final name = nameController.text;
                      final imageUrl = imageUrlController.text;
                      final price = priceController.text;
                      final place = placeController.text;

                      VaccineModel model = VaccineModel(id: '', name: name, price: price, place: place, vaccineImageUrl: imageUrl);
                      await DatabaseService.instance.setVaccineInformation(model);
                      _getVaccineList();

                      Navigator.pop(context);
                    },
                    child: const Text('Add', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
