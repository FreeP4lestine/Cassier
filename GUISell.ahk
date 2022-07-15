;//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*
    Setup sell GUI
*/
;//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#SingleInstance, Force

#Include, Lib\Classes\Class_CtlColors.ahk
#Include, Lib\Classes\Class_ImageButton.ahk
#Include, Lib\Classes\Class_GDIplus.ahk

#Include, Lib\Language.ahk

Gui, +HwndMain
Gui, Margin, 10, 10
Gui, Color, 0xD8D8AD
Gui, Font, s18 Bold, Calibri
Gui, Add, Button, % "x" A_ScreenWidth - 120 " y" A_ScreenHeight - 110 " w101 h35 HwndHCtrl gLaunchKeyboard"
ImageButton.Create(HCtrl, [[0, "Img\KBD\1.png"]
                         , [0, "Img\KBD\2.png"]
                         , [0, "Img\KBD\3.png"]
                         , [0, "Img\KBD\4.png"]]*)

Gui, Add, Edit, % "xm y" A_ScreenHeight - 340 " HwndE w190 vItemsSold -E0x200 ReadOnly Center Border -VScroll Hidden " , 0
Gui, Add, Edit, % "xp yp+" 40 " HwndE w190 vSoldP -E0x200 r2 ReadOnly Center Border -VScroll Hidden cGreen", 0
Gui, Add, Edit, % "xp yp+" 70 " HwndE w190 vCostP -E0x200 r2 ReadOnly Center Border -VScroll Hidden cRed", 0
Gui, Add, Edit, % "xp yp+" 70 " HwndE w190 vProfitP -E0x200 r2 ReadOnly Center Border -VScroll Hidden cGreen", 0
Gui, Font, s18

Gui, Add, Button, % "x" 230 + (A_ScreenWidth - 235) / 3 " y31 vAddEnter gEnter  w48 h46 HwndHCtrl"
ImageButton.Create(HCtrl, [ [0, "Img\AC\1.png"]
, [0, "Img\AC\2.png"]
, [0, "Img\AC\3.png"]
, [0, "Img\AC\4.png"]]* )
Gui, Font, s15
Gui, Add, Button, % "x225 y30 vSubKridi gSubKridi HwndHCtrl w100 Hidden", % _29
ImageButton.Create(HCtrl, [[0, 0xFFFFFF, , 0x008000, 0, , 0x008000, 1]
                         , [0, 0x008000, , 0xFFFFFF, 0, , 0x008000, 1]
                         , [0, 0x008000, , 0xFFFF00, 0, , 0x008000, 1]
                         , [0, 0xB2B2B2, , 0xFFFFFF, 0, , 0x000000, 2]]* )
Gui, Font, s25
pw := (A_ScreenWidth - 235) / 3
Gui, Add, Edit, % "xp yp+55 w" pw " h45 vGivenMoney -E0x200 gCalc Center Border Hidden"
Gui, Add, Edit, % "xp+" pw " yp wp h45 vAllSum HwndAS -E0x200 ReadOnly Center Border cGreen Hidden"
Gui, Add, Edit, % "xp+" pw " yp wp h45 vChange HwndC -E0x200 ReadOnly Center Border cRed Hidden"

Gui, Font, s25
Gui, Add, Edit, % "x225 y30 w" pw " -VScroll vBc Center -E0x200 gAnalyzeAvail Border HwndHCtrl "
CtlColors.Attach(HCtrl, "FFFFFF", "008000")
Gui, Add, Edit, % "xp yp+55 wp vNm h45 -E0x200 ReadOnly Center  Border"
Gui, Add, Edit, % "xp+" pw " yp wp h45 vQn Center -E0x200 ReadOnly  Border cRed"
Gui, Add, Edit, % "xp+" pw " wp h45 -E0x200 ReadOnly Center  Border vSum"

Gui, Font, s15
Gui, Add, Text, % "xp+25 yp+55 wp-25 vAllSumText cRed ", % _122 ":"
Gui, Add, Edit, % "xp yp+30 wp vThisListSum -E0x200 Border ReadOnly HwndHCtrl "
CtlColors.Attach(HCtrl, "FFFFFF", "FF0000")

Gui, Add, Text, % "xp yp+80 wp vRemiseText ", % _123 ":"
Gui, Add, Edit, % "xp yp+30 w100 vRemise -E0x200 Border Number gRemise  cGreen Disabled"

Gui, Add, Text, % "xp yp+35 w" pw - 25 " vClientText ", % _124 ":"
Gui, Add, Edit, % "xp yp+30 wp vClient -E0x200 Border gClient  Disabled"

Gui, Add, Text, % "xp yp+35 wp vSellDescText ", % _125 ":"
Gui, Add, Edit, % "xp yp+30 wp vSellDesc gSellDesc cBlue h" A_ScreenHeight - 534 " -E0x200 Border -VScroll Disabled"

