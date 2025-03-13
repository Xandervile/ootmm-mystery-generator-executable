import 'dart:convert';
import 'dart:io';

//'mainBlitz': "v1.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",


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

    'tcgStandardWeight': 'tcgStandardWeight',
    'tcgOwnDungWeight': 'tcgOwnDungWeight',
    'tcgAnywhereWeight': 'tcgAnywhereWeight',
    
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
    'souls0Weight': 'souls0Weight',
    'souls25Weight': 'souls25Weight',
    'souls50Weight': 'souls50Weight',
    'souls75Weight': 'souls75Weight',
    
    'bossSoulsNoneWeight': 'bossSoulsNoneWeight',
    'bossSoulsFullWeight': 'bossSoulsFullWeight',
    'bossSoulsBKNoneWeight': 'bossSoulsBKNoneWeight',
    'bossSoulsBKFullWeight': 'bossSoulsBKNoneWeight',

    'swordStartWeight': 'swordStartWeight',
    'swordShufWeight': 'swordShufWeight',
    
    'clocksNoneWeight': 'clocksNoneWeight',
    'clocksFullWeight': 'clocksFullWeight',
    'clocksAscWeight': 'clocksAscWeight',
    'clocksDescWeight': 'clocksDescWeight',
    'clocksSepWeight': 'clocksSepWeight',
    'clock1Weight': 'clock1Weight',
    'clock2Weight': 'clock2Weight',
    'clock3Weight': 'clock3Weight',
    'clock4Weight': 'clock4Weight',
    'clock5Weight': 'clock5Weight',
    
    'buttonStartWeight': 'buttonStartWeight',
    'buttonFullWeight': 'buttonFullWeight',
    'buttonStartSongShufWeight': 'buttonStartSongShufWeight',
    'buttonFullSongShufWeight': 'buttonFullSongShufWeight',
    'button0Weight': 'button0Weight',
    'button1Weight': 'button1Weight',
    'button2Weight': 'button2Weight',
    'button3Weight': 'button3Weight',
    'button4Weight': 'button4Weight',
    
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

    'gerudoStartWeight': 'gerudoStartWeight',
    'gerudoVanillaWeight': 'gerudoVanillaWeight',
    'gerudoAnywhereWeight': 'gerudoAnywhereWeight',

    'childWalletStartWeight': 'childWalletStartWeight',
    'childWalletShufWeight': 'childWalletShufWeight',
    'maxWalletGiant': 'maxWalletGiant',
    'maxWalletColossal': 'maxWalletColossal',
    'maxWalletBottomless': 'maxWalletBottomless'
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

    'priceAffordableWeight': 'priceAffordableWeight',
    'priceVanillaWeight': 'priceVanillaWeight',
    'priceWeightedWeight': 'priceWeightedWeight',
    'priceRandomWeight': 'priceRandomWeight',

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

    'decoupleFalseWeight': 'decoupleFalseWeight',
    'decoupleTrueWeight': 'decoupleTrueWeight',

    'mixedErFalseWeight': 'mixedErFalseWeight',
    'mixedErTrueWeight': 'mixedErTrueWeight',

    'mixedRegionErFalseWeight': 'mixedRegionErFalseWeight',
    'mixedRegionErTrueWeight': 'mixedRegionErTrueWeight',

    'mixedExteriorErFalseWeight': 'mixedExteriorErFalseWeight',
    'mixedExteriorErTrueWeight': 'mixedExteriorErTrueWeight',

    'mixedInteriorErFalseWeight': 'mixedInteriorErFalseWeight',
    'mixedInteriorErTrueWeight': 'mixedInteriorErTrueWeight',

    'mixedDungeonErFalseWeight': 'mixedDungeonErFalseWeight',
    'mixedDungeonErTrueWeight': 'mixedDungeonErTrueWeight',

    'mixedGrottoErFalseWeight': 'mixedGrottoErFalseWeight',
    'mixedGrottoErTrueWeight': 'mixedGrottoErTrueWeight',

    'gameLinkFalseWeight': 'gameLinkFalseWeight',
    'gameLinkTrueWeight': 'gameLinkTrueWeight',

    'warpNoneWeight': 'warpNoneWeight',
    'warpFullWeight': 'warpFullWeight',

    'openDungeon0Weight': 'openDungeon0Weight',
    'openDungeon1Weight': 'openDungeon1Weight',
    'openDungeon2Weight': 'openDungeon2Weight',
    'openDungeon3Weight': 'openDungeon3Weight',
    'openDungeon4Weight': 'openDungeon4Weight',
    'openDungeon5Weight': 'openDungeon5Weight',
    'openDungeon6Weight': 'openDungeon6Weight',
    'openDungeon7Weight': 'openDungeon7Weight',
    'openDungeon8Weight': 'openDungeon8Weight',
    'openDungeon9Weight': 'openDungeon9Weight',

    'mqDungeon0Weight': 'mqDungeon0Weight',
    'mqDungeon1Weight': 'mqDungeon1Weight',
    'mqDungeon2Weight': 'mqDungeon2Weight',
    'mqDungeon3Weight': 'mqDungeon3Weight',
    'mqDungeon4Weight': 'mqDungeon4Weight',
    'mqDungeon5Weight': 'mqDungeon5Weight',
    'mqDungeon6Weight': 'mqDungeon6Weight',
    'mqDungeon7Weight': 'mqDungeon7Weight',
    'mqDungeon8Weight': 'mqDungeon8Weight',
    'mqDungeon9Weight': 'mqDungeon9Weight',
    'mqDungeon10Weight': 'mqDungeon10Weight',
    'mqDungeon11Weight': 'mqDungeon11Weight',
    'mqDungeon12Weight': 'mqDungeon12Weight',
    
    'silverPouch0Weight': 'silverPouch0Weight',
    'silverPouch1Weight': 'silverPouch1Weight',
    'silverPouch2Weight': 'silverPouch2Weight',
    'silverPouch3Weight': 'silverPouch3Weight',
    'silverPouch4Weight': 'silverPouch4Weight',
    'silverPouch5Weight': 'silverPouch5Weight',
    'silverPouch6Weight': 'silverPouch6Weight',
    'silverPouch7Weight': 'silverPouch7Weight',
    'silverPouch8Weight': 'silverPouch8Weight',
    'silverPouch9Weight': 'silverPouch9Weight',
    'silverPouch10Weight': 'silverPouch10Weight',
    'silverPouch11Weight': 'silverPouch11Weight',
    'silverPouch12Weight': 'silverPouch12Weight',
    'silverPouch13Weight': 'silverPouch13Weight',
    'silverPouch14Weight': 'silverPouch14Weight',
    'silverPouch15Weight': 'silverPouch15Weight',
    'silverPouch16Weight': 'silverPouch16Weight',
    'silverPouch17Weight': 'silverPouch17Weight',
    'silverPouch18Weight': 'silverPouch18Weight',

    'keyRing0Weight': 'keyRing0Weight',
    'keyRing1Weight': 'keyRing1Weight',
    'keyRing2Weight': 'keyRing2Weight',
    'keyRing3Weight': 'keyRing3Weight',
    'keyRing4Weight': 'keyRing4Weight',
    'keyRing5Weight': 'keyRing5Weight',
    'keyRing6Weight': 'keyRing6Weight',
    'keyRing7Weight': 'keyRing7Weight',
    'keyRing8Weight': 'keyRing8Weight',
    'keyRing9Weight': 'keyRing9Weight',
    'keyRing10Weight': 'keyRing10Weight',
    'keyRing11Weight': 'keyRing11Weight',
    'keyRing12Weight': 'keyRing12Weight',
    'keyRing13Weight': 'keyRing13Weight',

    'ageless0Weight': 'ageless0Weight',
    'ageless1Weight': 'ageless1Weight',
    'ageless2Weight': 'ageless2Weight',
    'ageless3Weight': 'ageless3Weight',
    'ageless4Weight': 'ageless4Weight',
    'ageless5Weight': 'ageless5Weight',
    'ageless6Weight': 'ageless6Weight',
    'ageless7Weight': 'ageless7Weight',
    'ageless8Weight': 'ageless8Weight',
    'ageless9Weight': 'ageless9Weight',
    'ageless10Weight': 'ageless10Weight',
    'ageless11Weight': 'ageless11Weight',

    'gibdoVanillaWeight': 'gibdoVanillaWeight',
    'gibdoRemorselessWeight': 'gibdoRemorselessWeight',
    'gibdoRemovedWeight': 'gibdoRemovedWeight',
    'gibdoVanillaErWeight': 'gibdoVanillaErWeight',
    'gibdoRemorselessErWeight': 'gibdoRemorselessErWeight',
    'gibdoRemovedErWeight': 'gibdoRemovedErWeight',

    'trials0Weight': 'trials0Weight',
    'trials1Weight': 'trials1Weight',
    'trials2Weight': 'trials2Weight',
    'trials3Weight': 'trials3Weight',
    'trials4Weight': 'trials4Weight',
    'trials5Weight': 'trials5Weight',
    'trials6Weight': 'trials6Weight',

    'mmUsLayoutWeight': 'mmUsLayoutWeight',
    'mmJpLayoutWeight': 'mmJpLayoutWeight'
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

