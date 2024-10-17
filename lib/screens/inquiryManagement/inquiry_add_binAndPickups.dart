import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zero_waste/models/inquiry.dart';
import 'package:zero_waste/repositories/inquiry_repository.dart';
import 'package:zero_waste/widgets/submit_button.dart';
import 'package:zero_waste/widgets/text_field_input.dart';

class InquiryAddBinCollectionIssuesScreen extends StatefulWidget {
  const InquiryAddBinCollectionIssuesScreen({super.key});

  @override
  State<StatefulWidget> createState() => _InquiryAddBinCollectionIssuesState();
}

class _InquiryAddBinCollectionIssuesState extends State<InquiryAddBinCollectionIssuesScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _inquiryID = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _personName = TextEditingController();
  final TextEditingController _smartbinID = TextEditingController();
  final TextEditingController _inquiryType = TextEditingController();
  final TextEditingController _daysDelayed = TextEditingController();
  final TextEditingController _overflowingBinID = TextEditingController();
  final TextEditingController _wasteLocation = TextEditingController();
  final TextEditingController _wastetype = TextEditingController();
  final TextEditingController _desiredPickupDate = TextEditingController();
  final TextEditingController _inquiryDescription = TextEditingController();
  final TextEditingController _desiredSolution = TextEditingController();
  final TextEditingController _inquiryDate = TextEditingController();

  String _selectedInquiryTypes = 'Overflowing bin issues'; // Initial value

  final List<String> inquiryTypes = ['Overflowing bin issues', 'Illegal Garbage Dumps'];

  // Submit Inquiry
  void _submitForm(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      Inquiry entry = Inquiry(
        inquiryID: _inquiryID.text,
        email: _email.text,
        personName: _personName.text,
        smartbinID: _smartbinID.text,
        inquiryType: _selectedInquiryTypes,
        daysDelayed: int.tryParse(_daysDelayed.text) ?? 0,
        overflowingBinID: _overflowingBinID.text,
        wasteLocation: _wasteLocation.text,
        wastetype: _wastetype.text,
        desiredPickupDate: DateTime.tryParse(_desiredPickupDate.text) ?? DateTime.now(), // Parsing DateTime
        inquiryDescription: _inquiryDescription.text,
        desiredSolution: _desiredSolution.text,
        inquiryDate: DateTime.now(),
      );

      await InquiryRepository().createInquiry(entry);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Collection issue was collected by assistant!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient( // Changed to gradient for a better visual effect
            colors: [
              Color.fromARGB(255, 152, 225, 154),
              Colors.white,
            ],
            begin: Alignment.topLeft, // You can adjust the direction of the gradient
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 150.0, // Reduced height
                floating: false,
                pinned: true,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white), // Adjusted color for better visibility
                  onPressed: () {
                    context.go('/inquiry'); // Navigate back to home
                  },
                ),
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: EdgeInsets.only(left: 80.0, bottom: 16.0), // Adjusted padding
                  title: Text(
                    'Smart Bin and Waste Collection Schedules Issue Assistant',
                    style: TextStyle(
                      color: Colors.green, // Ensure this contrasts with the background
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0, // Reduced font size
                    ),
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Center(
                  child: Container(
                    constraints: BoxConstraints(maxWidth: 1300), // Adjust maxWidth as needed
                    padding: const EdgeInsets.symmetric(horizontal: 16.0), // More space on left and right
                    child: Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TextFieldInput(
                              title: "Your inquiryID",
                              icon: Icons.send,
                              controller: _inquiryID,
                              inputType: TextInputType.text,
                            ),
                            const SizedBox(height: 14),
                            TextFieldInput(
                              title: "Person Name",
                              icon: Icons.person,
                              controller: _personName,
                              inputType: TextInputType.text,
                            ),
                            const SizedBox(height: 14),
                            TextFieldInput(
                              title: "Email",
                              icon: Icons.email,
                              controller: _email,
                              inputType: TextInputType.text,
                            ),
                            const SizedBox(height: 14),
                            TextFieldInput(
                              title: "Smart bin ID",
                              icon: Icons.person,
                              controller: _smartbinID,
                              inputType: TextInputType.text,
                            ),
                            const SizedBox(height: 14),
                            DropdownButtonFormField<String>( // Dropdown button
                              decoration: InputDecoration(
                                labelText: "Inquiry Type",
                                prefixIcon: const Icon(Icons.category),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                              value: _selectedInquiryTypes,
                              items: inquiryTypes.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  _selectedInquiryTypes = newValue!;
                                });
                              },
                            ),
                            const SizedBox(height: 14),
                            TextFieldInput(
                              title: "No of days pickup delayed",
                              icon: Icons.date_range,
                              controller: _daysDelayed,
                              inputType: TextInputType.number, // Use number for day input
                            ),
                            const SizedBox(height: 14),
                            TextFieldInput(
                              title: "Overflowing Bin ID",
                              icon: Icons.description,
                              controller: _overflowingBinID,
                              inputType: TextInputType.text,
                            ),
                            const SizedBox(height: 14),
                            TextFieldInput(
                              title: "Waste location if garbage is not near your smart bin",
                              icon: Icons.location_on,
                              controller: _wasteLocation,
                              inputType: TextInputType.text,
                            ),
                            const SizedBox(height: 14),
                            TextFieldInput(
                              title: "Other Inquiry description",
                              icon: Icons.description,
                              controller: _inquiryDescription,
                              inputType: TextInputType.text,
                            ),
                            const SizedBox(height: 24),
                            TextFieldInput(
                              title: "Desired Solution",
                              icon: Icons.request_page,
                              controller: _desiredSolution,
                              inputType: TextInputType.text,
                            ),
                            const SizedBox(height: 24),
                            TextFieldInput(
                              title: "Inquiry Date",
                              icon: Icons.calendar_today,
                              controller: _inquiryDate,
                              inputType: TextInputType.datetime,
                            ),
                            const SizedBox(height: 24),
                            SubmitButton(
                              icon: Icons.send,
                              text: "Submit Smart Bin issue",
                              whenPressed: _submitForm 
                            ),
                          ],
                        ),
                      ),
                    ),
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
