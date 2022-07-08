;////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*
    Setup ensure GUI
*/
;////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
EnsureCtrlList := "LV1,LV10,EnsBtn,DeleteCurr,EditCurr,Currents,Chart,SortCurr,SearchByCText,SearchByC,$Sold,$Bought,$ProfitEq,$SoldText,$BoughtText,$ProfitEqText"
Gui, Main:Font, s15
Gui, Main:Add, Button, x225 y30 vEnsBtn w300 h40 HwndHCtrl Hidden gValid, % _9
ImageButton.Create(HCtrl, [[0, 0xFFFFFF, , 0x008000, 0, , 0x008000, 1]
                         , [0, 0x008000, , 0xFFFFFF, 0, , 0x008000, 1]
                         , [0, 0x008000, , 0xFFFF00, 0, , 0x008000, 1]
                         , [0, 0xB2B2B2, , 0x000000, 0, , 0x000000, 1]]*)
Gui, Main:Add, DDL, xp yp+50 w300 vCurrents Hidden gDisplayEqCurr, % _74 "||"
Gui, Main:Add, ListView, % "xp yp+40 w" (pw := A_ScreenWidth - 600) " h" A_ScreenHeight - 325 " Grid vLV1 HwndHCtrl Hidden -Multi", % _70 "|" _71 "|" _79
SetExplorerTheme(HCtrl)
Gui, Main:Default
Gui, Main:ListView, LV1
LV_ModifyCol(1, "0")
LV_ModifyCol(2, 350)
LV_ModifyCol(3, pw - 355)
Gui, Main:Add, ListView, % "xp+" pw+25 " BackgroundD8D8AD yp+40 w335 hp-40 vLV10 Hidden -Multi -Hdr HwndHCtrl", % "Col1|Col2"
SetExplorerTheme(HCtrl)
Gui, Main:ListView, LV10
LV_ModifyCol(1, 200)
LV_ModifyCol(2, 131)

Gui, Main:Add, DDL, % "xp yp-40 wp vSortCurr gSortCurr Hidden", % _68 "||" _129 "|" _39 "|" _138
Gui, Main:Add, Edit, % "xp yp-40 wp Center Border -E0x200 vSearchByC gSortCurr Hidden"
Gui, Main:Font, s13
Gui, Main:Add, Text, % "xp yp-30 wp Center vSearchByCText Hidden", % _139 ":"
Gui, Main:Add, Button, % "xp-157 y80 w132 h32 vDeleteCurr Hidden gDeleteCurr HwndHCtrl", % "        " _130
ImageButton.Create(HCtrl, [ [0, "Img\DEC\1.png",, 0xFF0000]
                          , [0, "Img\DEC\2.png",, 0x0080FF]
                          , [0, "Img\DEC\3.png",, 0xFF0000]
                          , [0, "Img\DEC\4.png"]]*)
Gui, Main:Add, Button, % "xp-142 yp wp hp vEditCurr Hidden gEditCurr HwndHCtrl", % "        " _131
ImageButton.Create(HCtrl, [ [0, "Img\DEE\1.png",, 0x008000]
                          , [0, "Img\DEE\2.png",, 0x0080FF]
                          , [0, "Img\DEE\3.png",, 0x008000]
                          , [0, "Img\DEE\4.png"]]*)
Gui, Main:Font, s20
Gui, Main:Add, Edit, % "x225 y" A_ScreenHeight - 135 " w" pw/3 " vSold Center -E0x200 ReadOnly cGreen Border Hidden"
Gui, Main:Font, s15

Gui, Main:Add, Text, % "xp yp-30 wp vSoldText Hidden Center gShowRemise", % _133 ":"
Gui, Main:Font, s20
Gui, Main:Add, Edit, % "xp+" pw/3 " yp+30 wp vBought -E0x200 ReadOnly Center cRed Border Hidden"
Gui, Main:Font, s15

Gui, Main:Add, Text, % "xp yp-30 wp vBoughtText Hidden Center", % _134 ":"

Gui, Main:Font, s20
Gui, Main:Add, Edit, % "xp+" pw/3 " yp+30 wp vProfitEq -E0x200 ReadOnly Center cGreen Border Hidden"
Gui, Main:Font, s15

Gui, Main:Add, Text, % "xp yp-30 wp vProfitEqText Hidden Center gShowRemise", % _135 ":"
;////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////