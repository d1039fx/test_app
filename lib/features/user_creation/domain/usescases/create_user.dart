import '../entities/user.dart';
import '../repositories/user_repository.dart';

// Un caso de uso encapsula una única pieza de lógica de negocio.
// Depende del contrato del repositorio, no de su implementación.

/// Use case for creating a new user.
///
/// This class encapsulates the business logic required to create a user.
class CreateUser {
  final UserRepository repository;

  /// Creates a [CreateUser] use case.
  ///
  /// Requires a [UserRepository] to interact with the data layer.
  CreateUser(this.repository);

  /// Executes the use case to create a user.
  ///
  /// Takes [firstName], [lastName], [dateOfBirth], and a list of [addresses]
  /// as parameters.
  /// Returns a [Future] that completes with the created [User] object.
  /// Additional business logic, like complex validations, could be added here.
  Future<User> call({
    required String firstName,
    required String lastName,
    required DateTime dateOfBirth,
    required List<String> addresses,
  }) async {
    return await repository.createUser(
        firstName: firstName,
        lastName: lastName,
        dateOfBirth: dateOfBirth,
        addresses: addresses);
  }
}
