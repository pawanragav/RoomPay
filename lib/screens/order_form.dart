// ignore_for_file: library_private_types_in_public_api, avoid_print

import 'dart:developer';

import 'package:bill_app/models/invoice_model.dart';
import 'package:bill_app/services/save_user.dart';
import 'package:bill_app/widgets/get_user_details.dart';
import 'package:bill_app/widgets/printable_data.dart';
import 'package:bill_app/widgets/product_item.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class OrderForm extends StatefulWidget {
  const OrderForm({super.key});

  @override // State<SaveBtnBuilder>
  _OrderFormState createState() => _OrderFormState();
}

class _OrderFormState extends State<OrderForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _buyerNameController = TextEditingController();
  final TextEditingController _buyerAddressController = TextEditingController();
  final TextEditingController _buyerGSTController = TextEditingController();
  final TextEditingController _sellerNameController = TextEditingController();
  final TextEditingController _sellerAddressController =
      TextEditingController();
  final TextEditingController _sellerGSTController = TextEditingController();
  final TextEditingController _invoiceController = TextEditingController();
  final TextEditingController _cgstController = TextEditingController();
  final TextEditingController _sgstController = TextEditingController();

  final List<Map<String, TextEditingController>> _products = [];
  String modeOfPayment = "Credit";

  UserDetails? currentUser;
  bool isLoading = false;
  bool customSeller = false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  getData() async {
    isLoading = true;
    setState(() {});
    currentUser = await UserDb.getUser();
    isLoading = false;
    setState(() {});
  }

  String? billDate;
  String? startDate;
  String? endDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _invoiceController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Invoice no'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter the buyer address';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 16,
              ),
              InkWell(
                  onTap: () {
                    showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    ).then((selectedDate) {
                      // After selecting the date, display the time picker.
                      if (selectedDate != null) {
                        billDate = selectedDate.toString();
                        log(billDate
                            .toString()); // You can use the selectedDateTime as needed.
                        setState(() {});
                      }
                    });
                  },
                  child: billDate == null
                      ? const Text(
                          "Select Bill Date",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )
                      : Text(
                          "Bill Date :  ${billDate.toString().substring(0, 10)}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        )),
              const SizedBox(
                height: 16,
              ),
              if (currentUser != null)
                Row(
                  children: [
                    Checkbox(
                        value: customSeller,
                        onChanged: ((val) {
                          customSeller = val!;
                          setState(() {});
                        })),
                    const Text("For custom seller details select this")
                  ],
                ),
              if (customSeller)
                GetUserDetails(
                  sellerNameController: _sellerNameController,
                  sellerAddressController: _sellerAddressController,
                  sellerGSTController: _sellerGSTController,
                  nameCaption: "Seller Name",
                  addressCaption: "Seller Address",
                  gstCaption: "Seller GST",
                ),
              if (currentUser == null)
                GetUserDetails(
                  sellerNameController: _sellerNameController,
                  sellerAddressController: _sellerAddressController,
                  sellerGSTController: _sellerGSTController,
                  nameCaption: "Seller Name",
                  addressCaption: "Seller Address",
                  gstCaption: "Seller GST",
                ),
              GetUserDetails(
                sellerNameController: _buyerNameController,
                sellerAddressController: _buyerAddressController,
                sellerGSTController: _buyerGSTController,
                nameCaption: "Buyer Name",
                addressCaption: "Buyer Address",
                gstCaption: "Buyer GST",
              ),
              const SizedBox(height: 16),
              const Text('Product List', style: TextStyle(fontSize: 18)),
              const SizedBox(height: 8),
              Column(
                children: _products.asMap().entries.map((entry) {
                  final index = entry.key;
                  final product = entry.value;

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ProductItem(
                      siNo: (index + 1).toString(),
                      productNameController: product['name']!,
                      gstController: product['gst']!,
                      rateController: product['rate']!,
                      perAmountController: product['perAmount']!,
                      noOfPerson: product["noOfPeople"]!,
                      onRemove: () {
                        _removeProduct(index);
                      },
                    ),
                  );
                }).toList(),
              ),
              ElevatedButton(
                onPressed: _addProduct,
                child: const Text('Add Product'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: _cgstController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: 'CGST'),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: _sgstController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(), labelText: 'SGST'),
              ),
              const SizedBox(height: 16),
              InkWell(
                  onTap: () {
                    showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    ).then((selectedDate) {
                      // After selecting the date, display the time picker.
                      if (selectedDate != null) {
                        showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        ).then((selectedTime) {
                          // Handle the selected date and time here.
                          if (selectedTime != null) {
                            DateTime selectedDateTime = DateTime(
                              selectedDate.year,
                              selectedDate.month,
                              selectedDate.day,
                              selectedTime.hour,
                              selectedTime.minute,
                            );
                            startDate = selectedDateTime.toString();
                            log(startDate
                                .toString()); // You can use the selectedDateTime as needed.
                            setState(() {});
                          }
                        });
                      }
                    });
                  },
                  child: startDate == null
                      ? const Text(
                          "Select Check In Date",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )
                      : Text(
                          "Check in time and Date :${startDate.toString().substring(0, 16)}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        )),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                  onTap: () {
                    showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    ).then((selectedDate) {
                      // After selecting the date, display the time picker.
                      if (selectedDate != null) {
                        showTimePicker(
                          context: context,
                          initialTime: TimeOfDay.now(),
                        ).then((selectedTime) {
                          // Handle the selected date and time here.
                          if (selectedTime != null) {
                            DateTime selectedDateTime = DateTime(
                              selectedDate.year,
                              selectedDate.month,
                              selectedDate.day,
                              selectedTime.hour,
                              selectedTime.minute,
                            );
                            endDate = selectedDateTime.toString();
                            log(endDate
                                .toString()); // You can use the selectedDateTime as needed.
                            setState(() {});
                          }
                        });
                      }
                    });
                  },
                  child: endDate == null
                      ? const Text(
                          "Select Check Out Date",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )
                      : Text(
                          "Check out time and Date :${endDate.toString().substring(0, 16)}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        )),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: 'Credit',
                items: const [
                  // DropdownMenuItem(
                  //   value: 'Credit Card',
                  //   child: Text('Credit Card'),
                  // ),
                  // DropdownMenuItem(
                  //   value: 'Debit Card',
                  //   child: Text('Debit Card'),
                  // ),
                  DropdownMenuItem(
                    value: 'Credit',
                    child: Text('Credit'),
                  ),
                  DropdownMenuItem(
                    value: 'Cash',
                    child: Text('Cash'),
                  ),
                  // DropdownMenuItem(
                  //   value: 'Upi',
                  //   child: Text('Upi'),
                  // ),
                ],
                onChanged: (value) {
                  modeOfPayment = value!;
                },
                decoration: const InputDecoration(labelText: 'Mode of Payment'),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (billDate == null) {
                    Fluttertoast.showToast(msg: "check the bill date");
                    return;
                  }
                  if (startDate == null) {
                    Fluttertoast.showToast(msg: "check the start and end date");
                    return;
                  }
                  if (endDate == null) {
                    Fluttertoast.showToast(msg: "check the start and end date");
                    return;
                  }
                  if (_formKey.currentState!.validate()) {
                    List<ItemModel> lim = [];

                    for (var data in _products) {
                      print(data["perAmount"]!.text);
                      lim.add(ItemModel(
                          amount: ((double.parse(data["rate"]!.text.trim()) *
                                      double.parse(data["perAmount"]!
                                                  .text
                                                  .trim() ==
                                              ""
                                          ? "0.0"
                                          : data["perAmount"]!.text.trim())) +
                                  ((double.parse(data["rate"]!.text.trim()) *
                                          double.parse(
                                              data["perAmount"]!.text.trim() ==
                                                      ""
                                                  ? "0.0"
                                                  : data["perAmount"]!
                                                      .text
                                                      .trim())) *
                                      double.parse("0.0") /
                                      100))
                              .toString(),
                          gst: data['gst']!.text.trim(),
                          particulars: data['name']!.text.trim(),
                          rate: data["rate"]!.text.trim(),
                          per: data["perAmount"]!.text.trim(),
                          noOfPeople: data["noOfPeople"]!.text.trim()));
                    }
                    String calculateTotal() {
                      double total = 0;
                      for (var item in lim) {
                        total += double.parse(item.amount!);
                      }
                      print(total);
                      if (total.toString().contains(".")) {
                        String inString = total.toStringAsFixed(2);
                        double inDouble = double.parse(inString);
                        return inDouble.toString();
                      } else {
                        return total.toString();
                      }
                    }

                    InvoiceModel im = InvoiceModel(
                        date: billDate,
                        cgst: _cgstController.text,
                        sgst: _sgstController.text,
                        modeOfPayment: modeOfPayment,
                        total: calculateTotal(),
                        sellerDetails: currentUser != null
                            ? customSeller
                                ? UserDetails(
                                    address: _sellerAddressController.text,
                                    gstNo: _sellerGSTController.text,
                                    name: _sellerNameController.text)
                                : currentUser
                            : UserDetails(
                                address: _sellerAddressController.text,
                                gstNo: _sellerGSTController.text,
                                name: _sellerNameController.text),
                        buyerDetails: UserDetails(
                            address: _buyerAddressController.text,
                            gstNo: _buyerGSTController.text,
                            name: _buyerNameController.text),
                        invoiceNO: _invoiceController.text,
                        totalInWords: convertNumberToWords(
                            double.parse(calculateTotal()).round()),
                        startDate: startDate!.substring(0, 16),
                        endDate: endDate!.substring(0, 16),
                        item: lim);
                    log(im.toJson().toString());
                    printDoc(im);
                  }
                },
                child: const Text('Generate invoice'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String convertNumberToWords(int number) {
    if (number < 0 || number > 10000000) {
      // Handle out-of-range numbers according to your requirements
      return 'Out of range';
    }

    if (number == 0) {
      return 'zero';
    }

    String result = '';

    List<String> units = [
      '',
      'one',
      'two',
      'three',
      'four',
      'five',
      'six',
      'seven',
      'eight',
      'nine'
    ];
    List<String> teens = [
      'eleven',
      'twelve',
      'thirteen',
      'fourteen',
      'fifteen',
      'sixteen',
      'seventeen',
      'eighteen',
      'nineteen'
    ];
    List<String> tens = [
      '',
      'ten',
      'twenty',
      'thirty',
      'forty',
      'fifty',
      'sixty',
      'seventy',
      'eighty',
      'ninety'
    ];

    String convertBelowThousand(int num) {
      String result = '';
      if (num >= 100) {
        result += '${units[num ~/ 100]} hundred';
        num %= 100;
        if (num > 0) {
          result += ' ';
        } else {
          return result;
        }
      }
      if (num > 10 && num < 20) {
        return result + teens[num - 11];
      } else {
        result += tens[num ~/ 10];
        num %= 10;
        if (num > 0) {
          result += ' ';
        } else {
          return result;
        }
      }
      return result + units[num];
    }

    if (number >= 1000000) {
      result += '${convertBelowThousand(number ~/ 1000000)} million ';
      number %= 1000000;
    }

    if (number >= 1000) {
      result += '${convertBelowThousand(number ~/ 1000)} thousand ';
      number %= 1000;
    }

    result += convertBelowThousand(number);

    return result;
  }

  Future<void> printDoc(data) async {
    final doc = pw.Document();
    doc.addPage(pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return buildPrintableData(
            data,
          );
        }));
    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => doc.save());
  }

  void _addProduct() {
    setState(() {
      _products.add({
        'name': TextEditingController(),
        'gst': TextEditingController(),
        'rate': TextEditingController(),
        'perAmount': TextEditingController(),
        'noOfPeople': TextEditingController(),
      });
    });
  }

  void _removeProduct(int index) {
    setState(() {
      _products.removeAt(index);
    });
  }
}
