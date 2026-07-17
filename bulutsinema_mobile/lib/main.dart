import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'Application/home/home_bloc.dart';
import 'Application/search/search_bloc.dart';
import 'Core/colors.dart';
import 'Infrastructure/home_repository.dart';
import 'Infrastructure/search_repository.dart';
import 'Presentation/home/home_screen.dart';
import 'Presentation/search/search_screen.dart';

void main() {
  runApp(const BulutsinemaApp());
}

class BulutsinemaApp extends StatelessWidget {
  const BulutsinemaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BULUTSINEMA',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.red,
          brightness: Brightness.dark,
        ).copyWith(
          primary: AppColors.red,
          surface: AppColors.surface,
        ),
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => HomeBloc(HomeRepository())),
          BlocProvider(create: (_) => SearchBloc(SearchRepository())),
        ],
        child: const RootNav(),
      ),
    );
  }
}

class RootNav extends StatefulWidget {
  const RootNav({super.key});

  @override
  State<RootNav> createState() => _RootNavState();
}

class _RootNavState extends State<RootNav> {
  int _index = 0;

  static const _screens = [
    HomeScreen(),
    SearchScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.surface,
        currentIndex: _index,
        selectedItemColor: Colors.white,
        unselectedItemColor: AppColors.muted,
        onTap: (i) => setState(() => _index = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Ana Sayfa'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Ara'),
        ],
      ),
    );
  }
}
