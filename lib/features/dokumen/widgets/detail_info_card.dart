import 'package:flutter/material.dart';
import '../../../models/peraturan_model.dart';

class DetailInfoCard extends StatelessWidget {
  final Peraturan data;

  const DetailInfoCard({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTitleSection(),
        const SizedBox(height: 16),

        _buildSectionCard(
          title: "Informasi Hukum",
          children: [
            _info("Jenis Peraturan", data.jenis),
            _info("Nomor / Tahun", "${data.nomor}/${data.tahunPengundangan}"),
            _info("Tanggal Penetapan", data.tanggalPenetapan),
            _info("Bahasa", data.bahasa ?? "Bahasa Indonesia"),
            _info("Status", _formatStatus(data.status)),
          ],
        ),

        const SizedBox(height: 16),

        _buildSectionCard(
          title: "Subjek dan Klasifikasi",
          children: [
            _info("Subjek", data.jenis),
            _info("Bidang Hukum", data.bidangHukum ?? "-"),
          ],
        ),

        const SizedBox(height: 16),

        _buildSectionCard(
          title: "Penetapan dan Pengundangan",
          children: [
            _info("Tempat Penetapan", data.tempatTerbit ?? "-"),
            _info("Tanggal Penetapan", data.tanggalPenetapan),
            _info("Tanggal Pengundangan", data.tanggalPengundangan),
            _info("Penandatangan", data.penandatangan ?? "-"),
          ],
        ),

        const SizedBox(height: 16),

        _buildSectionCard(
          title: "Pihak Terkait",
          children: [
            _info("T.E.U", 'Pemerintah ${data.tempatTerbit ?? 'Desa'}'),
            _info("Sumber", data.sumber ?? "-"),
            _info("Pemrakarsa", data.pemrakarsa ?? "-"),
          ],
        ),
      ],
    );
  }

  String _formatStatus(dynamic status) {
    if (status == null) return "Tidak Berlaku";

    final value = status.toString().trim();

    if (value == "1") {
      return "Berlaku";
    }

    return "Tidak Berlaku";
  }

  Widget _buildTitleSection() {
    return _buildSectionCard(
      title: "Judul Peraturan",
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            data.judul,
            textAlign: TextAlign.justify,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              height: 1.5,
            ),
          ),
        )
      ],
    );
  }

  Widget _buildSectionCard({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: Color(0xFF0D47A1),
              borderRadius:
              BorderRadius.vertical(top: Radius.circular(14)),
            ),
            child: Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius:
              BorderRadius.vertical(bottom: Radius.circular(14)),
            ),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }

  Widget _info(String label, String value) {
    return Padding(
      padding:
      const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black54,
              ),
            ),
          ),
          const Text(":", style: TextStyle(fontSize: 13)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}