import 'dart:convert';
import 'dart:io';
import 'package:ootmmgenerator/settings/general_settings.dart';

class ItemWeightSettings {
  static const Map<String, String> itemWeightKeys = {
    'songLocationsWeight': 'songLocationsWeight',
    'songOwlsWeight': 'songOwlsWeight',
    'songRewardsWeight': 'songRewardsWeight',
    'songAnywhereWeight': 'songAnywhereWeight',

    'smallKeysStandardWeight': 'smallKeysStandardWeight',
    'smallKeysyWeight': 'smallKeysyWeight',
    'smallKeysOwnDungWeight': 'smallKeysOwnDungWeight',
    'smallKeysAnywhereWeight': 'smallKeysAnywhereWeight',
    
    'bossKeysyWeight': 'bossKeysyWeight',
    'bossKeysOwnDungWeight': 'bossKeysOwnDungWeight',
    'bossKeysAnywhereWeight': 'bossKeysAnywhereWeight',
    
    'silvVanWeight': 'silvVanWeight',
    'silvOwnDungWeight': 'silvOwnDungWeight',
    'silvAnywhereWeight': 'silvAnywhereWeight',
    
    'skullVanWeight': 'skullVanWeight',
    'skullOwWeight': 'skullOwWeight',
    'skullDungWeight': 'skullDungWeight',
    'skullFullWeight': 'skullFullWeight',
    'skullMmVanWeight': 'skullMmVanWeight',
    'skullMmCrossWeight': 'skullMmCrossWeight',
    'skullMmFullWeight': 'skullMmFullWeight',
    
    'owlVanWeight': 'owlVanWeight',
    'owlAnywhereWeight': 'owlAnywhereWeight',
    'owlVanErWeight': 'owlVanErWeight',
    'owlAnywhereErWeight': 'owlAnywhereErWeight',
    
    'strayFairyChestsWeight': 'strayFairyChestsWeight',
    'strayFairyAllWeight': 'strayFairyAllWeight',
    
    'soulsNoneWeight': 'soulsNoneWeight',
    'soulsNPCWeight': 'soulsNPCWeight',
    'soulsEnemyWeight': 'soulsEnemyWeight',
    'soulsFullWeight': 'soulsFullWeight',
    
    'bossSoulsNoneWeight': 'bossSoulsNoneWeight',
    'bossSoulsFullWeight': 'bossSoulsFullWeight',
    'bossSoulsBKNoneWeight': 'bossSoulsBKNoneWeight',
    'bossSoulsBKFullWeight': 'bossSoulsBKNoneWeight',
    
    'clocksNoneWeight': 'clocksNoneWeight',
    'clocksFullWeight': 'clocksFullWeight',
    'clocksAscWeight': 'clocksAscWeight',
    'clocksDescWeight': 'clocksDescWeight',
    'clocksSepWeight': 'clocksSepWeight',
    
    'buttonStartWeight': 'buttonStartWeight',
    'buttonFullWeight': 'buttonFullWeight',
    'buttonStartSongShufWeight': 'buttonStartSongShufWeight',
    'buttonFullSongShufWeight': 'buttonFullSongShufWeight',
    
    'potNoneWeight': 'potNoneWeight',
    'potOwWeight': 'potOwWeight',
    'potDungWeight': 'potDungWeight',
    'potFullWeight': 'potFullWeight',
    
    'freeNoneWeight': 'freeNoneWeight',
    'freeOwWeight': 'freeOwWeight',
    'freeDungWeight': 'freeDungWeight',
    'freeFullWeight': 'freeFullWeight',
    
    'wonderNoneWeight': 'wonderNoneWeight',
    'wonderOwWeight': 'wonderOwWeight',
    'wonderDungWeight': 'wonderDungWeight',
    'wonderFullWeight': 'wonderFullWeight',
    
    'snowballNoneWeight': 'snowballNoneWeight',
    'snowballOwWeight': 'snowballOwWeight',
    'snowballDungWeight': 'snowballDungWeight',
    'snowballFullWeight': 'snowballFullWeight',
    
    'grassNoneWeight': 'grassNoneWeight',
    'grassOwWeight': 'grassOwWeight',
    'grassDungWeight': 'grassDungWeight',
    'grassFullWeight': 'grassFullWeight',
    
    'cratesBarrelsNoneWeight': 'cratesBarrelsNoneWeight',
    'cratesBarrelsOwWeight': 'cratesBarrelsOwWeight',
    'cratesBarrelsDungWeight': 'cratesBarrelsDungWeight',
    'cratesBarrelsFullWeight': 'cratesBarrelsFullWeight',
    
    'hiveNoneWeight': 'hiveNoneWeight',
    'hiveFullWeight': 'hiveFullWeight',
    
    'icicleNoneWeight': 'icicleNoneWeight',
    'icicleFullWeight': 'icicleFullWeight',
    
    'redBoulderNoneWeight': 'redBoulderNoneWeight',
    'redBoulderFullWeight': 'redBoulderFullWeight',
    
    'cowNoneWeight': 'cowNoneWeight',
    'cowFullWeight': 'cowFullWeight',
    
    'butterflyNoneWeight': 'butterflyNoneWeight',
    'butterflyFullWeight': 'butterflyFullWeight',
    
    'fairyFountainNoneWeight': 'fairyFountainNoneWeight',
    'fairyFountainFullWeight': 'fairyFountainFullWeight',
    
    'fishingNoneWeight': 'fishingNoneWeight',
    'fishingFullWeight': 'fishingFullWeight',
    
    'divingNoneWeight': 'divingNoneWeight',
    'divingFullWeight': 'divingFullWeight',
    
    'shopVanWeight': 'shopVanWeight',
    'shopFullWeight': 'shopFullWeight',
    'merchVanWeight': 'merchVanWeight',
    'merchFullWeight': 'merchFullWeight',

    "redIceNoneWeight": "redIceNoneWeight",
    "redIceFullWeight": "redIceFullWeight",
  };
}

