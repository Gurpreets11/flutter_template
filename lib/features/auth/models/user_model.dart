import 'package:flutter/foundation.dart';

/// The authenticated user, used by the authentication feature. Deliberately minimal — real apps built from this template
/// will extend this with whatever fields their backend actually
/// returns (organization, role, avatar, etc.).
@immutable
class UserModel {
  /// Creates a [UserModel].
  const UserModel({
    required this.id,
    required this.name,
    required this.email,
  });

  /// The user's unique identifier.
  final String id;

  /// The user's display name.
  final String name;

  /// The user's email address.
  final String email;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserModel &&
          id == other.id &&
          name == other.name &&
          email == other.email);

  @override
  int get hashCode => Object.hash(id, name, email);
}
