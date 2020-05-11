import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:ourwonderfullapp/home_page/src_dest.dart';
import '../classes/Groupe.dart';
import '../classes/Groupe.dart';
import '../classes/Utilisateur.dart';
import 'select_group.dart';
import 'package:unicorndial/unicorndial.dart';
import 'dragging.dart';
import 'fab_circular_menu.dart';
import 'src_dest.dart';
import 'package:ourwonderfullapp/classes/Groupe.dart';
import 'package:search_map_place/search_map_place.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geocoder/geocoder.dart';
import 'pin_pill_info.dart';
import 'dart:math';
import 'package:vector_math/vector_math.dart' show radians, Vector3;
import 'package:ourwonderfullapp/classes/Utilisateur.dart';
import 'track_group/groupe_syncronisation.dart';
import 'track_group/source_destionation_group.dart';
GoogleMapsPlaces _places =
GoogleMapsPlaces(apiKey: "AIzaSyCN5CJGsvRnutmMNhpN8toEprd3fn7cIBg");
class HomePages extends StatefulWidget {
 Utilisateur user ;
 HomePages(Utilisateur user ) {this.user = user ; }

  @override
  _MyHomePageStates createState() => new _MyHomePageStates(user);

}

class _MyHomePageStates extends State<HomePages> {
  StreamSubscription _locationSubscription;
  Utilisateur user ;
  _MyHomePageStates(Utilisateur User ) {this.user = User ; }
  // Location _locationTracker = Location();
  Marker marker;
  Circle circle;
  PinInformation sourcePinInfo;
  Group groupe ;

  GoogleMapController mapController;
  final Set<Marker> _markers = {};

  final Set<Polyline> _polyline = {};

  static LatLng _initialPosition;

  LatLng _lastPosition = _initialPosition;

  LatLng userPosition;
  MapType _currentMapType = MapType.normal;
  BitmapDescriptor locationIcon;

