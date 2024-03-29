if(!X_Server) exitWith {};

diag_log format["WASTELAND SERVER - Initilizing Server Vars"];

CVG_weapons = [];
CVG_weapons = CVG_rifles;
CVG_weapons = CVG_weapons + CVG_Scoped;
CVG_weapons = CVG_weapons + CVG_Heavy;
CVG_weapons = CVG_weapons + CVG_pistols;
CVG_weapons = CVG_weapons + CVG_Launchers;

sideMissionPos = "";
mainMissionPos = "";

currentVehicles = [];
publicVariable "currentVehicles";
pvar_teamSwitchList = [];
publicVariable "pvar_teamSwitchList";
pvar_teamKillList = [];
publicVariable "pvar_teamKillList";
pvar_beaconListBlu = []; 
publicVariable "pvar_beaconListBlu";
pvar_beaconListRed = []; 
publicVariable "pvar_beaconListRed";
pvar_groupBeaconList = []; 
publicVariable "pvar_groupBeaconList";
clientMissionMarkers = [];
publicVariable "clientMissionMarkers";
clientRadarMarkers = [];
publicVariable "clientRadarMarkers";
currentDate = [];
publicVariable "currentDate";
currentInvites = [];
publicVariable "currentInvites";
                  
if (isServer) then {
	"PlayerCDeath" addPublicVariableEventHandler {_id = (_this select 1) spawn server_playerDied};
};

currentStaticHelis = []; // Storage for the heli marker numbers so that we don't spawn wrecks on top of live helis

//Civilian Vehicle List - Random Spawns
civilianVehicles = [
	"car_hatchback",
	"car_sedan",
	"datsun1_civil_2_covered",
	"SkodaGreen",
	"Lada2",
	"V3S_Civ",
	"UralCivil",
	"VWGolf",
	"MMT_Civ",
	"Ikarus_TK_CIV_EP1",
	"Lada1_TK_CIV_EP1",
	"Old_moto_TK_Civ_EP1",
	"S1203_TK_CIV_EP1",
	"UAZ_Unarmed_TK_CIV_EP1",
	"ATV_US_EP1",
	"BAF_Offroad_W",
	"S1203_ambulance_EP1",
	"LadaLM",
	"hilux1_civil_2_covered"
];

//Military Vehicle List - Random Spawns
militaryVehicles = [
	"UAZ_CDF",
	"SUV_PMC",
	"MTVR",
	"BAF_Offroad_W",
	"HMMWV",
	"HMMWV_Ambulance",
	"S1203_ambulance_EP1",
	"GAZ_Vodnik_MedEvac"
];

//Armed Military Vehicle List - Random Spawns
armedMilitaryVehicles = [
	"ArmoredSUV_PMC",
	"Pickup_PK_GUE",
	"UAZ_MG_TK_EP1",
	"LandRover_MG_TK_INS_EP1",
	"HMMWV_M2",
	"HMMWV_Armored",
	"HMMWV_MK19",
	"HMMWV_TOW",
	"GAZ_Vodnik",
	"M113_TK_EP1", 
	"HMMWV_M1035_DES_EP1", 
	"HMMWV_M998A2_SOV_DES_EP1", 
	"HMMWV_M1151_M2_DES_EP1",
	"HMMWV_M998_crows_M2_DES_EP1", 
	"HMMWV_M998_crows_MK19_DES_EP1"
];

