import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:zero_waste/models/garbage_entry.dart';
import 'package:zero_waste/repositories/garbage_entry_repository.dart';
import 'package:zero_waste/repositories/rewards_repository.dart';
import 'package:zero_waste/screens/garbageCollection/edit_entry_screen.dart';

class UserHistoryScreen extends StatefulWidget {
  const UserHistoryScreen({super.key});

  @override
  State<UserHistoryScreen> createState() => _UserHistoryScreenState();
}

class _UserHistoryScreenState extends State<UserHistoryScreen> {
  String _searchTerm = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            context.go('/home');
          },
        ),
        title: const Text('User History'),
        foregroundColor: Colors.white,
        backgroundColor: Colors.green.shade700,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search by User ID',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchTerm = value;
                });
              },
            ),
          ),
        ),
      ),
      body: StreamBuilder(
        stream:
            FirebaseFirestore.instance.collection('garbageEntries').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          var entries = snapshot.data!.docs
              .map((doc) => GarbageEntry.fromDocument(doc))
              .where((entry) =>
                  entry.userId.contains(_searchTerm))
              .toList();

          if (entries.isEmpty) {
            return const Center(child: Text('No entries found'));
          }

          return ListView.builder(
            itemCount: entries.length,
            itemBuilder: (context, index) {
              var entry = entries[index];

              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'User ID: ${entry.userId}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade800,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Divider(),
                        Row(
                          children: [
                            _buildWasteInfo(
                                icon: Icons.local_drink,
                                label: 'Plastic',
                                value: entry.plasticWeight),
                            _buildWasteInfo(
                                icon: Icons.wine_bar,
                                label: 'Glass',
                                value: entry.glassWeight),
                            _buildWasteInfo(
                                icon: Icons.article,
                                label: 'Paper',
                                value: entry.paperWeight),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            _buildWasteInfo(
                                icon: Icons.grass,
                                label: 'Organic',
                                value: entry.organicWeight),
                            _buildWasteInfo(
                                icon: Icons.home_repair_service,
                                label: 'Metal',
                                value: entry.metalWeight),
                            _buildWasteInfo(
                                icon: Icons.memory,
                                label: 'E-Waste',
                                value: entry.eWasteWeight),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            'Date: ${DateFormat.yMMMd().format(entry.date)}',
                            style: TextStyle(
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.green),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        EditEntryScreen(entry: entry),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                _showDeleteConfirmation(context, entry.id);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildWasteInfo({
    required IconData icon,
    required String label,
    required double value,
  }) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, color: Colors.green, size: 30),
          const SizedBox(height: 4),
          Text(
            '$value kg',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }


  void _showDeleteConfirmation(BuildContext context, String entryId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Entry'),
          content: const Text('Are you sure you want to delete this entry?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _deleteEntry(entryId);
                Navigator.pop(context);
              },
              child: const Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  void _deleteEntry(String entryId) async {
    await GarbageEntryRepository().deleteEntry(entryId).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Entry deleted successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting entry: $error')),
      );
    });
  }
}
