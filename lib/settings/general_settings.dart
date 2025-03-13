import 'package:flutter/material.dart';
import 'package:ootmmgenerator/shared/shared.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:async';


class MainSettingsPage extends StatelessWidget {
  const MainSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: "Main Settings",
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: 1890,
              child: Column(
                children: [
                  Container(height: 3, color: Theme.of(context).colorScheme.inversePrimary),
                  Container(
                    color: Theme.of(context).colorScheme.inversePrimary.withValues(alpha: 0.4),
                    width: 1890,
                    height: 35,
                    alignment: Alignment.center,
                    child: Text(
                      'General Settings',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  WinConSettings(),
                  PiecesRequired(),
                  SettingsAmount(),
                  MMAdultSettings(),
                  SharedItemsSettings(),
                  ItemPoolSettings(),
                  MultiplayerSettings(),
                  PlayerCount(),
                  DistinctWorldsSettings(),
                  PresetSettings(),
                ]
              )
            ),
          )
        )
      )
    );
  }
}

abstract class MainWeightSettingsState<T extends StatefulWidget> extends State<T> {
  late Map<String, dynamic> mainWeights;
  final Map<String, MainWeightOption> mainWeightKeys;

  MainWeightSettingsState(this.mainWeightKeys);

  late File _settingsFile;
  Timer? _saveDelayTimer; // Timer to manage the delay

  @override
  void initState() {
    super.initState();
    mainWeights = {
      for (var key in mainWeightKeys.keys) 
        key: mainWeightKeys[key]?.options == null 
          ? 1 // Default to 1 for integer settings
          : mainWeightKeys[key]!.options!.first // Default to the first option for dropdown settings
    };
    _initFile();
  }


  /// Initialize the settings file
  Future<void> _initFile() async {
    final dir = Directory.current;
    _settingsFile = File('${dir.path}/persistent_settings.json');

    if (await _settingsFile.exists()) {
      _loadWeights(); // Load weights if the file exists
    } else {
      await _createDefaultFile(); // Create the default file if it doesn't exist
    }
  }

  /// Create a new default file with initial weights if the file doesn't exist
  Future<void> _createDefaultFile() async {
    try {
      await _settingsFile.create();
      Map<String, int> defaultWeights = {};
      String jsonContent = jsonEncode(defaultWeights);
      await _settingsFile.writeAsString(jsonContent);
    } catch (e) {
      print("Error creating settings file: $e");
    }
  }

  /// Load weights from the settings file
  Future<void> _loadWeights() async {
    try {
      String content = await _settingsFile.readAsString();
      if (content.isEmpty) {
        await _createDefaultFile(); // Create a default file if the file is empty
        return;
      }

      Map<String, dynamic> jsonData = jsonDecode(content);
      setState(() {
        for (var key in mainWeightKeys.keys) {
          String internalKey = mainWeightKeys[key]?.internalName ?? '';
          if (internalKey.isNotEmpty && jsonData.containsKey(internalKey)) {
            mainWeights[key] = jsonData[internalKey] ?? 1;
          } else {
            mainWeights[key] = 1;
          }
        }
      });
    } catch (e) {
      print("Error loading settings: $e");
    }
  }

  Future<void> _saveWeights() async {
    try {
      String content = await _settingsFile.readAsString();
      Map<String, dynamic> jsonData = jsonDecode(content);

      for (var entry in mainWeights.entries) {
        String internalKey = mainWeightKeys[entry.key]?.internalName ?? '';
        if (internalKey.isNotEmpty) {
          jsonData[internalKey] = entry.value; // Save as String for dropdown options
        }
      }

      String jsonContent = jsonEncode(jsonData);
      await _settingsFile.writeAsString(jsonContent);
    } catch (e) {
      print("Error saving settings: $e");
    }
  }


