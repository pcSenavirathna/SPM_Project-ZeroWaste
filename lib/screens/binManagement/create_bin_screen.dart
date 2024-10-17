import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:zero_waste/models/collection_route.dart';
import 'package:zero_waste/models/waste_bin.dart';
import 'package:zero_waste/repositories/collection_route_repository.dart';
import 'package:zero_waste/repositories/waste_bin_repository.dart';
import 'package:zero_waste/widgets/dialog_messages.dart';
import '../../widgets/select_dropdown.dart';

class CreateBinScreen extends StatefulWidget {
  const CreateBinScreen({super.key});

  @override
  State<CreateBinScreen> createState() => _CreateBinScreenState();
}

class _CreateBinScreenState extends State<CreateBinScreen> {
  late MapController controller;
  final _formKey = GlobalKey<FormState>();
  List<String> routeList = [];
  late List<CollectionRoute> allRoutes;
  String? _collectionRoute;
  String? _binType;
  GeoPoint? _binLocation;

  @override
  void initState() {
    super.initState();
    controller = MapController.withUserPosition(
        trackUserLocation: const UserTrackingOption(
      enableTracking: true,
      unFollowUser: false,
    ));
    loadRoutes();
  }

  @override
  Widget build(BuildContext context) {
    controller.listenerMapLongTapping.addListener(() async {
      if (controller.listenerMapLongTapping.value != null) {
        createPin(controller.listenerMapLongTapping.value);
      }
    });

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.green.shade200, Colors.blue.shade200],
          ),
        ),
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.15,
              width: double.infinity,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/bgImg.jpg"),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.elliptical(50, 30),
                      bottomRight: Radius.elliptical(50, 30))),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: () {
                          context.go("/profile");
                        },
                      )
                    ],
                  ),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Create Bin",
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 5),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: SelectDropdown(
                        title: "Route",
                        items: routeList,
                        selectedValue: _collectionRoute,
                        onChanged: (String? newValue) {
                          setState(() {
                            _collectionRoute = newValue;
                          });
                          drawRoute();
                        },
                        hint: "Select Route"),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: SelectDropdown(
                        title: "Bin Type",
                        items: const [
                          'Organic',
                          'Plastic',
                          'Glass',
                          'Paper',
                          'Metal',
                          'E-waste',
                        ],
                        selectedValue: _binType,
                        onChanged: (String? newValue) {
                          setState(() {
                            _binType = newValue;
                          });
                        },
                        hint: "Select Item"),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      "Select Bin Location",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.3,
                    child: OSMFlutter(
                      controller: controller,
                      osmOption: const OSMOption(
                        zoomOption: ZoomOption(
                          initZoom: 12,
                          minZoomLevel: 3,
                          maxZoomLevel: 19,
                          stepZoom: 1.0,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              margin: const EdgeInsets.fromLTRB(40, 5, 20, 0),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(10)),
              child: TextButton(
                onPressed: () => _submitForm(context),
                child: Text("Create Bin",
                    style: Theme.of(context).textTheme.bodyLarge),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> createPin(GeoPoint? location) async {
    if (_binLocation == null) {
      _binLocation = location;
      await controller.addMarker(
        _binLocation!,
        markerIcon: const MarkerIcon(
          icon: Icon(
            Icons.location_on,
            color: Colors.red,
            size: 48,
          ),
        ),
      );
    } else {
      GeoPoint? oldBinLocation = _binLocation;
      _binLocation = location;
      await controller.changeLocationMarker(
        oldLocation: oldBinLocation!,
        newLocation: _binLocation!,
        markerIcon: const MarkerIcon(
          icon: Icon(
            Icons.location_on,
            color: Colors.red,
            size: 48,
          ),
        ),
      );
    }
  }

  void _submitForm(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final wasteBin = WasteBin(
          routeId: _collectionRoute!.split(' -')[0],
          binType: _binType!,
          longitude: _binLocation!.longitude,
          latitude: _binLocation!.latitude);

      WasteBinRepository().addBin(wasteBin).then((_) {
        okMessageDialog(context, 'Created!', 'Waste Bin Created Successfully');
        context.go("/profile");
      }).catchError((error) {
        okMessageDialog(context, 'Failed!', error.toString());
      });
    }
  }

  void loadRoutes() {
    CollectionRouteRepository().getAllRoutes().then((collectionRoutes) {
      CollectionRoute route;
      List<String> routes = [];
      for (route in collectionRoutes) {
        String routeName =
            '${route.id} - ${route.startLocation} to ${route.endLocation}';
        routes.add(routeName);
      }
      setState(() {
        routeList = routes;
        allRoutes = collectionRoutes;
      });
    }).catchError((error) {
      okMessageDialog(context, 'Failed!', error.toString());
    });
  }

  void drawRoute() {
    CollectionRoute? selectedRoute;
    String routeId = _collectionRoute!.split(' -')[0];
    print(routeId);
    for (selectedRoute in allRoutes) {
      if (selectedRoute.id == routeId) {
        break;
      }
    }
    controller
        .drawRoad(
          GeoPoint(
              latitude: selectedRoute!.startLatitude,
              longitude: selectedRoute.startLongitude),
          GeoPoint(
              latitude: selectedRoute.endLatitude,
              longitude: selectedRoute.endLongitude),
          roadType: RoadType.foot,
          roadOption: const RoadOption(
            roadWidth: 10,
            roadColor: Colors.blue,
            zoomInto: true,
          ),
        )
        .then((roadInfo) {})
        .catchError((error) {});
  }
}
