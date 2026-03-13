import 'package:flutter/material.dart';
import '../../widgets/app_bar_widget.dart';
import '../dokumen/detail_page.dart';
import '../../widgets/peraturan_list_item_widget.dart';
import './widgets/empty_state_widget.dart';
import '../../widgets/hero_section_widget.dart';
import './widgets/search_filter_section_widget.dart';
import './widgets/active_filter_info_widget.dart';
import './widgets/result_header_widget.dart';
import './widgets/loading_state_widget.dart';
import './widgets/no_internet_widget.dart';
import './widgets/server_error_widget.dart';
import 'controllers/home_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomeController _controller;
  late ScrollController _scrollController;
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();

    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);

    _controller = HomeController(
      onStateChanged: () {
        if (mounted) setState(() {});
      },
    );

    _controller.loadData();
    _controller.initListeners();
  }

  void _onScroll() {
    if (_scrollController.offset > 180 && !_isScrolled) {
      setState(() => _isScrolled = true);
    } else if (_scrollController.offset <= 180 && _isScrolled) {
      setState(() => _isScrolled = false);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller.setContext(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBarWidget(isScrolled: _isScrolled),
      body: RefreshIndicator(
        onRefresh: () => _controller.refreshData(),
        color: Colors.blue[700],
        backgroundColor: Colors.white,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            SliverToBoxAdapter(
              child: HeroSectionWidget(
                title: "Jaringan Dokumentasi dan Informasi Hukum",
                subtitle: "Kabupaten Nganjuk",
              ),
            ),

            SliverToBoxAdapter(
              child: Material(
                color: Colors.blue.shade900,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(30),
                  bottomRight: Radius.circular(30),
                ),
                child: SearchFilterSectionWidget(
                  searchController: _controller.searchController,
                  searchQuery: _controller.searchQuery,
                  nomorController: _controller.nomorController,
                  jenisController: _controller.jenisController,
                  tahunController: _controller.tahunController,
                  getActiveFilterCount: _controller.getActiveFilterCount,
                  isAnyFilterActive: _controller.isAnyFilterActive,
                  onClearFilters: _controller.clearFilters,
                  jenisOptions: _controller.jenisOptions,
                  onJenisChanged: _controller.onJenisChanged,
                ),
              ),
            ),

            SliverToBoxAdapter(
              child: ActiveFilterInfoWidget(
                searchQuery: _controller.searchQuery,
                selectedNomor: _controller.selectedNomor,
                selectedJenis: _controller.selectedJenis,
                selectedTahun: _controller.selectedTahun,
                isAnyFilterActive: _controller.isAnyFilterActive,
                onClearFilters: _controller.clearFilters,
                onClearSearch: _controller.clearSearch,
                onClearNomor: _controller.clearNomor,
                onClearJenis: _controller.clearJenis,
                onClearTahun: _controller.clearTahun,
              ),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: 16),
            ),

            SliverToBoxAdapter(
              child: ResultHeaderWidget(
                filteredCount: _controller.paginatedData.length,
                totalCount: _controller.allData.length,
                isSearching: _controller.isAnyFilterActive(),
              ),
            ),

            _buildContentSliver(),
          ],
        ),
      ),
    );
  }

  Widget _buildContentSliver() {
    switch (_controller.loadState) {
      case LoadState.loading:
        return const SliverFillRemaining(
          child: LoadingStateWidget(),
        );

      case LoadState.noInternet:
        return SliverFillRemaining(
          child: NoInternetWidget(
            onRetry: _controller.loadData,
          ),
        );

      case LoadState.serverError:
        return SliverFillRemaining(
          child: ServerErrorWidget(
            onRetry: _controller.loadData,
          ),
        );

      case LoadState.empty:
        return SliverFillRemaining(
          child: EmptyStateWidget(
            searchQuery: _controller.searchQuery,
            selectedJenis: _controller.selectedJenis,
            selectedTahun: _controller.selectedTahun,
            onClearFilters: _controller.clearFilters,
          ),
        );

      case LoadState.success:
        return SliverList(
          delegate: SliverChildBuilderDelegate(
                (context, index) {
              if (index < _controller.paginatedData.length) {
                final p = _controller.paginatedData[index];

                return PeraturanListItemWidget(
                  peraturan: p,
                  index: index,
                  totalItems: _controller.paginatedData.length,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetailPage(data: p),
                      ),
                    );
                  },
                );
              } else {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                    child: ElevatedButton(
                      onPressed: _controller.loadMore,
                      child: const Text("Muat Lebih Banyak"),
                    ),
                  ),
                );
              }
            },
            childCount: _controller.paginatedData.length +
                (_controller.hasMoreData ? 1 : 0),
          ),
        );
    }
  }
}