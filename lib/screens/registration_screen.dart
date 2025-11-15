// lib/screens/registration_screen.dart

import 'package:flutter/material.dart';
import 'package:aguatorio/services/mock_api_service.dart';
import 'package:aguatorio/screens/onboarding_flow_screen.dart';
import 'package:aguatorio/widgets/responsive_layout_wrapper.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  final _api = MockApiService();

  Future<void> _handleRegistration() async {
    FocusScope.of(context).unfocus();

    if (_formKey.currentState!.validate()) {
      if (_passwordController.text != _confirmPasswordController.text) {
        setState(() {
          _errorMessage = "Las contraseñas no coinciden";
        });
        return;
      }

      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      try {
        final data = {
          'name': _nameController.text,
          'email': _emailController.text,
          'phone': _phoneController.text,
          'address': _addressController.text,
          'password': _passwordController.text,
        };

        final response = await _api.register(data);

        print("¡Registro exitoso! Usuario: ${response['user'].name}");

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("¡Registro exitoso, ${response['user'].name}!"),
            backgroundColor: Colors.green,
          ),
        );

        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => const OnboardingFlowScreen(),
            ),
          );
        }
      } catch (e) {
        setState(() {
          _errorMessage = e.toString().replaceFirst('Exception: ', '');
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear Cuenta')),
      body: ResponsiveLayoutWrapper(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // --- AÑADIR LOGO AQUÍ ---
                  Image.asset(
                    'assets/images/Aguatorio_logo.png', // Usa el logo con texto y fondo blanco
                    height: 120, // Ajusta el tamaño
                  ),
                  const SizedBox(height: 40), // Espacio después del logo
                  // --- Campo de Nombre ---
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nombre Completo',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (value) => (value == null || value.isEmpty)
                        ? 'Ingresa tu nombre'
                        : null,
                  ),
                  const SizedBox(height: 16),

                  // --- Campo de Email ---
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Correo Electrónico',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.email),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) =>
                        (value == null || value.isEmpty || !value.contains('@'))
                        ? 'Ingresa un correo válido'
                        : null,
                  ),
                  const SizedBox(height: 16),

                  // --- Campo de Teléfono ---
                  TextFormField(
                    controller: _phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Teléfono',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.phone),
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) => (value == null || value.isEmpty)
                        ? 'Ingresa tu teléfono'
                        : null,
                  ),
                  const SizedBox(height: 16),

                  // --- Campo de Dirección ---
                  TextFormField(
                    controller: _addressController,
                    decoration: const InputDecoration(
                      labelText: 'Dirección',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.home),
                    ),
                    validator: (value) => (value == null || value.isEmpty)
                        ? 'Ingresa tu dirección'
                        : null,
                  ),
                  const SizedBox(height: 16),

                  // --- Campo de Contraseña ---
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Contraseña',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock_outline),
                    ),
                    obscureText: true,
                    validator: (value) =>
                        (value == null || value.isEmpty || value.length < 6)
                        ? 'La contraseña debe tener al menos 6 caracteres'
                        : null,
                  ),
                  const SizedBox(height: 16),

                  // --- Campo de Confirmar Contraseña ---
                  TextFormField(
                    controller: _confirmPasswordController,
                    decoration: const InputDecoration(
                      labelText: 'Confirmar Contraseña',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.lock),
                    ),
                    obscureText: true,
                    validator: (value) => (value == null || value.isEmpty)
                        ? 'Confirma tu contraseña'
                        : null,
                  ),

                  const SizedBox(height: 24),

                  // --- Mensaje de Error (si existe) ---
                  if (_errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.red, fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    ),

                  // --- Botón de Registro ---
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          onPressed: _handleRegistration,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text(
                            'Crear Cuenta',
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
