import 'package:flutter/material.dart';

class EmptyStateWidget extends StatelessWidget {
  final String searchQuery;
  final String? selectedJenis;
  final String? selectedTahun;
  final VoidCallback onClearFilters;

  const EmptyStateWidget({
    super.key,
    required this.searchQuery,
    required this.selectedJenis,
    required this.selectedTahun,
    required this.onClearFilters,
  });

  @override
  Widget build(BuildContext context) {
    final hasFilters = searchQuery.isNotEmpty ||
        selectedJenis != null ||
        selectedTahun != null;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          const Text(
            'Data tidak ditemukan',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            hasFilters
                ? 'Tidak ditemukan dengan filter yang dipilih'
                : 'Tidak ada data peraturan',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 20),
          if (hasFilters)
            ElevatedButton(
              onPressed: onClearFilters,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[50],
                foregroundColor: Colors.blue[700],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Reset Filter'),
            ),
        ],
      ),
    );
  }
}