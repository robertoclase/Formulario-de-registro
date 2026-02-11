import 'package:flutter/material.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/validation_utils.dart';
import '../models/auth_models.dart';
import '../services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _authService = AuthService();
  
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro'),
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
                  Icons.person_add,
                  size: 50,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              
              const SizedBox(height: AppConstants.largePadding),
              
              // Título
              Text(
                'Crear cuenta',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: AppConstants.smallPadding),
              
              Text(
                'Completa tus datos para registrarte',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: AppConstants.largePadding),
              
              // Nombre
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre completo',
                  prefixIcon: Icon(Icons.person),
                ),
                textInputAction: TextInputAction.next,
                textCapitalization: TextCapitalization.words,
                validator: (value) {
                  if (!ValidationUtils.isNotEmpty(value)) {
                    return 'El nombre es requerido';
                  }
                  if (!ValidationUtils.hasMinLength(value!, 2)) {
                    return 'El nombre debe tener al menos 2 caracteres';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: AppConstants.defaultPadding),
              
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
              
              // Teléfono
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Teléfono (opcional)',
                  prefixIcon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (ValidationUtils.isNotEmpty(value) && 
                      !ValidationUtils.isValidPhone(value!)) {
                    return 'Ingresa un teléfono válido';
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
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (!ValidationUtils.isNotEmpty(value)) {
                    return 'La contraseña es requerida';
                  }
                  if (!ValidationUtils.hasMinLength(value!, 8)) {
                    return 'La contraseña debe tener al menos 8 caracteres';
                  }
                  if (!ValidationUtils.isValidPassword(value)) {
                    return 'La contraseña debe tener al menos una mayúscula, una minúscula y un número';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: AppConstants.defaultPadding),
              
              // Confirmar contraseña
              TextFormField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  labelText: 'Confirmar contraseña',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureConfirmPassword = !_obscureConfirmPassword;
                      });
                    },
                  ),
                ),
                obscureText: _obscureConfirmPassword,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _handleRegister(),
                validator: (value) {
                  if (!ValidationUtils.isNotEmpty(value)) {
                    return 'Confirma tu contraseña';
                  }
                  if (value != _passwordController.text) {
                    return 'Las contraseñas no coinciden';
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: AppConstants.largePadding),
              
              // Botón registro
              PrimaryButton(
                text: 'Registrarse',
                onPressed: _handleRegister,
                isLoading: _isLoading,
                icon: Icons.person_add,
              ),
              
              const SizedBox(height: AppConstants.defaultPadding),
              
              // Login
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('¿Ya tienes cuenta? '),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushReplacementNamed('/login');
                    },
                    child: const Text('Inicia sesión'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final request = RegisterRequest(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim().isEmpty 
            ? null 
            : _phoneController.text.trim(),
      );

      final result = await _authService.register(request);

      if (mounted) {
        if (result != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('¡Cuenta creada exitosamente!'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).pushReplacementNamed('/home');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Error al crear la cuenta'),
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