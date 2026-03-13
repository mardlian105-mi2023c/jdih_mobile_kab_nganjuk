class TipeDokumen {
  final String kodeTipe;
  final String namaTipe;

  TipeDokumen({
    required this.kodeTipe,
    required this.namaTipe,
  });

  factory TipeDokumen.fromJson(Map<String, dynamic> json) {
    return TipeDokumen(
      kodeTipe: json['kode_tipe'] ?? '',
      namaTipe: json['nama_tipe'] ?? '',
    );
  }
}
