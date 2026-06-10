import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:go_router/go_router.dart';
import 'appBar.dart';

class HomeScreen extends StatelessWidget {
  final List<Map<String, String>> categories = [
    {'name': 'Engines', 'image': 'assets/images/engine.png'},
    {'name': 'Wheels', 'image': 'assets/images/wheels.png'},
    {'name': 'Alternators', 'image': 'assets/images/alternators.png'},
    {'name': 'Lights', 'image': 'assets/images/lights.png'},
    {'name': 'Batteries', 'image': 'assets/images/batteries.png'},
    {'name': 'Chassis', 'image': 'assets/images/chassis.png'},
    {'name': 'Seats', 'image': 'assets/images/seats.png'},
    {'name': 'Accessories', 'image': 'assets/images/accessories.png'},
  ];

  @override
  Widget build(BuildContext context) {
    // Automatically request permissions when the home screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _requestPermissions();
    });

    return Scaffold(
      appBar: CustomAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // Two items per row
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return GestureDetector(
              onTap: () {
                context.push('/home2',
                    extra: category['name']); // Navigate to Home2 with category
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.yellow[100],
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          category['image']!,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        category['name']!,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _requestPermissions() async {
    await [
      Permission.storage,
      Permission.camera,
      Permission.photos, // For gallery access
    ].request();
  }
}
