import 'package:flutter/material.dart';
import './widgets/section_widget.dart';
import './widgets/info_item_widget.dart';
import './widgets/contact_item_widget.dart';
import '../../widgets/app_bar_widget.dart';
import './widgets/hero_section_widget.dart';

class AboutPage extends StatefulWidget {
  const AboutPage({super.key});

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  final ScrollController _scrollController = ScrollController();
  bool _isScrolled = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.offset > 80 && !_isScrolled) {
      setState(() => _isScrolled = true);
    } else if (_scrollController.offset <= 80 && _isScrolled) {
      setState(() => _isScrolled = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.grey[50],
      appBar: AppBarWidget(isScrolled: _isScrolled),

      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          const SliverToBoxAdapter(
            child: HeroSectionWidget(
              title: "Tentang JDIH Mobile",
              subtitle:
              "Kabupaten Nganjuk",
            ),
          ),

          SliverList(
            delegate: SliverChildListDelegate([
              const SizedBox(height: 20),
              const SectionWidget(
                title: 'Informasi Aplikasi',
                children: [
                  InfoItemWidget(label: 'Versi', value: '1.0.0'),
                  InfoItemWidget(
                    label: 'Dikembangkan oleh',
                    value: 'Diskominfo Kab. Nganjuk',
                  ),
                  InfoItemWidget(label: 'Tahun Rilis', value: '2026'),
                ],
              ),

              const SizedBox(height: 24),

              SectionWidget(
                title: 'Tentang Aplikasi',
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      'Aplikasi JDIH Mobile adalah platform digital yang menyediakan akses mudah dan cepat terhadap Jaringan Dokumentasi dan Informasi Hukum (JDIH) Kabupaten Nganjuk.',
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.6,
                        color: Colors.grey[700],
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              const SectionWidget(
                title: 'Kontak',
                children: [
                  ContactItemWidget(
                    icon: Icons.location_on,
                    title: 'Alamat',
                    subtitle:
                    'Jl. Merdeka No. 21, Kel. Mangundikaran Kec. Nganjuk Kab. Nganjuk',
                  ),
                  ContactItemWidget(
                    icon: Icons.phone,
                    title: 'Telepon',
                    subtitle: '(0358) 3550320',
                  ),
                  ContactItemWidget(
                    icon: Icons.email,
                    title: 'Email',
                    subtitle: 'jdih@nganjukkab.go.id',
                  ),
                  ContactItemWidget(
                    icon: Icons.language,
                    title: 'Website',
                    subtitle: 'jdih.nganjukkab.go.id',
                  ),
                ],
              ),

              const SizedBox(height: 24),

              Center(
                child: Text(
                  '©2026 Pemerintah Kabupaten Nganjuk',
                  style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                ),
              ),

              const SizedBox(height: 20),
            ]),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }
}