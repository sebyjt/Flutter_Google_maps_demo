import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';
void main() async {
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(title: const Text('Google Maps demo')),
      body: MapsDemo(),
    ),
  ));
}

class MapsDemo extends StatefulWidget {
  @override
  State createState() => MapsDemoState();
}

class MapsDemoState extends State<MapsDemo> {
  var currentlocation={};
  GoogleMapController mapController;
  Position position;
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
   }
init() async{
  position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  setState(() {
    currentlocation["latitude"]=position.latitude;
    currentlocation["longitude"]=position.longitude;
  });

}

  @override

  Widget build(BuildContext context) {
    return new Scaffold(
      body:currentlocation.isEmpty?new Center(child:CircularProgressIndicator()): new Stack(
        children: <Widget>[
          new Container(
            height: double.infinity,
            width: double.infinity,
            child: new GoogleMap(initialCameraPosition: CameraPosition(target: LatLng(currentlocation["latitude"], currentlocation["longitude"]),zoom: 20.0),

            onMapCreated: _onMapCreated,),
          ),
          Positioned(
            bottom: 50.0,
            left: 10.0,
            child: new RaisedButton(onPressed:gotocurrent,
              shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
              color: Colors.green,
              splashColor: Colors.red,
              padding: EdgeInsets.all(10.0),
              child: new Icon(Icons.location_on,size: 40.0,),


          ))
        ],
      ),
    );}
    void _onMapCreated(GoogleMapController controller) {
    setState(() { mapController = controller;
    mapController.addMarker(MarkerOptions(position: LatLng(currentlocation["latitude"], currentlocation["longitude"]),infoWindowText: InfoWindowText("you are here",""),visible: true));
    });
  }
  void gotocurrent()
  {
    mapController.animateCamera(CameraUpdate.newLatLng(LatLng(currentlocation["latitude"], currentlocation["longitude"])));
  }
}