Gui, Font, s12
AdditionalInfo := 0
Gui, Add, Text, % "xp+30 yp-194 wp-32 h30 gAdditionalInfo vAdditionalInfoText ", % " [" _127 "]"
Gui, Add, Pic, % "xp-30 yp-4 w30 h30 gAdditionalInfo vAdditionalInfoPic ", Img\MID.png

Gui, Font, s16
Gui, Add, Text, % "x225 yp-79 w" pw*2 - 31 " h30 vTransc HwndTHCtrl Right  gViewLastTrans"
CtlColors.Attach(THCtrl, "B2B2B2")
Gui, Add, Pic, % "x" 225 + pw*2 - 31 " yp w30 h30 vTranscOK  gViewLastTrans", Img\Idle.png

Gui, Font, s18
Gui, Add, ListView, % "HwndHCtrl x225 yp+33 w" pw*2 " h" A_ScreenHeight - 290 " vListView Grid ", % _63 "|" _61 "|" _38 "|" _68 "|" _69
SetExplorerTheme(HCtrl)

LV_ModifyCol(1, "0 Center")

AdminName := "ADM"

LV_ModifyCol(2, pw / 2)
LV_ModifyCol(3, pw / 2 " Center")
LV_ModifyCol(4, pw / 2 " Center")
LV_ModifyCol(5, pw / 2 " Center")

Gui, Font, s15

BMBTN := [[0, 0xFFFFFF, , 0x000000, 0, , 0x000000, 1]
        , [0, 0x717100, , 0xFFFFFF, 0, , 0x717100, 1]
        , [0, 0x717100, , 0xFFFF00, 0, , 0x717100, 1]
        , [0, 0xD8D8AD, , 0xFF0000, 0, , 0xD8D8AD, 1]]

Gui, Add, Button, % "xp y" A_ScreenHeight - 100 " w30 h25 vSession1 HwndHCtrl gSession1 ", 1
ImageButton.Create(HCtrl, BMBTN*)
Gui, Add, Button, % "xp+35 yp wp hp vSession2 HwndHCtrl gSession2 ", 2
ImageButton.Create(HCtrl, BMBTN*)
Gui, Add, Button, % "xp+35 yp wp hp vSession3 HwndHCtrl gSession3 ", 3
ImageButton.Create(HCtrl, BMBTN*)
Gui, Add, Button, % "xp+35 yp wp hp vSession4 HwndHCtrl gSession4 ", 4
ImageButton.Create(HCtrl, BMBTN*)
Gui, Add, Button, % "xp+35 yp wp hp vSession5 HwndHCtrl gSession5 ", 5
ImageButton.Create(HCtrl, BMBTN*)
Gui, Add, Button, % "xp+35 yp wp hp vSession6 HwndHCtrl gSession6 ", 6
ImageButton.Create(HCtrl, BMBTN*)
Gui, Add, Button, % "xp+35 yp wp hp vSession7 HwndHCtrl gSession7 ", 7
ImageButton.Create(HCtrl, BMBTN*)
Gui, Add, Button, % "xp+35 yp wp hp vSession8 HwndHCtrl gSession8 ", 8
ImageButton.Create(HCtrl, BMBTN*)
Gui, Add, Button, % "xp+35 yp wp hp vSession9 HwndHCtrl gSession9 ", 9
ImageButton.Create(HCtrl, BMBTN*)
Gui, Add, Button, % "xp+35 yp wp hp vSession10 HwndHCtrl gSession10 ", 10
ImageButton.Create(HCtrl, BMBTN*)
Gui, Show, , Sell GUI

Loop, 10 {
    Gui, Add, Text, % "y" A_Index + 10 " x" 210 + A_Index " w" A_ScreenWidth - 410 " h1 HwndHCtrl"
    CtlColors.Attach(HCtrl, "717100")
}

Gui, Add, Text, % "y21 x221 w" A_ScreenWidth - 230 " h2 HwndHCtrl"
CtlColors.Attach(HCtrl, "717100")
Gui, Add, Edit, % "x" A_ScreenWidth - 189 " y5 w180 vNowTime -E0x200 HwndHCtrl Center h15", ---
CtlColors.Attach(HCtrl, "D8D8AD")
Loop, 10 {
    Gui, Add, Text, % "y" A_Index + 12 " x" 208 + A_Index " w1 h" A_ScreenHeight - 90 " HwndHCtrl"
    CtlColors.Attach(HCtrl, "717100")
}
Loop, 10 {
    Gui, Add, Text, % "y" A_Index + A_ScreenHeight - 78 " x" 3 + A_Index " w203 h1 HwndHCtrl"
    CtlColors.Attach(HCtrl, "717100")
}


AdminName := A_Args[1]
AdminPass := A_Args[2]

GuiControl, Disabled, Session1
Selling     := 0
ProdDefs    := LoadDefinitions()
Session     := 1
If FileExist("Dump\" Session ".session") {
    RestoreSession()
    CalculateSum()
}
Return

#Include, GUISell_Hotkeys.ahk
#Include, GUISell_Functions.ahk
#Include, GUISell_Labels.ahk
;//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////