class MainWeightSettings {
  static const Map<String, String> mainWeightKeys = {
    "playerCount": "playerCount",
    "teamCount": "teamCount",
    "multiMode": "multiMode",
    "minSettingsAmount": "minSettingsAmount",
    "maxSettingsAmount": "maxSettingsAmount",
    "hardModeLimit": "hardModeLimit",
    "distinctWorlds": "distinctWorlds",
    "sharedItems": "sharedItems",
    "presetTemplate": "presetTemplate",

    "itemPoolPlentiful": "itemPoolPlentiful",
    "itemPoolNormal": "itemPoolNormal",
    "itemPoolScarce": "itemPoolScarce",
    "itemPoolMinimal": "itemPoolMinimal",
    "itemPoolBarren": "itemPoolBarren",

    "winGMWeight": "winGMWeight",
    "winPiecesWeight": "winPiecesWeight",
    "winQuestWeight": "winQuestWeight",

    "pieces20Weight": "pieces20Weight",
    "pieces25Weight": "pieces25Weight",
    "pieces30Weight": "pieces30Weight",
    "pieces35Weight": "pieces35Weight",
    "pieces40Weight": "pieces40Weight",

    "mmAdultTrueWeight": 'mmAdultTrueWeight',
    'mmAdultFalseWeight': 'mmAdultFalseWeight',

    'instantTransform': 'instantTransform',

    "hookshotAnywhereOnWeight": 'hookshotAnywhereOnWeight',
    "hookshotAnywhereOffWeight": 'hookshotAnywhereOffWeight',

    'climbSurfacesOnWeight': 'climbSurfacesOnWeight',
    'climbSurfacesOffWeight': 'climbSurfacesOffWeight',
  };
}

