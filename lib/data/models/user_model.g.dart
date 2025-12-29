// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserModelImpl _$$UserModelImplFromJson(Map<String, dynamic> json) =>
    _$UserModelImpl(
      uid: json['uid'] as String,
      displayName: json['displayName'] as String,
      email: json['email'] as String,
      photoUrl: json['photoUrl'] as String?,
      fitnessGoals:
          FitnessGoals.fromJson(json['fitnessGoals'] as Map<String, dynamic>),
      activeGymProfileId: json['activeGymProfileId'] as String,
      onboardingComplete: json['onboardingComplete'] as bool? ?? false,
      fcmToken: json['fcmToken'] as String?,
      weightUnit: json['weightUnit'] as String? ?? 'lbs',
      createdAt: const TimestampConverter().fromJson(json['createdAt']),
      lastActiveAt: const TimestampConverter().fromJson(json['lastActiveAt']),
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'displayName': instance.displayName,
      'email': instance.email,
      'photoUrl': instance.photoUrl,
      'fitnessGoals': instance.fitnessGoals,
      'activeGymProfileId': instance.activeGymProfileId,
      'onboardingComplete': instance.onboardingComplete,
      'fcmToken': instance.fcmToken,
      'weightUnit': instance.weightUnit,
      'createdAt': const TimestampConverter().toJson(instance.createdAt),
      'lastActiveAt': const TimestampConverter().toJson(instance.lastActiveAt),
    };
