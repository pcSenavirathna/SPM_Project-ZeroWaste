import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:zero_waste/models/inquiry.dart';
import 'package:zero_waste/repositories/inquiry_repository.dart';

class InquiryViewScreen extends StatefulWidget {
  const InquiryViewScreen({super.key});

  @override
  State<StatefulWidget> createState() => _InquiryViewState();
}

class _InquiryViewState extends State<InquiryViewScreen> {
  final InquiryRepository _inquiryRepository = InquiryRepository();

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
                  context.go('/inquiry');
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
                        'All Inquiries',
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.0,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        'Inquiries Categorized by Type',
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
            _buildInquirySection('Normal Inquiry', 'Normal Inquiries'),
            _buildInquirySection('Extra Trash Pickups', 'Extra Trash Pickups Inquiries'),
            _buildInquirySection('Overflowing bin issues', 'Overflowing Bin Issues Inquiries'),
            _buildInquirySection('Illegal Garbage Dumps', 'Illegal Garbage Dumps Inquiries'),
          ],
        ),
      ),
    );
  }

  SliverList _buildInquirySection(String inquiryType, String sectionTitle) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return FutureBuilder<QuerySnapshot>(
            future: FirebaseFirestore.instance
                .collection('inquiries')
                .where('inquiryType', isEqualTo: inquiryType)
                .get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Center(child: Text('No $sectionTitle Found')),
                );
              }

              List<DocumentSnapshot> inquiries = snapshot.data!.docs;

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      sectionTitle,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: inquiries.length,
                    itemBuilder: (context, index) {
                      var inquiry = Inquiry.fromDocument(inquiries[index]);
                      String docId = inquiries[index].id;

                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: ListTile(
                          title: Text(inquiry.inquiryID),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('ID: ${inquiry.inquiryID}'),
                              Text('Email: ${inquiry.email}'),
                              Text('Smartbin ID: ${inquiry.smartbinID}'),
                              Text('Contact Personal Name: ${inquiry.personName}'),
                              Text('Desired Solution: ${inquiry.desiredSolution}'),
                              Text('Date: ${inquiry.inquiryDate.toString()}'),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  _navigateToUpdatePage(context, inquiryType, inquiry.inquiryID);
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () async {
                                  _showDeleteConfirmationDialog(context, docId); // Pass docId here
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          );
        },
        childCount: 1,
      ),
    );
  }

  void _navigateToUpdatePage(BuildContext context, String inquiryType, String docId) {
    switch (inquiryType) {
      case 'Normal Inquiry':
        context.go('/inquiry/u_normal_inquiry/$docId');
        break;
      case 'Extra Trash Pickups':
        context.go('/inquiry/u_extra_trash_inquiry/$docId');
        break;
      case 'Overflowing bin issues':
        context.go('/inquiry/u_pickup_inquiry/$docId');
        break;
      case 'Illegal Garbage Dumps':
        context.go('/inquiry/u_pickup_inquiry/$docId');
        break;
      default:
        break;
    }
  }

  void _showDeleteConfirmationDialog(BuildContext context, String docId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Inquiry'),
          content: Text('Are you sure you want to delete this inquiry?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await _inquiryRepository.deleteInquiry(docId); // Use docId for deletion
                setState(() {});
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
