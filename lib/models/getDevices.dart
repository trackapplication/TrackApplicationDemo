import 'package:json_annotation/json_annotation.dart';
import "getDevice.dart";
part 'getDevices.g.dart';

@JsonSerializable()
class GetDevices {
    GetDevices();

    List<GetDevice> items;
    
    factory GetDevices.fromJson(Map<String,dynamic> json) => _$GetDevicesFromJson(json);
    Map<String, dynamic> toJson() => _$GetDevicesToJson(this);
}
