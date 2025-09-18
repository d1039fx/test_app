import 'package:test_app/features/user_creation/data/models/user_model.dart';
import '../repositories/user_repository.dart';

/// Use case for editing an existing user.
///
/// This class encapsulates the business logic for updating a user's information.
class EditUser {
  final UserRepository repository;

  /// Creates an [EditUser] use case.
  ///
  /// Requires a [UserRepository] to interact with the data layer.
  EditUser(this.repository);

  /// Executes the use case to update a user.
  ///
  /// The [userModel] parameter contains the updated user data.
  /// Returns a [Future] that completes when the update is done.
  /// Additional business logic, like complex validations, could be added here.
  Future<void> call({
    required UserModel userModel
  }) async {
    repository.updateUser(userModelUpdate: userModel);
  }
}
