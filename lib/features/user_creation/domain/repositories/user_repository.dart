import 'package:test_app/features/user_creation/data/models/user_model.dart';
import '../entities/user.dart';

/// Abstract contract for a user repository.
///
/// Defines the operations that can be performed on user data,
/// such as creating, updating, and retrieving users.
/// This contract is implemented in the data layer.
abstract class UserRepository {
  /// Creates a new user.
  ///
  /// Takes [firstName], [lastName], [dateOfBirth], and a list of [addresses]
  /// as parameters.
  /// Returns a [Future] that completes with the created [User] object.
  Future<User> createUser({
    required String firstName,
    required String lastName,
    required DateTime dateOfBirth,
    required List<String> addresses,
  });

  /// Updates an existing user.
  ///
  /// Takes a [userModelUpdate] of type [UserModel] containing the updated user data.
  ///
  /// Note: Consider using the domain [User] entity here instead of the data model [UserModel]
  /// for consistency within the domain layer, or define a clear DTO (Data Transfer Object)
  /// if interaction with data layer models is necessary at this level.
  void updateUser({
    required UserModel userModelUpdate
  });

  /// Retrieves a list of all users.
  ///
  /// Returns a [Future] that completes with a list of [User] objects.
  Future<List<User>> getUsers();
}
