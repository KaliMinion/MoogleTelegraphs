MoogleTelegraphs = {}
local self = MoogleTelegraphs
local selfs = "MoogleTelegraphs"
local selfslong = "Moogle Telegraphs"
local selfshort = "Telegraphs"

local MinionPath = GetStartupPath()
local LuaPath = GetLuaModsPath()
local ModulePath = LuaPath .. [[Moogle Telegraphs\]]
local ModuleSettings = ModulePath .. [[Settings.lua]]
local DebugOutput = ModulePath .. [[DebugOutput.lua]]
local ImageFolder = ModulePath .. [[Images\]]

self.Info = {
	Creator = "Kali",
	Version = "3.2.0",
	StartDate = "01/23/2020",
	LastUpdate = "02/05/2020",
	ChangeLog = {
		["1.0.0"] = "Initial release",
		["1.5.0"] = "Added support for Argus draw functions",
		["2.0.0"] = "Added filled draws",
		["2.1.0"] = "Raid Wide filled shape fix.",
		["2.2.0"] = "Same Size Issue fix",
		["2.3.0"] = "AOE Outline",
		["2.4.0"] = "Friendly Color indicator",
		["2.5.0"] = "Friendly line colors",
		["2.6.0"] = "Fill color increases alpha gradually",
		["2.7.0"] = "Line AoEs alpha increases too now",
		["2.8.0"] = "Added filled cross and donuts",
		["3.0.0"] = "Rewrite/Cleanup",
		["3.1.0"] = "Alpha %% now drawn correctly.",
		["3.2.0"] = "Rewrite/Cleanup and added GUI options including show entity heading."
	}
}

self.Settings = {
	enable = true,
	MainMenuType = 2,
	MainMenuEntryCreated = false,
	open = false,


	DebugRecord = true,
	DebugFile = true,
	DebugCastingToConsole = false,
	DebugChannelingToConsole = false,
	DebugMarkerToConsole = false,

	DebugTypesEnabled = {
		[1] = true,
		[2] = true,
		[3] = true,
	},
	DebugLogLimit = 10000,
	DebugLog12Hour = true,
	DebugLogPopOut = false,
	DebugLogPopOutCollapsed = false,
	DebugLogPopOutSize = { x = 530, y = 175 },
	DebugLogPopOutPos = { x = 0, y = 0 },


	verticesSpacing = 0.5,
	maxSegments = 50,


	DrawPlayerDot = true,
	DrawDotCombatOnly = false,
	DrawDotInstanceOnly = false,
	DotRGB = {r=1,g=0,b=0,a=1},
	DotDotU32 = 4278190335,
	DotSize = 4,


	DrawHealingAoE = true,
	DrawHealingOutOfRange = true,
	DrawHealingCirclesOutline = true,
	DrawHealingOutlineIfHealer = true,
	--DrawHealingAoEInRange = false,
	DrawFriendlyAoE = false,
	--DrawFriendlyOutRange = true,
	DrawFriendlyLB = false,
	--DrawSelfHealingOutline = true,
	DrawAttackRange = true,

	largeAoE = 30,
	alphafill = {
		enemy = {
			small = {
				min = 0.05,
				max = 0.5
			},
			large = {
				min = 0.025,
				max = 0.25
			}
		},
		healing = {
			small = {
				min = 0.05,
				max = 0.5
			},
			large = {
				min = 0.025,
				max = 0.25
			}
		},
		friend = {
			small = {
				min = 0.05,
				max = 0.5
			},
			large = {
				min = 0.025,
				max = 0.25
			}
		},
	},
	fillRGB = {
		enemy = {
			r = 1,
			g = 0,
			b = 0
		},
		healing = {
			r = 0,
			g = 1,
			b = 0,
		},
		friend = {
			r = 0,
			g = 0,
			b = 1,
		},
	},
	outlineRGB = {
		enemy = {
			r = 1,
			g = 0,
			b = 0,
			a = 1
		},
		healing = {
			r = 0,
			g = 1,
			b = 0,
			a = 1
		},
		friend = {
			r = 0,
			g = 0,
			b = 1,
			a = 1
		},
		rangeInside = {
			r = 1,
			g = 1,
			b = 1,
			a = 0.3
		},
		rangeOutside = {
			r = 1,
			g = 1,
			b = 0,
			a = 0.3
		}
	},
	outlineThickness = {
		enemy = 2,
		healing = 2,
		friend = 2,
		range = 4
	},


	UnknownConeAngle = 90,
	UnknownDonutRadius = 5,


	MaxTelegraphDrawRange = 0,
	MaxTelegraphsFilled = 0,


	HealingAoeActions = {124,133,186,206,207,208,803,825,1594,3362,3583,3600,3601,7439,8324,11406,12578,16015,16517,16534,16537,16543,16544,16546,16547,16550,16553,16558,17001,17152,17763,17785,18318,18945,18946,18947,18948,18950,18951},


	DrawHeadingEntities = true,
	showHeadingEntities = {
		{
			contentid = "8381",
			customFront = 0,
			customHitRadius = 0,
			mapid = 0,
			name = "Nyx",
			note = "Ahriman's in E2/E2S that inflicts Damage Down and Diabolic Curse on contact.",
		},
	},
	showHeadingMinRadius = 1.5,
	showHeadingMinFront = 1.5,
	showHeadingFillingRGB = {
		r = 0.5,
		g = 0,
		b = 0,
		a = 0.15
	},
	showHeadingOutlineRGB = {
		r = 0.5,
		g = 0,
		b = 0,
		a = 0.5
	},
	showHeadingOutlineThickness = 6,


	aoeIDUserBlacklist = {}, -- key = aoeID, value = w/e


	syncVerticalPosHeight = {
		near = 0.5,
		above = 5,
		below = 1
	}
}

self.Override = {}

