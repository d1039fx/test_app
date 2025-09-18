part of 'user_form_bloc.dart';

/// Base class for all states related to the user form.
///
/// Uses [Equatable] for value comparison.
sealed class UserFormState extends Equatable {
  const UserFormState();
}

/// The initial state of the user form.
final class UserFormInitial extends UserFormState {
  @override
  List<Object> get props => [];
}

/// State indicating that a user form operation (e.g., creating, editing) is in progress.
class UserFormLoading extends UserFormState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

/// State indicating that a user has been successfully created.
///
/// Contains the created [user] data.
class UserCreationSuccess extends UserFormState {
  /// The user that was successfully created.
  final User user;

  /// Creates a [UserCreationSuccess] state.
  const UserCreationSuccess({required this.user});

  @override
  List<Object> get props => [user];
}

/// State indicating that a user has been successfully updated.
///
/// Contains the updated [user] data.
class UserUpdateSuccess extends UserFormState {
  /// The user that was successfully updated.
  final User user;

  /// Creates a [UserUpdateSuccess] state.
  const UserUpdateSuccess({required this.user});

  @override
  List<Object> get props => [user];
}

/// State indicating that the list of addresses for a user has been successfully loaded.
///
/// Contains the [user] and their [addresses].
class AddressListLoaded extends UserFormState {
  /// The user whose addresses were loaded.
  final User user;
  /// The list of loaded addresses.
  final List<Address> addresses;

  /// Creates an [AddressListLoaded] state.
  const AddressListLoaded({required this.user, required this.addresses});

  @override
  List<Object> get props => [user, addresses];
}

/// State indicating that an error occurred during a user form operation.
///
/// Contains an error [message].
class UserFormError extends UserFormState {
  /// The error message describing what went wrong.
  final String message;

  /// Creates a [UserFormError] state.
  const UserFormError({required this.message});

  @override
  List<Object> get props => [message];
}
