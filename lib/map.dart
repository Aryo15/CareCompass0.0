import 'dart:async';
import 'dart:math'; // Import dart:math for Random class

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Indoor Tracking Simulation',
      home: IndoorMap(),
    );
  }
}

class IndoorMap extends StatefulWidget {
  @override
  _IndoorMapState createState() => _IndoorMapState();
}

class _IndoorMapState extends State<IndoorMap> {
  double userX = 100; // Initial user X-coordinate
  double userY = 100; // Initial user Y-coordinate

  @override
  void initState() {
    super.initState();
    // Simulate user movement by updating coordinates periodically
    startSimulation();
  }

  void startSimulation() {
    // Simulate user movement every 2 seconds
    Timer.periodic(Duration(seconds: 2), (timer) {
      // Generate random movement (for simulation purposes)
      final random = Random();
      final deltaX = random.nextDouble() * 50 - 25; // Random X movement
      final deltaY = random.nextDouble() * 50 - 25; // Random Y movement

      setState(() {
        // Update user's position
        userX += deltaX;
        userY += deltaY;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Indoor Tracking Simulation'),
      ),
      body: Center(
        child: Stack(
          children: [
            // Display the indoor map (replace with your map image)
            Image.asset(
              'assets/2D_hospital_map.png',
              width: 400, // Adjust the width as needed
              height: 400, // Adjust the height as needed
              fit: BoxFit.contain,
            ),
            // Display the user's position (simulate with a red dot)
            Positioned(
              left: userX,
              top: userY,
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
