import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/place_type.dart';
import 'package:google_places_flutter/model/prediction.dart';

import '../../domain/entities/user.dart';
import '../bloc/user_address_list/user_address_list_bloc.dart';
import '../widgets/direction_card.dart';

/// A screen for editing an existing address of a user.
///
/// This screen allows users to modify a previously saved address using the
/// Google Places API for searching and selecting a new address. The selected
/// address then replaces the old one in the user's profile.
/// It interacts with [UserAddressListBloc] to update the user's address list.
class EditAddressScreen extends StatefulWidget {
  /// The user whose address is being edited.
  final User user;
  /// The current address string that is to be edited.
  final String currentDirection;

  /// Creates an [EditAddressScreen].
  ///
  /// Requires a [user] object and the [currentDirection] string.
  const EditAddressScreen({
    super.key,
    required this.user,
    required this.currentDirection,
  });

  @override
  State<EditAddressScreen> createState() => _EditAddressScreenState();
}

class _EditAddressScreenState extends State<EditAddressScreen> {
  TextEditingController controller = TextEditingController();
  String? apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'];
  bool showDirectionSelected = true; // Initially true as an address is being edited

  @override
  void initState() {
    super.initState();
    // Initialize the controller with the current address being edited.
    controller.text = widget.currentDirection;
    // If the controller text is cleared, hide the selected direction card.
    controller.addListener(() {
      if (controller.text.isEmpty) {
        setState(() {
          showDirectionSelected = false;
        });
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar Dirección')), // Corrected: 'direcciones' to 'Dirección'
      body: SizedBox(
        height: 400, // Consider if a fixed height is ideal or if it should be more dynamic
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              child: GooglePlaceAutoCompleteTextField(
                textEditingController: controller,
                googleAPIKey: apiKey ?? '',
                boxDecoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade300),
                  color: Colors.white,
                ),
                inputDecoration: const InputDecoration(
                  hintText: 'Buscar nueva dirección...',
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                  ),
                ),
                debounceTime: 800,
                isLatLngRequired: true,
                getPlaceDetailWithLatLng: (Prediction prediction) {
                  if (kDebugMode) {
                    print("placeDetails: ${prediction.lat}, ${prediction.lng}");
                  }
                },
                itemClick: (Prediction prediction) {
                  setState(() {
                    controller.text = prediction.description ?? '';
                    controller.selection = TextSelection.fromPosition(
                      TextPosition(offset: prediction.description?.length ?? 0),
                    );
                    showDirectionSelected = true; // Show card when a new place is clicked
                  });
                },
                itemBuilder: (context, index, Prediction prediction) {
                  return Container(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      children: [
                        const Icon(Icons.location_on),
                        const SizedBox(width: 7),
                        Expanded(child: Text(prediction.description ?? "")),
                      ],
                    ),
                  );
                },
                seperatedBuilder: const Divider(),
                isCrossBtnShown: true,
                textInputAction: TextInputAction.done,
                containerHorizontalPadding: 10,
                placeType: PlaceType.geocode,
                keyboardType: TextInputType.text,
              ),
            ),
            if (showDirectionSelected) // Using if condition for clarity
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Text(
                      'Nueva Dirección Seleccionada', // Changed text for clarity
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10), // Added for spacing
                  DirectionCard(
                    direction: controller.text,
                    user: widget.user, // The user context remains the same
                    // showMenu is false by default, appropriate here
                  ),
                ],
              ),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurpleAccent.shade200,
                  padding: const EdgeInsets.all(15),
                ),
                onPressed: showDirectionSelected
                    ? () {
                        // Create a mutable copy of the addresses list
                        List<String> updatedAddresses = List<String>.from(widget.user.addresses);
                        int addressIndex = updatedAddresses.indexOf(widget.currentDirection);

                        if (addressIndex != -1) {
                          updatedAddresses[addressIndex] = controller.text;
                        } else {
                          // Handle case where original address is not found, though unlikely
                          // Optionally, add as new if old one not found, or show error
                          updatedAddresses.add(controller.text); 
                        }

                        context.read<UserAddressListBloc>().add(
                              FetchUserAddressesEvent( // This event should trigger an update in the BLoC/repository
                                user: User(
                                  id: widget.user.id,
                                  firstName: widget.user.firstName,
                                  lastName: widget.user.lastName,
                                  dateOfBirth: widget.user.dateOfBirth,
                                  addresses: updatedAddresses,
                                ),
                              ),
                            );
                        Navigator.of(context).pop();
                      }
                    : null, // Button disabled if no direction is shown/selected
                child: const Text(
                  'Guardar Cambios', // Changed button text
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
