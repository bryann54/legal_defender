// lib/features/auth/data/models/user_model.dart

import 'package:json_annotation/json_annotation.dart';
import 'package:legal_defender/features/auth/domain/entities/user_entity.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  // Use user_id as fallback for id, and allow nulls to prevent crashes
  @JsonKey(name: 'id')
  final String? id;
  @JsonKey(name: 'user_id')
  final String? userId;

  final String? email;
  final String? username;

  @JsonKey(name: 'phone_number')
  final String? phoneNumber;

  final String? state;

  @JsonKey(name: 'profile_type')
  final String? profileType;

  final String? language;

  final String? access;
  final String? refresh;

  const UserModel({
    this.id,
    this.userId,
    this.email,
    this.username,
    this.phoneNumber,
    this.state,
    this.profileType,
    this.language,
    this.access,
    this.refresh,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  UserEntity toEntity() {
    return UserEntity(
      id: id ?? userId ?? '', // Use whichever ID is available
      email: email ?? '',
      username: username ?? 'User',
      phoneNumber: phoneNumber ?? '',
      state: state ?? '',
      profileType: profileType ?? '',
      language: language ?? 'en',
    );
  }
}
