import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/core/utils.dart';
import 'package:test_app/features/user_creation/domain/entities/user.dart';

import '../../data/datasources/user_local_data_source_impl.dart';
import '../bloc/user_data/list/user_list_bloc.dart';
import '../screen/edit_user_screen.dart';
import '../screen/user_info_screen.dart';

/// A widget that displays a summary of user information in a list item format.
///
/// This widget shows the user's initials, full name, and date of birth.
/// It provides a tap action to navigate to the [UserInfoScreen] for more details,
/// and a trailing menu with options to edit (navigating to [EditUserScreen])
/// or delete the user. Deletion prompts a confirmation dialog and uses
/// [UserLocalDataSourceImpl] directly, then refreshes the list via [UserListBloc].
class UserInfoList extends StatefulWidget {
  /// The user data to display.
  final User user;
  const UserInfoList({super.key, required this.user});

  @override
  State<UserInfoList> createState() => _UserInfoListState();
}

class _UserInfoListState extends State<UserInfoList> with Utils {
  final FocusNode _buttonFocusNode = FocusNode(debugLabel: 'Menu Button');

  // Consider injecting this dependency rather than creating a static instance.
  static final UserLocalDataSourceImpl userLocalDataSource =
      UserLocalDataSourceImpl();

  @override
  void dispose() {
    _buttonFocusNode.dispose();
    super.dispose();
  }

  /// Shows a confirmation dialog before deleting a user.
  Future<void> _dialogBuilder(BuildContext context, String userId) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) { // Renamed context to avoid conflict
        return AlertDialog(
          title: const Text('Eliminar usuario'),
          content: const Text(
            '¿Estás seguro de que quieres eliminar este usuario?', // Corrected typo and grammar
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(dialogContext).textTheme.labelLarge,
                foregroundColor: Colors.red, // Make delete action more prominent
              ),
              child: const Text('Eliminar'),
              onPressed: () {
                // Direct data source call. Consider moving this logic to a BLoC or use case.
                userLocalDataSource.deleteUser(userId);
                Navigator.of(dialogContext).pop(); // Close dialog
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(dialogContext).textTheme.labelLarge,
              ),
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Close dialog
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      shadowColor: Colors.black.withAlpha(150),
      color: Colors.white,
      child: ListTile(
        splashColor: Colors.deepPurple.withAlpha(30),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => UserInfoScreen(user: widget.user),
            ),
          );
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        leading: CircleAvatar(
          radius: 25,
          child: Text(widget.user.firstName.isNotEmpty ? widget.user.firstName[0].toUpperCase() : 'U'),
        ),
        title: Text(
          '${widget.user.firstName} ${widget.user.lastName}',
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        subtitle: Text(
          'Fecha de nacimiento: ${formatDateCommon(date: widget.user.dateOfBirth)}',
        ),
        trailing: MenuAnchor(
          childFocusNode: _buttonFocusNode,
          menuChildren: <Widget>[
            const SizedBox(height: 10), // Provides padding within the menu
            MenuItemButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => EditUserScreen(user: widget.user),
                  ),
                );
              },
              child: const Row( // Using Row for better alignment
                children: [
                  Icon(Icons.edit, size: 20), // Adjusted size
                  SizedBox(width: 8),
                  Text('Editar usuario'),
                ],
              ),
            ),
            const SizedBox(height: 10), // Adjusted spacing
            MenuItemButton(
              onPressed: () {
                _dialogBuilder(context, widget.user.id).then((_) {
                  // Refresh the list after the dialog is dismissed, regardless of action,
                  // as the delete operation happens within the dialog.
                  // This ensures the list reflects the change if deletion occurred.
                  if (context.mounted) { // Check if the widget is still in the tree
                    context.read<UserListBloc>().add(FetchUsersEvent());
                  }
                });
              },
              child: const Row( // Using Row for better alignment
                children: [
                  Icon(Icons.delete, size: 20, color: Colors.red), // Adjusted size and color
                  SizedBox(width: 8),
                  Text('Borrar usuario', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
            const SizedBox(height: 10), // Provides padding within the menu
          ],
          builder: (context, MenuController controller, Widget? child) {
            return IconButton(
              focusNode: _buttonFocusNode,
              onPressed: () {
                if (controller.isOpen) {
                  controller.close();
                } else {
                  controller.open();
                }
              },
              icon: const Icon(Icons.more_vert),
            );
          },
        ),
      ),
    );
  }
}
