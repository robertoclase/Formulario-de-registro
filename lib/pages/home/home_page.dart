import 'package:flutter/material.dart';
import '../../shared/widgets/feature_card.dart';
import '../../core/constants/app_constants.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Sign In'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: const HomeView(),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bienvenido',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: AppConstants.smallPadding),
          Text(
            'Explora las diferentes funcionalidades disponibles',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: AppConstants.largePadding),
          Text(
            'Funcionalidades',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: AppConstants.defaultPadding),
          _buildFeaturesList(context),
        ],
      ),
    );
  }

  Widget _buildFeaturesList(BuildContext context) {
    final features = [
      {
        'title': 'Autenticación',
        'description': 'Sistema de login y registro de usuarios',
        'icon': Icons.login,
        'route': '/auth',
      },
      {
        'title': 'Perfil de Usuario',
        'description': 'Gestión y edición del perfil personal',
        'icon': Icons.person,
        'route': '/profile',
      },
      {
        'title': 'Contador',
        'description': 'Ejemplo de contador con estado',
        'icon': Icons.add_circle,
        'route': '/counter',
      },
    ];

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: features.length,
      separatorBuilder: (context, index) => 
          const SizedBox(height: AppConstants.defaultPadding),
      itemBuilder: (context, index) {
        final feature = features[index];
        return FeatureCard(
          title: feature['title'] as String,
          description: feature['description'] as String,
          icon: feature['icon'] as IconData,
          onTap: () => _navigateToFeature(context, feature['route'] as String),
        );
      },
    );
  }

  void _navigateToFeature(BuildContext context, String route) {
    Navigator.of(context).pushNamed(route);
  }
}