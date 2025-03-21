import zlib
import base64
import json
import random
import argparse
import os
import sys
generator_dir = os.path.dirname(os.path.abspath(__file__))

###############
## Arguments ##
###############
parser = argparse.ArgumentParser(
    prog="OoTMM Settings Generator",
    description="Randomly generates OoTMM settings strings so that settings themselves can be randomised.")

# Position-based argument: 0th argument.
parser.add_argument(
    "configfile",
    nargs="?",
    default="weightsFile.json",
    help="location of config file to use (default: Config - OoTMM Mystery Blitz Rando WIP.json)")
    
args = parser.parse_args()

####################################

if not os.path.exists(args.configfile):
    print(f"Error: Config File ({args.configfile}) not found.", file=sys.stderr)
    sys.exit(1)

with open(args.configfile, "r") as read_file:
    data = json.load(read_file)

basestring = data["SettingsString"]

base_data = basestring.split(".")[1]

padding_needed = len(base_data) % 4
if padding_needed:
    base_data += "=" * (4 - padding_needed)

decoded_data = zlib.decompress(base64.urlsafe_b64decode(base_data))

base_settings = json.loads(decoded_data)

settings = data["GameplaySettings"]

MinMysterySettings = settings["MinimumSettingsAmount"]
MaxMysterySettings = settings["MaximumSettingsAmount"]
MysteryCount = -1
HardCounter = 0

EnemySouls = ["SHARED_SOUL_ENEMY_ARMOS", "SHARED_SOUL_ENEMY_BEAMOS", "SHARED_SOUL_ENEMY_BUBBLE", "SHARED_SOUL_ENEMY_DEKU_BABA", "SHARED_SOUL_ENEMY_DEKU_SCRUB", "SHARED_SOUL_ENEMY_DODONGO", "SHARED_SOUL_ENEMY_THIEVES", "SHARED_SOUL_ENEMY_FLOORMASTER", "SHARED_SOUL_ENEMY_FLYING_POT", "SHARED_SOUL_ENEMY_FREEZARD", "SHARED_SOUL_ENEMY_GUAY", "OOT_SOUL_ENEMY_ANUBIS", "OOT_SOUL_ENEMY_BABY_DODONGO", "OOT_SOUL_ENEMY_BIRI_BARI", "OOT_SOUL_ENEMY_DARK_LINK", "OOT_SOUL_ENEMY_DEAD_HAND", "OOT_SOUL_ENEMY_FLARE_DANCER", "OOT_SOUL_ENEMY_GOHMA_LARVA", "OOT_SOUL_ENEMY_PARASITE", "OOT_SOUL_ENEMY_MOBLIN", "OOT_SOUL_ENEMY_SHABOM", "OOT_SOUL_ENEMY_SKULL_KID", "OOT_SOUL_ENEMY_SPIKE", "OOT_SOUL_ENEMY_STALFOS", "OOT_SOUL_ENEMY_STINGER", "OOT_SOUL_ENEMY_TAILPASARN", "OOT_SOUL_ENEMY_TORCH_SLUG", "MM_SOUL_ENEMY_BAD_BAT", "MM_SOUL_ENEMY_BIO_BABA", "MM_SOUL_ENEMY_BOE", "MM_SOUL_ENEMY_CAPTAIN_KEETA", "MM_SOUL_ENEMY_CHUCHU", "MM_SOUL_ENEMY_DEEP_PYTHON", "MM_SOUL_ENEMY_DEXIHAND", "MM_SOUL_ENEMY_DRAGONFLY", "MM_SOUL_ENEMY_EENO", "MM_SOUL_ENEMY_EYEGORE", "MM_SOUL_ENEMY_GARO", "MM_SOUL_ENEMY_GEKKO", "MM_SOUL_ENEMY_GOMESS", "MM_SOUL_ENEMY_HIPLOOP", "MM_SOUL_ENEMY_NEJIRON", "MM_SOUL_ENEMY_REAL_BOMBCHU", "MM_SOUL_ENEMY_SKULLFISH", "MM_SOUL_ENEMY_SNAPPER", "MM_SOUL_ENEMY_TAKKURI", "MM_SOUL_ENEMY_WART", "MM_SOUL_ENEMY_WIZZROBE", "SHARED_SOUL_ENEMY_IRON_KNUCKLE", "SHARED_SOUL_ENEMY_KEESE", "SHARED_SOUL_ENEMY_LEEVER", "SHARED_SOUL_ENEMY_LIKE_LIKE", "SHARED_SOUL_ENEMY_LIZALFOS_DINALFOS", "SHARED_SOUL_ENEMY_OCTOROK", "SHARED_SOUL_ENEMY_PEAHAT", "SHARED_SOUL_ENEMY_REDEAD_GIBDO", "SHARED_SOUL_ENEMY_SHELL_BLADE", "SHARED_SOUL_ENEMY_SKULLTULA", "SHARED_SOUL_ENEMY_SKULLWALLTULA", "SHARED_SOUL_ENEMY_STALCHILD", "SHARED_SOUL_ENEMY_WALLMASTER", "SHARED_SOUL_ENEMY_WOLFOS"]

if data["SharedItems"][0] == "true":
    data["SharedItems"][0] = True
else:
    data["SharedItems"][0] = False

if data["SharedItems"][0] == False:
    UnsharedEnemySouls = []
    for soul in EnemySouls:
        if soul.startswith("SHARED"):
            UnsharedEnemySouls.append(soul.replace("SHARED", "OOT"))
            UnsharedEnemySouls.append(soul.replace("SHARED", "MM"))
        else:
            UnsharedEnemySouls.append(soul)
    EnemySouls = UnsharedEnemySouls


NPCSouls = ["MM_SOUL_NPC_BLACKSMITHS", "OOT_SOUL_NPC_DARUNIA", "OOT_SOUL_NPC_HYLIAN_GUARD", "MM_SOUL_NPC_KAFEI", "MM_SOUL_NPC_KEATON", "OOT_SOUL_NPC_KING_ZORA", "OOT_SOUL_NPC_KOKIRI", "OOT_SOUL_NPC_KOKIRI_SHOPKEEPER", "MM_SOUL_NPC_KOUME_KOTAKE", "MM_SOUL_NPC_AROMA", "MM_SOUL_NPC_MAYOR_DOTOUR", "OOT_SOUL_NPC_MIDO", "MM_SOUL_NPC_MOON_CHILDREN", "MM_SOUL_NPC_PLAYGROUND_SCRUBS", "OOT_SOUL_NPC_POTION_SHOPKEEPER", "OOT_SOUL_NPC_SARIA", "OOT_SOUL_NPC_SHEIK", "MM_SOUL_NPC_BUTLER_DEKU", "MM_SOUL_NPC_DEKU_KING", "MM_SOUL_NPC_DEKU_PRINCESS", "MM_SOUL_NPC_GORON_ELDER", "MM_SOUL_NPC_ZORA_MUSICIANS", "MM_SOUL_NPC_TINGLE", "MM_SOUL_NPC_TOILET_HAND", "MM_SOUL_NPC_TOTO", "MM_SOUL_NPC_TOURIST_CENTER", "OOT_SOUL_NPC_ZELDA", "SHARED_SOUL_NPC_BIGGORON", "SHARED_SOUL_NPC_BOMBCHU_BOWLING_LADY", "SHARED_SOUL_NPC_CARPENTERS", "SHARED_SOUL_NPC_CITIZEN", "SHARED_SOUL_NPC_COMPOSER_BROS", "SHARED_SOUL_NPC_ANJU", "SHARED_SOUL_NPC_DAMPE", "SHARED_SOUL_NPC_FISHING_POND_OWNER", "SHARED_SOUL_NPC_GORON", "SHARED_SOUL_NPC_GURU_GURU", "SHARED_SOUL_NPC_HONEY_DARLING", "SHARED_SOUL_NPC_GORMAN", "SHARED_SOUL_NPC_MALON", "SHARED_SOUL_NPC_MEDIGORON", "SHARED_SOUL_NPC_POE_COLLECTOR", "SHARED_SOUL_NPC_ROOFTOP_MAN", "SHARED_SOUL_NPC_RUTO", "SHARED_SOUL_NPC_TALON", "SHARED_SOUL_NPC_ASTRONOMER", "SHARED_SOUL_NPC_BAZAAR_SHOPKEEPER", "SHARED_SOUL_NPC_BEAN_SALESMAN", "SHARED_SOUL_NPC_BANKER", "SHARED_SOUL_NPC_BOMBCHU_SHOPKEEPER", "SHARED_SOUL_NPC_CARPET_MAN", "SHARED_SOUL_NPC_CHEST_GAME_OWNER", "SHARED_SOUL_NPC_DOG_LADY", "SHARED_SOUL_NPC_GORON_CHILD", "SHARED_SOUL_NPC_GORON_SHOPKEEPER", "SHARED_SOUL_NPC_BOMBERS", "SHARED_SOUL_NPC_OLD_HAG", "SHARED_SOUL_NPC_THIEVES", "SHARED_SOUL_NPC_GROG", "SHARED_SOUL_NPC_SCIENTIST", "SHARED_SOUL_NPC_SHOOTING_GALLERY_OWNER", "SHARED_SOUL_NPC_ZORA_SHOPKEEPER", "SHARED_SOUL_NPC_ZORA"]
if data["SharedItems"][0] == False:
    UnsharedNPCSouls = []
    for soul in NPCSouls:
        if soul.startswith("SHARED"):
            UnsharedNPCSouls.append(soul.replace("SHARED", "OOT"))
            UnsharedNPCSouls.append(soul.replace("SHARED", "MM"))
        else:
            UnsharedNPCSouls.append(soul)
    NPCSouls = UnsharedNPCSouls

OcarinaButtons = ["SHARED_BUTTON_A", "SHARED_BUTTON_C_LEFT", "SHARED_BUTTON_C_RIGHT", "SHARED_BUTTON_C_DOWN", "SHARED_BUTTON_C_UP"]
if data["SharedItems"][0] == False:
    UnsharedButtons = []
    for button in OcarinaButtons:
        if button.startswith("SHARED"):
            UnsharedButtons.append(button.replace("SHARED", "OOT"))
            UnsharedButtons.append(button.replace("SHARED", "MM"))
        else:
            UnsharedButtons.append(button)
    OcarinaButtons = UnsharedButtons

