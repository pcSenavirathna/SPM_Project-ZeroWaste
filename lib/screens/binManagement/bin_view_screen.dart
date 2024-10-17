import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:go_router/go_router.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:zero_waste/models/waste_bin.dart';
import 'package:zero_waste/repositories/waste_bin_repository.dart';
import 'package:zero_waste/utils/custom_bins_icons.dart';
import 'package:zero_waste/widgets/dialog_messages.dart';

import '../../models/household_user.dart';
import '../../models/user.dart';

class BinViewScreen extends StatefulWidget {
  final User loginedUser;

  const BinViewScreen({super.key, required this.loginedUser});

  @override
  State<BinViewScreen> createState() => _BinViewScreenState();
}

class _BinViewScreenState extends State<BinViewScreen> {
  late MapController controller;
  late List<WasteBin> bins;
  late WasteBin selectedBin;
  bool updateStatus = false;
  GeoPoint? _binLocation;

  @override
  void initState() {
    super.initState();
    controller = MapController.withUserPosition(
        trackUserLocation: const UserTrackingOption(
      enableTracking: true,
      unFollowUser: false,
    ));
    loadBins();
  }

  void getCurrentLocation(GeoPoint geoPoint) {
    controller.myLocation().then((location) {
      controller.removeLastRoad().then((_) {
        _drawRoad(location, geoPoint);
      }).catchError((error) {
        print('Error Clearing Roads: $error');
        _drawRoad(GeoPoint(latitude: 5.5, longitude: 5.5), geoPoint);
      });
      _drawRoad(location, geoPoint);
    }).catchError((error) {
      print('Error fetching location: $error');
      _drawRoad(GeoPoint(latitude: 5.5, longitude: 5.5), geoPoint);
    });
  }

  void _onGeoPointClicked(GeoPoint geoPoint) {
    for (WasteBin bin in bins) {
      if (bin.latitude == geoPoint.latitude &&
          bin.longitude == geoPoint.longitude) {
        selectedBin = bin;
      }
    }

    Dialogs.bottomMaterialDialog(
        msg: 'Do You Want To Make any Changes to the Selected Marker?',
        title: 'Make Changes',
        context: context,
        actions: [
          IconsOutlineButton(
            onPressed: () {
              updateStatus = true;
              Navigator.of(context).pop();
            },
            text: 'Change',
            iconData: Icons.location_pin,
            textStyle: const TextStyle(color: Colors.grey),
            iconColor: Colors.grey,
          ),
          IconsButton(
            onPressed: () {
              deleteBin(selectedBin);
              Navigator.of(context).pop();
            },
            text: 'Remove',
            iconData: Icons.delete,
            color: Colors.red,
            textStyle: const TextStyle(color: Colors.white),
            iconColor: Colors.white,
          ),
        ]);
  }

  void _drawRoad(GeoPoint start, GeoPoint end) {
    for (WasteBin bin in bins) {
      if (bin.latitude == end.latitude && bin.longitude == end.longitude) {
        selectedBin = bin;
      }
    }
    controller
        .drawRoad(
      start,
      end,
      roadType: RoadType.foot,
      roadOption: const RoadOption(
        roadWidth: 10,
        roadColor: Colors.blue,
        zoomInto: true,
      ),
    )
        .then((roadInfo) {
      Dialogs.bottomMaterialDialog(
          msg:
              '${roadInfo.distance}km From Current Location and it Takes ${roadInfo.duration}sec to go by walk',
          title: '${selectedBin.binType} Bin',
          context: context,
          actions: [
            IconsOutlineButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              text: 'Ok',
              iconData: Icons.location_pin,
              textStyle: const TextStyle(color: Colors.grey),
              iconColor: Colors.grey,
            ),
          ]);
    }).catchError((error) {});
  }

  Future<void> createPin(GeoPoint location) async {
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

    showCupertinoDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text('Confirm New Marker?'),
          actions: <Widget>[
            CupertinoDialogAction(
              child: const Text('Cancel'),
              onPressed: () {
                _binLocation = null;
                Navigator.of(context).pop();
              },
            ),
            CupertinoDialogAction(
              child: const Text('Confirm'),
              onPressed: () {
                Navigator.of(context).pop();
                _binLocation = null;
                updateBin(location);
              },
            )
          ],
        );
      },
    );
  }

  Future<void> loadBins() async {
    bins = await WasteBinRepository().getAllBins();
    for (WasteBin bin in bins) {
      await controller.addMarker(
        GeoPoint(latitude: bin.latitude, longitude: bin.longitude),
        markerIcon: MarkerIcon(
          icon: CustomBins.getBinIcon(bin.binType),
        ),
      );
    }
  }

  void updateBin(GeoPoint location) {
    WasteBin newBin = selectedBin;
    newBin.longitude = location.longitude;
    newBin.latitude = location.latitude;

    WasteBinRepository().updateBin(selectedBin).then((_) {
      okMessageDialog(context, "Success!", "Waste Bin Updated Successfully");
    }).catchError((error) {
      okMessageDialog(context, "Failed!", error.toString());
    });
  }

  void deleteBin(WasteBin bin) {
    WasteBinRepository().deleteBin(bin.id).then((_) {
      okMessageDialog(context, "Success!", "Waste Bin Deleted Successfully");
    }).catchError((error) {
      okMessageDialog(context, "Failed!", error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    controller.listenerMapLongTapping.addListener(() async {
      if (updateStatus) {
        if (controller.listenerMapLongTapping.value != null) {
          createPin(controller.listenerMapLongTapping.value!);
        }
      }
    });

    return Scaffold(
        appBar: AppBar(
          title: const Text('Bin View'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              context.go("/profile");
            },
          ),
        ),
        body: OSMFlutter(
          onGeoPointClicked: (widget.loginedUser.userType == "HouseholdUser")
              ? getCurrentLocation
              : _onGeoPointClicked,
          controller: controller,
          osmOption: const OSMOption(
            userTrackingOption: UserTrackingOption(
              enableTracking: true,
              unFollowUser: false,
            ),
            zoomOption: ZoomOption(
              initZoom: 14,
              minZoomLevel: 3,
              maxZoomLevel: 19,
              stepZoom: 1.0,
            ),
          ),
        ));
  }
}
