import 'package:flutter/material.dart';
import '../../../shared/widgets/primary_button.dart';
import '../../../core/constants/app_constants.dart';
import '../../auth/services/auth_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  
  bool _isEditing = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _loadUserData() {
    final user = _authService.currentUser;
    if (user != null) {
      _nameController.text = user.name;
      _phoneController.text = user.phone ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = _authService.currentUser;
    
    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Perfil')),
        body: const Center(
          child: Text('No hay usuario logueado'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil'),
        actions: [
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                setState(() {
                  _isEditing = true;
                });
              },
            )
          else
            IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                setState(() {
                  _isEditing = false;
                  _loadUserData(); // Restaurar datos originales
                });
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Avatar
              Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.person,
                  size: 60,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              
              const SizedBox(height: AppConstants.largePadding),
              
              // Información del usuario
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.defaultPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Información Personal',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      
                      const SizedBox(height: AppConstants.defaultPadding),
                      
                      // Email (no editable)
                      ListTile(
                        leading: const Icon(Icons.email),
                        title: const Text('Email'),
                        subtitle: Text(user.email),
                        contentPadding: EdgeInsets.zero,
                      ),
                      
                      const Divider(),
                      
                      // Nombre
                      if (_isEditing)
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Nombre completo',
                            prefixIcon: Icon(Icons.person),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'El nombre es requerido';
                            }
                            return null;
                          },
                        )
                      else
                        ListTile(
                          leading: const Icon(Icons.person),
                          title: const Text('Nombre'),
                          subtitle: Text(user.name),
                          contentPadding: EdgeInsets.zero,
                        ),
                      
                      if (_isEditing) const SizedBox(height: AppConstants.defaultPadding),
                      if (!_isEditing) const Divider(),
                      
                      // Teléfono
                      if (_isEditing)
                        TextFormField(
                          controller: _phoneController,
                          decoration: const InputDecoration(
                            labelText: 'Teléfono',
                            prefixIcon: Icon(Icons.phone),
                          ),
                          keyboardType: TextInputType.phone,
                        )
                      else
                        ListTile(
                          leading: const Icon(Icons.phone),
                          title: const Text('Teléfono'),
                          subtitle: Text(user.phone?.isEmpty == false 
                              ? user.phone! 
                              : 'No registrado'),
                          contentPadding: EdgeInsets.zero,
                        ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: AppConstants.largePadding),
              
              // Información adicional
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.defaultPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Información de Cuenta',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      
                      const SizedBox(height: AppConstants.defaultPadding),
                      
                      ListTile(
                        leading: const Icon(Icons.calendar_today),
                        title: const Text('Miembro desde'),
                        subtitle: Text(_formatDate(user.createdAt)),
                        contentPadding: EdgeInsets.zero,
                      ),
                      
                      if (user.updatedAt != null) ...[
                        const Divider(),
                        ListTile(
                          leading: const Icon(Icons.update),
                          title: const Text('Última actualización'),
                          subtitle: Text(_formatDate(user.updatedAt!)),
                          contentPadding: EdgeInsets.zero,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: AppConstants.largePadding),
              
              // Botones de acción
              if (_isEditing)
                Column(
                  children: [
                    PrimaryButton(
                      text: 'Guardar cambios',
                      onPressed: _saveChanges,
                      isLoading: _isLoading,
                      icon: Icons.save,
                    ),
                    const SizedBox(height: AppConstants.defaultPadding),
                  ],
                ),
              
              ElevatedButton.icon(
                onPressed: _logout,
                icon: const Icon(Icons.logout),
                label: const Text('Cerrar sesión'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(AppConstants.buttonHeight),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final user = _authService.currentUser!;
      final updatedUser = user.copyWith(
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim().isEmpty 
            ? null 
            : _phoneController.text.trim(),
      );

      final result = await _authService.updateProfile(updatedUser);

      if (mounted) {
        if (result != null) {
          setState(() {
            _isEditing = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Perfil actualizado exitosamente'),
              backgroundColor: Colors.green,
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Error al actualizar el perfil'),
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

  Future<void> _logout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cerrar sesión'),
        content: const Text('¿Estás seguro de que quieres cerrar sesión?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Cerrar sesión'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final result = await _authService.logout();
      if (mounted && result) {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}