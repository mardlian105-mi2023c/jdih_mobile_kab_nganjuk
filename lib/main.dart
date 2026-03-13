import 'package:flutter/material.dart';
import 'package:jdih_kab_nganjuk/features/beranda/home_page.dart';
import 'package:provider/provider.dart';
import 'widgets/floating_bottom_bar_widget.dart';
import 'widgets/bottom_nav_provider.dart';
import 'splash_page.dart';
import 'features/dokumen/peraturan_page.dart';
import 'features/about/about_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => BottomNavProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'JDIH Kab. Nganjuk',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'Poppins',
          useMaterial3: true,
          appBarTheme: const AppBarTheme(
            elevation: 0,
            centerTitle: true,
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
          ),
          scaffoldBackgroundColor: Colors.grey[50],
        ),
        home: const SplashPage(),
      ),
    );
  }
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<BottomNavProvider>(
      builder: (context, provider, child) {
        return FloatingBottomBarWidget(
          currentIndex: provider.currentIndex,
          onItemTapped: (index) => provider.onItemTapped(index),
          child: IndexedStack(
            index: provider.currentIndex,
            children: const [
              HomePage(),
              PeraturanPage(),
              AboutPage(),
            ],
          ),
        );
      },
    );
  }
}