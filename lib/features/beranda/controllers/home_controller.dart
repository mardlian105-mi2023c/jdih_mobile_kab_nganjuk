import 'dart:io';
import 'package:flutter/material.dart';
import '../../../models/peraturan_model.dart';
import '../../../models/peraturan_response_model.dart';
import '../../../core/services/api_service.dart';

enum LoadState {
  loading,
  success,
  empty,
  noInternet,
  serverError,
}

class HomeController {
  List<Peraturan> allData = [];
  List<Peraturan> filteredData = [];
  List<Peraturan> paginatedData = [];

  LoadState loadState = LoadState.loading;

  String searchQuery = '';
  String? selectedJenis;
  String? selectedTahun;
  String? selectedNomor;

  List<String> jenisOptions = [];

  final TextEditingController searchController = TextEditingController();
  final TextEditingController jenisController = TextEditingController();
  final TextEditingController tahunController = TextEditingController();
  final TextEditingController nomorController = TextEditingController();

  final VoidCallback onStateChanged;
  BuildContext? context;

  int currentPage = 1;
  int itemsPerPage = 10;

  bool get hasMoreData =>
      (currentPage * itemsPerPage) < filteredData.length;

  HomeController({
    required this.onStateChanged,
    this.context,
  });

  /// INIT LISTENERS
  void initListeners() {
    searchController.addListener(() {
      search(searchController.text);
    });

    tahunController.addListener(applyFiltersFromInputs);
    nomorController.addListener(applyFiltersFromInputs);
  }

  /// LOAD DATA DARI API
  Future<void> loadData() async {
    loadState = LoadState.loading;
    onStateChanged();

    try {
      final PeraturanResponse response = await ApiService.fetchPeraturan();

      allData = response.data;
      allData.sort((a, b) {
        final yearA = int.tryParse(a.tahunPengundangan) ?? 0;
        final yearB = int.tryParse(b.tahunPengundangan) ?? 0;
        return yearB.compareTo(yearA);
      });

      if (allData.isEmpty) {
        filteredData = [];
        paginatedData = [];
        loadState = LoadState.empty;
        onStateChanged();
        return;
      }

      filteredData = allData;

      /// LIST JENIS PERATURAN
      jenisOptions =
          response.listJenis.map((e) => e.namaJenis).toList();
      jenisOptions.sort();

      loadState = LoadState.success;

      resetPagination();
    } on SocketException {
      loadState = LoadState.noInternet;
      onStateChanged();
    } catch (e) {
      loadState = LoadState.serverError;
      onStateChanged();
    }
  }

  /// SEARCH
  void search(String value) {
    searchQuery = value;
    applyFilters();
  }

  /// FILTER DARI INPUT
  void applyFiltersFromInputs() {
    selectedTahun =
    tahunController.text.trim().isEmpty ? null : tahunController.text.trim();

    selectedNomor =
    nomorController.text.trim().isEmpty ? null : nomorController.text.trim();

    applyFilters();
  }

  /// FILTER JENIS
  void onJenisChanged(String? value) {
    selectedJenis = value;
    jenisController.text = value ?? '';
    applyFilters();
  }

  void applyFilters() {
    filteredData = allData.where((item) {

      final matchesKeyword = searchQuery.isEmpty ||
          item.judul.toLowerCase().contains(searchQuery.toLowerCase()) ||
          item.nomor.toLowerCase().contains(searchQuery.toLowerCase()) ||
          item.jenis.toLowerCase().contains(searchQuery.toLowerCase()) ||
          item.tahunPengundangan.contains(searchQuery);

      final matchesNomor = selectedNomor == null ||
          item.nomor.toLowerCase().contains(selectedNomor!.toLowerCase());

      final matchesJenis = selectedJenis == null ||
          item.jenis.toLowerCase() == selectedJenis!.toLowerCase();

      final matchesTahun = selectedTahun == null ||
          item.tahunPengundangan.contains(selectedTahun!);

      return matchesKeyword &&
          matchesNomor &&
          matchesJenis &&
          matchesTahun;
    }).toList();

    if (filteredData.isEmpty) {
      loadState = LoadState.empty;
    } else {
      loadState = LoadState.success;
    }

    resetPagination();
  }

  /// RESET PAGINATION
  void resetPagination() {
    currentPage = 1;
    _applyPagination();
  }

  void loadMore() {
    if (hasMoreData) {
      currentPage++;
      _applyPagination();
    }
  }

  void _applyPagination() {
    final endIndex = (currentPage * itemsPerPage) > filteredData.length
        ? filteredData.length
        : currentPage * itemsPerPage;

    paginatedData = filteredData.sublist(0, endIndex);

    onStateChanged();
  }

  Future<void> refreshData() async {
    await loadData();
  }

  void clearFilters() {
    searchQuery = '';
    selectedJenis = null;
    selectedTahun = null;
    selectedNomor = null;

    searchController.clear();
    jenisController.clear();
    tahunController.clear();
    nomorController.clear();

    filteredData = allData;

    loadState =
    filteredData.isEmpty ? LoadState.empty : LoadState.success;

    resetPagination();
  }

  void clearSearch() => searchController.clear();
  void clearNomor() => nomorController.clear();

  void clearJenis() {
    jenisController.clear();
    selectedJenis = null;
    applyFilters();
  }

  void clearTahun() => tahunController.clear();

  int getActiveFilterCount() {
    int count = 0;

    if (searchQuery.isNotEmpty) count++;
    if (nomorController.text.isNotEmpty) count++;
    if (jenisController.text.isNotEmpty) count++;
    if (tahunController.text.isNotEmpty) count++;

    return count;
  }

  bool isAnyFilterActive() {
    return searchQuery.isNotEmpty ||
        nomorController.text.isNotEmpty ||
        jenisController.text.isNotEmpty ||
        tahunController.text.isNotEmpty;
  }

  void setContext(BuildContext ctx) {
    context = ctx;
  }

  void dispose() {
    searchController.dispose();
    jenisController.dispose();
    tahunController.dispose();
    nomorController.dispose();
  }
}