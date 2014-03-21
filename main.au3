#region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=lib\ico\icon.ico
#AutoIt3Wrapper_Compression=0
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_Res_requestedExecutionLevel=asInvoker
#endregion ;**** Directives created by AutoIt3Wrapper_GUI ****
$checkx64 = @AutoItX64
If $checkx64 = 1 Then
	WinSetOnTop("Diablo III", "", 0)
	MsgBox(0, "Erreur : ", "Script lanc� en x64, merci de lancer en x86 ")
	Terminate()
EndIf

$icon = @ScriptDir & "\lib\ico\icon.ico"
TraySetIcon($icon)



;;--------------------------------------------------------------------------------
;;      Initialize MouseCoords
;;--------------------------------------------------------------------------------"
Opt("MouseCoordMode", 2) ;1=absolute, 0=relative, 2=client


;;--------------------------------------------------------------------------------
;;      Initialize some Globals
;;--------------------------------------------------------------------------------

Global $D3Interop

Global $GameOverTime, $GameFailed, $ClickToMoveToggle, $d3, $Step, $a_range, $ResActivated, _
		$nb_die_t, $rdn_die_t, $ResLife, $Res_compt, $UsePath, $BanmonsterList, $File_Sequence, $TakeShrines

Global $Byte_NoItem_Identify, $Xp_Moy_Hrs, $ofs_objectmanager, $_MyGuid, $ofs_LocalActor_StrucSize, $_ActorAtrib_Count, _
		$_ActorAtrib_4, $ofs_ActorAtrib_StrucSize, $GrabListTab, $ofs_LocalActor_atribGUID, _
		$ofs_ActorDef, $ofs_MonsterDef, $_ofs_FileMonster_MonsterType, $_ofs_FileMonster_MonsterRace, _
		$_ofs_FileMonster_LevelNormal, $_ofs_FileMonster_LevelNightmare, $_ofs_FileMonster_LevelHell, _
		$_ofs_FileMonster_LevelInferno, $_defptr, $_defcount, $_deflink, $allSNOitems, $grablist, _
		$Byte_Full_Inventory[2], $Byte_Full_Stash[2], $Byte_Boss_TpDeny[2],$CurrentLoc


Global $AverageDps
Global $NbMobsKilled
$AverageDps=0 ; DPS constates
$NbMobsKilled=1 ; Nombre de Mobs crois�s

