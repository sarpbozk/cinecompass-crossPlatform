import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'blocs/favorites/favorites_bloc.dart';
import 'blocs/favorites/favorites_event.dart';
import 'blocs/movies/movies_bloc.dart';
import 'screens/home_screen.dart';
import 'screens/favorites_screen.dart';
import 'services/movie_service.dart';
import 'services/secure_storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize secure storage with API key
  final secureStorage = SecureStorageService();
  await secureStorage.initialize();
  
  runApp(MyApp(secureStorage: secureStorage));
}

class MyApp extends StatelessWidget {
  final SecureStorageService secureStorage;
  
  const MyApp({super.key, required this.secureStorage});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<FavoritesBloc>(
          create: (context) => FavoritesBloc()..add(LoadFavorites()),
        ),
        BlocProvider<MoviesBloc>(
          create: (context) => MoviesBloc(
            movieService: MovieService(),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'CineCompass',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MainScreen(),
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _screens = [
    HomeScreen(),
    FavoritesScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
