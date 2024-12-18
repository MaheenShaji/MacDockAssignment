import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

/// Main application entry point
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: DraggableDock(
            items: const [
              Icons.person,
              Icons.message,
              Icons.call,
              Icons.camera,
              Icons.photo,
            ],
          ),
        ),
      ),
    );
  }
}

/// Draggable Dock Widget
class DraggableDock extends StatefulWidget {
  final List<IconData> items;

  const DraggableDock({super.key, required this.items});

  @override
  _DraggableDockState createState() => _DraggableDockState();
}

class _DraggableDockState extends State<DraggableDock> {
  List<IconData> _dockItems = [];

  @override
  void initState() {
    super.initState();
    _dockItems = List.from(widget.items);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      color: Colors.grey.shade200,
      height: 100,
      child: Row(
        mainAxisSize: MainAxisSize.min, // Ensures that Row doesn't stretch
        children: List.generate(_dockItems.length, (index) {
          return DragTarget<IconData>(
            onAccept: (icon) {
              setState(() {
                _dockItems.remove(icon);
                _dockItems.insert(index, icon);
              });
            },
            builder: (context, candidateData, rejectedData) {
              return Draggable<IconData>(
                data: _dockItems[index],
                feedback: Material(
                  color: Colors.transparent,
                  child: _buildIconContainer(_dockItems[index]),
                ),
                childWhenDragging: Opacity(
                  opacity: 0.5,
                  child: _buildIconContainer(_dockItems[index]),
                ),
                child: AnimatedPositioned(
                  duration: const Duration(milliseconds: 300),
                  left: _dockItems.indexOf(_dockItems[index]) * 50.0, // Adjust the left position for animation
                  child: _buildIconContainer(_dockItems[index]),
                ),
              );
            },
          );
        }),
      ),
    );
  }

  Widget _buildIconContainer(IconData icon) {
    final color =
        Colors.primaries[icon.hashCode % Colors.primaries.length]; // Icon color
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: Colors.white, size: 30),
    );
  }
}