Global $BanTableActor = ""
Global $Count_ACD = 0
Global $Hero_Axe_Z = 10
Global $GetACD
Global $IgnoreItemList = ""
Global $nameCharacter
Global $timeforRightclick = 0
Global $timeForSpell1 = 0
Global $timeForSpell2 = 0
Global $timeForSpell3 = 0
Global $timeForSpell4 = 0
Global Const $PI = 3.141593
Global $Step = $PI / 6
Global $games = 1
Global $gamecounter = 0
Global $Try_ResumeGame = 0
Global $Try_Logind3 = 0
Global $disconnectcount = 0
Global $NeedRepairCount = 0
Global $Die2FastCount = 0
Global $timeforpotion = 0
Global $timeforclick = 0
Global $timeforskill = 0
Global $timedifmaxgamelength = 0
Global $timermaxgamelength = 0
Global $hotkeycheck = 0
Global $area = 0
Global $act = 0
Global $GameDifficulty = 0
Global $MP
Global $RepairTab = 0
Global $Paused
Global $GameOverTime = False
Global $DebugMessage
Global $fichierlog = "log-" & @YEAR & "_" & @MDAY & "_" & @MON & "_" & @HOUR & "h" & @MIN & ".txt"
Global $fichierstat = "stat_" & @YEAR & "_" & @MON & "_" & @MDAY & "-" & @HOUR & "h" & @MIN & ".txt"
Global $dif_timer_stat_formater = 0
Global $dif_timer_stat_moyen = 0
Global $Current_Hero_Z = 0
Local $posd3 = WinGetPos("Diablo III")
Global $grabskip = 0
Global $maxhp
Global $mousedownleft = 0
Global $Tp_Repair_And_Back = 0
Global $spell_gestini_verif = 0
Global $elite = 0
Global $handle_banlist1 = ""
Global $handle_banlist2 = ""
Global $handle_banlistdef = ""
Global $Ban_startstrItemList = "barbarian_|Demonhunter_|Monk_|WitchDoctor_|WD_|Enchantress_|Scoundrel_|Templar_|Wizard_|monsterAffix_|Demonic_|Generic_|fallenShaman_fireBall_impact|demonFlyer_B_clickable_corpse_01|grenadier_proj_trail"
Global $Ban_endstrItemList = "_projectile"
Global $Ban_ItemACDCheckList = "a1_|a3_|a2_|a4_|Lore_Book_Flippy|Topaz_|Emeraude_|Rubis_|Amethyste_|Console_PowerGlobe|GoldCoins|GoldSmall|GoldMedium|GoldLarge|healthPotion_Console"
;Global $IgnoreList = ""
$successratio = 1
$success = 0
$DebugX = $posd3[0] + $posd3[2] + 10
$DebugY = $posd3[1]
$Totalruns = 1
$Death = 0
$DeathCountToggle = True
$RepairORsell = 0
$ItemToStash = 0
$ItemToSell = 0
$GOLDInthepocket = 0
$GOLDINI = 0
$GOLD = 0
$GOLDMOY = 0
$GF = 0
$MF = 0
$PR = 0
$MS = 0
$GameFailed = 0
$grabtimeout = 0
$killtimeout = 0
$SkippedMove = 0
$GOLDMOYbyH = 0
$dif_timer_stat = 0
$begin_timer_stat = 0
$timer_stat_total = 0
$timer_stat_run_moyen = 0
;var xp
$NiveauParagon = 0
$ExperienceNextLevel = 0
$Expencours = 0
$Xp_Total = 0


Global $ClickableRec[4] = [0,0,0,0]
Global $SizeWindows = 0
Global $PointFinal[4] = [0,0,0,0]


CheckWindowD3()

WinSetOnTop("[CLASS:D3 Main Window Class]", "", 1)
;;--------------------------------------------------------------------------------
;;      Include some files
;;--------------------------------------------------------------------------------
#include "lib\sequence.au3"
#include "lib\settings.au3"
#include "lib\skills.au3"
#include "toolkit.au3"
;#include "GDI_scene.au3"
#include <WinAPI.au3>
#include "Lib\auto3Lib.au3"







;;================================================================================
;; Set Some Hotkey
;;================================================================================
HotKeySet("{F2}", "Terminate")
HotKeySet("{F3}", "TogglePause")

;;--------------------------------------------------------------------------------
;;      Initialize the offsets
;;--------------------------------------------------------------------------------
AdlibRegister("Die2Fast", 1200000)
offsetlist()

LoadingSNOExtended()

Func _dorun()
	_log("======== new run ==========")

	While Not offsetlist()
		Sleep(40)
	WEnd

	If $GameFailed = 0 Then
		$success += 1
	EndIf
	$successratio = $success / $Totalruns


	$GameFailed = 0
	$SkippedMove = 0
	$IgnoreItemList = ""

	StatsDisplay()

	If $hotkeycheck = 0 Then
		_log("CheckHotkeys init")
		CheckHotkeys()

		_log("Auto_Spell_init init")
		Auto_spell_init()
		_log("GestSpellInit")
		GestSpellInit()


		_log("LoadAttribGlobalStuff init")
		Load_Attrib_GlobalStuff()


		$maxhp = GetAttribute($_MyGuid, $Atrib_Hitpoints_Max_Total) ; dirty placement
		_log("Max HP : " & $maxhp)
		GetMaxResource($_MyGuid, $namecharacter)
		Send("t")
		Sleep(500)
		Detect_Str_full_inventory()
		CheckAndDefineSize()
	EndIf



	GetAct()
	Global $shrinebanlist = ""
	EmergencyStopCheck()



	If _checkRepair() Then
		NeedRepair()
	Else
		$NeedRepairCount = 0
	EndIf

	Sleep(100)

	enoughtPotions()
	init_sequence()

	sequence()

	Global $shrinebanlist = ""
	_log("End Run" & " gamefailled: " & $GameFailed)
	Return True