  /// Change item weight and save to file without overwriting everything
  void changeWeight(String key, int delta) {
    setState(() {
      mainWeights[key] = (mainWeights[key]! + delta).clamp(0, double.infinity).toInt();
    });
    _saveWeights();
  }

  Widget buildWeightSelector(String label, String key) {
    return Row(
      children: [
        Tooltip(
          message: mainWeightKeys[key]!.description,
          waitDuration: Duration(milliseconds: 500),
          child: SizedBox(
            width: 100,
            child: Text(
              '$label: ',
              textAlign: TextAlign.right
            ),
          ),
        ),
        IconButton(
          icon: Icon(Icons.remove),
          onPressed: () => changeWeight(key, -1),
        ),
        SizedBox(
          width: 50,
          child: TextField(
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            controller: TextEditingController(text: mainWeights[key].toString()),
            onChanged: (value) {
              // Cancel the previous delayed save if it's still active
              _saveDelayTimer?.cancel();

              // Start a new delayed save
              _saveDelayTimer = Timer(Duration(seconds: 1), () {
                setState(() {
                  int? newValue = int.tryParse(value);
                  if (newValue != null && newValue >= 0) {
                    mainWeights[key] = newValue;
                  }
                });
                _saveWeights();
              });
            },
            decoration: InputDecoration(border: OutlineInputBorder()),
          ),
        ),
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () => changeWeight(key, 1),
        ),
        SizedBox(width: 5),
      ],
    );
  }

  Widget buildSettingsUI(String title, List<String> keys) {
    return Column(
      children: [
        Container(height: 1, color: Theme.of(context).colorScheme.inversePrimary.withAlpha(100)),
        SizedBox(height: 5),
        Row(
          children: [
            SizedBox(width: 10),
            SizedBox(
              width: 100,
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.w600, color: Theme.of(context).colorScheme.primary),
              ),
            ),
            SizedBox(width: 10),
            Row(
              children: keys.map((key) {
                // Check if the key value is a number or a dropdown
                if (mainWeightKeys[key]?.options == null) {
                  // If options are null, it's an integer value, use Weight Selector
                  return buildWeightSelector(key, key);
                } else {
                  // If options are not null, use Dropdown Selector
                  return buildDropdownSelector(key, key);
                }
              }).toList(),
            )
          ],
        ),
        SizedBox(height: 5),
      ],
    );
  }

  String getDropdownValue(String key) {
  var value = mainWeights[key];

  // If the value is not set or not a valid option, return the first option
  if (value == null || value is! String || !mainWeightKeys[key]!.options!.contains(value)) {
    return mainWeightKeys[key]!.options!.first; // Default to the first option
  }

  return value;
}


  Widget buildDropdownSelector(String label, String key) {
    return Row(
      children: [
        Tooltip(
          message: mainWeightKeys[key]!.description,
          waitDuration: Duration(milliseconds: 500),
          child: SizedBox(
            width: 100,
            child: Text(
              '$label: ',
              textAlign: TextAlign.right,
            ),
          ),
        ),
        DropdownButton<String>(
          value: getDropdownValue(key), // Call the function to ensure a valid value
          onChanged: (newValue) {
            if (newValue != null) {
              setState(() {
                mainWeights[key] = newValue; // Store as string
              });
              _saveWeights();
            }
          },
          alignment: Alignment.centerRight,  // Align text to the right in the dropdown button
          items: mainWeightKeys[key]!.options!.map((option) {
            return DropdownMenuItem<String>(
              value: option,
              child: SizedBox(
                width: 100,
                child: Align(
                  alignment: Alignment.centerRight, // Align text to the right in the dropdown options
                  child: Text(option),
                ),
              ),
            );
          }).toList(),
        ),
        SizedBox(width: 5),
      ],
    );
  }

}

// Helper class to store weight key and description
class MainWeightOption {
  final String internalName;
  final String description;
  final List<String>? options; // New field for dropdown options
  final Map<String, String>? optionToInternalMap;
  final dynamic defaultValue;

