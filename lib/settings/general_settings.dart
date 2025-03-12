import 'package:flutter/material.dart';
import 'package:ootmmgenerator/shared/shared.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: "Settings",
      child: Center(child: Text("Settings Page")),
    );
  }
}

//Settings for this page: Dropdown for differnet modes, Adult in MM, Shared Items, Item Pool, Mode, Players, Teams, Distinct Words, Min Settings, Max Settings, Hard Mode Limit