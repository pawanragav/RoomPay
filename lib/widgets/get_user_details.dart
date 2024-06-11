import 'package:flutter/material.dart';

class GetUserDetails extends StatelessWidget {
  const GetUserDetails({
    super.key,
    required TextEditingController sellerNameController,
    required TextEditingController sellerAddressController,
    required TextEditingController sellerGSTController,
    required this.nameCaption,
    required this.addressCaption,
    required this.gstCaption,
  })  : _sellerNameController = sellerNameController,
        _sellerAddressController = sellerAddressController,
        _sellerGSTController = sellerGSTController;

  final TextEditingController _sellerNameController;
  final TextEditingController _sellerAddressController;
  final TextEditingController _sellerGSTController;
  final String nameCaption;
  final String addressCaption;
  final String gstCaption;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(border: Border.all()),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              TextFormField(
                controller: _sellerNameController,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: nameCaption,
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the name';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _sellerAddressController,
                decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    labelText: addressCaption),
                maxLines: 4,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the address';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _sellerGSTController,
                decoration: InputDecoration(
                  labelText: gstCaption,
                  border: const OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the GST';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