self.Data = {
	loaded = false,
	lastcheck = 0,
	lastColorChange = 0,
	lastColorRGB = {},
	lastColorAlpha = 1,
	lastLineRGB = {},
	lastLineThickness = 2,
	DebugRecordings = {Directional={},Ground={}},
	ActionNameOmens = {},
	--[[ Omen = {
		[1] = "general_1bf",
		[2] = "general02f",
		[3] = "gl_fan060_1bf", -- Earth Shaker
		[4] = "gl_fan090_1bf",
		[5] = "gl_fan120_1bf",
		[6] = "m0096sp_05c1s",
		[7] = "m0096sp_06c2s",
		[8] = "m0098sp04cx0t",
		[9] = "m0098sp07cx0t",
		[10] = "m0077sp03o0m",
		[11] = "m0077sp03o1m",
		[12] = "gl_sircle_1907af",
		[13] = "gl_sircle_3004af",
		[14] = "gl_sircle_5003af",
		[15] = "gl_fan270_0100af",
		[16] = "gl_fan270_1005af",
		[17] = "gl_fan270_1510af",
		[18] = "sandpilr1o0c",
		[19] = "m0063gt_loop_0m",
		[20] = "m0057sp09cx0s",
		[21] = "m0062sp_03o0s",
		[22] = "taihuunome0m",
		[23] = "tatumaki0m",
		[24] = "m063sp019o0c",
		[25] = "m0031sp03o0c",
		[26] = "m0099sp_03o0t",
		[27] = "gl_shipimpact0f",
		[28] = "gl_fan150_1bf",
		[29] = "d1006_meteo1m",
		[30] = "d1006_sp04o1m",
		[31] = "m0172sp05o0c",
		[32] = "m0095sp16o0c",
		[33] = "m0073_mijingiri1m",
		[34] = "m0073_wagiri1m",
		[35] = "m0073_wagiri2m",
		[36] = "m0073_wagiri3m",
		[37] = "m0073_wagiri4m",
		[38] = "m0073_ougigiri1m",
		[39] = "m0073_jiraisin1m",
		[40] = "undeadraise1o0h",
		[41] = "rinsen_s_omen",
		[42] = "rinsen_m_omen",
		[43] = "rinsen_l_omen",
		[44] = "leviathan_mizubakudan1t0h",
		[45] = "neil_jiware_o0t",
		[46] = "bahamut2_bomu_omen0s",
		[47] = "m0171sp05o0c",
		[48] = "d1006_delta1m",
		[49] = "d1006_overpowaer1m",
		[50] = "m0123_banrai_omen1s",
		[51] = "m0212sp02o0c",
		[52] = "kuraken_kanketu_gtkougeki_o0c",
		[53] = "m0074sp04o0c",
		[54] = "m7006sp01omen1s",
		[55] = "m7006sp03omen1s",
		[56] = "m0125sp05o0h",
		[57] = "m0125_gardian_enerugihdan_0m",
		[58] = "shiva_fuyuturara_raka_omen1m",
		[59] = "shiva_fleezfloa_omen0m",
		[60] = "m0070_fan120_0h",
		[61] = "m0070_fan180_0h",
		[62] = "phoenix_bluefire0t",
		[63] = "m0118sp05o0t",
		[64] = "m0117_gtae_01s",
		[65] = "m0117_trap_01s",
		[66] = "m0129sp01_omen_m",
		[67] = "mokuyaku_genryu_bom1m",
		[68] = "mokuyaku_genryu_bom2m",
		[69] = "mokuyaku_genryu_bom3m",
		[70] = "mokuyaku_genryu_o1m",
		[71] = "mokuyaku_genryu_o2m",
		[72] = "mokuyaku_genryu_o3m",
		[73] = "m131om_setu0f",
		[74] = "m131om_getu0f",
		[75] = "m131om_hana0f",
		[76] = "m070_fleezfloa_omen0f",
		[77] = "m070_meteo1f",
		[78] = "gl_sircle_1512af",
		[79] = "m0272sp09o0c",
		[80] = "m0260sp03o0c",
		[81] = "m0227_sp03_omen1s",
		[82] = "d1024_sp03_0s",
		[83] = "fate_altema_madoufensu1t",
		[84] = "m0248_freeze_o0c",
		[85] = "m0248_center_o0c",
		[86] = "m0248_side_o0c",
		[87] = "d1015sp11o0c",
		[88] = "m0244laser_o0t",
		[89] = "m0244donut_o0t",
		[90] = "d1025_sp012_bunsan01s",
		[91] = "c0501_fan240af",
		[92] = "d1025_sp11_zignzan0c",
		[93] = "m0103sp03o0t",
		[94] = "m0244en_o0t",
		[95] = "m0066tatari_o0c",
		[96] = "bismarck_mizubakudan1h",
		[97] = "m0070_taberu0c",
		[98] = "gl_fan060_1bf",
		[99] = "gl_fan030_0f",
		[100] = "gl_fan060_1f",
		[101] = "gl_fan120_1f",
		[102] = "general01bf",
		[103] = "gl_sircle_6008tf",
		[104] = "m0280sp02o0t",
		[105] = "gl_fan030_1bf",
		[106] = "manta_mizubakudan1h",
		[107] = "gl_fan180_1bf",
		[108] = "gl_sircle_1005bf",
		[109] = "m0311sp06o0c",
		[110] = "m0257gimmick0h",
		[111] = "gl_sircle_2010bf",
		[112] = "gl_sircle_3020bf",
		[113] = "gl_sircle_5003bf",
		[114] = "m0263_tossin01s",
		[115] = "m0285laser_o0t",
		[116] = "m330_zombi0ah",
		[117] = "zombieraise1o0h",
		[118] = "m0329_tossin01h",
		[119] = "m0336ice0f",
		[120] = "m0119_trap_01t",
		[121] = "undeadraise2o0c",
		[122] = "m0344_quasar01ah",
		[123] = "m0344_quasar02ah",
		[124] = "m0344sp08o0h",
		[125] = "m0361en_o0t",
		[126] = "m0344_quasar01bh",
		[127] = "m0012bitlz_o0t",
		[128] = "gl_fan210_1bf",
		[129] = "m0347hadou_o0t",
		[130] = "m0347tossin_o0t",
		[131] = "m0375handc0c",
		[132] = "m0307_aeroga0h",
		[133] = "m0307_aeroja0h",
		[134] = "m0307_blizzaga0h",
		[135] = "m0307_death0h",
		[136] = "gl_sircle_1034bf",
		[137] = "gl_sircle_3014bf",
		[138] = "gl_blu_lz01af",
		[139] = "m0376_mizu_o0p",
		[140] = "m0430gl_lz01i",
		[141] = "m0430gl_sircle_2013b01i",
		[142] = "general02f",
		[143] = "m074fire_circle_1504_01i",
		[144] = "m389singentic0n",
		[145] = "yazirushi1o0c",
		[146] = "gl_fan020_0f",
		[147] = "m0372_stlight01j",
		[148] = "m0372_umiwari01j",
		[149] = "m0372_ultrikou01j",
		[150] = "m0372_meilst01j",
		[151] = "m0376_tossin01h",
		[152] = "gl_shipimpact1f",
		[153] = "g3fc_b0_g02_o0c",
		[154] = "m0163_holy01h",
		[155] = "m0448_sp01red_o0v",
		[156] = "m0445houtei_o0c",
		[157] = "m0446show01o0h",
		[158] = "m0446sp14o0h",
		[159] = "bl_fan060_0f",
		[160] = "m0441sp03o0c",
		[161] = "general_1bxf",
		[162] = "general02xf",
		[163] = "gl_fan090_1bxf",
		[164] = "gl_fan120_1bxf",
		[165] = "gl_shipimpact0xf",
		[166] = "m0445sp03o0c",
		[167] = "m0121_blizzaga0f",
		[168] = "circle_sp01f",
		[169] = "m0462cir_a_o0c",
		[170] = "m0462don_a_o0c",
		[171] = "m0462lay_a_o0c",
		[172] = "m0462cir_b_o0c",
		[173] = "m0462don_b_o0c",
		[174] = "m0462lay_b_o0c",
		[175] = "m0462tenso_o0c",
		[176] = "m0456_sp03o1v",
		[177] = "m0454sp05_sircle_2504_01i",
		[178] = "general_1bwf",
		[179] = "general02wf",
		[180] = "gl_sircle_4010bwf",
		[181] = "er_general_1f",
		[182] = "er_general02f",
		[183] = "er_gl_fan060_1bf",
		[184] = "er_gl_fan090_1bf",
		[185] = "er_gl_fan120_1bf",
		[186] = "m0454sp17_sircle_2505_01i",
		[187] = "m0227_sp03_omen2f",
		[188] = "general_x02f",
		[189] = "m0487_light0h",
		[190] = "m0480_highspeed_c0x",
		[191] = "m0480_lowspeed_c0x",
		[192] = "m0506en_o0f",
		[193] = "m0481pot_o0c",
		[194] = "er_gl_fan180_1bf",
		[195] = "m0096sp_05c1bf",
		[196] = "m063mist_omen_o0v",
		[197] = "m0295_fire_sircle_h30m10_01i",
		[198] = "m0295_tunami_lz15_40_01i",
		[199] = "d2d9_b2_o0v",
		[200] = "d2d9_b2_o1v",
		[201] = "m0295_wind_sircle_h10_01i",
		[202] = "m0295_earth_lz4020_01i",
		[203] = "m0295_nockback_omen01i",
		[204] = "m0295_hikiyose_omen01i",
		[205] = "m0515cir_a_o0c",
		[206] = "gl_fan045_1bf",
		[207] = "gl_fan045_1bxf",
		[208] = "m0461om_hana0x",
		[209] = "m0461_umiwari01x",
		[210] = "m0001_ikaku_omen01p",
		[211] = "m513sp03o0w",
		[212] = "m514sp04o0w",
		[213] = "er_gl_fan270_1bf",
		[214] = "er_sicle_1005f",
		[215] = "m0531_light_o0v",
		[216] = "m0531_dark_o0v",
		[217] = "m0531_sp03l_o0v",
		[218] = "m0531_sp03d_o0v",
		[219] = "gl_sircle_3015ac",
		[220] = "gl_sircle_2008bi",
		[221] = "m0532om_fan01x",
		[222] = "m0532om_don01x",
		[223] = "m0532om_don02x",
		[224] = "m0532om_don03x",
		[225] = "m0534_omen_c0v",
		[226] = "m0557m0204sp07c0p",
		[227] = "gl_sircle_2005bf",
		[228] = "gl_sircle_3007bx",
		[229] = "m0532_hukitobashi_o0w",
		[230] = "m0532_gimc_ae01f",
		[231] = "m0559donut_o0v",
		[232] = "m0118sp30_o0p",
		[233] = "gl_sircle_1610_o0v",
		[234] = "m0559hidesp001_o0v",
		[235] = "er_gl_fan100_o0v",
		[236] = "er_gl_fan100_o1v",
		[237] = "er_m0551_don_4005x",
		[238] = "m0559yazirushio0v",
		[239] = "co_trap00h1",
		[240] = "gl_sircle_1203bf",
		[241] = "m0573_mizu_o0p",
		[242] = "gl_sircle_4005bf",
		[243] = "gl_sircle_3008bf",
		[244] = "m0581dom_a_o0c",
		[245] = "m0561_omen_c0t",
		[246] = "m0118rai_omen1h",
		[247] = "gl_sircle_6005at1",
		[248] = "gl_sircle_3218_o0v",
		[249] = "general02_y1m_t",
		[250] = "gl_sircle_4008ah1",
		[251] = "gl_shipimpact2f",
		[252] = "gl_sircle_2412_o0v",
		[253] = "gl_sircle_3624_o0v",
		[254] = "gl_sircle_4836_o0v",
		[255] = "n4d9_b0_g2_o0w",
		[256] = "m0598cir1_o0c",
		[257] = "general_1bf_y0x",
		[258] = "gl_fan060_1bf_y0x",
		[259] = "gl_sircle_1005y0x",
		[260] = "gl_sircle_1510bx",
		[261] = "gl_sircle_1510y0x",
		[262] = "gl_sircle_2015bx",
		[263] = "gl_sircle_2015y0x",
		[264] = "gl_sircle_1907y0x",
		[265] = "m0611_don_1907x",
		[266] = "m0611_don_2015x",
		[267] = "m0611_fan_60x",
		[268] = "m0611_sircle_01x",
		[269] = "yazirushi2o0p",
		[270] = "ytc_sonicb_om1p",
	},]]
	VFX = {
		[1] = "cmpp_djcas0c",
		[2] = "cmpp_djcas0c",
		[3] = "cmat_ligct0c",
		[4] = "cmst_ethct0c",
		[5] = "cmbw_castx0c",
		[6] = "cmst_ligct0c",
		[7] = "cmat_ethct0c",
		[8] = "cmrv_wndct0c",
		[9] = "cmat_wndct0c",
		[10] = "cmrv_ligct0c",
		[11] = "cmrv_watct0c",
		[12] = "cmwk_drkct1c",
		[13] = "cmat_firct0c",
		[14] = "cmat_icect0c",
		[15] = "cmat_thnct0c",
		[16] = "cmsm_wndct0s",
		[17] = "cmsm_ethct0s",
		[18] = "cmsm_firct0s",
		[19] = "cmtk_castx1t",
		[20] = "cmml_castx1f",
		[21] = "cmml_castx3s",
		[22] = "cmcs_castx1m",
		[23] = "cmhl_castx1f",
		[24] = "mon_eisyo03t",
		[25] = "mon_eisyo01et",
		[26] = "cmat_watct0c",
		[27] = "m0096_cast0s",
		[28] = "cmth_castx0c",
		[29] = "cmma_castx0f",
		[30] = "ystr_castx0h",
		[31] = "cmrg_castx0m",
		[32] = "lmdr_castx3f",
		[33] = "cmdg_castx0t",
		[34] = "lmba_castx3c",
		[35] = "lmma_castx3c",
		[36] = "cmsc_castx1f",
		[37] = "lmas_castx1h",
		[38] = "cmas_castx0h",
		[39] = "cmkt_castx0t",
		[40] = "cmsa_castx0t",
		[41] = "cmrd_castx0h",
		[42] = "m0376_leftwingsnow_c0p",
		[43] = "m0376_leftwingice_c0p",
		[44] = "m0376_rightwingflare_c0p",
		[45] = "m0376_rightwinglightning_c0p",
		[46] = "z3o2_m0420_c0ak",
		[47] = "z3o2_m0420_c0bk",
		[48] = "mgc_2kt001c1t",
		[49] = "cmrl_castx0c",
		[50] = "m0441_leftwingsnow_c0c",
		[51] = "m0441_leftwingice_c0c",
		[52] = "m0441_rightwingflare_c0c",
		[53] = "m0441_rightwinglightning_c0c",
		[54] = "cmlp_castx0t",
		[55] = "mon_eisyo04f",
		[56] = "m0460sp02cast0t",
		[57] = "m0343_cast_sp07x",
		[58] = "m0127_cast_sp12x",
		[59] = "m0127_cast_sp13x",
		[60] = "m0127_cast_sp15x",
		[61] = "m0458sp06cast0t",
		[62] = "m0454_cast_c0i",
		[63] = "m0487buki_loop0h",
		[64] = "m0501_cast_c0i",
		[65] = "m0315_castx1f",
		[66] = "d1027_cast02f",
		[67] = "m0499_b_cast0t",
		[68] = "m0499_c_cast0t",
		[69] = "m0522_cast_idle_c0x",
		[70] = "m0461_cast_sp01_c0x",
		[71] = "m0513sp13cast_c0c",
		[72] = "m0514sp11cast_c0c",
		[73] = "m0295_chaos_cast_c0i",
		[74] = "m0515cast_c0c",
		[75] = "m0499_d_cast0t",
		[76] = "m0499_e_cast0t",
		[77] = "cmat_aoz0f",
		[78] = "m0196_e_cast0t",
		[79] = "m0365sp14_aoz_c0p",
		[80] = "m0432cast1_0t",
		[81] = "m0204hide_sp05c0t",
		[82] = "m0532_cast01x",
		[83] = "z3r3_b4_g05cast_et",
		[84] = "z3r3_b4_g05cast_wt",
		[85] = "cmdg_castx_yg0f",
		[86] = "m0146sp_d_2lp_c0v",
		[87] = "m0146sp_d_2lp_c1v",
		[88] = "m529cast01c0w",
		[89] = "m529cast02c0w",
		[90] = "m0074_cast0k1",
		[91] = "m0554_eishoh_c_c0p",
		[92] = "m0554_eishoh_d_c0p",
		[93] = "m0553_sp07_cast0_e",
		[94] = "m0128_cbbm_sp_e_2lp_t1",
		[95] = "m0128_cbbm_sp_f_2lp_t1",
		[96] = "m0375sp_e_2lpc1v",
		[97] = "m0375_sp023_lp_c0v",
		[98] = "m0553_sp06_cast0_e",
		[99] = "m0585_cst1_c0v",
		[100] = "m0585_cst2_c0v",
		[101] = "m0585_cst3_c0v",
		[102] = "m0585_cst4_c0v",
		[103] = "m0541_2lp_c0_t1",
		[104] = "m204cast01c0w",
		[105] = "m204cast02c0w",
		[106] = "m141_sp_e_2lp_c0v",
		[107] = "m0573_1lp_c0_t1",
		[108] = "m0573_2lp_c0_t1",
		[109] = "m565_eishoh_b_c0p",
		[110] = "m565_eishoh_e_c0p",
		[111] = "m565_eishoh_f_c0p",
		[112] = "m565_eishoh_g_c0p",
		[113] = "c0101sp78_cast_c0i",
		[114] = "c0101sp80_cast_c0i",
		[115] = "m0576_cst0_c0k1",
		[116] = "m0146cast01c0w",
		[117] = "m0562_cast0ll_0t",
		[118] = "m0562_cast0lr_0t",
		[119] = "m0562_cast0rl_0t",
		[120] = "m0562_cast0rr_0t",
		[121] = "cst_m0420_c0af",
		[122] = "m0602cast_r_punch_c01i",
		[123] = "m0602cast_l_punch_c01i",
		[124] = "m0602cast_handclap_c01i",
		[125] = "m0602cast_strike_c01i",
		[126] = "m0602cast_w_rot_saw_c01i",
		[127] = "m0602cast_beam_c01i",
		[128] = "m0073sp21cast0w",
		[129] = "m0073sp17cast0w",
		[130] = "m0073sp18cast0w",
		[131] = "m0614_cast_sp11_c0v",
		[132] = "m0615sp11_eishoh_c0p",
		[133] = "m0069_cast0h1",
		[134] = "m0615eishoh_multi_c0p",
		[135] = "m0598_cst1_c0c",
		[136] = "cmtk_castx2t",
		[137] = "cmml_castx2f",
		[138] = "cmcs_castx2m",
		[139] = "cmhl_castx2f",
		[140] = "cmrg_castx2m",
	},
	LB = {
		[197] = "Shield Wall",
		[198] = "Stronghold",
		[199] = "Last Bastion",
		[200] = "Braver",
		[201] = "Bladedance",
		[202] = "Final Heaven",
		[203] = "Skyshard",
		[204] = "Starstorm",
		[205] = "Meteor",
		[206] = "Healing Wind",
		[207] = "Breath of the Earth",
		[208] = "Pulse of Life",
		[4238] = "Big Shot",
		[4239] = "Desperado",
		[4240] = "Land Waker",
		[4241] = "Dark Force",
		[4242] = "Dragonsong Dive",
		[4243] = "Chimatsuri",
		[4244] = "Sagittarius Arrow",
		[4245] = "Satellite Beam",
		[4246] = "Teraflare",
		[4247] = "Angel Feathers",
		[4248] = "Astral Stasis",
		[7861] = "Doom of the Living",
		[7862] = "Vermilion Scourge",
		[10001] = "Ungarmax",
		[10002] = "Ungarmax",
		[10894] = "Starstorm",
		[11193] = "Starstorm",
		[16578] = "Falling Star",
		[17084] = "Hypershot",
		[17105] = "Gunmetal Soul",
		[17106] = "Crimson Lotus",
		[17211] = "Arrow of Fortitude",
		[17221] = "the Reach of Darkness",
		[17259] = "Eternal Wind",
		[17576] = "Final Bastion",
		[17627] = "Out of the Labyrinth",
		[17993] = "Big Shot",
		[17994] = "Desperado",
		[17995] = "Skyshard",
		[17996] = "Starstorm",
		[17997] = "Braver",
		[17998] = "Bladedance",
		[18781] = "Dragonshadow Dive",
		[18782] = "Dragonshadow Dive"
	},
	HeadMarker = {
		[1] = "Prey Circle (Orange)",
		[2] = "Prey Circle (Orange)",
		[3] = "Prey Circle (Orange)",
		[4] = "Prey Circle (Orange)",
		[7] = "Green Meteor",
		[8] = "Ghost Meteor",
		[9] = "Red Meteor",
		[10] = "Yellow Meteor",
		[13] = "Devour Flower",
		[14] = "Prey Circle (Blue)",
		[16] = "Teal Crystal",
		[17] = "Heavenly Laser (Red)",
		[23] = "Red Pinwheel",
		[28] = "Gravity Puddle",
		[30] = "Prey Sphere (Orange)",
		[31] = "Prey Sphere (Blue)",
		[40] = "Earth Shaker",
		[41] = "Prey Circle (Locked Target)",
		[50] = "Sword Markers 1",
		[51] = "Sword Markers 2",
		[52] = "Sword Markers 3",
		[53] = "Sword Markers 4",
		[55] = "Red Dorito",
		[57] = "Purple Spread Circle (Large)",
		[62] = "Stack Marker (Bordered)",
		[70] = "Green Pinwheel",
		[75] = "Acceleration Bomb",
		[76] = "Purple Fire Circle (Large)",
		[84] = "Thunder Tether (Orange)",
		[87] = "Flare",
		[92] = "Prey (Dark)",
		[93] = "Stack Marker (Tank–No Border)",
		[96] = "Orange Spread Circle (Small)",
		[97] = "Chain Tether (Orange)",
		[100] = "Stack Marker (Bordered)",
		[101] = "Spread Bubble",
		[110] = "Levinbolt",
		[118] = "Prey (Dark)",
		[120] = "Orange Spread Circle (Large)",
		[123] = "Scatter (Animated Play Symbol)",
		[124] = "Turn Away (Animated eye Symbol)",
		[126] = "Green Crystal",
		[131] = "Sword Meteor (Tsukuyomi)",
		[135] = "Prey Sphere (Blue)",
		[138] = "Orange Spread Circle (Large)",
		[139] = "Purple Spread Circle (Small)",
		[142] = "Death From Above",
		[143] = "Death From Below",
		[145] = "Fundamental Synergy Square 1",
		[146] = "Fundamental Synergy Square 2",
		[147] = "Fundamental Synergy Square 3",
		[148] = "Fundamental Synergy Square 4",
		[149] = "Fundamental Synergy Triangle 1",
		[150] = "Fundamental Synergy Triangle 2",
		[151] = "Fundamental Synergy Triangle 3",
		[152] = "Fundamental Synergy Triangle 4",
		[161] = "Stack Marker (Bordered)",
		[169] = "Orange Spread Circle (Small)",
		[171] = "Green Poison Circle",
		[172] = "Reprobation Tether",
		[174] = "Blue Pinwheel",
		[185] = "Yellow Triangle (Spread)",
		[186] = "Orange Square (Stack)",
		[187] = "Blue Square (Big Spread)",
		[189] = "Purple Spread Circle (Giant)",
		[191] = "Granite Gaol",
	},
	CharType = {
		[0] = "NPC",
		[1] = "Enemy (Body Part)",
		[2] = "Pet",
		[3] = "Companion (Chocobo)",
		[4] = "Player",
		[5] = "Enemy",
		[6] = "",
		[7] = "",
		[8] = "",
		[9] = "Trust NPC",
	},
	CastType = {
		[0] = "Any",
		[1] = "Cone / Fan",
		[2] = "Circle - No Padding",
		[3] = "Cone / Fan - With Padding",
		[4] = "Line - Static Length",
		[5] = "Circle - With Padding",
		[6] = "Circle - Meteor Types",
		[7] = "Circle - Ground Targeting, sometimes leaves a puddle",
		[8] = "Line - Follows Player so Length Adjusts",
		[9] = "", -- No Action has CastType 9
		[10] = "Donut - No Padding",
		[11] = "Cross (Two Lines) - No Padding",
		[12] = "Line - No Padding",
		[13] = "Cone / Fan - No Padding",
	},

	aoeIDReactionBlacklist = {}, -- key == aoe ID, value = table containing map IDs as keys

	DebugTypes = {
		[1] = "Entity Casting Action Message",
		[2] = "Entity Channeling Action Message",
		[3] = "Target Icon (Head Markers) Added Message",
	},
	DebugLog = {},
	editHeadingEntry = 0,
}
--local Data = self.Data

