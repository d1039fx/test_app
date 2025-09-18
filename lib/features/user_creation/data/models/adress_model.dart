import '../../domain/entities/address.dart';

// El AddressModel extiende la entidad Address del dominio.
// Representa la estructura de datos tal como se recibe o envía
// a la fuente de datos (API, base de datos local, etc.).

/// Represents the data model for an address, extending the [Address] entity.
///
/// This model is used for interacting with data sources (e.g., JSON).
class AddressModel extends Address {
  /// Creates an [AddressModel] instance.
  ///
  /// Requires [addressData].
  const AddressModel({
    required super.addressData,
  });

  /// Creates an [AddressModel] from a JSON map.
  ///
  /// The [json] map should contain the key 'addressData'.
  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      addressData: json['addressData'],
    );
  }

  /// Converts the [AddressModel] to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'addressData': addressData,
    };
  }

  /// Converts this data model [AddressModel] to a domain entity [Address].
  Address toEntity() {
    return Address(addressData: addressData);
  }
}
