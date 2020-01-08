import 'dart:async';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:trackapp/blocs/mapPageBloc/containerBloc.dart';
import 'package:trackapp/main.dart';
import 'package:trackapp/models/deviceModel.dart';
import 'package:trackapp/services/getDevice.dart';
import 'package:intl/intl.dart';

class LocatePage extends StatefulWidget {
  @override
  _LocatePageState createState() => _LocatePageState();
}

class _LocatePageState extends State<LocatePage> {
  Completer<GoogleMapController> _controller = Completer();
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(28.6139, 77.2090),
    zoom: 10.0,
  );

  bool entered = false;
  String title = 'Welcome';
  int count = 0;

  Item it;

  Color color = Colors.white;
  bool surprise = true;
  double mapHeight = 806.8571428571429;
  ContainerBloc containerBloc = ContainerBloc();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: <Widget>[
          Expanded(

            child: Container(
              height: mapHeight / 1.5,
              child: StreamBuilder<Device>(
                  stream: fetchDevice().asStream(),
                  builder: (context, snapshot) {
                    List<Item> list = List();
                    Set<Marker> deviceMarkers = Set<Marker>();
                    if (snapshot.hasData) {
                      list.addAll(snapshot.data.items);
                      list.forEach((item) {
                        count = count + 1;
                        if (item.deviceId == radioDeviceSelector) {
                          print(item.toJson());
                        }
                        Item i = item ?? null;

                        print(i.name);

                        LastLog ll = i == null ? null : i.lastLog;
                        GpsData gd = ll == null ? null : ll.gpsData;
                        double lat = gd == null ? null : gd.lat;
                        double lng = gd == null ? null : gd.lon;

                        if (lat != null &&
                            lng != null &&
                            radioDeviceSelector == item.deviceId &&
                            radioDeviceSelector != '') {
                          it = item;
                          print(it.name);
                          containerBloc.b_ip.add(true);
                          goToDesiredLocation(LatLng(lat, lng));
                          Marker marker = Marker(
                            markerId: MarkerId(item.deviceId.toString()),
                            position: LatLng(lat, lng),
                            infoWindow: InfoWindow(
                              title: item.deviceId,
                            ),
                            onTap: () {
                              it = item;
                              print('huoooooo');
                              print(it.name);
                              //print(item.toJson());
                              containerBloc.b_ip.add(true);
                            },
                          );
                          deviceMarkers.add(marker);
                        }
                      });
                    }

                    return GoogleMap(
                        mapType: MapType.normal,
                        myLocationEnabled: true,
                        onTap: (omg) {
                          containerBloc.b_ip.add(false);
                        },
                        myLocationButtonEnabled: true,
                        initialCameraPosition: _kGooglePlex,
                        onMapCreated: (GoogleMapController controller) {
                          _controller.complete(controller);
                        },
                        markers: deviceMarkers,
                        //Set<Marker>.of(markers.values)
                        );
                  }),
            ),
          ),
          StreamBuilder<bool>(
              stream: containerBloc.b_op,
              initialData: false,
              builder: (context, s) {
                double battPercent;
                print("whadddupppp");
                //print(s);
                if (s.data && it != null) {
                  try{
                    String rawBatt = it.lastLog.rawPayload.split(".")[0];
                  print(rawBatt);
                  rawBatt = rawBatt.split(",")[0];
                  print(rawBatt);
                  String last3 = rawBatt.substring(rawBatt.length - 3);
                  print(last3);
                  int hexa = int.parse(last3, radix: 16);
                  print(hexa);
                  
                  battPercent = hexa / 10;
                  print(battPercent);
                  }catch(e){
                    print("error");
                  }finally{
                  //print(it.lastLog.wifiString);
                  //String wifiStat = it.lastLog.wifiString.split(" ")[0];
                  //wifiStat = wifiStat ?? "Disarmed • Static • Wifi";
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 0.0, horizontal: 14.0),
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                          flex: 1,
                                          child: Icon(
                                            Icons.signal_wifi_4_bar,
                                            color: Colors.green,
                                          )),
                                      Expanded(
                                          flex: 3,
                                          child: Text(
                                            it.lastLog.wifiString == null
                                                ? "Device is not connected to wifi"
                                                : "Device is connected to wifi",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black54),
                                          ))
                                    ],
                                  ),
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 0.0, horizontal: 14.0),
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                          flex: 1,
                                          child: Icon(
                                            Icons.network_check,
                                            color: Colors.green,
                                          )),
                                      Expanded(
                                          flex: 3,
                                          child: Text(
                                            it.updatedAt.toString() == null
                                                ? ""
                                                : "Last signal at:  " +
                                                    DateFormat(
                                                            'yyyy-MM-dd  kk:mm')
                                                        .format(
                                                            it.updatedAt),
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black54),
                                          ))
                                    ],
                                  ),
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 0.0, horizontal: 14.0),
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                          flex: 1,
                                          child: Icon(
                                            Icons.lock,
                                            color: Colors.green,
                                          )),
                                      Expanded(
                                          flex: 3,
                                          child: Text(
                                            it.online == null
                                                ? ""
                                                : it.online == false
                                                    ? "Device is not online"
                                                    : "Device is online",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black54),
                                          ))
                                    ],
                                  ),
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 0.0, horizontal: 14.0),
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                          flex: 1,
                                          child: Icon(
                                            Icons.location_on,
                                            color: Colors.green,
                                          )),
                                      Expanded(
                                          flex: 3,
                                          child: Text(
                                            // //"Last Location: 20.5937° N, 78.9629° E"
                                            it.lastLog.gpsData.lat
                                                        .toString() ==
                                                    null
                                                ? ""
                                                : it.lastLog.gpsData.lon
                                                            .toString() ==
                                                        null
                                                    ? ""
                                                    : "Last Location: " +
                                                        it.lastLog.gpsData
                                                            .lat
                                                            .toStringAsPrecision(
                                                                3) +
                                                        "° N, " +
                                                        it.lastLog.gpsData
                                                            .lon
                                                            .toStringAsPrecision(
                                                                3) +
                                                        "° S",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black54),
                                          ))
                                    ],
                                  ),
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 0.0, horizontal: 14.0),
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                          flex: 1,
                                          child: Icon(
                                            Icons.location_searching,
                                            color: Colors.green,
                                          )),
                                      Expanded(
                                          flex: 3,
                                          child: Text(
                                            it.updatedAt.toString() == null
                                                ? ""
                                                : "Last seen at:  " +
                                                    DateFormat(
                                                            'yyyy-MM-dd  kk:mm')
                                                        .format(
                                                            it.updatedAt),
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black54),
                                          ))
                                    ],
                                  ),
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 0.0, horizontal: 14.0),
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Row(
                                    children: <Widget>[
                                      Expanded(
                                          flex: 1,
                                          child: Icon(
                                            Icons.battery_charging_full,
                                            color: Colors.green,
                                          )),
                                      Expanded(
                                          flex: 3,
                                          child: Text(
                                            battPercent == null
                                                ? "API ERROR"
                                                : "Battery: ${battPercent.toStringAsPrecision(2)}%",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black54),
                                          ))
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }} else {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("No Device Selected"),
                    ),
                  );
                }
              })
        ],
      ),
    );
  }

  Future<void> goToDesiredLocation(LatLng latlng) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(target: latlng, zoom: 14)));
  }

  void bottomSheet() {
    Builder(
      builder: (context) {
        return SlidingUpPanel(
          panel: Center(
            child: Text('Panel'),
          ),
        );
      },
    );
  }
}
