import 'package:flutter/material.dart';

class ActiveFilterInfoWidget extends StatelessWidget {
  final String searchQuery;
  final String? selectedNomor;
  final String? selectedJenis;
  final String? selectedTahun;
  final bool Function() isAnyFilterActive;
  final VoidCallback onClearFilters;
  final VoidCallback onClearSearch;
  final VoidCallback onClearNomor;
  final VoidCallback onClearJenis;
  final VoidCallback onClearTahun;

  const ActiveFilterInfoWidget({
    super.key,
    required this.searchQuery,
    required this.selectedNomor,
    required this.selectedJenis,
    required this.selectedTahun,
    required this.isAnyFilterActive,
    required this.onClearFilters,
    required this.onClearSearch,
    required this.onClearNomor,
    required this.onClearJenis,
    required this.onClearTahun,
  });

  @override
  Widget build(BuildContext context) {
    if (!_hasActiveFilters()) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.only(top: 8, left: 16, right: 16),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          if (searchQuery.isNotEmpty)
            _buildFilterChip(
              label: 'Pencarian: "$searchQuery"',
              color: Colors.orange,
              onDelete: onClearSearch,
            ),
          if (selectedNomor != null && selectedNomor!.isNotEmpty)
            _buildFilterChip(
              label: 'Nomor: $selectedNomor',
              color: Colors.purple,
              onDelete: onClearNomor,
            ),
          if (selectedJenis != null && selectedJenis!.isNotEmpty)
            _buildFilterChip(
              label: 'Jenis: $selectedJenis',
              color: Colors.blue,
              onDelete: onClearJenis,
            ),
          if (selectedTahun != null && selectedTahun!.isNotEmpty)
            _buildFilterChip(
              label: 'Tahun: $selectedTahun',
              color: Colors.green,
              onDelete: onClearTahun,
            ),
          if (isAnyFilterActive())
            _buildClearAllButton(),
        ],
      ),
    );
  }

  bool _hasActiveFilters() {
    return searchQuery.isNotEmpty ||
        (selectedNomor != null && selectedNomor!.isNotEmpty) ||
        (selectedJenis != null && selectedJenis!.isNotEmpty) ||
        (selectedTahun != null && selectedTahun!.isNotEmpty);
  }

  Widget _buildFilterChip({
    required String label,
    required Color color,
    required VoidCallback onDelete,
  }) {
    return Chip(
      label: Text(
        label,
        style: TextStyle(
          fontSize: 13,
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
      backgroundColor: color.withValues(alpha: 0.1),
      deleteIcon: Icon(
        Icons.close_rounded,
        size: 16,
        color: color,
      ),
      onDeleted: onDelete,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: color.withValues(alpha: 0.3)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
    );
  }

  Widget _buildClearAllButton() {
    return GestureDetector(
      onTap: onClearFilters,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.clear_all_rounded, size: 16, color: Colors.grey[600]),
            const SizedBox(width: 4),
            Text(
              'Hapus semua',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}