// This function retrieves the item weights from persistent_settings.json
Future<Map<String, String>> getMainWeights() async {
  final dir = Directory.current;
  final settingsFile = File('${dir.path}/persistent_settings.json');

  Map<String, String> mainWeights = {};

  // Check if the settings file exists
  if (await settingsFile.exists()) {
    try {
      // Read the file and parse its contents
      String content = await settingsFile.readAsString();
      Map<String, dynamic> jsonData = jsonDecode(content);

      // Retrieve the item weights from the JSON data
      for (var key in MainWeightSettings.mainWeightKeys.keys) {
        // Store the value as a String (for easier handling)
        mainWeights[key] = jsonData[key]?.toString() ?? ''; // Default to empty string if the key doesn't exist
      }
    } catch (e) {
      print("Error loading settings from file: $e");
      // Fallback to default weights in case of an error
      for (var key in MainWeightSettings.mainWeightKeys.keys) {
        mainWeights[key] = ''; // Default value as an empty string
      }
    }
  } else {
    // If the settings file doesn't exist, use default weights
    for (var key in MainWeightSettings.mainWeightKeys.keys) {
      mainWeights[key] = ''; // Default value as an empty string
    }
  }

  return mainWeights;
}

class SettingsMapping {
  static const Map<String, String> presetMap = {
    "blitz": "v1.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",
    "standard": "v1.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",
  };
}


