// lib/features/auth/data/models/user_model.dart

import 'package:legal_defender/features/auth/domain/entities/user_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel extends Equatable {
  final String id;
  final String email;
  final String username;
  @JsonKey(name: 'phone_number')
  final String phoneNumber;
  final String state;
  @JsonKey(name: 'profile_type')
  final String profileType;
  final String language;

  const UserModel({
    required this.id,
    required this.email,
    required this.username,
    required this.phoneNumber,
    required this.state,
    required this.profileType,
    required this.language,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Handle user_id from response or id from nested user object
    final userId =
        (json['user_id']?.toString() ?? json['id']?.toString() ?? '0');

    return UserModel(
      id: userId,
      email: json['email'] as String? ?? '',
      username: json['username'] as String? ?? '',
      phoneNumber: json['phone_number'] as String? ?? '',
      state: json['state'] as String? ?? '',
      profileType: json['profile_type'] as String? ?? 'client',
      language: json['language'] as String? ?? 'en',
    );
  }

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      email: email,
      username: username,
      phoneNumber: phoneNumber,
      state: state,
      profileType: profileType,
      language: language,
    );
  }

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
}
