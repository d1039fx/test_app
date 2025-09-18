import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:test_app/features/user_creation/domain/entities/user.dart';
import 'package:test_app/features/user_creation/domain/usescases/get_users.dart';

part 'user_list_event.dart';
part 'user_list_state.dart';

/// BLoC responsible for managing the state of the user list.
///
/// It handles [UserListEvent]s, primarily for fetching the list of users,
/// and emits [UserListState]s to reflect the current state (initial, loading, loaded, or error).
class UserListBloc extends Bloc<UserListEvent, UserListState> {
  /// Use case for getting the list of users.
  final GetUsersUseCase getUsersUseCase; // Inyecta el caso de uso

  /// Creates a [UserListBloc].
  ///
  /// Requires a [getUsersUseCase] to interact with the domain layer for fetching users.
  UserListBloc({required this.getUsersUseCase}) : super(UserListInitial()) {
    on<FetchUsersEvent>(_onFetchUsers);
  }

  /// Handles the [FetchUsersEvent].
  ///
  /// Emits [UserListLoading] while the users are being fetched.
  /// If successful, emits [UserListLoaded] with the list of users.
  /// If an error occurs, emits [UserListError].
  Future<void> _onFetchUsers(FetchUsersEvent event, Emitter<UserListState> emit) async {
    emit(UserListLoading());
    try {
      final users = await getUsersUseCase.call();
      emit(UserListLoaded(users));
    } catch (e) {
      emit(UserListError("Error al cargar usuarios: ${e.toString()}"));
    }
  }
}
