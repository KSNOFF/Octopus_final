// ignore_for_file: file_names

class CardContent {
  final int pk;
  final String kj;
  final String ka;
  final String ds;
  final int lv;
  final bool sv;

  const CardContent({
    required this.pk,
    required this.kj,
    required this.ka,
    required this.ds,
    required this.lv,
    required this.sv,
  });

  static CardContent fromJson(json) => CardContent(
      pk: json["Pk"],
      kj: json["Kj"],
      ka: json["Ka"],
      ds: json["Ds"],
      lv: json["Lv"],
      sv: json["Sv"]);
}
