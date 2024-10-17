import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        elevation: 0,
        centerTitle: true,
        // Centers the title
        title: const Text(
          'Zero Waste',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart, color: Colors.white),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.account_circle, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        // Wrap with SingleChildScrollView
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Box
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Search your "Trash Type"',
                    prefixIcon: Icon(Icons.search, color: Colors.green),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Banner Carousel
              Container(
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  image: const DecorationImage(
                    image: AssetImage(
                        'assets/garbage.jpg'), // Replace with your banner image
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Category Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Category',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[700],
                    ),
                  ),
                  TextButton(onPressed: () {}, child: const Text('See All')),
                ],
              ),
              GridView(
                physics: const NeverScrollableScrollPhysics(),
                // Disable scroll inside the GridView
                shrinkWrap: true,
                // Allow GridView to shrink and fit content
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                children: [
                  _buildCategoryCard('Paper', Icons.book, Colors.orange),
                  _buildCategoryCard('Metals', Icons.hardware, Colors.grey),
                  _buildCategoryCard('Plastic', Icons.delete, Colors.blue),
                  _buildCategoryCard('Glass', Icons.wine_bar, Colors.teal),
                  _buildCategoryCard('E-Waste', Icons.tv, Colors.red),
                  _buildCategoryCard('Organic', Icons.eco, Colors.green),
                ],
              ),
              const SizedBox(height: 20),

              // Tips Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Tips',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[700],
                    ),
                  ),
                  TextButton(onPressed: () {}, child: const Text('More')),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.camera_alt, color: Colors.green),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Take photos of your trash to help us categorize it better!',
                        style:
                            TextStyle(color: Colors.green[700], fontSize: 16),
                      ),
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

  // Helper method to create category cards
  Widget _buildCategoryCard(String title, IconData icon, Color color) {
    return GestureDetector(
      onTap: () {
        // Navigate to respective category page
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 10),
            Text(title,
                style: TextStyle(color: Colors.green[700], fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
