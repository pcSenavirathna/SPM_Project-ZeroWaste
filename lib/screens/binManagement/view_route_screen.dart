import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:go_router/go_router.dart';
import 'package:zero_waste/models/collection_route.dart';
import 'package:zero_waste/models/employee.dart';
import 'package:zero_waste/models/route_schedule.dart';
import 'package:zero_waste/models/waste_bin.dart';
import 'package:zero_waste/repositories/collection_route_repository.dart';
import 'package:zero_waste/repositories/employee_repository.dart';
import 'package:zero_waste/repositories/route_schedule_repository.dart';
import 'package:zero_waste/repositories/waste_bin_repository.dart';
import 'package:zero_waste/utils/custom_bins_icons.dart';
import 'package:zero_waste/utils/helpers.dart';
import 'package:zero_waste/utils/user_types.dart';
import 'package:zero_waste/widgets/dialog_messages.dart';
import 'package:zero_waste/widgets/select_dropdown.dart';
import '../../models/user.dart';

class ViewRouteScreen extends StatefulWidget {
  final User loginedUser;

  const ViewRouteScreen({super.key, required this.loginedUser});

  @override
  State<ViewRouteScreen> createState() => _ViewRouteScreenState();
}

class _ViewRouteScreenState extends State<ViewRouteScreen> {
  late MapController controller;
  late List<WasteBin> bins;
  late List<GeoPoint> binLocations;
  late List<RouteSchedule> allSchedules;
  List<String> scheduleDates = [];
  late Employee driver;
  String? selectedDate;
  RouteSchedule? selectedSchedule;
  RoadInfo? roadDetails;

  @override
  void initState() {
    super.initState();
    controller = MapController.withUserPosition(
        trackUserLocation: const UserTrackingOption(
      enableTracking: true,
      unFollowUser: false,
    ));
    checkSchedule();
  }

  void checkSchedule() {
    _checkSchedule().then((_) {}).catchError((error) {
      okMessageDialog(context, "Failed!", error.toString());
    });
  }

  Future<void> _checkSchedule() async {
    try {
      Employee? employee =
          await EmployeeRepository().getEmployeeByUserId(widget.loginedUser.id);

      if (employee!.employeeType == UserTypes.TRUCK_DRIVER) {
        driver = employee;
        allSchedules = await RouteScheduleRepository()
            .findFutureSchedulesByDriverId(driver.id);
        RouteSchedule routeSchedule;
        List<String> dates = [];
        for (routeSchedule in allSchedules) {
          print(routeSchedule.scheduleDate.toString());
          dates.add(routeSchedule.scheduleDate.toString());
        }
        setState(() {
          scheduleDates = dates;
        });
      } else {
        context.go('/profile');
      }
    } catch (error) {
      okMessageDialog(context, "Failed!", error.toString());
    }
  }

  Future<void> loadRoute() async {
    RouteSchedule? selectedSchedule;
    for (selectedSchedule in allSchedules) {
      if (selectedSchedule.scheduleDate.toString() == selectedDate) {
        break;
      }
    }
    setState(() {
      this.selectedSchedule = selectedSchedule;
    });
    await loadBins(selectedSchedule!.routeId);
    CollectionRoute route =
        await CollectionRouteRepository().getRoute(selectedSchedule.routeId);
    RoadInfo details = await controller.drawRoad(
        GeoPoint(
            latitude: route.startLatitude, longitude: route.startLongitude),
        GeoPoint(latitude: route.endLatitude, longitude: route.endLongitude),
        roadType: RoadType.car,
        roadOption: const RoadOption(
          roadWidth: 10,
          roadColor: Colors.blue,
          zoomInto: true,
        ),
        intersectPoint: binLocations);
    setState(() {
      roadDetails = details;
    });
  }

  Future<void> loadBins(String routeId) async {
    bins = await WasteBinRepository().getBinByRouteId(routeId);
    List<GeoPoint> geopoints = [];
    for (WasteBin bin in bins) {
      await controller.addMarker(
        GeoPoint(latitude: bin.latitude, longitude: bin.longitude),
        markerIcon: MarkerIcon(
          icon: CustomBins.getBinIcon(bin.binType),
        ),
      );
      geopoints.add(GeoPoint(latitude: bin.latitude, longitude: bin.longitude));
    }
    binLocations = geopoints;
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 60),
            Padding(
              padding: const EdgeInsets.all(5),
              child: SelectDropdown(
                  title: "schedule Date",
                  items: scheduleDates,
                  selectedValue: selectedDate,
                  onChanged: (String? newValue) async {
                    setState(() {
                      selectedDate = newValue;
                    });
                    await loadRoute();
                  },
                  hint: "Select Route"),
            ),
            const SizedBox(height: 20),
            selectedSchedule != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Route : ${selectedSchedule!.routeId}',
                        style: const TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Distance : ${roadDetails!.distance}Km \n Time Estimated : ${Helpers.formatTime(roadDetails!.duration!.toInt())}',
                        style: const TextStyle(fontSize: 20),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.55,
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
                  )
                : const Text("No Data To display."),
          ],
        ),
      ),
    );
  }
}
