#Persistent
#SingleInstance, Force
DllCall("SetProcessDPIAware")
SetTimer, CheckForExactColorMatch, 500

exactTargetX := 829
exactTargetY := 1330
exactTargetColorBlue := 0xFF5F33
exactTargetColorLightBlue := 0xFF8B6B

newTargetX := 376
newTargetY := 2118
newTargetColor := 0x262626

thirdTargetX := 972
thirdTargetY := 1605
thirdTargetColor := 0xCCFF66

fourthTargetX := 824
fourthTargetY := 1756
fourthTargetColor := 0x302927

':: 
    CoordMode, Mouse, Screen
    MouseGetPos, originalX, originalY
    DllCall("SetCursorPos", "int", 43, "int", 1116)
    Click
    DllCall("SetCursorPos", "int", originalX, "int", originalY)
return

CheckForExactColorMatch:
    CoordMode, Mouse, Screen
    MouseGetPos, originalX, originalY
    
    hDC := DllCall("GetDC", "ptr", 0)
    
    pixelColor := DllCall("GetPixel", "ptr", hDC, "int", exactTargetX, "int", exactTargetY, "uint")
    newPixelColor := DllCall("GetPixel", "ptr", hDC, "int", newTargetX, "int", newTargetY, "uint")
    thirdPixelColor := DllCall("GetPixel", "ptr", hDC, "int", thirdTargetX, "int", thirdTargetY, "uint")
    fourthPixelColor := DllCall("GetPixel", "ptr", hDC, "int", fourthTargetX, "int", fourthTargetY, "uint")
    
    DllCall("ReleaseDC", "ptr", 0, "ptr", hDC)
    
    if (pixelColor = 0xFFFFFFFF || newPixelColor = 0xFFFFFFFF || thirdPixelColor = 0xFFFFFFFF) {
        ToolTip, Could not read pixels
        SetTimer, RemoveToolTip, -2000
        return
    }
    
    if (pixelColor = exactTargetColorBlue || pixelColor = exactTargetColorLightBlue) {
        ox := originalX
        oy := originalY
        
        DllCall("SetCursorPos", "int", exactTargetX, "int", exactTargetY)
        Sleep, 100
        MouseMove, 1, 0, 0, R
        SendInput {LButton down}
        Sleep, 10
        SendInput {LButton up}
        MouseMove, -1, 0, 0, R
        
        Sleep, 50
        MouseMove, ox, oy, 0
        
        ToolTip, Clicked! Exact match at %exactTargetX%,%exactTargetY%
        SetTimer, RemoveToolTip, -1000
        return
    }
    
    if (newPixelColor = newTargetColor) {
        ox := originalX
        oy := originalY
        
        DllCall("SetCursorPos", "int", newTargetX, "int", newTargetY)
        Sleep, 100
        MouseMove, 1, 0, 0, R
        SendInput {LButton down}
        Sleep, 10
        SendInput {LButton up}
        MouseMove, -1, 0, 0, R
        
        Sleep, 50
        MouseMove, ox, oy, 0
        
        ToolTip, Clicked! Exact match at %newTargetX%,%newTargetY%
        SetTimer, RemoveToolTip, -1000
        return
    }
    
    if (thirdPixelColor = thirdTargetColor) {
        ox := originalX
        oy := originalY
        
        DllCall("SetCursorPos", "int", thirdTargetX, "int", thirdTargetY)
        Sleep, 100
        MouseMove, 1, 0, 0, R
        SendInput {LButton down}
        Sleep, 10
        SendInput {LButton up}
        MouseMove, -1, 0, 0, R
        
        Sleep, 50
        MouseMove, ox, oy, 0
        
        ToolTip, Clicked! Exact match at %thirdTargetX%,%thirdTargetY%
        SetTimer, RemoveToolTip, -1000
    }

    if (fourthPixelColor = fourthTargetColor) {
        ox := originalX
        oy := originalY
        
        DllCall("SetCursorPos", "int", fourthTargetX, "int", fourthTargetY)
        Sleep, 100
        MouseMove, 1, 0, 0, R
        SendInput {LButton down}
        Sleep, 10
        SendInput {LButton up}
        MouseMove, -1, 0, 0, R
        
        Sleep, 50
        MouseMove, ox, oy, 0
        
        ToolTip, Clicked! Exact match at %fourthTargetX%,%fourthTargetY%
        SetTimer, RemoveToolTip, -1000
    }
return

RemoveToolTip:
    ToolTip
return

^!x::ExitApp