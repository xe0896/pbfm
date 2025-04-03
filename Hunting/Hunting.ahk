#Persistent
SetTimer, SecondMonitorClick, 2000

SecondMonitorClick:
    ; Save original mouse position
    CoordMode, Mouse, Screen
    MouseGetPos, oX, oY
    
    ; Target coordinates for second monitor
    targetX := 1955
    targetY := 3070
    
    ; Move to target position
    DllCall("SetCursorPos", "int", targetX, "int", targetY)
    
    ; Improved multi-monitor pixel capture
    hScreenDC := DllCall("GetDC", "ptr", 0)
    hMemDC := DllCall("CreateCompatibleDC", "ptr", hScreenDC)
    hBitmap := DllCall("CreateCompatibleBitmap", "ptr", hScreenDC, "int", 1, "int", 1)
    DllCall("SelectObject", "ptr", hMemDC, "ptr", hBitmap)
    DllCall("BitBlt", "ptr", hMemDC, "int", 0, "int", 0, "int", 1, "int", 1, "ptr", hScreenDC, "int", targetX, "int", targetY, "uint", 0x40CC0020)
    
    ; Get the pixel data
    VarSetCapacity(pixel, 4, 0)
    DllCall("GetBitmapBits", "ptr", hBitmap, "uint", 4, "ptr", &pixel)
    colorValue := NumGet(pixel, 0, "uint")
    
    ; Clean up
    DllCall("DeleteObject", "ptr", hBitmap)
    DllCall("DeleteDC", "ptr", hMemDC)
    DllCall("ReleaseDC", "ptr", 0, "ptr", hScreenDC)
    
    ; Check if we got a valid reading
    if (colorValue = 0xFFFFFFFF || colorValue = 0) ; Common error values
    {
        ToolTip, Could not read color from second monitor
    }
    else
    {
        ; Convert BGR to RGB
        red := (colorValue & 0xFF)
        green := (colorValue >> 8) & 0xFF
        blue := (colorValue >> 16) & 0xFF
        
        ; Format the display
        colorDisplay := Format("Secondary Monitor RGB: {1},{2},{3} (0x{:06X})", red, green, blue, colorValue)
        ToolTip, %colorDisplay%
    }
    
    ; Perform the click
    DllCall("mouse_event", "uint", 0x02, "uint", 0, "uint", 0, "uint", 0, "ptr", 0) ; Down
    DllCall("mouse_event", "uint", 0x04, "uint", 0, "uint", 0, "uint", 0, "ptr", 0) ; Up
    
    ; Return to original position
    DllCall("SetCursorPos", "int", oX, "int", oY)
    
    ; Remove tooltip after 2 seconds
    SetTimer, RemoveToolTip, -2000
return

RemoveToolTip:
    ToolTip
return

^!x::ExitApp