shared_item_starting = {
    "SHARED_NUTS_10": ["OOT_NUTS_10", "MM_NUTS_10"],
    "SHARED_SHIELD_HYLIAN": ["OOT_SHIELD_HYLIAN", "MM_SHIELD_HERO"],
    "SHARED_STICK": ["MM_STICK", "OOT_STICK"]
}

shared_item_hints = {
    "SHARED_ARROW_ICE": ["MM_ARROW_ICE"],
    "SHARED_SHIELD_MIRROR": ["MM_SHIELD_MIRROR"],
    "SHARED_SONG_TIME": ["MM_SONG_TIME"],
    "SHARED_ARROW_LIGHT": ["MM_ARROW_LIGHT"]
}

#HarderSettings get rolled first to allow limitations
HARDMODELIMIT = settings["HardModeLimit"]

DefaultJunkList = base_settings["junkLocations"]

DefaultStartingItemList = base_settings["startingItems"]

DefaultHintList = base_settings["hints"]

HintToInsertBefore = {"type":"woth",
                    "amount":10,
                    "extra":1}

Logic = data["LogicSettings"][0]

RewardsSetting = data["RewardsSettings"][0]

ItemPool = random.choices(data["ItemPool"][0], data["ItemPool"][1])[0]

DefaultPlando = base_settings["plando"]["locations"]

DefaultBridgeCond = base_settings["specialConds"]["BRIDGE"]

DefaultMoonCond = base_settings["specialConds"]["MOON"]

DefaultGanonBKCond = base_settings["specialConds"]["GANON_BK"]

DefaultMajoraCond = base_settings["specialConds"]["MAJORA"]

WinCond = random.choices(["Ganon and Majora", "Triforce Hunt", "Triforce Quest"], data["Goal"][1])[0]

