import 'package:flutter/material.dart';
import 'package:ootmmgenerator/shared/shared.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:async';

//What comes under world? -- ZD Shortcut, Gibdo, MQ Dungeons, JPN locations, Ganon Trials, Open Dungeons, Deku Tree, Entrance Rando

class WorldSettingsPage extends StatelessWidget {
  const WorldSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: "World Settings",
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
                      'General World Settings',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  DekuTreeSettings(),
                  SkipZeldaSettings(),
                  KingZoraSettings(),
                  OoTBeanSettings(),
                  ZDAdultSettings(),
                  DoorOfTimeSettings(),
                  TimeTravelSettings(),
                  Container(height: 3, color: Theme.of(context).colorScheme.inversePrimary),
                  Container(
                    color: Theme.of(context).colorScheme.inversePrimary.withValues(alpha: 0.4),
                    width: 1890,
                    height: 35,
                    alignment: Alignment.center,
                    child: Text(
                      'World Entrance Settings',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SpawnSettings(),
                  WorldEntranceSettings(),
                  DungeonEntranceSettings(),
                  ExtraDungeonEntranceSettings(),
                  BossEntranceSettings(),
                  GrottoEntranceSettings(),
                ]
              )
            ),
          )
        )
      )
    );
  }
}

abstract class WorldWeightSettingsState<T extends StatefulWidget> extends State<T> {
  late Map<String, int> worldWeights;
  final Map<String, WorldWeightOption> worldWeightKeys;

  WorldWeightSettingsState(this.worldWeightKeys);

  late File _settingsFile;
  Timer? _saveDelayTimer; // Timer to manage the delay

