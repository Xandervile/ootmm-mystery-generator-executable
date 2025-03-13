import 'package:flutter/material.dart';
import 'package:ootmmgenerator/shared/shared.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:async';

class ItemSettingsPage extends StatelessWidget {
  const ItemSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      title: "Item Settings",
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
                      'General Items',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SongSettings(),
                  OwlSettings(),
                  SoulSettings(),
                  SoulStartSettings(),
                  ClockSettings(),
                  ClockStartSettings(),
                  ButtonSettings(),
                  ButtonStartSettings(),
                  SkullSettings(),
                  PotSettings(),
                  WonderSpotSettings(),
                  FreestandingSettings(),
                  ShopSettings(),
                  WalletSettings(),
                  SwordSettings(),
                  CratesBarrelsSettings(),
                  GrassSettings(),
                  ButterflySettings(),
                  FishingSettings(),
                  DivingSettings(),
                  FairyFountainSettings(),
                  CowSettings(),
                  SnowballSettings(),
                  RedIceSettings(),
                  RedBoulderSettings(),
                  IcicleSettings(),
                  HiveSettings(),
                  Container(height: 3, color: Theme.of(context).colorScheme.inversePrimary),
                  Container(
                    color: Theme.of(context).colorScheme.inversePrimary.withValues(alpha: 0.4),
                    width: 1890,
                    height: 35,
                    alignment: Alignment.center,
                    child: Text(
                      'Dungeon Specific Items',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SmallKeySettings(),
                  TCGSettings(),
                  GerudoCardSettings(),
                  BossKeySettings(),
                  SilverRupeeSettings(),
                  StrayFairySettings(),
                  BossSoulSettings(),
                ]
              )
            ),
          )
        )
      )
    );
  }
}

abstract class ItemWeightSettingsState<T extends StatefulWidget> extends State<T> {
  late Map<String, int> itemWeights;
  final Map<String, ItemWeightOption> itemWeightKeys;

  ItemWeightSettingsState(this.itemWeightKeys);

  late File _settingsFile;
  Timer? _saveDelayTimer; // Timer to manage the delay

