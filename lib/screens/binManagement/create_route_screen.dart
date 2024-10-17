import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:zero_waste/models/collection_route.dart';
import 'package:zero_waste/repositories/collection_route_repository.dart';
import 'package:zero_waste/utils/helpers.dart';
import 'package:zero_waste/utils/validators.dart';
import 'package:zero_waste/widgets/dialog_messages.dart';
import 'package:zero_waste/widgets/text_field_input.dart';

class CreateRouteScreen extends StatefulWidget {
  const CreateRouteScreen({super.key});

  @override
  State<CreateRouteScreen> createState() => _CreateRouteScreenState();
}

class _CreateRouteScreenState extends State<CreateRouteScreen> {
  late MapController controller;
  final _formKey = GlobalKey<FormState>();
  final _startController = TextEditingController();
  final _endController = TextEditingController();
  GeoPoint? _startPoint;
  GeoPoint? _endPoint;
  double? distance = 0.0;
  String? timeTaken = '00:00:00';

  @override
  void initState() {
    super.initState();
    controller = MapController.withUserPosition(
        trackUserLocation: const UserTrackingOption(
      enableTracking: true,
      unFollowUser: false,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.green.shade200, Colors.blue.shade200],
            ),
          ),
          child: SafeArea(
              child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.2,
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
                                "Create Route",
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
                    const SizedBox(height: 30),
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFieldInput(
                                title: "Start Location",
                                icon: Icons.location_on_outlined,
                                controller: _startController,
                                inputType: TextInputType.text,
                                validator: Validators.nullCheck),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFieldInput(
                                title: "End Location",
                                icon: Icons.location_pin,
                                controller: _endController,
                                inputType: TextInputType.text,
                                validator: Validators.nullCheck),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            margin: const EdgeInsets.fromLTRB(20, 5, 20, 0),
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(10)),
                            child: TextButton(
                              onPressed: () => _loadLocations(context),
                              child: Text("Check Route",
                                  style: Theme.of(context).textTheme.bodyLarge),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Route View \n \n Total Distance : $distance km \n Total Time Taken : $timeTaken",
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.6,
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
                          ),
                          const SizedBox(height: 10),
                          Container(
                            margin: const EdgeInsets.fromLTRB(20, 5, 20, 8),
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(10)),
                            child: TextButton(
                              onPressed: () => _submitForm(context),
                              child: Text("Create Route",
                                  style: Theme.of(context).textTheme.bodyLarge),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ))),
    );
  }

  void _submitForm(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final route = CollectionRoute(
          id: '',
          startLocation: _startController.text,
          endLocation: _endController.text,
          startLongitude: _startPoint!.longitude,
          startLatitude: _startPoint!.latitude,
          endLongitude: _endPoint!.longitude,
          endLatitude: _endPoint!.latitude);

      CollectionRouteRepository().addRoute(route).then((_) {
        okMessageDialog(context, 'Created!', 'Route Created Successfully');
        context.go("/profile");
      }).catchError((error) {
        okMessageDialog(context, 'Failed!', error.toString());
      });
    }
  }

  void _loadLocations(BuildContext context) async {
    if (_startPoint != null) {
      await controller.removeMarker(_startPoint!);
    }
    if (_endPoint != null) {
      await controller.removeMarker(_endPoint!);
    }

    await controller.removeLastRoad();

    try {
      final responseStart = await http.get(Uri.parse(
          'https://nominatim.openstreetmap.org/search?q=${_startController.text}&format=json&limit=1'));
      final responseEnd = await http.get(Uri.parse(
          'https://nominatim.openstreetmap.org/search?q=${_endController.text}&format=json&limit=1'));

      if (responseStart.statusCode == 200 && responseEnd.statusCode == 200) {
        final jsonDataStart = jsonDecode(responseStart.body);
        final jsonDataEnd = jsonDecode(responseEnd.body);

        if (jsonDataStart.isNotEmpty && jsonDataEnd.isNotEmpty) {
          final locationStart = jsonDataStart[0];
          final locationEnd = jsonDataEnd[0];

          if (locationStart['lat'] != null &&
              locationStart['lon'] != null &&
              locationEnd['lat'] != null &&
              locationEnd['lon'] != null) {
            _startPoint = GeoPoint(
                latitude: double.parse(locationStart['lat']),
                longitude: double.parse(locationStart['lon']));

            _endPoint = GeoPoint(
                latitude: double.parse(locationEnd['lat']),
                longitude: double.parse(locationEnd['lon']));

            await controller.addMarker(
              _startPoint!,
              markerIcon: const MarkerIcon(
                icon: Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 48,
                ),
              ),
            );

            await controller.addMarker(
              _endPoint!,
              markerIcon: const MarkerIcon(
                icon: Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 48,
                ),
              ),
            );

            controller
                .drawRoad(
              _startPoint!,
              _endPoint!,
              roadType: RoadType.car,
              roadOption: const RoadOption(
                roadWidth: 10,
                roadColor: Colors.blue,
                zoomInto: true,
              ),
            )
                .then((roadInfo) {
              setState(() {
                distance =
                    double.parse((roadInfo.distance)!.toStringAsFixed(2));
                timeTaken = Helpers.formatTime(roadInfo.duration!.toInt());
              });
            }).catchError((error) {
              okMessageDialog(context, 'Failed!', 'Error drawing road: $error');
            });
          } else {
            okMessageDialog(context, 'Failed!', 'Invalid location coordinates');
          }
        } else {
          okMessageDialog(context, 'Failed!', 'Location not found');
        }
      } else {
        okMessageDialog(context, 'Failed!', 'Error searching for location');
      }
    } catch (e) {
      okMessageDialog(context, 'Failed!', 'Error: $e');
    }
  }

}
