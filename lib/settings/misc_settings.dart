import 'package:flutter/material.dart';

class MiscSettingsPage extends StatelessWidget {
  const MiscSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Misc. Settings")),
      body: ListView(
        scrollDirection: Axis.horizontal,  // Enable horizontal scrolling
        children: [
          Container(
            width: 3000,  // Width larger than the screen
            height: 500,  // Sufficient height
            color: Colors.blue,  // Just to visualize the container
          ),
          Container(
            width: 3000,  // Width larger than the screen
            height: 500,  // Sufficient height
            color: Colors.yellow,  // Just to visualize the container
          ),
        ],
      ),
    );
  }
}

//Settings for this page: Amount of Souls/Buttons Start, KeyRing settings, SilverPouches, Starting Clocks, Max Wallet Size, Ageless Items, Price Shuffle