while MysteryCount < MinMysterySettings or HardCounter > HARDMODELIMIT or MysteryCount > MaxMysterySettings:
    MysteryCount = 0
    HardCounter = 0
    entranceTypeShuffled = 0

    SettingsList = base_settings.copy()

    SettingsList["logic"] = Logic
    if Logic == "none":
        HintToInsertBefore = {"type":"sometimes",
                            "amount":"max",
                            "extra":1}

    SettingsList["dungeonRewardShuffle"] = RewardsSetting

    SettingsList["mode"] = data["Mode"][0]
    if SettingsList["mode"] == "multi" or SettingsList["mode"] == "coop":
        SettingsList["teams"] = data["Teams"][0]
    if SettingsList["mode"] == "multi":
        SettingsList["players"] = data["Players"][0]
        SettingsList["distinctWorlds"] = data["DistinctWorlds"][0]

    if data["InstantTransform"][0] == 'true':
        SettingsList["fastMasks"] = True
    else:
        SettingsList["fastMasks"] = False
    
    SettingsList["itemPool"] = ItemPool

    if WinCond == "Triforce Hunt":
        SettingsList["goal"] = "triforce"
        SettingsList["triforceGoal"] = random.choices(data["TriforcePieces"][0], data["TriforcePieces"][1])[0]
        SettingsList["triforcePieces"] = min(int(1.5 * SettingsList["triforceGoal"]), 50)
    elif WinCond == "Triforce Quest":
        SettingsList["goal"] = "triforce3"
    
    JunkList = DefaultJunkList.copy()
    StartingItemList = DefaultStartingItemList.copy()
    PlandoList = DefaultPlando.copy()
    HintList = DefaultHintList.copy()
    BridgeCond = DefaultBridgeCond.copy()
    MoonCond = DefaultMoonCond.copy()
    GanonBKCond = DefaultGanonBKCond.copy()
    MajoraCond = DefaultMajoraCond.copy()

    ClimbSurfaces = random.choices([True, False], settings["ClimbMostSurfaces"][1])[0]
    if ClimbSurfaces == True:
        SettingsList["climbMostSurfacesOot"] = 'logical'
        SettingsList["climbMostSurfacesMm"] = True

    HookshotAnywhere = random.choices([True, False], settings["HookshotSurfaces"][1])[0]
    if HookshotAnywhere == True:
        SettingsList["hookshotAnywhereOot"] = 'logical'
        SettingsList["hookshotAnywhereMm"] = 'logical'

    if WinCond != "Ganon and Majora":
        HintIndex = next((i for i, hint in enumerate(HintList) if hint == HintToInsertBefore), None)
        if data["SharedItems"][0] == True:
            HintList.insert(HintIndex, {"type": "item",
                                        "amount": 1,
                                        "extra": 1,
                                        "item": "SHARED_ARROW_LIGHT"})
        else:
            HintList.insert(HintIndex, {"type": "item",
                                        "amount": 1,
                                        "extra": 0,
                                        "item": "OOT_ARROW_LIGHT"})
            HintList.insert(HintIndex, {"type": "item",
                                        "amount": 1,
                                        "extra": 0,
                                        "item": "MM_ARROW_LIGHT"})

    SkipChildZelda = random.choices([True, False], settings["SkipChildZelda"][1])[0]
    if SkipChildZelda == False:
        SettingsList["skipZelda"] = False
        if "OOT Zelda's Letter" in PlandoList:
            del PlandoList["OOT Zelda's Letter"]
        if "OOT Zelda's Song" in PlandoList:
            del PlandoList["OOT Zelda's Song"]
        StartingItemList["OOT_SONG_TP_LIGHT"] = 1
        StartingItemList["OOT_OCARINA"] = 2
        HintIndex = next((i for i, hint in enumerate(HintList) if hint == HintToInsertBefore), None)
        HintList.insert(HintIndex, {"type": "item",
                                    "amount": 1,
                                    "extra": 1,
                                    "item": "OOT_CHICKEN"})

    DoorOfTime = random.choices(["Closed", "Open"], settings["DoorOfTime"][1])[0]
    if DoorOfTime == "Closed":
        SettingsList["doorOfTime"] = "closed"
        
    SongShuffle = random.choices(["Song Locations", "Mixed with Owls", "Dungeon Rewards", "Anywhere"], settings["SongShuffle"][1])[0]
    if SongShuffle == "Song Locations":
        SettingsList["songs"] = "songLocations"
    else:
        SettingsList["songs"] = "anywhere"
        MysteryCount += 1
        if SongShuffle == "Anywhere":
            HardCounter += 1
            SettingsList["sharedSongTime"] = True
            StartingItemList.pop("MM_SONG_TIME")
            if data["SharedItems"][0] == True:
                HintList = [hint for hint in HintList if hint.get("item") not in ["MM_MASK_CAPTAIN", "MM_POWDER_KEG", "SHARED_SHIELD_MIRROR"]]
            else:
                HintList = [hint for hint in HintList if
                            hint.get("item") not in ["MM_MASK_CAPTAIN", "MM_POWDER_KEG", "MM_SHIELD_MIRROR"]]
            HintIndex = next((i for i, hint in enumerate(HintList) if hint == HintToInsertBefore), None)
            HintList.insert(HintIndex, {"type": "item",
                                "amount": 1,
                                "extra": 1,
                                "item": "OOT_SONG_ZELDA"})
            HintList.insert(HintIndex, {"type": "item",
                                "amount": 1,
                                "extra": 1,
                                "item": "MM_SONG_TIME"})
            HintList.insert(HintIndex, {"type": "item",
                                "amount": 1,
                                "extra": 1,
                                "item": "OOT_SONG_EPONA"})
        elif SongShuffle == "Mixed with Owls":
            SettingsList["owlShuffle"] = "anywhere"

    GameLink = False
    EntranceRandomizer = random.choices(["none", "Regions Only", "Overworld", "Interiors", "Full"], settings["WorldEntranceRandomizer"][1])[0]
    if EntranceRandomizer == "Regions Only":
        SettingsList["erRegions"] = "full"
        SettingsList["erRegionsExtra"] = True
        SettingsList["erRegionsShortcuts"] = True
        MysteryCount += 1
        entranceTypeShuffled += 1
    elif EntranceRandomizer == "Overworld":
        SettingsList["erOverworld"] = "full"
        MysteryCount += 1
        HardCounter += 1
        entranceTypeShuffled += 1
    elif EntranceRandomizer == "Interiors":
        SettingsList["erIndoors"] = "full"
        SettingsList["erIndoorsMajor"] = True
        SettingsList["erIndoorsExtra"] = True
        GameLink = random.choices([True, False], settings["GameLinkEntrances"][1])[0]
        SettingsList["erIndoorsGameLinks"] = GameLink
        MysteryCount += 1
        HardCounter += 1
        entranceTypeShuffled += 1
    elif EntranceRandomizer == "Full":
        SettingsList["erOverworld"] = "full"
        SettingsList["erIndoors"] = "full"
        SettingsList["erIndoorsMajor"] = True
        SettingsList["erIndoorsExtra"] = True
        GameLink = random.choices([True, False], settings["GameLinkEntrances"][1])[0]
        SettingsList["erIndoorsGameLinks"] = GameLink
        MysteryCount += 1
        HardCounter += 1
        entranceTypeShuffled += 2

    SettingsList["erGrottos"] = random.choices(["none", "full"], settings["GrottoShuffle"][1])[0]
    if SettingsList["erGrottos"] == "full":
        MysteryCount += 1
        entranceTypeShuffled += 1

    OcarinaButtonWeight = settings["OcarinaButtons"][1]
    if SongShuffle == "anywhere":
        OcarinaButtonWeight = settings["OcarinaButtons"][2]
    OcarinaButtonShuffle = random.choices([True, False], OcarinaButtonWeight)[0]
    if OcarinaButtonShuffle == True:
        SettingsList["ocarinaButtonsShuffleOot"] = True
        SettingsList["ocarinaButtonsShuffleMm"] = True
        SettingsList["sharedOcarinaButtons"] = True
        HardCounter += 1
        MysteryCount += 1

    GrassShuffle = random.choices(["none", "dungeons", "overworld", "all"], settings["GrassShuffle"][1])[0]
    SettingsList["shuffleGrassOot"] = GrassShuffle
    SettingsList["shuffleGrassMm"] = GrassShuffle
    if GrassShuffle != "none":
        MysteryCount += 1
    if GrassShuffle == "overworld" or GrassShuffle == "all":
        if EntranceRandomizer == "Overworld" or EntranceRandomizer == "Full":
            SettingsList["shuffleTFGrassMm"] = True
        else:
            SettingsList["shuffleTFGrassMm"] = settings["TFGrassAllowed"][0]
            if SettingsList["shuffleTFGrassMm"] == True:
                for i in range(1, 19):                      #Limits Termina Field Grass to only 1 potential patch good
                    GrassAllowed = random.sample(range(1, 13), settings["TFGrassAllowed"][1])
                    for j in range(1, 13):
                        if j not in GrassAllowed:
                            JunkList.append(f"MM Termina Field Grass Pack {i:02} Grass {j:02}")
    if GrassShuffle == "all":
        HardCounter += 1  #Looking into limiting

    PotShuffle = random.choices(["none", "dungeons", "overworld", "all"], settings["PotShuffle"][1])[0]
    SettingsList["shufflePotsOot"] = PotShuffle
    SettingsList["shufflePotsMm"] = PotShuffle
    if PotShuffle != "none":
        MysteryCount += 1
        if PotShuffle == "all":
            HardCounter += 1

    SettingsList["silverRupeeShuffle"] = random.choices(["vanilla", "ownDungeon", "anywhere"], settings["SilverRupeeShuffle"][1])[0]

    SKeyShuffleWeight = settings["SmallKeyShuffle"][1]
    SKeyShuffle = random.choices([["removed", "ownDungeon"], ["removed", "removed"], ["ownDungeon", "ownDungeon"], ["anywhere", "anywhere"]], SKeyShuffleWeight)[0]
    SettingsList["smallKeyShuffleMm"] = SKeyShuffle[0]
    SettingsList["smallKeyShuffleOot"] = SKeyShuffle[1]
    if SKeyShuffle == ["anywhere", "anywhere"]:
        SettingsList["smallKeyShuffleHideout"] = "anywhere"
        SettingsList["smallKeyShuffleChestGame"] = "anywhere"
    else:
        SettingsList["smallKeyShuffleHideout"] = "vanilla"

    BKeyShuffleWeight = settings["BossKeyShuffle"][1]
    BKeyShuffle = random.choices(["removed", "ownDungeon", "anywhere"], BKeyShuffleWeight)[0]
    SettingsList["bossKeyShuffleMm"] = BKeyShuffle
    SettingsList["bossKeyShuffleOot"] = BKeyShuffle

    if SKeyShuffle[0] != "removed" or BKeyShuffle != "removed" or SettingsList["silverRupeeShuffle"] != "vanilla":
        MysteryCount += 1
        if (SKeyShuffle == ["anywhere", "anywhere"] and BKeyShuffle == "anywhere") or (SKeyShuffle == ["anywhere", "anywhere"] and SettingsList["silverRupeeShuffle"] == "anywhere") or (BKeyShuffle == "anywhere" and SettingsList["silverRupeeShuffle"] == "anywhere"):
            HardCounter += 1
        if SKeyShuffle == ["anywhere", "anywhere"] and BKeyShuffle == "anywhere" and SettingsList["silverRupeeShuffle"] == "anywhere":
            SettingsList["skeletonKeyOot"] = True
            SettingsList["skeletonKeyMm"] = True
            SettingsList["sharedSkeletonKey"] = True
            SettingsList["magicalRupee"] = True

    if SKeyShuffle!= ["anywhere", "anywhere"]:
        TCGKeyShuffle = random.choices(["vanilla", "ownDungeon", "anywhere"], settings["TCGKeySettings"][1])[0]
        SettingsList["smallKeyShuffleChestGame"] = TCGKeyShuffle

    SettingsList["clocks"] = random.choices([True, False], settings["ClockShuffle"][1])[0]
    if SettingsList["clocks"] == True:
        HardCounter += 1
        MysteryCount += 1
        StartingClockAmount = random.choices(settings["StartingClockAmount"][0], settings["StartingClockAmount"][1])[0]
        SettingsList["progressiveClocks"] = random.choices(["ascending", "descending", "separate"], settings["ProgressiveClockType"][1])[0]
        if SettingsList["progressiveClocks"] == "separate":
            StartingClocks = \
            random.sample(["MM_CLOCK1", "MM_CLOCK2", "MM_CLOCK3", "MM_CLOCK4", "MM_CLOCK5", "MM_CLOCK6"],
                           StartingClockAmount)
            for key in StartingClocks:
                StartingItemList[key] = 1
            if "MM_CLOCK6" not in StartingClocks:
                HintIndex = next((i for i, hint in enumerate(HintList) if hint == HintToInsertBefore), None)
                HintList.insert(HintIndex, {"type": "item",
                                            "amount": 1,
                                            "extra": 1,
                                            "item": "MM_CLOCK6"})
        else:
            StartingItemList["MM_CLOCK"] = StartingClockAmount - 1

    BossSoulsWeight = settings["BossSoulsWeight"][1]
    if BKeyShuffle == "anywhere":
        BossSoulsWeight = settings["BossSoulsWeight"][2]
    SharedBossSoulShuffle = random.choices([True, False], BossSoulsWeight)[0]
    if SharedBossSoulShuffle == True:
        SettingsList["soulsBossOot"] = True
        SettingsList["soulsBossMm"] = True
        HardCounter += 1
        MysteryCount += 1

    FreestandingShuffle = random.choices(["none", "dungeons", "overworld", "all"], settings["FreestandingShuffle"][1])[0]
    SettingsList["shuffleFreeRupeesOot"] = FreestandingShuffle
    SettingsList["shuffleFreeRupeesMm"] = FreestandingShuffle
    SettingsList["shuffleFreeHeartsOot"] = FreestandingShuffle
    if FreestandingShuffle == "dungeons" or FreestandingShuffle == "all":
        SettingsList["shuffleFreeHeartsMm"] = True
    else:
        SettingsList["shuffleFreeHeartsMm"] = False
    WonderSpotShuffle = random.choices(["none", "dungeons", "overworld", "all"], settings["WonderSpotShuffle"][1])[0]
    SettingsList["shuffleWonderItemsOot"] = WonderSpotShuffle
    if SettingsList["shuffleWonderItemsOot"] != "none":
        SettingsList["shuffleWonderItemsMm"] = True
    else:
        SettingsList["shuffleWonderItemsMm"] = False

    if FreestandingShuffle != "none" or WonderSpotShuffle != "none":
        MysteryCount += 1
        if FreestandingShuffle == "all" and WonderSpotShuffle == "all":
            HardCounter += 1

    SwordShuffle = random.choices([True, False], settings["SwordShuffle"][1])[0]
    if SwordShuffle == True:
        SettingsList["shuffleMasterSword"] = True
        SettingsList["extraChildSwordsOot"] = True
        if DoorOfTime == "Closed":
            SettingsList["timeTravelSword"] = random.choices([True, False], settings["TimeTravelSword"][2])[0]
        else:
            SettingsList["timeTravelSword"] = random.choices([True, False], settings["TimeTravelSword"][1])[0]
        SettingsList["sharedSwords"] = True
        MysteryCount += 1
        HardCounter += 1
        HintIndex = next((i for i, hint in enumerate(HintList) if hint == HintToInsertBefore), None)
        HintList.insert(HintIndex, {"type": "item",
                                    "amount": 1,
                                    "extra": 1,
                                    "item": "OOT_SWORD_MASTER"})
        if "MM_SWORD" in StartingItemList:
            StartingItemList.pop("MM_SWORD")
        if data["SharedItems"][0] == True:
            if "SHARED_SHIELD_HYLIAN" in StartingItemList:
                StartingItemList.pop("SHARED_SHIELD_HYLIAN")
        else:
            if "MM_SHIELD_HERO" and "OOT_SHIELD_HYLIAN" in StartingItemList:
                StartingItemList.pop("MM_SHIELD_HERO")
                StartingItemList.pop("OOT_SHIELD_HYLIAN")
    else:
        SettingsList["shuffleMasterSword"] = False
        SettingsList["swordlessAdult"] = False          #Temporary Fix until the thing actually works in the generator

    OwlWeight = settings["OwlShuffle"][1]
    if "erOverworld" in SettingsList and SettingsList["erOverworld"] == "full":
        OwlWeight = settings["OwlShuffle"][2]
    if SongShuffle == "Mixed with Owls":
        OwlWeight = [0, 100]
    OwlShuffle = random.choices(["anywhere", "none"], OwlWeight)[0]
    if OwlShuffle == "anywhere":
        SettingsList["owlShuffle"] = "anywhere"
        PlandoList["MM Clock Town Owl Statue"] = "MM_OWL_CLOCK_TOWN"
        MysteryCount += 1
        HardCounter += 1

    #Other Settings get Randomized here
    SettingsList["townFairyShuffle"] = "vanilla"
    SettingsList["strayFairyOtherShuffle"] = random.choices(["removed","anywhere"], settings["StrayFairyShuffle"][1])[0]
    if SettingsList["strayFairyOtherShuffle"] != "removed":
        MysteryCount += 1
        SettingsList["townFairyShuffle"] = "anywhere"
        
    DungeonEntranceShuffleWeight = settings["DungeonEntranceShuffle"][1]
    DungeonEntranceShuffle = random.choices([True, False], DungeonEntranceShuffleWeight)[0]
    if DungeonEntranceShuffle == True:
        entranceTypeShuffled += 1
        SettingsList["erDungeons"] = "full"
        SettingsList["erMajorDungeons"] = True
        SettingsList["erMinorDungeons"] = True
        SettingsList["erSpiderHouses"] = True
        SettingsList["erPirateFortress"] = True
        SettingsList["erBeneathWell"] = True
        SettingsList["erIkanaCastle"] = True
        SettingsList["erSecretShrine"] = True
        SettingsList["openDungeonsOot"] ={"type":"specific","values":["dekuTreeAdult","wellAdult","fireChild"]}
        MysteryCount += 1
        GanonCastleShuffle = random.choices([True, False], settings["GanonCastleShuffle"][1])[0]
        SettingsList["erGanonCastle"] = GanonCastleShuffle
        GanonTowerShuffle = random.choices([True, False], settings["GanonTowerShuffle"][1])[0]
        SettingsList["erGanonTower"] = GanonTowerShuffle
        if GanonCastleShuffle == True or GanonTowerShuffle == True:
            SettingsList["rainbowBridge"] = "open"
            SettingsList["ganonBossKey"] = "custom"
            GanonBKCond = DefaultBridgeCond
            BridgeCond["count"] = 0
            BridgeCond["stones"] = False
            BridgeCond["medallions"] = False
            BridgeCond["remains"] = False
        ClockTowerShuffle = random.choices([True, False], settings["ClockTowerShuffle"][1])[0]
        if ClockTowerShuffle == True:
            SettingsList["erMoon"] = True

    SettingsList["erBoss"] = random.choices(["none","full"],settings["BossEntranceShuffle"][1])[0]
    if SettingsList["erBoss"] == "full":
        MysteryCount += 1

    SharedShopShuffle = random.choices(["none", "full"],settings["ShopShuffle"][1])[0]
    if SharedShopShuffle != "none":
        SettingsList["shopShuffleOot"] = "full"
        SettingsList["shopShuffleMm"] = "full"
        ScrubShuffle = random.choices([True, False], settings["MerchantShuffle"][1])[0]
        SettingsList["scrubShuffleOot"] = ScrubShuffle
        SettingsList["scrubShuffleMm"] = ScrubShuffle
        SettingsList["shuffleMerchantsOot"] = ScrubShuffle
        SettingsList["shuffleMerchantsMm"] = ScrubShuffle
        PriceShuffle = random.choices(["affordable", "vanilla", "weighted", "random"], settings["PriceShuffle"][1])[0]
        SettingsList["priceOotShops"] = PriceShuffle
        SettingsList["priceMmShops"] = PriceShuffle
        SettingsList["priceMmTingle"] = PriceShuffle
        SettingsList["priceOotScrubs"] = PriceShuffle
        SettingsList["priceOotMerchants"] = PriceShuffle
        SettingsList["fillWallets"] = True
        if PriceShuffle == "weighted" or PriceShuffle == "random":
            MaxWalletSize = random.choices(["Giant", "Colossal", "Bottomless"], settings["MaxWalletSize"][1])[0]
            if MaxWalletSize != "Giant":
                SettingsList["rupeeScaling"] = True
                SettingsList["colossalWallets"] = True
                if MaxWalletSize == "Bottomless":
                    SettingsList["bottomlessWallets"] = True

        MysteryCount += 1
        
    SharedCowShuffle = random.choices([True, False],settings["CowShuffle"][1])[0]
    if SharedCowShuffle == True:
        SettingsList["cowShuffleOot"] = True
        SettingsList["cowShuffleMm"] = True
        MysteryCount += 1

    SharedMQDungeons = random.choices(settings["MQDungeonAmount"][0],settings["MQDungeonAmount"][1])[0]
    if SharedMQDungeons > 0:
        SettingsList["mqDungeons"] = {"type":"specific", "values":[]}
        DungeonList = ["DT", "DC", "JJ", "Forest", "Fire", "Water", "Spirit", "Shadow", "BotW", "IC", "GTG", "Ganon"]
        MQDungeonChosen = random.sample(DungeonList, SharedMQDungeons)
        for key in DungeonList:
            if key in MQDungeonChosen:
                SettingsList["mqDungeons"]["values"].append(key)

    SharedCratesAndBarrels = random.choices(["none", "dungeons", "overworld", "all"], settings["CratesAndBarrelsShuffle"][1])[0]
    SettingsList["shuffleCratesOot"] = SharedCratesAndBarrels
    SettingsList["shuffleCratesMm"] = SharedCratesAndBarrels
    if SharedCratesAndBarrels == "dungeons" or SharedCratesAndBarrels == "all":
        SettingsList["shuffleBarrelsMm"] = "all"
    else:
        SettingsList["shuffleBarrelsMm"] = "none"
    if SharedCratesAndBarrels != "none":
        MysteryCount += 1

    SharedHiveShuffle = random.choices([True, False], settings["HiveShuffle"][1])[0]
    if SharedHiveShuffle == True:
        SettingsList["shuffleHivesOot"] = True
        SettingsList["shuffleHivesMm"] = True
        MysteryCount += 1

    SettingsList["shuffleSnowballsMm"] = random.choices(["none", "dungeons", "overworld", "all"], settings["SnowballShuffle"][1])[0]
    if SettingsList["shuffleSnowballsMm"] != "none":
        MysteryCount += 1

    OoTSkulltulaWeights = settings["OoTSkulltulaShuffle"][1]
    SettingsList["goldSkulltulaTokens"] = random.choices(["none", "dungeons", "overworld", "all"], OoTSkulltulaWeights)[0]
    MMSkulltulaWeights = settings["MMSkulltulaShuffle"][1]
    SettingsList["housesSkulltulaTokens"] = random.choices(["none", "cross", "all"], MMSkulltulaWeights)[0]
    if SettingsList["goldSkulltulaTokens"] != "none" or SettingsList["housesSkulltulaTokens"] != "none":
        MysteryCount += 1
    if SettingsList["housesSkulltulaTokens"] == "cross":
        if "OOT Skulltula House 40 Tokens" in JunkList:
            JunkList.remove("OOT Skulltula House 40 Tokens")
        if "OOT Skulltula House 50 Tokens" in JunkList:
            JunkList.remove("OOT Skulltula House 50 Tokens")

    SoulShuffle = random.choices(["None", "Enemy", "NPC", "Full"], settings["SoulShuffle"][1])[0]
    if SoulShuffle != "None":
        MysteryCount += 1
        HardCounter += 1
        if SoulShuffle == "Enemy" or SoulShuffle == "Full":
            SettingsList["soulsEnemyOot"] = True
            SettingsList["soulsEnemyMm"] = True
            SettingsList["sharedSoulsEnemy"] = True
            HintIndex = next((i for i, hint in enumerate(HintList) if hint == HintToInsertBefore), None)
            if data["SharedItems"][0] == True:
                HintList.insert(HintIndex, {"type": "item",
                                            "amount": 1,
                                            "extra": 1,
                                            "item": "SHARED_SOUL_ENEMY_LIZALFOS_DINALFOS"})
                HintList.insert(HintIndex, {"type": "item",
                                            "amount": 1,
                                            "extra": 1,
                                            "item": "SHARED_SOUL_ENEMY_KEESE"})
                HintList.insert(HintIndex, {"type": "item",
                                            "amount": 1,
                                            "extra": 1,
                                            "item": "SHARED_SOUL_ENEMY_IRON_KNUCKLE"})
            else:
                HintList.insert(HintIndex, {"type": "item",
                                            "amount": 1,
                                            "extra": 0,
                                            "item": "OOT_SOUL_ENEMY_LIZALFOS_DINALFOS"})
                HintList.insert(HintIndex, {"type": "item",
                                            "amount": 1,
                                            "extra": 0,
                                            "item": "OOT_SOUL_ENEMY_KEESE"})
                HintList.insert(HintIndex, {"type": "item",
                                            "amount": 1,
                                            "extra": 0,
                                            "item": "OOT_SOUL_ENEMY_IRON_KNUCKLE"})
                HintList.insert(HintIndex, {"type": "item",
                                            "amount": 1,
                                            "extra": 0,
                                            "item": "MM_SOUL_ENEMY_LIZALFOS_DINALFOS"})
                HintList.insert(HintIndex, {"type": "item",
                                            "amount": 1,
                                            "extra": 0,
                                            "item": "MM_SOUL_ENEMY_KEESE"})
                HintList.insert(HintIndex, {"type": "item",
                                            "amount": 1,
                                            "extra": 0,
                                            "item": "MM_SOUL_ENEMY_IRON_KNUCKLE"})
            HintList.insert(HintIndex, {"type": "item",
                                        "amount": 1,
                                        "extra": 1,
                                        "item": "OOT_SOUL_ENEMY_STALFOS"})
            StartingEnemyPerc = random.choices(settings["StartingEnemySoulPercentage"][0], settings["StartingEnemySoulPercentage"][1])[0]
            StartingEnemyAmount = round(StartingEnemyPerc * len(EnemySouls) / 100)
            StartingEnemyChosen = random.sample(EnemySouls, StartingEnemyAmount)
            for key in StartingEnemyChosen:
                StartingItemList[key] = 1
        if SoulShuffle == "NPC" or SoulShuffle == "Full":
            SettingsList["soulsNpcOot"] = True
            SettingsList["soulsNpcMm"] = True
            SettingsList["sharedSoulsNpc"] = True
            HintIndex = next((i for i, hint in enumerate(HintList) if hint == HintToInsertBefore), None)
            HintList.insert(HintIndex, {"type": "item",
                                        "amount": 1,
                                        "extra": 1,
                                        "item": "MM_SOUL_NPC_MOON_CHILDREN"})
            if WinCond == "Ganon and Majora":
                HintList.insert(HintIndex, {"type": "item",
                                            "amount": 1,
                                            "extra": 1,
                                            "item": "OOT_SOUL_NPC_ZELDA"})
            StartingNPCPerc = random.choices(settings["StartingNPCSoulPercentage"][0], settings["StartingNPCSoulPercentage"][1])[0]
            StartingNPCAmount = round(StartingNPCPerc * len(NPCSouls) / 100)
            StartingNPCChosen = random.sample(NPCSouls, StartingNPCAmount)
            for key in StartingNPCChosen:
                StartingItemList[key] = 1


    FairyFountainShuffle = random.choices([True, False], settings["FairyFountainShuffle"][1])[0]
    if FairyFountainShuffle == True:
        SettingsList["fairyFountainFairyShuffleOot"] = True
        SettingsList["fairyFountainFairyShuffleMm"] = True
        SettingsList["fairySpotShuffleOot"] = True
        MysteryCount += 1

    ButterflyShuffle = random.choices([True, False], settings["ButterflyShuffle"][1])[0]
    if ButterflyShuffle == True:
        SettingsList["shuffleButterfliesOot"] = True
        SettingsList["shuffleButterfliesMm"] = True
        MysteryCount += 1

    FishingPondShuffle = random.choices([True, False], settings["FishingPondShuffle"][1])[0]
    if FishingPondShuffle == True:
        SettingsList["pondFishShuffle"] = True
        JunkList.append("OOT Fishing Pond Adult Loach")
        JunkList.append("OOT Fishing Pond Child Loach 1")
        JunkList.append("OOT Fishing Pond Child Loach 2")
        MysteryCount += 1

    DivingGameShuffle = random.choices([True, False], settings["DivingGameShuffle"][1])[0]
    if DivingGameShuffle == True:
        SettingsList["divingGameRupeeShuffle"] = True
        JunkList.append("OOT Zora Domain Diving Game Huge Rupee")

    GerudoCardShuffle = random.choices(["Starting", True, False], settings["GerudoCardShuffle"][1])[0]
    if GerudoCardShuffle != False:
        SettingsList["shuffleGerudoCard"] = True
        if GerudoCardShuffle == "Starting":
            StartingItemList["OOT_GERUDO_CARD"] = 1

    RedBoulderShuffle = random.choices([True, False], settings["RedBoulderShuffle"][1])[0]
    if RedBoulderShuffle == True:
        SettingsList["shuffleRedBouldersOot"] = True
        SettingsList["shuffleRedBouldersMm"] = True
        MysteryCount += 1

    IcicleShuffle = random.choices([True, False], settings["IcicleShuffle"][1])[0]
    if IcicleShuffle == True:
        SettingsList["shuffleIciclesOot"] = True
        SettingsList["shuffleIciclesMm"] = True
        MysteryCount += 1

    RedIceShuffle = random.choices([True, False], settings["RedIceShuffle"][1])[0]
    SettingsList["shuffleRedIceOot"] = RedIceShuffle
    
    SettingsList["erSpawns"] = random.choices(["none", "child", "adult", "both"], settings["SpawnShuffle"][1])[0]

    WellWeight = settings["GibdoSettings"][1]
    SettingsList["beneathWell"] = random.choices(["vanilla", "remorseless", "open"], WellWeight)[0]

    OpenDungeonsWeight = settings["OpenDungeons"][1]
    OpenDungeonAmount = random.choices(settings["OpenDungeons"][0], OpenDungeonsWeight)[0]
    if OpenDungeonAmount > 0:
        if "openDungeonsOot" not in SettingsList:
            SettingsList["openDungeonsOot"] = {"type": "specific","values": []}
        SettingsList["openDungeonsMm"] = {"type": "specific","values": []}
        OpenDungeonChoice = ["WF", "SH", "GB", "ST", "DC", "BotW", "JJ", "Shadow", "Water"]
        MMDung = ["WF", "SH", "GB", "ST"]
        OpenDungeons = random.sample(OpenDungeonChoice, OpenDungeonAmount)
        for key in OpenDungeons:
            if key in MMDung:
                SettingsList["openDungeonsMm"]["values"].append(key)
            else:
                SettingsList["openDungeonsOot"]["values"].append(key)

    SettingsList["dekuTree"] = random.choices(settings["DekuTree"][0], settings["DekuTree"][1])[0]

    GanonTrialAmount = random.choices(settings["GanonTrialAmount"][0], settings["GanonTrialAmount"][1])[0]
    if GanonTrialAmount > 0:
        MysteryCount += 1
        SettingsList["ganonTrials"] = {"type": "specific", "values": []}
        TrialList = ["Light", "Forest", "Fire", "Water", "Shadow", "Spirit"]
        TrialChosen = random.sample(TrialList, GanonTrialAmount)
        for key in TrialChosen:
            SettingsList["ganonTrials"]["values"].append(key)
        if GanonTrialAmount > 2:
            HardCounter += 1

    if SongShuffle != "Mix with Owls":
        WarpSongShuffle = random.choices([True, False], settings["WarpSongShuffle"][1])[0]
        if WarpSongShuffle == True:
            SettingsList["erWarps"] = True
            MysteryCount += 1

    MMAdultAllowed = random.choices(settings["AdultInMM"][0], settings["AdultInMM"][1])[0]
    SettingsList["crossAge"] = MMAdultAllowed

    AgelessAmount = random.choices(settings["AgelessAmount"][0], settings["AgelessAmount"][1])[0]
    if AgelessAmount > 0:
        AgelessItems = ["agelessSwords", "agelessShields", "agelessTunics", "agelessBoots", "agelessSticks", "agelessBoomerang", "agelessHammer", "agelessHookshot", "agelessSlingshot", "agelessBow", "agelessStrength"]
        AgeAllowed = random.sample(AgelessItems, AgelessAmount)
        for key in AgeAllowed:
            SettingsList[key] = True
            
    if SKeyShuffle[0] != "removed" and SKeyShuffle[1] != "removed":     
        if SettingsList["smallKeyShuffleChestGame"] != "vanilla":
            KeyRingAmount = random.choices(range(14), settings["KeyRingAmount"][2])[0]
        else:
            KeyRingAmount = random.choices(range(13), settings["KeyRingAmount"][1])[0]
        if KeyRingAmount > 0:
            SettingsList["smallKeyRingOot"] = {"type": "specific", "values": []}
            SettingsList["smallKeyRingMm"] = {"type": "specific", "values": []}
            KeyRingPlaces = ["Forest","Fire","Water","Shadow","Spirit","BotW","GTG","Ganon","SH","ST"]
            MMKeyRings = ["SH", "ST"]
            if SettingsList["smallKeyShuffleChestGame"] != "vanilla":
                KeyRingPlaces.append("TCG")
            KeyRingsChosen = random.sample(KeyRingPlaces, KeyRingAmount)
            for key in KeyRingsChosen:
                if key in MMKeyRings:
                    SettingsList["smallKeyRingMm"]["values"].append(key)
                else:
                    SettingsList["smallKeyRingOot"]["values"].append(key)

    if SettingsList["silverRupeeShuffle"] != "vanilla":
        if SharedMQDungeons > 0:
            SilverList = ["Shadow_Scythe","Shadow_Pit","Shadow_Spikes","GTG_Slopes","GTG_Lava","GTG_Water","Ganon_Fire"]
            if "DC" in MQDungeonChosen:
                SilverList.append("DC")
            if "BotW" not in MQDungeonChosen:
                SilverList.append("BotW")
            if "Spirit" in MQDungeonChosen:
                SilverList.append("Spirit_Lobby")
                SilverList.append("Spirit_Adult")
            else:
                SilverList.append("Spirit_Child")
                SilverList.append("Spirit_Sun")
                SilverList.append("Spirit_Boulders")
            if "Shadow" in MQDungeonChosen:
                SilverList.append("Shadow_Blades")
            if "IC" not in MQDungeonChosen:
                SilverList.append("IC_Scythe")
                SilverList.append("IC_Block")
            if "GC" in MQDungeonChosen:
                SilverList.append("Ganon_Shadow")
                SilverList.append("Ganon_Water")
            else:
                SilverList.append("Ganon_Spirit")
                SilverList.append("Ganon_Light")
                SilverList.append("Ganon_Forest")
        else:
            SilverList = ["BotW","Spirit_Child","Spirit_Sun","Spirit_Boulders","Shadow_Scythe","Shadow_Pit","Shadow_Spikes","IC_Scythe","IC_Block","GTG_Slopes","GTG_Lava","GTG_Water","Ganon_Light","Ganon_Forest","Ganon_Fire","Ganon_Spirit"]
        SilverCount = len(SilverList)
        SilverPouchAmount = SilverCount + 1
        while SilverPouchAmount > SilverCount:
            SilverPouchAmount = random.choices(list(range(0, 19)), settings["SilverPouchAmount"][1])[0]
        if SilverPouchAmount > 0:
            SettingsList["silverRupeePouches"] = {"type":"specific","values":[]}
            SilverPouchesChosen = random.sample(SilverList, SilverPouchAmount)
            for key in SilverPouchesChosen:
                SettingsList["silverRupeePouches"]["values"].append(key)
        
    ChildWallet = random.choices([True, False], settings["ChildWallet"][1])[0]
    if ChildWallet == True:
        SettingsList["childWallet"] = True
        if SharedShopShuffle == "full":
            HardCounter += 1

    PrePlantedBeans = random.choices([True, False], settings["PrePlantedBeans"][1])[0]
    if PrePlantedBeans == True:
        SettingsList["ootPreplantedBeans"] = True
        del PlandoList["OOT Zora River Bean Seller"]

    KingZoraWeights = settings["KingZora"][1]
    if EntranceRandomizer == "Overworld" or EntranceRandomizer == "Full":
        KingZoraWeights = settings["KingZora"][2]
    SettingsList["zoraKing"] = random.choices(["vanilla", "adult", "open"], KingZoraWeights)[0]

    ZoraDomainWeights = settings["ZoraDomainAdultShortcut"][1]
    if EntranceRandomizer == "Overworld" or "EntranceRandomizer" == "Full":
        ZoraDomainWeights = settings["ZoraDomainAdultShortcut"][2]
    SettingsList["openZdShortcut"] = random.choices([True, False], ZoraDomainWeights)[0]

    #To add here: Mixed Pool Settings
    if entranceTypeShuffled > 1 and settings["Mixed"]["Allow"][1][0] != 0:
        MixedSettings = 0
        MixedEntrances = random.choices(settings["Mixed"]["Allow"][0], settings["Mixed"]["Allow"][1])[0]
        if MixedEntrances == True:
            SettingsList["erMixed"] = "full"
            MixedList = []
            if EntranceRandomizer == "Regions Only":
                SettingsList["erMixedRegions"] = random.choices(settings["Mixed"]["Regions"][0], settings["Mixed"]["Regions"][1])[0]
                if SettingsList["erMixedRegions"] == True:
                    MixedList.append("Regions")
                    MixedSettings += 1
            if EntranceRandomizer == "Overworld" or EntranceRandomizer == "Full":
                SettingsList["erMixedOverworld"] = random.choices(settings["Mixed"]["Overworld"][0], settings["Mixed"]["Overworld"][1])[0]
                if SettingsList["erMixedOverworld"] == True:
                    MixedList.append("Overworld")
                    MixedSettings += 1
            if EntranceRandomizer == "Interiors" or EntranceRandomizer == "Full":
                SettingsList["erMixedIndoors"] = random.choices(settings["Mixed"]["Interior"][0], settings["Mixed"]["Interior"][1])[0]
                if SettingsList["erMixedIndoors"] == True:
                    MixedList.append("Interiors")
                    MixedSettings += 1
            if SettingsList["erGrottos"] == "full":
                SettingsList["erMixedGrottos"] = random.choices(settings["Mixed"]["Grottos"][0], settings["Mixed"]["Grottos"][1])[0]
                if SettingsList["erMixedGrottos"] == True:
                    MixedList.append("Grottos")
                    MixedSettings += 1
            if DungeonEntranceShuffle == True:
                SettingsList["erMixedDungeons"] = random.choices(settings["Mixed"]["Dungeons"][0], settings["Mixed"]["Dungeons"][1])[0]
                if SettingsList["erMixedDungeons"] == True:
                    MixedList.append("Dungeons")
                    MixedSettings += 1
            if MixedSettings < 2:
                SettingsList["erMixed"] = False
                del MixedList

    if entranceTypeShuffled > 0 and settings["DecoupledEntrances"][1][0] != 0:
        SettingsList["erDecoupled"] = random.choices(settings["DecoupledEntrances"][0], settings["DecoupledEntrances"][1])[0]

    if SongShuffle == "Mixed with Owls":
        PlandoList["MM Clock Town Owl Statue"] = "MM_OWL_CLOCK_TOWN"
        SongAndOwlList = ["OOT_SONG_EPONA", "OOT_SONG_SARIA", "OOT_SONG_TIME", "OOT_SONG_SUN", "SHARED_SONG_STORMS", "OOT_SONG_ZELDA", "OOT_SONG_TP_FOREST", "OOT_SONG_TP_FIRE", "OOT_SONG_TP_WATER", "OOT_SONG_TP_SHADOW", "OOT_SONG_TP_SPIRIT", "MM_SONG_HEALING", "MM_SONG_AWAKENING", "MM_SONG_GORON", "MM_SONG_ZORA", "SHARED_SONG_EMPTINESS", "MM_SONG_ORDER", "MM_OWL_MILK_ROAD", "MM_OWL_SOUTHERN_SWAMP", "MM_OWL_WOODFALL", "MM_OWL_MOUNTAIN_VILLAGE", "MM_OWL_SNOWHEAD", "MM_OWL_GREAT_BAY", "MM_OWL_ZORA_CAPE", "MM_OWL_IKANA_CANYON", "MM_OWL_STONE_TOWER"]
        SongAndOwlLocation = ["OOT Lon Lon Ranch Malon Song", "OOT Saria's Song", "OOT Graveyard Royal Tomb Song", "OOT Hyrule Field Song of Time", "OOT Windmill Song of Storms", "OOT Sacred Meadow Sheik Song", "OOT Death Mountain Crater Sheik Song", "OOT Ice Cavern Sheik Song", "OOT Kakariko Song Shadow", "OOT Desert Colossus Song Spirit", "OOT Temple of Time Sheik Song", "MM Clock Tower Roof Skull Kid Song of Time", "MM Romani Ranch Epona Song", "MM Southern Swamp Song of Soaring", "MM Beneath The Graveyard Song of Storms", "MM Deku Palace Sonata of Awakening", "MM Goron Elder", "MM Ancient Castle of Ikana Song Emptiness", "MM Oath to Order", "MM Milk Road Owl Statue", "MM Southern Swamp Owl Statue", "MM Woodfall Owl Statue", "MM Mountain Village Owl Statue", "MM Snowhead Owl Statue", "MM Great Bay Coast Owl Statue", "MM Zora Cape Owl Statue", "MM Ikana Canyon Owl Statue", "MM Stone Tower Owl Statue"]
        if data["SharedItems"][0] == False:
            SongAndOwlList.remove("SHARED_SONG_STORMS")
            SongAndOwlList.remove("SHARED_SONG_EMPTINESS")
            SongAndOwlList.append("OOT_SONG_EMPTINESS")
            SongAndOwlList.append("MM_SONG_EMPTINESS")
            SongAndOwlList.append("OOT_SONG_STORMS")
            SongAndOwlList.append("MM_SONG_STORMS")
        if SkipChildZelda == False:
            SongAndOwlLocation.append("OOT Zelda's Song")
        if OcarinaButtonShuffle == True:
            if data["SharedItems"][0] == True:
                SongAndOwlList.append("SHARED_BUTTON_A")
                SongAndOwlList.append("SHARED_BUTTON_C_RIGHT")
                SongAndOwlList.append("SHARED_BUTTON_C_LEFT")
                SongAndOwlList.append("SHARED_BUTTON_C_DOWN")
                SongAndOwlList.append("SHARED_BUTTON_C_UP")
            else:
                SongAndOwlList.append("OOT_BUTTON_A")
                SongAndOwlList.append("OOT_BUTTON_C_RIGHT")
                SongAndOwlList.append("OOT_BUTTON_C_LEFT")
                SongAndOwlList.append("OOT_BUTTON_C_DOWN")
                SongAndOwlList.append("OOT_BUTTON_C_UP")
                SongAndOwlList.append("MM_BUTTON_A")
                SongAndOwlList.append("MM_BUTTON_C_RIGHT")
                SongAndOwlList.append("MM_BUTTON_C_LEFT")
                SongAndOwlList.append("MM_BUTTON_C_DOWN")
                SongAndOwlList.append("MM_BUTTON_C_UP")
            SongAndOwlLocation.append("MM Initial Song of Healing")
            SongAndOwlLocation.append("MM Clock Town Owl Statue")
            del PlandoList["MM Clock Town Owl Statue"]
            JunkList.remove("MM Initial Song of Healing")
            StartingItemList["MM_OWL_CLOCK_TOWN"] = 1

        OOT_EXCLUDE_ROYAL_TOMB = ["OOT_SONG_ZELDA", "SHARED_BUTTON_C_RIGHT", "SHARED_BUTTON_C_LEFT", "SHARED_BUTTON_C_UP", "OOT_BUTTON_C_RIGHT", "OOT_BUTTON_C_LEFT", "OOT_BUTTON_C_UP"]
        OOT_ROYAL_TOMB_LOCATIONS = ["OOT Graveyard Royal Tomb Song"]

        OOT_EXCLUDE_ADULT_SACRED_MEADOW = ["SHARED_BUTTON_C_LEFT", "SHARED_BUTTON_C_RIGHT", "OOT_BUTTON_C_LEFT", "OOT_BUTTON_C_RIGHT"]
        OOT_ADULT_SACRED_MEADOW_LOCATIONS = ["OOT Sacred Meadow Sheik Song"]

        OOT_EXCLUDE_ICE_CAVERN = ["OOT_SONG_ZELDA", "SHARED_BUTTON_C_RIGHT", "SHARED_BUTTON_C_LEFT", "SHARED_BUTTON_C_UP", "OOT_BUTTON_C_RIGHT", "OOT_BUTTON_C_LEFT", "OOT_BUTTON_C_UP"]
        OOT_ICE_CAVERN_LOCATIONS = ["OOT Ice Cavern Sheik Song"]

        MM_EXCLUDE_IKANA_GRAVE = ["SHARED_BUTTON_C_UP", "SHARED_BUTTON_C_LEFT", "MM_BUTTON_C_UP", "MM_BUTTON_C_LEFT"]
        MM_IKANA_GRAVE_LOCATIONS = ["MM Beneath The Graveyard Song of Storms"]

        MM_EXCLUDE_OCEAN = ["SHARED_BUTTON_C_UP", "SHARED_BUTTON_C_LEFT", "MM_BUTTON_C_UP", "MM_BUTTON_C_LEFT"]
        MM_OCEAN_LOCATIONS = ["MM Great Bay Coast Owl Statue", "MM Zora Cape Owl Statue"]

        MM_EXCLUDE_CANYON = ["SHARED_BUTTON_C_UP", "SHARED_BUTTON_C_LEFT", "MM_BUTTON_C_UP", "MM_BUTTON_C_LEFT"]
        MM_CANYON_LOCATIONS = ["MM Ikana Canyon Owl Statue", "MM Stone Tower Owl Statue"]

        CheckList = SongAndOwlList.copy()
        CheckLocation = SongAndOwlLocation.copy()
        random.shuffle(CheckLocation)

        while len(CheckList) > 0:
            for key in CheckLocation:
                #Attempt to avoid straightforward generation conflicts
                if key in OOT_ROYAL_TOMB_LOCATIONS and SettingsList["erGrottos"] == "none":
                     ChosenItem = random.choice([item for item in CheckList if item not in OOT_EXCLUDE_ROYAL_TOMB])
                elif key in OOT_ADULT_SACRED_MEADOW_LOCATIONS and EntranceRandomizer in ["none", "Regions Only", "Interiors"]:
                    ChosenItem = random.choice([item for item in CheckList if item not in OOT_EXCLUDE_ADULT_SACRED_MEADOW])
                elif key in OOT_ICE_CAVERN_LOCATIONS and (EntranceRandomizer in ["none", "Regions Only", "Interiors"] or DungeonEntranceShuffle == False or SettingsList["openZdShortcut"] == False):
                    ChosenItem = random.choice([item for item in CheckList if item not in OOT_EXCLUDE_ICE_CAVERN])
                elif key in MM_IKANA_GRAVE_LOCATIONS and SettingsList["erGrottos"] == "none":
                    ChosenItem = random.choice([item for item in CheckList if item not in MM_EXCLUDE_IKANA_GRAVE])
                elif key in MM_OCEAN_LOCATIONS and EntranceRandomizer in ["none", "interiors"]:
                    ChosenItem = random.choice([item for item in CheckList if item not in MM_EXCLUDE_OCEAN])
                elif key in MM_CANYON_LOCATIONS and EntranceRandomizer in ["none", "interiors"]:
                    ChosenItem = random.choice([item for item in CheckList if item not in MM_EXCLUDE_CANYON])
                else:
                    ChosenItem = random.choice(CheckList)

                PlandoList[key] = ChosenItem
                CheckList.remove(ChosenItem)
                CheckLocation.remove(key)
                if len(CheckList) == 0:
                    break
            if len(CheckLocation) == 0:
                break
        if len(CheckLocation) != 0:
            for key in CheckLocation:
                JunkList.append(key)
        else:
            for key in CheckList:
                StartingItemList[key] = 1

    elif OcarinaButtonShuffle == True:
        StartingButtonCount = random.choices(settings["StartingButtons"][0], settings["StartingButtons"][1])[0]
        if data["SharedItems"][0] == True:
            ButtonsChosen = random.sample(OcarinaButtons, StartingButtonCount)
        else:
            ButtonsChosen = random.sample(OcarinaButtons, 2*StartingButtonCount)

        for key in ButtonsChosen:
            StartingItemList[key] = 1
            
    ##Rejection Logic for Dungeon Rewards Song Shuffle to try to reduce generation issues (weren't many but eh)

    if SongShuffle == "Dungeon Rewards":
        SongList = ["OOT_SONG_EPONA", "OOT_SONG_SARIA", "OOT_SONG_TIME", "OOT_SONG_SUN", "SHARED_SONG_STORMS",
                    "OOT_SONG_ZELDA", "OOT_SONG_TP_FOREST", "OOT_SONG_TP_FIRE", "OOT_SONG_TP_WATER",
                    "OOT_SONG_TP_SHADOW", "OOT_SONG_TP_SPIRIT", "MM_SONG_HEALING", "MM_SONG_AWAKENING", "MM_SONG_GORON",
                    "MM_SONG_ZORA", "SHARED_SONG_EMPTINESS", "MM_SONG_ORDER"]  # 17
        if data["SharedItems"][0] == False:
            SongList.remove("SHARED_SONG_EMPTINESS")
            SongList.append("MM_SONG_EMPTINESS")
            SongList.remove("SHARED_SONG_STORMS")
            SongList.append("OOT_SONG_STORMS")
            SongList.append("MM_SONG_STORMS")
        DungeonItemList = ["OOT Deku Tree Boss Container", "OOT Dodongo Cavern Boss Container",
                            "OOT Jabu-Jabu Boss Container", "OOT Forest Temple Boss Container",
                            "OOT Fire Temple Boss Container", "OOT Water Temple Boss HC", "OOT Shadow Temple Boss HC",
                            "OOT Spirit Temple Boss HC", "MM Woodfall Temple Boss Container",
                            "MM Snowhead Temple Boss HC", "MM Great Bay Temple Boss HC",
                            "MM Stone Tower Temple Inverted Boss HC",
                            "MM Ancient Castle of Ikana Song Emptiness", "MM Pirate Fortress Interior Hookshot", "MM Secret Shrine HP Chest", "MM Beneath The Well Mirror Shield", "MM Stone Tower Temple Light Arrow"]
        if SharedMQDungeons > 0:
            if "BotW" in MQDungeonChosen:
                DungeonItemList.append("OOT MQ Bottom of the Well Lens Chest")
            else:
                DungeonItemList.append("OOT Bottom of the Well Lens")
            if "IC" in MQDungeonChosen:
                DungeonItemList.append("OOT MQ Ice Cavern Sheik Song")
            else:
                DungeonItemList.append("OOT Ice Cavern Sheik Song")
            if "GTG" in MQDungeonChosen:
                DungeonItemList.append("OOT MQ Gerudo Training Grounds Ice Arrows Chest")
            else:
                DungeonItemList.append("OOT Gerudo Training Maze Chest 4")
        else:
            DungeonItemList.append("OOT Bottom of the Well Lens")
            DungeonItemList.append("OOT Ice Cavern Sheik Song")
            DungeonItemList.append("OOT Gerudo Training Maze Chest 4")
            
        random.shuffle(DungeonItemList)

        if SettingsList["erBoss"] == "none" and DungeonEntranceShuffle == False:
            LULLABY_REQUIRED = ["OOT MQ Bottom of the Well Lens Chest", "OOT Bottom of the Well Lens", "OOT Water Temple Boss HC", "OOT Shadow Temple Boss HC",
                            "OOT Spirit Temple Boss HC"]
            SONATA_REQUIRED = ["MM Woodfall Temple Boss Container"]
            GORON_REQUIRED = ["MM Snowhead Temple Boss HC"]
            BOSSA_REQUIRED = ["MM Great Bay Temple Boss HC"]
            ELEGY_REQUIRED = ["MM Stone Tower Temple Inverted Boss HC", "MM Stone Tower Temple Light Arrow"]

            CheckList2 = SongList.copy()
            CheckList3 = DungeonItemList.copy()

            while len(CheckList2) > 0:
                CheckList2 = SongList.copy()
                CheckList3 = DungeonItemList.copy()
                for key in DungeonItemList:
                    if len(CheckList2) > 0:
                        if key in LULLABY_REQUIRED:
                            ChosenItem = random.choice([item for item in CheckList2 if item != "OOT_SONG_ZELDA"])
                        elif key in SONATA_REQUIRED:
                            ChosenItem = random.choice([item for item in CheckList2 if item != "MM_SONG_AWAKENING"])
                        elif key in GORON_REQUIRED:
                            ChosenItem = random.choice([item for item in CheckList2 if item != "MM_SONG_GORON"])
                        elif key in BOSSA_REQUIRED:
                            ChosenItem = random.choice([item for item in CheckList2 if item != "MM_SONG_ZORA"])
                        elif key in ELEGY_REQUIRED:
                            ChosenItem = random.choice([item for item in CheckList2 if (item != "SHARED_SONG_EMPTINESS" and item != "MM_SONG_EMPTINESS")])
                        else:
                            ChosenItem = random.choice(CheckList2)
                        PlandoList[key] = ChosenItem
                        CheckList2.remove(ChosenItem)
                        CheckList3.remove(key)

            for key in CheckList3:
                JunkList.append(key)

        else:           ##Until plandoing/generation for precompleted and entrances are done in web generator, cannot make concrete logic so screw it
            for key in DungeonItemList:
                if len(SongList) > 0:
                    ChosenItem = random.choice(SongList)
                    PlandoList[key] = ChosenItem
                    SongList.remove(ChosenItem)
                else:
                    JunkList.append(key)

    
    WorldLayout = random.choices(settings["MMWorldLayout"][0], settings["MMWorldLayout"][1])[0]
    if WorldLayout == "jp":
        SettingsList["jpLayouts"] = {"type":"specific", "values":["DekuPalace"]}


