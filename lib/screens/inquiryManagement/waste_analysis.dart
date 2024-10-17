import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zero_waste/models/waste_analysis.dart';
import 'package:zero_waste/repositories/waste_analysis_repository.dart';

class WasteAnalysisScreen extends StatefulWidget {
  const WasteAnalysisScreen({super.key});

  @override
  State<StatefulWidget> createState() => _WasteAnalysisState();
}

class _WasteAnalysisState extends State<WasteAnalysisScreen> {
  final WasteAnalysisRepository _repository = WasteAnalysisRepository();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _analysisId = TextEditingController();

  // State variables for dropdowns
  String _selectedUserType = 'Household user';
  String _selectedBinType = 'Smart Bin';
  String _selectedPrimaryWasteType = '';
  String _selectedModerateWasteType = '';
  String _selectedLeastResidualType = '';
  String _selectedRemovingTime = 'Daily';
  String _selectedCollectionTime = 'Daily';
  String _selectedComposingStatus = 'Yes';
  String _selectedSeperateStatus = 'Recycleable waste is separated';
  String _selectedAreaCleaninesss = 'Poor';
  String _selectedSmartBinUpdates = 'Odor control';

  // Lists for fields
  final List<Map<String, dynamic>> wasteTypes = [
    {'name': 'Plastic', 'color': Colors.blue},
    {'name': 'Organic', 'color': Colors.green},
    {'name': 'Metal', 'color': Colors.grey},
    {'name': 'Glass', 'color': Colors.amber},
    {'name': 'Paper', 'color': Colors.brown},
  ];

