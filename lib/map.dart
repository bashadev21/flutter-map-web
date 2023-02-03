import 'dart:math';

import 'package:flutter/material.dart';
import 'dart:html';
import 'dart:ui' as ui;
import 'package:google_maps/google_maps.dart';

class MapView extends StatefulWidget {
  final String id;
  final List locationList;
  const MapView({
    Key? key,
    required this.id,
    required this.locationList,
  }) : super(key: key);

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  @override
  Widget build(BuildContext context) {
    // setState(() {
    // widget.lat =widget.lat;
    // widget.lon=widget.lon;
    // });
    return getMap();
  }

  Widget getMap() {
    //A unique id to name the div element
    String htmlId = widget.id;
    //creates a webview in dart
    //ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(htmlId, (int viewId) {
      //class to create a div element

      final mapOptions = MapOptions()
        ..zoom = 11
        ..tilt = 90
        ..center = LatLng(double.parse(widget.locationList[0]['lat']!),
            double.parse(widget.locationList[0]['long']!));
      final elem = DivElement()
        ..id = htmlId
        ..style.width = "100%"
        ..style.height = "100%"
        ..style.border = "none";

      final map = GMap(
        elem,
        mapOptions,
      );
      //
      for (int i = 0; i < widget.locationList.length; i++) {
        final marker1 = Marker(MarkerOptions()
          ..position = LatLng(double.parse(widget.locationList[i]['lat']!),
              double.parse(widget.locationList[i]['long']!))
          ..map = map
          //..icon = Icons.point_of_sale
          ..title = widget.locationList[i]['name']!);
        String name = widget.locationList[i]['name'];
        String location = widget.locationList[i]['location'];
        String contact = widget.locationList[i]['contact_no'];
        String cont = content(name, location, contact);
        final infoWindow = InfoWindow(InfoWindowOptions()..content = cont);
        marker1.onClick.listen((event) {
          infoWindow.close();
          infoWindow.open(map, marker1);
        });
      }
      // var marker2=   Marker(MarkerOptions()
      //   ..position = LatLng(8.9557616, 47.7568832)
      //   ..map = map
      //   ..title = 'My position');
      // marker2.onClick.listen((event) => infoWindow.open(map, marker2));

      // Marker(MarkerOptions()
      //   ..position = LatLng(12.9557616, 74.7568832)
      //   ..map = map
      //   ..title = 'My position');
      return elem;
    });
    //creates a platform view for Flutter Web
    return HtmlElementView(
      onPlatformViewCreated: (id) {},
      viewType: htmlId,
    );
  }

  String content(name, location, contact) {
    return '<div id="content" style="color:#5A3613FF"><div id="siteNotice"></div><h1 id="firstHeading" class="firstHeading">$name</h1><div id="bodyContent"><p>$location<b>. $contact</b></div></div>';
  }
}
