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

/// A screen for adding a new address to a user's profile.
///
/// This screen utilizes Google Places API to allow users to search for
/// and select an address. Once an address is selected, it can be saved
/// to the user's profile. It interacts with [UserAddressListBloc]
/// to update the user's address list.
class AddAddressScreen extends StatefulWidget {
  /// The user to whom the new address will be added.
  final User user;

  /// Creates an [AddAddressScreen].
  ///
  /// Requires a [user] object.
  const AddAddressScreen({super.key, required this.user});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  TextEditingController controller = TextEditingController();
  String? apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'];
  bool showDirectionSelected = false;

  @override
  void initState() {
    super.initState();
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
      appBar: AppBar(title: const Text('Añadir Dirección')), // Corrected typo: 'Adherir' to 'Añadir'
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
                  hintText: 'Buscar dirección...',
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
                    print("placeDetails: ${prediction.lng}"); // Log LatLng for debugging
                  }
                },
                itemClick: (Prediction prediction) {
                  setState(() {
                    controller.text = prediction.description ?? '';
                    controller.selection = TextSelection.fromPosition(
                      TextPosition(offset: prediction.description?.length ?? 0),
                    );
                    showDirectionSelected = true;
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
                containerHorizontalPadding: 10,
                placeType: PlaceType.geocode,
                keyboardType: TextInputType.text,
              ),
            ),
            if (showDirectionSelected) // Using if condition for clarity
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                // spacing: 10, // Removed, use SizedBox or Padding for spacing
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    child: const Text(
                      'Dirección seleccionada', // Corrected typo
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10), // Added for spacing
                  DirectionCard(
                    direction: controller.text,
                    user: widget.user,
                    // showMenu is false by default, which is appropriate here
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
                        // Ensure addresses list is mutable if it comes from an immutable source
                        List<String> updatedAddresses = List<String>.from(widget.user.addresses);
                        updatedAddresses.add(controller.text);

                        context.read<UserAddressListBloc>().add(
                              FetchUserAddressesEvent( // This event might be intended to trigger an update/edit
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
                    : null, // Button is disabled if no direction is selected
                child: const Text(
                  'Guardar Dirección', // Corrected typo
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
