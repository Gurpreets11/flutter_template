import 'package:flutter/foundation.dart';

/// The authenticated user, as understood by the domain/presentation
/// layers. Deliberately minimal — real apps built from this template
/// will extend this with whatever fields their backend actually
/// returns (organization, role, avatar, etc.).
@immutable
class AuthUser {
  /// Creates an [AuthUser].
  const AuthUser({
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
      (other is AuthUser &&
          id == other.id &&
          name == other.name &&
          email == other.email);

  @override
  int get hashCode => Object.hash(id, name, email);
}
