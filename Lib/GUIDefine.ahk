;//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*
    Setup define GUI
*/
;//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Gui, Main:Font, s13
DefineCtrlList := "DbcT,DnmT,DbpT,DspT,DeleteBtn,AddBtn,EditBtn,Dbc,Dnm,Dbp,Dsp,LV2,ProductLogo,ProductLogoT"
Gui, Main:Add, Text, % "x225 y30 vDbcT w" (pw := (A_ScreenWidth - 225) / 4 - 4) " h32 Center Hidden", % _56 ":"
Gui, Main:Add, Text, % "xp+" pw " yp vDnmT wp hp Center Hidden", % _57 ":"
Gui, Main:Add, Text, % "xp+" pw " yp vDbpT wp hp Center Hidden", % _58 ":"
Gui, Main:Add, Text, % "xp+" pw " yp vDspT wp hp Center Hidden", % _59 ":"
Gui, Main:Font, s15
Gui, Main:Add, Edit, % "xp-" pw * 3 " yp+32 wp Center Border vDbc -E0x200 gClearDbc Hidden"
Gui, Main:Add, Edit, % "xp+" pw " yp wp Center Border vDnm -E0x200 gClearDnm Hidden"
Gui, Main:Add, Edit, % "xp+" pw " yp wp Center Border vDbp -E0x200 Hidden Number"
Gui, Main:Add, Edit, % "xp+" pw " yp wp Center Border vDsp -E0x200 Hidden Number"
Gui, Main:Font, s13
Gui, Main:Add, Button, % "xp+" pw - 132 " yp+50 w132 hp vDeleteBtn Hidden gDelete HwndHCtrl", % "       " _130
ImageButton.Create(HCtrl, [ [0, "Img\DEC\1.png",, 0xFF0000]
                          , [0, "Img\DEC\2.png",, 0x0080FF]
                          , [0, "Img\DEC\3.png",, 0xFF0000]
                          , [0, "Img\DEC\4.png"]]*)
Gui, Main:Add, Button, % "x225 yp w132 hp vAddBtn Hidden gEnter HwndHCtrl", % "     " _140
ImageButton.Create(HCtrl, [ [0, "Img\DEA\1.png",, 0x008000]
                          , [0, "Img\DEA\2.png",, 0x0080FF]
                          , [0, "Img\DEA\3.png",, 0x008000]
                          , [0, "Img\DEA\4.png"]]*)
Gui, Main:Add, Button, % "xp+142 yp w132 hp vEditBtn Hidden gEdit HwndHCtrl", % "       " _131
ImageButton.Create(HCtrl, [ [0, "Img\DEE\1.png",, 0x008000]
                          , [0, "Img\DEE\2.png",, 0x0080FF]
                          , [0, "Img\DEE\3.png",, 0x008000]
                          , [0, "Img\DEE\4.png"]]*)
Gui, Main:Font, s15
Gui, Main:Add, ListView, % "x223 yp+40 w" pw * 4 - 3 " h" A_ScreenHeight - 280 " Grid vLV2 HwndHCtrl Hidden gEdit", % _63 "|" _38 "|" _40 "|" _39
SetExplorerTheme(HCtrl)
Gui, Main:Default
Gui, Main:ListView, LV2
LV_ModifyCol(1, pw - 6)
LV_ModifyCol(2, pw - 5)
LV_ModifyCol(3, pw - 5)
LV_ModifyCol(4, pw - 5)
;//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////