;//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*
    Setup sell GUI
*/
;//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
Gui, Main:Font, s18
MainCtrlList := "$ItemsSold,$SoldP,$CostP,$ProfitP,Bc,Nm,Qn,Sum,LV0,AllSumText,ThisListSum,AddEnter,DiscountPic,Percent,Transc,TranscOK,$SubKridi,$GivenMoney,$AllSum,$Change,$CB"
. ",OpenSess1,OpenSess2,OpenSess3,OpenSess4,OpenSess5,OpenSess6,OpenSess7"
. ",Remise,RemiseText"
. ",Client,ClientText"
. ",SellDesc,SellDescText"
. ",AdditionalInfoText,AdditionalInfoPic"
MainCtrlListE := "Bc,Nm,Qn,Sum,ThisListSum,Remise,Client,SellDesc,GivenMoney,AllSum,Change"

Gui, Main:Add, Edit, % "xm y" A_ScreenHeight - 340 " HwndE w190 vItemsSold -E0x200 ReadOnly Center Border -VScroll Hidden " , 0
Gui, Main:Add, Edit, % "xp yp+" 40 " HwndE w190 vSoldP -E0x200 r2 ReadOnly Center Border -VScroll Hidden cGreen", 0
Gui, Main:Add, Edit, % "xp yp+" 70 " HwndE w190 vCostP -E0x200 r2 ReadOnly Center Border -VScroll Hidden cRed", 0
Gui, Main:Add, Edit, % "xp yp+" 70 " HwndE w190 vProfitP -E0x200 r2 ReadOnly Center Border -VScroll Hidden cGreen", 0
Ind := "", Xb := 217
Gui, Main:Font, s18 Bold, Calibri

Gui, Main:Add, Button, % "x" 230 + (A_ScreenWidth - 235) / 3 " y31 vAddEnter gEnter Hidden w48 h46 HwndHCtrl"
ImageButton.Create(HCtrl, [ [0, "Img\AC\1.png"]
, [0, "Img\AC\2.png"]
, [0, "Img\AC\3.png"]
, [0, "Img\AC\4.png"]]* )
Gui, Main:Font, s15
Gui, Main:Add, Button, % "x225 y30 vSubKridi gSubKridi HwndHCtrl w100 Hidden", % _29
ImageButton.Create(HCtrl, [[0, 0xFFFFFF, , 0x008000, 0, , 0x008000, 1]
                         , [0, 0x008000, , 0xFFFFFF, 0, , 0x008000, 1]
                         , [0, 0x008000, , 0xFFFF00, 0, , 0x008000, 1]
                         , [0, 0xB2B2B2, , 0xFFFFFF, 0, , 0x000000, 2]]* )
Gui, Main:Font, s25
pw := (A_ScreenWidth - 235) / 3
Gui, Main:Add, Edit, % "xp yp+55 w" pw " h45 vGivenMoney -E0x200 gCalc Center Border Hidden"
Gui, Main:Add, Edit, % "xp+" pw " yp wp h45 vAllSum HwndAS -E0x200 ReadOnly Center Border cGreen Hidden"
Gui, Main:Add, Edit, % "xp+" pw " yp wp h45 vChange HwndC -E0x200 ReadOnly Center Border cRed Hidden"

Gui, Main:Font, s25
Gui, Main:Add, Edit, % "x225 y30 w" pw " -VScroll vBc Center -E0x200 gAnalyzeAvail Border HwndHCtrl Hidden"
CtlColors.Attach(HCtrl, "FFFFFF", "008000")
Gui, Main:Add, Edit, % "xp yp+55 wp vNm h45 -E0x200 ReadOnly Center Hidden Border"
Gui, Main:Add, Edit, % "xp+" pw " yp wp h45 vQn Center -E0x200 ReadOnly Hidden Border cRed"
Gui, Main:Add, Edit, % "xp+" pw " wp h45 -E0x200 ReadOnly Center Hidden Border vSum"

Gui, Main:Font, s15
Gui, Main:Add, Text, % "xp+25 yp+55 wp-25 vAllSumText cRed Hidden", % _122 ":"
Gui, Main:Add, Edit, % "xp yp+30 wp vThisListSum -E0x200 Border ReadOnly HwndHCtrl Hidden"
CtlColors.Attach(HCtrl, "FFFFFF", "FF0000")

