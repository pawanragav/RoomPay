import 'package:bill_app/models/invoice_model.dart';
import 'package:number_to_words_english/number_to_words_english.dart';
import 'package:pdf/widgets.dart' as pw;

buildPrintableData(
  InvoiceModel im,
) {
  return pw.Column(
    children: [
      pw.Container(
        decoration: pw.BoxDecoration(border: pw.Border.all()),
        child: pw.Padding(
          padding: const pw.EdgeInsets.all(16.0),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // pw.Center(
              //   child: pw.Text(
              //     'Jesus protects all!!',
              //     style: pw.TextStyle(
              //         fontSize: 18, fontWeight: pw.FontWeight.bold),
              //   ),
              // ),
              pw.SizedBox(height: 20),
              pw.Center(
                child: pw.Text(
                  'Tax Invoice',
                  style: pw.TextStyle(
                      fontSize: 24, fontWeight: pw.FontWeight.bold),
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.SizedBox(
                    width: 150,
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text(im.sellerDetails!.name!),
                        pw.Text(im.sellerDetails!.address!),
                        pw.Text("GST NO: ${im.sellerDetails!.gstNo}"),
                      ],
                    ),
                  ),
                  pw.SizedBox(
                    width: 100,
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text("Invoice No: ${im.invoiceNO}"),
                      ],
                    ),
                  ),
                  pw.SizedBox(
                    width: 100,
                    child: pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text("Date:${im.date!.substring(0, 10)}"),
                        pw.Text("Mode of payment"),
                        pw.Text(im.modeOfPayment!),
                      ],
                    ),
                  )
                ],
              ),
              pw.Divider(),
              pw.SizedBox(
                width: 150,
                child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text("Bill To"),
                      pw.Text(im.buyerDetails!.name!),
                      pw.Text(im.buyerDetails!.address!),
                      pw.Text("${im.buyerDetails!.gstNo}"),
                    ]),
              ),

              pw.Divider(),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text("SI No"),
                  pw.Text('Rooms'),
                  pw.Text('No Of Persons'),
                  pw.Text('Rate'),
                  pw.Text('No of Days'),
                  pw.Text('Amount')
                ],
              ),
              pw.Divider(),
              pw.ListView.builder(
                  itemCount: im.item!.length,
                  itemBuilder: (ctx, i) {
                    ItemModel item = im.item![i];
                    return pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.SizedBox(
                          width: 75,
                          child: pw.Text((i + 1).toString()),
                        ),
                        pw.SizedBox(
                          width: 95,
                          child: pw.Text(item.particulars!),
                        ),
                        pw.SizedBox(
                          width: 80,
                          child: pw.Text(item.noOfPeople!),
                        ),
                        pw.SizedBox(
                          width: 80,
                          child: pw.Text(item.rate!),
                        ),
                        pw.SizedBox(
                          width: 80,
                          child: pw.Text(item.per!),
                        ),
                        // pw.SizedBox(
                        //   width: 20,
                        //   child: pw.Text(item.noOfPeople!),
                        // ),
                        pw.Container(
                          width: 90,
                          alignment: pw.Alignment.centerLeft,
                          child: pw.Text("${double.parse(item.amount ?? "0")}"),
                        ),
                      ],
                    );
                  }),
              pw.Divider(),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.SizedBox(
                    width: 75,
                  ),
                  pw.SizedBox(
                    width: 95,
                    child: pw.Text("Output CGST"),
                  ),
                  pw.SizedBox(
                    width: 70,
                    child: pw.Text("${im.cgst!}%"),
                  ),
                  pw.SizedBox(
                    width: 160,
                  ),
                  pw.Container(
                    width: 90,
                    alignment: pw.Alignment.centerLeft,
                    child: pw.Text((double.parse(im.total ?? "0") *
                            (double.parse(im.cgst!) / 100))
                        .toStringAsFixed(2)),
                  ),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.SizedBox(
                    width: 75,
                  ),
                  pw.SizedBox(
                    width: 95,
                    child: pw.Text("Output SGST"),
                  ),
                  pw.SizedBox(
                    width: 70,
                    child: pw.Text("${im.sgst!}%"),
                  ),
                  pw.SizedBox(
                    width: 160,
                  ),
                  pw.Container(
                    width: 90,
                    alignment: pw.Alignment.centerLeft,
                    child: pw.Text((double.parse(im.total ?? "0") *
                            (double.parse(im.sgst!) / 100))
                        .toStringAsFixed(2)),
                  ),
                ],
              ),
              pw.Divider(),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.SizedBox(
                    width: 75,
                  ),
                  pw.SizedBox(
                    width: 95,
                    child: pw.Text("Check In"),
                  ),
                  pw.SizedBox(
                    child: pw.Text(im.startDate!),
                  ),
                  pw.SizedBox(
                    width: 170,
                  ),
                  pw.Container(
                    width: 90,
                    alignment: pw.Alignment.centerLeft,
                  ),
                ],
              ),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.SizedBox(
                    width: 75,
                  ),
                  pw.SizedBox(
                    width: 95,
                    child: pw.Text("Check Out"),
                  ),
                  pw.SizedBox(child: pw.Text(im.endDate!)),
                  pw.SizedBox(
                    width: 170,
                  ),
                  pw.Container(
                    width: 90,
                    alignment: pw.Alignment.centerLeft,
                  ),
                ],
              ),
              pw.Divider(),

              pw.Container(
                alignment: pw.Alignment.center,
                child: pw.Text(
                    "Total : Rs ${(double.parse(im.total!) + double.parse((double.parse(im.total ?? "0") * (double.parse(im.sgst!) / 100)).toStringAsFixed(2)) + double.parse((double.parse(im.total ?? "0") * (double.parse(im.cgst!) / 100)).toStringAsFixed(2))).toStringAsFixed(2)} /-",
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              ),
              pw.Divider(),
              // pw.Text("Adding Gst",
              //     style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              // pw.Divider(),
              // pw.Row(
              //   mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              //   children: [
              //     pw.SizedBox(
              //       width: 75,
              //       child: pw.Text("SiNo"),
              //     ),
              //     pw.SizedBox(width: 95, child: pw.Text('Product')),
              //     pw.SizedBox(width: 70, child: pw.Text('GST')),
              //     pw.SizedBox(width: 90, child: pw.Text('Total + Gst')),
              //   ],
              // ),
              // pw.Divider(),
              // pw.ListView.builder(
              //     itemCount: im.item!.length,
              //     itemBuilder: (ctx, i) {
              //       ItemModel item = im.item![i];
              //       return pw.Row(
              //         mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              //         children: [
              //           pw.SizedBox(
              //             width: 75,
              //             child: pw.Text((i + 1).toString()),
              //           ),
              //           pw.SizedBox(
              //             width: 95,
              //             child: pw.Text(item.particulars!),
              //           ),
              //           pw.SizedBox(
              //             width: 70,
              //             child: pw.Text(item.gst!),
              //           ),
              //           // pw.SizedBox(
              //           //   width: 90,
              //           //   child: pw.Text(item.rate!),
              //           // ),
              //           // pw.SizedBox(
              //           //   width: 80,
              //           //   child: pw.Text(item.per!),
              //           // ),

              //           pw.Container(
              //             width: 90,
              //             alignment: pw.Alignment.centerLeft,
              //             child: pw.Text("${double.parse(item.amount ?? "0")}"),
              //           ),
              //         ],
              //       );
              //     }),
              // pw.Divider(),
              // pw.Center(
              //   child: pw.Text(
              //     'Total: Rs ${im.total!}',
              //     style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              //   ),
              // ),
              // pw.Divider(),
              pw.Row(
                children: [
                  pw.Text("Amount Chargeable in words"),
                  pw.Spacer(),
                  pw.Text("E. & O.E")
                ],
              ),
              pw.SizedBox(
                height: 10,
              ),
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.SizedBox(
                    width: 200,
                    child: pw.Text(
                        "${totalToWords((double.parse(im.total!) + double.parse((double.parse(im.total ?? "0") * (double.parse(im.sgst!) / 100)).toStringAsFixed(2)) + double.parse((double.parse(im.total ?? "0") * (double.parse(im.cgst!) / 100)).toStringAsFixed(2))).toStringAsFixed(2))} Only"),
                  ),
                  pw.Spacer(),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text("for V.R. VENGATESH(Park Regency)"),
                      pw.Text("Authorised Signature"),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(
                height: 20,
              ),
              pw.Center(child: pw.Text("Computer Generated Invoice"))
            ],
          ),
        ),
      ),
    ],
  );
}