// This function generates the JSON data using the weights
Future<void> generateJsonAndRunPython(Map<String, int> itemWeights, Map<String, int> worldWeights, Map<String, String> mainWeights) async {
  // Create the gameplay settings JSON
  Map<String, dynamic> jsonData = {
    "SettingsString": SettingsMapping.presetMap[mainWeights["presetTemplate"]],

    "Goal": [["Ganon and Majora", "Triforce Hunt", "Triforce Quest"], [int.tryParse(mainWeights["winGMWeight"] ?? "") ?? 70, int.tryParse(mainWeights["winPiecesWeight"] ?? "") ?? 10, int.tryParse(mainWeights["winQuestWeight"] ?? "") ?? 20]],
    "TriforcePieces": [[20, 25, 30, 35, 40], [int.tryParse(mainWeights["pieces20Weight"] ?? "") ?? 15, int.tryParse(mainWeights["pieces25Weight"] ?? "") ?? 20, int.tryParse(mainWeights["pieces30Weight"] ?? "") ?? 30, int.tryParse(mainWeights["pieces35Weight"] ?? "") ?? 20, int.tryParse(mainWeights["pieces40Weight"] ?? "") ?? 15]],
    "LogicSettings":[["beatable", "none", "allLocations"], [0, 0, 100]],
    "ItemPool":[["plentiful", "normal", "scarce", "minimal", "barren"], [int.tryParse(mainWeights["itemPoolPlentiful"] ?? "") ?? 0, int.tryParse(mainWeights["itemPoolNormal"] ?? "") ?? 100, int.tryParse(mainWeights["itemPoolScarce"] ?? "") ?? 0, int.tryParse(mainWeights["itemPoolMinimal"] ?? "") ?? 0, int.tryParse(mainWeights["itemPoolBarren"] ?? "") ?? 0]],
    
    "Mode": [mainWeights['multiMode']],
    "Players": [int.tryParse(mainWeights["playerCount"] ?? "") ?? 2],
    "Teams": [int.tryParse(mainWeights["teamCount"] ?? "") ?? 1],
    "DistinctWorlds": [mainWeights["distinctWorlds"]],
    
    "SharedItems": [mainWeights["sharedItems"]],
    "InstantTransform": [mainWeights["instantTransform"]],

    "GameplaySettings": {
      "MinimumSettingsAmount": int.tryParse(mainWeights["minSettingsAmount"] ?? "") ?? 4,
      "MaximumSettingsAmount": int.tryParse(mainWeights["maxSettingsAmount"] ?? "") ?? 99,
      "HardModeLimit": int.tryParse(mainWeights["hardModeLimit"] ?? "") ?? 2,
      "TFGrassAllowed":[false],
      "AdultInMM":[[true, false], [int.tryParse(mainWeights["mmAdultTrueWeight"] ?? "") ?? 100, int.tryParse(mainWeights["mmAdultFalseWeight"] ?? "") ?? 0]],
      "MMWorldLayout":[["us", "jp"], [worldWeights['mmUsLayoutWeight'], worldWeights['mmJpLayoutWeight']]],
      
      "SongShuffle": [["Song Locations", "Mixed with Owls", "Dungeon Rewards", "Anywhere"], [itemWeights['songLocationsWeight'], itemWeights['songOwlsWeight'], itemWeights['songRewardsWeight'], itemWeights['songAnywhereWeight']]],
      "GrassShuffle": [["none", "dungeons", "overworld", "all"], [itemWeights['grassNoneWeight'], itemWeights['grassDungWeight'], itemWeights['grassOwWeight'], itemWeights['grassFullWeight']]],
      "PotShuffle":[["none", "dungeons", "overworld", "all"], [itemWeights['potNoneWeight'], itemWeights['potDungWeight'], itemWeights['potOwWeight'], itemWeights['potFullWeight']]],
      "FreestandingShuffle":[["none", "dungeons", "overworld", "all"], [itemWeights['freeNoneWeight'], itemWeights['freeDungWeight'], itemWeights['freeOwWeight'], itemWeights['freeFullWeight']]],
      "WonderSpotShuffle":[["none", "dungeons", "overworld", "all"], [itemWeights['wonderNoneWeight'], itemWeights['wonderDungWeight'], itemWeights['wonderOwWeight'], itemWeights['wonderFullWeight']]],
      "SwordShuffle":[[true, false], [itemWeights['swordShufWeight'], itemWeights["swordStartWeight"]]],
      "FairyFountainShuffle":[[true, false], [itemWeights['fairyFountainFullWeight'], itemWeights['fairyFountainNoneWeight']]],
      "ButterflyShuffle":[[true, false], [itemWeights['butterflyFullWeight'], itemWeights['butterflyNoneWeight']]],
      "CowShuffle":[[true, false], [itemWeights['cowFullWeight'], itemWeights['cowNoneWeight']]],
      "CratesAndBarrelsShuffle":[["none", "dungeons", "overworld", "all"], [itemWeights['cratesBarrelsNoneWeight'], itemWeights['cratesBarrelsDungWeight'], itemWeights['cratesBarrelsOwWeight'], itemWeights['cratesBarrelsFullWeight']]],
      "SnowballShuffle":[["none", "dungeons", "overworld", "all"], [itemWeights['snowballNoneWeight'], itemWeights['snowballDungWeight'], itemWeights['snowballOwWeight'], itemWeights['snowballFullWeight']]],
      "OoTSkulltulaShuffle":[["none", "Dungeons Only", "Overworld Only", "all"], [itemWeights['skullVanWeight'], itemWeights['skullDungWeight'], itemWeights['skullOwWeight'], itemWeights['skullFullWeight']]],
      "MMSkulltulaShuffle":[["none", "cross", "all"], [itemWeights['skullMmVanWeight'], itemWeights['skullMmCrossWeight'], itemWeights['skullMmFullWeight']]],
      "GerudoCardShuffle":[["starting", true, false], [itemWeights['gerudoStartWeight'], itemWeights['gerudoAnywhereWeight'], itemWeights['gerudoVanillaWeight']]],
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
      "PriceShuffle":[["Affordable", "Vanilla", "Weighted Random", "Fully Random"], [worldWeights["priceAffordableWeight"], worldWeights["priceVanillaWeight"], worldWeights["priceWeightedWeight"], worldWeights["priceRandomWeight"]]],
      "ChildWallet":[[true, false], [itemWeights['childWalletShufWeight'], itemWeights['childWalletStartWeight']]],
      "MaxWalletSize":[["Giant", "Colossal", "Bottomless"], [itemWeights['maxWalletGiant'], itemWeights['maxWalletColossal'], itemWeights['maxWalletBottomless']]],

      "OwlShuffle":[[true, false], [itemWeights['owlAnywhereWeight'], itemWeights['owlVanWeight']], [itemWeights['owlAnywhereErWeight'], itemWeights['owlVanErWeight']]],
      
      "SoulShuffle":[["None", "Enemy", "NPC", "Full"], [itemWeights['soulsNoneWeight'], itemWeights['soulsEnemyWeight'], itemWeights['soulsNPCWeight'], itemWeights['soulsFullWeight']]],
      "StartingEnemySoulPercentage":[[0, 25, 50, 75], [itemWeights['souls0Weight'], itemWeights['souls25Weight'], itemWeights['souls50Weight'], itemWeights['souls75Weight']]],
      "StartingNPCSoulPercentage":[[0, 25, 50, 75], [itemWeights['souls0Weight'], itemWeights['souls25Weight'], itemWeights['souls50Weight'], itemWeights['souls75Weight']]],
      
      "ClockShuffle":[[true, false], [itemWeights['clocksFullWeight'], itemWeights['clocksNoneWeight']]],
      "ProgressiveClockType":[["Ascending", "Descending", "Separate"], [itemWeights['clocksAscWeight'], itemWeights['clocksDescWeight'], itemWeights['clocksSepWeight']]],
      "StartingClockAmount": [[1, 2, 3, 4, 5], [itemWeights['clock1Weight'], itemWeights['clock2Weight'], itemWeights['clock3Weight'], itemWeights['clock4Weight'], itemWeights['clock5Weight']]], 
      
      "OcarinaButtons":[[true, false], [itemWeights['buttonFullWeight'], itemWeights['buttonStartWeight']], [itemWeights['buttonFullSongShufWeight'], itemWeights['buttonStartSongShufWeight']]],
      "StartingButtons":[[0, 1, 2, 3, 4], [itemWeights['button0Weight'], itemWeights['button1Weight'], itemWeights['button2Weight'], itemWeights['button3Weight'], itemWeights['button4Weight']]],
      
      "SilverRupeeShuffle": [["Untouched", "Own Dungeon", "anywhere"], [itemWeights['silvVanWeight'], itemWeights['silvOwnDungWeight'], itemWeights['silvAnywhereWeight']]],
      "SmallKeyShuffle":[["MM Keysy, OoT Own Dungeon", "MM and OoT Keysy", "MM and OoT Own Dungeons", "MM and OoT Keysanity"], [itemWeights['smallKeysStandardWeight'], itemWeights['smallKeysyWeight'], itemWeights['smallKeysOwnDungWeight'], itemWeights['smallKeysAnywhereWeight']]],
      "BossKeyShuffle":[["Keysy", "Own Dungeon", "Keysanity"], [itemWeights['bossKeysyWeight'], itemWeights['bossKeysOwnDungWeight'], itemWeights['bossKeysAnywhereWeight']]],
      "BossSoulsWeight": [[true, false], [itemWeights['bossSoulsFullWeight'], itemWeights['bossSoulsNoneWeight']], [itemWeights['bossSoulsBKFullWeight'], itemWeights['bossSoulsBKNoneWeight']]],
      "StrayFairyShuffle": [["Removed", "Anywhere"], [itemWeights['strayFairyChestsWeight'], itemWeights['strayFairyAllWeight']]],
      "MQDungeonAmount":[[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], [worldWeights['mqDungeon0Weight'], worldWeights['mqDungeon1Weight'], worldWeights['mqDungeon2Weight'], worldWeights['mqDungeon3Weight'], worldWeights['mqDungeon4Weight'], worldWeights['mqDungeon5Weight'], worldWeights['mqDungeon6Weight'], worldWeights['mqDungeon7Weight'], worldWeights['mqDungeon8Weight'], worldWeights['mqDungeon9Weight'], worldWeights['mqDungeon10Weight'], worldWeights['mqDungeon11Weight'], worldWeights['mqDungeon12Weight']]],
      "GibdoSettings":[["vanilla", "remorseless", "open"], [worldWeights['gibdoVanillaWeight'], worldWeights['gibdoRemorselessWeight'], worldWeights['gibdoRemovedWeight']], [worldWeights['gibdoVanillaErWeight'], worldWeights['gibdoRemorselessErWeight'], worldWeights['gibdoRemovedErWeight']]],
      "OpenDungeons":[[0, 1, 2, 3, 4, 5, 6, 7, 8, 9], [worldWeights['openDungeon0Weight'], worldWeights['openDungeon1Weight'], worldWeights['openDungeon2Weight'], worldWeights['openDungeon3Weight'], worldWeights['openDungeon4Weight'], worldWeights['openDungeon5Weight'], worldWeights['openDungeon6Weight'], worldWeights['openDungeon7Weight'], worldWeights['openDungeon8Weight'], worldWeights['openDungeon9Weight']]],
      "GanonTrialAmount":[[0, 1, 2, 3, 4, 5, 6], [worldWeights['trials0Weight'], worldWeights['trials1Weight'], worldWeights['trials2Weight'], worldWeights['trials3Weight'], worldWeights['trials4Weight'], worldWeights['trials5Weight'], worldWeights['trials6Weight']]],
      "TCGKeySettings":[["vanilla", "ownDungeon", "anywhere"], [itemWeights['tcgStandardWeight'], itemWeights['tcgOwnDungWeight'], itemWeights['tcgAnywhereWeight']]],
      "KeyRingAmount":[["0 - 12/13 depending on TCG"], [worldWeights['keyRing0Weight'], worldWeights['keyRing1Weight'], worldWeights['keyRing2Weight'], worldWeights['keyRing3Weight'], worldWeights['keyRing4Weight'], worldWeights['keyRing5Weight'], worldWeights['keyRing6Weight'], worldWeights['keyRing7Weight'], worldWeights['keyRing8Weight'], worldWeights['keyRing9Weight'], worldWeights['keyRing10Weight'], worldWeights['keyRing11Weight'], worldWeights['keyRing12Weight']], [worldWeights['keyRing0Weight'], worldWeights['keyRing1Weight'], worldWeights['keyRing2Weight'], worldWeights['keyRing3Weight'], worldWeights['keyRing4Weight'], worldWeights['keyRing5Weight'], worldWeights['keyRing6Weight'], worldWeights['keyRing7Weight'], worldWeights['keyRing8Weight'], worldWeights['keyRing9Weight'], worldWeights['keyRing10Weight'], worldWeights['keyRing11Weight'], worldWeights['keyRing12Weight'], worldWeights['keyRing13Weight']]],
      "SilverPouchAmount":[["0 - 18, if the value is above the amount of Silver Pouches available due to MQ, it rerolls"], [worldWeights['silverPouch0Weight'], worldWeights['silverPouch1Weight'], worldWeights['silverPouch2Weight'], worldWeights['silverPouch3Weight'], worldWeights['silverPouch4Weight'], worldWeights['silverPouch5Weight'], worldWeights['silverPouch6Weight'], worldWeights['silverPouch7Weight'], worldWeights['silverPouch8Weight'], worldWeights['silverPouch9Weight'], worldWeights['silverPouch10Weight'], worldWeights['silverPouch11Weight'], worldWeights['silverPouch12Weight'], worldWeights['silverPouch13Weight'], worldWeights['silverPouch14Weight'], worldWeights['silverPouch15Weight'], worldWeights['silverPouch16Weight'], worldWeights['silverPouch17Weight'], worldWeights['silverPouch18Weight']]],
      
      "DekuTree":[["closed", "vanilla", "open"], [worldWeights['dekuClosedWeight'], worldWeights['dekuVanWeight'], worldWeights['dekuOpenWeight']]],
      "KingZora":[["vanilla", "adult", "open"], [worldWeights['zoraClosedWeight'], worldWeights['zoraAdultWeight'], worldWeights['zoraOpenWeight']], [worldWeights['zoraClosedErWeight'], worldWeights['zoraAdultErWeight'], worldWeights['zoraOpenErWeight']]],
      "ZoraDomainAdultShortcut":[[true, false], [worldWeights['zdAdultOnWeight'], worldWeights['zdAdultOffWeight']], [worldWeights['zdAdultOnErWeight'], worldWeights['zdAdultOffErWeight']]],
      "DoorOfTime":[["Closed", "Open"], [worldWeights['dotClosedWeight'], worldWeights['dotOpenWeight']]],
      "TimeTravelSword":[[true, false], [worldWeights['timeSwordOpenWeight'], worldWeights['timeFreeOpenWeight']], [worldWeights['timeSwordClosedWeight'], worldWeights['timeFreeClosedWeight']]],
      
      "WorldEntranceRandomizer": [["None", "Regions Only", "Overworld Only", "Interiors Only", "Full"], [worldWeights['erNoneWeight'], worldWeights['erRegionWeight'], worldWeights['erExtWeight'], worldWeights['erIntWeight'], worldWeights['erFullWeight']]],
      "GameLinkEntrances":[[true, false], [worldWeights['gameLinkTrueWeight'], worldWeights['gameLinkFalseWeight']]],
      "WarpSongShuffle":[[true, false], [worldWeights['warpFullWeight'], worldWeights['warpNoneWeight']]],
      "DungeonEntranceShuffle": [[true, false], [worldWeights['dungErFullWeight'], worldWeights['dungErNoneWeight']]],
      "GanonCastleShuffle":[[true, false], [worldWeights['gcErIncWeight'], worldWeights['gcErExcWeight']]],
      "GanonTowerShuffle":[[true, false], [worldWeights['gtErIncWeight'], worldWeights['gtErExcWeight']]],
      "ClockTowerShuffle":[[true, false], [worldWeights['ctErIncWeight'], worldWeights['ctErExcWeight']]],
      "BossEntranceShuffle":[["none", "full"], [worldWeights['bossErNoneWeight'], worldWeights['bossErFullWeight']]],
      "GrottoShuffle":[["none", "full"], [worldWeights['grottoErNoneWeight'], worldWeights['grottoErFullWeight']]],
      "SpawnShuffle":[["none", "child", "adult", "both"], [worldWeights['spawnNoneWeight'], worldWeights['spawnChildWeight'], worldWeights['spawnAdultWeight'], worldWeights['spawnFullWeight']]],
      
      "Mixed":{
      "Allow":[[true, false], [worldWeights['mixedErTrueWeight'], worldWeights['mixedErFalseWeight']]],
      "Regions":[[true, false], [worldWeights['mixedRegionErTrueWeight'], worldWeights['mixedRegionErFalseWeight']]],
      "Overworld":[[true, false], [worldWeights['mixedExteriorErTrueWeight'], worldWeights['mixedExteriorErFalseWeight']]],
      "Interior":[[true, false], [worldWeights['mixedInteriorErTrueWeight'], worldWeights['mixedInteriorErFalseWeight']]],
      "Grottos":[[true, false], [worldWeights['mixedGrottoErTrueWeight'], worldWeights['mixedGrottoErFalseWeight']]],
      "Dungeons":[[true, false], [worldWeights['mixedDungeonErTrueWeight'], worldWeights['mixedDungeonErFalseWeight']]]
      },
      "DecoupledEntrances":[[true, false], [worldWeights['decoupleTrueWeight'], worldWeights['decoupleFalseWeight']]],
      
      "AgelessAmount":[[0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11], [worldWeights['ageless0Weight'], worldWeights['ageless1Weight'], worldWeights['ageless2Weight'], worldWeights['ageless3Weight'], worldWeights['ageless4Weight'], worldWeights['ageless5Weight'], worldWeights['ageless6Weight'], worldWeights['ageless7Weight'], worldWeights['ageless8Weight'], worldWeights['ageless9Weight'], worldWeights['ageless10Weight'], worldWeights['ageless11Weight']]],

      "ClimbMostSurfaces": [[true, false], [int.tryParse(mainWeights['climbSurfacesOnWeight'] ?? "") ?? 0, int.tryParse(mainWeights['climbSurfacesOffWeight'] ?? "") ?? 100]],
      "HookshotSurfaces":[[true, false], [int.tryParse(mainWeights['hookshotAnywhereOnWeight'] ?? "") ?? 0, int.tryParse(mainWeights['hookshotAnywhereOffWeight'] ?? "") ?? 100]],
    }
  };

  // Convert the Map to a JSON string
  String jsonString = jsonEncode(jsonData);

  // Save the JSON to a file
  final file = File('weightsFile.json');
  await file.writeAsString(jsonString);

  // Call the Python script
  await runPythonScript(mainWeights);
}

// This function runs the Python script
Future<void> runPythonScript(Map<String, String> mainWeights) async {
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
  Map<String, String> mainWeights = await getMainWeights();

  // Call the function to generate the JSON and run the Python script
  await generateJsonAndRunPython(itemWeights, worldWeights, mainWeights);
  print("JSON generated and Python script executed.");
}