EndFunc   ;==>_dorun

Func _botting()
	_log("Start Botting")
	$bottingtime = TimerInit()

	While 1
		_log("new main loop")

		offsetlist()

		If _onloginscreen() Then
			_log("LOGIN")
			_logind3()
			Sleep(Random(60000, 120000))
		EndIf

		If _inmenu() And _onloginscreen() = False Then
			$DeathCountToggle = True
			_resumegame()
		EndIf

		While _onloginscreen() = False And _ingame() = False
			_log("Ingame False")
			If _checkdisconnect() Then
				$disconnectcount += 1
				_log("Disconnected dc4")
				Sleep(1000)
				_randomclick(398, 349)
				Sleep(1000)
				While Not (_onloginscreen() Or _inmenu())
					Sleep(Random(10000, 15000))
				WEnd
				ContinueLoop 2
			EndIf
			_resumegame()
		WEnd

		If _onloginscreen() = False And _playerdead() = False And _ingame() = True Then
			Global $timermaxgamelength = TimerInit()
			Global $GameOverTime = False
			If _dorun() = True Then
				$handle_banlist1 = ""
				$handle_banlist2 = ""
				$handle_banlistdef = ""
				$Try_ResumeGame = 0
				$Try_Logind3 = 0
				$games += 1
				$gamecounter += 1
			EndIf
		EndIf


		If _onloginscreen() = False And _intown() = False And _playerdead() = False Then
			GoToTown()
		EndIf

		_log("start GoToTown from main 2")
		If _intown() Or _playerdead() And _onloginscreen() = False Then
			If _playerdead() = False And $games >= ($repairafterxxgames + Random(-2, 2, 1)) Then
				StashAndRepair()
				$games = 0
			EndIf

			If Not _checkdisconnect() Then
				_leavegame()
			Else
				_log("Disconnected dc2")
				$disconnectcount += 1
				Sleep(1000)
				_randomclick(398, 349)
				_randomclick(398, 349)
			EndIf

			If _playerdead() Then
				Sleep(Random(11000, 13000))
			EndIf
		EndIf

		Sleep(1000)
		_log('loop _inmenu() = False And _onloginscreen()')

		While _inmenu() = False And _onloginscreen() = False
			Sleep(10)
				If  _checkdisconnect() Then
					Sleep(1000)
					ClickUI("Root.TopLayer.BattleNetModalNotifications_main.ModalNotification.Buttons.ButtonList", 2022)
					sleep(50)
					ClickUI("Root.TopLayer.BattleNetModalNotifications_main.ModalNotification.Buttons.ButtonList", 2022)
				endif
		WEnd

	WEnd
EndFunc   ;==>_botting

Func MarkPos()
	$currentloc = GetCurrentPos()
	ConsoleWrite($currentloc[0] & ", " & $currentloc[1] & ", " & $currentloc[2] & ",1,25" & @CRLF);
EndFunc   ;==>MarkPos

HotKeySet("{�}", "MarkPos")

Func MonsterListing()
	$Object = IterateObjectList(0)
	$foundtarget = 0
	ConsoleWrite("monster listing ===========================" & @CRLF)
	For $i = 0 To UBound($Object, 1) - 1
		_ArraySort($Object, 0, 0, 0, 8)
		ConsoleWrite($Object[$i][2] & @CRLF)
		If $Object[$i][1] <> 0xFFFFFFFF And $Object[$i][7] <> -1 And $Object[$i][8] < 100 Then
			ConsoleWrite($Object[$i][2] & @CRLF)
		EndIf
	Next
EndFunc   ;==>MonsterListing

HotKeySet("{�}", "MonsterListing")

