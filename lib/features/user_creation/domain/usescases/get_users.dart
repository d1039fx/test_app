import '../entities/user.dart';
import '../repositories/user_repository.dart';

/// Use case for retrieving a list of users.
///
/// This class encapsulates the business logic for fetching all users.
class GetUsersUseCase {
  final UserRepository repository;

  /// Creates a [GetUsersUseCase] instance.
  ///
  /// Requires a [UserRepository] to interact with the data layer.
  GetUsersUseCase(this.repository);

  /// Executes the use case to get all users.
  ///
  /// Returns a [Future] that completes with a list of [User] objects.
  Future<List<User>> call() async { // O execute()
    return await repository.getUsers();
  }
}
