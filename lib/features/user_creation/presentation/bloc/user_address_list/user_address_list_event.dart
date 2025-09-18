part of 'user_address_list_bloc.dart';

/// Base class for all events related to the user's address list.
///
/// Uses [Equatable] for value comparison.
sealed class UserAddressListEvent extends Equatable {
  const UserAddressListEvent();
}

/// Event triggered to fetch or process a user's addresses.
///
/// Contains the [user] whose addresses are to be processed.
/// The exact behavior (fetching, updating) is determined by the BLoC handling this event.
class FetchUserAddressesEvent extends UserAddressListEvent {
  /// The user whose addresses are relevant to this event.
  final User user;

  /// Creates a [FetchUserAddressesEvent].
  const FetchUserAddressesEvent({required this.user});

  @override
  List<Object?> get props => [user];
}