Func Testing_IterateObjetcsList()

	Local $index, $offset, $count, $item[10]
	startIterateObjectsList($index, $offset, $count)

	While iterateObjectsList($index, $offset, $count, $item)

		For $i = 0 To UBound($item) - 1
			_log($item[$i])
		Next

		$ACD = GetACDOffsetByACDGUID($item[0])
		$CurrentIdAttrib = _memoryread($ACD + 0x120, $d3, "ptr");
		$quality = GetAttribute($CurrentIdAttrib, $Atrib_Item_Quality_Level)

		_log('quality : ' & $quality)
		_log("--------")
		_log("--------")
	WEnd
EndFunc   ;==>Testing_IterateObjetcsList



Func Testing()
CheckAndDefineSize()
Detect_Str_full_inventory()
Load_Attrib_GlobalStuff()
	SetItemLootLevel() ; should not be inside statsdisplay func
			SetSalvageLootLevel() ; should not be inside statsdisplay func
StashAndRepair()
_log("Finish")

EndFunc   ;==>Testing ##*******##*******##*******##*******##*******##*******##*******##*******##*******##*******##*******##*******###




Func CheckAndDefineSize()
	if $SizeWindows = 0 Then
		$SizeWindows = WinGetClientSize("[CLASS:D3 Main Window Class]")
		_log("Size Windows X : " & $SizeWindows[0] & " - Y : " & $SizeWindows[1])
	EndIF

	if $ClickableRec[0] = 0 AND $ClickableRec[1] = 0 AND $ClickableRec[2] = 0 AND $ClickableRec[3] = 0 Then

		;$result = GetOfsUI("Root.NormalLayer.game_notify_dialog_backgroundScreen.dlg_new_paragon.button", 0)
		$OfsBtnParagon = GetOfsFastUI("Root.NormalLayer.game_notify_dialog_backgroundScreen.dlg_new_paragon.button", 1028)
		Dim $TruePointBtnParagon = GetPositionUI($OfsBtnParagon)
		Dim $PointParagon = GetUIRectangle($TruePointBtnParagon[0], $TruePointBtnParagon[1], $TruePointBtnParagon[2], $TruePointBtnParagon[3])

		;$result = GetOfsUI("Root.NormalLayer.eventtext_bkgrnd.eventtext_region.checkbox", 0)
		$OfsBtnCheckBox = GetOfsFastUI("Root.NormalLayer.eventtext_bkgrnd.eventtext_region.checkbox", 31)
		Dim $TruePointCheckBox = GetPositionUI($OfsBtnCheckBox)
		Dim $PointCheckBox = GetUIRectangle($TruePointCheckBox[0], $TruePointCheckBox[1], $TruePointCheckBox[2], $TruePointCheckBox[3])

		;$result = GetOfsUI("Root.NormalLayer.portraits.stack.party_stack.portrait_0.Background", 0)
		$OfsPortrait = GetOfsFastUI("Root.NormalLayer.portraits.stack.party_stack.portrait_0.Background", 707)
		Dim $TruePointPortrait = GetPositionUI($OfsPortrait)
		Dim $PointPortrait = GetUIRectangle($TruePointPortrait[0], $TruePointPortrait[1], $TruePointPortrait[2], $TruePointPortrait[3])

		$PointFinal[0] = $PointPortrait[3] + $PointPortrait[0]
		$PointFinal[1] = $PointPortrait[2] + $PointPortrait[1]
		$PointFinal[2] = $PointCheckBox[0] - $PointFinal[1]
		$PointFinal[3] = $PointParagon[1] - $PointFinal[0]

		_log("Zone Clickable -> Y[0] : " & $PointFinal[0] & " - X[1] : " & $PointFinal[1] & " - Width[2] : " & $PointFinal[2] & " - Height[3] : " & $PointFinal[3])
	EndIF
EndFunc





Func Checkclickable($coord)

		if $coord[1] <= $PointFinal[0] Then
			$coord[1] = $PointFinal[0] + 1
		Elseif $coord[1] >= ($PointFinal[0] + $PointFinal[3]) Then
			$coord[1] =  ($PointFinal[0] + $PointFinal[3]) - 1
		EndIF

		if $coord[0] <= $PointFinal[1] Then
			$coord[0] = $PointFinal[1] + 1
		Elseif $coord[0] >= ($PointFinal[1] + $PointFinal[2]) Then
			$coord[0] = ($PointFinal[1] + $PointFinal[2]) - 1
		EndIF

		return $coord
