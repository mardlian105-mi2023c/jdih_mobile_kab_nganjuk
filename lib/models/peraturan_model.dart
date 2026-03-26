class Peraturan {
  final String idData;
  final String tahunPengundangan;
  final String tanggalPengundangan;
  final String tanggalPenetapan;
  final String jenis;
  final String singkatanJenis;
  final String nomor;
  final String judul;
  final String status;
  final String sumber;
  final String bahasa;
  final String pemrakarsa;
  final String tempatTerbit;
  final String? bidangHukum;
  final String? abstrak;
  final String? penandatangan;
  final String? tipedokumen;
  final String kodeTipe;
  final String kodeJenis;
  final String fileDownload;
  final String urlSampul;
  final String urlDownload;
  final String urlDetail;
  final int jumlahView;
  final int jumlahDownload;

  Peraturan({
    required this.idData,
    required this.tahunPengundangan,
    required this.tanggalPengundangan,
    required this.tanggalPenetapan,
    required this.jenis,
    required this.pemrakarsa,
    required this.nomor,
    required this.bahasa,
    required this.judul,
    required this.status,
    required this.sumber,
    required this.tempatTerbit,
    required this.singkatanJenis,
    this.bidangHukum,
    this.abstrak,
    this.penandatangan,
    this.tipedokumen,
    required this.kodeTipe,
    required this.kodeJenis,
    required this.fileDownload,
    required this.urlSampul,
    required this.urlDownload,
    required this.urlDetail,
    required this.jumlahView,
    required this.jumlahDownload,
  });

  factory Peraturan.fromJson(Map<String, dynamic> json) {
    String validate(dynamic value) {
      if (value == null || value.toString().trim().isEmpty) {
        return '-';
      }
      return value.toString();
    }
    
    return Peraturan(
      idData: validate(json['idData']),
      tahunPengundangan: validate(json['tahun_pengundangan']),
      tanggalPengundangan: validate(json['tanggal_pengundangan']),
      tanggalPenetapan: validate(json['tgl_penetapan']),
      singkatanJenis: validate(json['singkatanJenis']),
      jenis: validate(json['jenis']),
      nomor: validate(json['noPeraturan']),
      judul: validate(json['judul']),
      bahasa: validate(json['bahasa']),
      status: validate(json['status']),
      sumber: validate(json['sumber']),
      pemrakarsa: validate(json['pemrakarsa']),
      tempatTerbit: validate(json['tempatTerbit']),
      bidangHukum: validate(json['bidangHukum']),
      abstrak: validate(json['abstrak']),
      penandatangan: validate(json['penandatangan']),
      tipedokumen: validate(json['tipe_dokumen']),
      kodeTipe: validate(json['kode_tipe']),
      kodeJenis: validate(json['kode_jenis']),
      fileDownload: validate(json['fileDownload']),
      urlSampul: validate(json['urlSampul']),
      urlDownload: validate(json['urlDownload']),
      urlDetail: validate(json['urlDetailPeraturan']),
      jumlahView: int.tryParse(json['jml_view'].toString()) ?? 0,
      jumlahDownload: int.tryParse(json['jml_download'].toString()) ?? 0,
    );
  }

  String get id => idData;

  String get pdfUrl => fileDownload.isNotEmpty
      ? urlDownload + fileDownload
      : '';

  String get sampulUrl => urlSampul;
}
