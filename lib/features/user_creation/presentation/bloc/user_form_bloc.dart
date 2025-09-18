import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:test_app/features/user_creation/data/models/user_model.dart';
import 'package:test_app/features/user_creation/domain/entities/address.dart';
import 'package:test_app/features/user_creation/domain/entities/user.dart';
import 'package:test_app/features/user_creation/domain/usescases/create_user.dart';
import 'package:test_app/features/user_creation/domain/usescases/edit_user.dart';

part 'user_form_event.dart';
part 'user_form_state.dart';

/// BLoC responsible for managing the state of the user creation and editing form.
///
/// It handles [UserFormEvent]s related to creating or editing a user
/// and emits [UserFormState]s to reflect the current state of the operation
/// (initial, loading, success, or error).
class UserFormBloc extends Bloc<UserFormEvent, UserFormState> {
  /// Use case for creating a user.
  final CreateUser createUser;
  /// Use case for editing a user.
  final EditUser editUser;

  /// Creates a [UserFormBloc].
  ///
  /// Requires [createUser] and [editUser] use cases to interact with the domain layer.
  UserFormBloc({required this.createUser, required this.editUser})
    : super(UserFormInitial()) {
    on<CreateUserButtonPressed>(_onCreateUserButtonPressed);
    on<EditUserButtonPressed>(_onEditUserButtonPressed);
  }

  /// Handles the [CreateUserButtonPressed] event.
  ///
  /// Emits [UserFormLoading] while the creation is in progress.
  /// If successful, emits [UserCreationSuccess] with the created user.
  /// If an error occurs, emits [UserFormError].
  void _onCreateUserButtonPressed(
    CreateUserButtonPressed event,
    Emitter<UserFormState> emit,
  ) async {
    emit(UserFormLoading());
    try {
      final user = await createUser(
        firstName: event.firstName,
        lastName: event.lastName,
        dateOfBirth: event.dateOfBirth,
        addresses: event.addresses,
      );
      emit(UserCreationSuccess(user: user));
    } catch (e) {
      emit(
        UserFormError(message: "Error al crear el usuario: ${e.toString()}"),
      );
    }
  }

  /// Handles the [EditUserButtonPressed] event.
  ///
  /// Emits [UserFormLoading] while the editing is in progress.
  /// If successful, constructs a [UserModel] from the event data, calls the edit use case,
  /// and emits [UserCreationSuccess] (consider renaming this state for clarity in edit scenarios).
  /// If an error occurs, emits [UserFormError].
  void _onEditUserButtonPressed(
    EditUserButtonPressed event,
    Emitter<UserFormState> emit,
  ) async {
    emit(UserFormLoading());
    try {
      // Note: It's generally better to pass the domain entity (User) to the event
      // or have the BLoC work directly with domain entities if possible,
      // rather than constructing a data model (UserModel) here.
      final userModel = UserModel(
        id: event.user.id,
        firstName: event.user.firstName,
        lastName: event.user.lastName,
        dateOfBirth: event.user.dateOfBirth,
        addresses: event.user.addresses, // Ensure this aligns with UserModel's expectation
      );
      editUser(userModel: userModel);
      // Consider if UserCreationSuccess is the most appropriate state here, or if a UserEditSuccess state would be clearer.
      // Also, the `user` being emitted here is the UserModel, not necessarily the result from editUser if it were to return one.
      emit(UserCreationSuccess(user: userModel));
    } catch (e) {
      // Consider a more specific error message for editing.
      emit(
        UserFormError(message: "Error al editar el usuario: ${e.toString()}"),
      );
    }
  }
}