if data["SharedItems"][0] == False:
    def update_shared_items(obj):
        if isinstance(obj, dict):
            return {k: (False if "shared" in k.lower() else update_shared_items(v)) for k, v in obj.items()}
        elif isinstance(obj, list):
            return [update_shared_items(item) for item in obj]
        else:
            return obj

    SettingsList = update_shared_items(SettingsList)

    updatedStarting = {}
    for key, value in StartingItemList.items():
        if key.startswith("SHARED_"):
            if key in shared_item_starting:
                for new_key in shared_item_starting[key]:
                    updatedStarting[new_key] = value
        else:
            updatedStarting[key] = value

    StartingItemList = updatedStarting

    updatedPlando = {}
    for key, value in PlandoList.items():
        if key.startswith("SHARED_"):
            if key in shared_item_starting:
                for new_key in shared_item_starting[key]:
                    updatedPlando[new_key] = value
        else:
            updatedPlando[key] = value

    PlandoList = updatedPlando

    updatedHints = []

    for hint in HintList:  # Loop over list elements (each is a dictionary)
        item_name = hint.get("item")  # Extract the item name

        if item_name:
            if item_name.startswith("SHARED_") and item_name in shared_item_hints:
                for new_item in shared_item_hints[item_name]:
                    new_hint = hint.copy()
                    new_hint["item"] = new_item
                    updatedHints.append(new_hint)
            else:
                updatedHints.append(hint)  # Keep the original hint if not shared
        else:
            updatedHints.append(hint)  # Keep the original hint if not shared

    HintList = updatedHints