String convertAmountToWords(double amount) {
  // Separate integer and decimal parts
  int integerPart = amount.truncate();
  int decimalPart = ((amount - integerPart) * 100).truncate();

  String integerWords = _convertIntegerToWords(integerPart);
  String decimalWords = _convertDecimalToWords(decimalPart);

  // Construct the final result
  String result = "$integerWords Rupees";
  if (decimalPart > 0) {
    result += " and $decimalWords paisa";
  }
  result += " only";

  return result;
}

String _convertIntegerToWords(int number) {
  if (number == 0) {
    return "Zero";
  }

  List<String> units = ["", "Thousand", "Million", "Billion", "Trillion"];
  int index = 0;
  String result = "";

  while (number > 0) {
    int chunk = number % 1000;
    if (chunk != 0) {
      if (result.isNotEmpty) {
        result = "${_convertChunkToWords(chunk)} ${units[index]}, $result";
      } else {
        result = _convertChunkToWords(chunk);
      }
    }

    number ~/= 1000; // Move to the next chunk
    index++;
  }

  return result.trim();
}

String _convertDecimalToWords(int number) {
  if (number == 0) {
    return "Zero";
  }

  return _convertChunkToWords(number);
}

String _convertChunkToWords(int number) {
  List<String> units = [
    "",
    "One",
    "Two",
    "Three",
    "Four",
    "Five",
    "Six",
    "Seven",
    "Eight",
    "Nine"
  ];
  List<String> teens = [
    "",
    "Eleven",
    "Twelve",
    "Thirteen",
    "Fourteen",
    "Fifteen",
    "Sixteen",
    "Seventeen",
    "Eighteen",
    "Nineteen"
  ];
  List<String> tens = [
    "",
    "Ten",
    "Twenty",
    "Thirty",
    "Forty",
    "Fifty",
    "Sixty",
    "Seventy",
    "Eighty",
    "Ninety"
  ];

  String result = "";

  // Convert hundreds place
  if (number >= 100) {
    result += "${units[number ~/ 100]} Hundred";
    number %= 100;
  }

  // Convert tens and ones place
  if (number > 0) {
    if (result.isNotEmpty) {
      result += " and ";
    }

    if (number < 10) {
      result += units[number];
    } else if (number < 20) {
      result += teens[number - 10];
    } else {
      result += tens[number ~/ 10];
      if (number % 10 > 0) {
        result += " ${units[number % 10]}";
      }
    }
  }

  return result;
}

String totalToWords(total) {
  List no = total.split(".");
  var ruppess = int.parse(no[0]);
  var paise = int.parse(no[1]);
  String words = "";
  words += "${NumberToWordsEnglish.convert(ruppess)} Rupees and ";
  words += "${NumberToWordsEnglish.convert(paise)} Paise ";
  words = words.replaceAll("-", " ");
  List numberList = words.trim().split(" ");
  print(numberList);
  for (int i = 0; i < numberList.length; i++) {
    numberList[i] = numberList[i]
        .replaceFirst(numberList[i][0], numberList[i][0].toUpperCase());
  }

  String result = numberList.join(" ");
  return result;
}
