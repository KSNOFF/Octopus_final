//     final refreshDataModel = refreshDataModelFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:convert';

RefreshDataModel refreshDataModelFromJson(Map<String, dynamic> json) =>
    RefreshDataModel.fromJson(json);

String refreshDataModelToJson(RefreshDataModel data) =>
    json.encode(data.toJson());

class RefreshDataModel {
  RefreshDataModel({
    required this.access,
    required this.refresh,
  });

  String access;
  String refresh;

  factory RefreshDataModel.fromJson(Map<String, dynamic> json) =>
      RefreshDataModel(
        access: json["Access"],
        refresh: json["Refresh"],
      );

  Map<String, dynamic> toJson() => {
        "Access": access,
        "Refresh": refresh,
      };
}
