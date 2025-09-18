import 'package:equatable/equatable.dart';

/// Represents an address entity in the domain layer.
///
/// This class is a pure business object and uses [Equatable] for value comparison.
class Address extends Equatable {
  /// The address data, typically a street address or similar information.
  final String addressData;

  /// Creates an [Address] instance.
  ///
  /// Requires [addressData].
  const Address({required this.addressData});

  @override
  List<Object?> get props => [addressData];
}
