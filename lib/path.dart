import 'package:flutter/material.dart';

void main() {
  runApp(MapApp());
}

class MapApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: IndoorMap(),
    );
  }
}

class IndoorMap extends StatefulWidget {
  @override
  _IndoorMapState createState() => _IndoorMapState();
}

class _IndoorMapState extends State<IndoorMap> {
  double _scale = 1.0; // Store the current scale

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Indoor Map'),
      ),
      body: GestureDetector(
        onScaleUpdate: (details) {
          setState(() {
            // Update the scale factor
            _scale = details.scale;
          });
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.purple,
                Colors.black,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Transform.scale(
              scale: _scale, // Apply the scale factor
              child: Stack(
                children: [
                  // Display the indoor map image as the background
                  Image.asset(
                    'assets/indoor_map.png',
                    width: 800.0,
                    height: 600.0,
                    fit: BoxFit.contain,
                  ),
                  // Markers and paths go here
                  Positioned(
                    left: 20, // X-coordinate
                    top: 195, // Y-coordinate
                    child: Container(
                      height: 0, // Adjust the height of the marker
                      child: Icon(
                        Icons.location_on,
                        color: Colors.green,
                        size: 40,
                      ),
                    ),
                  ),

                  Positioned(
                    left: 100, // X-coordinate
                    top: 100, // Y-coordinate
                    child: Container(
                      height: 0, // Adjust the height of the marker
                      child: Icon(
                        Icons.podcasts,
                        color: Colors.red,
                        size: 20,
                      ),
                    ),
                  ),

                  Positioned(
                    left: 170, // X-coordinate
                    top: 240, // Y-coordinate
                    child: Container(
                      height: 0, // Adjust the height of the marker
                      child: Icon(
                        Icons.podcasts,
                        color: Colors.red,
                        size: 20,
                      ),
                    ),
                  ),

                  Positioned(
                    left: 155, // X-coordinate
                    top: 270, // Y-coordinate
                    child: Container(
                      height: 0, // Adjust the height of the marker
                      child: Icon(
                        Icons.podcasts,
                        color: Colors.red,
                        size: 20,
                      ),
                    ),
                  ),

                  CustomPaint(
                    painter: PathPainter(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PathPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final path1 = Path();
    final path2 = Path();
    final path3 = Path();

    // Define your path coordinates here using moveTo and lineTo methods
    path1.moveTo(40, 235);
    path1.lineTo(80, 225);
    path1.lineTo(128, 225);
    path1.lineTo(128, 305);
    path1.lineTo(200, 305);
    path1.lineTo(200, 285);
    path1.lineTo(287, 285);
    path1.lineTo(287, 235);

    //path.moveTo(345, 332);

    //path2
    path2.moveTo(40, 235);
    path2.lineTo(80, 225);
    path2.lineTo(128, 225);
    path2.lineTo(128, 305);
    path2.lineTo(200, 305);
    path2.lineTo(200, 332);
    path2.lineTo(345, 332);
    path2.lineTo(345, 230);
    path2.lineTo(345, 332);

    //path3
    path3.moveTo(40, 235);
    path3.lineTo(70, 235);
    path3.lineTo(70, 290);
    path3.lineTo(85, 328);
    path3.lineTo(128, 328);

    // Draw the path
    canvas.drawPath(path1, paint);
    canvas.drawPath(path2, paint);
    canvas.drawPath(path3, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
