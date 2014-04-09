#region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=lib\ico\icon.ico
#AutoIt3Wrapper_Compression=0
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_Res_requestedExecutionLevel=asInvoker
#endregion ;**** Directives created by AutoIt3Wrapper_GUI ****
$checkx64 = @AutoItX64
If $checkx64 = 1 Then
	WinSetOnTop("Diablo III", "", 0)
	MsgBox(0, "Erreur : ", "Script lancé en x64, merci de lancer en x86 ")
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
$NbMobsKilled=1 ; Nombre de Mobs croisés

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
Global $Ban_startstrItemList = "treasureGoblin_A_Sl|DH_|x1_DemonHunter|D3Arrow|barbarian_|Demonhunter_|Monk_|WitchDoctor_|WD_|Enchantress_|Scoundrel_|Templar_|Wizard_|monsterAffix_|Demonic_|Generic_|fallenShaman_fireBall_impact|demonFlyer_B_clickable_corpse_01|grenadier_proj_trail"
Global $Ban_endstrItemList = "_projectile"
Global $Ban_ItemACDCheckList = "a1_|a3_|a2_|a4_|a5_|Lore_Book_Flippy|D3Arrow|Topaz_|Emeraude_|Rubis_|Amethyste_|Console_PowerGlobe|GoldCoin|GoldSmall|GoldMedium|GoldLarge|healthPotion_Console"
Global $My_FastAttributeGroup
;Global $IgnoreList = ""
$successratio = 1
$success = 0



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
$DebugX = $posd3[0] + $posd3[2] + 10
$DebugY = $posd3[1]

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

;	While Not offsetlist()
;		Sleep(40)
;	WEnd

;foxey
	Local $hTimer = TimerInit()
        While Not offsetlist() And TimerDiff($hTimer) < 60000 ; 60secondes
                        Sleep(40)
        WEnd

        Sleep(3000)

        If TimerDiff($hTimer) >= 60000 Then
                        Return False
	EndIf
;foxey

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
			_log("Ingame False !")
			If _checkdisconnect() Then
				$disconnectcount += 1
				_log("Disconnected dc4")
			Sleep(1000)
			ClickUI("Root.TopLayer.BattleNetModalNotifications_main.ModalNotification.Buttons.ButtonList", 2022)
			sleep(50)
			ClickUI("Root.TopLayer.BattleNetModalNotifications_main.ModalNotification.Buttons.ButtonList", 2022)
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
			ClickUI("Root.TopLayer.BattleNetModalNotifications_main.ModalNotification.Buttons.ButtonList", 2022)
			sleep(50)
			ClickUI("Root.TopLayer.BattleNetModalNotifications_main.ModalNotification.Buttons.ButtonList", 2022)
			Sleep(1000)
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
					Sleep(1000)
				endif
		WEnd

	WEnd
EndFunc   ;==>_botting

Func MarkPos()
	$currentloc = GetCurrentPos()
	ConsoleWrite($currentloc[0] & ", " & $currentloc[1] & ", " & $currentloc[2] & ",1,25" & @CRLF);
EndFunc   ;==>MarkPos

HotKeySet("{ù}", "MarkPos")

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

HotKeySet("{µ}", "MonsterListing")

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
offsetlist()
GetAct()
;Is_PlayerRdy()


;mesurestart()
;IterateCACDV2()
;mesureend("blabla")
;Dim $test = IterateFilterAttackv5()
;_ArrayDisplay($test)

;dim $IterateCaveArray = IterateCave()
;_ArrayDisplay($IterateCaveArray)

;GetCave()
;_ArrayDisplay($RecordCave)

EndFunc   ;==>Testing ##*******##*******##*******##*******##*******##*******##*******##*******##*******##*******##*******##*******###


Func VerifAct($num)
	$CurrentAct = GetNumActByWPUI()
	$ActRequired = GetNumActByWPNumber($num)

	if $CurrentAct = $ActRequired Then
		return true
	Else
		SwitchAct($ActRequired)
	EndIF
EndFunc

Func SwitchAct($num)

	Switch $num
		Case 1
			$bucket = 725
		Case 2
			$bucket = 407
		Case 3
			$bucket = 844
		Case 4
			$bucket = 817
		Case 5
			$bucket = 1713
	EndSwitch

	clickUI("Root.NormalLayer.WaypointMap_main.LayoutRoot.OverlayContainer.Zoom.ZoomOut", 942)
	sleep(500)
	ClickUI("Root.NormalLayer.WaypointMap_main.LayoutRoot.OverlayContainer.WorldMap.Act" & $num & "Open.LayoutRoot.Name", $bucket)
	sleep(500)

EndFunc