EndFunc

Func ClickInventory($c, $l)
	$result = GetOfsFastUI("Root.NormalLayer.inventory_dialog_mainPage.timer slot 0 x0 y0", 1509)
	Dim $Point = GetPositionUI($result)
	Dim $Point2 = GetUIRectangle($Point[0], $Point[1], $Point[2], $Point[3])

	$FirstCaseX = $Point2[0] + $Point2[2] / 2
	$FirstCaseY = $Point2[1] + $Point2[3] / 2

	$SizeCaseX =  $Point2[2]
	$SizeCaseY =  $Point2[3]

	$XCoordinate = $FirstCaseX + $c * $SizeCaseX
	$YCoordinate = $FirstCaseY + $l * $SizeCaseY

	MouseClick("right", $XCoordinate, $YCoordinate)
EndFunc

;###########################################################################
;###########################################################################
;###########################################################################
;####################################################################
;###########################################################################
;###########################################################################


Global $Scene_table_totale[1][10]
Global $NavCell_table_totale[1][10]
Global $Scene_table_id_scene[1]
#cs
Func Read_Scene()

	$nb_totale_scene_record = 0
	$up = False

	While 1

		$ObManStoragePtr = _MemoryRead($ofs_objectmanager, $d3, "ptr")
		$offset = $ObManStoragePtr + 0x794 + 0x178
		$sceneCountPtr = _MemoryRead($offset, $d3, "ptr") + 0x108
		$countScene = _MemoryRead($sceneCountPtr, $d3, "int")

		$sceneFirstPtr = _MemoryRead($offset, $d3, "ptr") + 0x148
		Dim $obj_scene[1][10]
		$count = 0

		;################################## ITERATION OBJ SCENE ########################################
		For $i = 0 To $countScene
			$scenePtr = _MemoryRead($sceneFirstPtr, $d3, "ptr") + $i * 0x2A8

			$temp_id_world = _MemoryRead($scenePtr + 0x008, $d3, "ptr") ;id world
			$temp_id_scene = _MemoryRead($scenePtr, $d3, "ptr") ;id world
			$correlation = True



			If $temp_id_world = $_MyACDWorld And $temp_id_scene <> 0xFFFFFFFF Then;id world

				If $nb_totale_scene_record = 0 Then
					$Scene_table_id_scene[0] = $temp_id_scene
					$nb_totale_scene_record += 1
				Else
					For $a = 0 To UBound($Scene_table_id_scene) - 1
						If $Scene_table_id_scene[$a] = $temp_id_scene Then
							$correlation = False
							ExitLoop
						EndIf
					Next
					If $correlation = True Then
						$Ucount = UBound($Scene_table_id_scene)
						ReDim $Scene_table_id_scene[$Ucount + 1]
						$Scene_table_id_scene[$Ucount] = $temp_id_scene
					EndIf
				EndIf

				If $correlation = True Then

					$nb_totale_scene_record += 1
					$count += 1
					ReDim $obj_scene[$count][10]

					$obj_scene[$count - 1][0] = $temp_id_scene ;id_scene
					$scenePtr += 0x004
					$obj_scene[$count - 1][1] = $temp_id_world ;id world
					$obj_scene[$count - 1][2] = _MemoryRead($scenePtr + 0x014, $d3, "int") ;sno_levelarea
					$obj_scene[$count - 1][3] = _MemoryRead($scenePtr + 0x0D8, $d3, "ptr") ;id_sno_scene

					$obj_scene[$count - 1][4] = _MemoryRead($scenePtr + 0x0EC, $d3, "float") ;Vec2 Meshmin x
					$obj_scene[$count - 1][5] = _MemoryRead($scenePtr + 0x0F0, $d3, "float") ;Vec2 Meshmin y
					$obj_scene[$count - 1][6] = _MemoryRead($scenePtr + 0x0F4, $d3, "float") ;Vec2 Meshmin z

					$obj_scene[$count - 1][7] = _MemoryRead($scenePtr + 0x164, $d3, "float") ;Vec2 Meshmax x
					$obj_scene[$count - 1][8] = _MemoryRead($scenePtr + 0x168, $d3, "float") ;Vec2 Meshmax y
					$obj_scene[$count - 1][9] = _MemoryRead($scenePtr + 0x16C, $d3, "float") ;Vec2 Meshmax z


					ReDim $Scene_table_totale[$nb_totale_scene_record][10]

					$Scene_table_totale[$nb_totale_scene_record - 1][0] = $obj_scene[$count - 1][0]
					$Scene_table_totale[$nb_totale_scene_record - 1][1] = $obj_scene[$count - 1][1]
					$Scene_table_totale[$nb_totale_scene_record - 1][2] = $obj_scene[$count - 1][2]
					$Scene_table_totale[$nb_totale_scene_record - 1][3] = $obj_scene[$count - 1][3]
					$Scene_table_totale[$nb_totale_scene_record - 1][4] = $obj_scene[$count - 1][4]
					$Scene_table_totale[$nb_totale_scene_record - 1][5] = $obj_scene[$count - 1][5]
					$Scene_table_totale[$nb_totale_scene_record - 1][6] = $obj_scene[$count - 1][6]
					$Scene_table_totale[$nb_totale_scene_record - 1][7] = $obj_scene[$count - 1][7]
					$Scene_table_totale[$nb_totale_scene_record - 1][8] = $obj_scene[$count - 1][8]
					$Scene_table_totale[$nb_totale_scene_record - 1][9] = $obj_scene[$count - 1][9]


				EndIf


			EndIf

		Next
		;################################################################################################


		Dim $list_sno_scene = IndexSNO(0x18EDF60, 0)


		;############################## ITERATION DU SNO ################################################
		For $i = 1 To UBound($list_sno_scene) - 1
			$correlation = False
			$current_obj_scene = 0

			For $x = 0 To UBound($obj_scene) - 1
				If $list_sno_scene[$i][1] = $obj_scene[$x][3] Then
					$correlation = True
					$current_obj_scene = $x
				EndIf
			Next

			If $correlation Then
				$NavMeshDef = $list_sno_scene[$i][0] + 0x040
				$NavZoneDef = $list_sno_scene[$i][0] + 0x280

				;############## ITERATION DES NAVCELL ################
				$CountNavCell = _memoryRead($NavZoneDef, $d3, "int")
				$NavCellPtr = _memoryRead($NavZoneDef + 0x08, $d3, "ptr")

				If $CountNavCell <> 0 Then
					Dim $Navcell_Table[$CountNavCell][9]
					Local $NavCellStruct = DllStructCreate("float;float;float;float;float;float;short;short;int")

					For $t = 0 To $CountNavCell - 1

						DllCall($d3[0], 'int', 'ReadProcessMemory', 'int', $d3[1], 'int', $NavCellPtr + ($t * 0x20), 'ptr', DllStructGetPtr($NavCellStruct), 'int', DllStructGetSize($NavCellStruct), 'int', '')

						If Mod(DllStructGetData($NavCellStruct, 7), 2) = 1 Then
							$flag = 1
						Else
							$flag = 0
						EndIf

						If UBound($NavCell_table_totale) - 1 = 0 And $up = False Then
							$up = True
						Else
							ReDim $NavCell_table_totale[UBound($NavCell_table_totale) + 1][10]
						EndIf

						$num = UBound($NavCell_table_totale) - 1
						$NavCell_Table_Totale[$num][0] = DllStructGetData($NavCellStruct, 1)
						$NavCell_Table_Totale[$num][1] = DllStructGetData($NavCellStruct, 2)
						$NavCell_Table_Totale[$num][2] = DllStructGetData($NavCellStruct, 3)
						$NavCell_Table_Totale[$num][3] = DllStructGetData($NavCellStruct, 4)
						$NavCell_Table_Totale[$num][4] = DllStructGetData($NavCellStruct, 5)
						$NavCell_Table_Totale[$num][5] = DllStructGetData($NavCellStruct, 6)
						$NavCell_Table_Totale[$num][6] = $flag
						$NavCell_Table_Totale[$num][7] = DllStructGetData($NavCellStruct, 8)
						$NavCell_Table_Totale[$num][8] = DllStructGetData($NavCellStruct, 9)
						$NavCell_Table_Totale[$num][9] = $obj_scene[$current_obj_scene][0]
					Next
				Else

					For $a = 0 To UBound($Scene_table_id_scene) - 1
						If $Scene_table_id_scene[$a] = $obj_scene[$current_obj_scene][0] Then
							_ArrayDelete($Scene_table_id_scene, $a)
							ExitLoop
						EndIf
					Next

					For $a = 0 To UBound($Scene_table_totale) - 1
						If $Scene_table_totale[$a][0] = $obj_scene[$current_obj_scene][0] Then
							_Array2DDelete($Scene_table_totale, $a)
							$nb_totale_scene_record -= 1
							ExitLoop
						EndIf
					Next

				EndIf

			EndIf
		Next

		_log("fin Iteration")
		Sleep(500)
	WEnd

