part of 'user_list_bloc.dart';

/// Base class for all events related to the user list.
///
/// Uses [Equatable] for value comparison.
sealed class UserListEvent extends Equatable {
  const UserListEvent();
}

/// Event triggered to fetch the list of users.
class FetchUsersEvent extends UserListEvent {
  @override
  List<Object?> get props => [];
}