  @override
  void initState() {
    super.initState();
    itemWeights = {for (var key in itemWeightKeys.keys) key: 1}; // Default weights
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
        for (var key in itemWeightKeys.keys) {
          String internalKey = itemWeightKeys[key]?.internalName ?? '';
          if (internalKey.isNotEmpty && jsonData.containsKey(internalKey)) {
            itemWeights[key] = jsonData[internalKey] ?? 1;
          } else {
            itemWeights[key] = 1;
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

      for (var entry in itemWeights.entries) {
        String internalKey = itemWeightKeys[entry.key]?.internalName ?? '';
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
      itemWeights[key] = (itemWeights[key]! + delta).clamp(0, double.infinity).toInt();
    });
    _saveWeights();
  }

  Widget buildWeightSelector(String label, String key) {
    return Row(
      children: [
        Tooltip(
          message: itemWeightKeys[key]!.description,
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
            controller: TextEditingController(text: itemWeights[key].toString()),
            onChanged: (value) {
              // Cancel the previous delayed save if it's still active
              _saveDelayTimer?.cancel();

              // Start a new delayed save
              _saveDelayTimer = Timer(Duration(seconds: 1), () {
                setState(() {
                  int? newValue = int.tryParse(value);
                  if (newValue != null && newValue >= 0) {
                    itemWeights[key] = newValue;
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
class ItemWeightOption {
  final String internalName;
  final String description;

  ItemWeightOption(this.internalName, this.description);
}


// Song Settings
class SongSettings extends StatefulWidget {
  const SongSettings({super.key});

  @override
  SongSettingsState createState() => SongSettingsState();
}

class SongSettingsState extends ItemWeightSettingsState<SongSettings> {
  SongSettingsState()
      : super({
        'Song Locations': ItemWeightOption('songLocationsWeight', 'Songs shuffled amongst each other'),
        'Mixed With Owls': ItemWeightOption('songOwlsWeight', 'Songs are mixed in Song and Owl Locations, alongside all Owl Statues. If Ocarina Buttons are shuffled, these are also included here NOTE: Foolish Areas MAY STILL have required songs!'),
        'Dungeon Rewards': ItemWeightOption('songRewardsWeight', 'Songs placed on Dungeon Rewards (Boss Heart Containers, PF Hookshot Chest, Ikana King, ST Light Arrow Chest, Secret Shrine Final, Well Mirror Shield, Ice Cavern Iron Boots, GTG Ice Arrows, BotW Lens). NOTE: Foolish Dungeons MAY STILL have required songs!'),
        'Anywhere': ItemWeightOption('songAnywhereWeight', 'HARD OPTION: Songs placed anywhere in the world')
      });

  @override
  Widget build(BuildContext context) {
    return buildSettingsUI('Song Shuffle', itemWeightKeys.keys.toList());
  }
}

// Small Key Settings
class SmallKeySettings extends StatefulWidget {
  const SmallKeySettings({super.key});

  @override
  SmallKeySettingsState createState() => SmallKeySettingsState();
}

class SmallKeySettingsState extends ItemWeightSettingsState<SmallKeySettings> {
  SmallKeySettingsState()
      : super({
        'Standard': ItemWeightOption('smallKeysStandardWeight', 'OoT Own Dungeon Small Keys, MM Keysy'),
        'Keysy': ItemWeightOption('smallKeysyWeight', 'All Small Keys are removed from the world'),
        'Own Dungeons': ItemWeightOption('smallKeysOwnDungWeight', 'Small Keys are only available in their own dungeon'),
        'Anywhere': ItemWeightOption('smallKeysAnywhereWeight', 'Small Keys placed anywhere in the world (this also affects OoT Treasure Game Keys, and Gerudo Fortress Keys)')
      });

  @override
  Widget build(BuildContext context) {
    return buildSettingsUI('Dungeon Small Key Shuffle', itemWeightKeys.keys.toList());
  }
}

// Small Key Settings
class TCGSettings extends StatefulWidget {
  const TCGSettings({super.key});

  @override
  TCGSettingsState createState() => TCGSettingsState();
}

class TCGSettingsState extends ItemWeightSettingsState<TCGSettings> {
  TCGSettingsState()
      : super({
        'Vanilla': ItemWeightOption('tcgStandardWeight', 'Market Chest Game requires Lens'),
        'Own Game': ItemWeightOption('tcgOwnDungWeight', 'Market Chest Game does not require Lens'),
        'Anywhere': ItemWeightOption('tcgAnywhereWeight', 'Market Chest Game Keys are anywhere in the world')
      });

  @override
  Widget build(BuildContext context) {
    return buildSettingsUI('Market Chest Game Settings (no Keysanity)', itemWeightKeys.keys.toList());
  }
}

// Boss Key Settings
class BossKeySettings extends StatefulWidget {
  const BossKeySettings({super.key});

  @override
  BossKeySettingsState createState() => BossKeySettingsState();
}

class BossKeySettingsState extends ItemWeightSettingsState<BossKeySettings> {
  BossKeySettingsState()
      : super({
          'Keysy': ItemWeightOption('bossKeysyWeight', 'All Boss Keys are removed from the pool'),
          'Own Dungeons': ItemWeightOption('bossKeysOwnDungWeight', 'Boss Keys are only available in their own dungeon'),
          'Anywhere': ItemWeightOption('bossKeysAnywhereWeight', 'Boss Keys are placed anywhere in the world. If this, Small Keys and Silver Rupees are all Anywhere, a shared Skeleton Key is added to the pool')
        });

  @override
  Widget build(BuildContext context) {
    return buildSettingsUI('Boss Key Shuffle', itemWeightKeys.keys.toList());
  }
}

// Silver Rupee Settings
class SilverRupeeSettings extends StatefulWidget {
  const SilverRupeeSettings({super.key});

  @override
  SilverRupeeSettingsState createState() => SilverRupeeSettingsState();
}

class SilverRupeeSettingsState extends ItemWeightSettingsState<SilverRupeeSettings> {
  SilverRupeeSettingsState()
      : super({
          'Vanilla': ItemWeightOption('silvVanWeight', 'OoT Silver Rupee Puzzles are untouched'),
          'Own Dungeons': ItemWeightOption('silvOwnDungWeight', 'OoT Silver Rupees are placed in their own dungeon'),
          'Anywhere': ItemWeightOption('silvAnywhereWeight', 'HARD OPTION: OoT Silver Rupees are placed anywhere in the world. If these, Small Keys and Boss Keys roll Anywhere, a Magical Rupee is added to the pool')
        });

  @override
  Widget build(BuildContext context) {
    return buildSettingsUI('OoT Silver Rupee Shuffle', itemWeightKeys.keys.toList());
  }
}

// Skull Settings
class SkullSettings extends StatefulWidget {
  const SkullSettings({super.key});

  @override
  SkullSettingsState createState() => SkullSettingsState();
}

class SkullSettingsState extends ItemWeightSettingsState<SkullSettings> {
  SkullSettingsState()
      : super({
          'OoT Vanilla': ItemWeightOption('skullVanWeight', 'All OoT Skulltulas are untouched'),
          'OoT Overworld': ItemWeightOption('skullOwWeight', 'OoT Skulltulas located in the Overworld are shuffled'),
          'OoT Dungeons': ItemWeightOption('skullDungWeight', 'OoT Skulltulas located in Dungeons are shuffled'),
          'OoT All': ItemWeightOption('skullFullWeight', 'All OoT Skulltulas are shuffled'),
          'MM Vanilla': ItemWeightOption('skullMmVanWeight', 'All MM Skulltulas are untouched'),
          'MM Cross': ItemWeightOption('skullMmCrossWeight', 'MM Skulltulas and OoT Skulltulas are mixed together (this opens 40 and 50 OoT Skull rewards)'),
          'MM Full': ItemWeightOption('skullMmFullWeight', 'All MM Skulltulas are shuffled')
        });

  @override
  Widget build(BuildContext context) {
    return buildSettingsUI('Skulltula Shuffle', itemWeightKeys.keys.toList());
  }
}

// Owl Settings
class OwlSettings extends StatefulWidget {
  const OwlSettings({super.key});

  @override
  OwlSettingsState createState() => OwlSettingsState();
}

class OwlSettingsState extends ItemWeightSettingsState<OwlSettings> {
  OwlSettingsState()
      : super({
        'Vanilla': ItemWeightOption('owlVanWeight', 'MM Owl Statues are untouched'),
        'Anywhere': ItemWeightOption('owlAnywhereWeight', 'All MM Owl Statues are shuffled into the world'),
        'Vanilla (ER)': ItemWeightOption('owlVanErWeight', 'MM Owl Statures are untouched if Overworld Entrance Randomizer is on'),
        'Anywhere (ER)': ItemWeightOption('owlAnywhereErWeight', 'All MM Owl Statues are shuffled into the world if Overworld Entrance Randomizer is on')
      });

  @override
  Widget build(BuildContext context) {
    return buildSettingsUI('Owl Shuffle', itemWeightKeys.keys.toList());
  }
}

// Stray Fairy Settings
class StrayFairySettings extends StatefulWidget {
  const StrayFairySettings({super.key});

  @override
  StrayFairySettingsState createState() => StrayFairySettingsState();
}

class StrayFairySettingsState extends ItemWeightSettingsState<StrayFairySettings> {
  StrayFairySettingsState()
      : super({
        'Chests Only': ItemWeightOption('strayFairyChestsWeight', 'MM Chests that contained Fairies are shuffled, no free standing fairy locations are available'),
        'All Locations': ItemWeightOption('strayFairyAllWeight', 'All MM Stray Fairy locations are added to locations to check')
      });

  @override
  Widget build(BuildContext context) {
    return buildSettingsUI('MM Stray Fairy Locations', itemWeightKeys.keys.toList());
  }
}

// Common Souls Settings
class SoulSettings extends StatefulWidget {
  const SoulSettings({super.key});

  @override
  SoulSettingsState createState() => SoulSettingsState();
}

class SoulSettingsState extends ItemWeightSettingsState<SoulSettings> {
  SoulSettingsState()
      : super({
        'None': ItemWeightOption('soulsNoneWeight', 'Souls are not added to the pool'),
        'NPCs Only': ItemWeightOption('soulsNPCWeight', 'Only Souls for friendly NPCs are shuffled into the pool'),
        'Enemies Only': ItemWeightOption('soulsEnemyWeight', 'Only Souls for enemies are shuffled into the pool'),
        'NPCs and Enemies': ItemWeightOption('soulsFullWeight', 'All types of Souls are shuffled into the pool')
      });

  @override
  Widget build(BuildContext context) {
    return buildSettingsUI('Souls Shuffle', itemWeightKeys.keys.toList());
  }
}

class SoulStartSettings extends StatefulWidget {
  const SoulStartSettings({super.key});

  @override
  SoulStartSettingsState createState() => SoulStartSettingsState();
}

class SoulStartSettingsState extends ItemWeightSettingsState<SoulStartSettings> {
  SoulStartSettingsState()
      : super({
        '0%': ItemWeightOption('souls0Weight', 'If Souls are shuffled, start with 0 Souls'),
        '25%': ItemWeightOption('souls25Weight', 'If Souls are shuffled, start with 25% of the Souls'),
        '50%': ItemWeightOption('souls50Weight', 'If Souls are shuffled, start with 50% of the Souls'),
        '75%': ItemWeightOption('souls75Weight', 'If Souls are shuffled, start with 75% of the Souls')
      });

  @override
  Widget build(BuildContext context) {
    return buildSettingsUI('Soul Start%', itemWeightKeys.keys.toList());
  }
}

// Boss Souls Settings
class BossSoulSettings extends StatefulWidget {
  const BossSoulSettings({super.key});

  @override
  BossSoulSettingsState createState() => BossSoulSettingsState();
}

class BossSoulSettingsState extends ItemWeightSettingsState<BossSoulSettings> {
  BossSoulSettingsState()
      : super({
        'None': ItemWeightOption('bossSoulsNoneWeight', 'No Boss Souls are added to the pool'),
        'Full': ItemWeightOption('bossSoulsFullWeight', 'Boss Souls are added to the pool and are part of the "Path to" hints'),
        'None (BK Shuffled)': ItemWeightOption('bossSoulsBKNoneWeight', 'No Boss Souls are added to the pool (if Boss Keys Shuffled Anywhere)'),
        'Full (BK Shuffled)': ItemWeightOption('bossSoulsBKFullWeight', 'Boss Souls are added to the pool and are part of the "Path to" hints (if Boss Keys Shuffled Anywhere)')
      });

  @override
  Widget build(BuildContext context) {
    return buildSettingsUI('Boss Souls', itemWeightKeys.keys.toList());
  }
}

// Clocks Settings
class ClockSettings extends StatefulWidget {
  const ClockSettings({super.key});

  @override
  ClockSettingsState createState() => ClockSettingsState();
}

class ClockSettingsState extends ItemWeightSettingsState<ClockSettings> {
  ClockSettingsState()
      : super({
        'Off': ItemWeightOption('clocksNoneWeight', 'Start with all times of day in MM'),
        'On': ItemWeightOption('clocksFullWeight', 'Clocks are shuffled into the pool'),
        'Ascending': ItemWeightOption('clocksAscWeight', 'If clocks are on, weight of progressive ascending (start with Day 1, next clock is Night 1 etc)'),
        'Descending': ItemWeightOption('clocksDescWeight', 'If clocks are on, weight of progressive descending (start with Night 3, next clock is Day 3 etc)'),
        'Seperate': ItemWeightOption('clocksSepWeight', 'If clocks are on, weight of clocks as unique items')
      });

  @override
  Widget build(BuildContext context) {
    return buildSettingsUI('Clocks', itemWeightKeys.keys.toList());
  }
}

// Clock Start Settings
class ClockStartSettings extends StatefulWidget {
  const ClockStartSettings({super.key});

  @override
  ClockStartSettingsState createState() => ClockStartSettingsState();
}

class ClockStartSettingsState extends ItemWeightSettingsState<ClockStartSettings> {
  ClockStartSettingsState()
      : super({
        '1': ItemWeightOption('clock1Weight', 'Start with 1 Clock in MM'),
        '2': ItemWeightOption('clock2Weight', 'Start with 2 Clocks in MM'),
        '3': ItemWeightOption('clock3Weight', 'Start with 3 Clocks in MM'),
        '4': ItemWeightOption('clock4Weight', 'Start with 4 Clocks in MM'),
        '5': ItemWeightOption('clock5Weight', 'Start with 5 Clocks in MM')
      });

  @override
  Widget build(BuildContext context) {
    return buildSettingsUI('Clock Start Amount', itemWeightKeys.keys.toList());
  }
}

// Ocarina Button Settings
class ButtonSettings extends StatefulWidget {
  const ButtonSettings({super.key});

  @override
  ButtonSettingsState createState() => ButtonSettingsState();
}

class ButtonSettingsState extends ItemWeightSettingsState<ButtonSettings> {
  ButtonSettingsState()
      : super({
        'Starting': ItemWeightOption('buttonStartWeight', 'Start with all Ocarina Buttons'),
        'Full': ItemWeightOption('buttonFullWeight', 'HARD OPTION: Ocarina Buttons are shuffled into the world'),
        'Starting (Song Shuffle)': ItemWeightOption('buttonStartSongShufWeight', 'Start with all Ocarina Buttons (if Song Shuffle is enabled)'),
        'Full (Song Shuffle)': ItemWeightOption('buttonFullSongShufWeight', 'HARD OPTION: Ocarina Buttons are shuffled into the world (if Song Shuffle is enabled)')
      });

  @override
  Widget build(BuildContext context) {
    return buildSettingsUI('Ocarina Buttons', itemWeightKeys.keys.toList());
  }
}

// Ocarina Button Start Settings
class ButtonStartSettings extends StatefulWidget {
  const ButtonStartSettings({super.key});

  @override
  ButtonStartSettingsState createState() => ButtonStartSettingsState();
}

class ButtonStartSettingsState extends ItemWeightSettingsState<ButtonStartSettings> {
  ButtonStartSettingsState()
      : super({
        '0': ItemWeightOption('button0Weight', 'Start with 0 Ocarina Buttons'),
        '1': ItemWeightOption('button1Weight', 'Start with 1 Ocarina Button'),
        '2': ItemWeightOption('button2Weight', 'Start with 2 Ocarina Buttons'),
        '3': ItemWeightOption('button3Weight', 'Start with 3 Ocarina Buttons'),
        '4': ItemWeightOption('button4Weight', 'Start with 4 Ocarina Buttons')
      });

  @override
  Widget build(BuildContext context) {
    return buildSettingsUI('Ocarina Buttons Start Amount', itemWeightKeys.keys.toList());
  }
}

// Pot Settings
class PotSettings extends StatefulWidget {
  const PotSettings({super.key});

  @override
  PotSettingsState createState() => PotSettingsState();
}

class PotSettingsState extends ItemWeightSettingsState<PotSettings> {
  PotSettingsState()
      : super({
        'None': ItemWeightOption('potNoneWeight', 'Pots are left untouched'),
        'Overworld': ItemWeightOption('potOwWeight', 'Pots located in the Overworld are shuffled'),
        'Dungeons': ItemWeightOption('potDungWeight', 'Pots located in Dungeons are shuffled'),
        'Full': ItemWeightOption('potFullWeight', 'All Pots are shuffled into the pool'),
      });

  @override
  Widget build(BuildContext context) {
    return buildSettingsUI('Pot Shuffle', itemWeightKeys.keys.toList());
  }
}

// Freestanding Settings
class FreestandingSettings extends StatefulWidget {
  const FreestandingSettings({super.key});

  @override
  FreestandingSettingsState createState() => FreestandingSettingsState();
}

class FreestandingSettingsState extends ItemWeightSettingsState<FreestandingSettings> {
  FreestandingSettingsState()
      : super({
        'None': ItemWeightOption('freeNoneWeight', 'Freestanding Rupees and Hearts are untouched'),
        'Overworld': ItemWeightOption('freeOwWeight', 'Freestanding Rupees and Hearts in OoT Overworld and MM are shuffled'),
        'Dungeons': ItemWeightOption('freeDungWeight', 'Freestanding Rupees and Hearts in OoT Dungeons and MM are shuffled'),
        'Full': ItemWeightOption('freeFullWeight', 'All Freestanding Rupees and Hearts are shuffled')
      });

  @override
  Widget build(BuildContext context) {
    return buildSettingsUI('Freestanding Misc. Shuffle', itemWeightKeys.keys.toList());
  }
}

// Pot Settings
class WonderSpotSettings extends StatefulWidget {
  const WonderSpotSettings({super.key});

  @override
  WonderSpotSettingsState createState() => WonderSpotSettingsState();
}

class WonderSpotSettingsState extends ItemWeightSettingsState<WonderSpotSettings> {
  WonderSpotSettingsState()
      : super({
        'None': ItemWeightOption('wonderNoneWeight', 'Wonder Items are left untouched'),
        'Overworld': ItemWeightOption('wonderOwWeight', 'Wonder Items in OoT Overworld and MM are shuffled'),
        'Dungeons': ItemWeightOption('wonderDungWeight', 'Wonder Items in OoT Dungeons and MM are shuffled'),
        'Full': ItemWeightOption('wonderFullWeight', 'All Wonder Items are shuffled')
      });

  @override
  Widget build(BuildContext context) {
    return buildSettingsUI('Wonder Items Shuffle', itemWeightKeys.keys.toList());
  }
}

// Snowball Settings
class SnowballSettings extends StatefulWidget {
  const SnowballSettings({super.key});

  @override
  SnowballSettingsState createState() => SnowballSettingsState();
}

class SnowballSettingsState extends ItemWeightSettingsState<SnowballSettings> {
  SnowballSettingsState()
      : super({
        'None': ItemWeightOption('snowballNoneWeight', 'MM Snowballs are left untouched'),
        'Overworld': ItemWeightOption('snowballOwWeight', 'MM Snowballs located in the Overworld are shuffled'),
        'Dungeons': ItemWeightOption('snowballDungWeight', 'MM Snowballs located in Dungeons are shuffled'),
        'Full': ItemWeightOption('snowballFullWeight', 'All MM Snowballs are shuffled')
      });

  @override
  Widget build(BuildContext context) {
    return buildSettingsUI('Snowball Shuffle', itemWeightKeys.keys.toList());
  }
}

// Grass Settings
class GrassSettings extends StatefulWidget {
  const GrassSettings({super.key});

  @override
  GrassSettingsState createState() => GrassSettingsState();
}

class GrassSettingsState extends ItemWeightSettingsState<GrassSettings> {
  GrassSettingsState()
      : super({
        'None': ItemWeightOption('grassNoneWeight', 'No Grass is shuffled'),
        'Overworld': ItemWeightOption('grassOwWeight', 'Grass located in the Overworld is shuffled. Termina Field is excluded'),
        'Dungeons': ItemWeightOption('grassDungWeight', 'Grass located in Dungeons is shuffled'),
        'Full': ItemWeightOption('grassFullWeight', 'All Grass is shuffled. Termina Field is excluded')
      });

  @override
  Widget build(BuildContext context) {
    return buildSettingsUI('Grass Shuffle', itemWeightKeys.keys.toList());
  }
}

// Crates and Barrels Settings
class CratesBarrelsSettings extends StatefulWidget {
  const CratesBarrelsSettings({super.key});

  @override
  CratesBarrelsSettingsState createState() => CratesBarrelsSettingsState();
}

class CratesBarrelsSettingsState extends ItemWeightSettingsState<CratesBarrelsSettings> {
  CratesBarrelsSettingsState()
      : super({
        'None': ItemWeightOption('cratesBarrelsNoneWeight', 'No Crates or Barrels are shuffled'),
        'Overworld': ItemWeightOption('cratesBarrelsOwWeight', 'Crates and Barrels located in the Overworld are shuffled'),
        'Dungeons': ItemWeightOption('cratesBarrelsDungWeight', 'Crates and Barrels located in Dungeons are shuffled'),
        'Full': ItemWeightOption('cratesBarrelsFullWeight', 'All Crates and Barrels are shuffled')
      });

  @override
  Widget build(BuildContext context) {
    return buildSettingsUI('Crates and Barrels Shuffle', itemWeightKeys.keys.toList());
  }
}

// Hives Settings
class HiveSettings extends StatefulWidget {
  const HiveSettings({super.key});

  @override
  HiveSettingsState createState() => HiveSettingsState();
}

class HiveSettingsState extends ItemWeightSettingsState<HiveSettings> {
  HiveSettingsState()
      : super({
        'None': ItemWeightOption('hiveNoneWeight', 'No beehives are shuffled'),
        'Full': ItemWeightOption('hiveFullWeight', 'All beehives are shuffled')
      });

  @override
  Widget build(BuildContext context) {
    return buildSettingsUI('Hive Shuffle', itemWeightKeys.keys.toList());
  }
}

// Icicles Settings
class IcicleSettings extends StatefulWidget {
  const IcicleSettings({super.key});

  @override
  IcicleSettingsState createState() => IcicleSettingsState();
}

class IcicleSettingsState extends ItemWeightSettingsState<IcicleSettings> {
  IcicleSettingsState()
      : super({
        'None': ItemWeightOption('icicleNoneWeight', 'No Icicles are shuffled'),
        'Full': ItemWeightOption('icicleFullWeight', 'All Icicles on the ground are shuffled')
      });

  @override
  Widget build(BuildContext context) {
    return buildSettingsUI('Icicle Shuffle', itemWeightKeys.keys.toList());
  }
}

// Red Boulders Settings
class RedBoulderSettings extends StatefulWidget {
  const RedBoulderSettings({super.key});

  @override
  RedBoulderSettingsState createState() => RedBoulderSettingsState();
}

class RedBoulderSettingsState extends ItemWeightSettingsState<RedBoulderSettings> {
  RedBoulderSettingsState()
      : super({
        'None': ItemWeightOption('redBoulderNoneWeight', 'No Red Boulders are shuffled'),
        'Full': ItemWeightOption('redBoulderFullWeight', 'All Red Boulders are shuffled')
      });

  @override
  Widget build(BuildContext context) {
    return buildSettingsUI('Red Boulder Shuffle', itemWeightKeys.keys.toList());
  }
}

// Cows Settings
class CowSettings extends StatefulWidget {
  const CowSettings({super.key});

  @override
  CowSettingsState createState() => CowSettingsState();
}

class CowSettingsState extends ItemWeightSettingsState<CowSettings> {
  CowSettingsState()
      : super({
        'None': ItemWeightOption('cowNoneWeight', 'No Cows are shuffled'),
        'Full': ItemWeightOption('cowFullWeight', 'All Cows are shuffled')
      });

  @override
  Widget build(BuildContext context) {
    return buildSettingsUI('Cow Shuffle', itemWeightKeys.keys.toList());
  }
}

// Butterfly Settings
class ButterflySettings extends StatefulWidget {
  const ButterflySettings({super.key});

  @override
  ButterflySettingsState createState() => ButterflySettingsState();
}

class ButterflySettingsState extends ItemWeightSettingsState<ButterflySettings> {
  ButterflySettingsState()
      : super({
        'None': ItemWeightOption('butterflyNoneWeight', 'No Butterflies are shuffled'),
        'Full': ItemWeightOption('butterflyFullWeight', 'All Buttersflies are shuffled (use a stick near a group of butterflies)')
      });

  @override
  Widget build(BuildContext context) {
    return buildSettingsUI('Butterfly Shuffle', itemWeightKeys.keys.toList());
  }
}

// Fairy Fountain Settings
class FairyFountainSettings extends StatefulWidget {
  const FairyFountainSettings({super.key});

  @override
  FairyFountainSettingsState createState() => FairyFountainSettingsState();
}

class FairyFountainSettingsState extends ItemWeightSettingsState<FairyFountainSettings> {
  FairyFountainSettingsState()
      : super({
        'None': ItemWeightOption('fairyFountainNoneWeight', 'No Fairy Fountains or Spots are shuffled'),
        'Full': ItemWeightOption('fairyFountainFullWeight', 'All Fairy Fountain and OoT Spots are shuffled (Navi will hint you the locations and importance)')
      });

  @override
  Widget build(BuildContext context) {
    return buildSettingsUI('Fairy Fountain Shuffle', itemWeightKeys.keys.toList());
  }
}

// Fishing Settings
class FishingSettings extends StatefulWidget {
  const FishingSettings({super.key});

  @override
  FishingSettingsState createState() => FishingSettingsState();
}

class FishingSettingsState extends ItemWeightSettingsState<FishingSettings> {
  FishingSettingsState()
      : super({
        'None': ItemWeightOption('fishingNoneWeight', 'No Fish at the Fishing Pond are shuffled'),
        'Full': ItemWeightOption('fishingFullWeight', 'All Fish (except the Loach checks) at the Fishing Pond are shuffled')
      });

  @override
  Widget build(BuildContext context) {
    return buildSettingsUI('Fishing Shuffle', itemWeightKeys.keys.toList());
  }
}

// Diving Settings
class DivingSettings extends StatefulWidget {
  const DivingSettings({super.key});

  @override
  DivingSettingsState createState() => DivingSettingsState();
}

class DivingSettingsState extends ItemWeightSettingsState<DivingSettings> {
  DivingSettingsState()
      : super({
        'None': ItemWeightOption('divingNoneWeight', 'Rupees from the Diving Game are untouched'),
        'Full': ItemWeightOption('divingFullWeight', 'All Rupees (except the largest) from the Diving Game are shuffled'),
      });

  @override
  Widget build(BuildContext context) {
    return buildSettingsUI('Diving Shuffle', itemWeightKeys.keys.toList());
  }
}

// Shop Settings
class ShopSettings extends StatefulWidget {
  const ShopSettings({super.key});

  @override
  ShopSettingsState createState() => ShopSettingsState();
}

class ShopSettingsState extends ItemWeightSettingsState<ShopSettings> {
  ShopSettingsState()
      : super({
        'Vanilla': ItemWeightOption('shopVanWeight', 'All standard shops and scrubs are untouched'),
        'Shops': ItemWeightOption('shopFullWeight', 'Standard shops are shuffled into the pool'),
        'Vanilla Merchants': ItemWeightOption('merchVanWeight', 'If shops are shuffled, merchants and scrubs untouched'),
        'Include Merchants': ItemWeightOption('merchFullWeight', 'If shops are shuffled, merchants and scrubs are also shuffled')
      });

  @override
  Widget build(BuildContext context) {
    return buildSettingsUI('Shop Shuffle', itemWeightKeys.keys.toList());
  }
}


// Red Ice Settings
class RedIceSettings extends StatefulWidget {
  const RedIceSettings({super.key});

  @override
  RedIceSettingsState createState() => RedIceSettingsState();
}

class RedIceSettingsState extends ItemWeightSettingsState<RedIceSettings> {
  RedIceSettingsState()
      : super({
        'None': ItemWeightOption('redIceNoneWeight', 'All OoT Red Ice locations are untouched'),
        'Full': ItemWeightOption('redIceFullWeight', 'Red Ice Melting is shuffled into the pool'),
      });

  @override
  Widget build(BuildContext context) {
    return buildSettingsUI('Red Ice Shuffle', itemWeightKeys.keys.toList());
  }
}

// Sword Settings
class SwordSettings extends StatefulWidget {
  const SwordSettings({super.key});

  @override
  SwordSettingsState createState() => SwordSettingsState();
}

class SwordSettingsState extends ItemWeightSettingsState<SwordSettings> {
  SwordSettingsState()
      : super({
        'Off': ItemWeightOption('swordStartWeight', 'Start with MM Sword and Shield, and OoT Master Sword'),
        'On': ItemWeightOption('swordShufWeight', 'All sword shuffled into the pool, OoT and MM have shared sword in this setting'),
      });

  @override
  Widget build(BuildContext context) {
    return buildSettingsUI('Sword Shuffle', itemWeightKeys.keys.toList());
  }
}

// Gerudo Card Settings
class GerudoCardSettings extends StatefulWidget {
  const GerudoCardSettings({super.key});

  @override
  GerudoCardSettingsState createState() => GerudoCardSettingsState();
}

class GerudoCardSettingsState extends ItemWeightSettingsState<GerudoCardSettings> {
  GerudoCardSettingsState()
      : super({
        'Start With': ItemWeightOption('gerudoStartWeight', 'Start with Gerudo Card'),
        'Vanilla': ItemWeightOption('gerudoVanillaWeight', 'Gerudo Card is vanilla (Fast Carpenters is on)'),
        'Anywhere': ItemWeightOption('gerudoAnywhereWeight', 'Gerudo Card is anywhere in the world')
      });

  @override
  Widget build(BuildContext context) {
    return buildSettingsUI('Gerudo Card Settings', itemWeightKeys.keys.toList());
  }
}

// Wallet Settings
class WalletSettings extends StatefulWidget {
  const WalletSettings({super.key});

  @override
  WalletSettingsState createState() => WalletSettingsState();
}

class WalletSettingsState extends ItemWeightSettingsState<WalletSettings> {
  WalletSettingsState()
      : super({
        'Child Wallet Start': ItemWeightOption('childWalletStartWeight', 'Start with Child Wallet'),
        'Child Wallet Shuffle': ItemWeightOption('childWalletShufWeight', 'Child Wallet Shuffled'),
        'Giant Max Wallet': ItemWeightOption('maxWalletGiant', 'Giant Wallet is max wallet in Price Shuffle'),
        'Colossal Max Wallet': ItemWeightOption('maxWalletColossal', 'Giant Wallet is max wallet in Price Shuffle'),
        'Bottomless Max Wallet': ItemWeightOption('maxWalletBottomless', 'Giant Wallet is max wallet in Price Shuffle')
      });

  @override
  Widget build(BuildContext context) {
    return buildSettingsUI('Wallet Settings', itemWeightKeys.keys.toList());
  }
}