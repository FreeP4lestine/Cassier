;////////////////////////////////////////////////////////////////////////////////////////////////
/*
    Setup Kridi GUI
*/
;////////////////////////////////////////////////////////////////////////////////////////////////
Gui, Kridi:+HwndKr +Resize
Gui, Kridi:Color, 0xD8D8AD
Gui, Kridi:Margin, 10, 10
Gui, Kridi:Font, s15 Bold, Calibri
Gui, Kridi:Add, Edit, w200 vKName -E0x200 Border gCheckKExist
Gui, Kridi:Font, s13
Gui, Kridi:Add, Button, xm+210 ym w100 h33 HwndHCtrl gEnter, % _36
ImageButton.Create(HCtrl, [[0, 0xFFFFFF, , 0x008000, 0, , 0x008000, 1]
                         , [0, 0x008000, , 0xFFFFFF, 0, , 0x008000, 1]
                         , [0, 0x008000, , 0xFFFF00, 0, , 0x008000, 1]
                         , [0, 0xB2B2B2, , 0xFFFFFF, 0, , 0x000000, 2]]* )
Gui, Kridi:Font, s15
Gui, Kridi:Add, ListBox, w200 xm ym+40 vKLB h450 gWriteItDown 
Gui, Kridi:Add, ListView, xm+210 ym+40 w760 h435 Grid cBlue HwndHCtrl, Col1|Col2|Col3|Col4|Col5
SetExplorerTheme(HCtrl)
Gui, Kridi:Default
LV_ModifyCol(1, 0)
LV_ModifyCol(2, 190)
LV_ModifyCol(3, 190)
LV_ModifyCol(4, 190)
LV_ModifyCol(5, 190)
Gui, Kridi:Add, Edit, xm+550 ym w200 h33 -E0x200 Border ReadOnly vTotal Center
Gui, Kridi:Add, Edit, xm+768 ym w200 h33 -E0x200 Border ReadOnly vThisTotal Center cRed HwndE
CtlColors.Attach(E, "FFFFFF", "000000")
;////////////////////////////////////////////////////////////////////////////////////////////////