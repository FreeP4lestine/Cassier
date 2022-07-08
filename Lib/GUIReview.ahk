;//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*
    Setup review GUI
*/
;//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
ProfitCtrlList := "ProfByName,ProfByNameText,SPr,SPrText,CPr,CPrText,OAProfit,OAProfitText,LV4,SinceBegin,Today,Yesterday,Chart,$PB,$PBText"
Gui, Main:Add, Text, x225 y30 w300 vProfByNameText Hidden, % _156 ":"
Gui, Main:Add, DDL, xp yp+40 w300 vProfByName Hidden gGoLookUp
pw := A_ScreenWidth - 250
Gui, Main:Add, Text, % "x" (A_ScreenWidth - 381 - pw/2) " yp-40 w" pw/4 + 2 " vSPrText Hidden gShowRemise", % _157 ":"
Gui, Main:Add, Edit, % "xp yp+40 -E0x200 ReadOnly vSPr wp Hidden Border HwndHCtrl"
CtlColors.Attach(HCtrl, "00FF00", "000000")
Gui, Main:Add, Text, % "xp+" pw/4 + 2 " yp-40 wp vCPrText Hidden", % _158 ":"
Gui, Main:Add, Edit, % "xp yp+40 -E0x200 ReadOnly vCPr wp Hidden Border HwndHCtrl"
CtlColors.Attach(HCtrl, "FF8080", "000000")
Gui, Main:Add, Text, % "xp+" pw/4 + 2 " yp-40 wp vOAProfitText Hidden gShowRemise", % _159 ":"
Gui, Main:Add, Edit, % "xp yp+40 -E0x200 ReadOnly vOAProfit wp Hidden Border HwndHCtrl"
CtlColors.Attach(HCtrl, "00FF00", "000000")
Gui, Main:Add, ListView, % "x225 yp+40 w" pw + 6 " h" A_ScreenHeight - 310 " Grid vLV4 HwndHCtrl Hidden -Multi", % _70 "|" _72 "|" _39 "|" _40 "|" _41
SetExplorerTheme(HCtrl)
Gui, Main:Default
Gui, Main:ListView, LV4
LV_ModifyCol(1, "0")
LV_ModifyCol(2, pw / 4 - 2)
LV_ModifyCol(3, pw / 4 + 2)
LV_ModifyCol(4, pw / 4 + 2)
LV_ModifyCol(5, pw / 4 + 2) 
Gui, Main:Add, Progress, % "-Smooth vPB w" pw + 6 " Hidden h17", 0
Gui, Main:Add, Checkbox, xp yp+30 w345 vSinceBegin Hidden gEDTime, % _85
Gui, Main:Font, s25
TodayDate := A_Now
Gui, Main:Add, DateTime, xp yp+40 w350 vToday Choose%TodayDate% Hidden h40, yyyy.MM.dd | HH:mm:ss
TodayDate += -1, Days
Gui, Main:Add, DateTime, xp+355 yp w350 vYesterday Choose%TodayDate% Hidden hp, yyyy.MM.dd | HH:mm:ss
Gui, Main:Font, s13
Gui, Main:Add, Button, % "x" A_ScreenWidth - 120 " yp-40 vChart Hidden w101 HwndHCtrl h35 gDisplayChart", % _83
ImageButton.Create(HCtrl, [[0, 0xFFFFFF, , 0x008000, 0, , 0x008000, 1]
                         , [0, 0x008000, , 0xFFFFFF, 0, , 0x008000, 1]
                         , [0, 0x008000, , 0xFFFF00, 0, , 0x008000, 1]
                         , [0, 0x6C7174, , 0x000000, 0, , 0xFFFFFF, 1]]*)
;//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////