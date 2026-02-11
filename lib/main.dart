import 'package:flutter/material.dart';
import 'shared/styles/app_theme.dart';
import 'pages/home/home_page.dart';
import 'features/auth/views/login_page.dart';
import 'features/auth/views/register_page.dart';
import 'features/profile/views/profile_page.dart';
import 'features/counter/views/counter_page.dart';
import 'features/auth/services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AuthService().initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Form Sign In',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      
      // Página inicial
      initialRoute: _getInitialRoute(),
      
      // Rutas
      routes: {
        '/': (context) => const HomePage(),
        '/home': (context) => const HomePage(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/profile': (context) => const ProfilePage(),
        '/counter': (context) => const CounterPage(),
        '/auth': (context) => const LoginPage(),
      },
      
      // Rutas no encontradas
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(title: const Text('Página no encontrada')),
            body: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64),
                  SizedBox(height: 16),
                  Text(
                    'La página que buscas no existe',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      
      // Debug banner
      debugShowCheckedModeBanner: false,
    );
  }

  String _getInitialRoute() {
    final authService = AuthService();
    return authService.isLoggedIn ? '/home' : '/login';
  }
}
