import 'package:flutter/material.dart';

class EntryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            child: Container(
              color: Colors.blue[100],
              child: Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Add action for left button
                  },
                  child: Text('What to Eat'),
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.green[100],
              child: Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Add action for right button
                  },
                  child: Text('Where to Eat'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
