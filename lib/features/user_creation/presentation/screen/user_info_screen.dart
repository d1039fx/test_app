import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_app/features/user_creation/presentation/bloc/user_address_list/user_address_list_bloc.dart';

import '../../../../core/utils.dart';
import '../../domain/entities/user.dart';
import '../widgets/direction_card.dart';
import 'add_address_screen.dart';

/// A screen that displays detailed information about a specific user, including their addresses.
///
/// This screen shows the user's name, date of birth, and a list of their saved addresses.
/// It provides a [FloatingActionButton] to navigate to the [AddAddressScreen]
/// for adding new addresses to the current user.
/// It uses [UserAddressListBloc] to listen for updates to the user's addresses.
class UserInfoScreen extends StatelessWidget with Utils {
  /// The user whose information is to be displayed.
  final User user;

  /// Creates a [UserInfoScreen].
  ///
  /// Requires a [user] object.
  const UserInfoScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Información del usuario')),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddAddressScreen(user: user),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 150,
            child: Card(
              margin: const EdgeInsets.all(20),
              color: Colors.white,
              elevation: 6,
              shadowColor: Colors.black.withAlpha(150),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                // spacing: 20, // Consider using MainAxisAlignment.spaceEvenly or SizedBox for spacing
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: CircleAvatar(
                      radius: 30,
                      child: Text(
                        user.firstName.isNotEmpty ? user.firstName[0].toUpperCase() : 'U', // Handle empty name
                        style: const TextStyle(fontSize: 30),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${user.firstName} ${user.lastName}',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Text('Fecha de Nacimiento:'),
                        Text(formatDateCommon(date: user.dateOfBirth)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: const Text(
              'Direcciones guardadas',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: BlocBuilder<UserAddressListBloc, UserAddressListState>(
              builder: (context, state) {
                if (state is UserAddressListLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is UserAddressListError) {
                  return Center(child: Text(state.message));
                }

                List<String> addressesToShow = user.addresses;
                if (state is UserAddressListLoaded) {
                  addressesToShow = state.addresses;
                }

                if (addressesToShow.isEmpty) {
                  return const Center(child: Text('No hay direcciones guardadas.'));
                }

                return ListView.builder(
                  itemCount: addressesToShow.length,
                  itemBuilder: (context, index) {
                    String directionData = addressesToShow[index];
                    return DirectionCard(
                      direction: directionData,
                      user: user,
                      showMenu: true,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
