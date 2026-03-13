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
    return Peraturan(
      idData: json['idData']?.toString() ?? '',
      tahunPengundangan: json['tahun_pengundangan'] ?? '',
      tanggalPengundangan: json['tanggal_pengundangan'] ?? '',
      tanggalPenetapan: json['tgl_penetapan'] ?? '',
      singkatanJenis: json['singkatanJenis'] ?? '',
      jenis: json['jenis'] ?? '',
      nomor: json['noPeraturan'] ?? '',
      judul: json['judul'] ?? '',
      bahasa: json['bahasa'] ?? '',
      status: json['status'] ?? '',
      sumber: json['sumber'] ?? '',
      pemrakarsa: json['pemrakarsa'] ?? '',
      tempatTerbit: json['tempatTerbit'] ?? '',
      bidangHukum: json['bidangHukum'],
      abstrak: json['abstrak'],
      penandatangan: json['penandatangan'],
      tipedokumen: json['tipe_dokumen'],
      kodeTipe: json['kode_tipe'] ?? '',
      kodeJenis: json['kode_jenis'] ?? '',
      fileDownload: json['fileDownload'] ?? '',
      urlSampul: json['urlSampul'] ?? '',
      urlDownload: json['urlDownload'] ?? '',
      urlDetail: json['urlDetailPeraturan'] ?? '',
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
