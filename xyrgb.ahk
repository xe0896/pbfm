#Persistent
DllCall("SetProcessDPIAware")  ; Enable DPI awareness for accurate screen coordinates
SetTimer, TrackMouse, 200  ; Run TrackMouse function every 200ms

TrackMouse:
    ; Save the current cursor position
    CoordMode, Mouse, Screen  ; Coordinates are relative to the screen
    MouseGetPos, cursorX, cursorY  ; Get the current cursor position
    
    ; --- Get the RGB color at that position ---
    hDC := DllCall("GetDC", "ptr", 0)  ; Get device context
    colorValue := DllCall("GetPixel", "ptr", hDC, "int", cursorX, "int", cursorY, "uint")  ; Get the pixel color
    DllCall("ReleaseDC", "ptr", 0, "ptr", hDC)  ; Release the device context
    
    ; Check if GetPixel failed (invalid color)
    if (colorValue = 0xFFFFFFFF)
    {
        MsgBox, Failed to read pixel color. Try running as Administrator or check coordinates.
        return
    }

    ; Convert color from BGR to RGB
    red := (colorValue & 0xFF)
    green := (colorValue >> 8) & 0xFF
    blue := (colorValue >> 16) & 0xFF
    
    ; Display coordinates and RGB values using Format function
    formattedOutput := Format("Cursor Position: ({}, {})`nRGB: {} {} {} (0x{:06X})", cursorX, cursorY, red, green, blue, colorValue)
    ToolTip, %formattedOutput%  ; Display the result in a tooltip
    
return

^!x::ExitApp  ; Exit the script with Ctrl + Alt + X