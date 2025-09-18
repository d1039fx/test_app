part of 'user_address_list_bloc.dart';

/// Base class for all states related to the user's address list.
///
/// Uses [Equatable] for value comparison.
sealed class UserAddressListState extends Equatable {
  const UserAddressListState();
}

/// The initial state of the user's address list.
final class UserAddressListInitial extends UserAddressListState {
  @override
  List<Object> get props => [];
}

/// State indicating that the user's address list is currently being loaded or processed.
final class UserAddressListLoading extends UserAddressListState {
  @override
  List<Object> get props => [];
}

/// State indicating that the user's address list has been successfully loaded or processed.
///
/// Contains the list of [addresses].
final class UserAddressListLoaded extends UserAddressListState {
  /// The list of user addresses.
  /// Note: This is currently a list of strings. Consider using a more structured `Address` entity/model if needed.
  final List<String> addresses;

  /// Creates a [UserAddressListLoaded] state.
  const UserAddressListLoaded({required this.addresses});

  @override
  List<Object> get props => [addresses];
}

/// State indicating that an error occurred while loading or processing the user's address list.
///
/// Contains an error [message].
class UserAddressListError extends UserAddressListState {
  /// The error message describing what went wrong.
  final String message;

  /// Creates a [UserAddressListError] state.
  const UserAddressListError({required this.message});

  @override
  List<Object> get props => [message];
}
