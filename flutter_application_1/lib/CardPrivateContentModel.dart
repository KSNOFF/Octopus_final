// ignore_for_file: file_names

class CardPrivateContent {
  final int pk;
  final String kj;
  final String ka;
  final String ds;
  final int lv;

  const CardPrivateContent({
    required this.pk,
    required this.kj,
    required this.ka,
    required this.ds,
    required this.lv,
  });

  static CardPrivateContent fromJson(json) => CardPrivateContent(
      pk: json["Pk"],
      kj: json["Kj"],
      ka: json["Ka"],
      ds: json["Ds"],
      lv: json["Lv"]);
}
