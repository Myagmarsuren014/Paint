import 'package:flutter/material.dart';

void main() {
  runApp(DrawingApp());
}

class DrawingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Drawing Section',
      home: DrawingScreen(),
    );
  }
}

class DrawingScreen extends StatefulWidget {
  @override
  _DrawingScreenState createState() => _DrawingScreenState();
}

class _DrawingScreenState extends State<DrawingScreen> {
  List<List<Offset>> points = [];
  Color selectedColor = Colors.black;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Drawing Section'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: () => setState(() => points.clear()),
          ),
        ],
      ),
      body: Container(
        color: Color.fromARGB(255, 255, 255, 255),
        child: Stack(
          children: [
            GestureDetector(
              onPanStart: (details) {
                setState(() {
                  points.add([details.localPosition]);
                });
              },
              onPanUpdate: (details) {
                setState(() {
                  if (points.isNotEmpty) {
                    points.last.add(details.localPosition);
                  }
                });
              },
              onPanEnd: (details) {
                setState(() {
                  points.add([]);
                });
              },
              child: CustomPaint(
                painter: _DrawingPainter(points, selectedColor),
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawingPainter extends CustomPainter {
  final List<List<Offset>> lines;
  final Color color;

  _DrawingPainter(this.lines, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    for (final line in lines) {
      if (line.length < 2) continue;
      for (int i = 0; i < line.length - 1; i++) {
        canvas.drawLine(
          line[i],
          line[i + 1],
          Paint()
            ..color = color
            ..isAntiAlias = true
            ..strokeWidth = 5.0
            ..strokeCap = StrokeCap.round,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
