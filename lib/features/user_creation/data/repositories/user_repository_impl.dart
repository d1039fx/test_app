import 'package:test_app/features/user_creation/data/models/user_model.dart';
import 'package:test_app/features/user_creation/domain/repositories/user_local_data_source.dart';

import '../../domain/entities/user.dart';
import '../../domain/repositories/user_repository.dart';

/// Implements the [UserRepository] interface.
///
/// This class is responsible for orchestrating data operations by interacting
/// with data sources (e.g., local or remote).
class UserRepositoryImpl implements UserRepository {
  final UserLocalDataSource localDataSource;

  /// Creates a [UserRepositoryImpl] instance.
  ///
  /// Requires a [localDataSource] to fetch and store user data.
  UserRepositoryImpl({
    required this.localDataSource,
  });

  @override
  Future<User> createUser({
    required String firstName,
    required String lastName,
    required DateTime dateOfBirth,
    required List<String> addresses,
  }) async {
    final userModel = await localDataSource.createUser(
      firstName: firstName,
      lastName: lastName,
      dateOfBirth: dateOfBirth,
      addresses: addresses,
    );
    return userModel.toEntity();
  }

  @override
  Future<List<User>> getUsers() async {
    return localDataSource
        .getUsers()
        .map<User>((toElement) => toElement.toEntity())
        .toList();
  }

  @override
  void updateUser({
    required UserModel userModelUpdate,
  }) async {
    localDataSource.updateUser(userModelUpdate);
  }
}
