import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:trackapp/blocs/mapPageBloc/containerBloc.dart';
import 'package:trackapp/models/deviceModel.dart';
import 'package:trackapp/services/getDevice.dart';

class LocatePage extends StatefulWidget {
  @override
  _LocatePageState createState() => _LocatePageState();
}

class _LocatePageState extends State<LocatePage> {
  Completer<GoogleMapController> _controller = Completer();
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(28.6139, 77.2090),
    zoom: 2.0,
  );

  static final CameraPosition _kLake = CameraPosition(
      bearing: 0.0, target: LatLng(365.0, 0.00), tilt: 0.0, zoom: 12.0);

  bool entered = false;
  String title = 'Welcome';

  Color color = Colors.white;
  bool surprise = true;
  double mapHeight = 806.8571428571429;
  ContainerBloc containerBloc = ContainerBloc();
  @override
  Widget build(BuildContext context) {
    BorderRadiusGeometry radius = BorderRadius.only(
      topLeft: Radius.circular(20.0),
      topRight: Radius.circular(20.0),
    );
    return Stack(
      children: <Widget>[
        StreamBuilder<double>(
            initialData: mapHeight,
            stream: containerBloc.op,
            builder: (context, snapshot) {
              return Stack(
                children: <Widget>[
                  Container(
                    height: snapshot.data,
                    child: StreamBuilder<Device>(
                        stream: fetchDevice().asStream(),
                        builder: (context, snapshot) {
                          List<Item> list = List();
                          Set<Marker> deviceMarkers = Set<Marker>();
                          if (snapshot.hasData) {
                            list.addAll(snapshot.data.items);
                            list.forEach((item) {
                              Item i = item ?? null;
                              LastLog ll = i == null ? null : i.lastLog;
                              GpsData gd = ll == null ? null : ll.gpsData;
                              double lat = gd == null ? null : gd.lat;
                              double lng = gd == null ? null : gd.lon;
                              if (lat != null && lng != null) {
                                Marker marker = Marker(
                                  markerId: MarkerId(item.deviceId.toString()),
                                  position: LatLng(lat, lng),
                                  infoWindow: InfoWindow(
                                    title: item.deviceId,
                                  ),
                                  onTap: () {
                                    containerBloc.b_ip.add(true);
                                  },
                                );
                                deviceMarkers.add(marker);
                              }
                            });
                          }
                          print(deviceMarkers.length.toString() + " is len");
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
                              markers: deviceMarkers
                              //Set<Marker>.of(markers.values)
                              );
                        }),
                  ),
                ],
              );
            }),
        StreamBuilder<bool>(
            stream: containerBloc.b_op,
            initialData: false,
            builder: (context, s) {
              if (s.data) {
                return SlidingUpPanel(
                  onPanelOpened: () {
                    containerBloc.ip.add(mapHeight / 3);
                  },
                  onPanelClosed: () {
                    containerBloc.ip.add(mapHeight * 3);
                  },
                  panel: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(24.0),
                            topRight: Radius.circular(24.0)),
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 20.0,
                            color: Colors.grey,
                          ),
                        ]),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Hero(
                                  tag: "iconHero",
                                  child: Icon(
                                    Icons.phonelink_lock,
                                    size: 50,
                                  ),
                                ),
                              ),
                              Hero(
                                tag: "colHero",
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, right: 8.0),
                                      child: Text(
                                        "Redmi Note 5 Pro",
                                        style: TextStyle(
                                            fontSize: 22, color: Colors.black),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Text(
                                        "Disarmed • Static • Wifi",
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.black38),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                          Container(
                            height: 20,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 0.0, horizontal: 14.0),
                            child: Container(
                              height: 50,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
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
                                          "Device is connected to wifi",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black54),
                                        ))
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 32.0),
                            child: Divider(
                              color: Colors.black38,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 0.0, horizontal: 14.0),
                            child: Container(
                              height: 50,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
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
                                          "Last signal time : 10:00 am",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black54),
                                        ))
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 32.0),
                            child: Divider(
                              color: Colors.black38,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 0.0, horizontal: 14.0),
                            child: Container(
                              height: 50,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
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
                                          "Device is locked",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black54),
                                        ))
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 32.0),
                            child: Divider(
                              color: Colors.black38,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 0.0, horizontal: 14.0),
                            child: Container(
                              height: 50,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
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
                                          "Last Location: 20.5937° N, 78.9629° E",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black54),
                                        ))
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 32.0),
                            child: Divider(
                              color: Colors.black38,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 0.0, horizontal: 14.0),
                            child: Container(
                              height: 50,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
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
                                          "Last seen at 10:00 am",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black54),
                                        ))
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 32.0),
                            child: Divider(
                              color: Colors.black38,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 0.0, horizontal: 14.0),
                            child: Container(
                              height: 50,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
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
                                          "Battery is charging • 100%",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.black54),
                                        ))
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  renderPanelSheet: false,
                  collapsed: Container(
                    decoration:
                        BoxDecoration(color: color, borderRadius: radius),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            flex: 1,
                            child: Container(
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle, color: Colors.white),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Hero(
                                  tag: "iconHero",
                                  child: Icon(
                                    Icons.phonelink_lock,
                                    size: 50,
                                  ),
                                ),
                              ),
                            )),
                        Expanded(
                            flex: 4,
                            child: Container(
                              child: Hero(
                                tag: "colHero",
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, right: 8.0),
                                      child: Text(
                                        "Redmi Note 5 Pro",
                                        style: TextStyle(
                                            fontSize: 22, color: Colors.black),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Text(
                                        "Disarmed • Static • Wifi",
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Colors.black38),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )),
                      ],
                    ),
                  ),
                  borderRadius: radius,
                );
              } else {
                return Container();
              }
            })
      ],
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
