import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/user.dart';
import '../bloc/user_address_list/user_address_list_bloc.dart';
import '../screen/edit_address_screen.dart';

/// A card widget to display a single address (direction).
///
/// It shows the address string and an optional trailing menu for actions
/// like editing or deleting the address. Interacts with [UserAddressListBloc]
/// to reflect changes.
class DirectionCard extends StatefulWidget {
  /// The address string to display.
  final String direction;
  /// The user to whom this address belongs.
  final User user;
  /// Whether to show the trailing menu for actions. Defaults to false.
  final bool? showMenu;

  /// Creates a [DirectionCard].
  const DirectionCard({
    super.key,
    required this.direction,
    required this.user,
    this.showMenu,
  });

  @override
  State<DirectionCard> createState() => _DirectionCardState();
}

class _DirectionCardState extends State<DirectionCard> {
  final FocusNode _buttonFocusNode = FocusNode(debugLabel: 'Menu Button');

  @override
  void dispose() {
    _buttonFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      shadowColor: Colors.black.withAlpha(150),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        tileColor: Colors.white,
        leading: Icon(Icons.location_on, color: Colors.black.withAlpha(100)),
        title: Text(widget.direction),
        trailing: (widget.showMenu ?? false)
            ? MenuAnchor(
                childFocusNode: _buttonFocusNode,
                menuChildren: <Widget>[
                  MenuItemButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => EditAddressScreen(
                            user: widget.user,
                            currentDirection: widget.direction,
                          ),
                        ),
                      );
                    },
                    child: const Row( // Using Row for better alignment
                      children: [
                        Icon(Icons.edit, size: 20), // Adjusted size
                        SizedBox(width: 8),
                        Text('Editar'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  MenuItemButton(
                    onPressed: () {
                      // Create a mutable copy of the addresses list before modification
                      List<String> updatedAddresses = List<String>.from(widget.user.addresses);
                      updatedAddresses.remove(widget.direction);

                      context.read<UserAddressListBloc>().add(
                            FetchUserAddressesEvent( // This event should trigger an update/delete in the BLoC
                              user: User(
                                id: widget.user.id,
                                firstName: widget.user.firstName,
                                lastName: widget.user.lastName,
                                dateOfBirth: widget.user.dateOfBirth,
                                addresses: updatedAddresses,
                              ),
                            ),
                          );
                    },
                    child: const Row( // Using Row for better alignment
                      children: [
                        Icon(Icons.delete, size: 20), // Adjusted size
                        SizedBox(width: 8),
                        Text('Borrar'),
                      ],
                    ),
                  ),
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
              )
            : null,
      ),
    );
  }
}
