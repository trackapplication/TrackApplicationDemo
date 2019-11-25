// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'getDevices.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetDevices _$GetDevicesFromJson(Map<String, dynamic> json) {
  return GetDevices()
    ..items = (json['items'] as List)
        ?.map((e) =>
            e == null ? null : GetDevice.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$GetDevicesToJson(GetDevices instance) =>
    <String, dynamic>{'items': instance.items};
