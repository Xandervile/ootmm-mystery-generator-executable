import 'package:flutter/material.dart';
import 'package:ootmmgenerator/shared/shared.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:async';

//What comes under world? -- Gibdo, MQ Dungeons, JPN locations, Ganon Trials, Open Dungeons

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
                  MMLayoutSettings(),
                  DekuTreeSettings(),
                  SkipZeldaSettings(),
                  KingZoraSettings(),
                  OoTBeanSettings(),
                  ZDAdultSettings(),
                  PriceSettings(),
                  DoorOfTimeSettings(),
                  TimeTravelSettings(),
                  Container(height: 3, color: Theme.of(context).colorScheme.inversePrimary),
                  Container(
                    color: Theme.of(context).colorScheme.inversePrimary.withValues(alpha: 0.4),
                    width: 1890,
                    height: 35,
                    alignment: Alignment.center,
                    child: Text(
                      'World Difficulty Settings',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(height: 3, color: Theme.of(context).colorScheme.inversePrimary.withAlpha(100)),
                  OpenDungeonSettings(),
                  Container(height: 3, color: Theme.of(context).colorScheme.inversePrimary.withAlpha(100)),
                  MQDungeonSettings1(),
                  MQDungeonSettings2(),
                  Container(height: 3, color: Theme.of(context).colorScheme.inversePrimary.withAlpha(100)),
                  TrialsSettings(),
                  Container(height: 3, color: Theme.of(context).colorScheme.inversePrimary.withAlpha(100)),
                  KeyRingSettings1(),
                  KeyRingSettings2(),
                  Container(height: 3, color: Theme.of(context).colorScheme.inversePrimary.withAlpha(100)),
                  SilverPouchSettings1(),
                  SilverPouchSettings2(),
                  Container(height: 3, color: Theme.of(context).colorScheme.inversePrimary.withAlpha(100)),
                  AgelessSettings1(),
                  AgelessSettings2(),
                  Container(height: 2, color: Theme.of(context).colorScheme.inversePrimary.withAlpha(100)),
                  GibdoSettings(),
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
                  WarpSongSettings(),
                  WorldEntranceSettings(),
                  DungeonEntranceSettings(),
                  ExtraDungeonEntranceSettings(),
                  BossEntranceSettings(),
                  GrottoEntranceSettings(),
                  GameLinkSettings(),
                  Container(height: 3, color: Theme.of(context).colorScheme.inversePrimary),
                  Container(
                    color: Theme.of(context).colorScheme.inversePrimary.withValues(alpha: 0.4),
                    width: 1890,
                    height: 35,
                    alignment: Alignment.center,
                    child: Text(
                      'Mixed and Decoupled Settings',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  DecoupleSettings(),
                  AllowMixedSettings(),
                  MixedRegionSettings(),
                  MixedExteriorSettings(),
                  MixedInteriorSettings(),
                  MixedGrottoSettings(),
                  MixedDungeonSettings(),
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

    Widget buildThinWeightSelector(String label, String key) {
    return Row(
      children: [
        Tooltip(
          message: worldWeightKeys[key]!.description,
          waitDuration: Duration(milliseconds: 500),
          child: SizedBox(
            width: 20,
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
    Widget buildThinSettingsUI(String title, List<String> keys) {
    return Column(
      children: [
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
              children: keys.map((key) => buildThinWeightSelector(key, key)).toList(),
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

// Price Settings
class PriceSettings extends StatefulWidget {
  const PriceSettings({super.key});

  @override
  PriceSettingsState createState() => PriceSettingsState();
}

class PriceSettingsState extends WorldWeightSettingsState<PriceSettings> {
  PriceSettingsState()
      : super({
        "Affordable": WorldWeightOption('priceAffordableWeight', "All shops cost 10 rupees"),
        "Vanilla": WorldWeightOption('priceVanillaWeight', "All shops vanilla prices"),
        "Weighted Random": WorldWeightOption('priceWeightedWeight', "All shops random prices, but weighted to make it fairer"),
        "Fully Random": WorldWeightOption('priceRandomWeight', "All shops fully random prices"),
      });

  @override
  Widget build(BuildContext context) {
    return buildSettingsUI("Shop Prices (if Shop Shuffle)", worldWeightKeys.keys.toList());
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
    return buildSettingsUI("Time Travel (requires Sword Shuffle)", worldWeightKeys.keys.toList());
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

// Warp Song Settings
class WarpSongSettings extends StatefulWidget {
  const WarpSongSettings({super.key});

  @override
  WarpSongSettingsState createState() => WarpSongSettingsState();
}

class WarpSongSettingsState extends WorldWeightSettingsState<WarpSongSettings> {
  WarpSongSettingsState()
      : super({
        'No Change': WorldWeightOption('warpNoneWeight', "No warp songs are changed"),
        'Random': WorldWeightOption('warpFullWeight', "All warp songs are changed. This doesn't happen if Songs on Owls are rolled"),
      });

  @override
  Widget build(BuildContext context) {
    return buildSettingsUI('Warp Songs (if No songs on owls)', worldWeightKeys.keys.toList());
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

// Grotto Entrances Settings
class GameLinkSettings extends StatefulWidget {
  const GameLinkSettings({super.key});

  @override
  GameLinkSettingsState createState() => GameLinkSettingsState();
}

class GameLinkSettingsState extends WorldWeightSettingsState<GameLinkSettings> {
  GameLinkSettingsState()
      : super({
        "Off": WorldWeightOption('gameLinkFalseWeight', "Game Link Entrance (Mask Shop to Clock Tower) is untouched"),
        "On": WorldWeightOption('gameLinkTrueWeight', "Game Link Entrance (Mask Shop to Clock Tower) is shuffled with other interiors")
      });

  @override
  Widget build(BuildContext context) {
    return buildSettingsUI('Game Link (if Interiors Shuffled)', worldWeightKeys.keys.toList());
  }
}

//Decouple Entrances
class DecoupleSettings extends StatefulWidget {
  const DecoupleSettings({super.key});

  @override
  DecoupleSettingsState createState() => DecoupleSettingsState();
}

class DecoupleSettingsState extends WorldWeightSettingsState<DecoupleSettings> {
  DecoupleSettingsState()
      : super({
        "Off": WorldWeightOption('decoupleFalseWeight', "All Entrances are linked both ways"),
        "On": WorldWeightOption('decoupleTrueWeight', "Entrances are linked only one way")
      });

  @override
  Widget build(BuildContext context) {
    return buildSettingsUI('Decouple Loading Zones', worldWeightKeys.keys.toList());
  }
}

// Mixed Pool Settings
class AllowMixedSettings extends StatefulWidget {
  const AllowMixedSettings({super.key});

  @override
  AllowMixedSettingsState createState() => AllowMixedSettingsState();
}

class AllowMixedSettingsState extends WorldWeightSettingsState<AllowMixedSettings> {
  AllowMixedSettingsState()
      : super({
        "Off": WorldWeightOption('mixedErFalseWeight', "Randomised Entrance Types are not mixed when shuffled"),
        "On": WorldWeightOption('mixedErTrueWeight', "Randomised Entrance Types are mixed when shuffled")
      });

  @override
  Widget build(BuildContext context) {
    return buildSettingsUI('Allow Mixed Entrances Weight', worldWeightKeys.keys.toList());
  }
}

class MixedRegionSettings extends StatefulWidget {
  const MixedRegionSettings({super.key});

  @override
  MixedRegionSettingsState createState() => MixedRegionSettingsState();
}

class MixedRegionSettingsState extends WorldWeightSettingsState<MixedRegionSettings> {
  MixedRegionSettingsState()
      : super({
        "Off": WorldWeightOption('mixedRegionErFalseWeight', "Regions not added to the Mixed Pool"),
        "On": WorldWeightOption('mixedRegionErTrueWeight', "Regions added to the Mixed Pool")
      });

  @override
  Widget build(BuildContext context) {
    return buildSettingsUI('Mixed Regions (Region Shuffle Only)', worldWeightKeys.keys.toList());
  }
}

class MixedExteriorSettings extends StatefulWidget {
  const MixedExteriorSettings({super.key});

  @override
  MixedExteriorSettingsState createState() => MixedExteriorSettingsState();
}

class MixedExteriorSettingsState extends WorldWeightSettingsState<MixedExteriorSettings> {
  MixedExteriorSettingsState()
      : super({
        "Off": WorldWeightOption('mixedExteriorErFalseWeight', "Exteriors not added to the Mixed Pool"),
        "On": WorldWeightOption('mixedExteriorErTrueWeight', "Exteriors added to the Mixed Pool")
      });

  @override
  Widget build(BuildContext context) {
    return buildSettingsUI('Mixed Exteriors (if shuffled)', worldWeightKeys.keys.toList());
  }
}

class MixedInteriorSettings extends StatefulWidget {
  const MixedInteriorSettings({super.key});

  @override
  MixedInteriorSettingsState createState() => MixedInteriorSettingsState();
}

class MixedInteriorSettingsState extends WorldWeightSettingsState<MixedInteriorSettings> {
  MixedInteriorSettingsState()
      : super({
        "Off": WorldWeightOption('mixedInteriorErFalseWeight', "Interiors not added to the Mixed Pool"),
        "On": WorldWeightOption('mixedInteriorErTrueWeight', "Interiors added to the Mixed Pool")
      });

  @override
  Widget build(BuildContext context) {
    return buildSettingsUI('Mixed Interiors (if shuffled)', worldWeightKeys.keys.toList());
  }
}

class MixedGrottoSettings extends StatefulWidget {
  const MixedGrottoSettings({super.key});

  @override
  MixedGrottoSettingsState createState() => MixedGrottoSettingsState();
}

class MixedGrottoSettingsState extends WorldWeightSettingsState<MixedGrottoSettings> {
  MixedGrottoSettingsState()
      : super({
        "Off": WorldWeightOption('mixedGrottoErFalseWeight', "Grottos not added to the Mixed Pool"),
        "On": WorldWeightOption('mixedGrottoErTrueWeight', "Grottos added to the Mixed Pool")
      });

  @override
  Widget build(BuildContext context) {
    return buildSettingsUI('Mixed Grottos (if shuffled)', worldWeightKeys.keys.toList());
  }
}

class MixedDungeonSettings extends StatefulWidget {
  const MixedDungeonSettings({super.key});

  @override
  MixedDungeonSettingsState createState() => MixedDungeonSettingsState();
}

class MixedDungeonSettingsState extends WorldWeightSettingsState<MixedDungeonSettings> {
  MixedDungeonSettingsState()
      : super({
        "Off": WorldWeightOption('mixedDungeonErFalseWeight', "Dungeons not added to the Mixed Pool"),
        "On": WorldWeightOption('mixedDungeonErTrueWeight', "Dungeons added to the Mixed Pool")
      });

  @override
  Widget build(BuildContext context) {
    return buildSettingsUI('Mixed Dungeons (if shuffled)', worldWeightKeys.keys.toList());
  }
}

class OpenDungeonSettings extends StatefulWidget {
  const OpenDungeonSettings({super.key});

  @override
  OpenDungeonSettingsState createState() => OpenDungeonSettingsState();
}

class OpenDungeonSettingsState extends WorldWeightSettingsState<OpenDungeonSettings> {
  OpenDungeonSettingsState()
      : super({
        "0": WorldWeightOption('openDungeon0Weight', ""),
        "1": WorldWeightOption('openDungeon1Weight', ""),
        "2": WorldWeightOption('openDungeon2Weight', ""),
        "3": WorldWeightOption('openDungeon3Weight', ""),
        "4": WorldWeightOption('openDungeon4Weight', ""),
        "5": WorldWeightOption('openDungeon5Weight', ""),        
        "6": WorldWeightOption('openDungeon6Weight', ""),
        "7": WorldWeightOption('openDungeon7Weight', ""),
        "8": WorldWeightOption('openDungeon8Weight', ""),
        "9": WorldWeightOption('openDungeon9Weight', ""),
      });

  @override
  Widget build(BuildContext context) {
    return buildThinSettingsUI('Open Dungeons', worldWeightKeys.keys.toList());
  }
}

class MQDungeonSettings1 extends StatefulWidget {
  const MQDungeonSettings1({super.key});

  @override
  MQDungeonSettings1State createState() => MQDungeonSettings1State();
}

class MQDungeonSettings1State extends WorldWeightSettingsState<MQDungeonSettings1> {
  MQDungeonSettings1State()
      : super({
        "0": WorldWeightOption('mqDungeon0Weight', ""),
        "1": WorldWeightOption('mqDungeon1Weight', ""),
        "2": WorldWeightOption('mqDungeon2Weight', ""),
        "3": WorldWeightOption('mqDungeon3Weight', ""),
        "4": WorldWeightOption('mqDungeon4Weight', ""),
        "5": WorldWeightOption('mqDungeon5Weight', ""),        
        "6": WorldWeightOption('mqDungeon6Weight', ""),
        "7": WorldWeightOption('mqDungeon7Weight', ""),
        "8": WorldWeightOption('mqDungeon8Weight', ""),
        "9": WorldWeightOption('mqDungeon9Weight', ""),
      });

  @override
  Widget build(BuildContext context) {
    return buildThinSettingsUI('MQ Dungeons', worldWeightKeys.keys.toList());
  }
}

class MQDungeonSettings2 extends StatefulWidget {
  const MQDungeonSettings2({super.key});

  @override
  MQDungeonSettings2State createState() => MQDungeonSettings2State();
}

class MQDungeonSettings2State extends WorldWeightSettingsState<MQDungeonSettings2> {
  MQDungeonSettings2State()
      : super({
        "10": WorldWeightOption('mqDungeon10Weight', ""),
        "11": WorldWeightOption('mqDungeon11Weight', ""),
        "12": WorldWeightOption('mqDungeon12Weight', ""),
      });

  @override
  Widget build(BuildContext context) {
    return buildThinSettingsUI('', worldWeightKeys.keys.toList());
  }
}

class KeyRingSettings1 extends StatefulWidget {
  const KeyRingSettings1({super.key});

  @override
  KeyRingSettings1State createState() => KeyRingSettings1State();
}

class KeyRingSettings1State extends WorldWeightSettingsState<KeyRingSettings1> {
  KeyRingSettings1State()
      : super({
        "0": WorldWeightOption('keyRing0Weight', ""),
        "1": WorldWeightOption('keyRing1Weight', ""),
        "2": WorldWeightOption('keyRing2Weight', ""),
        "3": WorldWeightOption('keyRing3Weight', ""),
        "4": WorldWeightOption('keyRing4Weight', ""),
        "5": WorldWeightOption('keyRing5Weight', ""),        
        "6": WorldWeightOption('keyRing6Weight', ""),
        "7": WorldWeightOption('keyRing7Weight', ""),
        "8": WorldWeightOption('keyRing8Weight', ""),
        "9": WorldWeightOption('keyRing9Weight', ""),
      });

  @override
  Widget build(BuildContext context) {
    return buildThinSettingsUI('Keyrings Count', worldWeightKeys.keys.toList());
  }
}

class KeyRingSettings2 extends StatefulWidget {
  const KeyRingSettings2({super.key});

  @override
  KeyRingSettings2State createState() => KeyRingSettings2State();
}

class KeyRingSettings2State extends WorldWeightSettingsState<KeyRingSettings2> {
  KeyRingSettings2State()
      : super({
        "10": WorldWeightOption('keyRing10Weight', ""),
        "11": WorldWeightOption('keyRing11Weight', ""),
        "12": WorldWeightOption('keyRing12Weight', ""),
        "13": WorldWeightOption('keyRing13Weight','')
      });

  @override
  Widget build(BuildContext context) {
    return buildThinSettingsUI('', worldWeightKeys.keys.toList());
  }
}

class SilverPouchSettings1 extends StatefulWidget {
  const SilverPouchSettings1({super.key});

  @override
  SilverPouchSettings1State createState() => SilverPouchSettings1State();
}

class SilverPouchSettings1State extends WorldWeightSettingsState<SilverPouchSettings1> {
  SilverPouchSettings1State()
      : super({
        "0": WorldWeightOption('silverPouch0Weight', ""),
        "1": WorldWeightOption('silverPouch1Weight', ""),
        "2": WorldWeightOption('silverPouch2Weight', ""),
        "3": WorldWeightOption('silverPouch3Weight', ""),
        "4": WorldWeightOption('silverPouch4Weight', ""),
        "5": WorldWeightOption('silverPouch5Weight', ""),        
        "6": WorldWeightOption('silverPouch6Weight', ""),
        "7": WorldWeightOption('silverPouch7Weight', ""),
        "8": WorldWeightOption('silverPouch8Weight', ""),
        "9": WorldWeightOption('silverPouch9Weight', ""),
      });

  @override
  Widget build(BuildContext context) {
    return buildThinSettingsUI('Silver Pouch Count', worldWeightKeys.keys.toList());
  }
}

class SilverPouchSettings2 extends StatefulWidget {
  const SilverPouchSettings2({super.key});

  @override
  SilverPouchSettings2State createState() => SilverPouchSettings2State();
}

class SilverPouchSettings2State extends WorldWeightSettingsState<SilverPouchSettings2> {
  SilverPouchSettings2State()
      : super({
        "10": WorldWeightOption('SilverPouch10Weight', ""),
        "11": WorldWeightOption('SilverPouch11Weight', ""),
        "12": WorldWeightOption('SilverPouch12Weight', ""),
        "13": WorldWeightOption('SilverPouch13Weight', ""),
        "14": WorldWeightOption('SilverPouch14Weight', ""),
        "15": WorldWeightOption('SilverPouch15Weight', ""),
        "16": WorldWeightOption('SilverPouch16Weight', ""),
        "17": WorldWeightOption('SilverPouch17Weight', ""),
        "18": WorldWeightOption('SilverPouch18Weight', ""),
      });

  @override
  Widget build(BuildContext context) {
    return buildThinSettingsUI('', worldWeightKeys.keys.toList());
  }
}

class AgelessSettings1 extends StatefulWidget {
  const AgelessSettings1({super.key});

  @override
  AgelessSettings1State createState() => AgelessSettings1State();
}

class AgelessSettings1State extends WorldWeightSettingsState<AgelessSettings1> {
  AgelessSettings1State()
      : super({
        "0": WorldWeightOption('ageless0Weight', ""),
        "1": WorldWeightOption('ageless1Weight', ""),
        "2": WorldWeightOption('ageless2Weight', ""),
        "3": WorldWeightOption('ageless3Weight', ""),
        "4": WorldWeightOption('ageless4Weight', ""),
        "5": WorldWeightOption('ageless5Weight', ""),        
        "6": WorldWeightOption('ageless6Weight', ""),
        "7": WorldWeightOption('ageless7Weight', ""),
        "8": WorldWeightOption('ageless8Weight', ""),
        "9": WorldWeightOption('ageless9Weight', ""),
      });

  @override
  Widget build(BuildContext context) {
    return buildThinSettingsUI('Ageless Item Count', worldWeightKeys.keys.toList());
  }
}

class AgelessSettings2 extends StatefulWidget {
  const AgelessSettings2({super.key});

  @override
  AgelessSettings2State createState() => AgelessSettings2State();
}

class AgelessSettings2State extends WorldWeightSettingsState<AgelessSettings2> {
  AgelessSettings2State()
      : super({
        "10": WorldWeightOption('ageless10Weight', ""),
        "11": WorldWeightOption('ageless11Weight', ""),
      });

  @override
  Widget build(BuildContext context) {
    return buildThinSettingsUI('', worldWeightKeys.keys.toList());
  }
}

class GibdoSettings extends StatefulWidget {
  const GibdoSettings({super.key});

  @override
  GibdoSettingsState createState() => GibdoSettingsState();
}

class GibdoSettingsState extends WorldWeightSettingsState<GibdoSettings> {
  GibdoSettingsState()
      : super({
        "Vanilla": WorldWeightOption('gibdoVanillaWeight', "Gibdos in Beneath the Well are untouched"),
        "Remorseless": WorldWeightOption('gibdoRemorselessWeight', "Gibdos in Beneath the Well are removed permanently when their item is given"),
        "Removed": WorldWeightOption('gibdoRemovedWeight', 'Gibdos in Beneath the Well are removed'),
        "Vanilla (Dung ER)": WorldWeightOption('gibdoVanillaErWeight', 'Gibdos in Beneath the Well are untouched if dungeons are shuffled'),
        "Remorseless (Dung ER)": WorldWeightOption('gibdoRemorselessErWeight', "Gibdos in Beneath the Well are removed permanently when their item is given if dungeons are shuffled"),
        "Removed (Dung ER)": WorldWeightOption('gibdoRemovedErWeight', 'Gibdos in Beneath the Well are removed if dungeons are shuffled'),
      });

  @override
  Widget build(BuildContext context) {
    return buildSettingsUI('MM Well Gibdo Settings', worldWeightKeys.keys.toList());
  }
}

class TrialsSettings extends StatefulWidget {
  const TrialsSettings({super.key});

  @override
  TrialsSettingsState createState() => TrialsSettingsState();
}

class TrialsSettingsState extends WorldWeightSettingsState<TrialsSettings> {
  TrialsSettingsState()
      : super({
        "0": WorldWeightOption('trials0Weight', ""),
        "1": WorldWeightOption('trials1Weight', ""),
        "2": WorldWeightOption('trials2Weight', ""),
        "3": WorldWeightOption('trials3Weight', ""),
        "4": WorldWeightOption('trials4Weight', ""),
        "5": WorldWeightOption('trials5Weight', ""),        
        "6": WorldWeightOption('trials6Weight', ""),
      });

  @override
  Widget build(BuildContext context) {
    return buildThinSettingsUI("Active Ganon's Trials", worldWeightKeys.keys.toList());
  }
}

// MM Layout Settings
class MMLayoutSettings extends StatefulWidget {
  const MMLayoutSettings({super.key});

  @override
  MMLayoutSettingsState createState() => MMLayoutSettingsState();
}

class MMLayoutSettingsState extends WorldWeightSettingsState<MMLayoutSettings> {
  MMLayoutSettingsState()
      : super({
        "US": WorldWeightOption('mmUsLayoutWeight', "All areas untouched"),
        "JP": WorldWeightOption('mmJpLayoutWeight', "Deku Palace has the Japanese Layout"),
      });

  @override
  Widget build(BuildContext context) {
    return buildSettingsUI("MM Layout", worldWeightKeys.keys.toList());
  }
}