  void setCustomMapPin() async {
    locationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), 'assets/user_icon.png');
  }

  static final CameraPosition initialLocation = CameraPosition(
    target: LatLng(36.752887, 3.042048),
    zoom: 14.4746,
  );

  Widget button(Function function, IconData icon, Color color1, Color color2,String herotag) {
    return Container(
        height: 45,
        width: 45,
        child: FittedBox(
          child: FloatingActionButton(
            heroTag: herotag,
            onPressed: function,
            materialTapTargetSize: MaterialTapTargetSize.padded,
            backgroundColor: color1,
            child: Icon(icon, size: 30.0, color: color2),
          ),
        ));
  }
  _onMapTypeButtonPressed() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
    print ("aaaa") ;
  }
  Widget _buildBtn(Function onTap, Icon icon ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60.0,
        width: 60.0,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(0, 2),
              blurRadius: 6.0,
            ),
          ],

        ),
        child: icon,
      ),
    );
  }
  Widget _build_Nav_Bar ()
  {
    return Positioned(
      bottom: 6,
      left: 5,
      right: 5,
      height: 50,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              height: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 21.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.orangeAccent),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  GestureDetector(
                    child: Icon(
                      Icons.map,
                      color: Colors.white,
                    ),
                    onTap: () {_onMapTypeButtonPressed() ;},
                  ),
                  GestureDetector(
                    child: Icon(
                      Icons.history,
                      color: Colors.white,
                    ),
                    onTap: () {},
                  ),
                  GestureDetector(
                    child: Icon(
                      Icons.security,
                      color: Colors.white,
                    ),
                    onTap: () {},
                  ),
                  GestureDetector(
                    child: Icon(
                      Icons.settings,
                      color: Colors.white,
                    ),
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 5),

        ],
      ),
    );
  }

  Widget _buildBtnRow() {
    return Padding(
      padding: EdgeInsets.only(left:30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildBtn(_segeolocaliser, Icon(Icons.my_location)),
          _buildBtn(()async {
            // show input autocomplete with selected mode
            // then get the Prediction selected
            Prediction p = await PlacesAutocomplete.show(
              context: context,
              mode: Mode.overlay,
              apiKey: "AIzaSyCN5CJGsvRnutmMNhpN8toEprd3fn7cIBg",
            );
            displayPrediction(p);
          }, Icon(Icons.search)),
        ],
      ),
    );
  }
  Widget _buildLoginBtn() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 25.0),
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () {},
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: Colors.white,
        child: Text(
          'LOGIN',
          style: TextStyle(
            color: Color(0xFF527DAA),
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            GoogleMap(
              compassEnabled: true,
              tiltGesturesEnabled: false,
              mapType:_currentMapType,
              initialCameraPosition: initialLocation,
              markers: _markers,
              polylines: _polyline,
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
              },
            ),
            Positioned(

              child: RaisedButton(
                onPressed: () async  {
              //    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> groupe_home_page  (user ,  groupe )));
                    }, child: Text("Sync_group"), color : Colors.white ,),

              bottom: 100,
              right: 60,
              left: 60,
            ),
            Positioned(

              child: RaisedButton(
                onPressed: () async  {
                 Navigator.of(context).push(MaterialPageRoute(builder: (context)=>SourceDestination_grp (user ,  groupe )));
                }, child: Text("track_group"), color : Colors.white ,),

              bottom: 50,
              right: 60,
              left: 60,
            ),

          Positioned(
              top:40,
              left:5,
             child : Container(
                      height: 45,
                         width: 45,
                     child: FittedBox(
                              child : FloatingActionButton(
                                 onPressed: () async {   Prediction p = await PlacesAutocomplete.show(context: context, mode: Mode.overlay, apiKey: "AIzaSyCN5CJGsvRnutmMNhpN8toEprd3fn7cIBg",);displayPrediction(p);} ,
                                 materialTapTargetSize: MaterialTapTargetSize.padded,
                                backgroundColor: Colors.white,
                                child: Icon (
                                   Icons.search ,color: Colors.orangeAccent,
                                  ),
            ),)),
            ),
            Positioned(
              top:40,
              right:5,
              child:button(()async {},
                  Icons.message, Colors.white,
                  Colors.orangeAccent,"btn8"),
            ),

            Positioned(

              child: GestureDetector(
                onTap: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => s_d1()));},
                child: Container(

                  height: 45,

                  decoration: BoxDecoration(

                    gradient: LinearGradient(

                      colors: [

                        Colors.teal,

                        Colors.teal[200],

                      ],

                      begin: Alignment.topLeft,

                      end: Alignment.bottomRight,

                    ),

                    borderRadius: BorderRadius.circular(20),

                    boxShadow: [

                      BoxShadow(

                        color: Colors.black12,

                        offset: Offset(5, 5),

                        blurRadius: 10,

                      )

                    ],

                  ),

                  child: Center(

                    child: Text(

                      'Commencons un trajet ensemble',

                      style: TextStyle(

                        color: Colors.white,

                        fontSize: 15,

                        fontWeight: FontWeight.w500,

                      ),

                    ),

                  ),

                ),

              ),

              bottom: 140,

              right: 60,

              left: 60,

            ),
            Positioned(
              right: 10,
              bottom: 240,
              child: Column(children: <Widget>[
                //Amina there is the buttons
                //1************************************
                // the button of auto-tracking
                button(_segeolocaliser, Icons.my_location, Colors.white,
                    Colors.orangeAccent,"btn3"),
                SizedBox(height: 10),
                button(_onMapTypeButtonPressed, Icons.filter_none, Colors.white,
                    Colors.orangeAccent,"btn2"),

                //  button(zoomplus, Icons.zoom_in, Colors.orangeAccent),
                //  button(c, Icons.map, Colors.orangeAccent)
              ]),
            ),
            /*  Positioned(

              child: RaisedButton(
                onPressed: () {  Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => s_d()));  }, child: Text("commencer un voyage "), color : Colors.white ,),

              bottom: 200,
              right: 60,
              left: 60,
            ),*/
         //   MyGroup(),

           // Dragging(),

            _build_Nav_Bar() ,
          ],
        ));
  }

  _onMapTypeButtonPressedd() {
    setState(() {
      _currentMapType = _currentMapType == MapType.normal
          ? MapType.satellite
          : MapType.normal;
    });
  }

  _segeolocaliser() async {
    /*  hadi tmedlk l ihdathiat win raky */
    var currentLocation = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    /* hna bach ndir une marque f ma position */
    setState(() {
      _markers.clear();
      final marker = Marker(
        icon: locationIcon,
        markerId: MarkerId("curr_loc"),
        position: LatLng(currentLocation.latitude, currentLocation.longitude),
      );
      sourcePinInfo = PinInformation(
          locationName: "Start Location",
          pinPath: "assets/user_icon.png",
          avatarPath: "assets/friend1.jpg",
          labelColor: Colors.blueAccent);
      _markers.add(marker);
      /* hna bach tsra hadik l'animation ida konti fi plassa khra la map trej3ek f ta position */
      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(currentLocation.latitude, currentLocation.longitude),
            zoom: 11.0,
          ),
        ),
      );
    });
  }

  @override
  void initState() {
    super.initState();
    setCustomMapPin();
    cloc();
  }

  cloc() async {
    var currentLocation = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    userPosition = LatLng(currentLocation.latitude, currentLocation.longitude);
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

      mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(detail.result.geometry.location.lat,
                detail.result.geometry.location.lng),
            zoom: 18.0,
          ),
        ),
      );
    }
  }



///////////////////////

//////////

}