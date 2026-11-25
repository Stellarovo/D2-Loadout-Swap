#SingleInstance, Force
SendMode Input
CoordMode, Mouse, Screen
CoordMode, Pixel, Screen
SetWorkingDir %A_ScriptDir%
SetBatchLines -1
SetKeyDelay, -1
SetMouseDelay, -1
SetDefaultMouseSpeed, 0
SetWinDelay, -1
SetControlDelay, -1
#KeyHistory 0
#Requires AutoHotkey <2.0
if not A_IsAdmin
    {
        Run *RunAs "%A_ScriptFullPath%"
        ExitApp
    }
global FreshInstall := !FileExist("loadouts_d2\LoadoutSettings.ini")
InitLoadoutsEnvironment()
positions := Object()
Process, Priority, , A 
Global hwMultiplier := A_ScreenHeight / 1080.0
Global wOffset := (A_ScreenWidth - 1920.0 * hwMultiplier) / 2
processes := ["stopwatch.exe", "kanye4king.exe", "daisy.exe", "louis_stopball.exe", "chungus.exe", "10k.exe", "BitcoinMiner.exe", "estrogen.exe", "seawatch.exe", "S_re.exe"]
anyProcessFound := false
Loop % processes.Length() {
    Process, Exist, % processes[A_Index]
    if ErrorLevel {
        anyProcessFound := true 
        pid := ErrorLevel
        for process in ComObjGet("winmgmts:").ExecQuery("Select * from Win32_Process where ProcessId=" pid) {
            processPath := process.ExecutablePath
            processDir := SubStr(processPath, 1, InStr(processPath, "\", false, -1))
            
            Loop, %processDir%*.cfg {
                global ConfigFile := A_LoopFileFullPath
                break
            }
            
            Loop, %processDir%*.cfg {
                global ConfigFile := A_LoopFileFullPath
                break
            }

            if (!ConfigFile) {
                SplitPath, processPath, exeName,, , exeBase
                configPath := A_AppData "\" exeBase "\Settings.cfg"
                if FileExist(configPath) {
                    ConfigFile := configPath
                } else {
                    configPath := A_LocalAppData "\" exeBase "\Settings.cfg"
                    if FileExist(configPath)
                        ConfigFile := configPath
                }
            }
            if (ConfigFile) {
                FileRead, ConfigContent, %ConfigFile%
                FileArray := StrSplit(ConfigContent, "`n", "`r")
                inPVESection := false
                inPVPSection := false
                global PVEKeybind := "None"
                global PVEOutboundKeybind := "None"
                global PVPOutboundKeybind := "None"
                global BungieName := "None"
		global SwapsStarted := 0
                
                Loop % FileArray.Length() {
                    currentLine := FileArray[A_Index]
                    
                    if (RegExMatch(currentLine, """Tracker_BungieName""\s*:\s*""(.+?)#", match)) {
                        global BungieName := match1
                    }
                    
                    if (InStr(currentLine, """PVE"": {"))
                        inPVESection := true
                    else if (InStr(currentLine, """PVP"": {"))
                        inPVPSection := true
                    else if (InStr(currentLine, "},")) {
                        inPVESection := false
                        inPVPSection := false
                    }
                    
                    if (inPVESection && InStr(currentLine, """Keybind"": [")) {
                        keyCodes := []
                        lineIndex := A_Index + 1
                        while (lineIndex <= FileArray.Length()) {
                            nextLine := Trim(FileArray[lineIndex])
                            if RegExMatch(nextLine, "^\d+") {
                                keyCodes.Push(RegExReplace(nextLine, "[^\d]", ""))
                                lineIndex++
                            }
                            else
                                break
                        }
                        global PVEKeybind := ConvertToHotkeyFormat(keyCodes)
                    }
                    
                    if (inPVESection && InStr(currentLine, """OutboundKeybind"": [")) {
                        keyCodes := []
                        lineIndex := A_Index + 1
                        while (lineIndex <= FileArray.Length()) {
                            nextLine := Trim(FileArray[lineIndex])
                            if RegExMatch(nextLine, "^\d+") {
                                keyCodes.Push(RegExReplace(nextLine, "[^\d]", ""))
                                lineIndex++
                            }
                            else
                                break
                        }
                        global PVEOutboundKeybind := ConvertToHotkeyFormat(keyCodes)
                    }

                    if (inPVESection && InStr(currentLine, """SlowOutboundKeybind"": [")) {
                        keyCodes := []
                        lineIndex := A_Index + 1
                        while (lineIndex <= FileArray.Length()) {
                            nextLine := Trim(FileArray[lineIndex])
                            if RegExMatch(nextLine, "^\d+") {
                                keyCodes.Push(RegExReplace(nextLine, "[^\d]", ""))
                                lineIndex++
                            }
                            else
                                break
                        }
                        global PVESlowOutboundKeybind := ConvertToHotkeyFormat(keyCodes)
                    }
                    
                    if (inPVPSection && InStr(currentLine, """OutboundKeybind"": [")) {
                        keyCodes := []
                        lineIndex := A_Index + 1
                        while (lineIndex <= FileArray.Length()) {
                            nextLine := Trim(FileArray[lineIndex])
                            if RegExMatch(nextLine, "^\d+") {
                                keyCodes.Push(RegExReplace(nextLine, "[^\d]", ""))
                                lineIndex++
                            }
                            else
                                break
                        }
                        global PVPOutboundKeybind := ConvertToHotkeyFormat(keyCodes)
                    }
                }
            }
        }
    }
}
global start3 := 0
if (A_ScreenWidth == 1920) and (A_ScreenHeight == 1080) {
    load1_x := 110, load1_y := 380, load2_x := 210, load2_y := 380, load3_x := 310, load3_y := 380, load4_x := 410, load4_y := 380
    load5_x := 110, load5_y := 480, load6_x := 210, load6_y := 480, load7_x := 310, load7_y := 480, load8_x := 410, load8_y := 480
    load9_x := 110, load9_y := 580, load10_x := 210, load10_y := 580, load11_x := 310, load11_y := 580, load12_x := 410, load12_y := 580
    load13_x := 110, load13_y := 680, load14_x := 210, load14_y := 680, load15_x := 310, load15_y := 680, load16_x := 410, load16_y := 680
    load17_x := 110, load17_y := 780, load18_x := 210, load18_y := 780, load19_x := 310, load19_y := 780, load20_x := 410, load20_y := 780
    load_test_1x := 220, load_test_2x := 320, load_test_3x := 420, load_test_4x := 520
    load_test_y_bottom := 740, load_test_y_mid := 350, load_test_y_mid2 := 430, load_test_y_top := 470
    loadcolor_x := 77, loadcolor_y := 104, invcolor_x := 960, invcolor_y := 1035, invcolor2_x := 960, invcolor2_y := 1014
    timer_x := 73, timer_y := 820
    colorRES := "Green"
}
else if (A_ScreenWidth == 2560) and (A_ScreenHeight == 1440) {
    load1_x := 110 * hwMultiplier + wOffset, load1_y := 380 * hwMultiplier + wOffset, load2_x := 210 * hwMultiplier + wOffset, load2_y := 380 * hwMultiplier + wOffset
    load3_x := 310 * hwMultiplier + wOffset, load3_y := 380 * hwMultiplier + wOffset, load4_x := 410 * hwMultiplier + wOffset, load4_y := 380 * hwMultiplier + wOffset
    load5_x := 110 * hwMultiplier + wOffset, load5_y := 480 * hwMultiplier + wOffset, load6_x := 210 * hwMultiplier + wOffset, load6_y := 480 * hwMultiplier + wOffset
    load7_x := 310 * hwMultiplier + wOffset, load7_y := 480 * hwMultiplier + wOffset, load8_x := 410 * hwMultiplier + wOffset, load8_y := 480 * hwMultiplier + wOffset
    load9_x := 110 * hwMultiplier + wOffset, load9_y := 580 * hwMultiplier + wOffset, load10_x := 210 * hwMultiplier + wOffset, load10_y := 580 * hwMultiplier + wOffset
    load11_x := 310 * hwMultiplier + wOffset, load11_y := 580 * hwMultiplier + wOffset, load12_x := 410 * hwMultiplier + wOffset, load12_y := 580 * hwMultiplier + wOffset
    load13_x := 110 * hwMultiplier + wOffset, load13_y := 680 * hwMultiplier + wOffset, load14_x := 210 * hwMultiplier + wOffset, load14_y := 680 * hwMultiplier + wOffset
    load15_x := 310 * hwMultiplier + wOffset, load15_y := 680 * hwMultiplier + wOffset, load16_x := 410 * hwMultiplier + wOffset, load16_y := 680 * hwMultiplier + wOffset
    load17_x := 110 * hwMultiplier + wOffset, load17_y := 780 * hwMultiplier + wOffset, load18_x := 210 * hwMultiplier + wOffset, load18_y := 780 * hwMultiplier + wOffset
    load19_x := 310 * hwMultiplier + wOffset, load19_y := 780 * hwMultiplier + wOffset, load20_x := 410 * hwMultiplier + wOffset, load20_y := 780 * hwMultiplier + wOffset
    load_test_1x := 220 * hwMultiplier + wOffset, load_test_2x := 320 * hwMultiplier + wOffset, load_test_3x := 420 * hwMultiplier + wOffset, load_test_4x := 520 * hwMultiplier + wOffset
    load_test_y_bottom := 740 * hwMultiplier + wOffset, load_test_y_mid := 350 * hwMultiplier + wOffset, load_test_y_mid2 := 430 * hwMultiplier + wOffset, load_test_y_top := 470 * hwMultiplier + wOffset
    loadcolor_x := 102, loadcolor_y := 139, invcolor_x := 1280, invcolor_y := 1380, invcolor2_x := 1280, invcolor2_y := 1351
    timer_x := 73 * hwMultiplier + wOffset, timer_y := 820 * hwMultiplier + wOffset
    colorRES := "Green"
} else if (A_ScreenWidth == 1280) and (A_ScreenHeight == 768) {
    load1_x := 75, load1_y := 300, load2_x := 142.5, load2_y := 300, load3_x := 207, load3_y := 300, load4_x := 268, load4_y := 300
    load5_x := 75, load5_y := 360, load6_x := 142.5, load6_y := 360, load7_x := 207, load7_y := 360, load8_x := 268, load8_y := 360
    load9_x := 75, load9_y := 430, load10_x := 142.5, load10_y := 430, load11_x := 207, load11_y := 430, load12_x := 268, load12_y := 430
    load13_x := 75, load13_y := 490, load14_x := 142.5, load14_y := 490, load15_x := 207, load15_y := 490, load16_x := 268, load16_y := 490
    load17_x := 75, load17_y := 555, load18_x := 142.5, load18_y := 555, load19_x := 207, load19_y := 555, load20_x := 268, load20_y := 555
    load_test_1x := 220, load_test_2x := 320, load_test_3x := 420, load_test_4x := 520
    load_test_y_bottom := 740, load_test_y_mid := 350, load_test_y_mid2 := 430, load_test_y_top := 470
    loadcolor_x := 77, loadcolor_y := 104, invcolor_x := 960, invcolor_y := 1035, invcolor2_x := 960, invcolor2_y := 1014
    timer_x := 73, timer_y := 820
    colorRES := "Green"
} else {
    if FileExist("loadouts_d2\CustomLoadoutsCoordinates.ini"){
    loadX := [], loadY := []
    Loop, 20 {
        IniRead, x, loadouts_d2\CustomLoadoutsCoordinates.ini, settings, loadout%A_Index%_x
        IniRead, y, loadouts_d2\CustomLoadoutsCoordinates.ini, settings, loadout%A_Index%_y
        x := x + 0, y := y + 0
        loadX.Push(x), loadY.Push(y)
    }
    load1_x := loadX[1], load1_y := loadY[1], load2_x := loadX[2], load2_y := loadY[2], load3_x := loadX[3], load3_y := loadY[3], load4_x := loadX[4], load4_y := loadY[4]
    load5_x := loadX[5], load5_y := loadY[5], load6_x := loadX[6], load6_y := loadY[6], load7_x := loadX[7], load7_y := loadY[7], load8_x := loadX[8], load8_y := loadY[8]
    load9_x := loadX[9], load9_y := loadY[9], load10_x := loadX[10], load10_y := loadY[10], load11_x := loadX[11], load11_y := loadY[11], load12_x := loadX[12], load12_y := loadY[12]
    load13_x := loadX[13], load13_y := loadY[13], load14_x := loadX[14], load14_y := loadY[14], load15_x := loadX[15], load15_y := loadY[15], load16_x := loadX[16], load16_y := loadY[16]
    load17_x := loadX[17], load17_y := loadY[17], load18_x := loadX[18], load18_y := loadY[18], load19_x := loadX[19], load19_y := loadY[19], load20_x := loadX[20], load20_y := loadY[20]
    colorRES := "Yellow"
} else {
    colorRES := "Red"
}
    loadcolor_x := 77 * hwMultiplier + wOffset, loadcolor_y := 104 * hwMultiplier + wOffset
    invcolor_x := 960 * hwMultiplier + wOffset, invcolor_y := 1035 * hwMultiplier + wOffset
    invcolor2_x := 960 * hwMultiplier + wOffset, invcolor2_y := 1014 * hwMultiplier + wOffset
    timer_x := 100 * hwMultiplier + wOffset, timer_y := 870 * hwMultiplier + wOffset
}
global colorRES
global 1sttime := 0
global ActivePreset := 1

EnsureIniSetting(file, section, key, defaultValue) {
    IniRead, val, %file%, %section%, %key%, %defaultValue%
    if (val = "ERROR")
        val := defaultValue
    IniWrite, %val%, %file%, %section%, %key%
    return val
}

InitLoadoutsEnvironment() {
    global StopwatchBridgeEnabled, StopwatchBridgePollMs, idkhowtonameit, ActivePreset, FreshInstall
    FileCreateDir, loadouts_d2
    settingsFile := "loadouts_d2\LoadoutSettings.ini"
    if (FreshInstall) {
        IniWrite, %A_Space%, %settingsFile%, settings, SwapperSettingsBind
        IniWrite, %A_Space%, %settingsFile%, settings, SwapperHotkey
        IniWrite, %A_Space%, %settingsFile%, settings, 27k_ul_swap
        IniWrite, %A_Space%, %settingsFile%, settings, both_swap
        IniWrite, %A_Space%, %settingsFile%, settings, none_swap
        IniWrite, %A_Space%, %settingsFile%, settings, 3074_ul_bind
        IniWrite, %A_Space%, %settingsFile%, settings, 3074_dl_bind
        IniWrite, %A_Space%, %settingsFile%, settings, 27k_ul_bind
        IniWrite, 1, %settingsFile%, settings, StopwatchBridgeEnabled
        IniWrite, 150, %settingsFile%, settings, StopwatchBridgePollMs
        IniWrite, 0, %settingsFile%, settings, idkhowtonameit
        IniWrite, 1, %settingsFile%, settings, ActivePreset
        IniWrite, 3, %settingsFile%, version, version
    } else {
        EnsureIniSetting(settingsFile, "settings", "StopwatchBridgeEnabled", 1)
        EnsureIniSetting(settingsFile, "settings", "StopwatchBridgePollMs", 150)
        EnsureIniSetting(settingsFile, "settings", "idkhowtonameit", 0)
        EnsureIniSetting(settingsFile, "settings", "ActivePreset", 1)
        EnsureIniSetting(settingsFile, "version", "version", 3)
    }
    if !FileExist("loadouts_d2\statistics.dat") {
        FileAppend,, loadouts_d2\statistics.dat
        FileSetAttrib, +H, loadouts_d2\statistics.dat
    }
    InitStopwatchBridgeFiles()
}

InitStopwatchBridgeFiles() {
    base := StopwatchBridge_GetBaseFolder()
    bridgeCmd := base . "\ahk_bridge.cmd"
    bridgeRsp := base . "\ahk_bridge.rsp"
    if !FileExist(bridgeCmd)
        FileAppend,, %bridgeCmd%
    if !FileExist(bridgeRsp)
        FileAppend,, %bridgeRsp%
    if !FileExist("loadouts_d2\ahk_bridge.cmd")
        FileAppend,, loadouts_d2\ahk_bridge.cmd
    if !FileExist("loadouts_d2\ahk_bridge.rsp")
        FileAppend,, loadouts_d2\ahk_bridge.rsp
}

LoadGlobalSettingsFromIni() {
    global settings_bind, 3074_ul_bind, 3074_dl_bind, 27k_ul_bind, SwapperHotkey
    global 27k_ul_swap, both_swap, none_swap, StopwatchBridgeEnabled, StopwatchBridgePollMs
    global ActivePreset, idkhowtonameit, PVEOutboundKeybind, PVEKeybind, PVPOutboundKeybind
    settingsFile := "loadouts_d2\LoadoutSettings.ini"
    IniRead, settings_bind, %settingsFile%, settings, SwapperSettingsBind, %A_Space%
    IniRead, 3074_ul_bind, %settingsFile%, settings, 3074_ul_bind, %A_Space%
    if (3074_ul_bind = "" || 3074_ul_bind = "ERROR") {
        IniWrite, %PVEOutboundKeybind%, %settingsFile%, settings, 3074_ul_bind
        IniRead, 3074_ul_bind, %settingsFile%, settings, 3074_ul_bind
    }
    IniRead, 3074_dl_bind, %settingsFile%, settings, 3074_dl_bind, %A_Space%
    if (3074_dl_bind = "" || 3074_dl_bind = "ERROR") {
        IniWrite, %PVEKeybind%, %settingsFile%, settings, 3074_dl_bind
        IniRead, 3074_dl_bind, %settingsFile%, settings, 3074_dl_bind
    }
    IniRead, 27k_ul_bind, %settingsFile%, settings, 27k_ul_bind, %A_Space%
    if (27k_ul_bind = "" || 27k_ul_bind = "ERROR") {
        IniWrite, %PVPOutboundKeybind%, %settingsFile%, settings, 27k_ul_bind
        IniRead, 27k_ul_bind, %settingsFile%, settings, 27k_ul_bind
    }
    IniRead, SwapperHotkey, %settingsFile%, settings, SwapperHotkey, %A_Space%
    IniRead, 27k_ul_swap, %settingsFile%, settings, 27k_ul_swap, %A_Space%
    IniRead, both_swap, %settingsFile%, settings, both_swap, %A_Space%
    IniRead, none_swap, %settingsFile%, settings, none_swap, %A_Space%
    IniRead, StopwatchBridgeEnabled, %settingsFile%, settings, StopwatchBridgeEnabled, 1
    IniRead, StopwatchBridgePollMs, %settingsFile%, settings, StopwatchBridgePollMs, 150
    IniRead, ActivePreset, %settingsFile%, settings, ActivePreset, 1
    IniRead, idkhowtonameit, %settingsFile%, settings, idkhowtonameit, 0
    LoadPresetSettings(ActivePreset)
}

LoadStatisticsFromFile() {
    global totalswaps, totalswaps74ul, totalswaps27k, totaltimespent, totaltimespent74ul
    global totaltimespent27k, totalloadouts
    if !FileExist("loadouts_d2\statistics.dat") {
        FileAppend,, loadouts_d2\statistics.dat
        FileSetAttrib, +H, loadouts_d2\statistics.dat
        return
    }
    IniRead, totalswaps, loadouts_d2\statistics.dat, stats, totalswaps, 0
    IniRead, totalswaps74ul, loadouts_d2\statistics.dat, stats, totalswaps74ul, 0
    IniRead, totalswaps27k, loadouts_d2\statistics.dat, stats, totalswaps27k, 0
    IniRead, totaltimespent, loadouts_d2\statistics.dat, stats, totaltimespent, 0
    IniRead, totaltimespent74ul, loadouts_d2\statistics.dat, stats, totaltimespent74ul, 0
    IniRead, totaltimespent27k, loadouts_d2\statistics.dat, stats, totaltimespent27k, 0
    IniRead, totalloadouts, loadouts_d2\statistics.dat, stats, totalloadouts, 0
    Loop 20 {
        IniRead, total%A_Index%loadouts, loadouts_d2\statistics.dat, stats, total%A_Index%loadouts, 0
    }
}

LoadPresetSettings(num) {
    global
    if (num < 1 || num > 8)
        num := 1
    ActivePreset := num
    file := "loadouts_d2\Preset" num ".txt"
    if !FileExist(file) {
        Loop 20
            load%A_Index% := 0
        damage_loadout3074 := "", damage_loadout27k := "", damage_loadout_both := "", damage_loadout_none := ""
        swap_time := 0, swap_time_27k := 0, swap_time_none := 0
        time_between_loadouts := 0, f1_after_swaps := 0, swap_timer := 0
        untick_delay := 0, AutodisableBuffering := 0, enhanced_loadout_time := 0, 3074_dl := 0
        debug_done := 0, debug_count_total := 0
        return
    }
    Loop 20 {
        IniRead, val, %file%, settings, Loadout%A_Index%, 0
        load%A_Index% := val
    }
    IniRead, damage_loadout3074, %file%, settings, DamageLoadout3074, %A_Space%
    IniRead, damage_loadout27k, %file%, settings, DamageLoadout27k, %A_Space%
    IniRead, damage_loadout_both, %file%, settings, DamageLoadout_both, %A_Space%
    IniRead, damage_loadout_none, %file%, settings, DamageLoadout_none, %A_Space%
    IniRead, swap_time, %file%, settings, SwapTimeOverall, 0
    IniRead, swap_time_27k, %file%, settings, SwapTime27k, 0
    IniRead, swap_time_none, %file%, settings, SwapTime_none, 0
    IniRead, time_between_loadouts, %file%, settings, DelayBetweenLoadouts, 0
    IniRead, f1_after_swaps, %file%, settings, F1AfterSwaps, 0
    IniRead, swap_timer, %file%, settings, swap_timer, 0
    IniRead, untick_delay, %file%, settings, untick_delay, 0
    IniRead, AutodisableBuffering, %file%, settings, AutodisableBuffering, 0
    IniRead, enhanced_loadout_time, %file%, settings, enhanced_loadout_time, 0
    IniRead, 3074_dl, %file%, settings, 3074_dl, 0
    IniRead, debug_done, %file%, settings, debug_done, 0
    IniRead, debug_count_total, %file%, settings, debug_count_total, 0
}

SavePresetSettings(num := "") {
    global
    if (num = "")
        num := ActivePreset
    if (num < 1 || num > 8)
        return
    hasData := false
    Loop 20
        if (load%A_Index% = 1)
            hasData := true
    if (damage_loadout3074 != "" || damage_loadout27k != "" || damage_loadout_both != "" || damage_loadout_none != "")
        hasData := true
    if (swap_time != 0 || time_between_loadouts != 0)
        hasData := true
    file := "loadouts_d2\Preset" num ".txt"
    if !hasData {
        FileDelete, %file%
        return
    }
    content := "[settings]`n"
    Loop 20
        content .= "Loadout" A_Index "=" load%A_Index% "`n"
    content .= "DamageLoadout3074=" damage_loadout3074 "`n"
    content .= "DamageLoadout27k=" damage_loadout27k "`n"
    content .= "DamageLoadout_both=" damage_loadout_both "`n"
    content .= "DamageLoadout_none=" damage_loadout_none "`n"
    content .= "SwapTimeOverall=" swap_time "`n"
    content .= "SwapTime27k=" swap_time_27k "`n"
    content .= "SwapTime_none=" swap_time_none "`n"
    content .= "DelayBetweenLoadouts=" time_between_loadouts "`n"
    content .= "F1AfterSwaps=" f1_after_swaps "`n"
    content .= "swap_timer=" swap_timer "`n"
    content .= "untick_delay=" untick_delay "`n"
    content .= "AutodisableBuffering=" AutodisableBuffering "`n"
    content .= "enhanced_loadout_time=" enhanced_loadout_time "`n"
    content .= "3074_dl=" 3074_dl "`n"
    content .= "debug_done=" debug_done "`n"
    content .= "debug_count_total=" debug_count_total
    FileDelete, %file%
    FileAppend, %content%, %file%
}

if (FileExist("SwapperSettings.ini")) {
    IniRead, settings_bind, SwapperSettings.ini, settings, SwapperSettingsBind
    IniRead, 3074_ul_bind, SwapperSettings.ini, settings, 3074_ul_bind
    IniRead, 3074_dl_bind, SwapperSettings.ini, settings, 3074_dl_bind
    IniRead, 27k_ul_bind, SwapperSettings.ini, settings, 27k_ul_bind
    IniRead, SwapperHotkey, SwapperSettings.ini, settings, SwapperHotkey
    IniRead, swap_time, SwapperSettings.ini, settings, SwapTimeOverall
    IniRead, swap_time_27k, SwapperSettings.ini, settings, SwapTime27k
    IniRead, time_between_loadouts, SwapperSettings.ini, settings, DelayBetweenLoadouts
    IniRead, f1_after_swaps, SwapperSettings.ini, settings, F1AfterSwaps
    Loop, 20 {
        IniRead, load%A_Index%, SwapperSettings.ini, settings, Loadout%A_Index%
    }
    IniRead, damage_loadout3074, SwapperSettings.ini, settings, DamageLoadout
    FileCreateDir, loadouts_d2
    FileDelete, SwapperSettings.ini
    SavePresetSettings(1)
    settingsFile := "loadouts_d2\LoadoutSettings.ini"
    IniWrite, %settings_bind%, %settingsFile%, settings, SwapperSettingsBind
    IniWrite, %3074_ul_bind%, %settingsFile%, settings, 3074_ul_bind
    IniWrite, %3074_dl_bind%, %settingsFile%, settings, 3074_dl_bind
    IniWrite, %27k_ul_bind%, %settingsFile%, settings, 27k_ul_bind
    IniWrite, %SwapperHotkey%, %settingsFile%, settings, SwapperHotkey
    IniWrite, 1, %settingsFile%, settings, ActivePreset
    IniWrite, 1, %settingsFile%, settings, StopwatchBridgeEnabled
    IniWrite, 150, %settingsFile%, settings, StopwatchBridgePollMs
    IniWrite, 0, %settingsFile%, settings, idkhowtonameit
    IniWrite, 3, %settingsFile%, version, version
}

LoadGlobalSettingsFromIni()
LoadStatisticsFromFile()

if (FreshInstall) {
    settings_bind := "", SwapperHotkey := "", 27k_ul_swap := "", both_swap := "", none_swap := ""
    3074_ul_bind := "", 3074_dl_bind := "", 27k_ul_bind := ""
    settingsgui()
    return
}

Hotkey, IfWinActive, ahk_exe Destiny2.exe
if (SwapperHotkey != "" && SwapperHotkey != "None")
    Hotkey, % "*~" SwapperHotkey, Swap_74ul, On
if (27k_ul_swap != "" && 27k_ul_swap != "None")
    Hotkey, % "*~" 27k_ul_swap, Swap_27k, On
if (both_swap != "" && both_swap != "None")
    Hotkey, % "*~" both_swap, Swap_both, On
if (none_swap != "" && none_swap != "None")
    Hotkey, % "*~" none_swap, Swap_none, On
if (settings_bind != "" && settings_bind != "None")
    Hotkey, % "*~" settings_bind, Settings, On
Hotkey, IfWinActive

currentVersion := 3
iniread, version, loadouts_d2\LoadoutSettings.ini, version, version, <2.4
iniwrite, 3, loadouts_d2\LoadoutSettings.ini, version, version

if (settings_bind = "" || settings_bind = "ERROR" || settings_bind = "None")
    settings_bind := ""
if (SwapperHotkey = "" || SwapperHotkey = "ERROR" || SwapperHotkey = "None")
    SwapperHotkey := ""
if (27k_ul_swap = "" || 27k_ul_swap = "ERROR" || 27k_ul_swap = "None")
    27k_ul_swap := ""
if (both_swap = "" || both_swap = "ERROR" || both_swap = "None")
    both_swap := ""
if (none_swap = "" || none_swap = "ERROR" || none_swap = "None")
    none_swap := ""

StopwatchBridge_Init()

if (settings_bind == "") or (idkhowtonameit == 1){
    iniwrite, 0, loadouts_d2\LoadoutSettings.ini, settings, idkhowtonameit
    settingsgui()
    return
}
if (AutodisableBuffering == 1) {
    AutodisableBufferingTest()
}
If (langName() == "Non_English") {
    send, {shift down}{alt}{shift up}
    reload
}
if (SwapperHotkey != ""){
    hotkey, % "*~" SwapperHotkey, Swap_74ul
}
if (27k_ul_swap != ""){
    hotkey, % "*~" 27k_ul_swap, Swap_27k
}
if (both_swap != ""){
    hotkey, % "*~" both_swap, Swap_both
}
if (none_swap != ""){
    hotkey, % "*~" none_swap, Swap_none
}
if (settings_bind != ""){
    hotkey, % "*~" settings_bind, Settings
}
global 27ktest := 0
global 3074unpressed := 0
global 3074pressed := 0
global 3074_dl_bind, 27k_ul_bind, both_swap, 3074_ul_bind
global load1_x, load1_y, load2_x, load2_y, load3_x, load3_y, load4_x, load4_y, load5_x, load5_y, load6_x, load6_y, load7_x, load7_y, load8_x, load8_y, load9_x, load9_y, load10_x, load10_y, load11_x, load11_y, load12_x, load12_y, load13_x, load13_y, load14_x, load14_y, load15_x, load15_y, load16_x, load16_y, load17_x, load17_y, load18_x, load18_y, load19_x, load19_y, load20_x, load20_y, loadDual_x, loadDual_y, load_test_1x, load_test_4x, load_test_2x, load_test_3x, load_test_y_bottom, load_test_y_mid, load_test_y_top, load_test_y_mid2
global loadcolor_x, loadcolor_y, invcolor_x, invcolor_y, invcolor2_x, invcolor2_y, timer_x, timer_y, debug_done, debug_count_total
global swap_time, swap_time_27k, swap_time_none, time_between_loadouts, f1_after_swaps, damage_loadout3074, damage_loadout, damage_loadout27k, damage_loadout_both, damage_loadout_none, swap_timer, untick_delay
global damagePosition, halfPoint, enabledCount, 3074_dl, AutodisableBuffering, enhanced_loadout_time
global totalswaps, totalswaps74ul, totalswaps27k
global totaltimespent, totaltimespent74ul, totaltimespent27k
global totalloadouts, total1loadouts, total2loadouts, total3loadouts, total4loadouts, total5loadouts, total6loadouts, total7loadouts, total8loadouts, total9loadouts, total10loadouts, total11loadouts, total12loadouts, total13loadouts, total14loadouts, total15loadouts, total16loadouts, total17loadouts, total18loadouts, total19loadouts, total20loadouts
global StopwatchBridgeEnabled, StopwatchBridgePollMs, WM_SRE_NOSWAP, BridgeHwnd
langName(hWnd := "") {
    Static lang := {0409: "English_United_States", 0809: "English_United_Kingdom", 0c09: "English_Australia", 1009: "English_Canada", 1409: "English_New_Zealand", 1809: "English_Ireland", 2009: "English_Jamaica", 2409: "English_Caribbean", 3009: "English_Zimbabwe", 3409: "English_Philippines", 4009: "English_India", 4409: "English_Malaysia", 4809: "English_Singapore"}
    If !hWnd
        hWnd := WinActive("A")
    langCode := SubStr(Format("{:x}", DllCall("GetKeyboardLayout", "UInt", DllCall("GetWindowThreadProcessId", "UInt", hWnd, "UInt", 0), "UInt")), -3)
    Return InStr(lang[langCode], "English_") ? lang[langCode] : "Non_English"
}
GetKeyNameFromCode(code) {
    static keyMap := {}
    if (keyMap.Count() = 0) {
        Loop 10
            keyMap[48 + A_Index-1] := A_Index-1
        Loop 26
            keyMap[65 + A_Index-1] := Chr(65 + A_Index-1)
        Loop 24
            keyMap[111 + A_Index] := "F" . A_Index
        Loop 10
            keyMap[96 + A_Index-1] := "Numpad" . A_Index-1
        keyMap[160] := "LShift", keyMap[161] := "RShift", keyMap[162] := "LCtrl", keyMap[163] := "RCtrl"
        keyMap[164] := "LAlt", keyMap[165] := "RAlt", keyMap[91] := "LWin", keyMap[92] := "RWin"
        keyMap[8] := "Backspace", keyMap[9] := "Tab", keyMap[13] := "Enter", keyMap[27] := "Esc", keyMap[32] := "Space"
    }
    return keyMap.HasKey(code) ? keyMap[code] : "vk" . Format("{:x}", code)
}
FileRead, ScriptContent, %A_ScriptFullPath%
inSettingsGui := false
FoundLine := ""
Loop, Parse, ScriptContent, `n, `r
{
    if (A_LoopField ~= "^settingsgui\(\)\s*{")
        inSettingsGui := true
    if (inSettingsGui && InStr(A_LoopField, "Gui, user_input:New")) {
        FoundLine := Trim(A_LoopField)
        break
    }
}
AutodisableBufferingTest() {
    global ConfigFile, Window_DisplaySpeed, OKButton, WarningMsg
    if (ConfigFile) {
        FileRead, ConfigContent, %ConfigFile%
        FileArray := StrSplit(ConfigContent, "`n", "`r")
        global Window_DisplaySpeed := false
        Loop % FileArray.Length() {
            currentLine := FileArray[A_Index]
            if (InStr(currentLine, """Window_DisplaySpeed"":"))
                global Window_DisplaySpeed := InStr(currentLine, "true") ? true : false
        }
    }
    if (Window_DisplaySpeed == True) {
        Gui, WarningMsg:New, +AlwaysOnTop
        Gui, Add, Text,, Disable "Display connections info" in Stopwatch settings`nto use Auto-disable Buffering feature without issues.
        Gui, Add, Button, vOKButton gOKWarning, OK
        Gui, Add, Button, x+10 gDisableSpeed, Disable Now
        Gui, Show
    }
}
ConvertToHotkeyFormat(keyCodes) {
    if (!keyCodes.Length())
        return "None"
    prefix := "", mainKey := ""
    for i, code in keyCodes {
        if (code = 162 || code = 163 || code = 17)
            prefix .= "^"
        else if (code = 164 || code = 165 || code = 18)
            prefix .= "!"
        else if (code = 160 || code = 161 || code = 16)
            prefix .= "+"
        else if (code = 91 || code = 92)
            prefix .= "#"
        else {
            mainKey := GetKeyNameFromCode(code)
            if mainKey is alpha
                mainKey := Format("{:L}", mainKey)
        }
    }
    return mainKey ? prefix . mainKey : "None"
}
PreciseSleep(s) {
    DllCall("QueryPerformanceFrequency", "Int64*", QPF)
    DllCall("QueryPerformanceCounter", "Int64*", QPCB)
    While (((QPCA - QPCB) / QPF * 1000) < s)
        DllCall("QueryPerformanceCounter", "Int64*", QPCA)
    return ((QPCA - QPCB) / QPF * 1000) 
}
SendModified(key) {
    modifiers := ""
    if InStr(key, "^")
        modifiers .= "{LCtrl down}"
    if InStr(key, "+")
        modifiers .= "{LShift down}"
    if InStr(key, "!")
        modifiers .= "{LAlt down}"
    if InStr(key, "#")
        modifiers .= "{LWin down}"
    keys := StrSplit(RegExReplace(key, "[^a-zA-Z0-9]", " "), " ")
    keyPresses := ""
    for _, cleanKey in keys {
        if (cleanKey = "")
            continue
        if (RegExMatch(cleanKey, "i)^(LButton|MButton|RButton|XButton1|XButton2|WheelDown|WheelUp|WheelLeft|WheelRight|CapsLock|Space|Tab|Enter|Return|Backspace|BS|Delete|Del|Insert|Ins|Home|End|PgUp|PgDn|Up|Down|Left|Right|ScrollLock|PrintScreen|Pause|Break|Escape|Esc|NumLock|Numpad\d|NumpadDot|NumpadEnter|NumpadMult|NumpadDiv|NumpadAdd|NumpadSub|F\d+)$")) {
            keyPresses .= "{" cleanKey " down}{" cleanKey " up}"
        } else {
            Loop, Parse, cleanKey
                keyPresses .= "{" A_LoopField " down}"
            Loop, Parse, cleanKey
                keyPresses .= "{" A_LoopField " up}"
        }
    }
    send % modifiers keyPresses
    if InStr(key, "^")
        send {LCtrl up}
    if InStr(key, "+")
        send {LShift up}
    if InStr(key, "!")
        send {LAlt up}
    if InStr(key, "#")
        send {LWin up}
}
AutodisableBuffering(TrueFalse) {
    global ConfigFile
    if (ConfigFile) {
        FileRead, ConfigContent, %ConfigFile%
        FileArray := StrSplit(ConfigContent, "`n", "`r")
        inPVESection := false
        global Buffer := false
        Loop % FileArray.Length() {
            currentLine := FileArray[A_Index]
            if (InStr(currentLine, """PVE"": {"))
                inPVESection := true
            else if (InStr(currentLine, "},"))
                inPVESection := false
            if (inPVESection && InStr(currentLine, """Buffer"": ")) {
                Buffer := InStr(currentLine, "true") ? true : false
                break
            }
        }
    }
    if (Buffer == TrueFalse) {
        CoordMode, Mouse, Screen
        MouseGetPos, original_x, original_y
        WinGet, previous_window, ID, A
        processes := ["stopwatch.exe", "kanye4king.exe", "daisy.exe", "louis_stopball.exe", "chungus.exe", "10k.exe", "BitcoinMiner.exe", "estrogen.exe", "seawatch.exe", "S_re.exe"]
        foundWindow := false
        for index, processName in processes {
            WinGet, windows, List, ahk_exe %processName%
            if windows {
                foundWindow := true
                Loop % windows {
                    windowID := windows%A_Index%
                    WinGetTitle, windowTitle, ahk_id %windowID%
                    if (windowTitle != "") && (windowTitle != "ahk manager") {
                        WinGetPos, winX, winY, width, height, ahk_id %windowID%
                        targetY := height - 40
                        clickX3 := winX + 215
                        clickY3 := winY + targetY
                        sleep, 100
                        WinActivate ahk_id %windowID%
                        BlockInput, MouseMove
                        MouseMove, %clickX3%, %clickY3%, 0
                        sleep, 10
                        send, {lbutton down}
                        sleep, 10
                        send, {lbutton up}
                        BlockInput, MouseMoveOff
                        break 2
                    }
                }
            }
        }
        WinActivate ahk_id %previous_window%
        MouseMove, %original_x%, %original_y%, 0
        return
    }
}

; --- Stopwatch Bridge (future S_re module integration) ---
; When Bungie API says player is in target activity and 30k traffic starts,
; S_re will trigger No Port swap here instead of pressing the hotkey manually.
;
; File IPC (next to S_re.exe / stopwatchfree.cfg):
;   ahk_bridge.cmd  - write one command, script deletes file after read
;   ahk_bridge.rsp  - optional reply (PONG / NOSWAP OK / NOSWAP SKIP)
; Commands (first line, case-insensitive):
;   NOSWAP        run No Port mode once (same as none_swap hotkey)
;   NOSWAP FORCE  same, even if Stopwatch Bridge is disabled in settings
;   PING          connectivity test -> ahk_bridge.rsp = PONG
;
; Window message IPC (lower latency, for future C# code):
;   RegisterWindowMessage("S_re_AhkBridge_NoSwap") -> hidden window title "S_re_AhkBridge"

StopwatchBridge_GetBaseFolder() {
    global ConfigFile
    if (ConfigFile) {
        SplitPath, ConfigFile,, base
        return base
    }
    SplitPath, A_ScriptFullPath,, ahkFolderPath
    if InStr(ahkFolderPath, "\Ahk")
        return SubStr(ahkFolderPath, 1, InStr(ahkFolderPath, "\Ahk") - 1)
    return ahkFolderPath
}

RunNoSwapMode() {
    global SwapsStarted, damage_loadout3074, damage_loadout27k, damage_loadout_both, damage_loadout_none
    if (SwapsStarted == 1)
        return false
    if (!WinActive("ahk_exe Destiny2.exe"))
        return false
    if (damage_loadout3074 = "" && damage_loadout27k = "" && damage_loadout_both = "" && damage_loadout_none = "") {
        return false
    }
    SwapsStarted := 1
    Swaps(0, 0)
    return true
}

StopwatchBridge_OnWmNoSwap(wParam, lParam, msg, hwnd) {
    StopwatchBridge_TriggerNoSwap(true)
    return true
}

StopwatchBridge_TriggerNoSwap(force := false) {
    global StopwatchBridgeEnabled
    if (!force && !StopwatchBridgeEnabled)
        return false
    ok := RunNoSwapMode()
    StopwatchBridge_WriteResponse(ok ? "NOSWAP OK" : "NOSWAP SKIP")
    return ok
}

StopwatchBridge_WriteResponse(text) {
    base := StopwatchBridge_GetBaseFolder()
    rspFile := base . "\ahk_bridge.rsp"
    FileDelete, %rspFile%
    FileAppend, %text%, %rspFile%
}

StopwatchBridge_Poll() {
    global StopwatchBridgeEnabled
    if (!StopwatchBridgeEnabled)
        return
    base := StopwatchBridge_GetBaseFolder()
    bridgeFile := base . "\ahk_bridge.cmd"
    if !FileExist(bridgeFile)
        return
    FileRead, cmd, %bridgeFile%
    FileDelete, %bridgeFile%
    cmd := Trim(cmd)
    if (cmd = "")
        return
    StringUpper, cmdUpper, cmd
    if (cmdUpper = "NOSWAP") {
        StopwatchBridge_TriggerNoSwap(false)
    } else if (cmdUpper = "NOSWAP FORCE") {
        StopwatchBridge_TriggerNoSwap(true)
    } else if (cmdUpper = "PING") {
        StopwatchBridge_WriteResponse("PONG")
    } else {
        StopwatchBridge_WriteResponse("UNKNOWN " . cmd)
    }
}

StopwatchBridge_Init() {
    global WM_SRE_NOSWAP, StopwatchBridgePollMs, BridgeHwnd
    if (WM_SRE_NOSWAP = "")
        WM_SRE_NOSWAP := DllCall("RegisterWindowMessage", "Str", "S_re_AhkBridge_NoSwap")
    Gui, BridgeMsg:New, +HwndBridgeHwnd -Caption +ToolWindow
    Gui, BridgeMsg:Show, Hide
    WinSetTitle, ahk_id %BridgeHwnd%, S_re_AhkBridge
    OnMessage(WM_SRE_NOSWAP, "StopwatchBridge_OnWmNoSwap")
    pollMs := StopwatchBridgePollMs + 0
    if (pollMs < 50)
        pollMs := 50
    else if (pollMs > 2000)
        pollMs := 2000
    SetTimer, StopwatchBridge_PollTimer, %pollMs%
}

StopwatchBridge_PollTimer:
    StopwatchBridge_Poll()
return

Swaps(3074_ul, 27k_ul) {
    global
    if (damage_loadout3074 = "" && damage_loadout27k = "" && damage_loadout_both = "" && damage_loadout_none = "") {
        MsgBox, Set Final Loadouts in Settings before swapping.
        SwapsStarted := 0
        return
    }
    
    enabledCount := 0
    Loop, 20 {
        if (load%A_Index% = 1)
            enabledCount++
    }
    if (enabledCount = 0) {
        MsgBox, Enable at least one loadout in Settings before swapping.
        SwapsStarted := 0
        return
    }

    if (3074_ul == 1) and (27k_ul == 0){
        damage_loadout := damage_loadout3074
    } 
    else if (3074_ul == 0) and (27k_ul == 1){
        damage_loadout := damage_loadout27k
    }
    else if (3074_ul == 1) and (27k_ul == 1){
        damage_loadout := damage_loadout_both
    }
    else if (3074_ul == 0) and (27k_ul == 0){
        damage_loadout := damage_loadout_none
    }
    
    if (damage_loadout = "" || damage_loadout < 1 || damage_loadout > 20) {
        MsgBox, Set Final Loadout for this mode in Settings before swapping.
        SwapsStarted := 0
        return
    }
    
    loadDual_x := load%damage_loadout%_x
    loadDual_y := load%damage_loadout%_y

    damagePosition := 0
    Loop, 20 {
        if (load%A_Index% = 1) {
            if (A_Index < damage_loadout) {
                damagePosition++
            }
        }
    }

    halfPoint := enabledCount / 2
    TrueStart := A_TickCount
    if (3074_ul == 1){
        SendModified(3074_ul_bind)
        PreciseSleep(10)
    }
    if (3074_dl == 1) and ((3074_ul == 1) or (27k_ul == 1)){
        SendModified(3074_dl_bind)
        3074pressed := 1
    }
    if (27k_ul == 1){
        SendModified(27k_ul_bind)
    }
    invLeave := 0
    loop, 10 {
        pixelgetcolor, invscreencolor, %invcolor_x%, %invcolor_y%
        pixelgetcolor, invscreencolor2, %invcolor2_x%, %invcolor2_y%
        PixelGetColor, loadoutColor, %loadcolor_x%, %loadcolor_y%
        if (!RegExMatch(invscreencolor, "0xE.E.E.")) and (!RegExMatch(invscreencolor2, "0xE.E.E.")) and (!RegExMatch(loadoutColor, "0xE.E.E.")) and (!RegExMatch(loadoutColor, "0xD.D.D.")) and (!RegExMatch(invscreencolor, "0xD.D.D.")) and (!RegExMatch(invscreencolor2, "0xD.D.D.")){ 
            invLeave += 1
            break
        }
    }
    if (invLeave >= 1){
        send, {F1}
        send, {rbutton up}
        sleep, 100
        if (ConfigFile) and (AutodisableBuffering == 1) and (3074_ul == 1){
            AutodisableBuffering(True)
        }
        sleep, 600
        abccheck := 1
    } else {
        if (ConfigFile) and (AutodisableBuffering == 1) and (3074_ul == 1){
            AutodisableBuffering(True)
        }
        abccheck := 0
    }
    if (abccheck == 1){
        loop, 40 {
            MouseMove, % 10 * hwMultiplier + wOffset, % A_ScreenHeight/2, 0
            send, {left}
            Click Down
            Sleep 10
            Click Up
            PreciseSleep(1)
            PixelGetColor, loadoutColor, %loadcolor_x%, %loadcolor_y%
            if (RegExMatch(loadoutColor, "0xE.E.E.")) or (RegExMatch(loadoutColor, "0xD.D.D.")){
                whyureadthis := 1
                break
            } else { 
                whyureadthis := 0
            } 
        }
    } else {
        send, {Left}
        MouseMove, 50, % A_ScreenHeight/2, 0
        sleep, 100
    }
    start2  := A_TickCount
    loop, {
        PixelGetColor, loadoutColor, %loadcolor_x%, %loadcolor_y%
        if (RegExMatch(loadoutColor, "0xE.E.E.")) or (RegExMatch(loadoutColor, "0xD.D.D.")) or (whyureadthis == 1){
            break
        } 
        else if (start2 + 500 <= A_TickCount){
            break
        }
    }
    start := A_TickCount
    time74 := start + swap_time
    time27 := start + swap_time_27k
    time_none := start + swap_time_none
    dontsavedebug := 0
    if (3074_ul == 0) and (27k_ul == 0){
        time74 := time_none
        time27 := time_none
        time74 := start + swap_time_none
        time74fix := start + swap_time_none - (30 * enabledCount * 5)
        dontsavedebug := 1
        already_extended := 1
    }
    if (time74 < time27) and (27k_ul == 1){
        time74 := time27
        time74 := start + swap_time_27k
        time74fix := start + swap_time_27k - (30 * enabledCount * 5)
        dontsavedebug := 1
        already_extended := 1
    }
    if ((time_between_loadouts <= 37) or (enhanced_loadout_time == 1)) and (dontsavedebug == 0){
        time74fix := start + swap_time - (37 * enabledCount * 3)
    }
    else if (time_between_loadouts <= 50) and (dontsavedebug == 0){
        time74fix := start + swap_time - (time_between_loadouts * enabledCount * 2)
    } else if (time_between_loadouts <= 80) and (dontsavedebug == 0){
        time74fix := start + swap_time - (time_between_loadouts * enabledCount * 1.5)
    } else if (time_between_loadouts >= 80) and (dontsavedebug == 0){
        time74fix := start + swap_time - (time_between_loadouts * enabledCount)
    }
    if (enabledCount <= 2) {
        time74fix := time74
    }
    send, {Left}
    skipbetweentime := 0
    load_test_count := 0
    stolbNum := 0
    skipenhancedtime := 0
    debug_count := 0
    already_extended := 0
    loop, {
        direction := (damagePosition < halfPoint) ? 1 : -1
        Loop, 20 {
            loadNum := (direction == 1) ? A_Index : 21 - A_Index
            remain_time := Round((time74 - A_TickCount) / 1000, 2)
            if (remain_time <= 0) {
                remain_time := 0
            }
            if (swap_timer = 1){
                ToolTip, %remain_time%s, %timer_x%, %timer_y%, 1
            }
            isEnabled := load%loadNum%
            if (isEnabled = 1) {
                posX := load%loadNum%_x
                posY := load%loadNum%_y
                if (enhanced_loadout_time = 1) or (colorRES == "Green"){
                    if (loadNum = 1) or (loadNum = 5) or (loadNum = 9) or (loadNum = 13) or (loadNum = 17){
                        if (stolbNum != 1){
                            stolbNum := 1
                        } else {
                            skipenhancedtime := 1
                            PreciseSleep(time_between_loadouts/2)
                        }
                    } else if (loadNum = 2) or (loadNum = 6) or (loadNum = 10) or (loadNum = 14) or (loadNum = 18){
                        if (stolbNum != 2){
                            stolbNum := 2
                        } else {
                            skipenhancedtime := 1
                            PreciseSleep(time_between_loadouts/2)
                        }
                    } else if (loadNum = 3) or (loadNum = 7) or (loadNum = 11) or (loadNum = 15) or (loadNum = 19){
                        if (stolbNum != 3){
                            stolbNum := 3
                        } else {
                            skipenhancedtime := 1
                            PreciseSleep(time_between_loadouts/2)
                        }
                    } else {
                        if (stolbNum != 4){
                            stolbNum := 4
                        } else {
                            skipenhancedtime := 1
                            PreciseSleep(time_between_loadouts/2)
                        }
                    }
                    load_test_x := load_test_%stolbNum%x
                }
                if (posx == loadDual_x and posy == loadDual_y and time74fix <= A_TickCount) {
                    Continue
                }
                MouseMove, %posX%, %posY%, 0
                if ((enhanced_loadout_time == 0) or (skipenhancedtime == 1)) or (colorRES != "Green"){
                    PreciseSleep(time_between_loadouts/2)
                    Click Down
                    Sleep 10
                    Click Up
                    skipenhancedtime := 0
                    debug_count += 1
                } else if (enhanced_loadout_time == 1){
                    loop, {
                        pixelgetcolor, loadoutreadytest1, load_test_x, load_test_y_bottom
                        pixelgetcolor, loadoutreadytest2, load_test_x, load_test_y_mid
                        pixelgetcolor, loadoutreadytest3, load_test_x, load_test_y_mid2
                        pixelgetcolor, loadoutreadytest4, load_test_x, load_test_y_top
                        load_test_count += 1
                        if (RegExMatch(loadoutreadytest1, "F.F.F.")) or (RegExMatch(loadoutreadytest2, "F.F.F.")) or (RegExMatch(loadoutreadytest3, "F.F.F.")) or (RegExMatch(loadoutreadytest4, "F.F.F.")){
                            Click Down
                            Sleep 10
                            Click Up
                            load_test_count := 0
                            debug_count += 1
                            break
                        } else if (load_test_count >= 4){
                            Click Down
                            Sleep 10
                            Click Up
                            load_test_count := 0
                            debug_count += 1
                            break
                        }
                    }
                }
                if (enhanced_loadout_time == 0) or (colorRES != "Green"){
                    PreciseSleep(time_between_loadouts/2)
                }
            }
            if (time74 <= A_TickCount){
                break
            }
        }   
        if (time27 <= A_TickCount) and (27ktest = 0) and (27k_ul == 1) and (time27 < time74){
            SendModified(27k_ul_bind)
            TrueEnd27k := A_TickCount
            27ktest := 1
            if (3074_ul == 0){
                if (3074_dl == 1) and (3074pressed == 1){
                    SendModified(3074_dl_bind)
                    3074unpressed := 1
                    3074pressed := 0
                }
            }
        }
        if (time74 <= A_TickCount){
            MouseMove, %loadDual_x%, %loadDual_y%, 0
            ToolTip
            delays := [50, 50, 50, 10, 1, 1, 1, 1, 1]
            for index, d in delays {
                PreciseSleep(d)
                Click Down
                Sleep 10
                Click Up
            }
            break
        } else if (time74-swap_time*0.1 <= A_TickCount) and (already_extended == 0) and (debug_done >= 5){
            if (debug_count<=debug_count_total/debug_done*0.9){
                time74 += swap_time*0.2
                time74fix += swap_time*0.2
                already_extended := 1
                if (dontsavedebug == 0){
                    debug_done += 1
                    debug_count_total += debug_count*1.09
                    SavePresetSettings(ActivePreset)
                }
            }
        }
    }
    TrueEnd := A_TickCount
    if (27k_ul == 1) and (27ktest == 0){
        TrueEnd27k := A_TickCount
    }
    start3 := A_TickCount + untick_delay
    if (f1_after_swaps == 1){
        send, {F1}
    }
    loop, {
        sleep, 1
        if (start3 <= A_TickCount){
            Break
        }
    }
    if (27k_ul == 1) and (27ktest == 0){
        SendModified(27k_ul_bind)
    }
    if (3074_ul == 1){
        SendModified(3074_ul_bind)
        PreciseSleep(10)
    }
    if (3074_dl == 1) and (3074unpressed == 0) and (3074pressed == 1){
        SendModified(3074_dl_bind)
        3074pressed := 0
    }
    if (ConfigFile) and (AutodisableBuffering == 1)  and (3074_ul == 1){
        send, {rbutton up}
        send, {lbutton up}
        AutodisableBuffering(False)
    }
    27ktest := 0
    1sttime := 0
    SwapsStarted := 0
    3074unpressed := 0
    3074pressed := 0
    if (dontsavedebug == 0) and (already_extended == 0){
        debug_done += 1
        debug_count_total += debug_count
        SavePresetSettings(ActivePreset)
    }
    if (27k_ul == 1) and (3074_ul == 1){
        totalswaps += 1
        totalswaps74ul += 1
        totalswaps27k += 1
        totaltimespent += (TrueEnd - truestart)
        totaltimespent74ul += (TrueEnd - TrueStart)
        totaltimespent27k += (TrueEnd27k - TrueStart)
    } else if (3074_ul == 1) and (27k_ul == 0){
        totalswaps += 1
        totalswaps74ul += 1
        totaltimespent += (TrueEnd - truestart)
        totaltimespent74ul += (TrueEnd - TrueStart)
    } else if (27k_ul == 1) and (3074_ul == 0){
        totalswaps += 1
        totalswaps27k += 1
        totaltimespent += (TrueEnd - TrueStart)
        totaltimespent27k += (TrueEnd27k - TrueStart)
    }
    UpdateStats()
    return
}
UpdateStats(){
    IniWrite, %totalswaps%, loadouts_d2/statistics.dat, stats, totalswaps
    IniWrite, %totalswaps74ul%, loadouts_d2/statistics.dat, stats, totalswaps74ul
    IniWrite, %totalswaps27k%, loadouts_d2/statistics.dat, stats, totalswaps27k
    IniWrite, %totaltimespent%, loadouts_d2/statistics.dat, stats, totaltimespent
    IniWrite, %totaltimespent74ul%, loadouts_d2/statistics.dat, stats, totaltimespent74ul
    IniWrite, %totaltimespent27k%, loadouts_d2/statistics.dat, stats, totaltimespent27k
    IniWrite, %totalloadouts%, loadouts_d2/statistics.dat, stats, totalloadouts
    Loop 20 {
        IniWrite, % total%A_Index%loadouts, loadouts_d2/statistics.dat, stats, total%A_Index%loadouts
    }
    
    IfWinExist, Statistics
    {
        formattedTotaltimespent := FormatTimeFromMS(totaltimespent)
        formattedTotaltimespent74ul := FormatTimeFromMS(totaltimespent74ul)
        formattedTotaltimespent27k := FormatTimeFromMS(totaltimespent27k)
        maxCount := 0
        Loop, 20 {
            favload := "total" . A_Index . "loadouts"
            if (%favload% > maxCount) {
                maxCount := %favload%
                favLoadout := A_Index
            }
        }
        GuiControl, stats:, TotalSwapsText, Total Swaps: %totalswaps%
        GuiControl, stats:, Total74Text, Total 3074 UL Swaps: %totalswaps74ul%
        GuiControl, stats:, Total27kText, Total 27k UL Swaps: %totalswaps27k%
        GuiControl, stats:, TotalTimeText, Total Time Spent: %formattedTotaltimespent%
        GuiControl, stats:, Total74TimeText, Total Time Spent 3074 UL: %formattedTotaltimespent74ul%
        GuiControl, stats:, Total27kTimeText, Total Time Spent 27k UL: %formattedTotaltimespent27k%
        GuiControl, stats:, TotalLoadsText, Total Loadouts: %totalloadouts%
        GuiControl, stats:, FavLoadoutText, Favorite Loadout: %favLoadout%
        Loop 20 {
            i := A_Index
            val := total%i%loadouts
            txt := i . "th: " . val
            GuiControl, stats:, Total%i%LoadText, %txt%
        }
    }
}
settingsgui(){
    global color_gui, settings_bind, SwapperHotkey, swap_time, swap_time_27k, swap_time_none, time_between_loadouts
    global load1, load2, load3, load4, load5, load6, load7, load8, load9, load10, load11, load12, load13, load14, load15, load16, load17, load18, load19, load20
    global damage_loadout3074, damage_loadout27k, damage_loadout_both, damage_loadout_none, f1_after_swaps, 3074_ul, 3074_dl, 27k_ul, AutodisableBuffering
    global 3074_ul_bind, 3074_dl_bind, 27k_ul_bind, swap_timer, untick_delay, 3074_ul_swap, 27k_ul_swap, both_swap, none_swap, enhanced_loadout_time
    global StopwatchBridgeEnabled, StopwatchBridgePollMs
    global ActivePreset, PresetCb1, PresetCb2, PresetCb3, PresetCb4, PresetCb5, PresetCb6, PresetCb7, PresetCb8
    global cb1, cb2, cb3, cb4, cb5, cb6, cb7, cb8

    If (langName() == "Non_English") {
        send, {shift down}{alt}{shift up}
    }

    Gui, user_input:New,, Made by k3 | v3.2 
    Gui, Color, 1C1C1C
    Gui, Font, cWhite
    Gui, Font, s7
    Gui, user_input:Add, Text, x30 y237 cWhite, ------------------------------------------------
    Gui, user_input:Add, Text, x30 y272 cWhite, ------------------------------------------------
    Gui, user_input:Add, Text, x30 y307 cWhite, ------------------------------------------------
    Gui, Font, s8

    Gui, user_input:Add, GroupBox, x10 y10 w185 h180 cWhite, Choose Loadouts
    Gui, user_input:Add, Checkbox, x30 y35 vload1 Checked%load1% cWhite,1
    Gui, user_input:Add, Checkbox, x70 y35 vload2 Checked%load2% cWhite,2
    Gui, user_input:Add, Checkbox, x110 y35 vload3 Checked%load3% cWhite,3
    Gui, user_input:Add, Checkbox, x150 y35 vload4 Checked%load4% cWhite,4
    Gui, user_input:Add, Checkbox, x30 y65 vload5 Checked%load5% cWhite,5
    Gui, user_input:Add, Checkbox, x70 y65 vload6 Checked%load6% cWhite,6
    Gui, user_input:Add, Checkbox, x110 y65 vload7 Checked%load7% cWhite,7
    Gui, user_input:Add, Checkbox, x150 y65 vload8 Checked%load8% cWhite,8
    Gui, user_input:Add, Checkbox, x30 y95 vload9 Checked%load9% cWhite, 9
    Gui, user_input:Add, Checkbox, x70 y95 vload10 Checked%load10% cWhite,10
    Gui, user_input:Add, Checkbox, x110 y95 vload11 Checked%load11% cWhite,11
    Gui, user_input:Add, Checkbox, x150 y95 vload12 Checked%load12% cWhite,12
    Gui, user_input:Add, Checkbox, x30 y125 vload13 Checked%load13% cWhite,13
    Gui, user_input:Add, Checkbox, x70 y125 vload14 Checked%load14% cWhite,14
    Gui, user_input:Add, Checkbox, x110 y125 vload15 Checked%load15% cWhite,15
    Gui, user_input:Add, Checkbox, x150 y125 vload16 Checked%load16% cWhite,16
    Gui, user_input:Add, Checkbox, x30 y155 vload17 Checked%load17% cWhite,17
    Gui, user_input:Add, Checkbox, x70 y155 vload18 Checked%load18% cWhite,18
    Gui, user_input:Add, Checkbox, x110 y155 vload19 Checked%load19% cWhite,19
    Gui, user_input:Add, Checkbox, x150 y155 vload20 Checked%load20% cWhite,20

    Gui, user_input:Add, GroupBox, x200 y10 w165 h130 cWhite, Keybinds
    Gui, user_input:Add, Text, x220 y35 cWhite, Hide/show GUI:
    Gui, user_input:Add, Hotkey, x300 y30 w45 vsettings_bind c000000, %settings_bind%
    Gui, user_input:Add, Text, x220 y60 cWhite, 3074 UL Bind:
    Gui, user_input:Add, Hotkey, x300 y55 w45 v3074_ul_bind c000000, %3074_ul_bind%
    Gui, user_input:Add, Text, x220 y85 cWhite, 3074 DL Bind:
    Gui, user_input:Add, Hotkey, x300 y80 w45 v3074_dl_bind c000000, %3074_dl_bind%
    Gui, user_input:Add, Text, x220 y110 cWhite, 27k UL Bind:
    Gui, user_input:Add, Hotkey, x300 y105 w45 v27k_ul_bind c000000, %27k_ul_bind%

    Gui, user_input:Add, GroupBox, x200 y140 w165 h285 cWhite, Settings
    Gui, user_input:Add, Text, x220 y165 cWhite, Swap Time:
    Gui, user_input:Add, Edit, x300 y160 w45 vswap_time c000000, %swap_time%
    Gui, user_input:Add, Text, x220 y190 cWhite, 27k Swap Time:
    Gui, user_input:Add, Edit, x300 y185 w45 vswap_time_27k c000000, %swap_time_27k%
    Gui, user_input:Add, Text, x220 y215 cWhite, NP Swap Time:
    Gui, user_input:Add, Edit, x300 y210 w45 vswap_time_none c000000, %swap_time_none%
    Gui, user_input:Add, Text, x220 y240 cWhite, Swap Delay:
    Gui, user_input:Add, Edit, x300 y235 w45 vtime_between_loadouts c000000, %time_between_loadouts%
    Gui, user_input:Add, Text, x220 y265 cWhite, Untick After:
    Gui, user_input:Add, Edit, x300 y260 w45 vuntick_delay c000000, %untick_delay%
    Gui, user_input:Add, Checkbox, x220 y285 vf1_after_swaps Checked%f1_after_swaps% cWhite, Close Inventory
    Gui, user_input:Add, Checkbox, x220 y305 vswap_timer Checked%swap_timer% cWhite, Show Swap Timer
    Gui, user_input:Add, Checkbox, x220 y325 vAutodisableBuffering Checked%AutodisableBuffering% cWhite, Auto-Disable Buffering
    Gui, user_input:Add, Checkbox, x220 y345 v3074_dl Checked%3074_dl% cWhite, 3074 DL
    Gui, user_input:Add, Checkbox, x220 y365 venhanced_loadout_time Checked%enhanced_loadout_time% cWhite, Enhanced delay
    Gui, user_input:Add, Checkbox, x220 y385 vStopwatchBridgeEnabled Checked%StopwatchBridgeEnabled% cWhite, Stopwatch Bridge
    Gui, user_input:Add, Text, x220 y405 cWhite, Bridge Poll (ms):
    Gui, user_input:Add, Edit, x300 y400 w45 vStopwatchBridgePollMs c000000, %StopwatchBridgePollMs%
    
    Gui, user_input:Add, GroupBox, x10 y190 w185 h165 cWhite, Modes
    Gui, user_input:Add, Text, x30 y220 cWhite, 3074 UL
    Gui, user_input:Add, Text, x30 y255 cWhite, 27k UL
    Gui, user_input:Add, Text, x30 y290 cWhite, Both UL
    Gui, user_input:Add, Text, x30 y325 cWhite, No Port
    Gui, Font, s7
    Gui, user_input:Add, Text, x80 y202 cWhite, Hotkey:
    Gui, user_input:Add, Text, x140 y202 cWhite, End on:

    Gui, Font, s8
    Gui, user_input:Add, Hotkey, x80 y217 w45 vSwapperHotkey c000000, %SwapperHotkey%
    Gui, user_input:Add, Edit, x155 y217 w20 Limit2 vdamage_loadout3074 c000000, %damage_loadout3074%
    Gui, user_input:Add, Hotkey, x80 y252 w45 v27k_ul_swap c000000, %27k_ul_swap%
    Gui, user_input:Add, Edit, x155 y252 w20 Limit2 vdamage_loadout27k c000000, %damage_loadout27k%
    Gui, user_input:Add, Hotkey, x80 y287 w45 vboth_swap c000000, %both_swap%
    Gui, user_input:Add, Edit, x155 y287 w20 Limit2 vdamage_loadout_both c000000, %damage_loadout_both%
    Gui, user_input:Add, Hotkey, x80 y322 w45 vnone_swap c000000, %none_swap%
    Gui, user_input:Add, Edit, x155 y322 w20 Limit2 vdamage_loadout_none c000000, %damage_loadout_none%

    Gui, Font, s8
    Gui, user_input:Add, GroupBox, x10 y355 w185 h70 cWhite, Presets

    cb1 := (ActivePreset = 1) ? 1 : 0
    cb2 := (ActivePreset = 2) ? 1 : 0
    cb3 := (ActivePreset = 3) ? 1 : 0
    cb4 := (ActivePreset = 4) ? 1 : 0
    cb5 := (ActivePreset = 5) ? 1 : 0
    cb6 := (ActivePreset = 6) ? 1 : 0
    cb7 := (ActivePreset = 7) ? 1 : 0
    cb8 := (ActivePreset = 8) ? 1 : 0
    
    Gui, user_input:Add, Checkbox, x30 y377 vPresetCb1 gPresetSwitch Checked%cb1%, 1
    Gui, user_input:Add, Checkbox, x70 y377 vPresetCb2 gPresetSwitch Checked%cb2%, 2
    Gui, user_input:Add, Checkbox, x110 y377 vPresetCb3 gPresetSwitch Checked%cb3%, 3
    Gui, user_input:Add, Checkbox, x150 y377 vPresetCb4 gPresetSwitch Checked%cb4%, 4
    Gui, user_input:Add, Checkbox, x30 y395 vPresetCb5 gPresetSwitch Checked%cb5%, 5
    Gui, user_input:Add, Checkbox, x70 y395 vPresetCb6 gPresetSwitch Checked%cb6%, 6
    Gui, user_input:Add, Checkbox, x110 y395 vPresetCb7 gPresetSwitch Checked%cb7%, 7
    Gui, user_input:Add, Checkbox, x150 y395 vPresetCb8 gPresetSwitch Checked%cb8%, 8

    Gui, Font, s1 cAAAAAA, Consolas
    ascii_art := "
    (
               yOOOOOOOOOOy               
           OOx5OOOOOOOOOxy4yyOOxõ      /Oy     
         OyOOO5OOOy                  OOyxy    
        OOO OOO                 xy OOOyOOõ    
        O   yOO             yy   yOOyOOy      
        OOOO            xOy    yOOfOOOy       
       yyO         ÎOOy      OOOOOOOO x       
       OO      4yOO        OOOyyOOOx yõy      
       Oy                OOOyOOOOO  xxy       
       yy           y  ÎOOOOOOOOO  Oy¾Î       
       OÎ          yOyOyOO ¾OOOy  Oy O        
        yy         xOOyx   yOO   yy y         
         O          OOOO  xOO   OO  y         
          4Î      ÎyOx yOOOO   OO  O          
            Î   xOOy OOOOOO   OO   ¾          
               OOO ÎOy¾Î y5  OO               
             OOO            yO                
                           yy                
                          xÎ
    )"
    Gui, user_input:Add, Text, x20 y445 w185, %ascii_art%
    Gui, Font, s8 c888888
    Gui, user_input:Add, Text, x80 y458 w115, by k3, remade by`nthemostcuddleable`n

    Gui, Font, s12
    Gui, user_input:Add, Button, x200 y430 w165 h38 gOk, Save
    Gui, user_input:Add, Button, x200 y473 w165 h38 gShowStats, Statistics

    Gui, user_input:Show, w375 h520
    return
}
FormatTimeFromMS(ms) {
    seconds := Floor(ms/1000)
    hours := Floor(seconds/3600)
    minutes := Floor(Mod(seconds, 3600)/60)
    seconds := Mod(seconds, 60)
    result := ""
    if (hours > 0)
        result .= hours "h "
    if (minutes > 0)
        result .= minutes "m "
    if (seconds > 0 || result = "")
        result .= seconds "s"
    return Trim(result)
}
if (!anyProcessFound) {
global unknown_sw := ""
SplitPath, A_ScriptFullPath,, ahkFolderPath
baseFolder := SubStr(ahkFolderPath, 1, InStr(ahkFolderPath, "\Ahk") - 1)
Loop, Files, %baseFolder%\*.exe {
    exeName := A_LoopFileName
    dllName := SubStr(exeName, 1, -4) ".dll"
    if (FileExist(baseFolder "\" dllname)) {
        global unknown_sw := SubStr(exeName, 1, -4)  
    }
}
if unknown_sw {
    global anyProcessFound := True
    if (unknown_sw != "") {
        FileRead, scriptContent, %A_ScriptFullPath%
        if RegExMatch(scriptContent, "im)^\s*processes\s*:=\s*\[(.*?)\]", match) {
            currentProcesses := Trim(match1)
            newExe := """" unknown_sw ".exe"""
            if !InStr(currentProcesses, newExe) {
                newProcesses := currentProcesses . (currentProcesses ? ", " : "") . newExe
                newScriptContent := RegExReplace(scriptContent, "im)^(\s*processes\s*:=\s*\[).*?(\])", "$1" newProcesses "$2")
                FileDelete, %A_ScriptFullPath%
                FileAppend, %newScriptContent%, %A_ScriptFullPath%
                reload
            }
        }
    }
}
return
ShowStats:
    formattedTotaltimespent := FormatTimeFromMS(totaltimespent)
    formattedTotaltimespent74ul := FormatTimeFromMS(totaltimespent74ul)
    formattedTotaltimespent27k := FormatTimeFromMS(totaltimespent27k)
    maxCount := 0
    Loop, 20 {
        favload := "total" . A_Index . "loadouts"
        if (%favload% > maxCount) {
            maxCount := %favload%
            favLoadout := A_Index
        }
    }
    StatsX := A_ScreenWidth/2 - 140
    StatsY := A_ScreenHeight/2 - 282
    Gui, stats:New, -MinimizeBox, Statistics
    Gui, Color, 1C1C1C
    Gui, Font, cWhite
    
    gui, stats:Add, Groupbox, x10 y10 w260 h110 cWhite, Swaps
    Gui, stats:Add, Text, x30 y35 w230 cWhite vTotalSwapsText, Total Swaps: %totalswaps%
    Gui, stats:Add, Text, x30 y60 w230 cWhite vTotal74Text, Total 3074 UL Swaps: %totalswaps74ul%  
    Gui, stats:Add, Text, x30 y85 w230 cWhite vTotal27kText, Total 27k UL Swaps: %totalswaps27k%
    
    gui, stats:Add, Groupbox, x10 y120 w260 h110 cWhite, Time
    gui, stats:Add, Text, x30 y145 w230 cWhite vTotalTimeText, Total Time Spent: %formattedTotaltimespent%
    gui, stats:Add, Text, x30 y170 w230 cWhite vTotal74TimeText, Total Time Spent 3074 UL: %formattedTotaltimespent74ul%
    gui, stats:Add, Text, x30 y195 w230 cWhite vTotal27kTimeText, Total Time Spent 27k UL: %formattedTotaltimespent27k%
    
    gui, stats:Add, Groupbox, x10 y230 w260 h176 cWhite, Loadouts
    Gui, stats:Add, Text, x30 y250 w125 cWhite vTotalLoadsText, Total Loadouts: %totalloadouts%
    Gui, stats:Add, Text, x150 y250 w110 cWhite vFavLoadoutText, Favorite Loadout: %favLoadout%

    Loop 20 {
        i := A_Index
        val := total%i%loadouts
        row := Ceil(i / 4)         
        col := Mod(i - 1, 4) + 1 
        yPos := 278 + (row - 1) * 25  
        xPos := 30 + (col - 1) * 55   
        txt := i . "th: " . val
        Gui, stats:Add, Text, x%xPos% y%yPos% w60 cWhite vTotal%i%LoadText, %txt%
    }

    Gui, Font, s12
    UpdateStats()
    Gui, stats:Show, x%StatsX% y%StatsY% w280 h416
    return
settings:
    settingsgui()
    return
Setup:
    SetTitleMatchMode, 2
    SplitPath, processpath, filename, dir, ext, name_no_ext
    SplitPath, ConfigFile, ConfigFile2
    colorSWname := "Green"
    colorCFGname := "Green"
    if (name_no_ext == ""){
        if (unknown_sw != ""){
            name_no_ext := unknown_sw
        } else {
            name_no_ext := "NOT FOUND"
            colorSWname := "Red"
        }
    }
    if (ConfigFile == ""){
        ConfigFile2 := "NOT FOUND"
        colorCFGname := "Red"
    }
    WinGetPos, SettingsX, SettingsY,,, Made by k3f1r
    SetupY := SettingsY + 395
    SetupX := SettingsX - 185
    Gui, setup:New, -MinimizeBox, Setup
    Gui, Color, 1C1C1C
    Gui, Font, cWhite
    Gui, setup:Add, Text, x5 y5 c%colorRES%, Resolution: %A_ScreenWidth% x %A_ScreenHeight%
    Gui, setup:Add, Text, x5 y25 c%colorSWname%, Stopwatch Name: %name_no_ext%
    Gui, setup:Add, Text, x5 y45 c%colorCFGname%, Config: %ConfigFile2%
    if (colorRES == "Red") or (colorSWname == "Red") or (colorCFGname == "Red") or (colorRES == "Yellow"){
        Gui, setup:Add, Button, x45 y75 w90 gFixSetup, How to Fix
    } else {
        Gui, setup:Add, Text, x15 y75 cWhite, Everything should work properly!
    }
    Gui, setup:Show, x%SetupX% y%SetupY% w180 h115
    return
FixSetup:
if (colorRES == "Yellow"){
    msgbox The 3074 UL Duality macro and "Enhanced delay between" will not work. Only 1440p and 1080p are supported.
} else if (colorRES == "Red"){
    Gui, REDRES:New, +AlwaysOnTop
    Gui, Add, Text,, Your resolution is not supported. We need to find the coordinates of your loadouts. Please go to the loadouts screen and click OK. Then follow the instructions. 
    Gui, Add, Button, vOKButtonFix gOKWarningFix Disabled, OK (3)
    Gui, Show
    countdown := 3
    loop, 3 {
        sleep, 1000
        countdown -= 1
        GuiControl,, OKButtonFix, OK (%countdown%)
        if (countdown = 0) {
            GuiControl, Enable, OKButtonFix
            GuiControl,, OKButtonFix, OK
        }
    }   
} else if (colorSWname == "Red") or (colorCFGname == "Red"){
    msgbox Move the script to the "ahk" folder, which is located in the same folder as your .exe file. This isn't required - the macro will work without it - but some features, such as Auto-disable Buffering, may not function properly. 
}
return
OKWarningFix:
Gui, REDRES:destroy
WinActivate, ahk_exe destiny2.exe
Sleep, 10
send, {left}
Loop, 20 {
    ToolTip, Please Click on Loadout #%A_Index%, %timer_x%, %timer_y%, 1
    KeyWait, LButton, D
    MouseGetPos, x, y
    ToolTip
    IniWrite, %x%, loadouts_d2\CustomLoadoutsCoordinates.ini, settings, loadout%A_Index%_x
    IniWrite, %y%, loadouts_d2\CustomLoadoutsCoordinates.ini, settings, loadout%A_Index%_y
    Sleep, 500
}
reload
return
Ok:
If (langName() == "Non_English") {
    Gui, user_input: Destroy
    msgbox Don't swap ur language in this window pls :3`nSettings aren't saved
    settingsgui()
    return
} else {
    Gui, user_input: Submit
    Gui, user_input: Destroy
    if !RegExMatch(damage_loadout3074, "^[0-9]+$") || (damage_loadout3074 < 0) || (damage_loadout3074 > 20) {
        MsgBox Damage Loadout must be a number between 1 and 20
        settingsgui()
        return
    }
    if !RegExMatch(damage_loadout27k, "^[0-9]+$") || (damage_loadout27k < 0) || (damage_loadout27k > 20) {
        MsgBox Damage Loadout must be a number between 1 and 20
        settingsgui()
        return
    }
    if !RegExMatch(damage_loadout_both, "^[0-9]+$") || (damage_loadout_both < 0) || (damage_loadout_both > 20) {
        MsgBox Damage Loadout must be a number between 1 and 20
        settingsgui()
        return
    }
    if !RegExMatch(damage_loadout_none, "^[0-9]+$") || (damage_loadout_none < 0) || (damage_loadout_none > 20) {
        MsgBox Damage Loadout must be a number between 1 and 20
        settingsgui()
        return
    }
    if !RegExMatch(swap_time, "^[0-9]+$") {
        MsgBox Total Swap Time must contain only numbers
        settingsgui()
        return
    }
    if !RegExMatch(swap_time_27k, "^[0-9]+$") {
        MsgBox 27k Swap Time must contain only numbers
        settingsgui()
        return
    }
    if !RegExMatch(swap_time_none, "^[0-9]+$") {
        MsgBox No Port Swap Time must contain only numbers
        settingsgui()
        return
    }
    if !RegExMatch(time_between_loadouts, "^[0-9]+$") {
        MsgBox Delay Between Loadouts must contain only numbers
        settingsgui()
        return
    }
    if !RegExMatch(untick_delay, "^[0-9]+$") {
        MsgBox Untick Delay must contain only numbers
        settingsgui()
        return
    }
    if !RegExMatch(StopwatchBridgePollMs, "^[0-9]+$") || (StopwatchBridgePollMs < 50) || (StopwatchBridgePollMs > 2000) {
        MsgBox Bridge Poll must be a number between 50 and 2000
        settingsgui()
        return
    }
    SavePresetSettings(ActivePreset)
    FileDelete, loadouts_d2\LoadoutSettings.ini
    IniWrite, %settings_bind%, loadouts_d2\LoadoutSettings.ini, settings, SwapperSettingsBind
    IniWrite, %3074_ul_bind%, loadouts_d2\LoadoutSettings.ini, settings, 3074_ul_bind
    IniWrite, %3074_dl_bind%, loadouts_d2\LoadoutSettings.ini, settings, 3074_dl_bind
    IniWrite, %27k_ul_bind%, loadouts_d2\LoadoutSettings.ini, settings, 27k_ul_bind
    IniWrite, %SwapperHotkey%, loadouts_d2\LoadoutSettings.ini, settings, SwapperHotkey
    IniWrite, %27k_ul_swap%, loadouts_d2\LoadoutSettings.ini, settings, 27k_ul_swap
    IniWrite, %both_swap%, loadouts_d2\LoadoutSettings.ini, settings, both_swap
    IniWrite, %none_swap%, loadouts_d2\LoadoutSettings.ini, settings, none_swap
    IniWrite, %StopwatchBridgeEnabled%, loadouts_d2\LoadoutSettings.ini, settings, StopwatchBridgeEnabled
    IniWrite, %StopwatchBridgePollMs%, loadouts_d2\LoadoutSettings.ini, settings, StopwatchBridgePollMs
    IniWrite, %ActivePreset%, loadouts_d2\LoadoutSettings.ini, settings, ActivePreset
    IniWrite, %currentVersion%, loadouts_d2\LoadoutSettings.ini, version, version
    Run, "%A_ScriptFullPath%"
    ExitApp
    return
}
DisableSpeed:
Gui, WarningMsg:Destroy
CoordMode, Mouse, Screen
MouseGetPos, original_x, original_y
WinGet, previous_window, ID, A
processes := ["stopwatch.exe", "kanye4king.exe", "daisy.exe", "louis_stopball.exe", "chungus.exe", "10k.exe", "BitcoinMiner.exe", "estrogen.exe", "seawatch.exe", "S_re.exe"]
foundWindow := false
WinActivate, ahk_exe Destiny2.exe
for index, processName in processes {
    WinGet, windows, List, ahk_exe %processName%
    if windows {
        Loop % windows {
            windowID := windows%A_Index%
            WinGetPos, originalX, originalY,,, ahk_id %windowID%
            WinGetPos,,, width, height, ahk_id %windowID%
            centerX := (A_ScreenWidth - width) / 2
            centerY := (A_ScreenHeight - height) / 2
            WinGetTitle, windowTitle, ahk_id %windowID%
            if (windowTitle != "") and (windowtitle != "Ahk Manager"){
                WinMove, ahk_id %windowID%,, %centerX%, %centerY%
                foundWindow := true
                WinGetPos, winX, winY, width, height, ahk_id %windowID%
                clickX3 := winX + 285
                clickY3 := winY + 200
                sleep, 100
                WinActivate ahk_id %windowID%
                MouseMove, %clickX3%, %clickY3%, 0
                sleep, 100
                send, {lbutton down}
                sleep, 100
                send, {lbutton up}
                clickX3 := winX + 570
                clickY3 := winY + 95
                sleep, 100
                WinActivate ahk_id %windowID%
                MouseMove, %clickX3%, %clickY3%, 0
                sleep, 100
                send, {lbutton down}
                sleep, 100
                send, {lbutton up}
                clickX3 := winX + 585
                clickY3 := winY + 25
                sleep, 100
                WinActivate ahk_id %windowID%
                MouseMove, %clickX3%, %clickY3%, 0
                sleep, 500
                send, {lbutton down}
                sleep, 100
                send, {lbutton up}
                break 2
            }
        }
    }
}
WinMove, ahk_id %windowID%,, %originalX%, %originalY%
MouseMove, %original_x%, %original_y%, 0
WinActivate ahk_id %previous_window%
if (ConfigFile) {
    FileRead, ConfigContent, %ConfigFile%
    FileArray := StrSplit(ConfigContent, "`n", "`r")
    global Window_DisplaySpeed := false
    Loop % FileArray.Length() {
        currentLine := FileArray[A_Index]
        if (InStr(currentLine, """Window_DisplaySpeed"":"))
            global Window_DisplaySpeed := InStr(currentLine, "true") ? true : false
    }
}
if (Window_DisplaySpeed == True) {
    msgbox, Oops, something went wrong. Please turn off Display Connection Info yourself
}
return
OKWarning:
Gui, WarningMsg:Destroy
return
PresetSwitch:
    Loop 8 {
        Gui, user_input:Submit, NoHide
        if (PresetCb%A_Index% && A_Index != ActivePreset) {
            SavePresetSettings(ActivePreset)
            LoadPresetSettings(A_Index)
            
            Gui, user_input:Destroy
            ; Recreate hotkeys with new values
            Hotkey, IfWinActive, ahk_exe Destiny2.exe
            if (SwapperHotkey != "" && SwapperHotkey != "None")
                Hotkey, % "*~" SwapperHotkey, Swap_74ul, On
            if (27k_ul_swap != "" && 27k_ul_swap != "None")
                Hotkey, % "*~" 27k_ul_swap, Swap_27k, On
            if (both_swap != "" && both_swap != "None")
                Hotkey, % "*~" both_swap, Swap_both, On
            if (none_swap != "" && none_swap != "None")
                Hotkey, % "*~" none_swap, Swap_none, On
            if (settings_bind != "" && settings_bind != "None")
                Hotkey, % "*~" settings_bind, Settings, On
            Hotkey, IfWinActive
            settingsgui()
            break
        }
    }
return
Swap_74ul:
    if (WinActive("ahk_exe Destiny2.exe")) and (SwapsStarted != 1){
        SwapsStarted := 1
        Swaps(1, 0)
    }
return

Swap_27k:
    if (WinActive("ahk_exe Destiny2.exe")) and (SwapsStarted != 1){
        SwapsStarted := 1
        Swaps(0, 1)
    }
return

Swap_both:
    if (WinActive("ahk_exe Destiny2.exe")) and (SwapsStarted != 1){
        SwapsStarted := 1
        Swaps(1, 1)
    }
return

Swap_None:
    if (WinActive("ahk_exe Destiny2.exe"))
        RunNoSwapMode()
return