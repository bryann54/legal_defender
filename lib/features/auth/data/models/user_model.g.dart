// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      id: json['id'] as String?,
      userId: json['user_id'] as String?,
      email: json['email'] as String?,
      username: json['username'] as String?,
      phoneNumber: json['phone_number'] as String?,
      state: json['state'] as String?,
      profileType: json['profile_type'] as String?,
      language: json['language'] as String?,
      access: json['access'] as String?,
      refresh: json['refresh'] as String?,
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'email': instance.email,
      'username': instance.username,
      'phone_number': instance.phoneNumber,
      'state': instance.state,
      'profile_type': instance.profileType,
      'language': instance.language,
      'access': instance.access,
      'refresh': instance.refresh,
    };
