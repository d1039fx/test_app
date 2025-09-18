import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart'; // Needed to format the date
import 'package:test_app/features/user_creation/presentation/bloc/user_data/list/user_list_bloc.dart';
import '../bloc/user_form_bloc.dart';

/// A screen for creating a new user.
///
/// This screen provides a form with fields for first name, last name,
/// and date of birth. It uses [UserFormBloc] to handle the creation logic
/// and [UserListBloc] to refresh the user list upon successful creation.
class CreateUserScreen extends StatefulWidget {
  const CreateUserScreen({super.key});

  @override
  State<CreateUserScreen> createState() => _CreateUserScreenState();
}

class _CreateUserScreenState extends State<CreateUserScreen> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final dateController = TextEditingController();

  DateTime? _selectedDate;

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    dateController.dispose();
    super.dispose();
  }

  /// Displays a date picker dialog to select the user's date of birth.
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1920),
      lastDate: DateTime.now(),
      helpText: 'Selecciona tu fecha de nacimiento',
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        dateController.text = DateFormat('dd/MM/yyyy').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear Usuario')),
      body: BlocListener<UserFormBloc, UserFormState>(
        listener: (context, state) {
          if (state is UserCreationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Usuario ${state.user.firstName} creado!'),
              ),
            );
            // Refresh user list and navigate back
            context.read<UserListBloc>().add(FetchUsersEvent());
            Navigator.of(context).pop();
          } else if (state is UserFormError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  color: Colors
                      .white, // Consider removing if not needed or theme-based
                  child: TextFormField(
                    controller: firstNameController,
                    decoration: InputDecoration(
                      labelText: 'Nombre',
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  color: Colors
                      .white, // Consider removing if not needed or theme-based
                  child: TextFormField(
                    controller: lastNameController,
                    decoration: InputDecoration(
                      labelText: 'Apellido',
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  color: Colors
                      .white, // Consider removing if not needed or theme-based
                  child: TextFormField(
                    controller: dateController,
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Fecha de nacimiento',
                      hintText: 'dd/mm/yyyy',
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () => _selectDate(context),
                      ),
                    ),
                    onTap: () => _selectDate(context),
                  ),
                ),
                const SizedBox(height: 32),
                BlocBuilder<UserFormBloc, UserFormState>(
                  builder: (context, state) {
                    if (state is UserFormLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      ); // Centered indicator
                    }
                    return ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurpleAccent.shade200,
                        padding: const EdgeInsets.all(15),
                      ),
                      onPressed: () {
                        if (_selectedDate == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Por favor, selecciona una fecha de nacimiento.',
                              ),
                              backgroundColor: Colors.orange,
                            ),
                          );
                          return;
                        }
                        context.read<UserFormBloc>().add(
                          CreateUserButtonPressed(
                            addresses: [], // Initial addresses list is empty
                            firstName: firstNameController.text,
                            lastName: lastNameController.text,
                            dateOfBirth: _selectedDate!,
                          ),
                        );
                      },
                      child: const Text(
                        'Guardar y Añadir Dirección',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
