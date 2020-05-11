import 'dart:async';
//import 'dart:html' ;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ourwonderfullapp/classes/Groupe.dart';
import 'package:ourwonderfullapp/classes/SharableUserInfo.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:ourwonderfullapp/classes/Utilisateur.dart';

import '../../classes/Groupe.dart';
import '../../classes/Utilisateur.dart';
import '../../classes/Utilisateur.dart';
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: "AIzaSyCN5CJGsvRnutmMNhpN8toEprd3fn7cIBg");

class groupe_home_page extends StatefulWidget {
  Utilisateur user ;
  Group groupe ;
  groupe_home_page ( Utilisateur user , Group groupe   ) {this.user = user ; this.groupe = groupe ; }

  @override
  groupe_track_sync createState() => new groupe_track_sync ( user  ,groupe );

}


class groupe_track_sync extends State<groupe_home_page> {
  groupe_track_sync (Utilisateur user , Group groupe ) {this.groupe = groupe ;  this.user = user ;}
  StreamSubscription _locationSubscription;
  Group groupe ;
  Utilisateur user ;
  Marker marker;
  GoogleMapController _controller;
  static LatLng _initialPosition;
  LatLng _lastPosition = _initialPosition;

  final Set <Marker> _markers = Set <Marker> ();

  static final CameraPosition initialLocation = CameraPosition(
    target: LatLng(36.752887, 3.042048),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    setState(() {
      groupe.getMembers();
    });
    return Scaffold(

        body: Stack(
          children: <Widget>[

            GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: initialLocation,
              markers: _markers,
              onMapCreated: (GoogleMapController controller) {
                _controller = controller;
              },

            ),
            Positioned
              (
              top: 70.0,
              right: 15.0,
              left: 15.0,
              child: RaisedButton(
                /* yesmin hna bach yrooh  la fenetre bach yhawes ala destination lazem ydi le groupe comme parametre  bch ykder yjbed les membres o les position nta3hom*/
                onPressed: () {},
                child: Text("lets go"),),
            ),

            FloatingActionButton(
              child: Icon(Icons.search,),
              onPressed: () async {onboutton_group_pressed(groupe) ; },
              /* hada c juste bch ycryily le groupe u know lazem bch ykon andi group bch nkhdem and nty  il faut juste executer  on_bouton_group pressed
                *ana  9assdi qnd il clique ala l9roupe le but ntaha c yjbed  locations ntaaa3 members o yhathom sur la map des markers  */
              backgroundColor: Colors.blue,),
            Positioned
              (
              top: 150.0,
              right: 15.0,
              left: 15.0,
              child: RaisedButton(
                onPressed: () {on_sync_coutton_pressed(); },
                /* hna qnd la position ntaa les membres change  l user clique sur  le btn hdek ykherjolo les nv position nta les autre user ida kano on line */
                child: Text("sync"),),
            ),

          ],));
  }

  @override

  void onboutton_group_pressed(Group g) async
  {
    Set <Marker> _marker = await g.addMarkers();
    print(_marker);
    setState(() {
      _markers.addAll(_marker);
    });
  }
  void on_sync_coutton_pressed() async
  {
    Set <Marker> marker = await groupe.syncroniser();
    marker = await groupe.syncroniser();
    setState(()
    {_markers.clear();
    _controller ;
    _markers.addAll(marker);
    });
  }

}
