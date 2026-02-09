// lib/features/auth/data/models/user_model.dart

import 'package:legal_defender/features/auth/domain/entities/user_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel extends Equatable {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String? profileImageUrl;

  const UserModel({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.profileImageUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Handle different response structures from login and register
    final userData = json['user'] ?? json;

    return UserModel(
      id: _parseId(userData),
      email: _parseEmail(userData),
      firstName: _parseFirstName(userData),
      lastName: _parseLastName(userData),
      profileImageUrl: userData['profile_image_url'] as String? ??
          userData['profileImageUrl'] as String?,
    );
  }

  static String _parseId(Map<String, dynamic> userData) {
    return (userData['id']?.toString() ??
        userData['user_id']?.toString() ??
        '0');
  }

  static String _parseEmail(Map<String, dynamic> userData) {
    return userData['email'] as String? ?? '';
  }

  static String _parseFirstName(Map<String, dynamic> userData) {
    return userData['first_name'] as String? ??
        userData['firstName'] as String? ??
        userData['fullname'] as String? ??
        '';
  }

  static String _parseLastName(Map<String, dynamic> userData) {
    return userData['last_name'] as String? ??
        userData['lastName'] as String? ??
        '';
  }

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      email: email,
      firstName: firstName,
      lastName: lastName,
      profileImageUrl: profileImageUrl,
    );
  }

  @override
  List<Object?> get props => [id, email, firstName, lastName, profileImageUrl];
}
