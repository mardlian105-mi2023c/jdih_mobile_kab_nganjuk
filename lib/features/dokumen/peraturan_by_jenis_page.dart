import 'package:flutter/material.dart';
import 'controllers/peraturan_controller.dart';
import '../../models/peraturan_model.dart';
import '../../widgets/app_bar_widget.dart';
import './widgets/hero_section_widget.dart';
import '../../widgets/peraturan_list_item_widget.dart';
import '../../widgets/result_header_widget.dart';
import '../../widgets/search_bar_widget.dart';
import 'detail_page.dart';

class PeraturanByJenisPage extends StatefulWidget {
  final String jenis;

  const PeraturanByJenisPage({
    super.key,
    required this.jenis,
  });

  @override
  State<PeraturanByJenisPage> createState() =>
      _PeraturanByJenisPageState();
}

class _PeraturanByJenisPageState
    extends State<PeraturanByJenisPage> {
  late PeraturanController _controller;

  List<Peraturan> dataJenis = [];
  List<Peraturan> filteredData = [];

  bool isScrolled = false;
  final ScrollController _scrollController =
  ScrollController();

  String searchQuery = "";

  @override
  void initState() {
    super.initState();

    _controller = PeraturanController(
      onStateChanged: () {
        if (mounted) setState(() {});
      },
    );

    _scrollController.addListener(_onScroll);
    _loadData();
  }

  void _onScroll() {
    if (_scrollController.offset > 80 && !isScrolled) {
      setState(() => isScrolled = true);
    } else if (_scrollController.offset <= 80 && isScrolled) {
      setState(() => isScrolled = false);
    }
  }

  Future<void> _loadData() async {
    await _controller.loadData();

    dataJenis = _controller.allData
        .where((e) =>
    e.jenis.toLowerCase() ==
        widget.jenis.toLowerCase())
        .toList();

    _applySearch("");

    setState(() {});
  }

  void _applySearch(String query) {
    searchQuery = query;

    if (query.isEmpty) {
      filteredData = dataJenis;
    } else {
      filteredData = dataJenis.where((e) {
        return e.judul
            .toLowerCase()
            .contains(query.toLowerCase()) ||
            e.nomor
                .toLowerCase()
                .contains(query.toLowerCase());
      }).toList();
    }

    setState(() {});
  }

  void _goBack() {
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBarWidget(
        isScrolled: isScrolled,
        onBack: _goBack,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_controller.isLoading) {
      return const Center(
          child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: _loadData,
      child: CustomScrollView(
        controller: _scrollController,
        slivers: [
          /// HERO
          SliverToBoxAdapter(
            child: HeroSectionWidget(
              title: widget.jenis,
              subtitle:
              "Daftar dokumen ${widget.jenis}",
            ),
          ),

          /// SEARCH BAR
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 12),
              child: SearchBarWidget(
                onChanged: _applySearch,
              ),
            ),
          ),

          /// RESULT HEADER
          SliverToBoxAdapter(
            child: ResultHeaderWidget(
              filteredCount: filteredData.length,
              totalCount: dataJenis.length,
            ),
          ),

          /// LIST
          if (filteredData.isEmpty)
            const SliverFillRemaining(
              child: Center(
                  child: Text("Tidak ada data")),
            )
          else
            SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  final p = filteredData[index];

                  return PeraturanListItemWidget(
                    peraturan: p,
                    index: index,
                    totalItems:
                    filteredData.length,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              DetailPage(data: p),
                        ),
                      );
                    },
                  );
                },
                childCount: filteredData.length,
              ),
            ),

          const SliverToBoxAdapter(
            child: SizedBox(height: 24),
          ),
        ],
      ),
    );
  }
}