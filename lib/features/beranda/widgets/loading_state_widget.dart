import 'package:flutter/material.dart';

class LoadingStateWidget extends StatelessWidget {
  const LoadingStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildLoadingCircle(),
          const SizedBox(height: 24),
          _buildTitle(),
          const SizedBox(height: 8),
          _buildSubtitle(),
        ],
      ),
    );
  }

  Widget _buildLoadingCircle() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.1),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: CircularProgressIndicator(
        color: Colors.blue[700],
        strokeWidth: 2.5,
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      'Memuat data peraturan...',
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Colors.grey[700],
      ),
    );
  }

  Widget _buildSubtitle() {
    return Text(
      'Mohon tunggu sebentar',
      style: TextStyle(
        fontSize: 14,
        color: Colors.grey[500],
      ),
    );
  }
}