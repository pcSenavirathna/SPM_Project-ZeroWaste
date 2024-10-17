import 'package:flutter/material.dart';

class UpdateNormalInquiryScreen extends StatefulWidget {
  final String inquiryID;

  const UpdateNormalInquiryScreen({Key? key, required this.inquiryID}) : super(key: key);

  @override
  State<UpdateNormalInquiryScreen> createState() => _UpdateNormalInquiryScreenState();
}

class _UpdateNormalInquiryScreenState extends State<UpdateNormalInquiryScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchInquiryData();
  }

  Future<void> _fetchInquiryData() async {
    // Fetch the inquiry data from Firestore using widget.inquiryID
    // Example Firestore code
    // var inquiryData = await FirebaseFirestore.instance.collection('inquiries').doc(widget.inquiryID).get();
    // Set the data in the controller
  }

  Future<void> _updateInquiry() async {
    if (_formKey.currentState!.validate()) {
      // Update Firestore with the new data from the form
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Update Normal Inquiry')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
                validator: (value) => value!.isEmpty ? 'Please enter a description' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateInquiry,
                child: Text('Update Inquiry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