  final List<String> userTypes = ['Household user', 'Business', 'Both'];
  final List<String> binTypes = ['Smart Bin', 'Normal Bin'];
  final List<String> removingTimes = ['Daily', '2 times a week', '3 times a week', '4 times a week'];
  final List<String> collectionTimes = ['Daily', '2 times a week', '3 times a week'];
  final List<String> composingStatus = ['Yes', 'No'];
  final List<String> separateStatus = ['Recycleable waste is separated', 'I do not separate waste'];
  final List<String> areaCleanliness = ['Poor', 'Clean', 'Very clean'];
  final List<String> smartBinUpdates = ['Odor control', 'Temperature', 'Voice alerts', 'Sanitation', 'Size of the smart bin increased'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color.fromARGB(255, 152, 225, 154), Colors.white],
          ),
        ),
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 150.0,
              floating: false,
              pinned: true,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  Navigator.of(context).pop(); // Navigate back
                },
              ),
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: EdgeInsets.only(left: 0.0, bottom: 16.0),
                title: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Daily Analysis',
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        'Detailed Analysis of Waste Management Practices',
                        style: TextStyle(
                          color: const Color.fromARGB(255, 80, 82, 80),
                          fontSize: 12.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Primary Waste Type Checkboxes
                      Text("Primary Waste Type"),
                      Wrap(
                        spacing: 10.0, // spacing between the options
                        children: wasteTypes.map((type) {
                          return ChoiceChip(
                            label: Text(type['name']),
                            selected: _selectedPrimaryWasteType == type['name'],
                            onSelected: (bool selected) {
                              setState(() {
                                _selectedPrimaryWasteType = selected ? type['name'] : '';
                              });
                            },
                            selectedColor: type['color'],
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),

                      // Moderate Waste Type Checkboxes
                      Text("Moderate Waste Type"),
                      Wrap(
                        spacing: 10.0,
                        children: wasteTypes.map((type) {
                          return ChoiceChip(
                            label: Text(type['name']),
                            selected: _selectedModerateWasteType == type['name'],
                            onSelected: (bool selected) {
                              setState(() {
                                _selectedModerateWasteType = selected ? type['name'] : '';
                              });
                            },
                            selectedColor: type['color'],
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),

                      // Least Residual Type Checkboxes
                      Text("Least Residual Type"),
                      Wrap(
                        spacing: 10.0,
                        children: wasteTypes.map((type) {
                          return ChoiceChip(
                            label: Text(type['name']),
                            selected: _selectedLeastResidualType == type['name'],
                            onSelected: (bool selected) {
                              setState(() {
                                _selectedLeastResidualType = selected ? type['name'] : '';
                              });
                            },
                            selectedColor: type['color'],
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 32),

                      // User Type Dropdown
                      _buildDropdown(
                        label: 'User Type',
                        value: _selectedUserType,
                        items: userTypes,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedUserType = newValue!;
                          });
                        },
                      ),
                      const SizedBox(height: 16),

                      // Bin Type Dropdown
                      _buildDropdown(
                        label: 'Bin Type',
                        value: _selectedBinType,
                        items: binTypes,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedBinType = newValue!;
                          });
                        },
                      ),
                      const SizedBox(height: 16),

                      // Waste Removing Time Checkboxes
                      Text("Waste Removing Time"),
                      Wrap(
                        spacing: 10.0,
                        children: removingTimes.map((time) {
                          return ChoiceChip(
                            label: Text(time),
                            selected: _selectedRemovingTime == time,
                            onSelected: (bool selected) {
                              setState(() {
                                _selectedRemovingTime = selected ? time : 'Daily';
                              });
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),

                      // Waste Collection Time Checkboxes
                      Text("Waste Collection Time"),
                      Wrap(
                        spacing: 10.0,
                        children: collectionTimes.map((time) {
                          return ChoiceChip(
                            label: Text(time),
                            selected: _selectedCollectionTime == time,
                            onSelected: (bool selected) {
                              setState(() {
                                _selectedCollectionTime = selected ? time : 'Daily';
                              });
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),

                      // Composing Waste Status Checkboxes
                      Text("Composing Waste Status"),
                      Wrap(
                        spacing: 10.0,
                        children: composingStatus.map((status) {
                          return ChoiceChip(
                            label: Text(status),
                            selected: _selectedComposingStatus == status,
                            onSelected: (bool selected) {
                              setState(() {
                                _selectedComposingStatus = selected ? status : 'Yes';
                              });
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),

                      // Separate Waste Checkboxes
                      Text("Separate Waste"),
                      Wrap(
                        spacing: 10.0,
                        children: separateStatus.map((status) {
                          return ChoiceChip(
                            label: Text(status),
                            selected: _selectedSeperateStatus == status,
                            onSelected: (bool selected) {
                              setState(() {
                                _selectedSeperateStatus = selected ? status : 'Recycleable waste is separated';
                              });
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),

                      // Area Cleanliness Checkboxes
                      Text("Area Cleanliness"),
                      Wrap(
                        spacing: 10.0,
                        children: areaCleanliness.map((cleanliness) {
                          return ChoiceChip(
                            label: Text(cleanliness),
                            selected: _selectedAreaCleaninesss == cleanliness,
                            onSelected: (bool selected) {
                              setState(() {
                                _selectedAreaCleaninesss = selected ? cleanliness : 'Poor';
                              });
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 16),

                      // Smart Bin Updates Checkboxes
                      Text("Smart Bin Updates"),
                      Wrap(
                        spacing: 10.0,
                        children: smartBinUpdates.map((update) {
                          return ChoiceChip(
                            label: Text(update),
                            selected: _selectedSmartBinUpdates == update,
                            onSelected: (bool selected) {
                              setState(() {
                                _selectedSmartBinUpdates = selected ? update : 'Odor control';
                              });
                            },
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 32),

                      // Submit Button
                      Center(
                        child: ElevatedButton(
                          onPressed: _submitForm,
                          child: Text('Submit Analysis'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        DropdownButton<String>(
          isExpanded: true,
          value: value,
          icon: const Icon(Icons.arrow_drop_down),
          elevation: 16,
          onChanged: onChanged,
          items: items.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ],
    );
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      // Submit your form
      WasteAnalysis wasteAnalysis = WasteAnalysis(
        userType: _selectedUserType,
        binType: _selectedBinType,
        primaryWasteType: _selectedPrimaryWasteType,
        moderateWasteType: _selectedModerateWasteType,
        leastResidualType: _selectedLeastResidualType,
        wasteRemovingStatus: _selectedRemovingTime,
        wasteCollectionTime: _selectedCollectionTime,
        composingWasteStatus: _selectedComposingStatus,
        separateWaste: _selectedSeperateStatus,
        areaCleanliness: _selectedAreaCleaninesss,
        smartBinUpdate: _selectedSmartBinUpdates,
      );

      await _repository.createAnalysis(wasteAnalysis);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Analysis submitted successfully!')),
      );

      context.go('/inquiry');
      // Clear the form or navigate back
    }
  }
}
