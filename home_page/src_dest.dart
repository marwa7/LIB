import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:geocoder/geocoder.dart';
import 'dart:async';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'dart:io';

import 'package:ourwonderfullapp/home_page/track_indiv.dart';

GoogleMapsPlaces _places =
GoogleMapsPlaces(apiKey: "AIzaSyCN5CJGsvRnutmMNhpN8toEprd3fn7cIBg");

class s_d1 extends StatefulWidget {
  @override
  source_destinations createState() => source_destinations();
}

class source_destinations extends State<s_d1> {
  GoogleMapController _controller;

  // source_destination(GoogleMapController controller) {this._controller = controller ;}
  static final CameraPosition _initialLocation = CameraPosition(
    target: LatLng(36.752887, 3.042048),
    zoom: 14.4746,
  );
  String searchADR;

  static LatLng destination;

  TextEditingController LocationController = TextEditingController();

  TextEditingController DestinationController = TextEditingController();
  Set<Marker> _markers = {};

  BitmapDescriptor sourceIcon;
  BitmapDescriptor destinationIcon;

  @override
  void initState() {
    super.initState();
    _GetUserLocation() ;
    setSourceAndDestinationIcons();
  }

  void setSourceAndDestinationIcons() async {
    sourceIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), 'assets/user_icon.png');
    destinationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5),
        'assets/destination.png');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        body: Stack(children: <Widget>[
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _initialLocation,
            markers: _markers,
            onMapCreated: (GoogleMapController controller) {
              _controller = controller;
            },
          ),
          Positioned (
            bottom : 180.0 ,
            right : 15.0 ,
            left: 20.0 ,
            child : Container (
              height: 50.0,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0) ,
                color: Colors.white,
                boxShadow : [BoxShadow(color: Colors.black12 , offset: Offset(1.0,5.0),blurRadius: 10 , spreadRadius: 3) ],
              ),
              child: TextField(
                  controller: LocationController,
                  cursorColor: Colors.black,
                  decoration : InputDecoration
                    ( prefixIcon:Icon(Icons.my_location,color:Color(0xffe8652d)),
                    hintText: "Votre position" ,
                    border: InputBorder.none ,
                  )),
            ),
          ),
          Positioned (
            bottom :120.0 ,
            right : 15.0 ,
            left: 20.0 ,
            child : Container (
              height: 50.0,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0) ,
                color: Colors.white ,
                boxShadow : [BoxShadow(color: Colors.black12 , offset: Offset(1.0,5.0),blurRadius: 10 , spreadRadius: 3) ],
              ),
              child: TextField(
                controller: DestinationController,
                cursorColor: Colors.black,
                onTap: () async{ Prediction p = await PlacesAutocomplete.show(
                    context: context, apiKey: "AIzaSyCN5CJGsvRnutmMNhpN8toEprd3fn7cIBg" ,  mode: Mode.overlay );
                displayPrediction(p);} ,
                decoration : InputDecoration (
                  prefixIcon: Icon(Icons.location_on,color: Colors.teal),
                  hintText: "Votre destination" ,
                  border: InputBorder.none ,
                ),

              ),
            ),
          ),
          Positioned(
              top:50,
              right: 20,
              left: 20,
              child:Container(
                height:70,
                width: 100,
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Text(
                    "Pour commencer votre trajet choisissez une destination ",textAlign: TextAlign.center,
                    style:TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff739d84)

                    )),
              )
          ),
          Positioned(
            bottom :95,
            right:1,
            child: GestureDetector(
              onTap:(){Navigator.of(context).push(MaterialPageRoute(builder: (context)=> track_indv (_controller , destination)));} ,
              child:
              Container(
                height:60,
                width:60,
                padding: EdgeInsets.all(10),
                decoration: ShapeDecoration(
                  shape: CircleBorder(),
                  gradient: LinearGradient(
                      colors: [Colors.teal,Colors.teal[200]],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight),),
                child: Icon(Icons.arrow_forward,
                  size: 30,
                  color: Colors.white,

                ),

              ),),),
          /* Positioned(  top : 200.0 ,
              right : 10.0 ,
              left: 10.0 ,
              height: 50,
              width: 50,
              child: RaisedButton( color : Colors.white ,onPressed: (){Navigator.of(context).push(MaterialPageRoute(builder: (context)=> track (_controller , destination))); }, child: Text("commencer"),) ),*/

        ])



    );
  }

  Future<LatLng> _GetUserLocation() async {
    var currentLocation = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    LatLng crlocation =
    LatLng(currentLocation.latitude, currentLocation.longitude);
    List<Placemark> _placemark = await Geolocator().placemarkFromCoordinates(
        currentLocation.latitude, currentLocation.longitude);
    LocationController.text = _placemark[0].name;
    setState(() {
      //my location marker
      final marker = Marker(
        markerId: MarkerId("curr_loc"),
        position: LatLng(currentLocation.latitude, currentLocation.longitude),
        infoWindow: InfoWindow(title: 'q'),
        icon: sourceIcon,
      );
      _markers.add(marker);
      _controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(currentLocation.latitude, currentLocation.longitude),
            zoom: 11.0,
          ),
        ),
      );
    });
    return crlocation;
  }

  chercher() {
    Geolocator().placemarkFromAddress(searchADR).then((result) {
      _controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(
                result[0].position.latitude, result[0].position.longitude),
            zoom: 11.0,
          ),
        ),
      );
      destination =
          LatLng(result[0].position.latitude, result[0].position.longitude);
      print(
          "dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd");
      print(destination.longitude);
      print(destination.latitude);
      setState(() {
        final marker = Marker(
          markerId: MarkerId("destination"),
          position:
          LatLng(result[0].position.latitude, result[0].position.longitude),
          infoWindow: InfoWindow(title: 'asma'),
        );
        _markers.add(marker);
      });
    });
    print(destination.longitude);
    print(destination.latitude);
  }

  Future<Null> displayPrediction(Prediction p) async {
    if (p != null) {
      // List <Place> _places ;
      PlacesDetailsResponse detail =
      await _places.getDetailsByPlaceId(p.placeId);

      var placeId = p.placeId;
      double lat = detail.result.geometry.location.lat;
      double lng = detail.result.geometry.location.lng;

      var address = await Geocoder.local.findAddressesFromQuery(p.description);
      print(lat);
      print(lng);
      _controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(detail.result.geometry.location.lat,
                detail.result.geometry.location.lng),
            zoom: 18.0,
          ),
        ),
      );
      destination = LatLng(detail.result.geometry.location.lat,
          detail.result.geometry.location.lng);
      Placemark nation;
      // =  LatLng ( detail.result.geometry.location.lat,  detail.result.geometry.location.lng);

      DestinationController.text = detail.result.name;
      setState(() {
        //marker ta3 serach
        final marker = Marker(
          icon: destinationIcon,
          markerId: MarkerId("destination"),
          position: LatLng(detail.result.geometry.location.lat,
              detail.result.geometry.location.lng),
          infoWindow: InfoWindow(title: 'Your '),
        );
        _markers.add(marker);
      });
    }
  }
}
