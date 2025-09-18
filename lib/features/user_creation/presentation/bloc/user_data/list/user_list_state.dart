part of 'user_list_bloc.dart';

/// Base class for all states related to the user list.
///
/// Uses [Equatable] for value comparison.
sealed class UserListState extends Equatable {
  const UserListState();
}

/// The initial state of the user list.
class UserListInitial extends UserListState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

/// State indicating that the user list is currently being loaded.
class UserListLoading extends UserListState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

/// State indicating that the user list has been successfully loaded.
///
/// Contains the list of [users].
class UserListLoaded extends UserListState {
  /// The list of loaded users.
  final List<User> users;

  /// Creates a [UserListLoaded] state.
  const UserListLoaded(this.users);

  @override
  List<Object> get props => [users];
}

/// State indicating that an error occurred while loading the user list.
///
/// Contains an error [message].
class UserListError extends UserListState {
  /// The error message describing what went wrong.
  final String message;

  /// Creates a [UserListError] state.
  const UserListError(this.message);

  @override
  List<Object> get props => [message];
}
