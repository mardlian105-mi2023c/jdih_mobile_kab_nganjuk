import 'package:flutter/material.dart';
import '../../models/peraturan_model.dart';
import '../../core/utils/file_utils.dart';
import 'pdf_viewer_page.dart';
import './widgets/detail_info_card.dart';
import './widgets/detail_action_buttons.dart';
import './widgets/hero_section_widget.dart';

class DetailPage extends StatefulWidget {
  final Peraturan data;

  const DetailPage({
    super.key,
    required this.data,
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  String? localPath;
  bool loading = false;
  double downloadProgress = 0;

  final ScrollController _scrollController = ScrollController();
  bool isScrolled = false;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.offset > 200 && !isScrolled) {
        setState(() => isScrolled = true);
      } else if (_scrollController.offset <= 200 && isScrolled) {
        setState(() => isScrolled = false);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> openPdf() async {
    setState(() {
      loading = true;
      downloadProgress = 0;
    });

    final path = await FileUtils.downloadPdf(
      widget.data.urlDownload,
      '${widget.data.id}.pdf',
          (progress) {
        setState(() {
          downloadProgress = progress;
        });
      },
    );

    if (!mounted) return;

    setState(() {
      localPath = path;
      loading = false;
    });

    if (path == null) {
      _showSnack("Gagal membuka dokumen PDF", Colors.red);
    } else {
      _navigateToPdfViewer(path);
    }
  }

  Future<void> downloadPdf() async {
    setState(() {
      loading = true;
      downloadProgress = 0;
    });

    final path = await FileUtils.downloadPdf(
      widget.data.urlDownload,
      '${widget.data.id}.pdf',
          (progress) {
        setState(() {
          downloadProgress = progress;
        });
      },
    );

    if (!mounted) return;

    setState(() {
      loading = false;
      localPath = path;
    });

    _showSnack(
      path != null
          ? "PDF berhasil disimpan di Download/JDIH"
          : "Gagal mengunduh PDF",
      path != null ? Colors.green : Colors.red,
    );
  }

  void _viewDownloadedPdf() {
    if (localPath != null) {
      _navigateToPdfViewer(localPath!);
    } else {
      _showSnack("Dokumen belum diunduh.", Colors.orange);
    }
  }

  void _navigateToPdfViewer(String filePath) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PdfViewerPage(
          filePath: filePath,
          title: widget.data.judul,
        ),
      ),
    );
  }

  void _showSnack(String msg, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _buildDownloadProgress() {
    if (!loading) return const SizedBox();

    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Mengunduh Dokumen...",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          LinearProgressIndicator(
            value: downloadProgress,
            minHeight: 6,
            borderRadius: BorderRadius.circular(10),
          ),
          const SizedBox(height: 8),
          Text(
            "${(downloadProgress * 100).toStringAsFixed(0)} %",
            style: const TextStyle(fontWeight: FontWeight.w500),
          )
        ],
      ),
    );
  }

  Widget _badge(IconData icon, String value, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            "$value $label",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsBadges() {
    final viewCount = widget.data.jumlahView ?? 0;
    final downloadCount = widget.data.jumlahDownload ?? 0;

    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _badge(Icons.remove_red_eye_rounded, viewCount.toString(),
              "Dilihat", Colors.blue),
          const SizedBox(width: 20),
          _badge(Icons.download_rounded, downloadCount.toString(),
              "Diunduh", Colors.green),
        ],
      ),
    );
  }

  Widget _buildElegantCover() {
    final coverUrl = widget.data.urlSampul;
    final bool hasImage = coverUrl != null && coverUrl.isNotEmpty;

    if (!hasImage) return const SizedBox();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 14,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.menu_book_rounded,
                    size: 20,
                    color: Colors.blue.shade700,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  "Sampul Dokumen",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade800,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Center(
              child: GestureDetector(
                onTap: () {
                  _openCoverPreview(coverUrl);
                },
                child: Container(
                  width: 200,
                  height: 280,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.12),
                        blurRadius: 18,
                        offset: const Offset(0, 10),
                      )
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      coverUrl,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return Container(
                          color: Colors.grey.shade100,
                          alignment: Alignment.center,
                          child: const CircularProgressIndicator(),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return _imagePlaceholder();
                      },
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),
            Center(
              child: Text(
                "Ketuk gambar untuk memperbesar",
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      color: Colors.grey.shade200,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.image_not_supported_rounded,
              size: 50, color: Colors.grey),
          SizedBox(height: 10),
          Text(
            "Gambar tidak tersedia",
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
        ],
      ),
    );
  }

  void _openCoverPreview(String url) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: Center(
            child: InteractiveViewer(
              child: Image.network(url),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Stack(
        children: [
          CustomScrollView(
            controller: _scrollController,
            slivers: [
              SliverToBoxAdapter(
                child: HeroSectionWidget(
                  title: "Detail Dokumen Hukum",
                  subtitle: widget.data.jenis,
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                    BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24),
                        DetailInfoCard(data: widget.data),
                        const SizedBox(height: 24),
                        DetailActionButtons(
                          loading: loading,
                          localPath: localPath,
                          onOpenPdf: openPdf,
                          onDownloadPdf: downloadPdf,
                          onViewDownloadedPdf: _viewDownloadedPdf,
                        ),
                        _buildDownloadProgress(),
                        const SizedBox(height: 30),
                        _buildStatsBadges(),
                        const SizedBox(height: 30),

                        if (widget.data.urlSampul.isNotEmpty) ...[
                          _buildElegantCover(),
                          const SizedBox(height: 30),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 16,
            child: Material(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(14),
              elevation: 4,
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () => Navigator.pop(context),
                child: const Padding(
                  padding: EdgeInsets.all(10),
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    size: 18,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}