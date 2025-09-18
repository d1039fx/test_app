part of 'user_form_bloc.dart';

/// Base class for all events related to the user form.
///
/// Uses [Equatable] for value comparison.
sealed class UserFormEvent extends Equatable {
  const UserFormEvent();
}

/// Event triggered when the create user button is pressed.
///
/// Contains all the necessary information to create a new user.
class CreateUserButtonPressed extends UserFormEvent {
  /// The first name of the user to be created.
  final String firstName;
  /// The last name of the user to be created.
  final String lastName;
  /// The date of birth of the user to be created.
  final DateTime dateOfBirth;
  /// A list of addresses for the user to be created.
  final List<String> addresses;

  /// Creates a [CreateUserButtonPressed] event.
  const CreateUserButtonPressed({
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    required this.addresses,
  });

  @override
  List<Object?> get props => [firstName, lastName, dateOfBirth, addresses];
}

/// Event triggered when the edit user button is pressed.
///
/// Contains the [User] object that needs to be updated.
class EditUserButtonPressed extends UserFormEvent {
  /// The user object with updated information.
  final User user;

  /// Creates an [EditUserButtonPressed] event.
  const EditUserButtonPressed({required this.user});

  @override
  List<Object?> get props => [user];
}

/// Event triggered when the button to add a new address to a user is pressed.
class AddAddressButtonPressed extends UserFormEvent {
  /// The ID of the user to whom the address will be added.
  final String userId;
  /// The country of the new address.
  final String country;
  /// The department/state of the new address.
  final String department;
  /// The municipality/city of the new address.
  final String municipality;

  /// Creates an [AddAddressButtonPressed] event.
  const AddAddressButtonPressed({
    required this.userId,
    required this.country,
    required this.department,
    required this.municipality,
  });

  @override
  List<Object?> get props => [userId, country, department, municipality];
}

/// Event triggered to load the addresses for a specific user.
class LoadAddressesEvent extends UserFormEvent {
  /// The ID of the user whose addresses are to be loaded.
  final String userId;

  /// Creates a [LoadAddressesEvent] event.
  const LoadAddressesEvent({required this.userId});

  @override
  List<Object?> get props => [userId];
}