EndFunc   ;==>Read_Scene
#ce

#cs
Func Drawn()
	_log("taille du tab Scene-> " & UBound($Scene_table_totale))
	_log("taille du tab NavCell-> " & UBound($NavCell_Table_Totale))
	;_ArrayDisplay($Scene_table_id_scene)
	Dim $buffMax[2] = [0, 0]
	Dim $buffMin[2] = [999999999, 99999999]
	Dim $indexMax[2] = [0, 0] ; 0 -> Index MeshMax X le plus grand | 1 -> Index MEshMax Y le plus grand
	Dim $indexMin[2] = [999999999, 99999999]

	For $i = 0 To UBound($Scene_table_totale) - 1
		If $buffMax[0] < $Scene_table_totale[$i][7] Then
			$buffMax[0] = $Scene_table_totale[$i][7]
			$indexMax[0] = $i
		EndIf

		If $buffMin[0] > $Scene_table_totale[$i][4] Then
			$buffMin[0] = $Scene_table_totale[$i][4]
			$indexMin[0] = $i
		EndIf


		If $buffMax[1] < $Scene_table_totale[$i][8] Then
			$buffMax[1] = $Scene_table_totale[$i][8]
			$indexMax[1] = $i
		EndIf

		If $buffMin[1] > $Scene_table_totale[$i][5] Then
			$buffMin[1] = $Scene_table_totale[$i][5]
			$indexMin[1] = $i
		EndIf
	Next

	Initiate_GDIpicture($Scene_table_totale[$indexMax[1]][8] - $Scene_table_totale[$indexMin[1]][5], $Scene_table_totale[$indexMax[0]][7] - $Scene_table_totale[$indexMin[0]][4])



	For $i = 0 To UBound($Scene_table_totale) - 1
		For $y = 0 To UBound($NavCell_Table_Totale) - 1

			If $Scene_table_totale[$i][0] = $NavCell_Table_Totale[$y][9] Then

				;_arraydisplay($NavCell_Table_Totale)

				$vx = ($Scene_table_totale[$i][4] - $Scene_table_totale[$indexMin[0]][4]) + $NavCell_Table_Totale[$y][0]
				$vy = ($Scene_table_totale[$i][5] - $Scene_table_totale[$indexMin[1]][5]) + $NavCell_Table_Totale[$y][1]

				;_log($i & "-" &  $y)
				;_arraydisplay($NavCell_Table_Totale)
				$tx = $NavCell_Table_Totale[$y][3] - $NavCell_Table_Totale[$y][0]
				$ty = $NavCell_Table_Totale[$y][4] - $NavCell_Table_Totale[$y][1]
				$flag = $NavCell_Table_Totale[$y][6]

				;_log($vx & " - " & $vy)
				;_log($tx & " - " & $ty)

				Draw_Nav($vy, $vx, $flag, $ty, $tx)

			EndIf
		Next

		;Draw_Nav(($Scene_table_totale[$i][5] - $Scene_table_totale[$indexMin[1]][5]), ($Scene_table_totale[$i][4] - $Scene_table_totale[$indexMin[0]][4]), 3, $Scene_table_totale[$i][8] - $Scene_table_totale[$i][5], $Scene_table_totale[$i][7] - $Scene_table_totale[$i][4])
	Next

	Save_GDIpicture()
	Load_GDIpicture()
