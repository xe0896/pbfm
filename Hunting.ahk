#Requires AutoHotkey v2.0
#SingleInstance Force

; Make the script DPI aware
DllCall("SetProcessDPIAware")

; Define all targets in a more structured way for easier maintenance
targets := [
    {x: 1254, y: 2071, colors: [0xDFB358]}, ; Run
    {x: 29, y: 1507, colors: [0xFFFFFF]}, ; Menu
    {x: 909, y: 880 + 1080, colors : [0x59B2E0]} ; Bag
]

; Set up the timer - slightly faster interval
SetTimer(CheckAllColorTargets, 600)

; Hotkey for the top-left button
':: 
{
    RunInCircles()
}

; Main function to check all color targets
CheckAllColorTargets() {
    static lastClickTime := 0
    static flag := false
    static stateChangeTime := 0
    ; Don't process if we clicked recently (prevents excessive clicking)
    if (A_TickCount - lastClickTime < 200)
        return
        
    ; Get DC once for all pixel checks
    hDC := DllCall("GetDC", "ptr", 0)
    
    ; Save current mouse position
    CoordMode("Mouse", "Screen")
    MouseGetPos(&originalX, &originalY)
    currentTime := A_TickCount
    
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
        ;ToolTip("Flag value: " flag)
        if (matched && target.x = 29 && !flag && currentTime - stateChangeTime > 2000) {
            BlockInput("On")
            Send("'")
            flag := true
            stateChangeTime := currentTime
            lastClickTime := A_TickCount
            BlockInput("Off")
        } else if (matched && flag && currentTime - stateChangeTime > 1000) {
            Sleep(2000)
            ClickAtPosition(target.x, target.y, 1)
            Sleep(100)
            flag := false
            stateChangeTime := currentTime
            lastClickTime := A_TickCount
            break  ; Only handle one match per cycle
        } else if (matched && target.x = 909 && !flag && currentTime - stateChangeTime > 1000) {
            flag := true
        }
    }
    
    ; Release DC
    DllCall("ReleaseDC", "ptr", 0, "ptr", hDC)
}

StrictClickAtPosition(x, y, x1, y1, input, hDC, color, color1) {
    relevantColor := DllCall("GetPixel", "ptr", hDC, "int", x, "int", y, "uint")
    comparisonColor := DllCall("GetPixel", "ptr", hDC, "int", x1 "int", y1, "uint")

}

RunInCircles() {
    ClickAtPosition(382, 1430, 0)

    Send("{W down}")
    Sleep(100)  ; Reduced sleep time for faster operation
    

    Send("{A down}")
    Sleep(100)  ; Reduced sleep time for faster operationl
    ClickAtPosition(382, 1430, 0)
    Send("{A up}")
    Send("{W up}")

    ClickAtPosition(382, 1430, 0)
}

; Function to click at a position and return to original positio;n
ClickAtPosition(x, y, double) {
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
    if (double) {
        MouseMove(1, 0, 0, "R")
        Send("{LButton down}")
        Sleep(5)  ; Reduced sleep time for faster operation
        Send("{LButton up}")
    }

    ; Return to original position
    DllCall("SetCursorPos", "int", ox, "int", oy)
}

; Exit script with Ctrl+Alt+X
#x::ExitApp()