class JenisDokumen {
  final String kodeJenis;
  final String namaJenis;

  JenisDokumen({
    required this.kodeJenis,
    required this.namaJenis,
  });

  factory JenisDokumen.fromJson(Map<String, dynamic> json) {
    return JenisDokumen(
      kodeJenis: json['kode_jenis'] ?? '',
      namaJenis: json['nama_jenis'] ?? '',
    );
  }
}
