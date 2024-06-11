import 'package:bill_app/models/invoice_model.dart';
import 'package:bill_app/services/save_user.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UserDetailsForm extends StatefulWidget {
  const UserDetailsForm({super.key});

  @override
  State<UserDetailsForm> createState() => _UserDetailsFormState();
}

class _UserDetailsFormState extends State<UserDetailsForm> {
  final TextEditingController _sellerNameController = TextEditingController();
  final TextEditingController _sellerAddressController =
      TextEditingController();
  final TextEditingController _sellerGSTController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Set up your details"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(children: [
            TextFormField(
              maxLines: 2,
              controller: _sellerNameController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: 'Seller Name'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter the seller name';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              maxLines: 4,
              controller: _sellerAddressController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: 'Seller Address'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter the seller address';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: _sellerGSTController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: 'Seller GST'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter the seller GST';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
                onPressed: () {
                  if (_sellerNameController.text.trim() == "") {
                    Fluttertoast.showToast(msg: "name is missing");
                    return;
                  }
                  if (_sellerAddressController.text.trim() == "") {
                    Fluttertoast.showToast(msg: "address is missing");
                    return;
                  }
                  if (_sellerGSTController.text.trim() == "") {
                    Fluttertoast.showToast(msg: "GST is missing");
                    return;
                  }
                  UserDb.saveUserData(UserDetails(
                          address: _sellerAddressController.text,
                          gstNo: _sellerGSTController.text,
                          name: _sellerNameController.text))
                      .then((value) {
                    Navigator.pop(context);
                  });
                },
                child: const Text("Save data"))
          ]),
        ),
      ),
    );
  }
}