// This function retrieves the item weights from persistent_settings.json
Future<Map<String, int>> getItemWeights() async {
  final dir = Directory.current;
  final settingsFile = File('${dir.path}/persistent_settings.json');

  Map<String, int> itemWeights = {};

  // Check if the settings file exists
  if (await settingsFile.exists()) {
    try {
      // Read the file and parse its contents
      String content = await settingsFile.readAsString();
      Map<String, dynamic> jsonData = jsonDecode(content);
      // Retrieve the item weights from the JSON data
      for (var key in ItemWeightSettings.itemWeightKeys.keys) {
        itemWeights[key] = jsonData[key] ?? 1; // Default to 1 if key doesn't exist
      }
    } catch (e) {
      print("Error loading settings from file: $e");
      // Fallback to default weights in case of an error
      for (var key in ItemWeightSettings.itemWeightKeys.keys) {
        itemWeights[key] = 1; // Default value
      }
    }
  } else {
    // If the settings file doesn't exist, use default weights
    for (var key in ItemWeightSettings.itemWeightKeys.keys) {
      itemWeights[key] = 1; // Default value
    }
  }

  return itemWeights;
}

class WorldWeightSettings {
  static const Map<String, String> worldWeightKeys = {
    'ootBeanVanWeight': 'ootBeanVanWeight',
    'ootBeanFullWeight':'ootBeanFullWeight',

    'zeldaMeetWeight': 'zeldaMeetWeight',
    'zeldaSkipWeight': 'zeldaSkipWeight',

    'zoraClosedWeight': 'zoraClosedWeight',
    'zoraAdultWeight': 'zoraAdultWeight',
    'zoraOpenWeight': 'zoraOpenWeight',
    'zoraClosedErWeight': 'zoraClosedErWeight',
    'zoraAdultErWeight': 'zoraAdultErWeight',
    'zoraOpenErWeight': 'zoraOpenErWeight',

    'zdAdultOffWeight': 'zdAdultOffWeight',
    'zdAdultOnWeight': 'zdAdultOnWeight',
    'zdAdultOffErWeight': 'zdAdultOffErWeight',
    'zdAdultOnErWeight': 'zdAdultOnErWeight',

    'dekuVanWeight': 'dekuVanWeight',
    'dekuClosedWeight': 'dekuClosedWeight',
    'dekuOpenWeight': 'dekuOpenWeight',

    'dotClosedWeight': 'dotClosedWeight',
    'dotOpenWeight': 'dotOpenWeight',

    'timeFreeOpenWeight': 'timeFreeOpenWeight',
    'timeSwordOpenWeight': 'timeSwordOpenWeight',
    'timeFreeClosedWeight': 'timeFreeClosedWeight',
    'timeSwordClosedWeight': 'timeSwordClosedWeight',

    'erNoneWeight': 'erNoneWeight',
    'erRegionWeight': 'erRegionWeight',
    'erExtWeight': 'erExtWeight',
    'erIntWeight': 'erIntWeight',
    'erFullWeight': 'erFullWeight',

    'dungErNoneWeight': 'dungErNoneWeight',
    'dungErFullWeight': 'dungErFullWeight',
    'gcErExcWeight': 'gcErExcWeight',
    'gcErIncWeight': 'gcErIncWeight',
    'gtErExcWeight': 'gtErExcWeight',
    'gtErIncWeight': 'gtErIncWeight',
    'ctErExcWeight': 'ctErExcWeight',
    'ctErIncWeight': 'ctErIncWeight',

    'bossErNoneWeight': 'bossErNoneWeight',
    'bossErFullWeight': 'bossErFullWeight',

    'spawnNoneWeight': 'spawnNoneWeight',
    'spawnChildWeight': 'spawnChildWeight',
    'spawnAdultWeight': 'spawnAdultWeight',
    'spawnFullWeight': 'spawnFullWeight',

    'grottoErNoneWeight': 'grottoErNoneWeight',
    'grottoErFullWeight': 'grottoErFullWeight',
  };
}

