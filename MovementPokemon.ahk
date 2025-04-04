#Persistent
#SingleInstance, Force
DllCall("SetProcessDPIAware")
SetTimer, CheckForExactColorMatch, 500

BluePlayButton := [829, 1290, 0xFF5F33] ; Could be 0xFF8B6B, make some tests

exactTargetX := 829
exactTargetY := 1290
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

annoyingTextX := 975
annoyingTextY := 1313
annoyingColor := 0xFFFFFF

Array := 

':: ; Handles the top-left button input
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
    annoyingPixelColor := DllCall("GetPixel", "ptr", hDC, "int", annoyingTextX, "int", annoyingTextY, "uint")
    
    DllCall("ReleaseDC", "ptr", 0, "ptr", hDC)

    if (annoyingPixelColor = annoyingColor) {
        ox := originalX
        oy := originalY
        
        DllCall("SetCursorPos", "int", annoyingTextX, "int", annoyingTextY)
        Sleep, 100
        MouseMove, 1, 0, 0, R
        SendInput {LButton down}
        Sleep, 10
        SendInput {LButton up}
        MouseMove, -1, 0, 0, R
        
        Sleep, 50
        MouseMove, ox, oy, 0
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

    }
return

RemoveToolTip:
    ToolTip
return

^!x::ExitApp