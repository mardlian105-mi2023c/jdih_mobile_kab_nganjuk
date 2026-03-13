import 'dart:io';
import 'package:flutter/material.dart';

class DetailActionButtons extends StatelessWidget {
  final bool loading;
  final String? localPath;
  final VoidCallback onOpenPdf;
  final VoidCallback onDownloadPdf;
  final VoidCallback onViewDownloadedPdf;

  const DetailActionButtons({
    super.key,
    required this.loading,
    this.localPath,
    required this.onOpenPdf,
    required this.onDownloadPdf,
    required this.onViewDownloadedPdf,
  });

  static const Color primaryDark = Color(0xFF1E2B3F);
  static const Color greenColor = Color(0xFF059669);
  static const Color redColor = Color(0xFFDC2626);
  static const Color blueColor = Color(0xFF2563EB);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: const BoxDecoration(
              color: Color(0xFF0D47A1),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.description_outlined,
                    color: Colors.white,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  "Dokumen Peraturan",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 4,
                      height: 24,
                      decoration: BoxDecoration(
                        color: primaryDark,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Dokumen PDF',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: primaryDark,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                Container(
                  height: 1,
                  color: Colors.grey[100],
                ),

                const SizedBox(height: 24),

                loading
                    ? _buildLoadingIndicator()
                    : _buildActionButtons(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Column(
        children: const [
          SizedBox(
            height: 48,
            width: 48,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation<Color>(primaryDark),
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Memproses dokumen...',
            style: TextStyle(
              color: Color(0xFF6B7280),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final bool isFileExists = localPath != null;

    return Column(
      children: [
        Row(
          children: [
            Expanded(child: _buildPdfButton()),
            const SizedBox(width: 16),
            Expanded(child: _buildDownloadButton(isFileExists)),
          ],
        ),
        if (isFileExists) ...[
          const SizedBox(height: 16),
          _buildViewDownloadedButton(context),
        ],
      ],
    );
  }

  Widget _buildPdfButton() {
    return _buildCardButton(
      backgroundColor: const Color(0xFFFEF2F2),
      iconBg: redColor,
      icon: Icons.picture_as_pdf_rounded,
      title: 'Buka PDF',
      subtitle: 'Lihat online',
      textColor: redColor,
      onTap: onOpenPdf,
    );
  }

  Widget _buildDownloadButton(bool isFileExists) {
    final baseColor = isFileExists ? greenColor : blueColor;
    final bgColor =
    isFileExists ? const Color(0xFFF0FDF4) : const Color(0xFFEFF6FF);

    return _buildCardButton(
      backgroundColor: bgColor,
      iconBg: baseColor,
      icon: isFileExists
          ? Icons.file_download_done_rounded
          : Icons.download_rounded,
      title: isFileExists ? 'Download Ulang' : 'Download',
      subtitle: isFileExists ? 'Perbarui file' : 'Simpan offline',
      textColor: baseColor,
      onTap: onDownloadPdf,
    );
  }

  Widget _buildCardButton({
    required Color backgroundColor,
    required Color iconBg,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return Material(
      borderRadius: BorderRadius.circular(20),
      color: backgroundColor,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: Colors.white, size: 24),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  color: textColor.withOpacity(0.6),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildViewDownloadedButton(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(20),
      color: const Color(0xFFF8FAFC),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: () async {
          if (localPath != null) {
            final file = File(localPath!);
            if (await file.exists()) {
              onViewDownloadedPdf();
            } else if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content:
                  Text('File tidak ditemukan. Silakan download ulang.'),
                  backgroundColor: Colors.orange,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 18),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.folder_open_rounded, size: 18, color: greenColor),
              SizedBox(width: 12),
              Text(
                'Lihat File Tersimpan',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                  color: primaryDark,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}