EndFunc   ;==>Drawn
#ce

HotKeySet("{F1}", "Testing")
HotKeySet("{F4}", "Testing_IterateObjetcsList")

;HotKeySet("{F6}", "Read_Scene")
;HotKeySet("{F7}", "Drawn")

If $Devmode <> "true" Then
	_botting()
EndIf

While 1
sleep(5)
WEnd

;;--------------------------------------------------------------------------------
;;     Check KeyTo avoid sell of equiped stuff
;;--------------------------------------------------------------------------------
Func CheckHotkeys()
	Sleep(2000)
	Send("i")
	Sleep(500)
	If _checkInventoryopen() = False Then
		WinSetOnTop("Diablo III", "", 0)
		MsgBox(0, "Mauvais Hotkey", "La touche pour ouvrir l'inventaire doit �tre i" & @CRLF)
		Terminate()
	EndIf
	Sleep(185)
	Send("{SPACE}") ; make sure we close everything
	Sleep(170)
	If _checkInventoryopen() = True Then
		WinSetOnTop("Diablo III", "", 0)
		MsgBox(0, "Mauvais Hotkey", "La touche pour fermer les fen�tres doit �tre ESPACE" & @CRLF)
		Terminate()
	EndIf
	ConsoleWrite("Check des touches OK" & @CRLF)
	$hotkeycheck = 1
