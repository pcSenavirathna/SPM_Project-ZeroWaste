import 'package:flutter/material.dart';
import 'package:zero_waste/repositories/waste_analysis_repository.dart'; // Import the repository
import 'package:zero_waste/models/waste_analysis.dart'; // Import the model

class AllAnalysisScreen extends StatefulWidget {
  const AllAnalysisScreen({super.key});

  @override
  State<StatefulWidget> createState() => _AllAnalysisScreenState();
}

class _AllAnalysisScreenState extends State<AllAnalysisScreen> {
  final WasteAnalysisRepository _wasteAnalysisRepository = WasteAnalysisRepository();
  List<WasteAnalysis> _analyses = [];
  int _householdUserCount = 0;

  @override
  void initState() {
    super.initState();
    _fetchAllAnalyses();
  }

  // Fetch all analyses and count household users
  Future<void> _fetchAllAnalyses() async {
    try {
      _analyses = await _wasteAnalysisRepository.getAllAnalyses();
      _householdUserCount = _countHouseholdUsers();
      setState(() {});
    } catch (e) {
      // Handle error (e.g., show a Snackbar or alert)
      print('Error fetching analyses: $e');
    }
  }

  // Count number of analyses with userType 'Household user'
  int _countHouseholdUsers() {
    return _analyses.where((analysis) => analysis.userType == 'Household user').length;
  }
  

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
        child: SafeArea(
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
                  titlePadding: EdgeInsets.only(left: 80.0, bottom: 16.0),
                  title: Text(
                    'Extra Trash Pickup Assistant',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    children: [
                      // Display total records
                      Text(
                        'Total Records: ${_analyses.length}',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      // Display household user count
                      Text(
                        'Household Users: $_householdUserCount',
                        style: TextStyle(fontSize: 12), // Smaller font size for the subtopic
                      ),
                      // Add more UI elements as needed
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
