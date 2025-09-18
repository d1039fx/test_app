import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../data/models/user_model.dart';
import '../../../domain/entities/user.dart';
import '../../../domain/usescases/edit_user.dart';

part 'user_address_list_event.dart';
part 'user_address_list_state.dart';

/// BLoC responsible for managing the state of a user's address list.
///
/// It handles [UserAddressListEvent]s, primarily for fetching (or potentially updating and then displaying)
/// a user's addresses, and emits [UserAddressListState]s to reflect the current state.
class UserAddressListBloc extends Bloc<UserAddressListEvent, UserAddressListState> {
  /// Use case for editing a user. Currently used in the address fetching process.
  final EditUser editUser;

  /// Creates a [UserAddressListBloc].
  ///
  /// Requires an [editUser] use case.
  UserAddressListBloc({required this.editUser}) : super(UserAddressListInitial()) {
    on<FetchUserAddressesEvent>(fetchUserAddresses);
  }

  /// Handles the [FetchUserAddressesEvent].
  ///
  /// Emits [UserAddressListLoading] while processing.
  /// It then attempts to call the [editUser] use case with the user data from the event
  /// and, upon success, emits [UserAddressListLoaded] with the addresses originally present in the event's user data.
  /// If an error occurs, emits [UserAddressListError].
  ///
  /// Note: This method currently uses an [EditUser] use case and emits the addresses
  /// passed in via the event, rather than fetching them from a data source. The naming
  /// `FetchUserAddressesEvent` might be misleading given this implementation.
  void fetchUserAddresses(
      FetchUserAddressesEvent event,
      Emitter<UserAddressListState> emit,
      ) async {
    emit(UserAddressListLoading());
    try {
      final userModel = UserModel(
        id: event.user.id,
        firstName: event.user.firstName,
        lastName: event.user.lastName,
        dateOfBirth: event.user.dateOfBirth,
        addresses: event.user.addresses,
      );
      // The editUser use case is called, but its result is not directly used to populate the loaded addresses.
      editUser(userModel: userModel);
      // Emits the addresses that were part of the input event.
      emit(UserAddressListLoaded(addresses: userModel.addresses));
    } catch (e) {
      // Consider a more specific error message if the operation is more about editing than fetching.
      emit(
        UserAddressListError(message: "Error al procesar direcciones del usuario: ${e.toString()}"),
      );
    }
  }
}
