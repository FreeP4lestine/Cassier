;////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*
    Setup stock GUI
*/
;////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
StockPileCtrlList := "SBc,SBcT,SLB,SMetaData,SNum,SNumP,SNumM,SNumC,ProductInfo,SSave,STotal,RestAllS,RestSelS"
Gui, Main:Font, s13
Gui, Main:Add, Text, % "x225 y30 w300 vSBcT Hidden Center", % _139 ":"
Gui, Main:Font, s15
Gui, Main:Add, Edit, % "xp yp+40 w300 Center vSBc -E0x200 Hidden Border gSearchStock"
Gui, Main:Add, ListBox, % "AltSubmit x225 yp+50 w300 h" A_ScreenHeight - 300 " HwndHCtrl vSLB Hidden gDisplayStockEq"
CtlColors.Attach(HCtrl, "D8D8AD")
Gui, Main:Add, Button, % "w300 vRestAllS HwndHCtrl h38 gRESETALL Hidden", % _142
ImageButton.Create(HCtrl, [ [0, 0xFFFFFF, , 0xFF0000, 0, , 0xFF0000, 1]
                          , [0, 0xFF0000, , 0xFFFFFF, 0, , 0xFF0000, 1]
                          , [0, 0xFF0000, , 0xFFFF00, 0, , 0xFF0000, 1]
                          , [0, 0x6C7174, , 0xFFFFFF, 0, , 0xFFFFFF, 1]]*)
Gui, Main:Font, s13
Gui, Main:Add, Button, % "xp yp+42 w300 vRestSelS HwndHCtrl hp-2 gRESETSEL Hidden", % _143
ImageButton.Create(HCtrl, [ [0, 0xFFFFFF, , 0x0080FF, 0, , 0x0080FF, 1]
                          , [0, 0x0080FF, , 0xFFFFFF, 0, , 0x0080FF, 1]
                          , [0, 0x0080FF, , 0xFFFF00, 0, , 0x0080FF, 1]
                          , [0, 0x6C7174, , 0xFFFFFF, 0, , 0xFFFFFF, 1]]*)
Gui, Main:Font, s20
Gui, Main:Add, Edit, % "x545 y120 w" (pw := A_ScreenWidth - 560) / 2 " vSMetaData ReadOnly -E0x200 Hidden HwndHCtrl"
CtlColors.Attach(HCtrl, "D8D8AD", "008000")
Gui, Main:Add, Edit, % "xp yp-50 w" pw " Center vSTotal ReadOnly -E0x200 Hidden Border HwndHCtrl"
CtlColors.Attach(HCtrl, "D8D8AD", "FF0000")
Gui, Main:Font, s150
Gui, Main:Add, Edit, % "xp+90 yp+100 w" pw-90 " Center vSNum -E0x200 Hidden HwndHCtrl gCheckSNum"
CtlColors.Attach(HCtrl, "D8D8AD", "FF0000")
Gui, Main:Font, s15
Gui, Main:Add, Button, % "xp-90 yp+40 w50 h50 Center vSNumP Hidden HwndHCtrl gUp"
ImageButton.Create(HCtrl, [ [0, "Img\SNA\1.png"]
                          , [0, "Img\SNA\2.png"]
                          , [0, "Img\SNA\3.png"]
                          , [0, "Img\SNA\4.png"]]*)
Gui, Main:Add, Edit, % "xp yp+60 w50 Center vSNumC -E0x200 Hidden Border HwndHCtrl Number"
Gui, Main:Add, Button, % "xp yp+43 w50 h50 Center vSNumM Hidden HwndHCtrl gDown"
ImageButton.Create(HCtrl, [ [0, "Img\SNR\1.png"]
                          , [0, "Img\SNR\2.png"]
                          , [0, "Img\SNR\3.png"]
                          , [0, "Img\SNR\4.png"]]*)
Gui, Main:Font, s15
Gui, Main:Add, Edit, % "ReadOnly xp yp+120 w" pw " h" A_ScreenHeight - 570 " vProductInfo HwndHCtrl -E0x200 Hidden -VScroll"
CtlColors.Attach(HCtrl, "D8D8AD", "336700")
Gui, Main:Add, Button, % "w200 h33 vSSave HwndHCtrl Hidden gEnter", % _62
ImageButton.Create(HCtrl, [[0, 0xFFFFFF, , 0x008000, 0, , 0x008000, 1]
                         , [0, 0x008000, , 0xFFFFFF, 0, , 0x008000, 1]
                         , [0, 0x008000, , 0xFFFF00, 0, , 0x008000, 1]
                         , [0, 0xB2B2B2, , 0x000000, 0, , 0x000000, 1]]*)
;////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////