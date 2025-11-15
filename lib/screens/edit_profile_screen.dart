// lib/screens/edit_profile_screen.dart

import 'package:flutter/material.dart';
import 'package:aguatorio/widgets/responsive_layout_wrapper.dart'; // Importa el wrapper responsivo

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // 1. Claves para manejar el estado del formulario
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  bool _isLoading = false;

  // 2. Función para "Guardar" (solo imprime)
  void _handleSave() {
    FocusScope.of(context).unfocus(); // Oculta el teclado

    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Lógica (Pausada): En un futuro, aquí llamaríamos a la API
      // para actualizar los datos del usuario.
      print("Guardando perfil...");

      // Simula un retraso de red
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          _isLoading = false;
        });
        // Muestra un mensaje de éxito
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Perfil actualizado (simulado)"),
            backgroundColor: Colors.green,
          ),
        );
        // Cierra la pantalla
        Navigator.of(context).pop();
      });
    }
  }

  // 3. Función para "Cambiar Foto" (solo imprime)
  void _handleChangePicture() {
    // Lógica (Pausada): Aquí iría el 'image_picker'
    print("Abriendo selector de imagen...");
  }

  // 4. Llenar los campos con datos falsos al inicio
  @override
  void initState() {
    super.initState();
    // (Lógica Futura): Aquí cargaríamos los datos reales del usuario
    _nameController.text = "Usuario de Prueba";
    _emailController.text = "test@test.com";
    _phoneController.text = "9981234567";
    _addressController.text = "Av. Siempre Viva 123";
  }

  // 5. El constructor de la UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar Perfil')),
      body: ResponsiveLayoutWrapper(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // --- 6. Selector de Foto de Perfil ---
                  Center(
                    child: Stack(
                      children: [
                        const CircleAvatar(
                          radius: 60,
                          // Usamos un icono de placeholder
                          child: Icon(Icons.person, size: 70),
                        ),
                        // Botón de editar encima de la foto
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: CircleAvatar(
                            radius: 20,
                            backgroundColor: Theme.of(context).primaryColor,
                            child: IconButton(
                              icon: const Icon(
                                Icons.edit,
                                size: 20,
                                color: Colors.white,
                              ),
                              onPressed: _handleChangePicture,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),

                  // --- 7. Campos del Formulario ---
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

                  const SizedBox(height: 40),

                  // --- 8. Botón de Guardar ---
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          onPressed: _handleSave,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text(
                            'Guardar Cambios',
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

  // 9. Limpia los controladores
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }
}
