#Requires AutoHotkey v2.0

class Swapper {
    static IsSwapping := false
    static CancelRequested := false

    static Trigger(profile, *) {
    if this.IsSwapping
        return

    ; Only execute if Destiny 2 is the active window
    if D2SWAPPER_NEEDS_D2 && !WinActive("ahk_exe destiny2.exe")
        return

    ; Safety check: ensure at least one loadout slot is enabled
    if (profile.LoadoutGrid.Length == 0) {
        ToolTip("切换已中止：配置 " profile.Name " 未选择任何装备槽！")
        SetTimer(() => ToolTip(), -2500)
        SoundPlay("*16")
        return
    }

    ; ===== 开始前：先按 i，再按左方向键 =====
    Send("{i}")
    Sleep(520)
    Send("{Left}")
    Sleep(100)
    ; =========================================

    ; Sort loadouts in numerical ascending order
    sequence := profile.LoadoutGrid.Clone()
    this.SortAscending(sequence)

    this.IsSwapping := true
    this.CancelRequested := false

    try {
        this.RunLoop(profile, sequence)
    } finally {
        ToolTip()
        this.IsSwapping := false
    }

    ; ===== 切装完成后：点击最终配装，再按两次 Esc =====
    if (!this.CancelRequested) {
        Sleep(100)

        ; 如果设置了最终配装（1-20），先点击它
        if (profile.FinalLoadout >= 1 && profile.FinalLoadout <= 20) {
            resData := Coordinates.Get()
            if (resData.Loadouts.Has(profile.FinalLoadout)) {
                finalCoord := resData.Loadouts[profile.FinalLoadout]
                DllCall("SetCursorPos", "Int", finalCoord.X, "Int", finalCoord.Y)
                Sleep(50)
                this.ClickMouse()
                Sleep(200)
            }
        }

        ; 两次 Esc
        Send("{Esc}")
        Sleep(80)
        Send("{Esc}")
    }
}

    static RunLoop(profile, sequence) {
        resData := Coordinates.Get()
        
        ; Normalize gear key (e.g. "Class Item" -> "ClassItem")
        gearKey := StrReplace(profile.SelectedGear, " ", "")
        if (!resData.Gear.Has(gearKey))
            gearKey := "Helmet"
        gearCoord := resData.Gear[gearKey]

        ; Tooltip placement below slot 20
        slot20 := resData.Loadouts[20]
        slot16 := resData.Loadouts[16]
        rowDelta := slot20.Y - slot16.Y
        ttX := slot20.X - Round(rowDelta * 0.5) - resData.MonitorOffset[1]
        ttY := slot20.Y + Round(rowDelta * 0.65) - resData.MonitorOffset[2]

        currentSwaps := 0
        targetSwaps := profile.TargetSwaps

        ; 1: Move cursor to first slot in the ascending sequence
        firstSlot := sequence[1]
        firstCoord := resData.Loadouts[firstSlot]
        DllCall("SetCursorPos", "Int", firstCoord.X, "Int", firstCoord.Y)

        ; 2: wait for a frame to render and sample the initial gear pixel color
        ; 50ms should be about 20fps which should be fine for most players
        Sleep(50)
        lastGearColor := PixelGetColor(gearCoord[1], gearCoord[2], "RGB")
        
        ToolTip(currentSwaps "/" targetSwaps, ttX, ttY)
        
        ; 3: Perform initial click
        this.ClickMouse()

        currentIndex := 1
        seqLen := sequence.Length

        ; Sub-interval tick callback for high-frequency pixel monitoring (~125 Hz)
        onTick() {
            if (this.CancelRequested)
                return true

            currentColor := PixelGetColor(gearCoord[1], gearCoord[2], "RGB")
            if (currentColor != lastGearColor) {
                currentSwaps++
                lastGearColor := currentColor
                ToolTip("D2SRC " D2SWAPPER_VERSION " | " currentSwaps "/" targetSwaps, ttX, ttY)

                if (currentSwaps >= targetSwaps)
                    return true ; Abort sleep immediately
            }
            return false
        }

        ; 4: Main swap loop
        while (!this.CancelRequested && currentSwaps < targetSwaps) {
            ; Advance to next slot in the sequence
            currentIndex := Mod(currentIndex, seqLen) + 1
            nextSlot := sequence[currentIndex]
            coord := resData.Loadouts[nextSlot]

            ; Precise sleep with sub-interval pixel checking throughout the delay
            clickDelay := ConfigManager.ClampClickDelay(profile.ClickDelay)
            HighResTimer.Sleep(clickDelay, onTick)

            if (this.CancelRequested || currentSwaps >= targetSwaps)
                break

            ; Move cursor to next slot
            ; We don't need to wait for the animation frame since the slots won't
            ; while you're in the loadout screen regardless of resolution
            DllCall("SetCursorPos", "Int", coord.X, "Int", coord.Y)

            ; Click slot
            this.ClickMouse()
        }

        ToolTip()
    }

    static Cancel() {
        if this.IsSwapping {
            this.CancelRequested := true
            ToolTip()
            this.IsSwapping := false
            ; Restart script minimized so it doesn't steal focus or pop up over Destiny 2
            Run('"' A_AhkPath '" "' A_ScriptFullPath '" /min')
            ExitApp()
        }
    }

    static ClickMouse() {
        DllCall("mouse_event", "UInt", 0x0002, "Int", 0, "Int", 0, "UInt", 0, "UPtr", 0) ; Left Down
        DllCall("mouse_event", "UInt", 0x0004, "Int", 0, "Int", 0, "UInt", 0, "UPtr", 0) ; Left Up
    }

    static SortAscending(arr) {
        n := arr.Length
        if (n <= 1)
            return

        loop n - 1 {
            i := A_Index
            loop n - i {
                j := A_Index
                if (arr[j] > arr[j + 1]) {
                    tmp := arr[j]
                    arr[j] := arr[j + 1]
                    arr[j + 1] := tmp
                }
            }
        }
    }
}
