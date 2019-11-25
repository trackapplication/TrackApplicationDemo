class Device {
  List<Item> items;

  Device({
    this.items,
  });

  factory Device.fromJson(Map<String, dynamic> json) => Device(
        items: List<Item>.from(json["items"].map((x) => Item.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "items": List<dynamic>.from(items.map((x) => x.toJson())),
      };
}

class Item {
  String id;
  LastLog lastLog;
  bool online;
  String deviceId;
  DateTime createdAt;
  DateTime updatedAt;
  String name;

  Item({
    this.id,
    this.lastLog,
    this.online,
    this.deviceId,
    this.createdAt,
    this.updatedAt,
    this.name,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
        id: json["_id"],
        lastLog: LastLog.fromJson(json["lastLog"]),
        online: json["online"] == null ? null : json["online"],
        deviceId: json["deviceId"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "lastLog": lastLog.toJson(),
        "online": online == null ? null : online,
        "deviceId": deviceId,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "name": name,
      };
}

class LastLog {
  String protocol;
  String ipAddress;
  String wifiString;
  WifiData wifiData;
  String lbsString;
  LbsData lbsData;
  String rawPayload;
  dynamic imei;
  GpsData gpsData;
  DateTime timestamp;

  LastLog({
    this.protocol,
    this.ipAddress,
    this.wifiString,
    this.wifiData,
    this.lbsString,
    this.lbsData,
    this.rawPayload,
    this.imei,
    this.gpsData,
    this.timestamp,
  });

  factory LastLog.fromJson(Map<String, dynamic> json) => LastLog(
        protocol: json["protocol"] == null ? null : json["protocol"],
        ipAddress: json["ipAddress"] == null ? null : json["ipAddress"],
        wifiString: json["wifiString"] == null ? null : json["wifiString"],
        wifiData: json["wifiData"] == null
            ? null
            : WifiData.fromJson(json["wifiData"]),
        lbsString: json["lbsString"] == null ? null : json["lbsString"],
        lbsData:
            json["lbsData"] == null ? null : LbsData.fromJson(json["lbsData"]),
        rawPayload: json["rawPayload"] == null ? null : json["rawPayload"],
        imei: json["imei"],
        gpsData:
            json["gpsData"] == null ? null : GpsData.fromJson(json["gpsData"]),
        timestamp: json["timestamp"] == null
            ? null
            : DateTime.parse(json["timestamp"]),
      );

  Map<String, dynamic> toJson() => {
        "protocol": protocol == null ? null : protocol,
        "ipAddress": ipAddress == null ? null : ipAddress,
        "wifiString": wifiString == null ? null : wifiString,
        "wifiData": wifiData == null ? null : wifiData.toJson(),
        "lbsString": lbsString == null ? null : lbsString,
        "lbsData": lbsData == null ? null : lbsData.toJson(),
        "rawPayload": rawPayload == null ? null : rawPayload,
        "imei": imei,
        "gpsData": gpsData == null ? null : gpsData.toJson(),
        "timestamp": timestamp == null ? null : timestamp.toIso8601String(),
      };
}

class GpsData {
  double lon;
  double lat;

  GpsData({
    this.lon,
    this.lat,
  });

  factory GpsData.fromJson(Map<String, dynamic> json) => GpsData(
        lon: json["lon"].toDouble(),
        lat: json["lat"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "lon": lon,
        "lat": lat,
      };
}

class LbsData {
  String mobileNetworkCode;
  String mobileCountryCode;
  List<CellTower> cellTowers;

  LbsData({
    this.mobileNetworkCode,
    this.mobileCountryCode,
    this.cellTowers,
  });

  factory LbsData.fromJson(Map<String, dynamic> json) => LbsData(
        mobileNetworkCode: json["mobileNetworkCode"],
        mobileCountryCode: json["mobileCountryCode"],
        cellTowers: List<CellTower>.from(
            json["cellTowers"].map((x) => CellTower.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "mobileNetworkCode": mobileNetworkCode,
        "mobileCountryCode": mobileCountryCode,
        "cellTowers": List<dynamic>.from(cellTowers.map((x) => x.toJson())),
      };
}

class CellTower {
  String locationAreaCode;
  String cellId;

  CellTower({
    this.locationAreaCode,
    this.cellId,
  });

  factory CellTower.fromJson(Map<String, dynamic> json) => CellTower(
        locationAreaCode: json["locationAreaCode"],
        cellId: json["cellId"],
      );

  Map<String, dynamic> toJson() => {
        "locationAreaCode": locationAreaCode,
        "cellId": cellId,
      };
}

class WifiData {
  List<WifiAccessPoint> wifiAccessPoints;

  WifiData({
    this.wifiAccessPoints,
  });

  factory WifiData.fromJson(Map<String, dynamic> json) => WifiData(
        wifiAccessPoints: List<WifiAccessPoint>.from(
            json["wifiAccessPoints"].map((x) => WifiAccessPoint.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "wifiAccessPoints":
            List<dynamic>.from(wifiAccessPoints.map((x) => x.toJson())),
      };
}

class WifiAccessPoint {
  String macAddress;

  WifiAccessPoint({
    this.macAddress,
  });

  factory WifiAccessPoint.fromJson(Map<String, dynamic> json) =>
      WifiAccessPoint(
        macAddress: json["macAddress"],
      );

  Map<String, dynamic> toJson() => {
        "macAddress": macAddress,
      };
}
