;////////////////////////////////////////////////////////////////////////////////////////////////
/*
    Setup DB File Edit GUI
*/
;////////////////////////////////////////////////////////////////////////////////////////////////
Gui, EditF:Margin, 10, 10
Gui, EditF:+HwndEf -MinimizeBox
Gui, EditF:Color, 0xD8D8AD
Gui, EditF:Font, s15 Bold, Calibri
Gui, EditF:Add, ListView, % "HwndHCtrl xm ym w900 r20 vLV Grid", % _63 "| |" _38 "|" _68 "|" _69
SetExplorerTheme(HCtrl)
Gui, EditF:Default
Gui, EditF:ListView, LV
LV_ModifyCol(1, "0")
LV_ModifyCol(2, "0")
LV_ModifyCol(3, 299 " Center")
LV_ModifyCol(4, 299 " Center")
LV_ModifyCol(5, 298 " Center")
Gui, EditF:Add, Button, % "xp+350 yp+600 w200 gApplyEdit HwndHCtrl", % _132
ImageButton.Create(HCtrl, [[0, 0xFFFFFF, , 0x008000, 0, , 0x008000, 1]
                         , [0, 0x008000, , 0xFFFFFF, 0, , 0x008000, 1]
                         , [0, 0x008000, , 0xFFFF00, 0, , 0x008000, 1]
                         , [0, 0xB2B2B2, , 0x000000, 0, , 0x000000, 1]]*)
;////////////////////////////////////////////////////////////////////////////////////////////////