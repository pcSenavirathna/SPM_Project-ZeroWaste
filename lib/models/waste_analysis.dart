import 'package:cloud_firestore/cloud_firestore.dart';

class WasteAnalysis {
  String analysisId;
  String userType; // household, Business, both
  String binType; // smartbin, normal bin
  String primaryWasteType; // Most collecting waste type - Food waste, Plastic, Paper, glass, metal, e-waste, textile, construction waste
  String moderateWasteType; // Secondary collecting one
  String leastResidualType; // Least collecting one
  String wasteRemovingStatus; // How often would you remove household waste? daily, 2 times, 3 times, 4 times
  String wasteCollectionTime; // How often would you prefer waste to be collected?
  String composingWasteStatus; // Do you compose organic waste? Yes, no
  String separateWaste; // Do you seperate recycleble and not recycleble? Yes, no
  String areaCleanliness; // How would you rate the cleanliness around your smart bin area? Poor, Good, Clean
  String smartBinUpdate; // Any specific features you wish the smart bins had? Odor control, temperature, voice alerts, sanitation, size of the smart bin

  WasteAnalysis({
    this.analysisId = '',
    this.userType = '',  //this one
    this.binType = '',  //this one
    this.primaryWasteType = '',
    this.moderateWasteType = '',
    this.leastResidualType = '',
    this.wasteRemovingStatus = '',
    this.wasteCollectionTime = '',
    this.composingWasteStatus = '',  //this one
    this.separateWaste = '',
    this.areaCleanliness = '', 
    this.smartBinUpdate = '', //this one
  });

  Map<String, dynamic> toMap() {
    return {
      'analysisId': analysisId,
      'userType': userType,
      'binType': binType,
      'primaryWasteType': primaryWasteType,
      'moderateWasteType': moderateWasteType,
      'leastResidualType': leastResidualType,
      'wasteRemovingStatus': wasteRemovingStatus,
      'wasteCollectionTime': wasteCollectionTime,
      'composingWasteStatus': composingWasteStatus,
      'separateWaste': separateWaste,
      'areaCleanliness': areaCleanliness,
      'smartBinUpdate': smartBinUpdate,
    };
  }

  factory WasteAnalysis.fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return WasteAnalysis(
      analysisId: data['analysisId'] ?? '',
      userType: data['userType'] ?? '',
      binType: data['binType'] ?? '',
      primaryWasteType: data['primaryWasteType'] ?? '',
      moderateWasteType: data['moderateWasteType'] ?? '',
      leastResidualType: data['leastResidualType'] ?? '',
      wasteRemovingStatus: data['wasteRemovingStatus'] ?? '',
      wasteCollectionTime: data['wasteCollectionTime'] ?? '',
      composingWasteStatus: data['composingWasteStatus'] ?? '',
      separateWaste: data['separateWaste'] ?? '',
      areaCleanliness: data['areaCleanliness'] ?? '',
      smartBinUpdate: data['smartBinUpdate'] ?? '',
    );
  }
}
