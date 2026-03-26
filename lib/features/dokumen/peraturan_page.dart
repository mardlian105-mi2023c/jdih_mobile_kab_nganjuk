import 'package:flutter/material.dart';
import 'controllers/peraturan_controller.dart';
import '../../widgets/app_bar_widget.dart';
import './widgets/hero_section_widget.dart';
import 'peraturan_by_jenis_page.dart';

class PeraturanPage extends StatefulWidget {
  const PeraturanPage({super.key});

  @override
  State<PeraturanPage> createState() => _PeraturanPageState();
}

class _PeraturanPageState extends State<PeraturanPage> {
  late PeraturanController _controller;
  final ScrollController _scrollController = ScrollController();

  bool _isScrolled = false;
  List<String> jenisList = [];

  @override
  void initState() {
    super.initState();

    _controller = PeraturanController(
      onStateChanged: () {
        if (mounted) setState(() {});
      },
    );

    _scrollController.addListener(_onScroll);
    _loadJenis();
  }

  void _onScroll() {
    if (_scrollController.offset > 80 && !_isScrolled) {
      setState(() => _isScrolled = true);
    } else if (_scrollController.offset <= 80 && _isScrolled) {
      setState(() => _isScrolled = false);
    }
  }

  Future<void> _loadJenis() async {
    await _controller.loadData();

    if (_controller.errorMessage != null) return;

    final allJenis =
    _controller.allData.map((e) => e.jenis).toSet().toList();
    allJenis.sort();

    if (mounted) {
      setState(() {
        jenisList = allJenis;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller.setContext(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBarWidget(isScrolled: _isScrolled),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_controller.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_controller.errorMessage != null) {
      return _buildErrorState();
    }

    if (jenisList.isEmpty) {
      return const Center(
        child: Text(
          "Tidak ada jenis dokumen",
          style: TextStyle(fontSize: 14),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadJenis,
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          const SliverToBoxAdapter(
            child: HeroSectionWidget(
              title: "Dokumen Hukum",
              subtitle: "Pilih kategori dokumen hukum",
            ),
          ),

          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                final jenis = jenisList[index];

                return Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              PeraturanByJenisPage(jenis: jenis),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xffF1F3F6),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.20),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              color: const Color(0xffDCE8FF),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.description_outlined,
                              color: Color(0xff3E5C8A),
                            ),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: Text(
                              jenis,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),

                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade900,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              "Pilih",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              childCount: jenisList.length,
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 20)),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.cloud_off,
                size: 70, color: Colors.grey),

            const SizedBox(height: 16),

            Text(
              _controller.errorMessage ?? "Terjadi kesalahan",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: _loadJenis,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff3E5C8A),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text(
                "Coba Lagi",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}