//     final dictionaryDataModel = dictionaryDataModelFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:convert';

List<DictionaryDataModel> dictionaryDataModelFromJson(String str) =>
    List<DictionaryDataModel>.from(
        json.decode(str).map((x) => DictionaryDataModel.fromJson(x)));

String dictionaryDataModelToJson(List<DictionaryDataModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DictionaryDataModel {
  DictionaryDataModel({
    required this.pk,
    required this.kj,
    required this.ka,
    required this.ds,
    required this.lv,
    required this.sv,
  });

  int pk;
  String kj;
  String ka;
  String ds;
  int lv;
  bool sv;

  factory DictionaryDataModel.fromJson(Map<String, dynamic> json) =>
      DictionaryDataModel(
        pk: json["Pk"],
        kj: json["Kj"],
        ka: json["Ka"],
        ds: json["Ds"],
        lv: json["Lv"],
        sv: json["Sv"],
      );

  Map<String, dynamic> toJson() => {
        "Pk": pk,
        "Kj": kj,
        "Ka": ka,
        "Ds": ds,
        "Lv": lv,
        "Sv": sv,
      };
}