  MainWeightOption(this.internalName, this.description, {this.options, this.optionToInternalMap, this.defaultValue});
}


// SettingsAmount
class SettingsAmount extends StatefulWidget {
  const SettingsAmount({super.key});

  @override
  SettingsAmountState createState() => SettingsAmountState();
}

class SettingsAmountState extends MainWeightSettingsState<SettingsAmount> {
  SettingsAmountState()
      : super({
        "Minimum": MainWeightOption('minSettingsAmount', "Minimum number of settings"),
        "Maximum": MainWeightOption('maxSettingsAmount', "Maximum number of settings"),
        "Hard Maximum": MainWeightOption('hardModeLimit', "Maximum Amount of Hard Settings you will see")
      });

  @override
  Widget build(BuildContext context) {
    return buildSettingsUI('Settings Amount', mainWeightKeys.keys.toList());
  }
}

//  Multiplayer Settings
class MultiplayerSettings extends StatefulWidget {
  const MultiplayerSettings({super.key});

  @override
  MultiplayerSettingsState createState() => MultiplayerSettingsState();
}

class MultiplayerSettingsState extends MainWeightSettingsState<MultiplayerSettings> {
  MultiplayerSettingsState()
      : super({
        "Mode": MainWeightOption('multiMode', 'Choose whether you are solo, coop or multiworld', options: ['single', 'coop', 'multi'], defaultValue: 'solo'),
      });

  @override
  Widget build(BuildContext context) {
    return buildSettingsUI('Mode', mainWeightKeys.keys.toList());
  }
}

//  Multiplayer Settings
class PlayerCount extends StatefulWidget {
  const PlayerCount({super.key});

  @override
  PlayerCountState createState() => PlayerCountState();
}

class PlayerCountState extends MainWeightSettingsState<PlayerCount> {
  PlayerCountState()
      : super({
        "Player Count": MainWeightOption('playerCount', 'If a multiplayer game, how many players are there'),
        "Team Count": MainWeightOption('teamCount', "Amount of Teams in Multiplayer"),
      });

  @override
  Widget build(BuildContext context) {
    return buildSettingsUI('Multiplayer Settings', mainWeightKeys.keys.toList());
  }
}

//  Distinct Worlds Settings
class DistinctWorldsSettings extends StatefulWidget {
  const DistinctWorldsSettings({super.key});

  @override
  DistinctWorldsSettingsState createState() => DistinctWorldsSettingsState();
}

class DistinctWorldsSettingsState extends MainWeightSettingsState<DistinctWorldsSettings> {
  DistinctWorldsSettingsState()
      : super({
        "Output": MainWeightOption('distinctWorlds', 'Choose whether worlds have the exact same settings in Multiworld', options: ['true', 'false'], defaultValue: 'false'),
      });

  @override
  Widget build(BuildContext context) {
    return buildSettingsUI('Distinct Worlds', mainWeightKeys.keys.toList());
  }
}

//  Shared Items Settings
class SharedItemsSettings extends StatefulWidget {
  const SharedItemsSettings({super.key});

  @override
  SharedItemsSettingsState createState() => SharedItemsSettingsState();
}

class SharedItemsSettingsState extends MainWeightSettingsState<SharedItemsSettings> {
  SharedItemsSettingsState()
      : super({
        "Output": MainWeightOption('sharedItems', 'Choose whether OoT and MM share items', options: ['true', 'false'], defaultValue: 'true'),
      });

  @override
  Widget build(BuildContext context) {
    return buildSettingsUI('Shared Items', mainWeightKeys.keys.toList());
  }
}

//  Shared Items Settings
class ItemPoolSettings extends StatefulWidget {
  const ItemPoolSettings({super.key});

  @override
  ItemPoolSettingsState createState() => ItemPoolSettingsState();
}

