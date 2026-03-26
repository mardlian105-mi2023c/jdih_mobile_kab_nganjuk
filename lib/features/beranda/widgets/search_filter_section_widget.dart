import 'package:flutter/material.dart';

class SearchFilterSectionWidget extends StatefulWidget {
  final TextEditingController searchController;
  final String searchQuery;
  final TextEditingController nomorController;
  final TextEditingController jenisController;
  final TextEditingController tahunController;
  final int Function() getActiveFilterCount;
  final bool Function() isAnyFilterActive;
  final VoidCallback onClearFilters;
  final List<String> jenisOptions;
  final Function(String?) onJenisChanged;

  const SearchFilterSectionWidget({
    super.key,
    required this.searchController,
    required this.searchQuery,
    required this.nomorController,
    required this.jenisController,
    required this.tahunController,
    required this.getActiveFilterCount,
    required this.isAnyFilterActive,
    required this.onClearFilters,
    required this.jenisOptions,
    required this.onJenisChanged,
  });

  @override
  State<SearchFilterSectionWidget> createState() =>
      _SearchFilterSectionWidgetState();
}

class _SearchFilterSectionWidgetState extends State<SearchFilterSectionWidget> {
  static const Color _cardGrey = Color(0xffE6E6E6);

  bool _showFilter = false;

  void _toggleFilter() {
    setState(() {
      _showFilter = !_showFilter;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 24, left: 16, right: 16, bottom: 8),
      child: Column(
        children: [
          _buildSearchRow(),
          const SizedBox(height: 14),
          if (_showFilter) _buildFilterCard(),
        ],
      ),
    );
  }

  Widget _buildSearchRow() {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                )
              ],
            ),
            child: TextField(
              controller: widget.searchController,
              decoration: InputDecoration(
                hintText: "Masukkan Kata Kunci...",
                prefixIcon: const Icon(Icons.search),
                suffixIcon: widget.searchQuery.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    widget.searchController.clear();
                    setState(() {});
                  },
                )
                    : null,
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(40),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),

        GestureDetector(
          onTap: _toggleFilter,
          child: Container(
            height: 54,
            width: 54,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(90),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Icon(Icons.tune, color: Colors.black),
                if (widget.getActiveFilterCount() > 0)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        widget.getActiveFilterCount().toString(),
                        style: const TextStyle(
                            color: Colors.white, fontSize: 10),
                      ),
                    ),
                  )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _cardGrey,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel("Tahun Peraturan"),
          _buildWhiteField(
            controller: widget.tahunController,
            hint: "Masukkan Tahun Peraturan",
            keyboard: TextInputType.number,
          ),
          const SizedBox(height: 14),

          _buildLabel("Jenis Peraturan"),
          _buildJenisDropdown(),
          const SizedBox(height: 14),

          _buildLabel("Nomor Peraturan"),
          _buildWhiteField(
            controller: widget.nomorController,
            hint: "Masukkan Nomor Peraturan",
          ),
          const SizedBox(height: 18),

          Center(child: _buildResetButton()),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 6),
      child: Text(
        text,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildWhiteField({
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboard,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboard,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.black54),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildJenisDropdown() {
    return DropdownButtonFormField<String>(
      value:
      widget.jenisController.text.isNotEmpty ? widget.jenisController.text : null,
      dropdownColor: Colors.white,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        hintText: "Pilih Jenis Peraturan",
        hintStyle: const TextStyle(color: Colors.black54),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40),
          borderSide: BorderSide.none,
        ),
      ),
      items: widget.jenisOptions
          .map((e) => DropdownMenuItem(
        value: e,
        child: Text(e, style: const TextStyle(color: Colors.black)),
      ))
          .toList(),
      onChanged: widget.onJenisChanged,
    );
  }

  Widget _buildResetButton() {
    return SizedBox(
      width: 210,
      child: ElevatedButton(
        onPressed: widget.onClearFilters,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
          elevation: 0,
        ),
        child: const Text("Reset Semua Filter"),
      ),
    );
  }
}