# Builds the Setting List here:
settings_data = SettingsList
settings_data["junkLocations"] = JunkList
settings_data["hints"] = HintList
settings_data["startingItems"] = StartingItemList
settings_data["plando"]["locations"] = PlandoList
settings_data["specialConds"]["BRIDGE"] = BridgeCond
settings_data["specialConds"]["MOON"] = MoonCond
settings_data["specialConds"]["GANON_BK"] = GanonBKCond
settings_data["specialConds"]["MAJORA"] = MajoraCond

# Convert the settings into a JSON string (or similar format if required)
settings_json = json.dumps(settings_data)

# Compress the settings using zlib
compressed_data = zlib.compress(settings_json.encode())

# Base64 encode the compressed data
encoded_data = base64.urlsafe_b64encode(compressed_data).decode()

# Remove any unnecessary padding (optional, as the decoder will usually handle it)
encoded_data = encoded_data.rstrip("=")

# Format the final seed string (prepend 'v1.' to the encoded string)
seed_string = f"v1.{encoded_data}"

# Create the 'output' directory if it doesn't exist
os.makedirs("output", exist_ok=True)

with open("output/seed_output.txt", "w") as file:
    file.write("Seed String:\n")
    file.write("\n")
    file.write(seed_string)

with open("output/settings_output.txt", "w") as file:
    file.write("Settings List:\n")
    file.write("\n")
    for key, value in settings_data.items():
        file.write(f"{key}: {value}\n")

