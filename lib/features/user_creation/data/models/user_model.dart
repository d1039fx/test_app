import '../../domain/entities/user.dart';
import 'package:hive_ce/hive.dart';

// El modelo representa los datos como son recibidos/enviados a la fuente de datos.
// Incluye métodos para convertir a/desde JSON y a/desde la entidad de dominio.
part 'user_model.g.dart';

/// Represents the data model for a user, extending the [User] entity.
///
/// This model is used for interacting with data sources (e.g., Hive, JSON).
@HiveType(typeId: 0)
class UserModel extends User {
  /// Creates a [UserModel] instance.
  ///
  /// All parameters are required and correspond to the properties of the [User] entity.
  const UserModel({
    required super.id,
    required super.firstName,
    required super.lastName,
    required super.dateOfBirth,
    required super.addresses,
  });

  /// Creates a [UserModel] from a JSON map.
  ///
  /// The [json] map should contain keys 'id', 'firstName', 'lastName',
  /// 'dateOfBirth' (as an ISO 8601 string), and 'addresses'.
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      dateOfBirth: DateTime.parse(json['dateOfBirth']),
      addresses: json['addresses'],
    );
  }

  /// Converts the [UserModel] to a JSON map.
  ///
  /// The 'dateOfBirth' field is converted to an ISO 8601 string.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'dateOfBirth': dateOfBirth.toIso8601String(),
      'addresses': addresses
    };
  }

  /// Converts this data model [UserModel] to a domain entity [User].
  User toEntity() {
    return User(
      id: id,
      firstName: firstName,
      lastName: lastName,
      dateOfBirth: dateOfBirth,
      addresses: addresses,
    );
  }
}
