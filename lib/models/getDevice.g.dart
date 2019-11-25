// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'getDevice.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetDevice _$GetDeviceFromJson(Map<String, dynamic> json) {
  return GetDevice()
    ..lastLog = json['lastLog'] as Map<String, dynamic>
    ..online = json['online'] as String
    ..deviceId = json['deviceId'] as String
    ..createdAt = json['createdAt'] as String
    ..updatedAt = json['updatedAt'] as String
    ..name = json['name'] as String;
}

Map<String, dynamic> _$GetDeviceToJson(GetDevice instance) => <String, dynamic>{
      'lastLog': instance.lastLog,
      'online': instance.online,
      'deviceId': instance.deviceId,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
      'name': instance.name
    };
