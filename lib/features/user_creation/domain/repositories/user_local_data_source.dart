import 'package:test_app/features/user_creation/data/models/user_model.dart';

/// Abstract contract for a local data source for users.
///
/// Defines the operations that can be performed on user data stored locally.
/// This contract is implemented in the data layer (specifically, in the datasources sub-layer).
/// It typically interacts with local storage mechanisms like Hive, SQLite, or SharedPreferences.
abstract class UserLocalDataSource {
  /// Creates a new user in the local data source.
  ///
  /// Takes [firstName], [lastName], [dateOfBirth], and a list of [addresses]
  /// as parameters.
  /// Returns a [Future] that completes with the created [UserModel].
  Future<UserModel> createUser({
    required String firstName,
    required String lastName,
    required DateTime dateOfBirth,
    required List<String> addresses,
  });

  /// Retrieves a list of all users from the local data source.
  ///
  /// Returns a list of [UserModel] objects.
  List<UserModel> getUsers();

  /// Retrieves a user by their ID from the local data source.
  ///
  /// Takes the [userId] as a parameter.
  /// Returns the [UserModel] if found, otherwise null.
  UserModel? getUsrById(String userId);

  /// Updates an existing user in the local data source.
  ///
  /// Takes the [user] of type [UserModel] containing the updated data.
  void updateUser(UserModel user);

  /// Deletes a user from the local data source by their ID.
  ///
  /// Takes the [userId] as a parameter.
  void deleteUser(String userId);
}
