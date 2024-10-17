import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateBinAndPickupScreen extends StatefulWidget {
  final String inquiryID;

  const UpdateBinAndPickupScreen({Key? key, required this.inquiryID}) : super(key: key);

  @override
  State<UpdateBinAndPickupScreen> createState() => _UpdateBinAndPickupScreenState();
}

class _UpdateBinAndPickupScreenState extends State<UpdateBinAndPickupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _daysDelayedController = TextEditingController();
  final TextEditingController _overflowingBinIDController = TextEditingController();
  final TextEditingController _wasteLocationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _desiredSolutionController = TextEditingController();

  // Read-only information
  String email = '';
  String personName = '';
  String inquiryType = '';
  String inquiryDate = '';

  @override
  void initState() {
    super.initState();
    _fetchInquiryData();
  }

  Future<void> _fetchInquiryData() async {
    try {
      DocumentSnapshot inquirySnapshot = await FirebaseFirestore.instance
          .collection('inquiries')
          .doc(widget.inquiryID)
          .get();

      if (inquirySnapshot.exists) {
        var data = inquirySnapshot.data() as Map<String, dynamic>;

        // Populate text fields and other details with the fetched data
        setState(() {
          email = data['email'] ?? '';
          personName = data['personName'] ?? '';
          inquiryType = data['inquiryType'] ?? '';
          inquiryDate = data['inquiryDate'] ?? '';

          _daysDelayedController.text = data['daysDelayed']?.toString() ?? '';
          _overflowingBinIDController.text = data['overflowingBinID'] ?? '';
          _wasteLocationController.text = data['wasteLocation'] ?? '';
          _descriptionController.text = data['description'] ?? '';
          _desiredSolutionController.text = data['desiredSolution'] ?? '';
        });
      }
    } catch (e) {
      print('Error fetching inquiry data: $e');
    }
  }

  Future<void> _updateInquiry() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseFirestore.instance
            .collection('inquiries')
            .doc(widget.inquiryID)
            .update({
          'daysDelayed': _daysDelayedController.text,
          'overflowingBinID': _overflowingBinIDController.text,
          'wasteLocation': _wasteLocationController.text,
          'description': _descriptionController.text,
          'desiredSolution': _desiredSolutionController.text,
        });

        // Pop the screen after a successful update
        Navigator.pop(context);
      } catch (e) {
        print('Error updating inquiry: $e');
      }
    }
  }

  @override
  void dispose() {
    _daysDelayedController.dispose();
    _overflowingBinIDController.dispose();
    _wasteLocationController.dispose();
    _descriptionController.dispose();
    _desiredSolutionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Update Bin and Pickup Inquiry')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display read-only details
              Text("Inquiry ID: ${widget.inquiryID}"),
              Text("Email: $email"),
              Text("Person Name: $personName"),
              Text("Inquiry Type: $inquiryType"),
              Text("Inquiry Date: $inquiryDate"),
              SizedBox(height: 20),

              // Form for updatable fields
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _daysDelayedController,
                      decoration: InputDecoration(labelText: 'Days Delayed'),
                      validator: (value) => value!.isEmpty ? 'Please enter days delayed' : null,
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _overflowingBinIDController,
                      decoration: InputDecoration(labelText: 'Overflowing Bin ID'),
                      validator: (value) => value!.isEmpty ? 'Please enter bin ID' : null,
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _wasteLocationController,
                      decoration: InputDecoration(labelText: 'Waste Location'),
                      validator: (value) => value!.isEmpty ? 'Please enter waste location' : null,
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(labelText: 'Description'),
                      validator: (value) => value!.isEmpty ? 'Please enter a description' : null,
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      controller: _desiredSolutionController,
                      decoration: InputDecoration(labelText: 'Desired Solution'),
                      validator: (value) => value!.isEmpty ? 'Please enter a desired solution' : null,
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _updateInquiry,
                      child: Text('Update Inquiry'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// like this,  in UpdateNormalInquiriesScreen show only inquiryDescription, desiredSolution in form fields while  inquiryId, email, personName, inquirytype, inquiryDate should be displyed like a normal text above the form.And the oage UpdateExtraTrashPickupScreen should only display wasteType, desiredPickupDate, inquiryDescription in fields and other details inquiryId, email, personName, inquirytype, inquiryDate should be displyed like a normal text above the form.