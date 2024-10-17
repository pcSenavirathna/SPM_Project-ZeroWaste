import 'package:flutter/material.dart';

class UpdateExtraTrashInquiriesScreen extends StatefulWidget {
  final String inquiryID;

  const UpdateExtraTrashInquiriesScreen({Key? key, required this.inquiryID}) : super(key: key);

  @override
  State<UpdateExtraTrashInquiriesScreen> createState() => _UpdateExtraTrashInquiriesScreenState();
}

class _UpdateExtraTrashInquiriesScreenState extends State<UpdateExtraTrashInquiriesScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _additionalInfoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchInquiryData();
  }

  Future<void> _fetchInquiryData() async {
    // Fetch data based on inquiryID
  }

  Future<void> _updateInquiry() async {
    if (_formKey.currentState!.validate()) {
      // Update inquiry in Firestore
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Update Extra Trash Inquiry')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _additionalInfoController,
                decoration: InputDecoration(labelText: 'Additional Information'),
                validator: (value) => value!.isEmpty ? 'Please enter additional info' : null,
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
