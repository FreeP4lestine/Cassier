;/////////////////////////////////////////////////////////////////////////////////////
/*
    Setup Chart GUI for some statistic information
*/
;/////////////////////////////////////////////////////////////////////////////////////
Gui, Chart:Font, s13 Bold, Calibri
Gui, Chart:Margin, 10, 10
Gui, Chart:-MinimizeBox +HwndChrt
Gui, Chart:Color, 0xD8D8AD
Gui, Chart:Add, Text, w300 Center, % _139
Gui, Chart:Font, s15
Gui, Chart:Add, Edit, w300 vSeachBc gLoadLB -E0x200 Border
Gui, Chart:Add, DDL, w300 vDDL gLoadLB, % _68 "||" _129 "|" _39 "|" _138
Gui, Chart:Add, ListBox, xp yp+40 w300 r25 vLB HwndHCtrl AltSubmit gDisplaySellInfo
CtlColors.Attach(HCtrl, "D8D8AD")
Gui, Chart:Add, Progress, xp+310 yp vCB w500 h15 cGreen BackGroundWhite
Gui, Chart:Add, Edit, xp yp+40 w500 HwndHCtrl vCR r23 -VScroll -E0x200 ReadOnly Center
;/////////////////////////////////////////////////////////////////////////////////////