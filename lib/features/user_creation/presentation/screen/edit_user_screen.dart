import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart'; // Required for date formatting
import 'package:test_app/features/user_creation/presentation/bloc/user_data/list/user_list_bloc.dart';
import '../../domain/entities/user.dart';
import '../bloc/user_form_bloc.dart';

/// A screen for editing an existing user's information.
///
/// This screen provides fields to edit the user's first name, last name,
/// and date of birth. It uses [UserFormBloc] to handle the editing logic
/// and [UserListBloc] to refresh the user list upon successful editing.
class EditUserScreen extends StatefulWidget {
  /// The user whose information is to be edited.
  final User user;
  const EditUserScreen({super.key, required this.user});

  @override
  State<EditUserScreen> createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final dateController = TextEditingController(); // Controller for the date

  DateTime? _selectedDate; // Variable to store the selected date

  @override
  void initState() {
    super.initState();
    firstNameController.text = widget.user.firstName;
    lastNameController.text = widget.user.lastName;
    _selectedDate = widget.user.dateOfBirth;
    dateController.text = DateFormat('dd/MM/yyyy').format(_selectedDate!);
  }

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
      appBar: AppBar(title: const Text('Editar Usuario')), // Changed title
      body: BlocListener<UserFormBloc, UserFormState>(
        listener: (context, state) {
          if (state is UserCreationSuccess) { // Consider renaming to UserUpdateSuccess or similar
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Usuario ${state.user.firstName} actualizado!'), // Updated message
              ),
            );
            // Optionally, refresh the user list if it's visible on a previous screen
            context.read<UserListBloc>().add(FetchUsersEvent());
            Navigator.of(context).pop(); // Go back after successful update
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
                  color: Colors.white,
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
                  color: Colors.white,
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
                  color: Colors.white,
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
                      return const Center(child: CircularProgressIndicator()); // Centered indicator
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
                          EditUserButtonPressed(
                            user: User(
                              id: widget.user.id, // Use existing user ID
                              firstName: firstNameController.text,
                              lastName: lastNameController.text,
                              dateOfBirth: _selectedDate!,
                              addresses: widget.user.addresses, // Preserve existing addresses
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        'Guardar Cambios', // Changed button text
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 15,),
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
