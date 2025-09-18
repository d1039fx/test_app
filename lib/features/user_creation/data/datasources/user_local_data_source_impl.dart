// Implementación (aquí usarías SharedPreferences, Hive, SQLite, etc.)
import 'package:hive_ce/hive.dart';
import 'package:test_app/features/user_creation/data/models/user_model.dart';
import 'package:test_app/features/user_creation/domain/repositories/user_local_data_source.dart';

/// Implements the [UserLocalDataSource] interface using Hive for local storage.
class UserLocalDataSourceImpl implements UserLocalDataSource {

  /// The name of the Hive box used for storing user data.
  static const String userBoxName = 'user_box';
  final Box<UserModel> _userBox;

  /// Creates an instance of [UserLocalDataSourceImpl].
  ///
  /// Initializes the Hive box for users.
  UserLocalDataSourceImpl() : _userBox = Hive.box<UserModel>(userBoxName);

  @override
  Future<UserModel> createUser({
    required String firstName,
    required String lastName,
    required DateTime dateOfBirth,
    required List<String> addresses,
  }) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch.toString();
      final newUser = UserModel(
        id: id,
        firstName: firstName,
        lastName: lastName,
        dateOfBirth: dateOfBirth,
        addresses: [], // Initializes with an empty list of addresses
      );
      _userBox.put(id, newUser);
      return newUser;
    } catch (error) {
      // It's generally better to throw a more specific exception type.
      throw Exception('Failed to create user: $error');
    }
  }

  @override
  List<UserModel> getUsers() {
    try{
      return _userBox.values.toList();
    }catch(e){
      throw Exception('Failed to get users: $e');
    }

  }

  @override
  void deleteUser(String userId) {
    try{
      _userBox.delete(userId);
    }catch(e){
      throw Exception('Failed to delete user: $e');
    }
  }

  @override
  void updateUser(UserModel user) {
    try{
      _userBox.put(user.id, user);
    }catch(e){
      throw Exception('Failed to update user: $e');
    }
  }

  @override
  UserModel? getUsrById(String userId) {
    try{
      return _userBox.get(userId);
    }catch(e){
      throw Exception('Failed to get user by id: $e');
    }
  }
}
