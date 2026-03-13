import 'package:flutter/material.dart';

class ResultHeaderWidget extends StatelessWidget {
  final int filteredCount;
  final int totalCount;
  final bool isSearching;

  const ResultHeaderWidget({
    super.key,
    required this.filteredCount,
    required this.totalCount,
    required this.isSearching,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[200]!,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          _buildIcon(),
          const SizedBox(width: 12),
          _buildTitle(),
          const Spacer(),
          _buildCounter(),
        ],
      ),
    );
  }

  Widget _buildIcon() {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        isSearching
            ? Icons.search_rounded
            : Icons.description,
        size: 18,
        color: Colors.blue[700],
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      isSearching ? 'Hasil Pencarian' : 'Dokumen Terbaru',
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.grey[800],
        letterSpacing: 0.3,
      ),
    );
  }

  Widget _buildCounter() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        isSearching
            ? '$filteredCount dari $totalCount'
            : '$filteredCount dokumen',
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Colors.blue[700],
        ),
      ),
    );
  }
}