Gui, Main:Add, Text, % "xp yp+80 wp vRemiseText Hidden", % _123 ":"
Gui, Main:Add, Edit, % "xp yp+30 w100 vRemise -E0x200 Border Number gRemise Hidden cGreen Disabled"

Gui, Main:Add, Text, % "xp yp+35 w" pw - 25 " vClientText Hidden", % _124 ":"
Gui, Main:Add, Edit, % "xp yp+30 wp vClient -E0x200 Border gClient Hidden Disabled"

Gui, Main:Add, Text, % "xp yp+35 wp vSellDescText Hidden", % _125 ":"
Gui, Main:Add, Edit, % "xp yp+30 wp vSellDesc gSellDesc cBlue h" A_ScreenHeight - 534 " -E0x200 Border Hidden Disabled"

Gui, Main:Font, s12
AdditionalInfo := 0
Gui, Main:Add, Text, % "xp+30 yp-194 wp-32 h30 gAdditionalInfo vAdditionalInfoText Hidden", % " [" _127 "]"
Gui, Main:Add, Pic, % "xp-30 yp-4 w30 h30 gAdditionalInfo vAdditionalInfoPic Hidden", Img\MID.png

Gui, Main:Font, s16
Gui, Main:Add, Text, % "x225 yp-79 w" pw*2 - 31 " h30 vTransc HwndTHCtrl Right Hidden gViewLastTrans"
CtlColors.Attach(THCtrl, "B2B2B2")
Gui, Main:Add, Pic, % "x" 225 + pw*2 - 31 " yp w30 h30 vTranscOK Hidden gViewLastTrans", Img\Idle.png

Gui, Main:Font, s18
Gui, Main:Add, ListView, % "HwndHCtrl x225 yp+33 w" pw*2 " h" A_ScreenHeight - 290 " vLV0 Grid Hidden", % _63 "|" _61 "|" _38 "|" _68 "|" _69
SetExplorerTheme(HCtrl)
Gui, Main:Default
Gui, Main:ListView, LV0
LV_ModifyCol(1, "0 Center")

LV_ModifyCol(2, (AdminName = "ADM") ? pw / 2 - 40 : 0)
LV_ModifyCol(3, pw / 2 + 40 + ((AdminName = "ADM") ? 0 : pw / 2 - 40) " Center")
LV_ModifyCol(4, pw / 2 - 1 " Center")
LV_ModifyCol(5, pw / 2 - 1 " Center")

Gui, Main:Font, s15

Gui, Main:Add, Button, % "xp y" A_ScreenHeight - 100 " w25 h25 vOpenSess1 HwndHCtrl gUpdateSession Hidden", 1
ImageButton.Create(HCtrl, BMBTN*)
Gui, Main:Add, Button, % "xp+25 yp w25 h25 vOpenSess2 HwndHCtrl gUpdateSession Hidden", 2
ImageButton.Create(HCtrl, BMBTN*)
Gui, Main:Add, Button, % "xp+25 yp w25 h25 vOpenSess3 HwndHCtrl gUpdateSession Hidden", 3
ImageButton.Create(HCtrl, BMBTN*)
Gui, Main:Add, Button, % "xp+25 yp w25 h25 vOpenSess4 HwndHCtrl gUpdateSession Hidden", 4
ImageButton.Create(HCtrl, BMBTN*)
Gui, Main:Add, Button, % "xp+25 yp w25 h25 vOpenSess5 HwndHCtrl gUpdateSession Hidden", 5
ImageButton.Create(HCtrl, BMBTN*)
Gui, Main:Add, Button, % "xp+25 yp w25 h25 vOpenSess6 HwndHCtrl gUpdateSession Hidden", 6
ImageButton.Create(HCtrl, BMBTN*)
Gui, Main:Add, Button, % "xp+25 yp w25 h25 vOpenSess7 HwndHCtrl gUpdateSession Hidden", 7
ImageButton.Create(HCtrl, BMBTN*)
GuiControl, Main:Disabled, OpenSess1
;//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////