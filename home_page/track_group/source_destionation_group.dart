//import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ourwonderfullapp/classes/Groupe.dart';
import 'package:geolocator/geolocator.dart';
import 'commencer_lestrack_groupe.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import'package:google_maps_webservice/places.dart';
import 'package:geocoder/geocoder.dart';
import 'package:ourwonderfullapp/home_page/track_group/groupe_syncronisation.dart';
import '../../classes/Utilisateur.dart';

GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: "AIzaSyCN5CJGsvRnutmMNhpN8toEprd3fn7cIBg");

class SourceDestination_grp extends StatefulWidget {
   Group groupe ;
   Utilisateur user ;
  SourceDestination_grp(Utilisateur user , Group groupe ) {this.groupe = groupe ; this.user=user;}

  @override
  _SourceDestinationState_group createState() =>_SourceDestinationState_group(user , groupe );
}

class _SourceDestinationState_group extends State<SourceDestination_grp>
{
  Group groupe ;
  Utilisateur user ;
  _SourceDestinationState_group (Utilisateur user , Group group ) {this.groupe = groupe ; this.user = user ;}
  GoogleMapController _controller ;
  static final CameraPosition _initialLocation = CameraPosition(target: LatLng(36.752887,  3.042048), zoom: 14.4746,);
  static LatLng destination ;
  TextEditingController DestinationController = TextEditingController();
  Set <Marker> _markers = {} ;


  @override
  void initState() {
    groupe = widget.groupe;
    group_markers();
  }

  aaaa ()async {
    Set <Marker> m =  await  groupe.addMarkers() ;
    _markers.addAll(m);}

  group_markers() { setState(()  {aaaa();});}  // pour afficher  'markers' fel map

  @override
  Widget build(BuildContext context)
  {

    return Scaffold(
        appBar: AppBar(
          title: Text("home_page"),
        ),
        body: Stack( children :  <Widget> [
          GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _initialLocation,
            markers: _markers,
            onMapCreated: (GoogleMapController controller) {
              _controller = controller;
            },),

          Positioned (
            top : 105.0 ,
            right : 15.0 ,
            left: 15.0 ,
            child : Container (
              height: 50.0,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0) ,
                color: Colors.white ,
                boxShadow : [BoxShadow(color: Colors.black12 , offset: Offset(1.0,5.0),blurRadius: 10 , spreadRadius: 3) ],
              ),
              child: TextField(
                controller: DestinationController,
                cursorColor: Colors.black,
                onTap: () async{

                  Prediction p = await PlacesAutocomplete.show(
                      context: context, apiKey: "AIzaSyCN5CJGsvRnutmMNhpN8toEprd3fn7cIBg" ,  mode: Mode.overlay );
                  displayPrediction(p);
                  setState(() async {
                    Set <Marker> m = await  groupe.addMarkers() ;
                    _markers.addAll(m) ;
                  });
                } ,
                decoration : InputDecoration ( icon: Container(margin: EdgeInsets.only(left: 20,top: 5), width: 10, height: 10, child: Icon ( Icons.directions_car ), ) ,
                  hintText: "Destination" ,
                  border: InputBorder.none ,
                ),

              ),
            ),
          ),
          Positioned(  top : 80.0 ,
              right : 10.0 ,
              left: 10.0 ,
              child: RaisedButton( color : Colors.white ,onPressed: (){Navigator.of(context).push(MaterialPageRoute(builder: (context)=> track_groupe ( user ,   destination ,  groupe ))); }, child: Text("commencer"),) ),

        ]));



  }


  void get_group_position()
  {
    for (int j=0 ; j < groupe.members.length ; j++)
    {
      setState(() {
        _markers.add(Marker(
          markerId: MarkerId(groupe.members[j].membersInfo.id),
          position: groupe.members[j].membersInfo.location,
          infoWindow: InfoWindow(title: groupe.members[j].membersInfo.displayName),
          anchor: Offset(0.5, 0.5),));
      });
    }

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
      _controller.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition ( target: LatLng ( detail.result.geometry.location.lat,  detail.result.geometry.location.lng), zoom: 18.0 ,  ),
      ),
      );
      destination =  LatLng ( detail.result.geometry.location.lat,  detail.result.geometry.location.lng);
      Placemark nation;
      // =  LatLng ( detail.result.geometry.location.lat,  detail.result.geometry.location.lng);

      DestinationController.text = detail.result.name ;
      setState(() {
        final marker = Marker(
          markerId: MarkerId("destination"),
          position:  LatLng ( detail.result.geometry.location.lat,  detail.result.geometry.location.lng),
          infoWindow: InfoWindow(title: 'Your destination'),
        );
        _markers.add(marker);

      } ) ;
    }
  }
}
