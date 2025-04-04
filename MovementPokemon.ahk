#Requires AutoHotkey v2.0
#SingleInstance Force

; Make the script DPI aware
DllCall("SetProcessDPIAware")

; Define all targets in a more structured way for easier maintenance
targets := [
    {x: 829, y: 1290, colors: [0xFF5F33, 0xFF8B6B]},
    {x: 376, y: 2118, colors: [0x262626]},
    {x: 972, y: 1605, colors: [0xCCFF66]},
    {x: 824, y: 1756, colors: [0x302927]},
    {x: 975, y: 1313, colors: [0xFFFFFF]},
    {x: 639, y: 1946, colors: [0x050405]}, ; Variable
    {x: 802, y: 1555, colors: [0x3B3938]}
]

; Set up the timer - slightly faster interval
SetTimer(CheckAllColorTargets, 500)

; Hotkey for the top-left button
':: 
{
    ClickAtPosition(43, 1116)
}

; Main function to check all color targets
CheckAllColorTargets() {
    static lastClickTime := 0
    
    ; Don't process if we clicked recently (prevents excessive clicking)
    if (A_TickCount - lastClickTime < 200)
        return
        
    ; Get DC once for all pixel checks
    hDC := DllCall("GetDC", "ptr", 0)
    
    ; Save current mouse position
    CoordMode("Mouse", "Screen")
    MouseGetPos(&originalX, &originalY)
    
    ; Check all targets in order
    for target in targets {
        matched := false
        
        ; Check if any of the colors match for this target
        pixelColor := DllCall("GetPixel", "ptr", hDC, "int", target.x, "int", target.y, "uint")
        
        for expectedColor in target.colors {
            if (pixelColor = expectedColor) {
                matched := true
                break
            }
        }
        
        ; If matched, click the target
        if (matched) {
            ClickAtPosition(target.x, target.y)
            lastClickTime := A_TickCount
            break  ; Only handle one match per cycle
        }
    }
    
    ; Release DC
    DllCall("ReleaseDC", "ptr", 0, "ptr", hDC)
}

; Function to click at a position and return to original positio;n
ClickAtPosition(x, y) {
    ; Save current position
    CoordMode("Mouse", "Screen")
    MouseGetPos(&ox, &oy)
    
    ; Move, click, and return in one smooth operation
    DllCall("SetCursorPos", "int", x, "int", y)
    Sleep(10)  ; Small delay for stability
    
    ; Small offset click for better reliability
    MouseMove(1, 0, 0, "R")
    Send("{LButton down}")
    Sleep(5)  ; Reduced sleep time for faster operation
    Send("{LButton up}")
    
    ; Return to original position
    DllCall("SetCursorPos", "int", ox, "int", oy)
    
}

; Exit script with Ctrl+Alt+X
^!x::ExitApp()