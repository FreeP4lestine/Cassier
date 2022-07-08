;////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*
    Setup kridi GUI
*/
;////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
KridiCtrlList := "KLE,KLEText,KLB,KLBB,KLBB1,CashK,CashKE,LV6,KMD,KLESum,KMDSubmit,KEditBtn,Mony"
Gui, Main:Font, s15
Gui, Main:Add, Text, % "x225 y30 w" (pw := (A_ScreenWidth - 240) / 4) " vKLEText Hidden Center", % _161
Gui, Main:Font, s17
Gui, Main:Add, Edit, % "x225 yp+40 wp vKLE Hidden gDisplayKridisUsers -E0x200 Border"
Gui, Main:Add, ListBox, % "AltSubmit xp yp+40 wp h" A_ScreenHeight - 220 " vKLB HwndHCtrl Hidden Multi gShowKridiInfo"
CtlColors.Attach(HCtrl, "D8D8AD")
Gui, Main:Font, s20
Gui, Main:Add, Edit, % "wp vKLESum Hidden -E0x200 HwndHCtrl Center ReadOnly Border"
CtlColors.Attach(HCtrl, "D8D8AD", "FF0000")
Gui, Main:Font, s14
Gui, Main:Add, ListBox, % "AltSubmit xp+" pw + 210 " y70 HwndHCtrl w200 h" (A_ScreenHeight - 220) / 2 " vKLBB1 Hidden gDisplayMetaK1 -Multi"
CtlColors.Attach(HCtrl, "FFFFFF", "008000") 
Gui, Main:Add, ListBox, % "AltSubmit xp-200 HwndHCtrl yp wp hp vKLBB Hidden gDisplayMetaK -Multi"
CtlColors.Attach(HCtrl, "FFFFFF", "800000")      

Gui, Main:Font, s17
Gui, Main:Add, Edit, % "wp Center vCashK -E0x200 Hidden HwndHCtrl ReadOnly Border"
CtlColors.Attach(HCtrl, "D8D8AD", "FF0000")    
Gui, Main:Font, s15
Gui, Main:Add, Edit, % "wp Center vCashKE -E0x200 Hidden HwndHCtrl ReadOnly Border"
CtlColors.Attach(HCtrl, "D8D8AD", "FF0000")
Gui, Main:Add, ListView, % "Hidden w" pw * 3 - 10 " h" ((A_ScreenHeight - 220) / 2) - 69 " vLV6", % "|" _38 "|" _68 "|" _39
SetExplorerTheme(HCtrl)
Gui, Main:Default
Gui, Main:ListView, LV6
LV_ModifyCol(1, "0 Center")
LV_ModifyCol(2, pw)
LV_ModifyCol(3, pw)
LV_ModifyCol(4, pw)
Gui, Main:Font, s13
Gui, Main:Add, Button, % "xp+" pw + 50 " y70 w132 h32 vKEditBtn Hidden gKEdit HwndHCtrl", % "       " _131
ImageButton.Create(HCtrl, [ [0, "Img\DEE\1.png",, 0x008000]
                          , [0, "Img\DEE\2.png",, 0x0080FF]
                          , [0, "Img\DEE\3.png",, 0x008000]
                          , [0, "Img\DEE\4.png"]]*)
Gui, Main:Font, s100
Gui, Main:Add, Edit, % "ReadOnly xp+140 yp w" pw + 145 " h" (A_ScreenHeight - 220) / 3 " Right -VScroll vKMD -E0x200 Hidden HwndHCtrl"
CtlColors.Attach(HCtrl, "D8D8AD")
Gui, Main:Font, s25
GuiControlGet, HCtrl, Main:Pos, CashK
Gui, Main:Add, Edit, % "xp y" HCtrlY - 60 " wp -VScroll Center vKMDSubmit cGreen -E0x200 Border Hidden HwndHCtrl gKUpdateVal Number"
Gui, Main:Add, Pic, % "xp+" (pw + 95) / 2 " yp+50 vMony w50 h50 Hidden", Img\Money.png
;////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////