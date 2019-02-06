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
  var currentlocation = {};
  GoogleMapController mapController;
  Position position;
  TextEditingController controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
    controller = new TextEditingController();
  }

  init() async {
    position = await Geolocator()
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      currentlocation["latitude"] = position.latitude;
      currentlocation["longitude"] = position.longitude;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      resizeToAvoidBottomPadding: false,
      body: currentlocation.isEmpty
          ? new Center(child: CircularProgressIndicator())
          : new Stack(
              children: <Widget>[
                new Container(
                  height: double.infinity,
                  width: double.infinity,
                  child: new GoogleMap(
                    initialCameraPosition: CameraPosition(
                        target: LatLng(currentlocation["latitude"],
                            currentlocation["longitude"]),
                        zoom: 15.0),
                    onMapCreated: _onMapCreated,
                  ),
                ),
                Positioned(
                    bottom: 50.0,
                    left: 10.0,
                    child: new RaisedButton(
                      onPressed: gotocurrent,
                      shape: CircleBorder(
                          side: BorderSide(color: Colors.transparent)),
                      color: Colors.green,
                      splashColor: Colors.red,
                      padding: EdgeInsets.all(10.0),
                      child: new Icon(
                        Icons.location_on,
                        size: 40.0,
                      ),
                    )),

                new Container(
                      height: 50.0,
                      margin: EdgeInsets.all(10.0),
                      decoration: new BoxDecoration(
                        
                        color: Colors.white70,
                          borderRadius:
                          BorderRadius.all(Radius.circular(10.0)),
                        border: Border.all(color: Colors.transparent)
                      ),
                  child:new Row(
                    children: <Widget>[
                      new Expanded(child: new GestureDetector(
                        child: new Icon(Icons.search),
                        onTap: (){
                          print(controller.text+"hellooo");
                          try{
                          Geolocator().placemarkFromAddress(controller.text).then((result){
                            print(result);
                            mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
    target:
    LatLng(result[0].position.latitude, result[0].position.longitude),
    zoom: 15.0)));
                          });}
                          catch (e)
                          {

                          }
                        },
                      ),flex: 1,),
                      new Expanded(child: TextField(
                        controller: controller,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "enter the place to search"
                        ),
                      ),flex: 6,)
                    ],
                  ),
                        )
              ],
            ),
    );
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
      mapController.addMarker(MarkerOptions(
          position:
              LatLng(currentlocation["latitude"], currentlocation["longitude"]),
          infoWindowText: InfoWindowText("you are here", ""),
          visible: true));
    });
  }

  void gotocurrent() {
    mapController.animateCamera(CameraUpdate.newLatLng(
        LatLng(currentlocation["latitude"], currentlocation["longitude"])));
  }
}
