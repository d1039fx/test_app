import 'package:equatable/equatable.dart';
import 'package:hive_ce_flutter/adapters.dart';

// Las entidades son objetos de negocio puros. No contienen lógica de serialización
// ni dependen de ningún framework. Usamos `equatable` para facilitar la comparación.

/// Represents a user entity in the domain layer.
///
/// This class is a pure business object and uses [Equatable] for value comparison.
/// It also includes Hive field annotations for persistence.
class User extends Equatable {
  /// The unique identifier for the user.
  @HiveField(0)
  final String id;

  /// The first name of the user.
  @HiveField(1)
  final String firstName;

  /// The last name of the user.
  @HiveField(2)
  final String lastName;

  /// The date of birth of the user.
  @HiveField(3)
  final DateTime dateOfBirth;

  /// A list of addresses associated with the user.
  ///
  /// Currently, this is a list of strings. Consider creating an `Address` entity
  /// for more structured address data if needed in the future.
  @HiveField(4)
  final List<String> addresses;

  /// Creates a [User] instance.
  ///
  /// All parameters are required.
  const User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.dateOfBirth,
    required this.addresses,
  });

  @override
  List<Object?> get props => [id, firstName, lastName, dateOfBirth, addresses];
}
