// To parse this JSON data, do
//
//     final dayInfo = dayInfoFromJson(jsonString);

import 'dart:convert';

DayInfo dayInfoFromJson(String str) => DayInfo.fromJson(json.decode(str));

String dayInfoToJson(DayInfo data) => json.encode(data.toJson());

class DayInfo {
  String id;
  String storeId;
  String title;
  String deDigit;
  String status;
  String? remaining_days;

  DayInfo({
    required this.id,
    required this.storeId,
    required this.title,
    required this.deDigit,
    required this.status,
    this.remaining_days
  });

  factory DayInfo.fromJson(Map<String, dynamic> json) => DayInfo(
        id: json["id"],
        storeId: json["store_id"],
        title: json["title"],
        deDigit: json["de_digit"],
        status: json["status"],
        remaining_days: json["remaining_days"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "store_id": storeId,
        "title": title,
        "de_digit": deDigit,
        "status": status,
        "remaining_days": remaining_days,
      };
}