//Item Config
pickupList = [
	"Satelit",
	"EvMoney",
	"Suitcase",
	"Fuel_can"
];
objectList = [
	"Land_Barrel_water",
	"Land_prebehlavka",
	"Land_leseni2x",
	"Fort_Crate_wood",
	"Land_CamoNet_NATO",
	"Land_Barrel_water",
	"Land_stand_small_EP1",
	"Land_stand_small_EP1",
	"Base_WarfareBBarrier10xTall",
	"Base_WarfareBBarrier10x",
	"Base_WarfareBBarrier5x",
	"Base_WarfareBBarrier10xTall",
	"Base_WarfareBBarrier10x",
	"Base_WarfareBBarrier5x",
	"Land_Misc_deerstand",
	"Fort_Barricade",
	"Concrete_Wall_EP1",
	"Concrete_Wall_EP1",
	"Land_fort_bagfence_long",
	"Land_fort_bagfence_long",
	"Land_fort_bagfence_round",
	"Land_fort_bagfence_corner",
	"Land_BagFenceLong",
	"Land_BagFenceLong",
	"Land_fort_artillery_nest",
	"Land_fortified_nest_small_EP1",
	"Land_Misc_deerstand",
	"Land_fort_rampart",
	"Land_fort_rampart_EP1",
	"Land_HBarrier_large",
	"Land_HBarrier_large",
	"Land_Misc_Scaffolding",
	"Land_Fort_Watchtower_EP1",
	"Land_Fort_Watchtower",
	"Land_fortified_nest_big",
	"RampConcrete",
	"Base_WarfareBBarrier10xTall",
	"WarfareBDepot",
	"WarfareBCamp",
	"Hedgehog",
	"Land_ConcreteRamp",
	"Land_CncBlock_Stripes",
	"Land_Campfire_burning",
	"Land_GuardShed",
	"Land_tent_east",
	"Land_ConcreteBlock",
	"Land_A_Castle_Stairs_A",
	"Land_Barrack2",
	"Land_Hlidac_budka",
	"Land_Ind_SawMillPen",
	"Land_Shed_wooden",
	"Land_Wall_Gate_Village",
	"Land_plot_green_branka",
	"Land_plot_rust_vrata",
	"Land_plot_green_vrata",
	"CampEast",
	"CampEast_EP1",
	"Misc_cargo_cont_net2",
	"Misc_cargo_cont_small2",
	"Fort_RazorWire",
	"Land_HBarrier1",
	"Land_HBarrier3",
	"Land_Fort_Watchtower",
	"Sign_Danger",
	"Land_Misc_Well_L_EP1",
	"Land_transport_kiosk_EP1"
];
                                         
//Object List - Random Spawns.
staticWeaponsList = [
	"M2StaticMG_US_EP1",
	"DSHKM_TK_INS_EP1",
	"DSHkM_Mini_TriPod_CDF",
	"KORD_high",
	"KORD",
	"M2HD_mini_TriPod"
];

staticHeliList = [
	"UH1H_TK_GUE_EP1",
	"Mi17_Civilian",
	"MV22",
	"CH_47F_EP1",
	"Mi17_TK_EP1",
	"MH6J_EP1",
	"UH60M_MEV_EP1",
    "AH6X_EP1",
	"Mi17_Ins"
];

//Random Weapon List - Change this to what you want to spawn in cars.
vehicleWeapons = [
	"AK_107_GL_kobra",
	"AK_107_kobra",
	"AK_47_M",
	"AK_47_S",
	"AK_74",
	"AK_74_GL",
	"AK_74_GL_kobra",
	"BAF_L110A1_Aim",
	"BAF_L7A2_GPMG",
	"BAF_L85A2_RIS_ACOG",
	"BAF_L85A2_UGL_Holo",
	"BAF_L86A2_ACOG",
	"bizon",
	"bizon_silenced",
	"FN_FAL",
	"G36a",
	"G36_C_SD_eotech",
	"LeeEnfield",
	"M1014",
	"M16A2",
	"M14_EP1",
	"M16A2GL",
	"m16a4",
	"M240",
	"M249",
	"M4A1_Aim",
	"M4A1_HWS_GL",
	"M4A3_CCO_EP1",
	"M60A4_EP1",
	"m8_carbine",
	"MG36",
	"Mk_48",
	"MP5A5",
	"Sa58V_EP1",
	"Sa58V_CCO_EP1",
	"Saiga12K",
	"SCAR_H_CQC_CCO",
	"SCAR_L_CQC"
];
                
MissionSpawnMarkers = [
	["Mission_0",false],
	["Mission_1",false],
	["Mission_2",false],
	["Mission_3",false],
	["Mission_4",false],
	["Mission_5",false],
	["Mission_6",false],
	["Mission_7",false],
	["Mission_8",false],
	["Mission_9",false],
	["Mission_10",false],
	["Mission_11",false],
	["Mission_12",false],
	["Mission_13",false],
	["Mission_14",false],
	["Mission_15",false],
	["Mission_16",false],
	["Mission_17",false],
	["Mission_18",false],
	["Mission_19",false],
	["Mission_20",false],
	["Mission_21",false],
	["Mission_22",false],
	["Mission_23",false],
	["Mission_24",false],
	["Mission_25",false],
	["Mission_26",false],
	["Mission_27",false],
	["Mission_28",false],
	["Mission_29",false],
	["Mission_30",false],
	["Mission_31",false],
	["Mission_32",false],
	["Mission_33",false],
	["Mission_34",false],
	["Mission_35",false],
	["Mission_36",false],
	["Mission_37",false],
	["Mission_38",false],
	["Mission_39",false],
	["Mission_40",false],
	["Mission_41",false],
	["Mission_42",false],
	["Mission_43",false],
	["Mission_44",false],
	["Mission_45",false],
	["Mission_46",false],
	["Mission_47",false],
	["Mission_48",false],
	["Mission_49",false],
	["Mission_50",false]
];