EndFunc   ;==>CheckHotkeys


;;--------------------------------------------------------------------------------
;;     Initialise Buffs while in training Area
;;--------------------------------------------------------------------------------
Func Buffinit()
	If $delaiBuff1 Then
		AdlibRegister("buff1", $delaiBuff1 * Random(1, 1.2))

	EndIf
	If $PreBuff1 = "true" Then
		buff1()
		Sleep(150)
	EndIf
	If $delaiBuff2 Then
		AdlibRegister("buff2", $delaiBuff2 * Random(1, 1.2))

	EndIf
	If $PreBuff2 = "true" Then
		buff2()
		Sleep(150)
	EndIf
	If $delaiBuff3 Then
		AdlibRegister("buff3", $delaiBuff3 * Random(1, 1.2))

	EndIf
	If $PreBuff3 = "true" Then
		buff3()
		Sleep(150)
	EndIf
	If $delaiBuff4 Then
		AdlibRegister("buff4", $delaiBuff4 * Random(1, 1.2))

	EndIf
	If $PreBuff4 = "true" Then
		buff4()
		Sleep(150)
	EndIf
EndFunc   ;==>Buffinit



;;--------------------------------------------------------------------------------
;;     Stop All buff timers
;;--------------------------------------------------------------------------------
Func UnBuff()
	If $delaiBuff1 Then
		AdlibUnRegister("buff1")
	EndIf
	If $delaiBuff2 Then
		AdlibUnRegister("buff2")
	EndIf
	If $delaiBuff3 Then
		AdlibUnRegister("buff3")
	EndIf
	If $delaiBuff4 Then
		AdlibUnRegister("buff4")
	EndIf
EndFunc   ;==>UnBuff
Func buff1()
	Send($ToucheBuff1)
EndFunc   ;==>buff1
Func buff2()
	Send($ToucheBuff2)
EndFunc   ;==>buff2
Func buff3()
	Send($ToucheBuff3)
EndFunc   ;==>buff3
Func buff4()
	Send($ToucheBuff4)
EndFunc   ;==>buff4
