import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';
import 'package:zero_waste/models/reward_item.dart';
import 'package:zero_waste/repositories/reward_item_repository.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});
  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final RewardItemRepository _repository = RewardItemRepository();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _pointsController = TextEditingController();
  final TextEditingController _imageController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String? _selectedItemId;

  void _showItemDialog({RewardItem? item}) {
    if (item != null) {
      _nameController.text = item.name;
      _pointsController.text = item.points.toString();
      _imageController.text = item.image;
      _descriptionController.text = item.description;
      _selectedItemId = item.id;
    } else {
      _nameController.clear();
      _pointsController.clear();
      _imageController.clear();
      _descriptionController.clear();
      _selectedItemId = null;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(item == null ? 'Add Item' : 'Update Item'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: _pointsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Points'),
              ),
              TextField(
                controller: _imageController,
                decoration: const InputDecoration(labelText: 'Image URL'),
              ),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (_nameController.text.isEmpty ||
                    _pointsController.text.isEmpty ||
                    _imageController.text.isEmpty ||
                    _descriptionController.text.isEmpty) {
                  return;
                }

                final item = RewardItem(
                  id: _selectedItemId ??
                      FirebaseFirestore.instance
                          .collection('reward_items')
                          .doc()
                          .id,
                  name: _nameController.text,
                  points: int.parse(_pointsController.text),
                  image: _imageController.text,
                  description: _descriptionController.text,
                );

                if (_selectedItemId == null) {
                  await _repository.addItem(item);
                } else {
                  await _repository.updateItem(item);
                }
                Navigator.of(context).pop();
              },
              child: Text(item == null ? 'Add' : 'Update'),
            ),
          ],
        );
      },
    );
  }

  void _deleteItem(String id) async {
    await _repository.deleteItem(id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.go('/home'),
        ),
        title: const Center(
          child: Text(
            'Admin Dashboard',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: Colors.green[800],
      ),
      body: StreamBuilder<List<RewardItem>>(
        stream: _repository.getItems(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final items = snapshot.data ?? [];

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return ListTile(
                leading: Image.network(item.image),
                title: Text(item.name),
                subtitle: Text('${item.points} points'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () => _showItemDialog(item: item),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () => _deleteItem(item.id),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showItemDialog(),
        backgroundColor: Colors.green[800],
        child: const Icon(Icons.add),
      ),
    );
  }
}
