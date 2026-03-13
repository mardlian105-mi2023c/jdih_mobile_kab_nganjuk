import 'peraturan_model.dart';
import 'tipe_dokumen_model.dart';
import 'jenis_dokumen_model.dart';

class PeraturanResponse {
  final List<TipeDokumen> listTipe;
  final List<JenisDokumen> listJenis;
  final List<Peraturan> data;

  PeraturanResponse({
    required this.listTipe,
    required this.listJenis,
    required this.data,
  });

  factory PeraturanResponse.fromJson(Map<String, dynamic> json) {
    return PeraturanResponse(
      listTipe: (json['list_tipe'] as List? ?? [])
          .map((e) => TipeDokumen.fromJson(e))
          .toList(),

      listJenis: (json['list_jenis'] as List? ?? [])
          .map((e) => JenisDokumen.fromJson(e))
          .toList(),

      data: (json['data'] as List? ?? [])
          .map((e) => Peraturan.fromJson(e))
          .toList(),
    );
  }
}
