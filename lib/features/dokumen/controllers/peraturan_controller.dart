import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import '../../../models/peraturan_model.dart';
import '../../../models/peraturan_response_model.dart';
import '../../../models/tipe_dokumen_model.dart';
import '../../../models/jenis_dokumen_model.dart';
import '../../../core/services/api_service.dart';

class PeraturanController {
  // ================= DATA UTAMA =================
  List<Peraturan> allData = [];
  List<Peraturan> filteredData = [];
  List<Peraturan> paginatedData = [];

  // Data kategori
  List<TipeDokumen> listTipe = [];
  List<JenisDokumen> listJenis = [];

  // State
  bool isLoading = true;
  String? errorMessage;

  // Navigasi kategori
  String? selectedJenisKode;
  String? selectedJenisNama;
  String? selectedTipeKode;

  // ================= FILTER =================
  String searchQuery = '';
  String? selectedJenis;
  String? selectedTahun;
  String? selectedNomor;

  List<String> jenisOptions = [];
  List<String> tahunOptions = [];

  // ================= CONTROLLERS =================
  final TextEditingController searchController = TextEditingController();
  final TextEditingController jenisController = TextEditingController();
  final TextEditingController tahunController = TextEditingController();
  final TextEditingController nomorController = TextEditingController();

  // ================= CALLBACK =================
  final VoidCallback onStateChanged;
  BuildContext? context;

  // ================= PAGINATION =================
  int currentPage = 1;
  int itemsPerPage = 10;

  bool get hasMoreData => (currentPage * itemsPerPage) < filteredData.length;

  PeraturanController({
    required this.onStateChanged,
    this.context,
  });

  // ================= ERROR SNACK =================
  void _showSnack(String message) {
    if (context == null) return;

    ScaffoldMessenger.of(context!).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  // ================= LOAD DATA DAN ERROR HANDLING =================
  Future<void> loadData() async {
    try {
      isLoading = true;
      errorMessage = null;
      onStateChanged.call();

      final PeraturanResponse response =
      await ApiService.fetchPeraturan().timeout(const Duration(seconds: 20));

      allData = response.data;
      filteredData = response.data;
      listTipe = response.listTipe;
      listJenis = response.listJenis;

      _generateFilterOptions();

      isLoading = false;
      resetPagination();
    }

    on SocketException catch (e) {
      debugPrint("SocketException: $e");
      isLoading = false;
      errorMessage = 'Tidak ada koneksi internet';
      _showSnack(errorMessage!);
    }

    on TimeoutException catch (e) {
      debugPrint("TimeoutException: $e");
      isLoading = false;
      errorMessage = 'Server tidak merespon';
      _showSnack(errorMessage!);
    }

    on FormatException catch (e) {
      debugPrint("FormatException: $e");
      isLoading = false;
      errorMessage = 'Format data tidak valid';
      _showSnack(errorMessage!);
    }

    on HttpException catch (e) {
      debugPrint("HttpException: $e");
      isLoading = false;
      errorMessage = 'Terjadi kesalahan server';
      _showSnack(errorMessage!);
    }

    catch (e, stack) {
      debugPrint("Unknown error: $e");
      debugPrintStack(stackTrace: stack);

      isLoading = false;
      errorMessage = 'Periksa Koneksi Anda';
      _showSnack(errorMessage!);
    }

    onStateChanged.call();
  }

  // ================= INIT =================
  void initListeners() {
    searchController.addListener(() {
      search(searchController.text);
    });

    tahunController.addListener(applyFiltersFromInputs);
    nomorController.addListener(applyFiltersFromInputs);
  }

  // ================= FILTER OPTIONS =================
  void _generateFilterOptions() {
    jenisOptions = allData.map((e) => e.jenis).toSet().toList();
    jenisOptions.sort();

    tahunOptions = allData.map((e) => e.tahunPengundangan).toSet().toList();
    tahunOptions.sort((a, b) => b.compareTo(a));
  }

  // ================= NAVIGASI =================
  void selectJenis(String kodeJenis, String namaJenis) {
    selectedJenisKode = kodeJenis;
    selectedJenisNama = namaJenis;
    selectedTipeKode = null;
    resetPagination();
    onStateChanged.call();
  }

  void selectTipe(String kodeTipe) {
    selectedTipeKode = kodeTipe;
    resetPagination();
    onStateChanged.call();
  }

  void clearJenisSelection() {
    selectedJenisKode = null;
    selectedJenisNama = null;
    selectedTipeKode = null;
    resetPagination();
    onStateChanged.call();
  }

  void clearTipeSelection() {
    selectedTipeKode = null;
    resetPagination();
    onStateChanged.call();
  }

  // ================= FILTER =================
  void search(String value) {
    searchQuery = value;
    applyFilters();
  }

  void applyFiltersFromInputs() {
    selectedTahun = tahunController.text.trim().isEmpty
        ? null
        : tahunController.text.trim();

    selectedNomor = nomorController.text.trim().isEmpty
        ? null
        : nomorController.text.trim();

    applyFilters();
  }

  void onJenisFilterChanged(String? value) {
    selectedJenis = value;
    jenisController.text = value ?? '';
    applyFilters();
  }

  void onTahunFilterChanged(String? value) {
    selectedTahun = value;
    tahunController.text = value ?? '';
    applyFilters();
  }

  void applyFilters() {
    filteredData = List.from(allData);

    if (searchQuery.isNotEmpty) {
      filteredData = filteredData.where((item) {
        return item.judul.toLowerCase().contains(searchQuery.toLowerCase()) ||
            item.nomor.toLowerCase().contains(searchQuery.toLowerCase()) ||
            item.jenis.toLowerCase().contains(searchQuery.toLowerCase()) ||
            item.tahunPengundangan.contains(searchQuery);
      }).toList();
    }

    if (selectedNomor != null && selectedNomor!.isNotEmpty) {
      filteredData = filteredData.where((item) {
        return item.nomor.toLowerCase().contains(selectedNomor!.toLowerCase());
      }).toList();
    }

    if (selectedJenis != null && selectedJenis!.isNotEmpty) {
      filteredData = filteredData.where((item) {
        return item.jenis.toLowerCase() == selectedJenis!.toLowerCase();
      }).toList();
    }

    if (selectedTahun != null && selectedTahun!.isNotEmpty) {
      filteredData = filteredData.where((item) {
        return item.tahunPengundangan == selectedTahun;
      }).toList();
    }

    resetPagination();
  }

  // ================= PAGINATION =================
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
    onStateChanged.call();
  }

  // ================= UTILS =================
  Future<void> refreshData() async => await loadData();

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
    resetPagination();
  }

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

  // ================= DISPOSE =================
  void dispose() {
    searchController.dispose();
    jenisController.dispose();
    tahunController.dispose();
    nomorController.dispose();
  }

  void setContext(BuildContext ctx) {
    context = ctx;
  }
}