// To parse this JSON data, do
//
//     final cardModel = cardModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

CardModel cardModelFromJson(String str) => CardModel.fromJson(json.decode(str));

String cardModelToJson(CardModel data) => json.encode(data.toJson());

class CardModel {
  final Links links;
  final List<Result> results;

  CardModel({
    required this.links,
    required this.results,
  });

  factory CardModel.fromJson(Map<String, dynamic> json) => CardModel(
    links: Links.fromJson(json["links"]),
    results: List<Result>.from(json["results"].map((x) => Result.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "links": links.toJson(),
    "results": List<dynamic>.from(results.map((x) => x.toJson())),
  };
}

class Links {
  final String nextPageNumber;
  final String currentPageNumber;
  final dynamic previousPageNumber;

  Links({
    required this.nextPageNumber,
    required this.currentPageNumber,
    required this.previousPageNumber,
  });

  factory Links.fromJson(Map<String, dynamic> json) => Links(
    nextPageNumber: json["next_page_number"],
    currentPageNumber: json["current_page_number"],
    previousPageNumber: json["previous_page_number"],
  );

  Map<String, dynamic> toJson() => {
    "next_page_number": nextPageNumber,
    "current_page_number": currentPageNumber,
    "previous_page_number": previousPageNumber,
  };
}

class Result {
  final int id;
  final SellerDb sellerDb;
  final String hiddenCc;
  final String expMonth;
  final String expYear;
  final bool cvv;
  final bool holdersName;
  final BinBase binBase;
  final bool dob;
  final bool ssn;
  final bool email;
  final bool phone;
  final Country country;
  final String city;
  final String state;
  final String zip;
  final bool address;
  final double price;
  final bool refundable;
  final SellerTag sellerTag;
  final int cvr;
  final bool sensitive;

  Result({
    required this.id,
    required this.sellerDb,
    required this.hiddenCc,
    required this.expMonth,
    required this.expYear,
    required this.cvv,
    required this.holdersName,
    required this.binBase,
    required this.dob,
    required this.ssn,
    required this.email,
    required this.phone,
    required this.country,
    required this.city,
    required this.state,
    required this.zip,
    required this.address,
    required this.price,
    required this.refundable,
    required this.sellerTag,
    required this.cvr,
    required this.sensitive,
  });

  factory Result.fromJson(Map<String, dynamic> json) => Result(
    id: json["id"],
    sellerDb: SellerDb.fromJson(json["seller_db"]),
    hiddenCc: json["hidden_cc"],
    expMonth: json["exp_month"],
    expYear: json["exp_year"],
    cvv: json["cvv"],
    holdersName: json["holders_name"],
    binBase: BinBase.fromJson(json["bin_base"]),
    dob: json["dob"],
    ssn: json["ssn"],
    email: json["email"],
    phone: json["phone"],
    country: countryValues.map[json["country"]]!,
    city: json["city"],
    state: json["state"],
    zip: json["zip"],
    address: json["address"],
    price: json["price"]?.toDouble(),
    refundable: json["refundable"],
    sellerTag: sellerTagValues.map[json["seller_tag"]]!,
    cvr: json["cvr"],
    sensitive: json["sensitive"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "seller_db": sellerDb.toJson(),
    "hidden_cc": hiddenCc,
    "exp_month": expMonth,
    "exp_year": expYear,
    "cvv": cvv,
    "holders_name": holdersName,
    "bin_base": binBase.toJson(),
    "dob": dob,
    "ssn": ssn,
    "email": email,
    "phone": phone,
    "country": countryValues.reverse[country],
    "city": city,
    "state": state,
    "zip": zip,
    "address": address,
    "price": price,
    "refundable": refundable,
    "seller_tag": sellerTagValues.reverse[sellerTag],
    "cvr": cvr,
    "sensitive": sensitive,
  };
}

class BinBase {
  final String bankName;
  final TypeCc1 typeCc1;
  final ClassCc classCc;
  final TypeCc2 typeCc2;

  BinBase({
    required this.bankName,
    required this.typeCc1,
    required this.classCc,
    required this.typeCc2,
  });

  factory BinBase.fromJson(Map<String, dynamic> json) => BinBase(
    bankName: json["bank_name"],
    typeCc1: typeCc1Values.map[json["type_cc1"]]!,
    classCc: classCcValues.map[json["class_cc"]]!,
    typeCc2: typeCc2Values.map[json["type_cc2"]]!,
  );

  Map<String, dynamic> toJson() => {
    "bank_name": bankName,
    "type_cc1": typeCc1Values.reverse[typeCc1],
    "class_cc": classCcValues.reverse[classCc],
    "type_cc2": typeCc2Values.reverse[typeCc2],
  };
}

enum ClassCc {
  AMERICAN_EXPRESS,
  BUSINESS,
  CLASSIC,
  COMPANY,
  COMPANY_REVOLVE,
  ENHANCED,
  MIXED_PRODUCT,
  PERSONAL,
  PERSONAL_REVOLVE,
  PLATINUM,
  PREPAID,
  PREPAID_EMPLOYEE_INCENTIVE,
  PREPAID_GOVERNMENT,
  PREPAID_HSA_NON_SUBSTANTIATED,
  PREPAID_PAYROLL,
  PREPAID_RELOADABLE,
  PROFESSIONAL,
  SIGNATURE,
  STANDARD,
  WORLD,
  WORLD_ELITE
}

final classCcValues = EnumValues({
  "AMERICAN EXPRESS": ClassCc.AMERICAN_EXPRESS,
  "BUSINESS": ClassCc.BUSINESS,
  "CLASSIC": ClassCc.CLASSIC,
  "COMPANY": ClassCc.COMPANY,
  "COMPANY REVOLVE": ClassCc.COMPANY_REVOLVE,
  "ENHANCED": ClassCc.ENHANCED,
  "MIXED PRODUCT": ClassCc.MIXED_PRODUCT,
  "PERSONAL": ClassCc.PERSONAL,
  "PERSONAL REVOLVE": ClassCc.PERSONAL_REVOLVE,
  "PLATINUM": ClassCc.PLATINUM,
  "PREPAID": ClassCc.PREPAID,
  "PREPAID EMPLOYEE INCENTIVE": ClassCc.PREPAID_EMPLOYEE_INCENTIVE,
  "PREPAID GOVERNMENT": ClassCc.PREPAID_GOVERNMENT,
  "PREPAID HSA NON-SUBSTANTIATED": ClassCc.PREPAID_HSA_NON_SUBSTANTIATED,
  "PREPAID PAYROLL": ClassCc.PREPAID_PAYROLL,
  "PREPAID RELOADABLE": ClassCc.PREPAID_RELOADABLE,
  "PROFESSIONAL": ClassCc.PROFESSIONAL,
  "SIGNATURE": ClassCc.SIGNATURE,
  "STANDARD": ClassCc.STANDARD,
  "WORLD": ClassCc.WORLD,
  "WORLD ELITE": ClassCc.WORLD_ELITE
});

enum TypeCc1 {
  AMERICAN_EXPRESS,
  DISCOVER,
  MASTERCARD,
  VISA
}

final typeCc1Values = EnumValues({
  "AMERICAN EXPRESS": TypeCc1.AMERICAN_EXPRESS,
  "DISCOVER": TypeCc1.DISCOVER,
  "MASTERCARD": TypeCc1.MASTERCARD,
  "VISA": TypeCc1.VISA
});

enum TypeCc2 {
  CREDIT,
  DEBIT
}

final typeCc2Values = EnumValues({
  "CREDIT": TypeCc2.CREDIT,
  "DEBIT": TypeCc2.DEBIT
});

enum Country {
  UNITED_KINGDOM,
  UNITED_STATES
}

final countryValues = EnumValues({
  "United Kingdom": Country.UNITED_KINGDOM,
  "United States": Country.UNITED_STATES
});

class SellerDb {
  final PartName partName;
  final double rating;

  SellerDb({
    required this.partName,
    required this.rating,
  });

  factory SellerDb.fromJson(Map<String, dynamic> json) => SellerDb(
    partName: partNameValues.map[json["part_name"]]!,
    rating: json["rating"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "part_name": partNameValues.reverse[partName],
    "rating": rating,
  };
}

enum PartName {
  THE_08082023_MQ_UNDERWEAR,
  THE_11082023_USA_ECOMMERCE_SITE_DATABASE_DUMP,
  THE_16082023_USA_ECOMMERCE_SITE_DUMP,
  THE_26082023_USA_MARKET_UP,
  THE_27082023_USA_HIGH_VALID_CARDS
}

final partNameValues = EnumValues({
  "[08.08.2023] MQ UNDERWEAR": PartName.THE_08082023_MQ_UNDERWEAR,
  "[11.08.2023] USA ecommerce site database dump": PartName.THE_11082023_USA_ECOMMERCE_SITE_DATABASE_DUMP,
  "[16.08.2023] USA Ecommerce site dump": PartName.THE_16082023_USA_ECOMMERCE_SITE_DUMP,
  "[26.08.2023] USA MARKET UP": PartName.THE_26082023_USA_MARKET_UP,
  "[27.08.2023] USA HIGH VALID CARDS": PartName.THE_27082023_USA_HIGH_VALID_CARDS
});

enum SellerTag {
  SELLER13725,
  SELLER47326
}

final sellerTagValues = EnumValues({
  "seller13725": SellerTag.SELLER13725,
  "seller47326": SellerTag.SELLER47326
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