Func GetNumActByWPUI()
	if fastcheckuiitemvisible("Root.NormalLayer.WaypointMap_main.LayoutRoot.OverlayContainer.POI.entry 0.LayoutRoot.Interest", 1, 1363) Then
		_log("Act1 Detected")
		return 1
	ElseIf fastcheckuiitemvisible("Root.NormalLayer.WaypointMap_main.LayoutRoot.OverlayContainer.POI.entry 18.LayoutRoot.Interest", 1, 1472) Then
		_log("Act2 Detected")
		return 2
	ElseIf fastcheckuiitemvisible("Root.NormalLayer.WaypointMap_main.LayoutRoot.OverlayContainer.POI.entry 26.LayoutRoot.Interest", 1, 421) Then
		_log("Act3 Detected")
		return 3
	ElseIf fastcheckuiitemvisible("Root.NormalLayer.WaypointMap_main.LayoutRoot.OverlayContainer.POI.entry 39.LayoutRoot.Interest", 1, 565) Then
		_log("Act4 Detected")
		return 4
	ElseIf fastcheckuiitemvisible("Root.NormalLayer.WaypointMap_main.LayoutRoot.OverlayContainer.POI.entry 46.LayoutRoot.Interest", 1, 1113) Then
		_log("Act5 Detected")
		return 5
	EndIf
EndFunc

Func GetNumActByWPNumber($num)
	if $num <= 17 Then
		_log("Act1 Required")
		return 1
	ElseIf $num <= 25 Then
		_log("Act2 Required")
		return 2
	ElseIf $num <= 38 Then
		_log("Act3 Required")
		return 3
	ElseIf $num <= 45 Then
		_log("Act4 Required")
		return 4
	Else
		_log("Act5 Required")
		return 5
	EndIF
EndFunc


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


HotKeySet("{F1}", "Testing")
HotKeySet("{F4}", "Testing_IterateObjetcsList")

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
		MsgBox(0, "Mauvais Hotkey", "La touche pour ouvrir l'inventaire doit être i" & @CRLF)
		Terminate()
	EndIf
	Sleep(185)
	Send("{SPACE}") ; make sure we close everything
	Sleep(170)
	If _checkInventoryopen() = True Then
		WinSetOnTop("Diablo III", "", 0)
		MsgBox(0, "Mauvais Hotkey", "La touche pour fermer les fenêtres doit être ESPACE" & @CRLF)
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



Func GiveBucketWp($num)

	_log("Num : " & $num)

	$bucket = ""

	Switch $num

		Case 0
			$bucket =  "1363"

		Case 1
			$bucket = "378"

		Case 2
			$bucket = "995"

		Case 3
			$bucket = "1450"

		Case 4
			$bucket = "61"

		Case 5
			$bucket = "1562"

		Case 6
			$bucket = "265"

		Case 7
			$bucket = "1581"

		Case 8
			$bucket = "597"

		Case 9
			$bucket = "1310"

		Case 10
			$bucket = "883"

		Case 11
			$bucket = "612"

		Case 12
			$bucket = "980"

		Case 13
			$bucket = "49"

		Case 14
			$bucket = "1808"

		Case 15
			$bucket = "441"

		Case 16
			$bucket = "4"

		Case 17
			$bucket = "1538"

		Case 18
			$bucket = "1472" ;home act2

		Case 19
			$bucket = "536"

		Case 20
			$bucket = "667"

		Case 21
			$bucket = "1766"

		Case 22
			$bucket = "689"

		Case 23
			$bucket = "501"

		Case 24
			$bucket = "1249"

		Case 25
			$bucket = "28"

		Case 26
			$bucket = "421" ; HOME Act 3

		Case 27
			$bucket = "1745"

		Case 28
			$bucket = "539"

		Case 29
			$bucket = "1711"

		Case 30
			$bucket = "898"

		Case 31
			$bucket = "1317"

		Case 32
			$bucket = "945"

		Case 33
			$bucket = "364"

		Case 34
			$bucket = "923"

		Case 35
			$bucket = "503"

		Case 36
			$bucket = "631"

		Case 37
			$bucket = "613"

		Case 38
			$bucket = "1477"


		Case 39
			$bucket = "565" ;Home Act 4

		Case 40
			$bucket = "1664"

		Case 41
			$bucket = "1697"

		Case 42
			$bucket = "431"

		Case 43
			$bucket = "1045"

		Case 44
			$bucket = "1185"

		Case 45
			$bucket = "61"

		Case 46
			$bucket = "1113" ;Home act 5

		Case 47
			$bucket = "369"

		Case 48
			$bucket = "850"

		Case 49
			$bucket = "1062"

		Case 50
			$bucket = "162"

		Case 51
			$bucket = "348"

		Case 52
			$bucket = "785"

		Case 53
			$bucket = "192"

		Case 54
			$bucket = "820"

		Case 55
			$bucket = "1"

	EndSwitch

_log("RETURN : " & $bucket)

	return $bucket

EndFunc


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
