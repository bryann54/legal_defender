// lib/features/account/data/models/user_profile_model.dart

import 'package:json_annotation/json_annotation.dart';
import 'package:legal_defender/features/account/domain/entities/user_profile.dart';

part 'user_profile_model.g.dart';

@JsonSerializable()
class UserProfileModel extends UserProfile {
  @JsonKey(name: 'phone_number')
  final String? phoneNumber;

  const UserProfileModel({
    required super.id, 
    required super.email,
    required super.username,
    this.phoneNumber,
    super.state,
  }) : super(
          phone: phoneNumber,
        );

  factory UserProfileModel.fromJson(Map<String, dynamic> json) =>
      _$UserProfileModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserProfileModelToJson(this);
}
