import 'package:flutter/material.dart';
import '../models/peraturan_model.dart';

class PeraturanItemWidget extends StatelessWidget {
  final Peraturan peraturan;
  final VoidCallback onTap;

  const PeraturanItemWidget({
    super.key,
    required this.peraturan,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final statusText = _getStatusText(peraturan.status);
    final isBerlaku = statusText.toLowerCase() == "berlaku";

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            peraturan.judul,
            textAlign: TextAlign.justify,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14.5,
              height: 1.35,
            ),
          ),

          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              _smallBadge(
                peraturan.jenis,
                const Color(0xFFEDE9FE),
                const Color(0xFF6D28D9),
              ),
              _smallBadgeFlexible(
                "${peraturan.nomor} / ${peraturan.tahunPengundangan}",
                const Color(0xFFDCEAFE),
                const Color(0xFF2563EB),
              ),
              _smallBadge(
                statusText,
                isBerlaku
                    ? const Color(0xFFE6F6EC)
                    : const Color(0xFFFFF3E0),
                isBerlaku ? Colors.green : Colors.orange,
              ),
            ],
          ),

          const SizedBox(height: 14),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFFDC2626).withOpacity(.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.picture_as_pdf_rounded,
                  color: Color(0xFFDC2626),
                  size: 24,
                ),
              ),

              InkWell(
                borderRadius: BorderRadius.circular(24),
                onTap: onTap,
                child: Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade900,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Text(
                    "Buka Dokumen",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 12.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _smallBadgeFlexible(String text, Color bg, Color textColor) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 180),
      child: _smallBadge(text, bg, textColor),
    );
  }

  Widget _smallBadge(String text, Color bg, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 11,
          color: textColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  String _getStatusText(String status) {
    if (status == "1") return "Berlaku";
    if (status.toLowerCase().contains("berlaku")) return "Berlaku";
    if (status.isEmpty || status == "0") return "Tidak Berlaku";
    return status;
  }
}