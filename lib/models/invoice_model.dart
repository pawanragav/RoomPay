class InvoiceModel {
  String? invoiceNO;
  String? date;
  String? modeOfPayment;
  String? total;
  String? totalInWords;
  List<ItemModel>? item;
  UserDetails? buyerDetails;
  UserDetails? sellerDetails;
  String? cgst;
  String? sgst;
  String? startDate;
  String? endDate;

  InvoiceModel(
      {this.invoiceNO,
      this.date,
      this.modeOfPayment,
      this.total,
      this.buyerDetails,
      this.sellerDetails,
      this.item,
      this.totalInWords,
      this.cgst,
      this.sgst,
      this.startDate,
      this.endDate});

  Map<String, dynamic> toJson() {
    return {
      'invoiceNO': invoiceNO,
      'date': date,
      'modeOfPayment': modeOfPayment,
      'total': total,
      'totalInWords': totalInWords,
      'item': item?.map((e) => e.toJson()).toList(),
      'buyerDetails': buyerDetails?.toJson(),
      'sellerDetails': sellerDetails?.toJson(),
      "cgst": cgst,
      "sgst": sgst,
      "start_date": startDate,
      "end_date": endDate
    };
  }
}

class ItemModel {
  String? particulars;
  String? gst;
  String? noOfPeople;
  String? rate;
  String? per;
  String? amount;

  ItemModel({
    this.particulars,
    this.gst,
    this.noOfPeople,
    this.rate,
    this.per,
    this.amount,
  });

  Map<String, dynamic> toJson() {
    return {
      'particulars': particulars,
      'gst': gst,
      'noOfPeople': noOfPeople,
      'rate': rate,
      'per': per,
      'amount': amount,
    };
  }
}

class UserDetails {
  String? name;
  String? address;
  String? gstNo;

  UserDetails({
    this.name,
    this.address,
    this.gstNo,
  });

  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      name: json['name'],
      address: json['address'],
      gstNo: json['gstNo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'address': address,
      'gstNo': gstNo,
    };
  }
}
