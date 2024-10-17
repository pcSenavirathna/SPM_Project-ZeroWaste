import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zero_waste/models/inquiry.dart';
import 'package:zero_waste/repositories/inquiry_repository.dart';
import 'package:zero_waste/widgets/submit_button.dart';
import 'package:zero_waste/widgets/text_field_input.dart';

class InquiryAddScreen extends StatefulWidget {
  const InquiryAddScreen({super.key});

  @override
  State<StatefulWidget> createState() => _InquiryAddState();
}

class _InquiryAddState extends State<InquiryAddScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _inquiryID = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _personName = TextEditingController();
  final TextEditingController _smartbinID = TextEditingController();
  final TextEditingController _daysDelayed = TextEditingController();
  final TextEditingController _overflowingBinID = TextEditingController();
  final TextEditingController _wasteLocation = TextEditingController();
  final TextEditingController _wastetype = TextEditingController();
  final TextEditingController _desiredPickupDate = TextEditingController();
  final TextEditingController _inquiryDescription = TextEditingController();
  final TextEditingController _desiredSolution = TextEditingController();
  final TextEditingController _inquiryDate = TextEditingController();

  //Submit Inquiry
  void _submitForm(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      Inquiry entry = Inquiry(
        inquiryID: _inquiryID.text,
        email: _email.text,
        personName: _personName.text,
        smartbinID: _smartbinID.text,
        inquiryType: 'Normal Inquiry',
        daysDelayed: int.tryParse(_daysDelayed.text) ?? 0,  
        overflowingBinID: _overflowingBinID.text,
        wasteLocation: _wasteLocation.text,
        wastetype: _wastetype.text,
        desiredPickupDate: DateTime.tryParse(_desiredPickupDate.text) ?? DateTime.now(),  // Parsing DateTime
        inquiryDescription: _inquiryDescription.text,
        desiredSolution: _desiredSolution.text,
        inquiryDate: DateTime.now(),  
      );

      await InquiryRepository().createInquiry(entry);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Inquiry submitted Successfuly!')),
      );
     
    }
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
                    'Normal Inquiry Assistant',
                    style: TextStyle(
                      color: Colors.green, // Ensure this contrasts with the background
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0, // Reduced font size
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFieldInput(
                          title: "Inquiry ID",
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
                        TextFieldInput(
                          title: "Other Inquiry description",
                          icon: Icons.date_range,
                          controller: _inquiryDescription,
                          inputType: TextInputType.text,
                        ),
                        const SizedBox(height: 24),
                        TextFieldInput(
                          title: "Desired Solution",
                          icon: Icons.date_range,
                          controller: _desiredSolution,
                          inputType: TextInputType.text,
                        ),
                        const SizedBox(height: 24),
                        TextFieldInput(
                          title: "Inquiry Date",
                          icon: Icons.date_range,
                          controller: _inquiryDate,
                          inputType: TextInputType.datetime,
                        ),
                        const SizedBox(height: 24),
                        SubmitButton(
                          icon: Icons.send,
                          text: "Submit Normal Inquiry to the Authority",
                          whenPressed: _submitForm, 
                        ),
                      ],
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
