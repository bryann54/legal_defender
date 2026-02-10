// lib/features/account/domain/entities/user_profile.dart
import 'package:equatable/equatable.dart';

class UserProfile extends Equatable {
  final int id;
  final String email;
  final String username;
  final String? phone;
  final String? state;

  const UserProfile({
    required this.id,
    required this.email,
    required this.username,
    this.phone,
    this.state,
  });

  @override
  List<Object?> get props => [id, email, username, phone, state];
}
