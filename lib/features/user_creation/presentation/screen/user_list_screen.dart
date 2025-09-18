// user_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/features/user_creation/presentation/bloc/user_data/list/user_list_bloc.dart';
import 'package:test_app/features/user_creation/presentation/screen/create_user_screen.dart';
import 'package:test_app/features/user_creation/presentation/widgets/user_info_list.dart';

import '../../data/datasources/user_local_data_source_impl.dart';

/// A screen that displays a list of registered users.
///
/// This screen uses a [UserListBloc] to fetch and display user data.
/// It shows a loading indicator while data is being fetched, a list of users
/// if successful, a message if no users are registered, or an error message
/// if fetching fails.
/// A [FloatingActionButton] allows navigation to the [CreateUserScreen] to add new users.
class UserListScreen extends StatelessWidget {
  const UserListScreen({super.key});

  /// A static instance of [UserLocalDataSourceImpl].
  /// Note: Its direct usage within this widget's build method is not apparent.
  /// It might be intended for use by child widgets or other utility functions.
  static final UserLocalDataSourceImpl userLocalDataSource =
      UserLocalDataSourceImpl();

  @override
  Widget build(BuildContext context) {
    // Dispatch FetchUsersEvent when the screen is built, if not already loaded.
    // Consider if this should be done in an initState or a similar one-time setup
    // if UserListScreen were a StatefulWidget, or via a specific event trigger.
    // For a StatelessWidget, this will trigger every time it rebuilds unless the BLoC handles it.
    // A common pattern is to dispatch the event in the BLoC constructor or via a dedicated event.
    // However, if the BLoC is provided higher up and already initialized, this might be intentional
    // to ensure data is fetched when this screen becomes visible.
    // If the data is already in UserListLoaded state, this might re-fetch unnecesarily depending on BLoC logic.
    // For now, assuming the BLoC is initialized and handles this appropriately or this is the intended point of fetch.
    // A more explicit way could be: context.read<UserListBloc>().add(FetchUsersEvent());
    // but only if it's not already loading or loaded, or if a refresh is intended.

    return Scaffold(
      appBar: AppBar(title: const Text('Lista de Usuarios')),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CreateUserScreen()), // Added const
          );
        },
      ),
      body: BlocBuilder<UserListBloc, UserListState>(
        builder: (contextBloc, state) {
          if (state is UserListLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UserListLoaded) {
            if (state.users.isEmpty) {
              return const Center(child: Text('No hay usuarios registrados.'));
            }
            return ListView.builder(
              itemCount: state.users.length,
              itemBuilder: (context, index) {
                final user = state.users[index];
                return UserInfoList(user: user); // Displays each user in the list
              },
            );
          } else if (state is UserListError) {
            return Center(child: Text(state.message));
          }
          // Initial state or any other unhandled state
          // Request to fetch users if in initial state to start data loading
          if (state is UserListInitial) {
             context.read<UserListBloc>().add(FetchUsersEvent());
             return const Center(child: Text('Cargando usuarios...'));
          }
          return const Center(child: Text('Iniciando...')); 
        },
      ),
    );
  }
}
