;//////////////////////////////////////////////////////////////////////////////////////
/*
    Setup Loading GUI
*/
;//////////////////////////////////////////////////////////////////////////////////////
Gui, Load: -Caption
Gui, Load: Color, 0x717100
Gui, Load: Margin, 3, 3
Gui, Load: Add, Progress, HwndCtrl +0x00000008 c0x717100 w300 Border BackgroundWhite
DllCall("User32.dll\SendMessage", "Ptr", Ctrl, "Int", 0x0000040A, "Ptr", 1, "Ptr", 50)
;//////////////////////////////////////////////////////////////////////////////////////