self.GUI = {
	WindowName = selfs.."##MainWindow",
	name = selfslong,
	NavName = selfslong,
	open = false,
	visible = true,
	MiniButton = false,
	OnClick = loadstring(selfs..".GUI.open = not "..selfs..".GUI.open"),
	IsOpen = loadstring("return "..selfs..".GUI.open"),
	ToolTip = "A module that works with Argus to draw telegraphs for all actions.",
	WindowStyle = {
		["Text"] = { [1] = 0, [2] = 0, [3] = 0, [4] = 0 },
		["TextDisabled"] = { [1] = 0, [2] = 0, [3] = 0, [4] = 0 },
		["WindowBg"] = { [1] = 7, [2] = 0, [3] = 12, [4] = 0.75 },
		["ChildWindowBg"] = { [1] = 0, [2] = 0, [3] = 0, [4] = 0 },
		["Border"] = { [1] = 0, [2] = 0, [3] = 0, [4] = 0 },
		["BorderShadow"] = { [1] = 0, [2] = 0, [3] = 0, [4] = 0 },
		["FrameBg"] = { [1] = 42, [2] = 31, [3] = 48, [4] = 0.85 },
		["FrameBgHovered"] = { [1] = 68, [2] = 54, [3] = 77, [4] = 0.90 },
		["FrameBgActive"] = { [1] = 179, [2] = 154, [3] = 195, [4] = 0.95 },
		["TitleBg"] = { [1] = 68, [2] = 54, [3] = 77, [4] = 0.90 },
		["TitleBgCollapsed"] = { [1] = 68, [2] = 54, [3] = 77, [4] = 0.90 },
		["TitleBgActive"] = { [1] = 42, [2] = 31, [3] = 48, [4] = 0.85 },
		["MenuBarBg"] = { [1] = 0, [2] = 0, [3] = 0, [4] = 0 },
		["ScrollbarBg"] = { [1] = 42, [2] = 31, [3] = 48, [4] = 0.85 },
		["ScrollbarGrab"] = { [1] = 68, [2] = 54, [3] = 77, [4] = 0.90 },
		["ScrollbarGrabHovered"] = { [1] = 68, [2] = 54, [3] = 77, [4] = 0.90 },
		["ScrollbarGrabActive"] = { [1] = 179, [2] = 154, [3] = 195, [4] = 0.95 },
		["ComboBg"] = { [1] = 0, [2] = 0, [3] = 0, [4] = 0 },
		["CheckMark"] = { [1] = 179, [2] = 154, [3] = 195, [4] = 0.95 },
		["SliderGrab"] = { [1] = 68, [2] = 54, [3] = 77, [4] = 0.90 },
		["SliderGrabActive"] = { [1] = 179, [2] = 154, [3] = 195, [4] = 0.95 },
		["Button"] = { [1] = 51, [2] = 0, [3] = 127, [4] = 0.75 },
		["ButtonHovered"] = { [1] = 42, [2] = 31, [3] = 48, [4] = 0.75 },
		["ButtonActive"] = { [1] = 84, [2] = 69, [3] = 95, [4] = 1.00 },
		["Header"] = { [1] = 0, [2] = 0, [3] = 0, [4] = 0 },
		["HeaderHovered"] = { [1] = 0, [2] = 0, [3] = 0, [4] = 0 },
		["HeaderActive"] = { [1] = 0, [2] = 0, [3] = 0, [4] = 0 },
		["Column"] = { [1] = 0, [2] = 0, [3] = 0, [4] = 0 },
		["ColumnHovered"] = { [1] = 0, [2] = 0, [3] = 0, [4] = 0 },
		["ColumnActive"] = { [1] = 0, [2] = 0, [3] = 0, [4] = 0 },
		["ResizeGrip"] = { [1] = 42, [2] = 31, [3] = 48, [4] = 0.75 },
		["ResizeGripHovered"] = { [1] = 68, [2] = 54, [3] = 77, [4] = 0.75 },
		["ResizeGripActive"] = { [1] = 84, [2] = 69, [3] = 95, [4] = 1.00 },
		["CloseButton"] = { [1] = 0, [2] = 0, [3] = 0, [4] = 0 },
		["CloseButtonHovered"] = { [1] = 0, [2] = 0, [3] = 0, [4] = 0 },
		["CloseButtonActive"] = { [1] = 0, [2] = 0, [3] = 0, [4] = 0 },
		["PlotLines"] = { [1] = 0, [2] = 0, [3] = 0, [4] = 0 },
		["PlotLinesHovered"] = { [1] = 0, [2] = 0, [3] = 0, [4] = 0 },
		["PlotHistogram"] = { [1] = 0, [2] = 0, [3] = 0, [4] = 0 },
		["PlotHistogramHovered"] = { [1] = 0, [2] = 0, [3] = 0, [4] = 0 },
		["TextSelectedBg"] = { [1] = 0, [2] = 0, [3] = 0, [4] = 0 },
		["TooltipBg"] = { [1] = 7, [2] = 0, [3] = 12, [4] = 0.9 },
		["ModalWindowDarkening"] = { [1] = 7, [2] = 0, [3] = 12, [4] = 0.75 },
		["NavHighlight"] = { [1] = 0, [2] = 0, [3] = 0, [4] = 0 },
		["NavWindowingHighlight"] = { [1] = 0, [2] = 0, [3] = 0, [4] = 0 },
		["DragDropTarget"] = { [1] = 0, [2] = 0, [3] = 0, [4] = 0 },
	},
	Links = {
		[1] = {
			name = "Minion Forums",
			icon = MinionPath .. [[\GUI\UI_Textures\minionblack.png]],
			link = [[http://www.mmominion.com/thread-21145.html]],
			tooltip = "Visit MMOMinion Forums to view this software's topic page.",
			lasthover = 0,
			size = { x = 25, y = 25}
		},
		[2] = {
			name = "Discord",
			icon = ImageFolder .. [[Discord.png]],
			link = [[https://discord.gg/SczhKhG]],
			link2 = [[https://discord.gg/uMYzdE9]],
			tooltip = "[Left Click] Visit Rikudou's Addon Discord for Moogle Telegraph related support and discussion.\n\n[Right Click] Visit my Discord for support, discussion, and other information about the modules I create.",
			lasthover = 0,
			size = { x = 25, y = 25}
		},
		[3] = {
			name = "GitHub",
			icon = ImageFolder .. [[GitHub.png]],
			link = [[https://github.com/KaliMinion/MoogleTelegraphs]],
			tooltip = "Visit my GitHub to view the source code for all of my projects.",
			lasthover = 0,
			size = { x = 25, y = 25}
		},
		[4] = {
			name = "Trello",
			icon = ImageFolder .. [[Trello.png]],
			link = [[https://trello.com/invite/b/UtTb43Is/e6ec13d1a11fe0176b6ea8950efb940c]],
			tooltip = "Visit the Moogle Telegraphs Trello page where you can make request or bug reports.",
			lasthover = 0,
			size = { x = 25, y = 25}
		},
		[5] = {
			name = "Ko-fi",
			icon = ImageFolder .. [[Ko-fi.png]],
			link = [[https://ko-fi.com/P5P1KKVD]],
			tooltip = "If you enjoy my content, please consider supporting what I do. Thank you!",
			lasthover = 0,
			size = { x = 25, y = 25}
		},
	}
}
local Gui = self.GUI
local WindowStyle = self.GUI.WindowStyle

local v = table.valid
function self.valid(...)
	local tbl = {...}
	local size = #tbl
	if size > 0 then
		local count = tbl[1]
		if type(count) == "number" then
			if size == (count + 1) then
				for i = 2, size do
					if not v(tbl[i]) then return false end
				end
				return true
			end
		else
			for i = 1, size do
				if not v(tbl[i]) then return false end
			end
			return true
		end
	end
	return false
end
local valid = self.valid

function self.Is(check,...)
	local tbl = {...}
	if valid(tbl) then
		local valid = false
		for i=1,#tbl do
			if check == tbl[i] then valid = true end
		end
		if valid then
			return true
		end
	end
	return false
end
local Is = self.Is

local contains = table.contains
function self.is(check,tbl)
	if valid(tbl) then
		if contains(tbl,check) then
			return true
		end
	end
	return false
end
local is = self.is

function self.LoadSettings()
	local tbl = FileLoad(ModuleSettings)
	local function scan(tbl,tbl2,depth)
		depth = depth or 0
		if valid(2,tbl,tbl2) then
			for k,v in pairs(tbl2) do
				if type(v) == "table" then
					if tbl[k] and valid(tbl[k]) then
						tbl[k] = table.merge(tbl[k],scan(tbl[k],v,depth+1))
					else
						tbl[k] = v
					end
				else
					if tbl[k] ~= tbl2[k] then tbl[k] = tbl2[k] end
				end
			end
		end
		return tbl
	end
	self.Settings = scan(self.Settings,tbl)
end
local LoadSettings = self.LoadSettings

local PreviousSave,lastcheck = {},0
function self.save(force)
	if (force or TimeSince(lastcheck) > 30000) then
		lastcheck = Now()
		if not table.deepcompare(self.Settings,PreviousSave) then
			FileSave(ModuleSettings,self.Settings)
			PreviousSave = table.deepcopy(self.Settings)
		end
	end
end
local save = self.save

function self.Initialize()
	self.GUI.main_tabs = GUI_CreateTabs("Telegraphs,Markers,Extras,Debug")
	local Settings = self.Settings
	local ModuleTable = self.GUI
	local MainIcon = ImageFolder .. [[MoogleStuff.png]]
	local MenuType = Settings.MainMenuType
	local ModuleIcon = ImageFolder .. ModuleTable.name .. [[.png]]

	-- Create the Main Menu entry if it hasn't been created yet --
	if not Settings.MainMenuEntryCreated then
		local ImGUIIcon = GetStartupPath() .. "\\GUI\\UI_Textures\\ImGUI.png"
		local MetricsIcon = GetStartupPath() .. "\\GUI\\UI_Textures\\Metrics.png"
		local ImGUIToolTip = "ImGUI Demo is an overview of what's possible with the UI."
		local MetricsToolTip = "ImGUI Metrics shows every window's rendering information, visible or hidden."

		if MenuType == 1 then
			-- No Main Menu Entry --
			-- Adding the ImGUI Test Window as a Minion Menu entry
			ml_gui.ui_mgr:AddMember({ id = "ImGUIDemo", name = "ImGUI Demo", onClick = function() ml_gui.showtestwindow = true end, tooltip = ImGUIToolTip, texture = ImGUIIcon }, "FFXIVMINION##MENU_HEADER")
			-- Adding the ImGUI Test Window as a Minion Menu entry
			ml_gui.ui_mgr:AddMember({ id = "ImGUIMetrics", name = "ImGUIMetrics", onClick = function() ml_gui.showmetricswindow = true end, tooltip = MetricsToolTip, texture = MetricsIcon }, "FFXIVMINION##MENU_HEADER")
		elseif MenuType == 2 then
			local members,new = ml_gui.ui_mgr.menu.components[2].members,true
			for i=1,#members do if members[i].name == "MoogleStuff" then new = false end end
			if new then
				-- Expansion Submenu inside of Main Menu --
				ml_gui.ui_mgr:AddMember({ id = [[MOOGLESTUFF##MENU_HEADER]], name = "MoogleStuff", texture = MainIcon }, "FFXIVMINION##MENU_HEADER")
				-- Adding the ImGUI Test Window as a Minion Menu entry
				ml_gui.ui_mgr:AddSubMember({ id = "ImGUIDemo", name = "ImGUI Demo", onClick = function() ml_gui.showtestwindow = not ml_gui.showtestwindow end, tooltip = ImGUIToolTip, texture = ImGUIIcon }, "FFXIVMINION##MENU_HEADER", "MOOGLESTUFF##MENU_HEADER")
				-- Adding the ImGUI Test Window as a Minion Menu entry
				ml_gui.ui_mgr:AddSubMember({ id = "ImGUIMetrics", name = "ImGUIMetrics", onClick = function() ml_gui.showmetricswindow = not ml_gui.showmetricswindow end, tooltip = MetricsToolTip, texture = MetricsIcon }, "FFXIVMINION##MENU_HEADER", "MOOGLESTUFF##MENU_HEADER")
			end
		elseif MenuType == 3 then
			local components,new = ml_gui.ui_mgr.menu.components,true
			for i=1,#components do if components[i].name == "MoogleStuff" then new = false end end
			if new then
				-- New Component Header that branches off to the right --
				ml_gui.ui_mgr:AddComponent({ header = { id = [[MOOGLESTUFF##MENU_HEADER]], expanded = false, name = "MoogleStuff", texture = MainIcon }, members = {} })
				-- Adding the ImGUI Test Window as a Minion Menu entry
				ml_gui.ui_mgr:AddMember({ id = "ImGUIDemo", name = "ImGUI Demo", onClick = function() ml_gui.showtestwindow = true end, tooltip = ImGUIToolTip, texture = ImGUIIcon }, "MOOGLESTUFF##MENU_HEADER")
				-- Adding the ImGUI Test Window as a Minion Menu entry
				ml_gui.ui_mgr:AddMember({ id = "ImGUIMetrics", name = "ImGUIMetrics", onClick = function() ml_gui.showmetricswindow = true end, tooltip = MetricsToolTip, texture = MetricsIcon }, "MOOGLESTUFF##MENU_HEADER")
			end
		end
		Settings.MainMenuEntryCreated = true
	end

	-- Creating Module Entry --
	if MenuType == 1 then
		ml_gui.ui_mgr:AddMember({ id = selfshort, name = selfshort, onClick = function() ModuleTable.OnClick() end, tooltip = ModuleTable.ToolTip, texture = ModuleIcon }, "FFXIVMINION##MENU_HEADER")
	elseif MenuType == 2 then
		ml_gui.ui_mgr:AddSubMember({ id = selfshort, name = selfshort, onClick = function() ModuleTable.OnClick() end, tooltip = ModuleTable.ToolTip, texture = ModuleIcon }, "FFXIVMINION##MENU_HEADER", "MOOGLESTUFF##MENU_HEADER")
	elseif MenuType == 3 then
		ml_gui.ui_mgr:AddMember({ id = selfshort, name = selfshort, onClick = function() ModuleTable.OnClick() end, tooltip = ModuleTable.ToolTip, texture = ModuleIcon }, "MOOGLESTUFF##MENU_HEADER")
	end

	-- Mini Button --
	if ModuleTable.MiniButton then
		local MiniNameStr = selfshort
		table.insert(ml_global_information.menu.windows, { name = MiniNameStr, openWindow = function() ModuleTable.OnClick() end, isOpen = function() return ModuleTable.IsOpen() end })
	end

	--local ActionInfo = ModulePath.."ActionInfo.lua"
	--if FileExists(ActionInfo) then
	--    self.Data.ActionInfo = FileLoad(ActionInfo)
	--	local nameOmens = self.Data.ActionNameOmens
	--	local actionInfo = self.Data.ActionInfo
	--	for k,v in pairs(actionInfo) do
	--		if v[1] ~= 0 then
	--			if not nameOmens[v[11]] then nameOmens[v[11]] = {} end
	--			local omen = self.Data.Omen[v[1]]
	--			if not nameOmens[v[11]][omen] then nameOmens[v[11]][omen] = true end
	--		end
	--	end
	--end

	return Settings.MainMenuEntryCreated
end

function self.GameState()
	if MGetGameState() == FFXIV.GAMESTATE.INGAME then
		return true
	end
	return false
end
local GameState = self.GameState

local function Sign(value)
	return (value >= 0 and 1) or -1
end

local function Round(value, bracket)
	bracket = bracket or 1
	local floor = math.floor
	return floor(value / bracket + Sign(value) * 0.5) * bracket
end

function self.Distance3D(pos,pos2,IgnoreRadius)
	if valid(2,pos,pos2) then
		if IgnoreRadius or not pos.pos or not pos2.pos then
			if valid(pos.pos) then pos = pos.pos end
			if valid(pos2.pos) then pos2 = pos2.pos end
			return math.sqrt( math.pow(( pos2.x - pos.x ),2 ) + math.pow(( pos2.y - pos.y ),2 ) + math.pow(( pos2.z - pos.z ),2 ))
		else
			local pos,pos2,radius,radius2 = pos.pos or pos, pos2.pos or pos2, pos.hitradius or 0.5, pos2.hitradius or 0.5
			return math.sqrt( math.pow(( pos2.x - pos.x ),2 ) + math.pow(( pos2.y - pos.y ),2 ) + math.pow(( pos2.z - pos.z ),2 )) - (radius + radius2)
		end
	end
end
local Distance3D = self.Distance3D

function self.IsFriend(entity)
	if valid(entity) then
		if entity.targetable and not entity.attackable then return true end
	end
	return false
end
local IsFriend = self.IsFriend

function self.WriteOutput(tbl)
	FileWrite(DebugOutput, tostring(tbl), true)
end
local WriteOutput = self.WriteOutput

function self.DebugRecord(aoe,aoeType,entity,Note)
	if self.Settings.DebugRecord then
		local ID = aoe.aoeID
		local tbl = self.Data.DebugRecordings[aoeType]
		if not tbl[ID] then
			tbl[ID] = aoe
			local t,ActionInfo = tbl[ID],self.Data.ActionInfo
			t.Time = os.date("%X")
			if valid(entity) then
				t.EntityName = entity.name
				t.EntityContentID = entity.contentid
				t.EntityFriendly = entity.friendly
				t.EntityAttackable = entity.attackable
				t.EntityTargetable = entity.targetable
				t.EntityHeading = entity.pos.hn
			end
			if valid(ActionInfo) then
				local info = ActionInfo[ID]
				if valid(info) then
					-- omen = info[1]
					t.VFXTargetID = info[2]
					t.AnimationStartTargetID = info[3]
					t.AnimationEndTargetID = info[4]
					t.ActionTimelineHitTargetID = info[5]
					t.AffectsPosition = info[6]
					t.CanTargetSelf = info[7]
					t.CanTargetHostile = info[8]
					t.CanTargetFriendly = info[9]
					t.TargetArea = info[10]
					-- name = info[11]
				end
			end
			t.EntityNotes = Note
			t.OmenID = t.aoeType
			t.OmenStr = Data.Omen[t.aoeType or 0]
			t.map = "["..Player.localmapid.."] "..GetMapName(Player.localmapid)
			WriteOutput(t)
			d("[MoogleTelegraphs] Added ["..ID.."] "..aoe.aoeName..", "..tostring(Note))
		end
	end
end
local DebugRecord = self.DebugRecord

function self.fill(fillCount,maxFillCount,size,channeltime,casttime)
	if maxFillCount == 0 or fillCount <= maxFillCount then
		return size.min+((size.max-size.min)*(channeltime/casttime))
	end
end
local fill = self.fill

function self.DrawCone(aoe,extra,angle)
	local Radius = aoe.aoeRadius or aoe.aoeLength
	local Segments = (function() local seg = ((Radius * 2) * math.pi) / extra.verticesSpacing if seg <= extra.maxSegments then return seg else return extra.maxSegments end end)()
	local fill,pos = fill(extra.fillCount,extra.maxFillCount,(function() if Radius < extra.largeAoE then return extra.small else return extra.large end end)(),extra.channeltime,extra.casttime), extra.pos
	Argus.addConeFilled(pos.x, pos.y, pos.z, Radius, math.rad(angle), pos.h, Segments,
			extra.friendly and GUI:ColorConvertFloat4ToU32(extra.friendFill.r, extra.friendFill.g, extra.friendFill.b, 1) or
					GUI:ColorConvertFloat4ToU32(extra.enemyFill.r, extra.enemyFill.g, extra.enemyFill.b, fill),
			extra.friendly and GUI:ColorConvertFloat4ToU32(extra.outlineFriend.r, extra.outlineFriend.g, extra.outlineFriend.b, extra.outlineFriend.a) or
					GUI:ColorConvertFloat4ToU32(extra.outlineEnemy.r, extra.outlineEnemy.g, extra.outlineEnemy.b, extra.outlineEnemy.a),
			extra.friendly and extra.outlineThicknessFriend or extra.outlineThicknessEnemy)
end
local DrawCone = self.DrawCone

function self.DrawDonut(aoe,extra,radiusInner)
	local Radius = aoe.aoeRadius or aoe.aoeLength
	local Segments = (function() local seg = ((Radius * 2) * math.pi) / extra.verticesSpacing if seg <= extra.maxSegments then return seg else return extra.maxSegments end end)()
	local fill,pos = fill(extra.fillCount,extra.maxFillCount,(function() if Radius < extra.largeAoE then return extra.small else return extra.large end end)(),extra.channeltime,extra.casttime), extra.pos
	Argus.addDonutFilled(pos.x, pos.y, pos.z, radiusInner or extra.hitradius, Radius, Segments,
			extra.friendly and GUI:ColorConvertFloat4ToU32(extra.friendFill.r, extra.friendFill.g, extra.friendFill.b, fill) or
					GUI:ColorConvertFloat4ToU32(extra.enemyFill.r, extra.enemyFill.g, extra.enemyFill.b, fill),
			extra.friendly and GUI:ColorConvertFloat4ToU32(extra.outlineFriend.r, extra.outlineFriend.g, extra.outlineFriend.b, extra.outlineFriend.a) or
					GUI:ColorConvertFloat4ToU32(extra.outlineEnemy.r, extra.outlineEnemy.g, extra.outlineEnemy.b, extra.outlineEnemy.a),
			extra.friendly and extra.outlineThicknessFriend or extra.outlineThicknessEnemy)
end
local DrawDonut = self.DrawDonut

function self.DrawCircle(aoe,extra)
	local Radius = aoe.aoeRadius or aoe.aoeLength
	local Segments = (function() local seg = ((Radius * 2) * math.pi) / extra.verticesSpacing if seg <= extra.maxSegments then return seg else return extra.maxSegments end end)()
	local fill,pos = fill(extra.fillCount,extra.maxFillCount,(function() if Radius < extra.largeAoE then return extra.small else return extra.large end end)(),extra.channeltime,extra.casttime), extra.pos
	Argus.addCircleFilled(pos.x, pos.y, pos.z, Radius, Segments,
			extra.isHealing and GUI:ColorConvertFloat4ToU32(extra.healingFill.r, extra.healingFill.g, extra.healingFill.b, fill) or
				extra.friendly and GUI:ColorConvertFloat4ToU32(extra.friendFill.r, extra.friendFill.g, extra.friendFill.b, fill) or
				GUI:ColorConvertFloat4ToU32(extra.enemyFill.r, extra.enemyFill.g, extra.enemyFill.b, fill),
			extra.isHealing and GUI:ColorConvertFloat4ToU32(extra.outlineHealing.r, extra.outlineHealing.g, extra.outlineHealing.b, extra.outlineHealing.a) or
				extra.friendly and GUI:ColorConvertFloat4ToU32(extra.outlineFriend.r, extra.outlineFriend.g, extra.outlineFriend.b, extra.outlineFriend.a) or
				GUI:ColorConvertFloat4ToU32(extra.outlineEnemy.r, extra.outlineEnemy.g, extra.outlineEnemy.b, extra.outlineEnemy.a),
			extra.friendly and extra.outlineThicknessFriend or extra.outlineThicknessEnemy)
end
local DrawCircle = self.DrawCircle

function self.DrawRect(aoe,extra)
	local fill = fill(extra.fillCount,extra.maxFillCount,(function() if aoe.aoeWidth < extra.largeAoE then return extra.small else return extra.large end end)(),extra.channeltime,extra.casttime)
	local pos = extra.pos
	Argus.addRectFilled(pos.x, pos.y, pos.z, aoe.aoeLength, aoe.aoeWidth, pos.h,
			extra.friendly and GUI:ColorConvertFloat4ToU32(extra.friendFill.r, extra.friendFill.g, extra.friendFill.b, fill) or
					GUI:ColorConvertFloat4ToU32(extra.enemyFill.r, extra.enemyFill.g, extra.enemyFill.b, fill),
			extra.friendly and GUI:ColorConvertFloat4ToU32(extra.outlineFriend.r, extra.outlineFriend.g, extra.outlineFriend.b, extra.outlineFriend.a) or
					GUI:ColorConvertFloat4ToU32(extra.outlineEnemy.r, extra.outlineEnemy.g, extra.outlineEnemy.b, extra.outlineEnemy.a),
			extra.friendly and extra.outlineThicknessFriend or extra.outlineThicknessEnemy)

end
local DrawRect = self.DrawRect

function self.DrawCross(aoe,extra)
	local fill,pos = fill(extra.fillCount,extra.maxFillCount,(function() if aoe.aoeWidth < extra.largeAoE then return extra.small else return extra.large end end)(),extra.channeltime,extra.casttime), extra.pos
	Argus.addDonutFilled(pos.x, pos.y, pos.z, aoe.aoeLength, aoe.aoeWidth, pos.h,
			extra.friendly and GUI:ColorConvertFloat4ToU32(extra.friendFill.r, extra.friendFill.g, extra.friendFill.b, fill) or
					GUI:ColorConvertFloat4ToU32(extra.enemyFill.r, extra.enemyFill.g, extra.enemyFill.b, fill),
			extra.friendly and GUI:ColorConvertFloat4ToU32(extra.outlineFriend.r, extra.outlineFriend.g, extra.outlineFriend.b, extra.outlineFriend.a) or
					GUI:ColorConvertFloat4ToU32(extra.outlineEnemy.r, extra.outlineEnemy.g, extra.outlineEnemy.b, extra.outlineEnemy.a),
			extra.friendly and extra.outlineThicknessFriend or extra.outlineThicknessEnemy)
end
local DrawCross = self.DrawCross


local valid = table.valid
function self.Update()
	local Data,Settings,Override = self.Data,self.Settings,self.Override
	if Data.loaded then
		local p,aoes = Player, { Ground = Argus.getCurrentGroundAOEs(), Directional = Argus.getCurrentDirectionalAOEs() }
		local DrawHealing,DrawFriendly,DrawLB = Settings.DrawHealingAoE,Settings.DrawFriendlyAoE,Settings.DrawFriendlyLB
		local alphafill,fillRGB,largeAoE,maxSegments,outlineRGB,outlineThickness,UnknownConeAngle,UnknownDonutRadius = Settings.alphafill,Settings.fillRGB,Settings.largeAoE,Settings.maxSegments,Settings.outlineRGB,Settings.outlineThickness,Settings.UnknownConeAngle,Settings.UnknownDonutRadius
		local smallEnemy,largeEnemy,smallHealing,largeHealing,smallFriend,largeFriend,enemyFill,healingFill,friendFill,outlineEnemy,outlineHealing,outlineFriend,outlineThicknessEnemy,outlineThicknessHealing,outlineThicknessFriend = alphafill.enemy.small,alphafill.enemy.large,alphafill.healing.small,alphafill.healing.large,alphafill.friend.small,alphafill.friend.large,fillRGB.enemy,fillRGB.healing,fillRGB.friend,outlineRGB.enemy,outlineRGB.healing,outlineRGB.friend,outlineThickness.enemy,outlineThickness.healing,outlineThickness.friend
		local fillCount,maxFillCount = 0,Settings.MaxTelegraphsFilled
		for source,tbl in pairs(aoes) do
			if valid(tbl) then for id,aoe in pairs(tbl) do
				local aoeID,mapID = aoe.aoeID, p.localmapid; local userBL,reactionBL = Settings.aoeIDUserBlacklist[aoeID],Data.aoeIDReactionBlacklist[aoeID] or {}
				if not userBL and not reactionBL[mapID] then
					local pos,ppos,maxDrawRange = {x = aoe.x, y = aoe.y, z = aoe.z, h = aoe.heading}, p.pos, Settings.MaxTelegraphDrawRange; local diff,sync = pos.y - ppos.y,Settings.syncVerticalPosHeight
					if InInstance() then -- TODO: If telegraph raycasting gets supported, this can go away.
						if diff >= 0 then if diff <= sync.near then pos.y = ppos.y
						elseif diff >= sync.above then pos.y = ppos.y end
						elseif diff < sync.below then pos.y = ppos.y end
					end
					if maxDrawRange == 0 or Distance3D(pos,ppos) <= maxDrawRange then
						if not Override[aoeID] then
							local entity = EntityList:Get(id)
							local friendly,cinfo,hitradius = (function() if valid(entity) then return IsFriend(entity) or false, entity.castinginfo, (function() local hitradius = entity.hitradius if hitradius < 1.5 then
								local el = EntityList("name="..tostring(entity.name))
								if valid(el) then for _,e in pairs(el) do
									local hitrad = e.hitradius
									if hitrad > hitradius then hitradius = hitrad end
								end end
							end return hitradius end)() else return false,false,0 end end)()
							if (not friendly or (DrawHealing or DrawFriendly)) and (not Data.LB[aoeID] or DrawLB) then -- TODO: add logic to not draw if within range if healing or friendly

								local pass = true
								local small,large,isHealing
								if friendly and (DrawHealing or DrawFriendly) then
									if DrawHealing and table.contains(Settings.HealingAoeActions,aoeID) then
										local party = MEntityList("myparty")
										if id == p.id or (valid(party) and party[id]) then
											if id == p.id then
												if Settings.DrawHealingOutlineIfHealer then
													small,large = {min=0,max=0},{min=0,max=0}
													isHealing = true
												else pass = false end
											elseif (Distance3D(pos,ppos) + p.hitradius) > (aoe.aoeRadius or aoe.aoeLength) then
												if Settings.DrawHealingOutOfRange then
													small,large = alphafill.healing.small,alphafill.healing.large
													isHealing = true
												else pass = false end
											elseif Settings.DrawHealingCirclesOutline then
												small,large = {min=0,max=0},{min=0,max=0}
												isHealing = true
											else pass = false end
										else pass = false end
									elseif not table.contains(Settings.HealingAoeActions,aoeID) then
										if table.contains(Data.LB,aoeID) then
											if Settings.DrawFriendlyLB then
												small,large = alphafill.friend.small,alphafill.friend.large
											else pass = false end
										else
											small,large = alphafill.friend.small,alphafill.friend.large
										end
									else
										pass = false
									end
								else
									small,large = alphafill.enemy.small,alphafill.enemy.large
								end

								if pass then
									local casttime,channeltime,channeltargetid = (function() if valid(cinfo) then return cinfo.casttime,cinfo.channeltime,cinfo.channeltargetid else return 0,0,0 end end)()
									local aoeCastType,Omen,Width,extra = aoe.aoeCastType, aoe.aoeEffectInfo.aoeEffectName, tonumber(aoe.aoeWidth), { entity = entity, pos = pos, friendly = friendly, isHealing = isHealing, small = small, large = large, largeAoE = Settings.largeAoE, hitradius = hitradius, fillCount = fillCount, maxFillCount = maxFillCount, verticesSpacing = Settings.verticesSpacing, maxSegments = Settings.maxSegments, casttime = casttime, channeltime = channeltime, channeltargetid = channeltargetid, smallEnemy = smallEnemy, largeEnemy = largeEnemy, smallHealing = smallHealing, largeHealing = largeHealing, smallFriend = smallFriend, largeFriend = largeFriend, enemyFill = enemyFill, healingFill = healingFill, friendFill = friendFill, outlineEnemy = outlineEnemy, outlineHealing = outlineHealing, outlineFriend = outlineFriend, outlineThicknessEnemy = outlineThicknessEnemy, outlineThicknessHealing = outlineThicknessHealing, outlineThicknessFriend = outlineThicknessFriend }
									if Width > 0 then
										if aoeCastType == 11 then -- Cross
											DrawCross( aoe, extra ) fillCount = fillCount + 1
										else -- Line
											DrawRect( aoe, extra ) fillCount = fillCount + 1
										end
									else
										local OmenInfo = Omen:gsub("o",""):sub(6,-1):match("%D(%d+)%D") or ""
										if #OmenInfo == 4 or Omen:sub(6,-1):match("don") or Omen:sub(6,-1):match("sircle") or aoeCastType == 10 then -- Donut
											DrawDonut(aoe, extra, tonumber(OmenInfo:sub(-2)) or 0 ) fillCount = fillCount + 1
										elseif #OmenInfo == 3 or Omen:sub(6,-1):match("fan") or is(aoeCastType,{3,13}) then -- Cone
											DrawCone(aoe, extra, (function() if (tonumber(OmenInfo) or 0) > 0 then return tonumber(OmenInfo) else return UnknownConeAngle end end)() ) fillCount = fillCount + 1
										else
											DrawCircle( aoe, extra ) fillCount = fillCount + 1
										end
									end
								end
							end
						else
							Override[aoeID]() -- TODO: Override Logic
						end
					end
				end
			end end
		end
		if self.GUI.open ~= Settings.open then Settings.open = self.GUI.open end save()
	elseif not FolderExists(ModulePath) then
		-- Changing ModulePath to the current directory, in case the user renamed the folder --
		local lastclip = ""
		lastclip = GUI:GetClipboardText()
		GUI:SetClipboardText(tostring(self))
		local str = GUI:GetClipboardText()
		GUI:SetClipboardText(lastclip)

		for w in str:gmatch("function: .-lua") do
			local dir = w:sub(11,-#(selfslong..".lua ")) d(dir)
			if FolderExists(dir) then
				ModulePath = dir
				ModuleSettings = dir .. [[Settings.lua]]
				DebugOutput = dir .. [[DebugOutput.lua]]
				ImageFolder = dir .. [[Images\]]
				break
			end
		end
		-- Changing ModulePath to the current directory, in case the user renamed the folder --
	else
		LoadSettings()
		self.GUI.open = Settings.open
		Data.loaded = true
	end
	if #Data.DebugLog > Settings.DebugLogLimit then table.remove(Data.DebugLog,1) end
end

Argus.registerOnEntityCast(function(entityID, actionID)
	local entity = EntityList:Get(entityID)
	if valid(entity) and entity.chartype ~= 4 and entity.chartype ~= 2 then
		local action,name,heading,cinfo = ActionList:Get(1,actionID),entity.name or "", entity.pos.h or 0,entity.castinginfo
		local Name,Range,Radius,AttackType,targets,targetstr = action.name or "",action.range or "",action.radius or "",action.attacktype or "",cinfo.castingtargets,""
		if valid(targets) then for _,target in pairs(targets) do
			targetstr = targetstr..tostring(EntityList:Get(target).name)..","
		end end
		table.insert(self.Data.DebugLog,{
			line = (function() if self.Settings.DebugLog12Hour then return "["..os.date("%I:%M:%S %p").."] " else return "["..os.date("%H:%M:%S").."] " end end)().."Casting: ["..entityID.."] "..name.." - "..Name.."["..actionID.."] on ["..tostring(targetstr).."] (Range: "..Range..", Radius: "..Radius..", Attack Type: "..AttackType..", Heading: "..heading..")",
			type = 1
		})
 end end)

Argus.registerOnEntityChannel(function(entityID, channelID, targetID, channelTimeMax)
	local entity,target = EntityList:Get(entityID),EntityList:Get(targetID)
	if valid(entity) and entity.chartype ~= 4 and entity.chartype ~= 2 then
		local action,name,heading = ActionList:Get(1,channelID),entity.name or "", entity.pos.h or 0
		local Name,Range,Radius,AttackType = action.name or "",action.range or "",action.radius or "",action.attacktype or ""
		local targetName = (function() if valid(target) then return target.name else return targetID end end)()
		table.insert(self.Data.DebugLog,{
			line = (function() if self.Settings.DebugLog12Hour then return "["..os.date("%I:%M:%S %p").."] " else return "["..os.date("%H:%M:%S").."] " end end)().."Channeling: ["..entityID.."] "..name.." - "..Name.."["..channelID.."] on ["..targetName.."] (Range: "..Range..", Radius: "..Radius..", Attack Type: "..AttackType..", Heading: "..heading..")",
			type = 2
		})
end end)

Argus.registerOnMarkerAdd(function(entityID, markerType)
	local entity = EntityList:Get(entityID)
	if valid(entity) then
		table.insert(self.Data.DebugLog,{
			line = (function() if self.Settings.DebugLog12Hour then return "["..os.date("%I:%M:%S %p").."] " else return "["..os.date("%H:%M:%S").."] " end end)().."Marker: ["..entityID.."] "..entity.name..", marked with: ["..markerType.."] "..tostring(self.Data.HeadMarker[markerType]),
			type = 3
		})
end end)

local function unpack(tbl)
	local str = ""
	for i=1,#tbl do
		str = str..tbl[i]
		if i ~= #tbl then str = str.."," end
	end
	return str
end
local StringTableCache = {}
local expandedTreeNodes = {}

function self.Draw()
	local p,Settings,Data,Style = Player,self.Settings,self.Data,GUI:GetStyle()
	local windowPadding = Style.windowpadding
	local winX,winY,posX,posY
	if self.GUI.open then
		local c = 0
		GUI:SetNextWindowSize(530,175,GUI.SetCond_FirstUseEver)
		GUI:SetNextWindowPosCenter(GUI.SetCond_FirstUseEver)
		for k,v in pairs(WindowStyle) do if v[4] ~= 0 then c = c + 1 loadstring([[GUI:PushStyleColor(GUI.Col_]]..k..[[, ]]..(v[1]/255)..[[, ]]..(v[2]/255)..[[, ]]..(v[3]/255)..[[, ]]..v[4]..[[)]])() end end
		self.GUI.visible, self.GUI.open = GUI:Begin(self.GUI.name, self.GUI.open)
		if self.GUI.visible then
			local tabindex, tabname = GUI_DrawTabs(self.GUI.main_tabs)
			if (tabname == GetString("Telegraphs")) then
				Settings.enable = GUI:Checkbox("Enable / Disable",Settings.enable) GUI:SameLine(0,25)

				local hovered = false
				GUI:Text("Draw Range: ") if not hovered then hovered = GUI:IsItemHovered() end
				GUI:SameLine(0,0) GUI:PushItemWidth(60)
				local val,changed = GUI:SliderInt("##MaxTelegraphDrawRange",Settings.MaxTelegraphDrawRange,0,100)
				if changed then
					Settings.MaxTelegraphDrawRange = val save(true)
				end GUI:PopItemWidth()
				if not hovered then hovered = GUI:IsItemHovered() end
				if hovered then
					GUI:BeginTooltip()
					GUI:PushTextWrapPos(300)
					GUI:Text("If you suspect that the draw distance of telegraphs is affecting system performance, you can try changing this value to set the max distance. Keep in mind, if you set this value too low won't be very accurate.\n")
					GUI:TextColored(1,1,0,1,"Leave this set to 0 for unlimited draw distance.\n[CTRL]+[Left Mouse Button] to manually type in amount instead of dragging.")
					GUI:PopTextWrapPos()
					GUI:EndTooltip()
				end GUI:SameLine(0,25)

				local hovered = false
				GUI:Text("Max Filled Draws: ") if not hovered then hovered = GUI:IsItemHovered() end
				GUI:SameLine(0,0) GUI:PushItemWidth(60)
				local val,changed = GUI:SliderInt("##MaxTelegraphsFilled",Settings.MaxTelegraphsFilled,0,25)
				if changed then
					Settings.MaxTelegraphsFilled = val save(true)
				end GUI:PopItemWidth()
				if not hovered then hovered = GUI:IsItemHovered() end
				if hovered then
					GUI:BeginTooltip()
					GUI:PushTextWrapPos(300)
					GUI:Text("Having multiple filled in active telegraphs can impact system performance, depending on your system. You can prevent telegraphs from filling in after a certain amount are already active to free up resources.\n")
					GUI:TextColored(1,1,0,1,"Leave this set to 0 for unlimited filled telegraphs.\n[CTRL]+[Left Mouse Button] to manually type in amount instead of dragging.")
					GUI:PopTextWrapPos()
					GUI:EndTooltip()
				end

				Settings.DrawPlayerDot = GUI:Checkbox("Draw Player Dot",Settings.DrawPlayerDot)
				GUI:SameLine(0,11)
				local dot = Settings.DotRGB
				GUI:ColorEditMode(GUI.ColorEditMode_NoInputs + GUI.ColorEditMode_AlphaBar)
				local r,g,b,a,changed = GUI:ColorEdit4("##PlayerDotColorTelegraphs",dot.r, dot.g, dot.b, dot.a)
				if (changed) then
					Settings.DotRGB = {r=r,g=g,b=b,a=a}
					Settings.DotDotU32 = GUI:ColorConvertFloat4ToU32(r,g,b,a) save(true)
				end
				GUI:SameLine(0,10)
				GUI:PushItemWidth(50)
				Settings.DotSize = GUI:SliderInt("Dot Size",Settings.DotSize,1,10)
				GUI:PopItemWidth()
				--GUI:Indent()
				GUI:SameLine(0,15)
				Settings.DrawDotCombatOnly = GUI:Checkbox("Combat Only",Settings.DrawDotCombatOnly)
				GUI:SameLine(0,5)
				Settings.DrawDotInstanceOnly = GUI:Checkbox("Instance Only",Settings.DrawDotInstanceOnly)
				--GUI:Unindent()

				local str = "Color Settings:"
				local strX,strY = GUI:CalcTextSize(str)
				GUI:BeginChild(str.."#Telegraphs", strX + (windowPadding.x * 2) , GUI:GetFrameHeight() + (windowPadding.y * 2),true, GUI.WindowFlags_NoTitleBar + GUI.WindowFlags_NoResize + GUI.WindowFlags_NoMove + GUI.WindowFlags_NoScrollbar + GUI.WindowFlags_NoScrollWithMouse + GUI.WindowFlags_NoCollapse + GUI.WindowFlags_NoSavedSettings)
				GUI:AlignFirstTextHeightToWidgets()
				GUI:Text(str)
				GUI:EndChild() GUI:SameLine(0,0)
				GUI:BeginChild("##ColorSettingsTelegraphs",-1, GUI:GetFrameHeight() + (windowPadding.y * 2), true, GUI.WindowFlags_NoTitleBar + GUI.WindowFlags_NoResize + GUI.WindowFlags_NoMove + GUI.WindowFlags_NoScrollbar + GUI.WindowFlags_NoScrollWithMouse + GUI.WindowFlags_NoCollapse + GUI.WindowFlags_NoSavedSettings) GUI:SameLine(0,10)
				local alphafill,fillRGB,outlineRGB,outlineThickness = Settings.alphafill,Settings.fillRGB,Settings.outlineRGB,Settings.outlineThickness
				local smallEnemy,largeEnemy,smallHealing,largeHealing,smallFriend,largeFriend,enemyFill,healingFill,friendFill,outlineEnemy,outlineHealing,outlineFriend,outlineRangeInside,outlineRangeOutside,outlineThicknessEnemy,outlineThicknessHealing,outlineThicknessFriend,outlineThicknessRange = alphafill.enemy.small,alphafill.enemy.large,alphafill.healing.small,alphafill.healing.large,alphafill.friend.small,alphafill.friend.large,fillRGB.enemy,fillRGB.healing,fillRGB.friend,outlineRGB.enemy,outlineRGB.healing,outlineRGB.friend,outlineRGB.rangeInside,outlineRGB.rangeOutside,outlineThickness.enemy,outlineThickness.healing,outlineThickness.friend,outlineThickness.range
				GUI:ColorButton("Enemy Color", enemyFill.r, enemyFill.g, enemyFill.b, 1, 0, GUI:GetFrameHeight(), GUI:GetFrameHeight())
				if GUI:IsItemClicked(0) then
					GUI:OpenPopup("Enemy Color Editor")
				end
				if GUI:BeginPopup("Enemy Color Editor", GUI.WindowFlags_NoTitleBar + GUI.WindowFlags_NoResize + GUI.WindowFlags_NoMove + GUI.WindowFlags_NoScrollbar + GUI.WindowFlags_NoScrollWithMouse + GUI.WindowFlags_NoCollapse + GUI.WindowFlags_NoSavedSettings) then
					GUI:ColorEditMode(GUI.ColorEditMode_NoInputs + GUI.ColorEditMode_NoAlpha)
					local r,g,b,changed = GUI:ColorEdit3("Enemy Color##EnemyColorTelegraphs",enemyFill.r, enemyFill.g, enemyFill.b)
					if (changed) then
						self.Data.lastColorChange = Now()
						self.Data.lastColorRGB = {r=r,g=g,b=b}
						self.Data.lastLineRGB = Settings.outlineRGB.enemy
						Settings.fillRGB.enemy = {r=r,g=g,b=b}
						self.Data.lastColorAlpha = Settings.alphafill.enemy.small.max save(true)
					end
					if GUI:IsItemClicked() then
						self.Data.lastColorChange = Now()
						self.Data.lastColorRGB = {r=r,g=g,b=b}
						self.Data.lastLineRGB = Settings.outlineRGB.enemy
						self.Data.lastColorAlpha = Settings.alphafill.enemy.small.max
					end GUI:SameLine(0,15)
					GUI:ColorEditMode(GUI.ColorEditMode_NoInputs + GUI.ColorEditMode_AlphaBar)
					local r2,g2,b2,a2,changed2 = GUI:ColorEdit4("Outline Color##EnemyColorTelegraphs",outlineEnemy.r, outlineEnemy.g, outlineEnemy.b, outlineEnemy.a)
					if (changed2) then
						self.Data.lastColorChange = Now()
						self.Data.lastColorRGB = {r=r,g=g,b=b}
						self.Data.lastLineRGB = {r=r2,g=g2,b=b2,a=a2}
						Settings.outlineRGB.enemy = {r=r2,g=g2,b=b2,a=a2}
						self.Data.lastColorAlpha = Settings.alphafill.enemy.small.max save(true)
					end
					if GUI:IsItemClicked() then
						self.Data.lastColorChange = Now()
						self.Data.lastColorRGB = {r=r,g=g,b=b}
						self.Data.lastLineRGB = {r=r2,g=g2,b=b2,a=a2}
						self.Data.lastColorAlpha = Settings.alphafill.enemy.small.max
					end GUI:SameLine(0,15)
					GUI:Text("Line Size: ") GUI:SameLine(0,0) GUI:PushItemWidth(-1)
					local val,changed = GUI:SliderInt("##OutlineThicknessEnemy",outlineThicknessEnemy,1,10)
					if changed then
						self.Data.lastColorChange = Now()
						self.Data.lastColorRGB = {r=r,g=g,b=b}
						self.Data.lastLineRGB = {r=r2,g=g2,b=b2,a=a2}
						self.Data.lastColorAlpha = Settings.alphafill.enemy.small.max
						Settings.outlineThickness.enemy = val
						self.Data.lastLineThickness = val save(true)
					end GUI:PopItemWidth()

					GUI:Text("Telegraph Fill Alpha Settings:")
					local str = "Small AoE:"
					local strX,strY = GUI:CalcTextSize(str)
					GUI:BeginChild(str.."#SmallTelegraphs", strX + (windowPadding.x * 2) , GUI:GetFrameHeight() + (windowPadding.y * 2),true, GUI.WindowFlags_NoTitleBar + GUI.WindowFlags_NoResize + GUI.WindowFlags_NoMove + GUI.WindowFlags_NoScrollbar + GUI.WindowFlags_NoScrollWithMouse + GUI.WindowFlags_NoCollapse + GUI.WindowFlags_NoSavedSettings)
					GUI:AlignFirstTextHeightToWidgets()
					GUI:Text(str)
					GUI:EndChild() GUI:SameLine(0,0)
					GUI:BeginChild("##SmallAlphaSettingsTelegraphs",GUI:CalcTextSize("Min Alpha: Max: ") + 200, GUI:GetFrameHeight() + (windowPadding.y * 2), true, GUI.WindowFlags_NoTitleBar + GUI.WindowFlags_NoResize + GUI.WindowFlags_NoMove + GUI.WindowFlags_NoScrollbar + GUI.WindowFlags_NoScrollWithMouse + GUI.WindowFlags_NoCollapse + GUI.WindowFlags_NoSavedSettings)
					GUI:PushItemWidth(100)
					GUI:AlignFirstTextHeightToWidgets()
					GUI:Text("Min: ") GUI:SameLine(0,0)
					local val,changed = GUI:SliderInt("##smallTelegraphsMin",smallEnemy.min*100,1,100,"%i%%")
					if changed then
						smallEnemy.min = val / 100
						self.Data.lastColorChange = Now()
						self.Data.lastColorRGB = {r=r,g=g,b=b}
						self.Data.lastLineRGB = Settings.outlineRGB.enemy
						self.Data.lastColorAlpha = val / 100
					end GUI:SameLine(0,15)
					GUI:Text("Max: ") GUI:SameLine(0,0)
					local val2,changed2 = GUI:SliderInt("##smallTelegraphsMax",smallEnemy.max*100,1,100,"%i%%")
					if changed2 then
						smallEnemy.max = val2 / 100
						self.Data.lastColorChange = Now()
						self.Data.lastColorRGB = {r=r,g=g,b=b}
						self.Data.lastLineRGB = Settings.outlineRGB.enemy
						self.Data.lastColorAlpha = val2 / 100
					end
					GUI:PopItemWidth()
					GUI:EndChild()

					local str = "Large AoE:"
					local strX,strY = GUI:CalcTextSize(str)
					GUI:BeginChild(str.."#LargeTelegraphs", strX + (windowPadding.x * 2) , GUI:GetFrameHeight() + (windowPadding.y * 2),true, GUI.WindowFlags_NoTitleBar + GUI.WindowFlags_NoResize + GUI.WindowFlags_NoMove + GUI.WindowFlags_NoScrollbar + GUI.WindowFlags_NoScrollWithMouse + GUI.WindowFlags_NoCollapse + GUI.WindowFlags_NoSavedSettings)
					GUI:AlignFirstTextHeightToWidgets()
					GUI:Text(str)
					GUI:EndChild() GUI:SameLine(0,0)
					GUI:BeginChild("##LargeAlphaSettingsTelegraphs",GUI:CalcTextSize("Min Alpha: Max: ") + 200, GUI:GetFrameHeight() + (windowPadding.y * 2), true, GUI.WindowFlags_NoTitleBar + GUI.WindowFlags_NoResize + GUI.WindowFlags_NoMove + GUI.WindowFlags_NoScrollbar + GUI.WindowFlags_NoScrollWithMouse + GUI.WindowFlags_NoCollapse + GUI.WindowFlags_NoSavedSettings)
					GUI:PushItemWidth(100)
					GUI:AlignFirstTextHeightToWidgets()
					GUI:Text("Min: ") GUI:SameLine(0,0)
					local val,changed = GUI:SliderInt("##LargeTelegraphsMin",largeEnemy.min*100,1,100,"%i%%")
					if changed then
						largeEnemy.min = val / 100
						self.Data.lastColorChange = Now()
						self.Data.lastColorRGB = {r=r,g=g,b=b}
						self.Data.lastLineRGB = Settings.outlineRGB.enemy
						self.Data.lastColorAlpha = val / 100
					end GUI:SameLine(0,15)
					GUI:Text("Max: ") GUI:SameLine(0,0)
					local val2,changed2 = GUI:SliderInt("##LargeTelegraphsMax",largeEnemy.max*100,1,100,"%i%%")
					if changed2 then
						largeEnemy.max = val2 / 100
						self.Data.lastColorChange = Now()
						self.Data.lastColorRGB = {r=r,g=g,b=b}
						self.Data.lastLineRGB = Settings.outlineRGB.enemy
						self.Data.lastColorAlpha = val2 / 100
					end
					GUI:PopItemWidth()
					GUI:EndChild()

					GUI:EndPopup()
				end
				GUI:SameLine(0,5) GUI:Text("Enemy")
				GUI:SameLine(0,15)

				local hovered = false
				GUI:ColorButton("Healing Color", healingFill.r, healingFill.g, healingFill.b, 1, 0, GUI:GetFrameHeight(), GUI:GetFrameHeight()) if not hovered then hovered = GUI:IsItemHovered() end
				if GUI:IsItemClicked(0) then
					GUI:OpenPopup("Healing Color Editor")
				elseif GUI:IsItemClicked(1) then
					Settings.DrawHealingAoE = not Settings.DrawHealingAoE save(true)
				end
				if GUI:BeginPopup("Healing Color Editor", GUI.WindowFlags_NoTitleBar + GUI.WindowFlags_NoResize + GUI.WindowFlags_NoMove + GUI.WindowFlags_NoScrollbar + GUI.WindowFlags_NoScrollWithMouse + GUI.WindowFlags_NoCollapse + GUI.WindowFlags_NoSavedSettings) then
					GUI:ColorEditMode(GUI.ColorEditMode_NoInputs + GUI.ColorEditMode_NoAlpha)
					local r,g,b,changed = GUI:ColorEdit3("Healing Color##HealingColorTelegraphs",healingFill.r, healingFill.g, healingFill.b)
					if (changed) then
						self.Data.lastColorChange = Now()
						self.Data.lastColorRGB = {r=r,g=g,b=b}
						self.Data.lastLineRGB = Settings.outlineRGB.healing
						Settings.fillRGB.healing = {r=r,g=g,b=b}
						self.Data.lastColorAlpha = Settings.alphafill.healing.small.max save(true)
					end
					if GUI:IsItemClicked() then
						self.Data.lastColorChange = Now()
						self.Data.lastColorRGB = {r=r,g=g,b=b}
						self.Data.lastLineRGB = Settings.outlineRGB.healing
						self.Data.lastColorAlpha = Settings.alphafill.healing.small.max
					end GUI:SameLine(0,15)
					GUI:ColorEditMode(GUI.ColorEditMode_NoInputs + GUI.ColorEditMode_AlphaBar)
					local r2,g2,b2,a2,changed2 = GUI:ColorEdit4("Outline Color##HealingColorTelegraphs",outlineHealing.r, outlineHealing.g, outlineHealing.b, outlineHealing.a)
					if (changed2) then
						self.Data.lastColorChange = Now()
						self.Data.lastColorRGB = {r=r,g=g,b=b}
						self.Data.lastLineRGB = {r=r2,g=g2,b=b2,a=a2}
						Settings.outlineRGB.healing = {r=r2,g=g2,b=b2,a=a2}
						self.Data.lastColorAlpha = Settings.alphafill.healing.small.max save(true)
					end
					if GUI:IsItemClicked() then
						self.Data.lastColorChange = Now()
						self.Data.lastColorRGB = {r=r,g=g,b=b}
						self.Data.lastLineRGB = {r=r2,g=g2,b=b2,a=a2}
						self.Data.lastColorAlpha = Settings.alphafill.healing.small.max
					end GUI:SameLine(0,15)
					GUI:Text("Line Size: ") GUI:SameLine(0,0) GUI:PushItemWidth(-1)
					local val,changed = GUI:SliderInt("##OutlineThicknessHealing",outlineThicknessHealing,1,10)
					if changed then
						self.Data.lastColorChange = Now()
						self.Data.lastColorRGB = {r=r,g=g,b=b}
						self.Data.lastLineRGB = {r=r2,g=g2,b=b2,a=a2}
						self.Data.lastColorAlpha = Settings.alphafill.healing.small.max
						Settings.outlineThickness.healing = val
						self.Data.lastLineThickness = val save(true)
					end GUI:PopItemWidth()

					GUI:Text("Telegraph Fill Alpha Settings:")
					local str = "Small AoE:"
					local strX,strY = GUI:CalcTextSize(str)
					GUI:BeginChild(str.."#SmallTelegraphs", strX + (windowPadding.x * 2) , GUI:GetFrameHeight() + (windowPadding.y * 2),true, GUI.WindowFlags_NoTitleBar + GUI.WindowFlags_NoResize + GUI.WindowFlags_NoMove + GUI.WindowFlags_NoScrollbar + GUI.WindowFlags_NoScrollWithMouse + GUI.WindowFlags_NoCollapse + GUI.WindowFlags_NoSavedSettings)
					GUI:AlignFirstTextHeightToWidgets()
					GUI:Text(str)
					GUI:EndChild() GUI:SameLine(0,0)
					GUI:BeginChild("##SmallAlphaSettingsTelegraphs",GUI:CalcTextSize("Min Alpha: Max: ") + 200, GUI:GetFrameHeight() + (windowPadding.y * 2), true, GUI.WindowFlags_NoTitleBar + GUI.WindowFlags_NoResize + GUI.WindowFlags_NoMove + GUI.WindowFlags_NoScrollbar + GUI.WindowFlags_NoScrollWithMouse + GUI.WindowFlags_NoCollapse + GUI.WindowFlags_NoSavedSettings)
					GUI:PushItemWidth(100)
					GUI:AlignFirstTextHeightToWidgets()
					GUI:Text("Min: ") GUI:SameLine(0,0)
					local val,changed = GUI:SliderInt("##smallTelegraphsMin",smallHealing.min*100,1,100,"%i%%")
					if changed then
						smallHealing.min = val / 100
						self.Data.lastColorChange = Now()
						self.Data.lastColorRGB = {r=r,g=g,b=b}
						self.Data.lastLineRGB = Settings.outlineRGB.healing
						self.Data.lastColorAlpha = val / 100
					end GUI:SameLine(0,15)
					GUI:Text("Max: ") GUI:SameLine(0,0)
					local val2,changed2 = GUI:SliderInt("##smallTelegraphsMax",smallHealing.max*100,1,100,"%i%%")
					if changed2 then
						smallHealing.max = val2 / 100
						self.Data.lastColorChange = Now()
						self.Data.lastColorRGB = {r=r,g=g,b=b}
						self.Data.lastLineRGB = Settings.outlineRGB.healing
						self.Data.lastColorAlpha = val2 / 100
					end
					GUI:PopItemWidth()
					GUI:EndChild()

					local str = "Large AoE:"
					local strX,strY = GUI:CalcTextSize(str)
					GUI:BeginChild(str.."#LargeTelegraphs", strX + (windowPadding.x * 2) , GUI:GetFrameHeight() + (windowPadding.y * 2),true, GUI.WindowFlags_NoTitleBar + GUI.WindowFlags_NoResize + GUI.WindowFlags_NoMove + GUI.WindowFlags_NoScrollbar + GUI.WindowFlags_NoScrollWithMouse + GUI.WindowFlags_NoCollapse + GUI.WindowFlags_NoSavedSettings)
					GUI:AlignFirstTextHeightToWidgets()
					GUI:Text(str)
					GUI:EndChild() GUI:SameLine(0,0)
					GUI:BeginChild("##LargeAlphaSettingsTelegraphs",GUI:CalcTextSize("Min Alpha: Max: ") + 200, GUI:GetFrameHeight() + (windowPadding.y * 2), true, GUI.WindowFlags_NoTitleBar + GUI.WindowFlags_NoResize + GUI.WindowFlags_NoMove + GUI.WindowFlags_NoScrollbar + GUI.WindowFlags_NoScrollWithMouse + GUI.WindowFlags_NoCollapse + GUI.WindowFlags_NoSavedSettings)
					GUI:PushItemWidth(100)
					GUI:AlignFirstTextHeightToWidgets()
					GUI:Text("Min: ") GUI:SameLine(0,0)
					local val,changed = GUI:SliderInt("##LargeTelegraphsMin",largeHealing.min*100,1,100,"%i%%")
					if changed then
						largeHealing.min = val / 100
						self.Data.lastColorChange = Now()
						self.Data.lastColorRGB = {r=r,g=g,b=b}
						self.Data.lastLineRGB = Settings.outlineRGB.healing
						self.Data.lastColorAlpha = val / 100
					end GUI:SameLine(0,15)
					GUI:Text("Max: ") GUI:SameLine(0,0)
					local val2,changed2 = GUI:SliderInt("##LargeTelegraphsMax",largeHealing.max*100,1,100,"%i%%")
					if changed2 then
						largeHealing.max = val2 / 100
						self.Data.lastColorChange = Now()
						self.Data.lastColorRGB = {r=r,g=g,b=b}
						self.Data.lastLineRGB = Settings.outlineRGB.healing
						self.Data.lastColorAlpha = val2 / 100
					end
					GUI:PopItemWidth()
					GUI:EndChild()

					GUI:PushItemWidth(-1)
					GUI:AlignFirstTextHeightToWidgets()
					if not StringTableCache["Healing Actions"] then StringTableCache["Healing Actions"] = unpack(Settings.HealingAoeActions) end
					GUI:Text("Healing Actions: ")
					GUI:SameLine(0,0)
					local val,changed = GUI:InputText("##HealingActions",StringTableCache["Healing Actions"])
					if changed then
						local tbl = {}
						for w in val:gmatch("[^,]+") do tbl[#tbl+1] = tonumber(w) end
						if table.valid(tbl) then
							StringTableCache["Healing Actions"] = val
							Settings.HealingAoeActions = tbl save(true)
						end
					end
					GUI:PopItemWidth()
					Settings.DrawHealingOutOfRange = GUI:Checkbox("Draw healing only if out of range",Settings.DrawHealingOutOfRange)
					Settings.DrawHealingCirclesOutline = GUI:Checkbox("Draw outline while in range",Settings.DrawHealingCirclesOutline)
					Settings.DrawHealingOutlineIfHealer = GUI:Checkbox("Draw outline if you're the caster",Settings.DrawHealingOutlineIfHealer)
					GUI:EndPopup()
				end
				GUI:SameLine(0,5)
				if Settings.DrawHealingAoE then
					GUI:Text("Healing")
				else
					GUI:TextDisabled("Healing")
				end if not hovered then hovered = GUI:IsItemHovered() end
				if GUI:IsItemClicked(0) then
					GUI:OpenPopup("Healing Color Editor")
				elseif GUI:IsItemClicked(1) then
					Settings.DrawHealingAoE = not Settings.DrawHealingAoE save(true)
				end
				if hovered then
					GUI:BeginTooltip()
					GUI:PushTextWrapPos(300)
					local str = (function() if Settings.DrawHealingAoE then return "Disable" else return "Enable" end end)()
					GUI:Text("Right Click to [") GUI:SameLine(0,0)
					GUI:TextColored(1,1,0,1,str) GUI:SameLine(0,0)
					GUI:Text("]")
					GUI:PopTextWrapPos()
					GUI:EndTooltip()
				end GUI:SameLine(0,15)


				local hovered = false
				GUI:ColorButton("Friendly Color", friendFill.r, friendFill.g, friendFill.b, 1, 0, GUI:GetFrameHeight(), GUI:GetFrameHeight()) if not hovered then hovered = GUI:IsItemHovered() end
				if GUI:IsItemClicked(0) then
					GUI:OpenPopup("Friendly Color Editor")
				elseif GUI:IsItemClicked(1) then
					Settings.DrawFriendlyAoE = not Settings.DrawFriendlyAoE save(true)
				end
				if GUI:BeginPopup("Friendly Color Editor", GUI.WindowFlags_NoTitleBar + GUI.WindowFlags_NoResize + GUI.WindowFlags_NoMove + GUI.WindowFlags_NoScrollbar + GUI.WindowFlags_NoScrollWithMouse + GUI.WindowFlags_NoCollapse + GUI.WindowFlags_NoSavedSettings) then
					GUI:ColorEditMode(GUI.ColorEditMode_NoInputs + GUI.ColorEditMode_NoAlpha)
					local r,g,b,changed = GUI:ColorEdit3("Friendly Color##FriendlyColorTelegraphs",friendFill.r, friendFill.g, friendFill.b)
					if (changed) then
						self.Data.lastColorChange = Now()
						self.Data.lastColorRGB = {r=r,g=g,b=b}
						self.Data.lastLineRGB = Settings.outlineRGB.friend
						Settings.fillRGB.friend = {r=r,g=g,b=b}
						self.Data.lastColorAlpha = Settings.alphafill.friend.small.max save(true)
					end
					if GUI:IsItemClicked() then
						self.Data.lastColorChange = Now()
						self.Data.lastColorRGB = {r=r,g=g,b=b}
						self.Data.lastLineRGB = Settings.outlineRGB.friend
						self.Data.lastColorAlpha = Settings.alphafill.friend.small.max
					end GUI:SameLine(0,15)
					GUI:ColorEditMode(GUI.ColorEditMode_NoInputs + GUI.ColorEditMode_AlphaBar)
					local r2,g2,b2,a2,changed2 = GUI:ColorEdit4("Outline Color##FriendColorTelegraphs",outlineFriend.r, outlineFriend.g, outlineFriend.b, outlineFriend.a)
					if (changed2) then
						self.Data.lastColorChange = Now()
						self.Data.lastColorRGB = {r=r,g=g,b=b}
						self.Data.lastLineRGB = {r=r2,g=g2,b=b2,a=a2}
						Settings.outlineRGB.friend = {r=r2,g=g2,b=b2,a=a2}
						self.Data.lastColorAlpha = Settings.alphafill.friend.small.max save(true)
					end
					if GUI:IsItemClicked() then
						self.Data.lastColorChange = Now()
						self.Data.lastColorRGB = {r=r,g=g,b=b}
						self.Data.lastLineRGB = {r=r2,g=g2,b=b2,a=a2}
						self.Data.lastColorAlpha = Settings.alphafill.friend.small.max
					end GUI:SameLine(0,15)
					GUI:Text("Line Size: ") GUI:SameLine(0,0) GUI:PushItemWidth(-1)
					local val,changed = GUI:SliderInt("##OutlineThicknessFriend",outlineThicknessFriend,1,10)
					if changed then
						self.Data.lastColorChange = Now()
						self.Data.lastColorRGB = {r=r,g=g,b=b}
						self.Data.lastLineRGB = {r=r2,g=g2,b=b2,a=a2}
						self.Data.lastColorAlpha = Settings.alphafill.friend.small.max
						Settings.outlineThickness.friend = val
						self.Data.lastLineThickness = val save(true)
					end GUI:PopItemWidth()

					GUI:Text("Telegraph Fill Alpha Settings:")
					local str = "Small AoE:"
					local strX,strY = GUI:CalcTextSize(str)
					GUI:BeginChild(str.."#SmallTelegraphs", strX + (windowPadding.x * 2) , GUI:GetFrameHeight() + (windowPadding.y * 2),true, GUI.WindowFlags_NoTitleBar + GUI.WindowFlags_NoResize + GUI.WindowFlags_NoMove + GUI.WindowFlags_NoScrollbar + GUI.WindowFlags_NoScrollWithMouse + GUI.WindowFlags_NoCollapse + GUI.WindowFlags_NoSavedSettings)
					GUI:AlignFirstTextHeightToWidgets()
					GUI:Text(str)
					GUI:EndChild() GUI:SameLine(0,0)
					GUI:BeginChild("##SmallAlphaSettingsTelegraphs",GUI:CalcTextSize("Min Alpha: Max: ") + 200, GUI:GetFrameHeight() + (windowPadding.y * 2), true, GUI.WindowFlags_NoTitleBar + GUI.WindowFlags_NoResize + GUI.WindowFlags_NoMove + GUI.WindowFlags_NoScrollbar + GUI.WindowFlags_NoScrollWithMouse + GUI.WindowFlags_NoCollapse + GUI.WindowFlags_NoSavedSettings)
					GUI:PushItemWidth(100)
					GUI:AlignFirstTextHeightToWidgets()
					GUI:Text("Min: ") GUI:SameLine(0,0)
					local val,changed = GUI:SliderInt("##smallTelegraphsMin",smallFriend.min*100,1,100,"%i%%")
					if changed then
						smallFriend.min = val / 100
						self.Data.lastColorChange = Now()
						self.Data.lastColorRGB = {r=r,g=g,b=b}
						self.Data.lastLineRGB = Settings.outlineRGB.friend
						self.Data.lastColorAlpha = val / 100
					end GUI:SameLine(0,15)
					GUI:Text("Max: ") GUI:SameLine(0,0)
					local val2,changed2 = GUI:SliderInt("##smallTelegraphsMax",smallFriend.max*100,1,100,"%i%%")
					if changed2 then
						smallFriend.max = val2 / 100
						self.Data.lastColorChange = Now()
						self.Data.lastColorRGB = {r=r,g=g,b=b}
						self.Data.lastLineRGB = Settings.outlineRGB.friend
						self.Data.lastColorAlpha = val2 / 100
					end
					GUI:PopItemWidth()
					GUI:EndChild()

					local str = "Large AoE:"
					local strX,strY = GUI:CalcTextSize(str)
					GUI:BeginChild(str.."#LargeTelegraphs", strX + (windowPadding.x * 2) , GUI:GetFrameHeight() + (windowPadding.y * 2),true, GUI.WindowFlags_NoTitleBar + GUI.WindowFlags_NoResize + GUI.WindowFlags_NoMove + GUI.WindowFlags_NoScrollbar + GUI.WindowFlags_NoScrollWithMouse + GUI.WindowFlags_NoCollapse + GUI.WindowFlags_NoSavedSettings)
					GUI:AlignFirstTextHeightToWidgets()
					GUI:Text(str)
					GUI:EndChild() GUI:SameLine(0,0)
					GUI:BeginChild("##LargeAlphaSettingsTelegraphs",GUI:CalcTextSize("Min Alpha: Max: ") + 200, GUI:GetFrameHeight() + (windowPadding.y * 2), true, GUI.WindowFlags_NoTitleBar + GUI.WindowFlags_NoResize + GUI.WindowFlags_NoMove + GUI.WindowFlags_NoScrollbar + GUI.WindowFlags_NoScrollWithMouse + GUI.WindowFlags_NoCollapse + GUI.WindowFlags_NoSavedSettings)
					GUI:PushItemWidth(100)
					GUI:Text("Min: ") GUI:SameLine(0,0)
					local val,changed = GUI:SliderInt("##LargeTelegraphsMin",largeFriend.min*100,1,100,"%i%%")
					if changed then
						largeFriend.min = val / 100
						self.Data.lastColorChange = Now()
						self.Data.lastColorRGB = {r=r,g=g,b=b}
						self.Data.lastLineRGB = Settings.outlineRGB.friend
						self.Data.lastColorAlpha = val / 100
					end GUI:SameLine(0,15)
					GUI:Text("Max: ") GUI:SameLine(0,0)
					local val2,changed2 = GUI:SliderInt("##LargeTelegraphsMax",largeFriend.max*100,1,100,"%i%%")
					if changed2 then
						largeFriend.max = val2 / 100
						self.Data.lastColorChange = Now()
						self.Data.lastColorRGB = {r=r,g=g,b=b}
						self.Data.lastLineRGB = Settings.outlineRGB.friend
						self.Data.lastColorAlpha = val2 / 100
					end
					GUI:PopItemWidth()
					GUI:EndChild()

					GUI:EndPopup()
				end
				GUI:SameLine(0,5)
				if Settings.DrawFriendlyAoE then
					GUI:Text("Friendly")
				else
					GUI:TextDisabled("Friendly")
				end if not hovered then hovered = GUI:IsItemHovered() end
				if GUI:IsItemClicked(0) then
					GUI:OpenPopup("Friendly Color Editor")
				elseif GUI:IsItemClicked(1) then
					Settings.DrawFriendlyAoE = not Settings.DrawFriendlyAoE save(true)
				end
				if hovered then
					GUI:BeginTooltip()
					GUI:PushTextWrapPos(300)
					local str = (function() if Settings.DrawFriendlyAoE then return "Disable" else return "Enable" end end)()
					GUI:Text("Right Click to [") GUI:SameLine(0,0)
					GUI:TextColored(1,1,0,1,str) GUI:SameLine(0,0)
					GUI:Text("]")
					GUI:PopTextWrapPos()
					GUI:EndTooltip()
				end GUI:SameLine(0,25)


				local hovered = false
				GUI:ColorButton("Attack Range Color", outlineRangeOutside.r, outlineRangeOutside.g, outlineRangeOutside.b, 1, 0, GUI:GetFrameHeight(), GUI:GetFrameHeight()) if not hovered then hovered = GUI:IsItemHovered() end
				if GUI:IsItemClicked(0) then
					GUI:OpenPopup("Attack Range Color Editor")
				elseif GUI:IsItemClicked(1) then
					Settings.DrawAttackRange = not Settings.DrawAttackRange save(true)
				end
				if GUI:BeginPopup("Attack Range Color Editor", GUI.WindowFlags_NoTitleBar + GUI.WindowFlags_NoResize + GUI.WindowFlags_NoMove + GUI.WindowFlags_NoScrollbar + GUI.WindowFlags_NoScrollWithMouse + GUI.WindowFlags_NoCollapse + GUI.WindowFlags_NoSavedSettings) then
					GUI:ColorEditMode(GUI.ColorEditMode_NoInputs + GUI.ColorEditMode_AlphaBar)
					local r,g,b,a,changed = GUI:ColorEdit4("Attack Range (Inside) Color##AttackRange",outlineRangeInside.r, outlineRangeInside.g, outlineRangeInside.b, outlineRangeInside.a)
					if (changed) then
						self.Data.lastColorChange = Now()
						self.Data.lastLineRGB = {r=r,g=g,b=b,a=a}
						Settings.outlineRGB.rangeInside = {r=r,g=g,b=b,a=a}
						self.Data.lastColorAlpha = 0 save(true)
					end
					if GUI:IsItemClicked() then
						self.Data.lastColorChange = Now()
						self.Data.lastLineRGB = {r=r,g=g,b=b,a=a}
						self.Data.lastColorAlpha = 0
					end
					local r,g,b,a,changed = GUI:ColorEdit4("Attack Range (Outside) Color##AttackRange",outlineRangeOutside.r, outlineRangeOutside.g, outlineRangeOutside.b, outlineRangeOutside.a)
					if (changed) then
						self.Data.lastColorChange = Now()
						self.Data.lastLineRGB = {r=r,g=g,b=b,a=a}
						Settings.outlineRGB.rangeOutside = {r=r,g=g,b=b,a=a}
						self.Data.lastColorAlpha = 0 save(true)
					end
					if GUI:IsItemClicked() then
						self.Data.lastColorChange = Now()
						self.Data.lastLineRGB = {r=r,g=g,b=b,a=a}
						self.Data.lastColorAlpha = 0
					end
					GUI:AlignFirstTextHeightToWidgets()
					GUI:Text("Line Size: ") GUI:SameLine(0,0) GUI:PushItemWidth(100)
					local val,changed = GUI:SliderInt("##OutlineThicknessAttackRange",outlineThicknessRange,1,10)
					if changed then
						self.Data.lastColorChange = Now()
						self.Data.lastLineRGB = {r=r,g=g,b=b,a=a}
						self.Data.lastColorAlpha = 0
						Settings.outlineThickness.range = val
						self.Data.lastLineThickness = val save(true)
					end GUI:PopItemWidth()

					GUI:EndPopup()
				end
				GUI:SameLine(0,5)
				if Settings.DrawAttackRange then
					GUI:Text("Attack Range")
				else
					GUI:TextDisabled("Attack Range")
				end if not hovered then hovered = GUI:IsItemHovered() end
				if GUI:IsItemClicked(0) then
					GUI:OpenPopup("Attack Range Color Editor")
				elseif GUI:IsItemClicked(1) then
					Settings.DrawAttackRange = not Settings.DrawAttackRange save(true)
				end
				if hovered then
					GUI:BeginTooltip()
					GUI:PushTextWrapPos(300)
					local str = (function() if Settings.DrawAttackRange then return "Disable" else return "Enable" end end)()
					GUI:Text("Right Click to [") GUI:SameLine(0,0)
					GUI:TextColored(1,1,0,1,str) GUI:SameLine(0,0)
					GUI:Text("]")
					GUI:PopTextWrapPos()
					GUI:EndTooltip()
				end




				GUI:EndChild()

				--GUI:SameLine(0,15)
				--local r,g,b,changed = GUI:ColorPicker3("##FriendlyColorTelegraphs",friend.r, friend.g, friend.b)
				--if (changed) then
				--	self.Data.lastColorChange = Now()
				--	self.Data.lastColorRGB = {r=r,g=g,b=b}
				--	Settings.fillRGB.friend = {r=r,g=g,b=b}
				--end
				--if GUI:IsItemClicked() then
				--	self.Data.lastColorChange = Now()
				--	self.Data.lastColorRGB = {r=r,g=g,b=b}
				--end

				GUI:AlignFirstTextHeightToWidgets()

				local hovered = false
				GUI:Text("Vertices Spacing: ") if not hovered then hovered = GUI:IsItemHovered() end
				GUI:SameLine(0,0) GUI:PushItemWidth(60)
				local val,changed = GUI:SliderFloat("##VerticesSpacing",Settings.verticesSpacing, 0.1, 3,"%.1f")
				if changed and val > 0 then
					Settings.verticesSpacing = val save(true)
				end GUI:PopItemWidth()
				if not hovered then hovered = GUI:IsItemHovered() end
				if hovered then
					GUI:BeginTooltip()
					GUI:PushTextWrapPos(300)
					GUI:TextColored(1,0,0,1,"[Advanced] ") GUI:SameLine(0,0)
					GUI:TextColored(1,1,0,1,"This setting will impact system performance.")
					GUI:Text("When drawing curved lines the spacing determines how smooth the curve ends up being. The lower the value the more segments required to draw the telegraph, and each telegraph being drawn amplifies the demand further.")
					GUI:Text("If you feel like telegraphs are straining your computer's performance, then you can make the spacing higher (default is 0.5).")
					GUI:TextColored(1,1,0,1,"Leave this set to 0 for unlimited draw distance.\n[CTRL]+[Left Mouse Button] to manually type in amount instead of dragging.")
					GUI:PopTextWrapPos()
					GUI:EndTooltip()
				end GUI:SameLine(0,25)

				local hovered = false
				GUI:Text("Max Segments: ") if not hovered then hovered = GUI:IsItemHovered() end
				GUI:SameLine(0,0) GUI:PushItemWidth(60)
				local val,changed = GUI:SliderInt("##MaxSegments",Settings.maxSegments, 10, 100)
				if changed and val > 0 then
					Settings.maxSegments = val save(true)
				end GUI:PopItemWidth()
				if not hovered then hovered = GUI:IsItemHovered() end
				if hovered then
					GUI:BeginTooltip()
					GUI:PushTextWrapPos(300)
					GUI:TextColored(1,0,0,1,"[Advanced] ") GUI:SameLine(0,0)
					GUI:TextColored(1,1,0,1,"This setting will impact system performance.")
					GUI:Text("When drawing curved lines the number of segments determines how smooth the curve ends up being. The higher the value the smoother the line, and smaller telegraphs won't reach this limit.")
					GUI:Text("Larger telegraphs will require more segments to complete the curve, so to keep things under control we set a cap on how many segments each telegraph can utilize.")
					GUI:Text("If you feel like telegraphs are straining your computer's performance, then you can lower the max segments (default is 50).")
					GUI:TextColored(1,1,0,1,"Leave this set to 0 for unlimited draw distance.\n[CTRL]+[Left Mouse Button] to manually type in amount instead of dragging.")
					GUI:PopTextWrapPos()
					GUI:EndTooltip()
				end GUI:SameLine(0,25)


				--Settings.DrawFriendlyAoE = GUI:Checkbox("Draw Friendly AoE",Settings.DrawFriendlyAoE)
				--GUI:SameLine(0,15)
				--Settings.DrawFriendlyOutRange = GUI:Checkbox("Only if Outside of AoE",Settings.DrawFriendlyOutRange)
				--GUI:SameLine(0,15)
				--Settings.DrawFriendlyLB = GUI:Checkbox("Draw Limit Break",Settings.DrawFriendlyLB)
			elseif (tabname == GetString("Markers")) then
				GUI:Text("Work In Progress")
			elseif (tabname == GetString("Extras")) then
				GUI:Text("Show Entity Heading:")
				GUI:BeginChild("##HeadingFrame",0,250,true)
				local hEntities,minRadius,minFront,fill,outline,thickness = Settings.showHeadingEntities,Settings.showHeadingMinRadius,Settings.showHeadingMinFront,Settings.showHeadingFillingRGB,Settings.showHeadingOutlineRGB,Settings.showHeadingOutlineThickness

				GUI:ColorEditMode(GUI.ColorEditMode_NoInputs + GUI.ColorEditMode_AlphaBar)
				local r,g,b,a,changed = GUI:ColorEdit4("Heading Color##HeadingColor",fill.r, fill.g, fill.b, fill.a)
				if (changed) then
					self.Data.lastColorChange = Now()
					self.Data.lastColorRGB = {r=r,g=g,b=b}
					self.Data.lastLineRGB = outline
					Settings.showHeadingFillingRGB = {r=r,g=g,b=b,a=a}
					self.Data.lastColorAlpha = a save(true)
				end
				if GUI:IsItemClicked() then
					self.Data.lastColorChange = Now()
					self.Data.lastColorRGB = {r=r,g=g,b=b}
					self.Data.lastLineRGB = outline
					self.Data.lastColorAlpha = a
				end GUI:SameLine(0,15)
				GUI:ColorEditMode(GUI.ColorEditMode_NoInputs + GUI.ColorEditMode_AlphaBar)
				local r2,g2,b2,a2,changed2 = GUI:ColorEdit4("Outline Color##HeadingColorOutline",outline.r, outline.g, outline.b, outline.a)
				if (changed2) then
					self.Data.lastColorChange = Now()
					self.Data.lastColorRGB = {r=fill.r,g=fill.g,b=fill.b}
					self.Data.lastLineRGB = {r=r2,g=g2,b=b2,a=a2}
					Settings.showHeadingOutlineRGB = {r=r2,g=g2,b=b2,a=a2}
					self.Data.lastColorAlpha = a save(true)
				end
				if GUI:IsItemClicked() then
					self.Data.lastColorChange = Now()
					self.Data.lastColorRGB = {r=fill.r,g=fill.g,b=fill.b}
					self.Data.lastLineRGB = {r=r2,g=g2,b=b2,a=a2}
					self.Data.lastColorAlpha = a
				end GUI:SameLine(0,15)
				GUI:Text("Line Size: ") GUI:SameLine(0,0) GUI:PushItemWidth(100)
				local val,changed = GUI:SliderInt("##OutlineThicknessHeading",thickness,1,10)
				if changed then
					self.Data.lastColorChange = Now()
					self.Data.lastColorRGB = {r=r,g=g,b=b}
					self.Data.lastLineRGB = {r=r2,g=g2,b=b2,a=a2}
					self.Data.lastColorAlpha = a
					Settings.showHeadingOutlineThickness = val
					self.Data.lastLineThickness = val save(true)
				end GUI:PopItemWidth()

				GUI:Text("Minimum Radius: ") GUI:SameLine(0,0) GUI:PushItemWidth(100)
				local val,changed = GUI:SliderFloat("##MinimumRadiusHeading",minRadius,0.1,10,"%.1f")
				if changed then
					self.Data.lastColorChange = Now()
					self.Data.lastColorRGB = {r=r,g=g,b=b}
					self.Data.lastLineRGB = {r=r2,g=g2,b=b2,a=a2}
					self.Data.lastColorAlpha = a
					Settings.showHeadingMinRadius = val save(true)
				end GUI:PopItemWidth() GUI:SameLine(0,15)
				GUI:Text("Minimum Frontal: ") GUI:SameLine(0,0) GUI:PushItemWidth(100)
				local val,changed = GUI:SliderFloat("##MinimumFrontalHeading",minFront,0.1,10,"%.1f")
				GUI:PushStyleVar(GUI.StyleVar_ItemSpacing, 0, Style.itemspacing.y)
				GUI:PushStyleVar(GUI.StyleVar_FramePadding, 0, Style.framepadding.y)
				GUI:PushStyleVar(GUI.StyleVar_WindowPadding, 0, Style.windowpadding.y)
				if changed then
					self.Data.lastColorChange = Now()
					self.Data.lastColorRGB = {r=r,g=g,b=b}
					self.Data.lastLineRGB = {r=r2,g=g2,b=b2,a=a2}
					self.Data.lastColorAlpha = a
					Settings.showHeadingMinFront = val save(true)
				end GUI:PopItemWidth()
				GUI:BeginChild("##HeadingEntities",0,0,true)
				local width = GUI:GetContentRegionAvailWidth()

				GUI:Columns(3,"HeadingEntitiesColumn",true)
				GUI:SetColumnWidth(-1,width/3)
				local height = GUI:GetTextLineHeightWithSpacing()
				local str = "Map ID"
				local padding = ((width/3)-GUI:CalcTextSize(str))/2
				GUI:Dummy(padding,height) GUI:SameLine(0,0) GUI:Text(str) GUI:NextColumn()
				GUI:SetColumnWidth(-1,width/3)
				local str = "Content ID"
				local padding = ((width/3)-GUI:CalcTextSize(str))/2
				GUI:Dummy(padding,height) GUI:SameLine(0,0) GUI:Text(str) GUI:NextColumn()
				GUI:SetColumnWidth(-1,width/3)
				local str = "Entity Name"
				local padding = ((width/3)-GUI:CalcTextSize(str))/2
				GUI:Dummy(padding,height) GUI:SameLine(0,0) GUI:Text(str) GUI:Separator() GUI:NextColumn()
				local delete = false
				for i=1,#hEntities do
					local e = hEntities[i]
					local hovered,clicked = false,false
					GUI:SetColumnWidth(-1,width/3)
					local str = e.mapid or 0
					local padding = ((width/3)-GUI:CalcTextSize(str))/2
					GUI:Selectable("##"..i.."dummy",false,GUI.SelectableFlags_SpanAllColumns) if GUI:IsItemHovered() then hovered = true end if GUI:IsItemClicked(1) then clicked = true end GUI:SameLine(0,0)
					GUI:Dummy(padding,height) GUI:SameLine(0,0) GUI:Selectable(str.."##"..i.."mapid",false,GUI.SelectableFlags_SpanAllColumns) if GUI:IsItemHovered() then hovered = true end if GUI:IsItemClicked(1) then clicked = true end GUI:NextColumn()
					--GUI:Selectable(string.rep(" ",Round(padding/space,1))..str.."##"..i.."mapid",false,GUI.SelectableFlags_SpanAllColumns,width,height) GUI:NextColumn()

					GUI:SetColumnWidth(-1,width/3)
					local str = e.contentid or 0
					local padding = ((width/3)-GUI:CalcTextSize(str))/2
					GUI:Dummy(padding,height) GUI:SameLine(0,0) GUI:Selectable(str.."##"..i.."contentid",false,GUI.SelectableFlags_SpanAllColumns) if GUI:IsItemHovered() then hovered = true end if GUI:IsItemClicked(1) then clicked = true end GUI:NextColumn()
					--GUI:Selectable(string.rep(" ",Round(padding/space,1))..str.."##"..i.."contentid",false,GUI.SelectableFlags_SpanAllColumns,width,height) GUI:NextColumn()

					GUI:SetColumnWidth(-1,width/3)
					local str = e.name or ""
					local padding = ((width/3)-GUI:CalcTextSize(str))/2
					GUI:Dummy(padding,height) GUI:SameLine(0,0) GUI:Selectable(str.."##"..i.."name",false,GUI.SelectableFlags_SpanAllColumns) if GUI:IsItemHovered() then hovered = true end if GUI:IsItemClicked(1) then clicked = true end GUI:NextColumn()
					--GUI:Selectable(string.rep(" ",Round(padding/space,1))..str.."##"..i.."name",false,GUI.SelectableFlags_SpanAllColumns,width,height) GUI:NextColumn()
					local note = e.note
					if hovered and note and note ~= "" then
						GUI:PushStyleVar(GUI.StyleVar_FramePadding, Style.framepadding.x, Style.framepadding.y)
						GUI:PushStyleVar(GUI.StyleVar_WindowPadding, Style.windowpadding.x, Style.windowpadding.y)
						GUI:BeginTooltip()
						GUI:PushTextWrapPos(300)
						GUI:Text(note)
						GUI:PopTextWrapPos()
						GUI:EndTooltip()
						GUI:PopStyleVar(2)
					end
					if clicked then
						Data.editHeadingEntry = i
						--GUI:OpenPopup("Edit Heading Entry")
						GUI:OpenPopup("Add/Edit")
					end
					if Data.editHeadingEntry == i then
						local add,edit = false,false
						GUI:PushStyleVar(GUI.StyleVar_FramePadding, Style.framepadding.x, Style.framepadding.y)
						GUI:PushStyleVar(GUI.StyleVar_WindowPadding, Style.windowpadding.x, Style.windowpadding.y)
						if GUI:BeginPopup("Add/Edit", GUI.WindowFlags_NoTitleBar + GUI.WindowFlags_NoResize + GUI.WindowFlags_NoMove + GUI.WindowFlags_NoScrollbar + GUI.WindowFlags_NoScrollWithMouse + GUI.WindowFlags_NoCollapse + GUI.WindowFlags_NoSavedSettings) then
							local _,clicked = GUI:Selectable("Add",false) if clicked then add = true end
							local _,clicked = GUI:Selectable("Edit",false) if clicked then edit = true end
							GUI:Separator()
							local _,clicked = GUI:Selectable("Delete",false) if clicked then delete = true end
							GUI:EndPopup()
						end
						GUI:PopStyleVar(2)
						if add then
							Data.editHeadingEntry = Data.editHeadingEntry + 1
							table.insert(Settings.showHeadingEntities,Data.editHeadingEntry,{ contentid = "0", customFront = 0, customHitRadius = 0, mapid = 0, name = "", note = ""})
							GUI:OpenPopup("Edit Heading Entry")
						elseif edit then
							GUI:OpenPopup("Edit Heading Entry")
						end
					end
				end
				if #hEntities < 8 then
					for i=1,8-#hEntities do
						GUI:Text(" ") GUI:NextColumn() GUI:Text(" ") GUI:NextColumn() GUI:Text(" ") GUI:NextColumn()
					end
				end

				if not GUI:IsPopupOpen("Add/Edit") and GUI:IsMouseClicked(1) then
					GUI:OpenPopup("Add/Edit 2")
				end
				local add = false
				GUI:PushStyleVar(GUI.StyleVar_FramePadding, Style.framepadding.x, Style.framepadding.y)
				GUI:PushStyleVar(GUI.StyleVar_WindowPadding, Style.windowpadding.x, Style.windowpadding.y)
				if GUI:BeginPopup("Add/Edit 2", GUI.WindowFlags_NoTitleBar + GUI.WindowFlags_NoResize + GUI.WindowFlags_NoMove + GUI.WindowFlags_NoScrollbar + GUI.WindowFlags_NoScrollWithMouse + GUI.WindowFlags_NoCollapse + GUI.WindowFlags_NoSavedSettings) then
					local _,clicked = GUI:Selectable("Add",false) if clicked then add = true end
					GUI:EndPopup()
				end
				GUI:PopStyleVar(2)
				if add then
					Data.editHeadingEntry = (#Settings.showHeadingEntities or 0) + 1
					table.insert(Settings.showHeadingEntities,Data.editHeadingEntry,{ contentid = "0", customFront = 0, customHitRadius = 0, mapid = 0, name = "", note = ""})
					GUI:OpenPopup("Edit Heading Entry")
				end
				GUI:PushStyleVar(GUI.StyleVar_FramePadding, Style.framepadding.x, Style.framepadding.y)
				GUI:PushStyleVar(GUI.StyleVar_WindowPadding, Style.windowpadding.x, Style.windowpadding.y)
				if GUI:BeginPopup("Edit Heading Entry", GUI.WindowFlags_NoTitleBar + GUI.WindowFlags_NoResize + GUI.WindowFlags_NoMove + GUI.WindowFlags_NoScrollbar + GUI.WindowFlags_NoScrollWithMouse + GUI.WindowFlags_NoCollapse + GUI.WindowFlags_NoSavedSettings) then
					local i = Data.editHeadingEntry
					if tonumber(i) and i > 0 then
						local entry = Settings.showHeadingEntities[i]
						local mapid,contentid,customFront,customHitRadius,mapid,name,note = entry.mapid,entry.contentid,entry.customFront,entry.customHitRadius,entry.mapid,entry.name,entry.note
						GUI:AlignFirstTextHeightToWidgets() GUI:Text("Map ID: ") GUI:SameLine(0,0)
						GUI:PushItemWidth(({GUI:CalcTextSize("123")})[1] + (Style.iteminnerspacing.x * 2))
						local val,changed = GUI:InputText("##Map ID",mapid,GUI.InputTextFlags_CharsDecimal)
						if changed and val and val~="" and tonumber(val) >= 0 then
							entry.mapid = tonumber(val) or 0 save(true)
						end GUI:PopItemWidth()
						GUI:PushItemWidth(({GUI:CalcTextSize("1234567")})[1] + (Style.iteminnerspacing.x * 2))
						GUI:AlignFirstTextHeightToWidgets() GUI:Text("Content ID: ") GUI:SameLine(0,0)
						local val,changed = GUI:InputText("##Content ID",contentid)
						if changed and val and val~="" then
							entry.contentid = val or "" save(true)
						end GUI:PopItemWidth()
						GUI:AlignFirstTextHeightToWidgets() GUI:Text("Radius: ") GUI:SameLine(0,0)
						GUI:PushItemWidth(({GUI:CalcTextSize("123")})[1] + (Style.iteminnerspacing.x * 2))
						local val,changed = GUI:InputText("##Radius",customHitRadius,GUI.InputTextFlags_CharsDecimal)
						if changed and val and val~="" and tonumber(val) >= 0 then
							entry.customHitRadius = tonumber(val) or 0 save(true)
						end GUI:PopItemWidth()
						GUI:AlignFirstTextHeightToWidgets() GUI:Text("Front: ") GUI:SameLine(0,0)
						GUI:PushItemWidth(({GUI:CalcTextSize("123")})[1] + (Style.iteminnerspacing.x * 2))
						local val,changed = GUI:InputText("##Front",customFront,GUI.InputTextFlags_CharsDecimal)
						if changed and val and val~="" and tonumber(val) >= 0 then
							entry.customFront = tonumber(val) or 0 save(true)
						end GUI:PopItemWidth()
						GUI:PushItemWidth(({GUI:CalcTextSize("1234567890 1234567890")})[1] + (Style.iteminnerspacing.x * 2))
						GUI:AlignFirstTextHeightToWidgets() GUI:Text("Name: ") GUI:SameLine(0,0)
						local val,changed = GUI:InputText("##Name",name)
						if changed then
							entry.name = val or "" save(true)
						end GUI:PopItemWidth()
						GUI:PushItemWidth(({GUI:CalcTextSize("1234567890 1234567890")})[1] + (Style.iteminnerspacing.x * 2))
						GUI:AlignFirstTextHeightToWidgets() GUI:Text("Note: ") GUI:SameLine(0,0)
						local val,changed = GUI:InputText("##Note",note)
						if changed then
							entry.note = val or "" save(true)
						end GUI:PopItemWidth()
					end
					GUI:EndPopup()
				end
				GUI:PopStyleVar(2)
				GUI:Columns(1)
				GUI:EndChild()
				GUI:PopStyleVar(3)
				GUI:EndChild()
				if delete then table.remove(Settings.showHeadingEntities,Data.editHeadingEntry) save(true) end


			elseif (tabname == GetString("Debug")) then
				GUI:Text("Work In Progress")
				--Settings.DebugRecord = GUI:Checkbox("Record Missed Telegraphs",Settings.DebugRecord) GUI:SameLine(0,15)
				--Settings.DebugFile = GUI:Checkbox("Output Debug to File",Settings.DebugFile)
				GUI:Text("Set Unknown Cone Angles to: ") GUI:SameLine(0,0) GUI:PushItemWidth(100)
				local val,changed = GUI:SliderInt("##UnknownConeAngle",Settings.UnknownConeAngle,1,180)
				if changed and val > 0 then
					Settings.MaxTelegraphDrawRange = val save(true)
				end
				GUI:Text("Set Unknown Donut Inner-Radius to: ") GUI:SameLine(0,0)
				local val,changed = GUI:SliderInt("##UnknownDonutRadius",Settings.UnknownDonutRadius,1,10)
				if changed and val > 0 then
					Settings.UnknownDonutRadius = val save(true)
				end GUI:PopItemWidth()
			end


			-- Sidebar --
			local Links = self.GUI.Links
			winX,winY = GUI:GetWindowSize()
			posX,posY = GUI:GetWindowPos()
			local min,max,rate,spacing,padding = 25,50,5,5,0
			local windowsize = 25
			for i=2, #Links do
				local size = Links[i].size.x
				if size and size > 0 and size > windowsize then windowsize = size end
			end
			GUI:PushStyleColor(GUI.Col_WindowBg, 0,0,0,0)
			GUI:SetNextWindowPos(posX-windowsize-spacing,posY + 20,GUI.SetCond_Always)
			GUI:SetNextWindowSize(max,((#Links - 1) * min) + ((#Links - 1) * spacing) + max,GUI.SetCond_Always)
			GUI:PushStyleVar(GUI.StyleVar_WindowPadding,padding,padding)
			GUI:PushStyleVar(GUI.StyleVar_ItemSpacing,spacing,spacing)
			GUI:Begin("MoogleTelegraphs##Sidebar",true,GUI.WindowFlags_NoTitleBar + GUI.WindowFlags_NoResize + GUI.WindowFlags_NoMove + GUI.WindowFlags_NoScrollbar + GUI.WindowFlags_NoScrollWithMouse + GUI.WindowFlags_NoCollapse + GUI.WindowFlags_NoFocusOnAppearing)
			if GUI:IsWindowFocused("MoogleTelegraphs##Sidebar") then GUI:SetWindowFocus(self.GUI.name) end
			for i=2, #Links do
				GUI:Dummy(windowsize-Links[i].size.x,0) GUI:SameLine(0,0)
				GUI:Image(Links[i].icon,Links[i].size.x,Links[i].size.y)
				if GUI:IsItemHovered() then
					GUI:PopStyleVar(2)
					GUI:BeginTooltip()
					GUI:PushTextWrapPos(300)
					GUI:Text(Links[i].tooltip)
					GUI:PopTextWrapPos()
					GUI:EndTooltip()
					GUI:PushStyleVar(GUI.StyleVar_WindowPadding,padding,padding)
					GUI:PushStyleVar(GUI.StyleVar_ItemSpacing,spacing,spacing)
					if Links[i].size.x < max then Links[i].size.x = Links[i].size.x + rate end
					if Links[i].size.y < max then Links[i].size.y = Links[i].size.y + rate end
					if GUI:IsItemClicked(0) then
						io.popen([[cmd /c start "" "]]..Links[i].link..[["]]):close()
					elseif GUI:IsItemClicked(1) then
						io.popen([[cmd /c start "" "]]..Links[i].link2..[["]]):close()
					end
				else
					if Links[i].size.x > min then Links[i].size.x = Links[i].size.x - rate end
					if Links[i].size.y > min then Links[i].size.y = Links[i].size.y - rate end
				end
			end
			GUI:End()
			GUI:PopStyleColor()
			GUI:PopStyleVar(2)
		end
		GUI:End()
		GUI:PopStyleColor(c)
	end
	if Settings.enable and GameState() and not MIsLoading() and not p.onlinestatus ~= 15 then
		local maxWidth, maxHeight = GUI:GetScreenSize()
		GUI:SetNextWindowPos(0, 0, GUI.SetCond_Always)
		GUI:SetNextWindowSize(maxWidth,maxHeight,GUI.SetCond_Always)
		GUI:PushStyleColor(GUI.Col_WindowBg, 0, 0, 0, 0)
		local flags = (GUI.WindowFlags_NoInputs + GUI.WindowFlags_NoBringToFrontOnFocus + GUI.WindowFlags_NoTitleBar + GUI.WindowFlags_NoResize + GUI.WindowFlags_NoScrollbar + GUI.WindowFlags_NoCollapse)
		GUI:Begin("MoogleTelegraphs##MoogleTelegraphs", true, flags)
		if Settings.DrawPlayerDot then
			local player = RenderManager:WorldToScreen(p.pos)
			if valid(player) then
				local combatOnly,instanceOnly = Settings.DrawDotCombatOnly,Settings.DrawDotInstanceOnly
				if (not combatOnly or p.incombat) and (not instanceOnly or InInstance()) then
					GUI:AddCircleFilled(player.x,player.y,Settings.DotSize,Settings.DotDotU32)
				end
			end
		end
		if Settings.DrawHeadingEntities then
			local hEntities,minRadius,minFront,fill,outline,thickness = Settings.showHeadingEntities,Settings.showHeadingMinRadius,Settings.showHeadingMinFront,Settings.showHeadingFillingRGB,Settings.showHeadingOutlineRGB,Settings.showHeadingOutlineThickness
			for i=1,#hEntities do
				local e = hEntities[i]
				if e.mapid == 0 or e.mapid == p.localmapid then
					local el = EntityList("contentid="..e.contentid)
					if valid(el) then
						for _,entity in pairs(el) do
							local pos,radius = entity.pos,(function() local h = entity.hitradius
								if e.customHitRadius and e.customHitRadius > h then return e.customHitRadius
								elseif h >= minRadius then return h else return minRadius end end)()
							local Length = (radius * 2) + (function() local f = tonumber(e.customFront) if f and f > 0 then return f else return minFront end end)()
							Argus.addRectFilled(pos.x, pos.y, pos.z, Length, (radius * 2), pos.h,GUI:ColorConvertFloat4ToU32(fill.r,fill.g,fill.b,fill.a),GUI:ColorConvertFloat4ToU32(outline.r,outline.g,outline.b,outline.a),thickness)
						end
					end
				end
			end
		end
		if Settings.DrawAttackRange then
			local target = MGetTarget()
			if valid(target) and target.attackable then
				local maxRange,dist,outlineRGB = ml_global_information.AttackRange + 1,Distance3D(p,target),Settings.outlineRGB
				if dist > maxRange then
					local rangeOutside,pos,Radius,maxSegments = outlineRGB.rangeOutside,target.pos,target.hitradius + p.hitradius + maxRange,Settings.maxSegments
					local Segments = (function() local seg = ((Radius * 2) * math.pi) / Settings.verticesSpacing if seg <= maxSegments then return seg else return maxSegments end end)()
					Argus.addCircleFilled(pos.x, pos.y, pos.z, Radius, Segments,nil,
							GUI:ColorConvertFloat4ToU32(rangeOutside.r,rangeOutside.g,rangeOutside.b,rangeOutside.a),Settings.outlineThickness.range)
				else
					local buffer = maxRange - dist
					local alphaPercent = (1.5 - buffer) / 1.5
					if alphaPercent <= 1 then
						local rangeInside,pos,Radius,maxSegments = outlineRGB.rangeInside,target.pos,target.hitradius + p.hitradius + maxRange,Settings.maxSegments
						local Segments = (function() local seg = ((Radius * 2) * math.pi) / Settings.verticesSpacing if seg <= maxSegments then return seg else return maxSegments end end)()
						local alpha = rangeInside.a * alphaPercent
						Argus.addCircleFilled(pos.x, pos.y, pos.z, Radius, Segments,nil,
								GUI:ColorConvertFloat4ToU32(rangeInside.r,rangeInside.g,rangeInside.b,alpha),Settings.outlineThickness.range)
					end
				end
			end
		end

		local lastColorChange = Data.lastColorChange
		if TimeSince(lastColorChange) < 5000 then
			local pos,fill,a,outline,thickness = p.pos,Data.lastColorRGB,Data.lastColorAlpha,Data.lastLineRGB,Data.lastLineThickness
			if self.GUI.main_tabs.tabs[1].isselected then
				local Radius,angle = 8,90
				local Segments = (function() local seg = ((Radius * 2) * math.pi) / Settings.verticesSpacing if seg <= Settings.maxSegments then return seg else return Settings.maxSegments end end)()
				Argus.addConeFilled(pos.x, pos.y, pos.z, Radius, math.rad(angle), pos.h, Segments,
						GUI:ColorConvertFloat4ToU32(fill.r, fill.g, fill.b, a),
						GUI:ColorConvertFloat4ToU32(outline.r, outline.g, outline.b, outline.a), thickness)
			elseif self.GUI.main_tabs.tabs[3].isselected then
				local Radius = Settings.showHeadingMinRadius
				local Length = (Radius * 2) + Settings.showHeadingMinFront
				Argus.addRectFilled(pos.x, pos.y, pos.z, Length, Radius * 2, pos.h,GUI:ColorConvertFloat4ToU32(fill.r,fill.g,fill.b,a),GUI:ColorConvertFloat4ToU32(outline.r,outline.g,outline.b,outline.a),thickness)
			end
		end
		GUI:End()
		GUI:PopStyleColor()
	end
	if (self.GUI.main_tabs.tabs[4].isselected and (posX and posY and winX and winY)) or Settings.DebugLogPopOut then
		local DebugTypes,DebugTypesEnabled,DebugLog,DebugLogLimit,DebugLog12Hour,DebugLogPopOut,DebugLogPopOutCollapsed,DebugLogPopOutSize,DebugLogPopOutPos = Data.DebugTypes,Settings.DebugTypesEnabled,Data.DebugLog,Settings.DebugLogLimit,Settings.DebugLog12Hour,Settings.DebugLogPopOut,Settings.DebugLogPopOutCollapsed,Settings.DebugLogPopOutSize,Settings.DebugLogPopOutPos
		GUI:PushStyleVar(GUI.StyleVar_WindowMinSize,(function() if DebugLogPopOut then return 10 else return winX end end)(),(function() if DebugLogPopOut then return 10 else return winY end end)())
		local c = 0
		for k,v in pairs(WindowStyle) do if v[4] ~= 0 then c = c + 1 loadstring([[GUI:PushStyleColor(GUI.Col_]]..k..[[, ]]..(v[1]/255)..[[, ]]..(v[2]/255)..[[, ]]..(v[3]/255)..[[, ]]..v[4]..[[)]])() end end
		if not DebugLogPopOut then
			GUI:SetNextWindowPos(posX,posY + winY + 2,GUI.SetCond_Always)
			GUI:SetNextWindowSize(winX,winY,GUI.SetCond_Always)
		else
			GUI:SetNextWindowPos(DebugLogPopOutPos.x,DebugLogPopOutPos.y,GUI.SetCond_Appearing)
			GUI:SetNextWindowSize(DebugLogPopOutSize.x,DebugLogPopOutSize.y,GUI.SetCond_Appearing)
		end
		GUI:Begin("Moogle Telegraphs Log",true,(function() if not DebugLogPopOut then
			return GUI.WindowFlags_NoTitleBar + GUI.WindowFlags_NoResize + GUI.WindowFlags_NoMove + GUI.WindowFlags_NoScrollbar + GUI.WindowFlags_NoScrollWithMouse + GUI.WindowFlags_NoCollapse + GUI.WindowFlags_NoFocusOnAppearing
		else
			return GUI.WindowFlags_NoScrollbar
		end end)())
		GUI:BeginChild("##Moogle Telegraphs Log",0,0)
		GUI:PushStyleVar(GUI.StyleVar_FramePadding, Style.framepadding.x, 0)
		GUI:PushStyleVar(GUI.StyleVar_ItemSpacing, Style.itemspacing.x, 2)
		local count,height,ScrollY = #DebugLog,GUI:GetTextLineHeightWithSpacing(),GUI:GetScrollY()
		local start,x,y = ScrollY/height,GUI:GetContentRegionAvail()
		local bottom = start + (y / height)

		for i=1,count do
			if (i >= (start - 2)) and (i <= (bottom + 2)) then
				local line = DebugLog[i]
				if line.type then
					GUI:Selectable(line.line,false)
				end
			else
				GUI:NewLine()
			end
		end

		GUI:PopStyleVar(2)
		GUI:EndChild()
		GUI:End()
		GUI:PopStyleVar()
		GUI:PopStyleColor(c)
	end
end

RegisterEventHandler("Module.Initalize", self.Initialize, selfslong)
RegisterEventHandler("Gameloop.Update", self.Update, selfslong)
RegisterEventHandler("Gameloop.Draw", self.Draw, selfslong)