with open("output/settings_spoiler.txt", "w") as spoiler_file:
    print("OoTMM Random Settings Generator -- Spoiler Log", file=spoiler_file)
    print("Hard Settings Shuffled:", HardCounter, file=spoiler_file)
    print("Major Settings Shuffled:", MysteryCount, file=spoiler_file)
    print("Logic Settings:", Logic, file=spoiler_file)
    print("Item Pool Settings:", ItemPool, file=spoiler_file)
    if settings["MMWorldLayout"][1][1] > 0:
        print("World Layout:", WorldLayout.upper(), file=spoiler_file)
    print("", file=spoiler_file)
    print("Goal:", WinCond, file=spoiler_file)
    if WinCond == "Triforce Hunt":
        print("Triforce Pieces Needed:", SettingsList["triforceGoal"], file=spoiler_file)
        print("Triforce Pieces Overall:", SettingsList["triforcePieces"], file=spoiler_file)
    print("", file=spoiler_file)
    print("Memey Settings:", file=spoiler_file)
    print("Climb Most Surfaces:", ClimbSurfaces, file=spoiler_file)
    print("Hookshot Anywhere:", HookshotAnywhere, file=spoiler_file)
    print("Instant Transform:", SettingsList["fastMasks"], file=spoiler_file)
    print("", file=spoiler_file)
    print("Main Settings:", file=spoiler_file)
    print("Skip Child Zelda:", SkipChildZelda, file=spoiler_file)
    print("Door Of Time:", DoorOfTime, file=spoiler_file)
    print("Songsanity:", SongShuffle, file=spoiler_file)
    if SongShuffle == "Mixed with Owls" and OcarinaButtonShuffle == True:
        print("Ocarina Buttons: Mixed with Songs and Owls", file=spoiler_file)
    else:
        if OcarinaButtonShuffle == True:
            print("Ocarina Buttons:", OcarinaButtonShuffle, "start with", StartingButtonCount, file=spoiler_file)
        else:
            print("Ocarina Buttons: False", file=spoiler_file)
    print("Sword Shuffle:", SwordShuffle, file=spoiler_file)
    if SwordShuffle == True:
        print("Master Sword needed for Time Travel:", SettingsList["timeTravelSword"], file=spoiler_file)
    print("Gerudo Card Shuffle:", GerudoCardShuffle, file=spoiler_file)
    print("OoT Skullsanity:", SettingsList["goldSkulltulaTokens"].capitalize(), file=spoiler_file)
    print("MM Skullsanity:", SettingsList["housesSkulltulaTokens"].capitalize(), file=spoiler_file)
    print("Grass Shuffle:", GrassShuffle.capitalize(), file=spoiler_file)
    print("Pot Shuffle:", PotShuffle.capitalize(), file=spoiler_file)
    print("Freestanding Rupees and Hearts Shuffle:", FreestandingShuffle.capitalize(), file=spoiler_file)
    print("Wonder Spot Shuffle: OoT", WonderSpotShuffle.capitalize(), "MM", WonderSpotShuffle != "none", file=spoiler_file)
    print("Crate and Barrel Shuffle:", SharedCratesAndBarrels.capitalize(), file=spoiler_file)
    print("Snowball Shuffle:", SettingsList["shuffleSnowballsMm"].capitalize(), file = spoiler_file)
    print("Red Boulder Shuffle:", RedBoulderShuffle, file=spoiler_file)
    print("Icicle Shuffle:", IcicleShuffle, file=spoiler_file)
    print("Red Ice Shuffle:", RedIceShuffle, file=spoiler_file)
    print("Cow Shuffle:", SharedCowShuffle, file=spoiler_file)
    print("Child Wallet Shuffle:", ChildWallet, file=spoiler_file)
    print("Shop Shuffle:", SharedShopShuffle.capitalize(), file=spoiler_file)
    if SharedShopShuffle == "full":
        print("Merchant Shuffle:", ScrubShuffle, file=spoiler_file)
        print("Price Shuffle:", PriceShuffle.capitalize(), file=spoiler_file)
        if PriceShuffle == "weighted" or PriceShuffle == "random":
            print("Maximum Wallet Size:", MaxWalletSize, file=spoiler_file)
    if SettingsList["clocks"] == True:
        print("Clock Shuffle:", SettingsList["progressiveClocks"].capitalize(), file=spoiler_file)
        if SettingsList["progressiveClocks"] == "separate":
            print("Starting Clocks:", StartingClocks, file=spoiler_file)
        else:
            print("Clock Shuffle:", SettingsList["clocks"], "starting with", StartingClockAmount, file=spoiler_file)
    else:
        print("Clock Shuffle: False", file=spoiler_file)
    print("Fountain and Spot Fairies Shuffle:", FairyFountainShuffle, file=spoiler_file)
    print("Butterfly Shuffle:", ButterflyShuffle, file=spoiler_file)
    print("Hive Shuffle:", SharedHiveShuffle, file=spoiler_file)
    print("Soul Shuffle:", SoulShuffle, file=spoiler_file)
    if SongShuffle != "Mixed with Owls":
        print("Owl Statue Shuffle:", OwlShuffle.capitalize(), file=spoiler_file)
    print("Fishing Pond Shuffle:", FishingPondShuffle, file=spoiler_file)
    print("OoT Diving Rupee Shuffle:", DivingGameShuffle, file=spoiler_file)
    print("OoT Pre-Planted Beans:", PrePlantedBeans, file=spoiler_file)
    print("", file=spoiler_file)
    print("Dungeon Item Settings:", file=spoiler_file)
    print("OoT Small Keys:", SKeyShuffle[1].capitalize(), file=spoiler_file)
    print("OoT Game Keys:", SettingsList["smallKeyShuffleChestGame"].capitalize(), file=spoiler_file)
    print("MM Small Keys:", SKeyShuffle[0].capitalize(), file=spoiler_file)
    print("OoT Silver Rupees:", SettingsList["silverRupeeShuffle"].capitalize(), file=spoiler_file)
    print("MM Stray Fairies:", SettingsList["strayFairyOtherShuffle"].capitalize(), file=spoiler_file)
    print("Boss Keys:", BKeyShuffle.capitalize(), file=spoiler_file)
    if BKeyShuffle != "anywhere":
        print("Boss Souls:", SharedBossSoulShuffle, file=spoiler_file)
    print("Deku Tree:", SettingsList["dekuTree"].capitalize(), file=spoiler_file)
    print("King Zora:", SettingsList["zoraKing"].capitalize(), file=spoiler_file)
    print("Zora's Domain Adult Shortcut:", SettingsList["openZdShortcut"], file=spoiler_file)
    print("Gibdo Well:", SettingsList["beneathWell"].capitalize(), file=spoiler_file)
    print("", file=spoiler_file)
    print("Entrance Settings:", file=spoiler_file)
    print("Spawn:", SettingsList["erSpawns"].capitalize(), file=spoiler_file)
    if SongShuffle != "Mix with Owls":
        print("Warp Songs:", WarpSongShuffle, file=spoiler_file)
    if GameLink == False:
        print("World Entrances:", EntranceRandomizer.capitalize(), file=spoiler_file)
    else:
        print("World Entrances:", EntranceRandomizer.capitalize() + " and Game Link", file=spoiler_file)
    print("Grotto Entrances:", SettingsList["erGrottos"]=="full", file=spoiler_file)
    print("Dungeon Entrances:", DungeonEntranceShuffle, file=spoiler_file)
    if DungeonEntranceShuffle == True:
        print("Ganon's Castle Included:", GanonCastleShuffle, file=spoiler_file)
        print("Ganon's Tower Included:", GanonTowerShuffle, file=spoiler_file)
        print("Clock Tower Included:", ClockTowerShuffle, file=spoiler_file)
    print("Boss Entrances:", SettingsList["erBoss"]=="full", file=spoiler_file)
    if entranceTypeShuffled > 0 and settings["DecoupledEntrances"][1][0] != 0:
        print("Decoupled Entrances:", SettingsList["erDecoupled"], file = spoiler_file)
    print("", file=spoiler_file)
    if entranceTypeShuffled > 1 and settings["Mixed"]["Allow"][1][0] != 0 and "MixedList" in globals():
        print("Mixed Entrances:", MixedEntrances, file=spoiler_file)
        if MixedEntrances == True:
            for key in MixedList:
                if key != MixedList[-1]:
                    spoiler_file.write(f"{key}, ")
                else:
                    spoiler_file.write(f"{key}")
            spoiler_file.write("\n")
        print("", file=spoiler_file)
    print("Ageless Items:", AgelessAmount, file=spoiler_file)
    if AgelessAmount > 0:
        for key in AgeAllowed:
            if key != AgeAllowed[-1]:
                spoiler_file.write(f"{key[7:]}, ")
            else:
                spoiler_file.write(f"{key[7:]}")
        spoiler_file.write("\n")
    print("", file=spoiler_file)
    print("MQ Dungeons:", SharedMQDungeons, file=spoiler_file)
    if SharedMQDungeons > 0:
        for key in MQDungeonChosen:
            if key != MQDungeonChosen[-1]:
                spoiler_file.write(f"{key}, ")
            else:
                spoiler_file.write(f"{key}")
        spoiler_file.write("\n")
    print("", file=spoiler_file)
    print("Open Dungeons:", OpenDungeonAmount, file=spoiler_file)
    if OpenDungeonAmount > 0:
        for key in OpenDungeons:
            if key != OpenDungeons[-1]:
                spoiler_file.write(f"{key}, ")
            else:
                spoiler_file.write(f"{key}")
        spoiler_file.write("\n")
    print("", file=spoiler_file)
    if SKeyShuffle[0] != "removed" and SKeyShuffle[1] != "removed":
        print("Key Rings:", KeyRingAmount, file=spoiler_file)
        if KeyRingAmount > 0:
            for key in KeyRingsChosen:
                if key != KeyRingsChosen[-1]:
                    spoiler_file.write(f"{key}, ")
                else:
                    spoiler_file.write(f"{key}")
            spoiler_file.write("\n")
        print("", file=spoiler_file)
    if SettingsList["silverRupeeShuffle"] != "vanilla":
        print("Silver Rupee Pouches:", SilverPouchAmount, file=spoiler_file)
        if SilverPouchAmount > 0:
            for key in SilverPouchesChosen:
                if key != SilverPouchesChosen[-1]:
                    spoiler_file.write(f"{key}, ")
                else:
                    spoiler_file.write(f"{key}")
            spoiler_file.write("\n")
        print("", file=spoiler_file)
    print("Ganon Trials:", GanonTrialAmount, file=spoiler_file)
    if GanonTrialAmount > 0:
        for key in TrialChosen:
            if key != TrialChosen[-1]:
                spoiler_file.write(f"{key}, ")
            else:
                spoiler_file.write(f"{key}")
        spoiler_file.write("\n")
    if SoulShuffle == "Enemy" or SoulShuffle == "Full":
        print("Starting Enemy Souls:", f"{StartingEnemyPerc}%", file=spoiler_file)
        if StartingEnemyAmount > 0:
            for key in StartingEnemyChosen:
                if key != StartingEnemyChosen[-1]:
                    spoiler_file.write(f"{key}, ")
                else:
                    spoiler_file.write(f"{key}")
            spoiler_file.write("\n")
    if SoulShuffle == "NPC" or SoulShuffle == "Full":
        print("Starting NPC Souls:", f"{StartingNPCPerc}%", file=spoiler_file)
        if StartingNPCAmount > 0:
            for key in StartingNPCChosen:
                if key != StartingNPCChosen[-1]:
                    spoiler_file.write(f"{key}, ")
                else:
                    spoiler_file.write(f"{key}")
            spoiler_file.write("\n")