  @override
  void initState() {
    super.initState();
    worldWeights = {for (var key in worldWeightKeys.keys) key: 1}; // Default weights
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
        for (var key in worldWeightKeys.keys) {
          String internalKey = worldWeightKeys[key]?.internalName ?? '';
          if (internalKey.isNotEmpty && jsonData.containsKey(internalKey)) {
            worldWeights[key] = jsonData[internalKey] ?? 1;
          } else {
            worldWeights[key] = 1;
          }
        }
      });
    } catch (e) {
      print("Error loading settings: $e");
    }
  }

  /// Save weights to the persistent settings file
  Future<void> _saveWeights() async {
    try {
      String content = await _settingsFile.readAsString();
      Map<String, dynamic> jsonData = jsonDecode(content);

      for (var entry in worldWeights.entries) {
        String internalKey = worldWeightKeys[entry.key]?.internalName ?? '';
        if (internalKey.isNotEmpty) {
          jsonData[internalKey] = entry.value;
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
      worldWeights[key] = (worldWeights[key]! + delta).clamp(0, double.infinity).toInt();
    });
    _saveWeights();
  }

  Widget buildWeightSelector(String label, String key) {
    return Row(
      children: [
        Tooltip(
          message: worldWeightKeys[key]!.description,
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
            controller: TextEditingController(text: worldWeights[key].toString()),
            onChanged: (value) {
              // Cancel the previous delayed save if it's still active
              _saveDelayTimer?.cancel();

              // Start a new delayed save
              _saveDelayTimer = Timer(Duration(seconds: 1), () {
                setState(() {
                  int? newValue = int.tryParse(value);
                  if (newValue != null && newValue >= 0) {
                    worldWeights[key] = newValue;
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
              children: keys.map((key) => buildWeightSelector(key, key)).toList(),
            )
          ],
        ),
        SizedBox(height: 5),
      ],
    );
  }
}

// Helper class to store weight key and description
class WorldWeightOption {
  final String internalName;
  final String description;

  WorldWeightOption(this.internalName, this.description);
}

// Bean Settings
class OoTBeanSettings extends StatefulWidget {
  const OoTBeanSettings({super.key});

  @override
  OoTBeanSettingsState createState() => OoTBeanSettingsState();
}

class OoTBeanSettingsState extends WorldWeightSettingsState<OoTBeanSettings> {
  OoTBeanSettingsState()
      : super({
        'Untouched': WorldWeightOption('ootBeanVanWeight', 'All OoT Bean Soil Patches are untouched'),
        'Planted': WorldWeightOption('ootBeanFullWeight', 'All OoT Bean Soil Patches are preplanted')
      });

  @override
  Widget build(BuildContext context) {
    return buildSettingsUI('OoT Preplanted Beans', worldWeightKeys.keys.toList());
  }
}

// Child Zelda Settings
class SkipZeldaSettings extends StatefulWidget {
  const SkipZeldaSettings({super.key});

  @override
  SkipZeldaSettingsState createState() => SkipZeldaSettingsState();
}

class SkipZeldaSettingsState extends WorldWeightSettingsState<SkipZeldaSettings> {
  SkipZeldaSettingsState()
      : super({
        'Meet Child Zelda': WorldWeightOption('zeldaMeetWeight', 'Child Zelda holds a potential song and letter in OoT'),
        'Skip Child Zelda': WorldWeightOption('zeldaSkipWeight', 'Skip having to meet Child Zelda in OoT')
      });

  @override
  Widget build(BuildContext context) {
    return buildSettingsUI('Skip Child Zelda', worldWeightKeys.keys.toList());
  }
}

// King Zora Settings
class KingZoraSettings extends StatefulWidget {
  const KingZoraSettings({super.key});

  @override
  KingZoraSettingsState createState() => KingZoraSettingsState();
}

class KingZoraSettingsState extends WorldWeightSettingsState<KingZoraSettings> {
  KingZoraSettingsState()
      : super({
        'King Zora Closed': WorldWeightOption('zoraClosedWeight', "King Zora fully blocks the way to Zora Fountain, requiring Letter (MWEEP)"),
        'King Zora Adult Open': WorldWeightOption('zoraAdultWeight', "King Zora only blocks Zora Fountain as Child"),
        'King Zora Open': WorldWeightOption('zoraOpenWeight', "King Zora has moved, Letter removed from pool"),
        'King Zora Closed (ER)': WorldWeightOption('zoraClosedErWeight', "King Zora fully blocks the way to Zora Fountain, requiring Letter if ER is enabled (MWEEP)"),
        'King Zora Adult Open (ER)': WorldWeightOption('zoraAdultErWeight', "King Zora only blocks Zora Fountain as Child if ER is enabled"),
        'King Zora Open (ER)': WorldWeightOption('zoraOpenErWeight', "King Zora has moved, Letter removed from pool if ER is enabled")
      });

  @override
  Widget build(BuildContext context) {
    return buildSettingsUI('King Zora Position', worldWeightKeys.keys.toList());
  }
}

// Zora Domain as Adult Settings
class ZDAdultSettings extends StatefulWidget {
  const ZDAdultSettings({super.key});

  @override
  ZDAdultSettingsState createState() => ZDAdultSettingsState();
}

class ZDAdultSettingsState extends WorldWeightSettingsState<ZDAdultSettings> {
  ZDAdultSettingsState()
      : super({
        "Off": WorldWeightOption('zdAdultOffWeight', "Lake Hylia to Zora's Domain Shortcut closed as Adult"),
        "On": WorldWeightOption('zdAdultOnWeight', "Lake Hylia to Zora's Domain Shortcut opened as Adult"),
        "Off (Er)": WorldWeightOption('zdAdultOffErWeight', "Lake Hylia to Zora's Domain Shortcut closed as Adult (if ER is on)"),
        "On (Er)": WorldWeightOption('zdAdultOnErWeight', "Lake Hylia to Zora's Domain Shortcut opened as Adult (if ER is on)")
      });

  @override
  Widget build(BuildContext context) {
    return buildSettingsUI("Adult Zora's Domain Shortcut", worldWeightKeys.keys.toList());
  }
}

// Deku Tree Settings
class DekuTreeSettings extends StatefulWidget {
  const DekuTreeSettings({super.key});

  @override
  DekuTreeSettingsState createState() => DekuTreeSettingsState();
}

class DekuTreeSettingsState extends WorldWeightSettingsState<DekuTreeSettings> {
  DekuTreeSettingsState()
      : super({
        "Vanilla": WorldWeightOption('dekuVanWeight', "Deku Tree requires Kokiri Sword and Deku Shield, cannot leave forest until Tree is beaten"),
        "Closed": WorldWeightOption('dekuClosedWeight', "Forest Open, Deku Tree requires Kokiri Sword and Deku Shield"),
        "Open": WorldWeightOption('dekuOpenWeight', "Forest and Deku Tree open"),
      });

  @override
  Widget build(BuildContext context) {
    return buildSettingsUI("Deku Tree Access", worldWeightKeys.keys.toList());
  }
}

// Door of Time Settings
class DoorOfTimeSettings extends StatefulWidget {
  const DoorOfTimeSettings({super.key});

  @override
  DoorOfTimeSettingsState createState() => DoorOfTimeSettingsState();
}

class DoorOfTimeSettingsState extends WorldWeightSettingsState<DoorOfTimeSettings> {
  DoorOfTimeSettingsState()
      : super({
        "Closed": WorldWeightOption('dotClosedWeight', "Door of Time requires OoT Song of Time"),
        "Open": WorldWeightOption('dotOpenWeight', "Door of Time open"),
      });

  @override
  Widget build(BuildContext context) {
    return buildSettingsUI("Door of Time Access", worldWeightKeys.keys.toList());
  }
}

// Time Travel Settings
class TimeTravelSettings extends StatefulWidget {
  const TimeTravelSettings({super.key});

  @override
  TimeTravelSettingsState createState() => TimeTravelSettingsState();
}

class TimeTravelSettingsState extends WorldWeightSettingsState<TimeTravelSettings> {
  TimeTravelSettingsState()
      : super({
        "Free (Open DoT)": WorldWeightOption('timeFreeOpenWeight', "Time Travel is free (if Door of Time is Open)"),
        "Requires Master Sword (Open DoT)": WorldWeightOption('timeSwordOpenWeight', "Time Travel requires Master Sword (if Door of Time is open)"),
        "Free (Closed DoT)": WorldWeightOption('timeFreeClosedWeight', "Time Travel is free (if Door of Time is Closed)"),
        "Requires Master Sword (Closed DoT)": WorldWeightOption('timeSwordClosedWeight', "Time Travel requires Master Sword (if Door of Time is closed)"),
      });

  @override
  Widget build(BuildContext context) {
    return buildSettingsUI("Time Travel Settings", worldWeightKeys.keys.toList());
  }
}

// World Entrances Settings
class WorldEntranceSettings extends StatefulWidget {
  const WorldEntranceSettings({super.key});

  @override
  WorldEntranceSettingsState createState() => WorldEntranceSettingsState();
}

class WorldEntranceSettingsState extends WorldWeightSettingsState<WorldEntranceSettings> {
  WorldEntranceSettingsState()
      : super({
        'No Change': WorldWeightOption('erNoneWeight', "No standard entrances are changed"),
        'Regions Only': WorldWeightOption('erRegionWeight', "Region Entrances are shuffled"),
        'Exteriors Only': WorldWeightOption('erExtWeight', "Exterior Entrances are shuffled"),
        'Interiors Only': WorldWeightOption('erIntWeight', "Interior Entrances are shuffled"),
        'Exteriors and Interiors': WorldWeightOption('erFullWeight', "Interior and Exterior Entrances are shuffled"),
      });

  @override
  Widget build(BuildContext context) {
    return buildSettingsUI('World Entrance Shuffle', worldWeightKeys.keys.toList());
  }
}

// Dungeon Entrances Settings
class DungeonEntranceSettings extends StatefulWidget {
  const DungeonEntranceSettings({super.key});

  @override
  DungeonEntranceSettingsState createState() => DungeonEntranceSettingsState();
}

class DungeonEntranceSettingsState extends WorldWeightSettingsState<DungeonEntranceSettings> {
  DungeonEntranceSettingsState()
      : super({
        'No Change': WorldWeightOption('dungErNoneWeight', "No dungeon entrances are changed"),
        'Shuffled': WorldWeightOption('dungErFullWeight', "All dungeon entrances are shuffled. This is cross game and includes all minor dungeons"),
        "Exc. Ganon's Castle": WorldWeightOption('gcErExcWeight', "Ignore Ganon's Castle if dungeons are shuffled"),
        "Inc. Ganon's Castle": WorldWeightOption('gcErIncWeight', "Include Ganon's Castle if dungeons are shuffled"),
      });

  @override
  Widget build(BuildContext context) {
    return buildSettingsUI('Dungeon Entrance Shuffle', worldWeightKeys.keys.toList());
  }
}

// Extra Dungeon Entrances Settings
class ExtraDungeonEntranceSettings extends StatefulWidget {
  const ExtraDungeonEntranceSettings({super.key});

  @override
  ExtraDungeonEntranceSettingsState createState() => ExtraDungeonEntranceSettingsState();
}

class ExtraDungeonEntranceSettingsState extends WorldWeightSettingsState<ExtraDungeonEntranceSettings> {
  ExtraDungeonEntranceSettingsState()
      : super({
        "Exc. Ganon's Tower": WorldWeightOption('gtErExcWeight', "Ignore Ganon's Tower if dungeons are shuffled"),
        "Inc. Ganon's Tower": WorldWeightOption('gtErIncWeight', "Include Ganon's Castle if dungeons are shuffled"),
        "Exc. Clock Tower Roof": WorldWeightOption('ctErExcWeight', "Ignore Clock Tower Entrance if dungeons are shuffled"),
        "Inc. Clock Tower Roof": WorldWeightOption('ctErIncWeight', "Include Clock Tower Entrance if dungeons are shuffled"),
      });

  @override
  Widget build(BuildContext context) {
    return buildSettingsUI('Extra Dungeon Entrance Settings', worldWeightKeys.keys.toList());
  }
}

// Boss Entrances Settings
class BossEntranceSettings extends StatefulWidget {
  const BossEntranceSettings({super.key});

  @override
  BossEntranceSettingsState createState() => BossEntranceSettingsState();
}

class BossEntranceSettingsState extends WorldWeightSettingsState<BossEntranceSettings> {
  BossEntranceSettingsState()
      : super({
        "None": WorldWeightOption('bossErNoneWeight', "Boss Entrances are untouched"),
        "Full": WorldWeightOption('bossErFullWeight', "Boss Entrances are shuffled, cross game")
      });

  @override
  Widget build(BuildContext context) {
    return buildSettingsUI('Boss Entrance Settings', worldWeightKeys.keys.toList());
  }
}

// Spawn Settings
class SpawnSettings extends StatefulWidget {
  const SpawnSettings({super.key});

  @override
  SpawnSettingsState createState() => SpawnSettingsState();
}

class SpawnSettingsState extends WorldWeightSettingsState<SpawnSettings> {
  SpawnSettingsState()
      : super({
        "None": WorldWeightOption('spawnNoneWeight', "Default Spawn Locations untouched"),
        "Child Only": WorldWeightOption('spawnChildWeight', "Child Spawn Location shuffled, Adult untouched"),
        "Adult Only": WorldWeightOption('spawnAdultWeight', "Adult Spawn Location shuffled, Child untouched"),
        "Both": WorldWeightOption('spawnFullWeight', "Default Spawn Locations shuffled"),
      });

  @override
  Widget build(BuildContext context) {
    return buildSettingsUI('Default Spawn Settings', worldWeightKeys.keys.toList());
  }
}

// Grotto Entrances Settings
class GrottoEntranceSettings extends StatefulWidget {
  const GrottoEntranceSettings({super.key});

  @override
  GrottoEntranceSettingsState createState() => GrottoEntranceSettingsState();
}

class GrottoEntranceSettingsState extends WorldWeightSettingsState<GrottoEntranceSettings> {
  GrottoEntranceSettingsState()
      : super({
        "None": WorldWeightOption('grottoErNoneWeight', "Grotto Entrances are untouched"),
        "Full": WorldWeightOption('grottoErFullWeight', "Grotto Entrances are shuffled, cross game")
      });

  @override
  Widget build(BuildContext context) {
    return buildSettingsUI('Grotto Entrance Settings', worldWeightKeys.keys.toList());
  }
}