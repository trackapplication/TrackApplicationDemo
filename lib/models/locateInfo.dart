class LocateInfo {
    List<Items> items;
  
    LocateInfo({this.items});
  
    LocateInfo.fromJson(Map<String, dynamic> json) {
      if (json['items'] != null) {
        items = new List<Items>();
        json['items'].forEach((v) {
          items.add(new Items.fromJson(v));
        });
      }
    }
  
    Map<String, dynamic> toJson() {
      final Map<String, dynamic> data = new Map<String, dynamic>();
      if (this.items != null) {
        data['items'] = this.items.map((v) => v.toJson()).toList();
      }
      return data;
    }
  }
  
  class Items {
    String sId;
    LastLog lastLog;
    bool online;
    String deviceId;
    String createdAt;
    String updatedAt;
    double lat;
    double lon;
    String name;
  
    Items(
        {this.sId,
        this.lastLog,
        this.online,
        this.deviceId,
        this.createdAt,
        this.updatedAt,
        this.lat,
        this.lon,
        this.name});
  
    Items.fromJson(Map<String, dynamic> json) {
      sId = json['_id'];
      lastLog =
          json['lastLog'] != null ? new LastLog.fromJson(json['lastLog']) : null;
      online = json['online'];
      deviceId = json['deviceId'];
      createdAt = json['createdAt'];
      updatedAt = json['updatedAt'];
      lat = json['lat'];
      lon = json['lon'];
      name = json['name'];
    }
  
    Map<String, dynamic> toJson() {
      final Map<String, dynamic> data = new Map<String, dynamic>();
      data['_id'] = this.sId;
      if (this.lastLog != null) {
        data['lastLog'] = this.lastLog.toJson();
      }
      data['online'] = this.online;
      data['deviceId'] = this.deviceId;
      data['createdAt'] = this.createdAt;
      data['updatedAt'] = this.updatedAt;
      data['lat'] = this.lat;
      data['lon'] = this.lon;
      data['name'] = this.name;
      return data;
    }
  }
  
  class LastLog {
    String protocol;
    String imei;
    String ipAddress;
    GpsData gpsData;
    String rawPayload;
    String timestamp;
  
    LastLog(
        {this.protocol,
        this.imei,
        this.ipAddress,
        this.gpsData,
        this.rawPayload,
        this.timestamp});
  
    LastLog.fromJson(Map<String, dynamic> json) {
      protocol = json['protocol'];
      imei = json['imei'];
      ipAddress = json['ipAddress'];
      gpsData =
          json['gpsData'] != null ? new GpsData.fromJson(json['gpsData']) : null;
      rawPayload = json['rawPayload'];
      timestamp = json['timestamp'];
    }
  
    Map<String, dynamic> toJson() {
      final Map<String, dynamic> data = new Map<String, dynamic>();
      data['protocol'] = this.protocol;
      data['imei'] = this.imei;
      data['ipAddress'] = this.ipAddress;
      if (this.gpsData != null) {
        data['gpsData'] = this.gpsData.toJson();
      }
      data['rawPayload'] = this.rawPayload;
      data['timestamp'] = this.timestamp;
      return data;
    }
  }
  
  class GpsData {
    double lon;
    double lat;
  
    GpsData({this.lon, this.lat});
  
    GpsData.fromJson(Map<String, dynamic> json) {
      lon = json['lon'];
      lat = json['lat'];
    }
  
    Map<String, dynamic> toJson() {
      final Map<String, dynamic> data = new Map<String, dynamic>();
      data['lon'] = this.lon;
      data['lat'] = this.lat;
      return data;
    }
  }
  