import 'package:json_annotation/json_annotation.dart';

part 'getDevice.g.dart';

@JsonSerializable()
class GetDevice {
    GetDevice();

    Map<String,dynamic> lastLog;
    String online;
    String deviceId;
    String createdAt;
    String updatedAt;
    String name;
    
    factory GetDevice.fromJson(Map<String,dynamic> json) => _$GetDeviceFromJson(json);
    Map<String, dynamic> toJson() => _$GetDeviceToJson(this);
}
