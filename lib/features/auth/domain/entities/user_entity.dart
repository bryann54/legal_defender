// lib/features/auth/domain/entities/user_entity.dart

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

@immutable
class UserEntity extends Equatable {
  final String id;
  final String email;
  final String username;
  final String phoneNumber;
  final String state;
  final String profileType;
  final String language;

  const UserEntity({
    required this.id,
    required this.email,
    required this.username,
    required this.phoneNumber,
    required this.state,
    required this.profileType,
    required this.language,
  });

  @override
  List<Object?> get props => [
        id,
        email,
        username,
        phoneNumber,
        state,
        profileType,
        language,
      ];

  UserEntity copyWith({
    String? id,
    String? email,
    String? username,
    String? phoneNumber,
    String? state,
    String? profileType,
    String? language,
  }) {
    return UserEntity(
      id: id ?? this.id,
      email: email ?? this.email,
      username: username ?? this.username,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      state: state ?? this.state,
      profileType: profileType ?? this.profileType,
      language: language ?? this.language,
    );
  }
}
