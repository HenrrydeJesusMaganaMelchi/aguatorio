// lib/screens/add_water_log_screen.dart

import 'package:flutter/material.dart';
import 'package:aguatorio/models/activity.dart';
import 'package:aguatorio/services/mock_api_service.dart';
import 'package:aguatorio/services/database_service.dart';
import 'package:aguatorio/services/auth_service.dart';
import 'package:aguatorio/widgets/responsive_layout_wrapper.dart';

class AddWaterLogScreen extends StatefulWidget {
  const AddWaterLogScreen({super.key});

  @override
  State<AddWaterLogScreen> createState() => _AddWaterLogScreenState();
}

class _AddWaterLogScreenState extends State<AddWaterLogScreen> {
  // 1. Estado visual
  int _selectedAmountMl = 250;
  TimeOfDay _selectedTime = TimeOfDay.now();
  final List<int> _amountOptions = [250, 500, 750, 1000];

  // 2. Estado para el Dropdown de Actividades
  final _databaseService = DatabaseService(); // Servicio de base de datos real
  final _authService = AuthService(); // Servicio de autenticación real
  final _api =
      MockApiService(); // Mantenemos MockApi por ahora solo para getActivities si no hay backend para eso aún
  List<Activity> _activityOptions = [];
  Activity? _selectedActivity;
  bool _isLoadingActivities = true;
  bool _isSaving = false; // Estado para el spinner del botón

  // 3. Cargar las actividades al iniciar
  @override
  void initState() {
    super.initState();
    _fetchActivities();
  }

  Future<void> _fetchActivities() async {
    try {
      // Por ahora seguimos usando el mock para las actividades
      // hasta que tengamos una colección de actividades en Firestore
      final activities = await _api.getActivities();
      if (mounted) {
        setState(() {
          _activityOptions = activities;
          _isLoadingActivities = false;
        });
      }
    } catch (e) {
      print("Error al cargar actividades: $e");
      if (mounted) {
        setState(() {
          _isLoadingActivities = false;
        });
      }
    }
  }

  // --- 4. FUNCIÓN _handleSave (¡CORREGIDA!) ---
  Future<void> _handleSave() async {
    setState(() {
      _isSaving = true;
    }); // Muestra el spinner

    // Combina la fecha de hoy con la hora seleccionada
    final now = DateTime.now();
    final timestamp = DateTime(
      now.year,
      now.month,
      now.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    try {
      final user = _authService.currentUser;
      if (user == null) {
        throw Exception('Usuario no autenticado');
      }

      // Llama al servicio real para guardar el log
      await _databaseService.addWaterLog(
        uid: user.uid,
        amount: _selectedAmountMl,
        timestamp: timestamp,
        activityId: _selectedActivity?.id.toString(),
      );

      // Si todo sale bien, cierra la pantalla
      if (mounted) {
        Navigator.of(context).pop(); // Vuelve a la HomeTab
      }
    } catch (e) {
      // Si hay un error
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error al guardar: $e")));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        }); // Oculta el spinner
      }
    }
  }
  // --- FIN DE LA CORRECCIÓN ---

  // 5. El constructor de la UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Añadir Consumo')),
      body: ResponsiveLayoutWrapper(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // ... (El resto de la UI: Cantidad, Hora, Actividad)
                      _buildAmountSelector(),
                      const SizedBox(height: 32),
                      const Divider(),
                      const SizedBox(height: 32),
                      _buildTimeSelector(),
                      const SizedBox(height: 32),
                      const Divider(),
                      const SizedBox(height: 32),
                      _buildActivitySelector(),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // --- BOTÓN DE AÑADIR (MODIFICADO) ---
              // Ahora muestra un spinner si está guardando
              _isSaving
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _handleSave,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'Añadir Consumo',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Widgets Auxiliares (sin cambios) ---

  Widget _buildAmountSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Cantidad (ml)', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12.0,
          alignment: WrapAlignment.center,
          children: _amountOptions.map((amount) {
            final isSelected = _selectedAmountMl == amount;
            return ChoiceChip(
              label: Text(
                '$amount ml',
                style: TextStyle(
                  fontSize: 16,
                  color: isSelected ? Colors.white : Colors.black87,
                ),
              ),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedAmountMl = amount;
                });
              },
              backgroundColor: Colors.grey[200],
              selectedColor: Theme.of(context).colorScheme.primary,
              pressElevation: 5.0,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildTimeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Hora', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: Colors.grey),
          ),
          leading: const Icon(Icons.access_time),
          title: Text(
            _selectedTime.format(context),
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          trailing: const Icon(Icons.arrow_drop_down),
          onTap: () async {
            final newTime = await showTimePicker(
              context: context,
              initialTime: _selectedTime,
            );
            if (newTime != null) {
              setState(() {
                _selectedTime = newTime;
              });
            }
          },
        ),
      ],
    );
  }

  Widget _buildActivitySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Actividad (Opcional)',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 16),

        if (_isLoadingActivities)
          const Center(child: CircularProgressIndicator())
        else
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<Activity>(
                isExpanded: true,
                hint: const Text('Seleccionar actividad'),
                value: _selectedActivity,
                icon: const Icon(Icons.arrow_drop_down),
                items: _activityOptions.map((Activity activity) {
                  return DropdownMenuItem<Activity>(
                    value: activity,
                    child: Text(activity.name),
                  );
                }).toList(),
                onChanged: (Activity? newValue) {
                  setState(() {
                    _selectedActivity = newValue;
                  });
                },
              ),
            ),
          ),
      ],
    );
  }
}