class ItemPoolSettingsState extends MainWeightSettingsState<ItemPoolSettings> {
  ItemPoolSettingsState()
      : super({
        "Plentiful": MainWeightOption('itemPoolPlentiful', 'Item Pool has extra copies of required items, less junk'),
        "Normal": MainWeightOption('itemPoolNormal', 'Item Pool untouched'),
        "Scarce": MainWeightOption('itemPoolScarce', 'Less upgrades for required items in the Item Pool'),
        "Minimal": MainWeightOption('itemPoolMinimal', 'Item Pool has only 1 copy of each item, no upgrades, no heart pieces/containers'),
        "Barren": MainWeightOption('itemPoolBarren', 'Item Pool has only required items to reach all locations'),
      });

  @override
  Widget build(BuildContext context) {
    return buildSettingsUI('Item Pool Weights', mainWeightKeys.keys.toList());
  }
}

//  Preset Settings
class PresetSettings extends StatefulWidget {
  const PresetSettings({super.key});

  @override
  PresetSettingsState createState() => PresetSettingsState();
}

class PresetSettingsState extends MainWeightSettingsState<PresetSettings> {
  PresetSettingsState()
      : super({
        "Choose": MainWeightOption('presetTemplate', 'Choose base settings from preset', options: ['blitz', 'standard'], defaultValue: 'blitz'),
      });

  @override
  Widget build(BuildContext context) {
    return buildSettingsUI('Preset', mainWeightKeys.keys.toList());
  }
}

//  WinCon Settings
class WinConSettings extends StatefulWidget {
  const WinConSettings({super.key});

  @override
  WinConSettingsState createState() => WinConSettingsState();
}

class WinConSettingsState extends MainWeightSettingsState<WinConSettings> {
  WinConSettingsState()
      : super({
        "Ganon and Majora": MainWeightOption('winGMWeight', 'Beat Ganon and Majora'),
        "Triforce Hunt": MainWeightOption('winPiecesWeight', 'Find the pieces of the Triforce of Courage!'),
        "Triforce Quest": MainWeightOption('winQuestWeight', "Find the 3 main pieces of the Triforce")
      });

  @override
  Widget build(BuildContext context) {
    return buildSettingsUI('Win Condition', mainWeightKeys.keys.toList());
  }
}

//  OiecesRequired
class PiecesRequired extends StatefulWidget {
  const PiecesRequired({super.key});

  @override
  PiecesRequiredState createState() => PiecesRequiredState();
}

class PiecesRequiredState extends MainWeightSettingsState<PiecesRequired> {
  PiecesRequiredState()
      : super({
        "20": MainWeightOption('pieces20Weight', '20 out of 30 pieces needed in Triforce Hunt'),
        "25": MainWeightOption('pieces25Weight', '25 out of 37 pieces needed in Triforce Hunt'),
        "30": MainWeightOption('pieces30Weight', "30 out of 45 pieces needed in Triforce Hunt"),
        "35": MainWeightOption('pieces35Weight', '35 out of 50 pieces needed in Triforce Hunt'),
        "40": MainWeightOption('pieces40Weight', "40 out of 50 pieces needed in Triforce Hunt")
      });

  @override
  Widget build(BuildContext context) {
    return buildSettingsUI('Triforce Pieces Required in Hunt', mainWeightKeys.keys.toList());
  }
}

//  MM Adult Weight
class MMAdultSettings extends StatefulWidget {
  const MMAdultSettings({super.key});

  @override
  MMAdultSettingsState createState() => MMAdultSettingsState();
}

class MMAdultSettingsState extends MainWeightSettingsState<MMAdultSettings> {
  MMAdultSettingsState()
      : super({
        "True": MainWeightOption('mmAdultTrueWeight', 'Allow Adult Link in MM'),
        "False": MainWeightOption('mmAdultFalseWeight', 'Link is always Child in MM'),
      });

  @override
  Widget build(BuildContext context) {
    return buildSettingsUI('Adult in MM', mainWeightKeys.keys.toList());
  }
}