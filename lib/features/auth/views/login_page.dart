import 'package:flutter/material.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/validation_utils.dart';
import '../models/auth_models.dart';
import '../services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Iniciar Sesión'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: AppConstants.largePadding),
              
              // Logo
              Container(
                height: 100,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Icon(
                  Icons.login,
                  size: 50,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              
              const SizedBox(height: AppConstants.largePadding),
              
              // Título
              Text(
                'Bienvenido de vuelta',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: AppConstants.smallPadding),
              
              Text(
                'Inicia sesión con tu cuenta',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: AppConstants.largePadding),
              
              // Email
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (!ValidationUtils.isNotEmpty(value)) {
                    return 'El email es requerido';
                  }
                  if (!ValidationUtils.isValidEmail(value!)) {
                    return 'Ingresa un email válido';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: AppConstants.defaultPadding),
              
              // Contraseña
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Contraseña',
                  prefixIcon: const Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                obscureText: _obscurePassword,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _handleLogin(),
                validator: (value) {
                  if (!ValidationUtils.isNotEmpty(value)) {
                    return 'La contraseña es requerida';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: AppConstants.largePadding),
              
              // Botón login
              PrimaryButton(
                text: 'Iniciar Sesión',
                onPressed: _handleLogin,
                isLoading: _isLoading,
                icon: Icons.login,
              ),
              
              const SizedBox(height: AppConstants.defaultPadding),
              
              // Registro
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('¿No tienes cuenta? '),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed('/register');
                    },
                    child: const Text('Regístrate'),
                  ),
                ],
              ),
              
              const SizedBox(height: AppConstants.defaultPadding),
              
              // Datos de prueba
              Container(
                padding: const EdgeInsets.all(AppConstants.defaultPadding),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Credenciales de prueba:',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    const Text('Email: user@example.com'),
                    const Text('Contraseña: password123'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final request = LoginRequest(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      final result = await _authService.login(request);

      if (mounted) {
        if (result != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('¡Bienvenido!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).pushReplacementNamed('/home');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Credenciales incorrectas'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}