// This function retrieves the item weights from persistent_settings.json
Future<Map<String, int>> getWorldWeights() async {
  final dir = Directory.current;
  final settingsFile = File('${dir.path}/persistent_settings.json');

  Map<String, int> worldWeights = {};

  // Check if the settings file exists
  if (await settingsFile.exists()) {
    try {
      // Read the file and parse its contents
      String content = await settingsFile.readAsString();
      Map<String, dynamic> jsonData = jsonDecode(content);
      // Retrieve the item weights from the JSON data
      for (var key in WorldWeightSettings.worldWeightKeys.keys) {
        worldWeights[key] = jsonData[key] ?? 1; // Default to 1 if key doesn't exist
      }
    } catch (e) {
      print("Error loading settings from file: $e");
      // Fallback to default weights in case of an error
      for (var key in ItemWeightSettings.itemWeightKeys.keys) {
        worldWeights[key] = 1; // Default value
      }
    }
  } else {
    // If the settings file doesn't exist, use default weights
    for (var key in WorldWeightSettings.worldWeightKeys.keys) {
      worldWeights[key] = 1; // Default value
    }
  }

  return worldWeights;
}

// This function generates the JSON data using the weights
Future<void> generateJsonAndRunPython(Map<String, int> itemWeights, Map<String, int> worldWeights) async {
  // Create the gameplay settings JSON
  Map<String, dynamic> jsonData = {
    "SettingsString": "v1.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",

    "Goal": [["Ganon and Majora", "Triforce Hunt", "Triforce Quest"], [75, 10, 15]],
    "TriforcePieces": [[20, 25, 30], [50, 30, 20]],
    "LogicSettings":[["beatable", "none", "allLocations"], [0, 0, 100]],
    "ItemPool":[["plentiful", "normal", "scarce", "minimal", "barren"], [0, 100, 0, 0, 0]],
    
    "Mode": ["single"],
    "Players": [2],
    "Teams": [2],
    "DistinctWorlds": [true],
    
    "SharedItems": [true],

    "GameplaySettings": {
      "MinimumSettingsAmount":5,
      "MaximumSettingsAmount":99,
      "HardModeLimit":2,
      "TFGrassAllowed":[false],
      "AdultInMM":[[true, false], [100, 0]],
      "MMWorldLayout":[["us", "jp"], [100, 0]],
      
      "SongShuffle": [["Song Locations", "Mixed with Owls", "Dungeon Rewards", "Anywhere"], [itemWeights['songLocationsWeight'], itemWeights['songOwlsWeight'], itemWeights['songRewardsWeight'], itemWeights['songAnywhereWeight']]],
      "GrassShuffle": [["none", "dungeons", "overworld", "all"], [itemWeights['grassNoneWeight'], itemWeights['grassDungWeight'], itemWeights['grassOwWeight'], itemWeights['grassFullWeight']]],
      "PotShuffle":[["none", "dungeons", "overworld", "all"], [itemWeights['potNoneWeight'], itemWeights['potDungWeight'], itemWeights['potOwWeight'], itemWeights['potFullWeight']]],
      "FreestandingShuffle":[["none", "dungeons", "overworld", "all"], [itemWeights['freeNoneWeight'], itemWeights['freeDungWeight'], itemWeights['freeOwWeight'], itemWeights['freeFullWeight']]],
      "WonderSpotShuffle":[["none", "dungeons", "overworld", "all"], [itemWeights['wonderNoneWeight'], itemWeights['wonderDungWeight'], itemWeights['wonderOwWeight'], itemWeights['wonderFullWeight']]],
      "SwordShuffle":[[true, false], [30, 70]],
      "FairyFountainShuffle":[[true, false], [itemWeights['fairyFountainFullWeight'], itemWeights['fairyFountainNoneWeight']]],
      "ButterflyShuffle":[[true, false], [itemWeights['butterflyFullWeight'], itemWeights['butterflyNoneWeight']]],
      "CowShuffle":[[true, false], [itemWeights['cowFullWeight'], itemWeights['cowNoneWeight']]],
      "CratesAndBarrelsShuffle":[["none", "dungeons", "overworld", "all"], [itemWeights['cratesBarrelsNoneWeight'], itemWeights['cratesBarrelsDungWeight'], itemWeights['cratesBarrelsOwWeight'], itemWeights['cratesBarrelsFullWeight']]],
      "SnowballShuffle":[["none", "dungeons", "overworld", "all"], [itemWeights['snowballNoneWeight'], itemWeights['snowballDungWeight'], itemWeights['snowballOwWeight'], itemWeights['snowballFullWeight']]],
      "OoTSkulltulaShuffle":[["none", "Dungeons Only", "Overworld Only", "all"], [itemWeights['skullVanWeight'], itemWeights['skullDungWeight'], itemWeights['skullOwWeight'], itemWeights['skullFullWeight']]],
      "MMSkulltulaShuffle":[["none", "cross", "all"], [itemWeights['skullMmVanWeight'], itemWeights['skullMmCrossWeight'], itemWeights['skullMmFullWeight']]],
      "GerudoCardShuffle":[["starting", true, false], [20, 20, 60]],
      "FishingPondShuffle":[[true, false], [itemWeights['fishingFullWeight'], itemWeights['fishingNoneWeight']]],
      "DivingGameShuffle":[[true, false], [itemWeights['divingFullWeight'], itemWeights['divingNoneWeight']]],
      "HiveShuffle":[[true, false], [itemWeights['hiveFullWeight'], itemWeights['hiveNoneWeight']]],
      "RedBoulderShuffle":[[true, false], [itemWeights['redBoulderFullWeight'], itemWeights['redBoulderNoneWeight']]],
      "IcicleShuffle":[[true, false], [itemWeights['icicleFullWeight'], itemWeights['icicleNoneWeight']]],
      "RedIceShuffle":[[true, false], [itemWeights['redIceFullWeight'], itemWeights['redIceNoneWeight']]],
      "PrePlantedBeans":[[true, false], [worldWeights['ootBeanFullWeight'], worldWeights['ootBeanVanWeight']]],
      "SkipChildZelda":[[true, false], [worldWeights['zeldaSkipWeight'], worldWeights['zeldaMeetWeight']]],
      
      "ShopShuffle":[["none", "full"], [itemWeights['shopVanWeight'], itemWeights['shopFullWeight']]],
      "MerchantShuffle":[[true, false], [itemWeights['merchFullWeight'], itemWeights['merchVanWeight']]],
      "PriceShuffle":[["Affordable", "Vanilla", "Weighted Random", "Fully Random"], [20, 30, 50, 0]],
      "ChildWallet":[[true, false], [10, 90]],
      "MaxWalletSize":[["Giant", "Colossal", "Bottomless"], [40, 30, 30]],

      "OwlShuffle":[[true, false], [10, 90], [itemWeights['owlAnywhereErWeight'], itemWeights['owlVanErWeight']]],
      
      "SoulShuffle":[["None", "Enemy", "NPC", "Full"], [itemWeights['soulsNoneWeight'], itemWeights['soulsEnemyWeight'], itemWeights['soulsNPCWeight'], itemWeights['soulsFullWeight']]],
      "StartingEnemySoulPercentage":[[0, 25, 50, 75, 100], [0, 20, 60, 20, 0]],
      "StartingNPCSoulPercentage":[[0, 25, 50, 75, 100], [0, 20, 60, 20, 0]],
      
      "ClockShuffle":[[true, false], [itemWeights['clocksFullWeight'], itemWeights['clocksNoneWeight']]],
      "ProgressiveClockType":[["Ascending", "Descending", "Separate"], [itemWeights['clocksAscWeight'], itemWeights['clocksDescWeight'], itemWeights['clocksSepWeight']]],
      "StartingClockAmount": [[1, 2, 3, 4, 5], [10, 20, 40, 20, 10]], 
      
      "OcarinaButtons":[[true, false], [itemWeights['buttonFullWeight'], itemWeights['buttonStartWeight']], [itemWeights['buttonFullSongShufWeight'], itemWeights['buttonStartSongShufWeight']]],
      "StartingButtons":[[0, 1, 2, 3, 4], [5, 20, 30, 30, 15]],
      
      "SilverRupeeShuffle": [["Untouched", "Own Dungeon", "anywhere"], [itemWeights['silvVanWeight'], itemWeights['silvOwnDungWeight'], itemWeights['silvAnywhereWeight']]],
      "SmallKeyShuffle":[["MM Keysy, OoT Own Dungeon", "MM and OoT Keysy", "MM and OoT Own Dungeons", "MM and OoT Keysanity"], [itemWeights['smallKeysStandardWeight'], itemWeights['smallKeysyWeight'], itemWeights['smallKeysOwnDungWeight'], itemWeights['smallKeysAnywhereWeight']]],
      "BossKeyShuffle":[["Keysy", "Own Dungeon", "Keysanity"], [itemWeights['bossKeysyWeight'], itemWeights['bossKeysOwnDungWeight'], itemWeights['bossKeysAnywhereWeight']]],
      "BossSoulsWeight": [[true, false], [itemWeights['bossSoulsFullWeight'], itemWeights['bossSoulsNoneWeight']], [itemWeights['bossSoulsBKFullWeight'], itemWeights['bossSoulsBKNoneWeight']]],
      "StrayFairyShuffle": [["Removed", "Anywhere"], [itemWeights['strayFairyChestsWeight'], itemWeights['strayFairyAllWeight']]],
      "MQDungeonAmount":[[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], [4096, 2048, 1024, 512, 256, 128, 64, 32, 16, 8, 4, 2, 1]],
      "GibdoSettings":[["vanilla", "remorseless", "open"], [0, 90, 10]],
      "OpenDungeons":[[0, 1, 2, 3, 4, 5, 6, 7, 8, 9], [1024, 256, 128, 64, 32, 16, 8, 4, 2, 1]],
      "GanonTrialAmount":[[0, 1, 2, 3, 4, 5, 6], [64, 32, 16, 8, 4, 2, 1]],
      "TCGKeySettings":[["vanilla", "ownDungeon", "anywhere"], [60, 30, 10]],
      "KeyRingAmount":[["0 - 12/13 depending on TCG"], [4096, 2048, 1024, 512, 256, 128, 64, 32, 16, 8, 4, 2, 1], [8192, 4096, 2048, 1024, 512, 256, 128, 64, 32, 16, 8, 4, 2, 1]],
      "SilverPouchAmount":[["0 - 18, if the value is above the amount of Silver Pouches available due to MQ, it rerolls"], [262144, 131072, 65536, 32768, 16384, 8192, 4096, 2048, 1024, 512, 256, 128, 64, 32, 16, 8, 4, 2, 1]],
      
      "DekuTree":[["closed", "vanilla", "open"], [worldWeights['dekuClosedWeight'], worldWeights['dekuVanWeight'], worldWeights['dekuOpenWeight']]],
      "KingZora":[["vanilla", "adult", "open"], [worldWeights['zoraClosedWeight'], worldWeights['zoraAdultWeight'], worldWeights['zoraOpenWeight']], [worldWeights['zoraClosedErWeight'], worldWeights['zoraAdultErWeight'], worldWeights['zoraOpenErWeight']]],
      "ZoraDomainAdultShortcut":[[true, false], [worldWeights['zdAdultOnWeight'], worldWeights['zdAdultOffWeight']], [worldWeights['zdAdultOnErWeight'], worldWeights['zdAdultOffErWeight']]],
      "DoorOfTime":[["Closed", "Open"], [worldWeights['dotClosedWeight'], worldWeights['dotOpenWeight']]],
      "TimeTravelSword":[[true, false], [worldWeights['timeSwordOpenWeight'], worldWeights['timeFreeOpenWeight']], [worldWeights['timeSwordClosedWeight'], worldWeights['timeFreeClosedWeight']]],
      
      "WorldEntranceRandomizer": [["None", "Regions Only", "Overworld Only", "Interiors Only", "Full"], [worldWeights['erNoneWeight'], worldWeights['erRegionWeight'], worldWeights['erExtWeight'], worldWeights['erIntWeight'], worldWeights['erFullWeight']]],
      "GameLinkEntrances":[[true, false], [20, 80]],
      "WarpSongShuffle":[[true, false], [10, 90]],
      "DungeonEntranceShuffle": [[true, false], [worldWeights['dungErFullWeight'], worldWeights['dungErNoneWeight']]],
      "GanonCastleShuffle":[[true, false], [worldWeights['gcErIncWeight'], worldWeights['gcErExcWeight']]],
      "GanonTowerShuffle":[[true, false], [worldWeights['gtErIncWeight'], worldWeights['gtErExcWeight']]],
      "ClockTowerShuffle":[[true, false], [worldWeights['ctErIncWeight'], worldWeights['ctErExcWeight']]],
      "BossEntranceShuffle":[["none", "full"], [worldWeights['bossErNoneWeight'], worldWeights['bossErFullWeight']]],
      "GrottoShuffle":[["none", "full"], [worldWeights['grottoErNoneWeight'], worldWeights['grottoErFullWeight']]],
      "SpawnShuffle":[["none", "child", "adult", "both"], [worldWeights['spawnNoneWeight'], worldWeights['spawnChildWeight'], worldWeights['spawnAdultWeight'], worldWeights['spawnFullWeight']]],
      
      "Mixed":{
      "Allow":[[true, false], [0, 100]],
      "Regions":[[true, false], [0, 100]],
      "Overworld":[[true, false], [0, 100]],
      "Interior":[[true, false], [0, 100]],
      "Grottos":[[true, false], [100, 0]],
      "Dungeons":[[true, false], [100, 0]]
      },
      "DecoupledEntrances":[[true, false], [0, 100]],
      
      "AgelessAmount":[[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], [2048, 1024, 512, 256, 128, 64, 32, 16, 8, 4, 2, 1]]
    }
  };

  // Convert the Map to a JSON string
  String jsonString = jsonEncode(jsonData);

  // Save the JSON to a file
  final file = File('weightsFile.json');
  await file.writeAsString(jsonString);

  // Call the Python script
  await runPythonScript();
}

// This function runs the Python script
Future<void> runPythonScript() async {
  try {
    // Call the Python script, assuming it's in the same directory
    final result = await Process.run('python', ['generate.py']);
    print('Python Script Output: ${result.stdout}');
  } catch (e) {
    print('Error running Python script: $e');
  }
}

// This function will be called to generate the settings and run the Python script
Future<void> generateSettings() async {
  // Get the item weights from shared preferences
  Map<String, int> itemWeights = await getItemWeights();
  Map<String, int> worldWeights = await getWorldWeights();

  // Call the function to generate the JSON and run the Python script
  await generateJsonAndRunPython(itemWeights, worldWeights);
  print("JSON generated and Python script executed.");
}
