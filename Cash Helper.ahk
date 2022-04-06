#NoEnv
#Persistent
#SingleInstance, Force
SendMode Input
SetWorkingDir %A_ScriptDir%

#Include, <Class_CtlColors>
#Include, <Class_ImageButton>
#Include, <UseGDIP>
#Include, <Class_LVColors>
#Include, <LV_SetSelColors>
#Include, <HashSum>
#Include, <Class_ScrollGUI>

LoadInterfaceLng()

RMS := "#-1"

If (CheckForUpdatesStat()) {
    If DllCall("Wininet.dll\InternetGetConnectedState", "Str", 0x40, "Int", 0)
        CheckForUpdates()
}

CheckFoldersSet()

GreenBTN := [[0, 0xFFFFFF, , 0x008000, 0, , 0x008000, 1]
           , [0, 0x008000, , 0xFFFFFF, 0, , 0x008000, 1]
           , [0, 0x008000, , 0xFFFF00, 0, , 0x008000, 1]
           , [0, 0x6C7174, , 0x000000, 0, , 0xFFFFFF, 1]]
RedBTN := [[0, 0xFFFFFF, , 0xFF0000, 0, , 0xD43F3A, 1]
           , [0, 0xFF0000, , 0xFFFFFF, 0, , 0xD43F3A, 1]
           , [0, 0xFF0000, , 0xFFFF00, 0, , 0xD43F3A, 1]
           , [0, 0x6C7174, , 0xFFFFFF, 0, , 0xFFFFFF, 1]]
LMBTN := [[0, 0x80FFFFFF, , 0x000000, 3, , 0x008000]
           , [0, 0x80D8D8AD, , 0x000000, 3, , 0x008000]
           , [0, 0x80D8D8AD, , 0xFF0000, 3, , 0x008000]
           , [0, "Img\LMBD.png", , 0x000000, 3, , 0x80D8D8AD]]
           
EBTN := [[0, 0xC6E6C6, , , 0, , 0x5CB85C, 5]
           , [0, 0x91CF91, , , 0, , 0x5CB85C, 5]
           , [0, 0x5CB85C, , , 0, , 0x5CB85C, 5]
           , [0, 0xF0F0F0, , , 0, , 0x5CB85C, 5]]
BMBTN := [[0, 0x80FFFFFF, , 0x000000, 0, , 0x80FFFFFF]
           , [0, 0x80F0AD4E, , 0x000000, 0, , 0x80FFFFFF]
           , [0, 0x80F0AD4E, , 0xFF0000, 0, , 0x80FFFFFF]
           , [0, 0x80F0AD4E, , 0x000000, 0, , 0x80F0AD4E]]

HH := A_ScreenHeight // 2

Gui, StSum:Color, 0xD8D8AD
Gui, StSum:+HwndStSum
Gui, StSum:Font, s15 Bold, Calibri
Gui, StSum:Add, ListView, % "w800 h" A_ScreenHeight - 350, % _63 "|" _38 "|" _64 "|" _66
Gui, StSum:Font, s20
Gui, StSum:Add, Edit, vStockSum w800 ReadOnly Center
Gui, StSum:Default

LV_ModifyCol(1, "200")
LV_ModifyCol(2, "200")
LV_ModifyCol(3, "200")
LV_ModifyCol(4, "200")

Gui, ReIn:Color, Green
Gui, ReIn:+HwndInfo -Caption AlwaysOnTop ToolWindow
Gui, ReIn:Font, s15 Bold, Calibri
Gui, ReIn:Add, Edit, x3 y3 w800 h%HH% ReadOnly HwndE vDInfo
CtlColors.Attach(E, "FFFFFF", "000000")


Gui, Kridi:+HwndKr +Resize
Gui, Kridi:Color, 0xD8D8AD
Gui, Kridi:Font, s15 Bold, Calibri
Gui, Kridi:Add, Edit, w200 vKName -E0x200 Border gCheckKExist hwndKE
Gui, Kridi:Add, Button, xm+210 ym w100 h33 HwndBtn gEnter, % _36
ImageButton.Create(Btn, [[0, 0xFFFFFF, , 0x008000, 0, , 0x008000, 1]
                       , [0, 0x008000, , 0xFFFFFF, 0, , 0x008000, 1]
                       , [0, 0x008000, , 0xFFFF00, 0, , 0x008000, 1]
                       , [0, 0xB2B2B2, , 0xFFFFFF, 0, , 0x000000, 2]]* )
Gui, Kridi:Add, ListBox, w200 xm ym+40 vKLB h450 gWriteItDown
Gui, Kridi:Add, ListView, xm+210 ym+40 w760 h435 Grid cBlue, Col1|Col2|Col3|Col4|Col5
Gui, Kridi:Default
LV_ModifyCol(1, 0)
LV_ModifyCol(2, 190)
LV_ModifyCol(3, 190)
LV_ModifyCol(4, 190)
LV_ModifyCol(5, 190)
Gui, Kridi:Add, Edit, xm+550 ym w200 h33 -E0x200 Border ReadOnly vTotal Center
Gui, Kridi:Add, Edit, xm+768 ym w200 h33 -E0x200 Border ReadOnly vThisTotal Center cRed HwndE
CtlColors.Attach(E, "FFFFFF", "000000")
Gui, Main:Default
Gui, Main: +HwndMain
Gui, Main:Font, s10 Bold, Calibri
Gui, Main:Color, 0xD8D8AD
LoadBackground()
Pass := 0
Global RMS
If !CheckLicense() {
    Gui, Main:Add, Picture, x0 y10 h419 vLicPic, Img\Lic.png
    Gui, Main:Add, Edit, xm+205 ym+135 w760 vEPassString Center
    Gui, Main:Add, Text, xm+205 ym+165 w760 vPassString Center BackgroundTrans, Please enter the KeyString
    Gui, Main:Show, w1000 h500
    Pass := 1
    ADMUsername := ADMPassword := ""
    GuiControl, Main:, PassString, Create ADM username
    Return
}
Gui, Main:Add, Text, x0 y0 w203 HwndTopText vTText h20, % "  " _75 ":"
CtlColors.Attach(TopText, "FFFFFF", "000000")
OpenApp:
    RMS := "#0"
    Gui, Main:+Resize
    Gui, Main:Font, s13
    Gui, Main:Add, Button, x0 y10 HwndBtn w199 h40 gOpenMain Disabled Hidden vBtn1, % _4
    ImageButton.Create(Btn, LMBTN*)
    Gui, Main:Add, Button, x0 y50 HwndBtn w199 h40 gSubmit vBtn2 Hidden, % _8
    ImageButton.Create(Btn, LMBTN*)
    Gui, Main:Add, Button, x0 y90 HwndBtn w199 h40 gDefine vBtn3 Hidden, % _5
    ImageButton.Create(Btn, LMBTN*)
    Gui, Main:Add, Button, x0 y130 HwndBtn w199 h40 gStockPile vBtn4 Hidden, % _6
    ImageButton.Create(Btn, LMBTN*)
    Gui, Main:Add, Button, x0 y170 HwndBtn w199 h40 gProf vBtn5 Hidden, % _7
    ImageButton.Create(Btn, LMBTN*)
    Gui, Main:Add, Button, x0 y210 HwndBtn w199 h40 gManage vBtn6 Hidden, % _28
    ImageButton.Create(Btn, LMBTN*)
    Gui, Main:Add, Button, x0 y250 HwndBtn w199 h40 gKridi vBtn7 Hidden, % _29
    ImageButton.Create(Btn, LMBTN*)

    global TU, TP

    Gui, Main:Add, Edit, xm ym+150 vTU w178 Center HwndE h28 -E0x200
    CtlColors.Attach(E, "FFFFFF", "000000")
    Gui, Main:Add, Edit, xm+200 ym+170 vTP w178 Center Password HwndTP_ h28 -E0x200
    CtlColors.Attach(TP_, "FFFFFF", "FF0000")
    Gui, Main:Add, Button, xm+400 ym+170 w178 HwndBtn vLogin gEnter h28, % _35
    ImageButton.Create(Btn, [[0, 0xFFFFFF, , 0x008000, 0, , 0x008000, 1]
                           , [0, 0x008000, , 0xFFFFFF, 0, , 0x008000, 1]
                           , [0, 0x008000, , 0xFFFF00, 0, , 0x008000, 1]
                           , [0, 0x6C7174, , 0x000000, 0, , 0xFFFFFF, 1]]*)

    Gui, Main:Add, Button, xm ym+170 w178 HwndBtn vReload gReload Hidden h28, % _73
    ImageButton.Create(Btn, GreenBTN*)
    
    MainCtrlList := "Bc,$CB,Nm,Qn,Sum,LV0,ThisListSum,AddEnter,$SubKridi,$GivenMoney,$AllSum,$Change,$ItemsSold,$SoldP,$CostP,$ProfitP,DiscountPic,Percent"
    Gui, Main:Font, s18
    Gui, Main:Add, Edit, xm y400 HwndE w175 vItemsSold -E0x200 ReadOnly Center Border -VScroll Hidden, 0
    Gui, Main:Add, Edit, xm y465 HwndE w175 vSoldP -E0x200 r2 ReadOnly Center Border -VScroll Hidden cGreen, 0
    Gui, Main:Add, Edit, xm y530 HwndE w175 vCostP -E0x200 r2 ReadOnly Center Border -VScroll Hidden cRed, 0
    Gui, Main:Add, Edit, xm y595 HwndE w175 vProfitP -E0x200 r2 ReadOnly Center Border -VScroll Hidden cGreen, 0
    Ind := "", Xb := 217
    Gui, Main:Font, s25 Bold, Calibri
    Gui, Main:Add, Edit, xm+205 ym+10 w250 -VScroll vBc Center -E0x200 gAnalyzeAvail Border HwndBc_ Hidden
    CtlColors.Attach(Bc_, "FFFFFF", "008000")
    GuiControlGet, ThisPos, Main:Pos, Bc
    ThisPosX -= 10
    Gui, Main:Add, ComboBox, xm+%ThisPosX% ym+58 w250 vCB r10 Simple 0x100 Center gChooseItem HwndLB_ Hidden ReadOnly
    CtlColors.Attach(LB_, "FFFFFF", "008000")

    Gui, Main:Add, Edit, xm+205 ym+70 w250 vNm -E0x200 ReadOnly Center Hidden Border
    Gui, Main:Add, Edit, xm+715 ym+70 w260 vQn Center -E0x200 ReadOnly Hidden Border cRed
    Gui, Main:Add, Edit, xm+455 ym+70 w250 vSum -E0x200 ReadOnly Center Hidden Border
    Gui, Main:Add, Edit, xm+715 ym+370 w250 vThisListSum -E0x200 Border ReadOnly HwndThisListSum_ Center Hidden
    CtlColors.Attach(ThisListSum_, "FFFFFF", "FF0000")

    Gui, Main:Font, s15
    Loop, 7 {
        Gui, Main:Add, Button, xm+%Xb% ym+300 w25 h25 vOpenSess%Ind% HwndOpenSess%Ind%_ gUpdateSession Center Hidden, % A_Index
        MainCtrlList .= ",OpenSess" Ind
        ImageButton.Create(OpenSess%Ind%_, BMBTN*)
        Ind := A_Index
        Xb += 25
    }

    Gui, Main:Font, s25
    Gui, Main:Add, Button, xm+715 ym+15 vAddEnter gEnter Hidden w40 h40 HwndBtn
    ImageButton.Create(Btn, [ [0, "Img\AC\1.png"]
                            , [0, "Img\AC\2.png"]
                            , [0, "Img\AC\3.png"]
                            , [0, "Img\AC\4.png"]]* )
    Gui, Main:Font, s20
    Gui, Main:Add, Button, xm+205 ym+10 vSubKridi gSubKridi Hidden HwndBtn w120 h40, % _29
    ImageButton.Create(Btn, [[0, 0xFFFFFF, , 0x008000, 0, , 0x008000, 1]
                       , [0, 0x008000, , 0xFFFFFF, 0, , 0x008000, 1]
                       , [0, 0x008000, , 0xFFFF00, 0, , 0x008000, 1]
                       , [0, 0xB2B2B2, , 0xFFFFFF, 0, , 0x000000, 2]]* )
    
    Gui, Main:Add, Edit, xm+205 ym+70 w254 vGivenMoney -E0x200 gCalc Center Hidden Border
    Gui, Main:Add, Edit, xm+460 ym+70 w254 vAllSum HwndAS -E0x200 ReadOnly Center Hidden Border cGreen
    Gui, Main:Add, Edit, xm+715 ym+70 w252 vChange HwndC -E0x200 ReadOnly Center Hidden Border cRed
    Gui, Main:Font, s18
    Gui, Main:Add, ListView, xm+205 ym+135 w760 r10 Grid vLV0 cRed HwndHLV Hidden -Multi, % _63 "|" _61 "|" _38 "|" _68 "|" _69
    Gui, Main:Default
    Gui, Main:ListView, LV0
    LV_ModifyCol(1, "0 Center")
    LV_ModifyCol(2, "180")
    LV_ModifyCol(3, "234 Center")
    LV_ModifyCol(4, "232 Center")
    LV_ModifyCol(5, "230 Center")

    EnsureCtrlList := "LV1,EnsBtn,Currents,$Sold,$Bought,$ProfitEq"
    Gui, Main:Font, s15
    Gui, Main:Add, Button, xm+205 ym+30 vEnsBtn w300 h40 hwndEnsBtn_ Hidden gValid, % _9
    ImageButton.Create(EnsBtn_, [[0, 0xFFFFFF, , 0x008000, 0, , 0x008000, 4]
                               , [0, 0x008000, , 0xFFFFFF, 0, , 0x008000, 4]
                               , [0, 0x008000, , 0xFFFF00, 0, , 0x008000, 4]
                               , [0, 0xB2B2B2, , 0x000000, 0, , 0x000000, 2]]* )
    Gui, Main:Add, DDL, xm+205 ym+85 w300 vCurrents Hidden gDisplayEqCurr, % _74 "||"
    Gui, Main:Add, ListView, xm+205 ym+135 w760 r10 Grid vLV1 HwndHLV Hidden -Multi, % _70 "|" _71
    Gui, Main:Default
    Gui, Main:ListView, LV1
    LV_ModifyCol(1, "0")
    LV_ModifyCol(2, "760")

    Gui, Main:Font, s25
    Gui, Main:Add, Edit, x217 ym+450 w260 vSold Center -E0x200 ReadOnly HwndE gAnalyzeQn Hidden cGreen Border
    Gui, Main:Add, Edit, xm+456 ym+450 w260 vBought -E0x200 ReadOnly HwndE Center Hidden cRed Border
    Gui, Main:Add, Edit, xm+716 ym+450 w260 vProfitEq -E0x200 ReadOnly HwndE Center Hidden cGreen Border
    Gui, Main:Font, s13

    DefineCtrlList := "DbcT,DnmT,DbpT,DspT,Dbc,Dnm,Dbp,Dsp,LV2,PrevPD,PDSave"
    Gui, Main:Add, Text, xm+205 ym+90 vDbcT w185 h32 Center Hidden, % _56 ":"
    Gui, Main:Add, Text, xm+205 ym+90 vDnmT w185 h32 Center Hidden, % _57 ":"
    Gui, Main:Add, Text, xm+205 ym+90 vDbpT w185 h32 Center Hidden, % _58 ":"
    Gui, Main:Add, Text, xm+205 ym+90 vDspT w185 h32 Center Hidden, % _59 ":"
    Gui, Main:Font, s15
    Gui, Main:Add, Edit, xm+205 ym+120 w185 Center Border vDbc HwndDbc_ -E0x200 gClearDbc Hidden
    CtlColors.Attach(Dbc_, "FFFFFF", "000000")
    
    Gui, Main:Add, Edit, xm+396 ym+120 w185 Center Border vDnm HwndDnm_ -E0x200 gClearDnm Hidden
    CtlColors.Attach(Dnm_, "FFFFFF", "000000")
    
    Gui, Main:Add, Edit, xm+589 ym+120 w185 Center Border vDbp HwndDbp_ -E0x200 gClearDbp Hidden
    CtlColors.Attach(Dbp_, "FFFFFF", "000000")
    
    Gui, Main:Add, Edit, xm+780 ym+120 w185 Center Border vDsp HwndDsp_ -E0x200 gClearDsp Hidden
    CtlColors.Attach(Dsp_, "FFFFFF", "000000")

    Gui, Main:Font, s12
    Gui, Main:Add, DDL, xm+780 ym+50 w185 Center Border vPrevPD r10 gPrevPDAnalyze Hidden
    Gui, Main:Add, Button, xm+780 ym+20 w185 h25 Center Border vPDSave HwndPDSave_ gApplyPD Hidden, % _30
    ImageButton.Create(PDSave_, RedBtn*)

    Gui, Main:Font, s15
    Gui, Main:Add, ListView, xm+205 ym+170 w760 r9 Grid vLV2 HwndHLV Hidden gEdit, % _63 "|" _38 "|" _68 "|" _69
    Gui, Main:Default
    Gui, Main:ListView, LV2
    LV_ModifyCol(1, "185")
    LV_ModifyCol(2, "192")
    LV_ModifyCol(3, "192")
    LV_ModifyCol(4, "186")


    StockPileCtrlList := "Pnm,PnmT,PnmTT,PqnT,PSum,LV3,SaveCh"
    Gui, Main:Add, Text, xm+205 ym+50 w253 vPnmT Hidden, % "      " _56
    Gui, Main:Add, Text, xm+453 ym+90 w253 vPnmTT Hidden, % "      " _57
    Gui, Main:Add, Text, xm+706 ym+50 w253 Center vPqnT Hidden, % _61
    Gui, Main:Font, s20
    Gui, Main:Add, Edit, xm+205 ym+90 w253 Center vPnm gSearchStock -E0x200 Hidden Border

    Gui, Main:Add, Edit, xm+711 ym+90 w253 Center vPSum HwndPSum_ -E0x200 Hidden Border Number, 1
    CtlColors.Attach(PSum_, "E6E6E6", "000000")

    Gui, Main:Font, s15, Calibri
    Gui, Main:Add, ListView, xm+205 ym+135 w760 r10 Grid vLV3 HwndHLV gStockSum Hidden, % _63 "|" _38 "|" _68
    Gui, Main:Default
    Gui, Main:ListView, LV3
    LV_ModifyCol(1, "190")
    LV_ModifyCol(2, "190")
    LV_ModifyCol(3, "190 Center")
    Gui, Main:Add, Button, xm+205 ym+135 w300 HwndBtn vSaveCh Hidden gEnter, % _62
    ImageButton.Create(Btn, GreenBTN* )

    ProfitCtrlList := "ProfByName,SPr,CPr,OAProfit,LV4,Today,Yesterday,$PB"
    Gui, Main:Font, s25
    TodayDate := A_Now
    Gui, Main:Add, DateTime, xm+205 ym+350 w345 vToday Choose%TodayDate% Hidden, yyyy.MM.dd | HH:mm:ss
    TodayDate += -1, Days
    Gui, Main:Add, DateTime, xm+605 ym+350 w345 vYesterday Choose%TodayDate% Hidden, yyyy.MM.dd | HH:mm:ss
    Gui, Main:Font, s15
    Gui, Main:Add, DDL, xm+205 ym+90 vProfByName Hidden
    Gui, Main:Add, Edit, xm+776 ym+90 -E0x200 ReadOnly vOAProfit w189 Hidden Border HwndE
    CtlColors.Attach(E, "00FF00", "000000")
    Gui, Main:Add, Edit, xm+586 ym+90 -E0x200 ReadOnly vCPr w189 Hidden Border HwndE
    CtlColors.Attach(E, "FF8080", "000000")
    Gui, Main:Add, Edit, xm+396 ym+90 -E0x200 ReadOnly vSPr w189 Hidden Border HwndE
    CtlColors.Attach(E, "00FF00", "000000")
    Gui, Main:Add, Progress, xm+205 ym+65 -Smooth vPB w189 Hidden h17, 0
    Gui, Main:Add, ListView, xm+205 ym+135 w760 r10 Grid vLV4 HwndHLV Hidden -Multi, % _70 "|" _72 "|" _40 "|" _39 "|" _41
    Gui, Main:Default
    Gui, Main:ListView, LV4
    LV_ModifyCol(1, "0")
    LV_ModifyCol(2, "189")
    LV_ModifyCol(3, "189")
    LV_ModifyCol(4, "189")
    LV_ModifyCol(5, "189")


    ManageCtrlList := "UserName,UserPass,LV5,CheckForUpdatesCB1,CheckForUpdatesCB2,CheckForUpdatesCB3,RememberLoginCB1,RememberLoginCB2,RememberLoginCB3,CheckForUpdatesCBText,RememberLoginCBText"
                    . ",FixedToolTipCB1,FixedToolTipCB2,FixedToolTipCB3,FixedToolTipCBText"
                    . ",MultiSelCB1,MultiSelCB2,MultiSelCB3,MultiSelCBText"
    Gui, Main:Add, Edit, xm+205 ym+10 w200 -E0x200 vUserName Hidden HwndE Border Right cRed
    Gui, Main:Add, Edit, xm+405 ym+10 w200 -E0x200 vUserPass Hidden HwndE Border
    Gui, Font, s25, Wingdings
    Global CheckForUpdates
    Gui, Main:Add, Text, xm+615 ym+10 w32 h33 0x6 vCheckForUpdatesCB1 Hidden
    Gui, Main:Add, Text, xp yp w33 h33 0x12 vCheckForUpdatesCB2 Hidden
    Gui, Main:Add, Text, xp yp w33 h33 0x200 BackgroundTrans Center cGreen vCheckForUpdatesCB3 gCheckForUpdates Hidden
    Global RememberLogin
    Gui, Main:Add, Text, xm+615 ym+45 w32 h33 0x6 vRememberLoginCB1 Hidden
    Gui, Main:Add, Text, xp yp w33 h33 0x12 vRememberLoginCB2 Hidden
    Gui, Main:Add, Text, xp yp w33 h33 0x200 BackgroundTrans Center cGreen vRememberLoginCB3 gRememberLogin Hidden
    Global FixedToolTip
    Gui, Main:Add, Text, xm+615 ym+80 w32 h33 0x6 vFixedToolTipCB1 Hidden
    Gui, Main:Add, Text, xp yp w33 h33 0x12 vFixedToolTipCB2 Hidden
    Gui, Main:Add, Text, xp yp w33 h33 0x200 BackgroundTrans Center cGreen vFixedToolTipCB3 gFixedToolTipTog Hidden
    Global MultiSel
    Gui, Main:Add, Text, xm+615 ym+115 w32 h33 0x6 vMultiSelCB1 Hidden
    Gui, Main:Add, Text, xp yp w33 h33 0x12 vMultiSelCB2 Hidden
    Gui, Main:Add, Text, xp yp w33 h33 0x200 BackgroundTrans Center cGreen vMultiSelCB3 gMultiSelTog Hidden

    Gui, Main:Font, s12, Calibri
    Gui, Main:Add, Text, xm+660 ym+15 vCheckForUpdatesCBText Hidden gCheckForUpdates, % _31
    Gui, Main:Add, Text, xm+660 ym+50 vRememberLoginCBText Hidden gRememberLogin, % _32
    Gui, Main:Add, Text, xm+660 ym+85 vFixedToolTipCBText Hidden gRememberLogin, % _43
    Gui, Main:Add, Text, xm+660 ym+120 vMultiSelCBText Hidden gRememberLogin, % _65
    Gui, Main:Font, s15, Calibri
    Gui, Main:Add, ListView, xm+205 ym+50 w400 r10 Grid vLV5 HwndHLV Hidden -Multi cBlue, N|P
    Gui, Main:Default
    Gui, Main:ListView, LV5
    LV_ModifyCol(1, "198 Right")
    LV_ModifyCol(2, "198")

    KridiCtrlList := "KLB,LV6,ThisListSum"
    Gui, Main:Add, ListBox, xm+205 ym+135 w210 vKLB Hidden HwndKLB Multi gDisplayKridi
    CtlColors.Attach(KLB, "FCEFDC", "000000")
    Gui, Main:Add, ListView, xm+430 ym+135 w760 r10 Grid vLV6 cRed HwndHLV Hidden -Multi, % _63 "|" _72 "|" _38 "|" _68 "|" _69
    Gui, Main:Default
    Gui, Main:ListView, LV6
    LV_ModifyCol(1, "0 Center")
    LV_ModifyCol(2, "180")
    LV_ModifyCol(3, "234 Center")
    LV_ModifyCol(4, "232 Center")
    LV_ModifyCol(5, "230 Center")

    Gui, Main:Font, s15
    Gui, Main:Show, % "w800 h78"

    IniRead, Log, Setting.ini, OtherSetting, RemUser
    OldLog := StrSplit(DB_Read("Sets\RL.db"), ";")

    If (OldLog[1] = Log) {
        GuiControl, Main:, TU, % OldLog[1]
        GuiControl, Main:, TP, % OldLog[2]
        GuiControl, Main:Focus, TP
    }
    Return
Continue:
    Gui, Main:-Resize
    Gui, Main:Font, s12
    Gui, Main:Add, Button, xm+199 ym+10 gCFU w170 h30 HwndBtn vCFU, % _44

    ImageButton.Create(Btn, [[0, 0xFFFFFF, , 0x000000, 0, , 0x000000, 1]
                           , [0, 0xD8D8AD, , 0x000000, 0, , 0x000000, 1]
                           , [0, 0xD8D8AD, , 0x000000, 0, , 0x000000, 1]
                           , [0, 0xB2B2B2, , 0x000000, 0, , 0x000000, 1]]* )

    Gui, Main:Show, % "w800 h400 Center"
    
    Gui, Main:Add, Button, xm+199 ym+10 w140 h90 gCheckAndRun HwndBtn vOpenMain

    ImageButton.Create(Btn, [ [0, "Img\OM\1.png"]
                            , [0, "Img\OM\2.png"]
                            , [0, "Img\OM\3.png"]
                            , [0, "Img\OM\4.png"]]*)
                        
    Gui, Main:Add, Button, xm+344 ym+10 w140 h90 gCheckAndRun HwndBtn vSubmit

    ImageButton.Create(Btn, [ [0, "Img\ED\1.png"]
                            , [0, "Img\ED\2.png"]
                            , [0, "Img\ED\3.png"]
                            , [0, "Img\ED\4.png"]]*)
    
    Gui, Main:Add, Button, xm+489 ym+10 w140 h90 gCheckAndRun HwndBtn vDefine

    ImageButton.Create(Btn, [ [0, "Img\DE\1.png"]
                            , [0, "Img\DE\2.png"]
                            , [0, "Img\DE\3.png"]
                            , [0, "Img\DE\4.png"]]*)

    Gui, Main:Add, Button, xm+634 ym+10 w140 h90 gCheckAndRun HwndBtn vStockpile

    ImageButton.Create(Btn, [ [0, "Img\ST\1.png"]
                            , [0, "Img\ST\2.png"]
                            , [0, "Img\ST\3.png"]
                            , [0, "Img\ST\4.png"]]*)
    
    Gui, Main:Add, Button, xm+199 ym+110 w140 h90 gCheckAndRun HwndBtn vProf

    ImageButton.Create(Btn, [ [0, "Img\PR\1.png"]
                            , [0, "Img\PR\2.png"]
                            , [0, "Img\PR\3.png"]
                            , [0, "Img\PR\4.png"]]*)
    
    Gui, Main:Add, Button, xm+344 ym+110 w140 h90 gCheckAndRun HwndBtn vManage

    ImageButton.Create(Btn, [ [0, "Img\MN\1.png"]
                            , [0, "Img\MN\2.png"]
                            , [0, "Img\MN\3.png"]
                            , [0, "Img\MN\4.png"]]*)
                        
    Gui, Main:Add, Button, xm+489 ym+110 w140 h90 gCheckAndRun HwndBtn vKridi

    ImageButton.Create(Btn, [ [0, "Img\KR\1.png"]
                            , [0, "Img\KR\2.png"]
                            , [0, "Img\KR\3.png"]
                            , [0, "Img\KR\4.png"]]*)
    SessionID := "OpenSess", HLM := 0

    RMS := "#0.1"

    Version := Version()

    About := "`nCash Helper v" Version " Released!"
           . "`nThis is a free app made in purpose to help a friend"
           . "`nMany thanks to the next:"
           . "`n"
           . "`nIsmail Jarallah: "
           . "`nDebugging the app"
           . "`nSuggesting ideas"
           . "`nReal-Time testing"
           . "`nVerifying the app effectiveness"
           . "`n"
           . "`nMuhammad Abdelmumen:"
           . "`nInitial ideas of app"
           . "`nVerifying the app effectiveness"
           . "`n"
           . "`nAtef Naji:"
           . "`nVerifying the app effectiveness"
           . "`nSuggesting ideas"
           
    Gui, About:+ParentMain +HwndAbt
    Gui, About:Color, FFFF00
    Gui, About:Font, s10 Bold Italic, Calibri
    Gui, About:-Caption
    Gui, About:Add, Edit, x2 y0 w180 vAboutText Center -E0x200 ReadOnly -VScroll HwndE, % About
    CtlColors.Attach(E, "000000", "FFFF00")
    GuiControlGet, Height, About:Pos, AboutText
    
    Gui, About:Add, Edit, w180 vAboutText_ Center -E0x200 ReadOnly -VScroll HwndE, % About
    CtlColors.Attach(E, "000000", "FFFF00")
    Gui, About:Show, % "x3 y17 h" HeightH + 10 " w198"
    Gui, % "About: +Resize +MaxSize198x" HeightH + 10 " MinSize198x" HeightH + 10
    SetTimer, About, 0
    GuiControl, Main:Focus, OpenMain
Return

DisplayEqCurr:
    Gui, Main:Submit, NoHide
    LV_Delete()
    If (Currents != "All") {
        For Each, SO in UsersSells {
            If (SubStr(Each, 1, InStr(Each, "_") - 1) = Currents) {
                LV_Add(, SO[1], SO[2])
            }
        }

    } Else {
        For Each, SO in UsersSells {
            If InStr(Each, "_")
                LV_Add(, SO[1], SO[2])
        }
    }

    GuiControl, Main:, ProfitEq, % "+ " UsersSells[Currents][3] " " ConvertMillimsToDT(UsersSells[Currents][3], "+")
    GuiControl, Main:, Sold, % "+ " UsersSells[Currents][4] " " ConvertMillimsToDT(UsersSells[Currents][4], "+")
    GuiControl, Main:, Bought, % "- " UsersSells[Currents][2] " " ConvertMillimsToDT(UsersSells[Currents][2], "-")
Return

SearchStock:
    Gui, Main:Submit, NoHide
    LoadStockList()
Return

UpdateProgressBar:
    CurrentSize := File.Length()
    LastSizeTick := CurrentSizeTick
    LastSize := CurrentSize
    PercentDone := Round(CurrentSize / FinalSize * 100)
    Progress, % PercentDone, % PercentDone " % - " _54
Return

CFU:
    GuiControl, Main:Disabled, CFU
    CheckForUpdates()
    GuiControl, Main:Enabled, CFU
Return

SubKridi:
    LoadKridiUsers()
    Gui, Kridi:Show,, % _34
    GuiControl, Kridi:Focus, KName
    ThisCharList := {}
    Loop, % LV_GetCount() {
        LV_GetText(Col1, A_Index, 1), LV_GetText(Col2, A_Index, 2), LV_GetText(Col3, A_Index, 3), LV_GetText(Col4, A_Index, 4), LV_GetText(Col5, A_Index, 5)
        ThisCharList[A_Index] := [Col1, Col2, Col3, Col4, Col5]
    }
    Gui, Kridi:Default
    LV_Delete()
    For Each, Item in ThisCharList {
        LV_Add(, Item[1], Item[2], Item[3], Item[4], Item[5])
    }
    Gui, Main:Submit, NoHide
    GuiControl, Kridi:, ThisTotal, % "+ " AllSum " " ConvertMillimsToDT(AllSum, "+")
    Gui, Main:Default
Return

KridiGuiClose:
    Gui, Kridi:Hide
    GuiControl, Main:Focus, Bc
Return

DisplayEqProf:
    Gui, Main:Submit, NoHide
    ByDate := SubStr(ByDate, InStr(ByDate, " ",, 0))
    Arr := StrSplit(ByDate, ";")
    GuiControl, Main:, Today, % Arr[2]
    GuiControl, Main:, Yesterday, % Arr[1]
    GoSub, DisplayEqProfit
Return

About:
    YPos += 1
    GuiControl, About:Move, AboutText, % "y" YPos
    GuiControl, About:Move, AboutText_, % "y" YPos - HeightH - 2
    If (Ypos = HeightH) {
        YPos := 0
    }
    Sleep, 25
Return

MultiSelTog:
    If (MultiSel := !MultiSel) {
        GuiControl, Main:, MultiSelCB3, % Chr(252)
    } Else {
        GuiControl, Main:, MultiSelCB3
    }
Return

FixedToolTipTog:
    If (FixedToolTip := !FixedToolTip) {
        GuiControl, Main:, FixedToolTipCB3, % Chr(252)
    } Else {
        GuiControl, Main:, FixedToolTipCB3
    }
Return

RememberLogin:
    Gui, Main:Submit, NoHide
    If (RememberLogin := !RememberLogin) {
        IniWrite, % TP, Setting.ini, OtherSetting, RemUser
        DB_Write("Sets\RL.db", TP ";" TU)
        GuiControl, Main:, RememberLoginCB3, % Chr(252)
    } Else {
        IniWrite, % "", Setting.ini, OtherSetting, RemUser
        FileDelete, Sets\RL.db
        GuiControl, Main:, RememberLoginCB3
    }
Return
;CheckForUpdatesCB3
CheckForUpdates:
    Gui, Main:Submit, NoHide
    If (CheckForUpdates := !CheckForUpdates) {
        IniWrite, 1, Setting.ini, Update, Upt
        GuiControl, Main:, CheckForUpdatesCB3, % Chr(252)
    } Else {
        IniWrite, 0, Setting.ini, Update, Upt
        GuiControl, Main:, CheckForUpdatesCB3
    }
Return

ApplyPD:
    Gui, Main:Submit, NoHide
    RegExMatch(PrevPD, "\[\d+\]", PrevID)
    If (PrevID != "[0]") {
        Loop, Files, % "Sets\Bu\*.bu"
        {
            If ("[" A_Index "]" = PrevID) {
                FileCopy, % "Sets\PD.db", % "Sets\Bu\" A_Now ".Bu"
                FileCopy, % A_LoopFileFullPath, % "Sets\PD.db", 1
                GuiControl, Main:Disabled, PDSave
                LoadPrevPD()
                ProdDefs := LoadDefinitions(DB_Read("Sets\PD.db"))
                LoadDefined()
                Break
            }
        }
    }
Return

PrevPDAnalyze:
    Gui, Main:Submit, NoHide
    GuiControl, Main:Enabled, PDSave
    RegExMatch(PrevPD, "\[\d+\]", PrevID)
    If (PrevID = "[0]") {
        LV_Delete()
        PDAllItems := ""
        PDProdDefs := LoadDefinitions(DB_Read("Sets\PD.db"))

        For Each, Item in PDProdDefs {
            PDAllItems .= Each ","
        }
        
        Sort, PDAllItems, N D,
        Loop, Parse, % Trim(PDAllItems, ","), `,
            LV_Add("", A_LoopField, PDProdDefs["" A_LoopField ""][1], PDProdDefs["" A_LoopField ""][2], PDProdDefs["" A_LoopField ""][3])
        GuiControl, Main:Disabled, PDSave
    } Else {
        Loop, Files, % "Sets\Bu\*.bu"
        {
            If ("[" A_Index "]" = PrevID) {
                LV_Delete()
                PDAllItems := ""

                PDProdDefs := LoadDefinitions(DB_Read(A_LoopFileFullPath))
                For Each, Item in PDProdDefs {
                    PDAllItems .= Each ","
                }

                Sort, PDAllItems, N D,
                Loop, Parse, % Trim(PDAllItems, ","), `,
                    LV_Add("", A_LoopField, PDProdDefs["" A_LoopField ""][1], PDProdDefs["" A_LoopField ""][2], PDProdDefs["" A_LoopField ""][3])
                Break
            }
        }
    }
Return

DisplayKridi:
    LV_Delete()
    Gui, Main:Submit, NoHide
    KridiSum := 0, KridiArr := StrSplit(KLB, "|")
    ;InStr(KLB, "|") ? (LV_Add("",, KridiArr[1] " :"), LV_Add())
    For Each, One in KridiArr {
        ThisKridiSum := 0
        InStr(KLB, "|") ? (LV_Add(), LV_Add("",, "| " One " |"), LV_Add())
        Loop, Files, % "Kr\" (ThisKLB := EncodeAlpha(One)) "\*.db"
        {
            Index := A_Index
            If (RD := DB_Read(A_LoopFileFullPath)) {
                Arr__ := StrSplit(RD, "> "), Date := (StrSplit(Arr__[1], "|")[2])
                Items := StrSplit(Trim(Arr__[2], "|"), "|")
                For Each, One in Items {
                    ThisOne := StrSplit(One, ";")
                    LV_Add("", ThisOne[1], Index " | " (((DT := StrSplit(Arr__[1], "|"))[2]) ? DT[2] : DT[1]), ThisOne[2], ThisOne[3], ThisOne[4])
                    KridiSum += ThisOne[4]
                    ThisKridiSum += ThisOne[4]
                }
            }
        }
        LV_Add("",,,,, ThisKridiSum " " ConvertMillimsToDT(ThisKridiSum))
    }
    GuiControl, Main:, ThisListSum, % ((KridiSum) ? (KridiSum " " ConvertMillimsToDT(KridiSum)) : "---")
Return

CheckKExist:
    GuiControl, Kridi:Choose, KLB, 0
    Gui, Kridi:Submit, NoHide
    GuiControl, Kridi:ChooseString, KLB, % KName
    Gui, Kridi:Submit, NoHide
    GuiControl, Kridi:, Total, % PrevKridis[KLB] " " ConvertMillimsToDT(PrevKridis[KLB])
Return

WriteItDown:
    Gui, Kridi:Submit, NoHide
    If (KLB) {
        GuiControl, Kridi:, KName, % KLB
        GuiControl, Kridi:Focus, KName
        SelectAll(KE)
    }
Return

CheckAndRun:
    SetTimer, About, Off
    Gui, About:Hide
    Loop, Parse, % "OpenMain,Submit,Define,Prof,Stockpile,Manage,Kridi", `,
        GuiControl, Main:Hide, %A_LoopField%

    Global ProdDefs := {}
    If FileExist("Sets\PD.db")
        ProdDefs := LoadDefinitions(DB_Read("Sets\PD.db"))

    LastMDate := ""
    FileGetTime, PBMData, Sets\PD.db, M

    Table := ["A", "B", "C", "D", "E", "F"]
    FileGetTime, PBMData, Sets\PD.db, M
    CoordMode, Mouse, Screen
    OnMessage(0x200, "MouseHover")

    Loop, Parse, % "1243567"
        GuiControl, Main:Show, Btn%A_LoopField%

    SetTimer, Update, 250
    Gui, Main:+Resize +MinSize1000x500
    Gui, Main:Show, % "Maximize"
    Gosub, % LabelName ? LabelName : A_GuiControl
    MM := 1
Return

Reload:
    Reload
Return
ChooseItem:
    Gui, Main:Submit, NoHide
    Bc := SubStr(CB, InStr(CB, " ",, 0) + 1)
    GuiControl, Main:, Bc, % Trim(Bc, "[]")
Return
DisplayEqProfit:
    Gui, Main:Submit, NoHide

    OAPr := 0
    CP := 0
    SPr := 0

    GuiControl, Main:, SPr, % SPr
    GuiControl, Main:, CPr, % CP
    GuiControl, Main:, OAProfit, % OAPr
    GuiControl, Main:Show, PB
    
    LV_Delete()

    LoadObj := FileOpen("Loads\Mem.ld", "r")
    Loop, Files, Valid\*.db, F R
    {
        If Var Between %Yesterday% and %Today%
        {
            _Arr := StrSplit(Line[3], ",")

            SPr := SPr + _Arr[2]
            CP := CP + _Arr[3]
            OAPr := OAPr + _Arr[4]

            LV_Add("", StrReplace(Line[1], "'"), _Arr[1], "+ " _Arr[2], "- " _Arr[3], "+ " _Arr[4])
            
        }
        If (Mod(A_Index, 100) = 0)
            GuiControl, Main:, PB, % A_Index / Lines * 100
    }
    
    GuiControl, Main:, SPr, % SPr
    GuiControl, Main:, CPr, % CP
    GuiControl, Main:, OAProfit, % OAPr
    GuiControl, Main:, PB, % 0
    GuiControl, Main:Hide, PB
Return

WM_LBUTTONDOWN:
    PostMessage 0xA1, 2
Return

UpdateSession:
    Gui, Main:Submit, NoHide
    Loop, Parse, % ",1,2,3,4,5,6", `,
        GuiControl, Main:Enable, % "OpenSess" A_LoopField
    GuiControl, Main:Disabled, % A_GuiControl
    SessionID := A_GuiControl
    If FileExist("Dump\" SessionID ".db")
        RestoreSession(DB_Read("Dump\" SessionID ".db"))
    Else {
        Loop, Parse, % StrReplace(MainCtrlList, "$"), `,
        {
            If (A_LoopField != "Qn")
                GuiControl, Main:, % A_LoopField
            Else
                GuiControl, Main:, % A_LoopField, % "x1"
        }
        LV_Delete()
    }
    GuiControl, Main:Hide, GivenMoney
    GuiControl, Main:Hide, AllSum
    GuiControl, Main:Hide, Change
    GuiControl, Main:Hide, CB
    GuiControl, Main:Show, Bc
    GuiControl, Main:Show, Nm
    GuiControl, Main:Show, Qn
    GuiControl, Main:Show, Sum
    GuiControl, Main:Show, Stck
    GuiControl, Main:Focus, Bc
Return
;:*C:LetAppRunOnThisMachine::
;    If WinActive("ahk_id " Main) {
;        If (RMS = "#-1") {
;            Pass := 1
;            ADMUsername := ADMPassword := ""
;            GuiControl, Main:, PassString, Create ADM username
;        }
;    }
;Return
MainGuiSize:
    WinGetPos,,, Width, Height, % "ahk_id " Main
    Height -= 35
    
    GuiControl, Main:Move, % "Prt1", % "y" Height - 55 " w" Width - 199
    GuiControl, Main:Move, % "Prt2", % "y" Height - 55
    GuiControl, Main:Move, % "Prt3", % "y" Height - 60 " w" Width
    GuiControl, Main:Move, % "Prt4", % "h" Height - 70
    Loop, 5 {
        GuiControl, Main:+Redraw, % "Prt" A_Index
    }
    If (RMS = "#0") {
        GuiControl, Main:Move, TU, % "y" Height - 45
        GuiControl, Main:+Redraw, TU
        GuiControl, Main:Move, TP, % "y" Height - 45
        GuiControl, Main:+Redraw, TP
        GuiControl, Main:Move, Login, % "y" Height - 45
        GuiControl, Main:+Redraw, Login
        GuiControl, Main:Move, % "TText", % "x0 w" Width
        GuiControl, Main:+Redraw, TText
    }
    Width -= 30
    Third := (Width - 217) // 3
    If (RMS != "#0") {
        GuiControl, Main:Move, Reload, % "y" Height - 40
        GuiControl, Main:+Redraw, Reload
        GuiControl, Main:Move, TP, % "y" Height - 40
        GuiControl, Main:+Redraw, TP
        GuiControl, Main:Move, CFU, % "x" Width-160 "y" Height - 40
        GuiControl, Main:+Redraw, CFU
    }
    If (RMS = "#1") {
        InitY := 180
        GuiControl, Main:Move, % "ProfitP", % "y" Height - InitY
        GuiControl, Main:Move, % "CostP", % "y" Height - InitY - 65
        GuiControl, Main:Move, % "SoldP", % "y" Height - InitY - (65 * 2)
        GuiControl, Main:Move, % "ItemsSold", % "y" Height - InitY - (65 * 3)

        GuiControl, Main:Move, % "Bc", % "w" Third
        GuiControl, Main:Move, % "AddEnter", % "x" Third + 227
        GuiControl, Main:Move, % "CB", % "w" Third
        GuiControl, Main:Move, % "Nm", % "w" Third
        GuiControl, Main:Move, % "Qn", % "x" (Third * 2) + 217 " w" Third
        GuiControl, Main:Move, % "Sum", % "x" Third + 217 " w" Third
        GuiControl, Main:Move, % "LV0", % "x" 217 " w" (Third * 3) " h" Height - 260
        Gui, Main:ListView, LV0
        LV_ModifyCol(3, (Val := Third) - 61)
        LV_ModifyCol(4, Val - 62)
        LV_ModifyCol(5, Val - 61)
        GuiControl, Main:Move, % "ThisListSum", % "x" (Third * 2) + 217 " y" Height - 118 " w" Third

        GuiControl, Main:Move, % "GivenMoney", % "w" Third
        GuiControl, Main:Move, % "AllSum", % "x" Third + 217 " w" Third
        GuiControl, Main:Move, % "Change", % "x" (Third * 2) + 217 " w" Third
        ThisY := Height - 85
        GuiControl, Main:Move, % "OpenSess", % "x" 217 " y" ThisY
        GuiControl, Main:Move, % "OpenSess" 1, % "x" 243 " y" ThisY
        GuiControl, Main:Move, % "OpenSess" 2, % "x" 269 " y" ThisY
        GuiControl, Main:Move, % "OpenSess" 3, % "x" 295 " y" ThisY
        GuiControl, Main:Move, % "OpenSess" 4, % "x" 321 " y" ThisY
        GuiControl, Main:Move, % "OpenSess" 5, % "x" 347 " y" ThisY
        GuiControl, Main:Move, % "OpenSess" 6, % "x" 373 " y" ThisY
        Loop, Parse, % ",1,2,3,4,5,6", `,
            GuiControl, Main:+Redraw, % "OpenSess" A_LoopField
        If (Loaded) {
            Loop, Parse, % ",1,2,3,4,5,6", `,
                GuiControl, Main:+Redraw, % "OpenSess" A_LoopField
        }
    } Else If (RMS = "#2") {
        GuiControl, Main:Move, % "LV1", % "w" (Third * 3) " h" Height - 300
        Gui, Main:ListView, LV1
        LV_ModifyCol(2, (Third * 3) - 22)
        GuiControl, Main:Move, % "Sold", % "y" Height - 135 " w" Third
        GuiControl, Main:Move, % "Bought", % "x" Third + 217 " y" Height - 135 " w" Third
        GuiControl, Main:Move, % "ProfitEq", % "x" (Third * 2) + 217 " y" Height - 135 " w" Third
    } Else If (RMS = "#3") {
        Quarter := (Width - 217) // 4

        GuiControl, Main:Move, % "Dbc", % "w" Quarter
        GuiControl, Main:Move, % "Dnm", % "x" Quarter + 217 " w" Quarter
        GuiControl, Main:Move, % "Dbp", % "x" (Quarter * 2) + 217 " w" Quarter
        GuiControl, Main:Move, % "Dsp", % "x" (Quarter * 3) + 217 " w" Quarter
        GuiControl, Main:Move, % "DbcT", % "w" Quarter
        GuiControl, Main:Move, % "DnmT", % "x" Quarter + 217 " w" Quarter
        GuiControl, Main:Move, % "DbpT", % "x" (Quarter * 2) + 217 " w" Quarter
        GuiControl, Main:Move, % "DspT", % "x" (Quarter * 3) + 217 " w" Quarter
        GuiControl, Main:Move, % "PrevPD", % "x" (Quarter * 3) + 217 " w" Quarter

        GuiControl, Main:Move, % "PDSave", % "x" (Quarter * 3) + 217 " w" Quarter
        GuiControl, Main:, % "PDSave", % _30
        ImageButton.Create(PDSave_, RedBTN*)

        If (Loaded) {
            GuiControl, Main:+Redraw, % "PDSave"
        }

        GuiControl, Main:Move, % "LV2", % "w" (Quarter * 4) " h" Height - 270
        Gui, Main:ListView, LV2
        LV_ModifyCol(1, (Val := Quarter) - 2)
        LV_ModifyCol(2, Val - 1)
        LV_ModifyCol(3, Val)
        LV_ModifyCol(4, Val - 1)
    } Else If (RMS = "#4") {
        GuiControl, Main:Move, % "Pnm", % "w" Third
        GuiControl, Main:Move, % "PnmT", % "w" Third
        GuiControl, Main:+Redraw, % "PnmT"
        GuiControl, Main:Move, % "PnmTT", % "x" Third + 217 " w" Third
        GuiControl, Main:+Redraw, % "PnmTT"
        GuiControl, Main:Move, % "PqnT", % "x" (Third * 2) + 217 " w" Third
        GuiControl, Main:+Redraw, % "PqnT"
        GuiControl, Main:Move, % "SaveCh", % "x" ((Width - 517) // 2) + 217 " y" Height - 105
        GuiControl, Main:+Redraw, % "SaveCh"
        Gui, Main:ListView, LV3
        ;GuiControl, Main:Move, % "Pqn", % "x" Third + 217 " w" Third
        GuiControl, Main:Move, % "Psum", % "x" (Third * 2) + 217 " w" Third
        GuiControl, Main:Move, % "LV3", % "w" (Third * 3) " h" Height - 250
        ;GuiControl, Main:Move, % "SSt", % "x" ((Third * 2) // 2) + 217 " w" (Third // 2)
        ;GuiControl, Main:Move, % "StockSum", % "x" (Third * 2) + 217 " y" Height - 120 " w" Third

        LV_ModifyCol(1, Third)
        LV_ModifyCol(2, Third)
        LV_ModifyCol(3, Third)
    } Else If (RMS = "#5") {
        Quarter := (Width - 217) // 4
        GuiControl, Main:Move, % "SPr", % "x" Quarter + 217 " w" Quarter
        GuiControl, Main:Move, % "ProfByName", % "x" 217 " w" Quarter - 20
        GuiControl, Main:Move, % "CPr", % "x" (Quarter * 2) + 217 " w" Quarter
        GuiControl, Main:Move, % "OAProfit", % "x" (Quarter * 3) + 217 "w" Quarter
        GuiControl, Main:Move, % "Today", % "x" 217 " y" Height - 115
        GuiControl, Main:Move, % "Yesterday", % "x" Width - 350 " y" Height - 115
        GuiControl, Main:Move, % "PB", % "w" (Quarter * 4)
        GuiControl, Main:Move, % "LV4", % "w" (Quarter * 4) " h" Height - 260
        Gui, Main:ListView, LV4
        LV_ModifyCol(2, (Val := Quarter) - 3)
        LV_ModifyCol(3, Val)
        LV_ModifyCol(4, Val)
        LV_ModifyCol(5, Val - 1)
    } Else If (RMS = "#6") {
        GuiControl, Main:Move, % "LV0", % "h" Height - 140
    } Else If (RMS = "#7") {
        Quarter := (Width - 432) // 4
        GuiControl, Main:Move, % "GivenMoney", % "w" Third
        GuiControl, Main:Move, % "AllSum", % "x" Third + 217 " w" Third
        GuiControl, Main:Move, % "Change", % "x" (Third * 2) + 217 " w" Third
        GuiControl, Main:Move, % "KLB", % "x" 217 " h" Height - 260
        GuiControl, Main:Move, % "LV6", % "x" 437 " w" (Third * 3) - 220 " h" Height - 260
        GuiControl, Main:Move, % "ThisListSum", % "x" (Third * 2) + 217 " y" Height - 118 " w" Third
        Gui, Main:ListView, LV6
        LV_ModifyCol(2, Quarter)
        LV_ModifyCol(3, Quarter)
        LV_ModifyCol(4, Quarter)
        LV_ModifyCol(5, Quarter)
    }
Return

CheckIntCalc:
    Gui, Main:Submit, NoHide
    If (Percent) && (Percent > 100) {
        GuiControl, Main:, Percent, 100
        SelectAll(Percent_)
    }
Return

Update:
    If WinActive("ahk_id " Main) {
        If (Level = "User") {
            If (RMS = "#0.1") {
                Loop, Parse, % "Submit,Define,Prof,Stockpile,Manage,Kridi", `,
                {
                    GuiControlGet, Enb, Main:Enabled, % A_LoopField
                    If (Enb) {
                        GuiControl, Main:Disabled, % A_LoopField
                    }
                    GuiControlGet, Visi, Main:Visible, % A_LoopField
                    If (Visi) {
                        GuiControl, Main:Hide, % A_LoopField
                    }
                }
            } Else {
                Loop, 6 {
                    GuiControlGet, Enb, Main:Enabled, % "Btn" A_Index + 1
                    If (Enb) {
                        GuiControl, Main:Disabled, % "Btn" A_Index + 1
                    }
                    GuiControlGet, Visi, Main:Visible, % "Btn" A_Index + 1
                    If (Visi) {
                        GuiControl, Main:Hide, % "Btn" A_Index + 1
                    }
                }
            }
            GuiControlGet, Visi, Main:Visible, % "CFU"
            If (Visi) {
                GuiControl, Main:Hide, % "CFU"
            }
        }
        
        If FileExist("Sets\PD.db") {
            FileGetTime, _ThisMData, Sets\PD.db, M
            If (PBMData != _ThisMData) {
                ProdDefs := LoadDefinitions(DB_Read("Sets\PD.db"))
                PBMData := _ThisMData
            }
        }
        If (RMS = "#1") {
            FileGetTime, ThisMData, Curr, M
            If (ThisMData != LastMDate) {
                Nb := CPr := SPr := OAPr := 0
                GuiControl, Main:, ItemsSold, % Nb
                GuiControl, Main:, SoldP, % SPr
                GuiControl, Main:, CostP, % CPr
                GuiControl, Main:, ProfitP, % OAPr
                Loop, Files, Curr\*.db
                {
                    RD := DB_Read(A_LoopFileFullPath)
                    If (RD) {
                        Arr := CalcProfit(RD)
                        SPr := Arr[2][1] + SPr
                        CPr := Arr[2][2] + CPr
                        OAPr := Arr[2][3] + OAPr
                        Nb := Nb + Arr[3]
                    }
                }
                GuiControl, Main:, ItemsSold, % Nb ? Nb " " _37 : "---"
                GuiControl, Main:, SoldP, % SPr ? SPr "`n" ConvertMillimsToDT(SPr) : "---"
                GuiControl, Main:, CostP, % CPr ? CPr "`n" ConvertMillimsToDT(CPr) : "---"
                GuiControl, Main:, ProfitP, % OAPr ? OAPr "`n" ConvertMillimsToDT(OAPr) : "---"
                LastMDate := ThisMData
            }

            GuiControlGet, Visi, Main:Visible, CB
            If (Visi) {
                GuiControlGet, ThisFocus, Main:FocusV
                If (ThisFocus != "CB") {
                    GuiControl, Main:Hide, CB
                }
                MouseGetPos,,,, OutputVarControl
                If !(OutputVarControl ~= "Edit7|ComboLBox1") {
                    GuiControl, Main:+Redraw, CB
                }
            }
        }
    }
Return
OpenMain:
    RMS := "#1"
    Loop, Parse, % "1243567"
        GuiControl, Main:Disabled, Btn%A_LoopField%
    Gosub, MainGuiSize
    Hide(EnsureCtrlList "," DefineCtrlList "," StockPileCtrlList "," ProfitCtrlList "," ManageCtrlList "," KridiCtrlList)
    Show(MainCtrlList)
    
    Gui, Main:ListView, LV0
    Gui, Main:Submit, NoHide
    Loop, Parse, % "243567"
        GuiControl, Main:Enabled, Btn%A_LoopField%
    If FileExist("Dump\" SessionID ".db")
        RestoreSession(DB_Read("Dump\" SessionID ".db"))
    GuiControl, Main:Focus, Bc

    If (HLM) {
        Loop, Parse, % "ItemsSold,CostP,SoldP,ProfitP", `,
            GuiControl, Main:Show, % A_LoopField
    } Else {
        Loop, Parse, % "ItemsSold,CostP,SoldP,ProfitP", `,
            GuiControl, Main:Hide, % A_LoopField
    }
Return

Submit:
    RMS := "#2"
    Gosub, MainGuiSize
    Loop, Parse, % "1243567"
        GuiControl, Main:Disabled, Btn%A_LoopField%
    Hide(MainCtrlList "," DefineCtrlList "," StockPileCtrlList "," ProfitCtrlList "," ManageCtrlList "," KridiCtrlList)
    Show(EnsureCtrlList)
    Gui, Main:ListView, LV1
    GuiControl, Main:Enabled, EnsBtn
    LoadCurrent()
    Loop, Parse, % "134567"
        GuiControl, Main:Enabled, Btn%A_LoopField%
    GuiControl, Main:Focus, EnsBtn
    If (HLM) {
        Loop, Parse, % "Sold,Bought,ProfitEq", `,
            GuiControl, Main:Show, % A_LoopField
    } Else {
        Loop, Parse, % "Sold,Bought,ProfitEq", `,
            GuiControl, Main:Hide, % A_LoopField
    }
Return
Define:
    RMS := "#3"
    Gosub, MainGuiSize
    Loop, Parse, % "1243567"
        GuiControl, Main:Disabled, Btn%A_LoopField%
    Hide(MainCtrlList "," EnsureCtrlList "," StockPileCtrlList "," ProfitCtrlList "," ManageCtrlList "," KridiCtrlList)
    Show(DefineCtrlList)
    Gui, Main:ListView, LV2

    GuiControl, Main:, Dbc, % Dbc := ""
    GuiControl, Main:, Dnm, % Dnm := ""
    GuiControl, Main:, Dbp, % Dbp := ""
    GuiControl, Main:, Dsp, % Dsp := ""
    GuiControl, Main:Focus, Dbc
    EditMod[1] := 0

    LoadDefined()
    LoadPrevPD()
    Loop, Parse, % "124567"
        GuiControl, Main:Enabled, Btn%A_LoopField%
Return
StockPile:
    RMS := "#4"
    Gosub, MainGuiSize
    Loop, Parse, % "1243567"
        GuiControl, Main:Disabled, Btn%A_LoopField%
    Hide(MainCtrlList "," EnsureCtrlList "," DefineCtrlList "," ProfitCtrlList "," ManageCtrlList "," KridiCtrlList)
    Show(StockPileCtrlList)
    Gui, Main:ListView, LV3
    ;LoadStockList()

    Loop, Parse, % "123567"
        GuiControl, Main:Enabled, Btn%A_LoopField%
    GuiControl, Main:, Pnm
    GuiControl, Main:Focus, Pnm
Return
Prof:
    RMS := "#5"
    Gosub, MainGuiSize
    Loop, Parse, % "1234567"
        GuiControl, Main:Disabled, Btn%A_LoopField%

    Hide(MainCtrlList "," EnsureCtrlList "," DefineCtrlList "," StockPileCtrlList "," ManageCtrlList "," KridiCtrlList)
    Show(ProfitCtrlList)
    Gui, Main:ListView, LV4

    GuiControl, Main:, Today, % Yesterday := A_Now
    Yesterday += -1, Days
    GuiControl, Main:, Yesterday, % Yesterday

    LoadProf()
    Loop, Parse, % "123467"
        GuiControl, Main:Enabled, Btn%A_LoopField%
    GuiControl, Main:Focus, LV4
Return
Manage:
    
    RMS := "#6"
    Gosub, MainGuiSize
    Loop, Parse, % "1234567"
        GuiControl, Main:Disabled, Btn%A_LoopField%


    Hide(MainCtrlList "," EnsureCtrlList "," DefineCtrlList "," StockPileCtrlList "," ProfitCtrlList "," KridiCtrlList)
    Show(ManageCtrlList)
    Gui, Main:ListView, LV5
    LoadAccounts()
    LoadSetting()
    Loop, Parse, % "123457"
        GuiControl, Main:Enabled, Btn%A_LoopField%
    GuiControl, Main:Focus, UserName
    GuiControl, Main:Focus, LV5
Return

Kridi:
    RMS := "#7"
    Gosub, MainGuiSize
    Loop, Parse, % "1234567"
        GuiControl, Main:Disabled, Btn%A_LoopField%


    Hide(MainCtrlList "," EnsureCtrlList "," DefineCtrlList "," StockPileCtrlList "," ProfitCtrlList "," ManageCtrlList)
    Show(KridiCtrlList)
    Gui, Main:ListView, LV6
    LoadKridis()
    Loop, Parse, % "123456"
        GuiControl, Main:Enabled, Btn%A_LoopField%
    GuiControl, Main:Focus, KLB
Return

Edit:
    LV_GetText(EBc, Row := LV_GetNext(), 1)
    EditMod := [1, EBc]
    LV_GetText(ENm, Row, 2)
    LV_GetText(EBp, Row, 3)
    LV_GetText(ESp, Row, 4)
    GuiControl, Main:, Dbc, % EBc
    GuiControl, Main:, Dnm, % StrSplit(ENm, " | ")[2]
    GuiControl, Main:, Dbp, % EBp
    GuiControl, Main:, Dsp, % ESp
Return
Calc:
    Gui, Main:Submit, NoHide
    GuiControl, Main:, Change
    If GivenMoney is not Digit
    {
        ShakeControl("Main", GivenMoney)
    } Else If (GivenMoney >= AllSum) {
        GuiControl, Main:, Change, % GivenMoney - AllSum
    }
Return
Valid:
    Gui, Main:Default
    FileCreateDir, % "Valid\" Now := A_Now
    Loop, % LV_GetCount() {
        LV_GetText(FP, A_Index, 1)
        FileMove, % FP, % "Valid\" Now
    }
    LoadCurrent()
Return
StockSum:
    Gui, STSum:Show,, % _64
    Gui, STSum:Default
    LV_Delete()
    GuiControl, STSum:, StockSum, ---
    AllItems := ""
    For Each, Item in RowsArr {
        AllItems .= Each ","
    }
    Sort, AllItems, N D,
    Loop, Parse, % Trim(AllItems, ","), `,
    {
        (A_LoopField != "OverAll") ? LV_Add("", A_LoopField, ProdDefs["" A_LoopField ""][1], RowsArr["" A_LoopField ""][2], RowsArr["" A_LoopField ""][3])
    }
    GuiControl, STSum:, StockSum, % RowsArr["OverAll"] " " ConvertMillimsToDT(RowsArr["OverAll"])
    Gui, Main:Default
Return
ClearDbc:
    Gui, Main:Submit, NoHide
    CtlColors.Change(Dbc_, "FFFFFF", "000000")
    If (Dbc ~= "[^0-9A-Za-z]") {
        CtlColors.Change(Dbc_, "FF8080", "000000")
        ShakeControl("Main", "Dbc")
    }
Return
ClearDnm:
    Gui, Main:Submit, NoHide
    CtlColors.Change(Dnm_, "FFFFFF", "000000")
    If (Dnm ~= "\[|\]|\;|\$|\||\/") {
        CtlColors.Change(Dnm_, "FF8080", "000000")
    ShakeControl("Main", "Dnm")
}
Return
ClearDbp:
    Gui, Main:Submit, NoHide
    CtlColors.Change(Dbp_, "FFFFFF", "000000")
    If (Dbp ~= "[^0-9]") {
        CtlColors.Change(Dbp_, "FF8080", "000000")
        ShakeControl("Main", "Dbp")
    }
Return
ClearDsp:
    Gui, Main:Submit, NoHide
    CtlColors.Change(Dsp_, "FFFFFF", "000000")
    If (Dsp ~= "[^0-9]") {
        CtlColors.Change(Dsp_, "FF8080", "000000")
        ShakeControl("Main", "Dsp")
    }
Return

#If WinActive("ahk_id " Main)
F1::
    LabelName := "OpenMain"
    GoSub, CheckAndRun
    LabelName := ""
Return
F2::
    LabelName := "Submit"
    GoSub, CheckAndRun
    LabelName := ""
Return
F3::
    LabelName := "Define"
    GoSub, CheckAndRun
    LabelName := ""
Return
F4::
    LabelName := "StockPile"
    GoSub, CheckAndRun
    LabelName := ""
Return
F5::
    LabelName := "Prof"
    GoSub, CheckAndRun
    LabelName := ""
Return
F6::
    LabelName := "Manage"
    GoSub, CheckAndRun
    LabelName := ""
Return
F7::
    LabelName := "Kridi"
    GoSub, CheckAndRun
    LabelName := ""
Return
^s::
    If (RMS="#3") {
        Gui, Main:Submit, NoHide
        Gui, Main:Default
        If (Row := LV_GetNext()) {
            NRow := 0, TmpArr := [], ListPro := ""
            While (NRow != Row) {
                If (A_Index = 1)
                    NRow := Row
                If (NRow) {
                    LV_GetText(Bc, NRow, 1)
                    TmpArr.Push(Bc)
                    ListPro .= ListPro ? Bc "/" : "/" Bc "/"
                }
                NRow := LV_GetNext(NRow)
            }
            If (TmpArr.Length() >= 2) {
                NotAlreadyDefined := 1
                For All, Things in TmpArr {
                    If (ProdDefs["" Things ""][5]) {
                        NotAlreadyDefined := 0
                        Break
                    }
                }
                ;Msgbox % ListPro
                StockedTogether := ""
                If (NotAlreadyDefined) {
                    SetQn := ProdDefs["" TmpArr[1] ""][4] ? ProdDefs["" TmpArr[1] ""][4] : 0
                    For Each, One in TmpArr {
                        StockedTogether .= "| " ProdDefs["" One ""][1] " |"
                        ProdDefs["" One ""][4] := SetQn
                        ProdDefs["" One ""][5] := Trim(StrReplace(ListPro, "/" One "/", "/"), "/")
                    }
                    MsgBox, 64, Applied, The next list of products are added to the same stock option:`n`n%StockedTogether%`n`nStock = %SetQn%
                } Else {
                    For Each, One in TmpArr {
                        ProdDefs["" One ""][5] := ""
                        StockedTogether .= "| " ProdDefs["" One ""][1] " |"
                    }
                    MsgBox, 64, Applied, The next list of products are removed from the same stock option:`n`n%StockedTogether%
                }
                UpdateProdDefs()
            }
        }
    }
Return

Esc::
    If (RMS="#1") {
        GuiControlGet, Visi, Main:Visible, Nm
        If (!Visi) {
            GuiControl, Main:Hide, GivenMoney
            GuiControl, Main:Hide, AllSum
            GuiControl, Main:Hide, Change
            GuiControl, Main:Hide, CB
            GuiControl, Main:Hide, SubKridi
            GuiControl, Main:Show, Bc
            GuiControl, Main:Show, AddEnter
            GuiControl, Main:Show, Nm
            GuiControl, Main:Show, Qn
            GuiControl, Main:Show, Sum
            GuiControl, Main:Focus, Bc
        }
    }
Return

Right::
    If (RMS="#1") {
        Gui, Main:Submit, NoHide
        Gui, Main:Default
        Loop, Parse, % ",1,2,3,4,5,6", `,
            GuiControl, Main:Enable, % "OpenSess" A_LoopField
        If (SessionID != "OpenSess6") {
            If RegExMatch(SessionID, "\d+", Mark) {
                GuiControl, Main:Disabled, % "OpenSess" Mark + 1
                SessionID := "OpenSess" Mark + 1
            } Else {
                GuiControl, Main:Disabled, % "OpenSess1"
                SessionID := "OpenSess1"
            }
        } Else {
            GuiControl, Main:Disabled, % "OpenSess"
            SessionID := "OpenSess"
        }
        If FileExist("Dump\" SessionID ".db") {
            RestoreSession(DB_Read("Dump\" SessionID ".db"))
        } Else {
            Loop, Parse, % StrReplace(MainCtrlList, "$"), `,
            {
                If (A_LoopField != "Qn")
                    GuiControl, Main:, % A_LoopField
                Else
                    GuiControl, Main:, % A_LoopField, % "x1"
            }
            LV_Delete()
        }
        GuiControl, Main:Hide, GivenMoney
        GuiControl, Main:Hide, AllSum
        GuiControl, Main:Hide, Change
        GuiControl, Main:Hide, CB
        GuiControl, Main:Show, Bc
        GuiControl, Main:Show, Nm
        GuiControl, Main:Show, Qn
        GuiControl, Main:Show, Sum
        GuiControl, Main:Show, Stck
        GuiControl, Main:Focus, Bc
    } Else {
        SendInput, {Right}
    }
    Sleep, 125
Return

Left::
    If (RMS="#1") {
        Gui, Main:Default
        Gui, Main:Submit, NoHide
        Loop, Parse, % ",1,2,3,4,5,6", `,
            GuiControl, Main:Enable, % "OpenSess" A_LoopField
        If (SessionID != "OpenSess") {
            RegExMatch(SessionID, "\d+", Mark)
            If (Mark > 1) {
                GuiControl, Main:Disabled, % "OpenSess" Mark - 1
                SessionID := "OpenSess" Mark - 1
            } Else {
                GuiControl, Main:Disabled, % "OpenSess"
                SessionID := "OpenSess"
            }
        } Else {
            GuiControl, Main:Disabled, % "OpenSess6"
            SessionID := "OpenSess6"
        }
        If FileExist("Dump\" SessionID ".db")
            RestoreSession(DB_Read("Dump\" SessionID ".db"))
        Else {
            Loop, Parse, % StrReplace(MainCtrlList, "$"), `,
            {
                If (A_LoopField != "Qn")
                    GuiControl, Main:, % A_LoopField
                Else
                    GuiControl, Main:, % A_LoopField, % "x1"
            }
            LV_Delete()
        }
        GuiControl, Main:Hide, GivenMoney
        GuiControl, Main:Hide, AllSum
        GuiControl, Main:Hide, Change
        GuiControl, Main:Hide, CB
        GuiControl, Main:Show, Bc
        GuiControl, Main:Show, Nm
        GuiControl, Main:Show, Qn
        GuiControl, Main:Show, Sum
        GuiControl, Main:Show, Stck
        GuiControl, Main:Focus, Bc
    } Else {
        SendInput, {Left}
    }
    Sleep, 125
Return

Tab::
    If (Level = "Admin") {
        If (RMS = "#1") {
            If (HLM := !HLM) {
                Loop, Parse, % "ItemsSold,CostP,SoldP,ProfitP", `,
                    GuiControl, Main:Show, % A_LoopField
            } Else {
                Loop, Parse, % "ItemsSold,CostP,SoldP,ProfitP", `,
                    GuiControl, Main:Hide, % A_LoopField
            }
        } Else If (RMS = "#2") {
            If (HLM := !HLM) {
                Loop, Parse, % "Sold,Bought,ProfitEq", `,
                    GuiControl, Main:Show, % A_LoopField
            } Else {
                Loop, Parse, % "Sold,Bought,ProfitEq", `,
                    GuiControl, Main:Hide, % A_LoopField
            }
        } Else {
            SendInput, {Tab}
        }
    }
    Sleep, 125
Return


#If WinActive("ahk_id " Main) or WinActive("ahk_id " Kr)
Enter::
    If WinActive("ahk_id " Main) {
        Gui, Main:Submit, NoHide
        Gui, Main:Default
        If (RMS = "#-1") {
            If (Pass) {
                If (EPassString) && (!ADMUsername) {
                    ADMUsername := EPassString
                    EPassString := ""
                    GuiControl, Main:, PassString, Create ADM password
                    GuiControl, Main:, EPassString
                }
                If (EPassString) && (!ADMPassword) {
                    ADMPassword := EPassString
                    If !FileExist("Sets\Lc.lic")
                        DB_Write("Sets\Lc.lic", UUID() ";" ADMUsername ";" ADMPassword)
                    Else {
                        LC := DB_Read("Sets\Lc.lic")
                        LC := StrSplit(LC, ";")
                        If (Encode(UUID()) != LC[1])
                            DB_Write("Sets\Lc.lic", UUID() ";" ADMUsername ";" ADMPassword)
                    }
                    GuiControl, Main:Hide, LicPic
                    GuiControl, Main:Hide, EPassString
                    GuiControl, Main:Hide, PassString
                    Reload
                }
            }
        } Else If (RMS = "#0") {
            Gui, Main:Submit, NoHide
            Level := ""
            If (!TU) {
                CtlColors.Change(TopText, "FF0000", "FFFFFF")
                GuiControl, Main:, TText, % "  " _76
                ShakeControl("Main", "TU")
                Return
            }
            If (!TP) {
                CtlColors.Change(TopText, "FF0000", "FFFFFF")
                GuiControl, Main:, TText, % "  " _77
                ShakeControl("Main", "TP")
                Return
            }
            EverythingSetting := StrSplit(DB_Read("Sets\Lc.lic"), ";")
            If (TU == EverythingSetting[2]) && (TP == EverythingSetting[3]) {
                GuiControl, Main:Hide, TU
                GuiControl, Main:+ReadOnly -Password, TP
                CtlColors.Change(TP_, "B2B2B2", "000000")
                GuiControl, Main:, TP, % TU
                GuiControl, Main:, TU, % TP
                GuiControl, Main:Show, Reload
                GuiControl, Main:Hide, Login
                GuiControl, Main:Hide, TText
                Level := "Admin"
                RMS := "#0.1"
                ;SaveLogIn()
                Gosub, Continue
            } Else If (OtherUsers := EverythingSetting[4]) {
                LOGSArray := {}
                Loop, % EverythingSetting.MaxIndex() - 3 {
                    UP := StrSplit(EverythingSetting[A_Index + 3], "/")
                    LOGSArray["" UP[1] ""] := "" UP[2] ""
                }
                If (LOGSArray["" TU ""] == TP) {
                    GuiControl, Main:Hide, TU
                    GuiControl, Main:+ReadOnly -Password, TP
                    CtlColors.Change(TP_, "B2B2B2", "000000")
                    GuiControl, Main:, TP, % TU
                    GuiControl, Main:, TU, % TP
                    GuiControl, Main:Show, Reload
                    GuiControl, Main:Hide, Login
                    GuiControl, Main:Hide, TText
                    Level := "User"
                    RMS := "#0.1"
                    ;SaveLogIn()
                    Gosub, Continue
                } Else {
                    CtlColors.Change(TopText, "FF0000", "FFFFFF")
                    GuiControl, Main:, TText, % "  " _78
                    ShakeControl("Main", "TU")
                    ShakeControl("Main", "TP")
                }
            } Else {
                CtlColors.Change(TopText, "FF0000", "FFFFFF")
                GuiControl, Main:, TText, % "  " _78
                ShakeControl("Main", "TU")
                ShakeControl("Main", "TP")
            }
        } Else If (RMS = "#1") {
            GuiControl, Main:Disabled, Bc
            GuiControlGet, Visi, Main:Visible, Nm
            If (Visi) {
                GuiControl, Main:, Bc, % Bc "."
                Bc := Bc "."
                Loop, Parse, % Trim(Bc, "."), % "."
                {
                    If (ProdDefs["" (Barcode := A_LoopField) ""][1] != "") {
                        Nm := ProdDefs["" Barcode ""][1]
                        SellPrice := ProdDefs["" Barcode ""][3]
                        ThisCurrQuantity := ProdDefs["" Barcode ""][4] ? ProdDefs["" Barcode ""][4] : 0
                        QuantitySumArg := SellPrice "x1"
                        JobDone := 0
                        Loop, % LV_GetCount() {
                            LV_GetText(ThisBc, Row := A_Index, 1)
                            If (ThisBc = Barcode) {
                                LV_GetText(AddedCurrQuantity, Row, 2), AddedCurrQuantity := StrSplit(AddedCurrQuantity, " -> ")
                                LV_GetText(AddedQuantitySumArg, Row, 4), AddedQuantitySumArg := StrSplit(AddedQuantitySumArg, "x"), QuantitySumArg := AddedQuantitySumArg[1] "x" AddedQuantitySumArg[2] + 1
                                LV_GetText(PreviousSum, Row, 5)
                                SellPrice := ProdDefs["" Barcode ""][3]

                                LV_Modify(Row,,, AddedCurrQuantity[1] " -> " AddedCurrQuantity[2] - 1,, QuantitySumArg, PreviousSum + SellPrice)
                                JobDone := 1
                                Break
                            }
                        }
                        If (!JobDone)  {
                            LV_Add("", Barcode, ThisCurrQuantity " -> " ThisCurrQuantity - 1, Nm, QuantitySumArg, SellPrice)
                        }
                    }
                }
                GuiControl, Main:, Bc
                GuiControl, Main:, Qn
                GuiControl, Main:Focus, Bc
            } Else {
                GuiControlGet, Visi, Main:Visible, CB
                If (Visi) {
                    Gui, Main:Submit, NoHide
                    Bc := SubStr(CB, InStr(CB, " ",, 0) + 1)
                    GuiControl, Main:, Bc, % Trim(Bc, "[]")
                } Else {
                    ;If (!GivenMoney) || (Change = "") {
                    ;    ShakeControl("Main", "GivenMoney")
                    ;    Return
                    ;}

                    Arr := StrSplit(Trim(StrSplit(Sum_Data[2], "> ")[2], "|"), "|")
                    For Each, SO in Arr {
                        ThisArr := StrSplit(SO, ";")
                        ThisBc := ThisArr[1]
                        ErrorInfo := ""
                        ThisQn := (Val := StrSplit(ThisArr[3], "x")[2]) ? Val : ErrorInfo .= ThisBc ": " ThisQn "|"
                        ProdDefs["" ThisBc ""][4] := ProdDefs["" ThisBc ""][4] - ThisQn
                        If (ProdDefs["" ThisBc ""][5]) {
                            For Other, Bcs in StrSplit(ProdDefs["" ThisBc ""][5], "/") {
                                ProdDefs["" Bcs ""][4] := ProdDefs["" Bcs ""][4] - ThisQn
                            }
                        }
                    }
                    If (ErrorInfo) {
                        MsgBox, 16, % _67, % Clipboard := CollectInfo
                        Return
                    }

                    DB_Write(_This := "Curr\" A_Now ".db", TP "|" Sum_Data[2])
                    UpdateProdDefs()
                    GuiControl, Main:, AllSum
                    GuiControl, Main:, Change
                    GuiControl, Main:Hide, GivenMoney
                    GuiControl, Main:Hide, AllSum
                    GuiControl, Main:Hide, Change
                    GuiControl, Main:Show, Bc
                    GuiControl, Main:Show, Nm
                    GuiControl, Main:Show, Qn
                    GuiControl, Main:Show, Sum
                    GuiControl, Main:Show, AddEnter
                    GuiControl, Main:Hide, SubKridi
                    GuiControl, Main:, Nm
                    GuiControl, Main:, Qn
                    GuiControl, Main:, Sum
                    LV_Delete()
                    If FileExist("Dump\" SessionID ".db")
                        FileDelete, % "Dump\" SessionID ".db"
                    GuiControl, Main:, GivenMoney
                }
            }
            CreateNew("Bc", "LV0")
            CheckListSum()
            GuiControl, Main:Enabled, Bc
            GuiControl, Main:, Bc
            GuiControl, Main:Focus, Bc
        } Else If (RMS = "#3") {
            Filled := (Dbc) && (Dnm) && (Dbp) && (Dsp)
            If (Filled) {
                If (Dbc ~= "[^0-9A-Za-z]") {
                    ShakeControl("Main", "Dbc")
                    Return
                }
                If (Dnm ~= "\[|\]|\;|\$|\||\/") {
                    ShakeControl("Main", "Dnm")
                Return
                }
                If (Dbp ~= "[^0-9]") {
                    ShakeControl("Main", "Dbp")
                    Return
                }
                If (Dsp ~= "[^0-9]") {
                    ShakeControl("Main", "Dsp")
                    Return
                }
                GuiControl, Main:Disabled, Dbc
                GuiControl, Main:Disabled, Dnm
                GuiControl, Main:Disabled, Dbp
                GuiControl, Main:Disabled, Dsp
                If (!EditMod[1]) {
                    If (ProdDefs["" Dbc ""][1] = "") {
                        ProdDefs["" Dbc ""] := [Dnm,Dbp,Dsp,0]
                        UpdateProdDefs()
                        LoadDefined()
                        GuiControl, Main:, Dbc
                        GuiControl, Main:, Dnm
                        GuiControl, Main:, Dbp
                        GuiControl, Main:, Dsp
                        GuiControl, Main:Focus, Dbc
                    } Else {
                        LV_Modify(0, "-Select")
                        Loop, % LV_GetCount() {
                            LV_GetText(ThisBar, A_Index, 1)
                            If (ThisBar = Dbc) {
                                GuiControl, Main:Focus, LV2
                                SendInput, {Home}
                                Loop, % A_Index - 1
                                    SendInput, {Down}
                                Break
                            }
                        }
                    }
                } Else {
                    Temp := ProdDefs.Clone()
                    If (Dbc = EditMod[2])
                        Temp.Remove("" Dbc "")
                    If (Temp["" Dbc ""][1] = "") {
                        Modify := 0
                        Loop, % LV_GetCount() {
                            LV_GetText(ThisBar, A_Index, 1)
                            If (ThisBar = Dbc) {
                                Modify := 1
                                ProdDefs["" Dbc ""] := [Dnm,Dbp,Dsp,ProdDefs["" Dbc ""][4],ProdDefs["" Dbc ""][5]]
                                LV_Modify(A_Index, "Select")
                                Break
                            }
                        }
                        If (!Modify) {
                            Loop, % LV_GetCount() {
                                LV_GetText(ThisBar, A_Index, 1)
                                If (ThisBar = EditMod[2]) {
                                    Modify := 1
                                    ProdDefs.Delete("" EditMod[2] "")
                                    ProdDefs["" Dbc ""] := [Dnm,Dbp,Dsp,ProdDefs["" Dbc ""][4],ProdDefs["" Dbc ""][5]]
                                    GuiControl, Main:Focus, LV2
                                    SendInput, {Home}
                                    Loop, % A_Index - 1
                                        SendInput, {Down}
                                    Break
                                }
                            }
                        }
                        If (Modify) {
                            _Dbc := Dbc
                            GuiControl, Main:, Dbc
                            GuiControl, Main:, Dnm
                            GuiControl, Main:, Dbp
                            GuiControl, Main:, Dsp
                            GuiControl, Main:Focus, Dbc
                            UpdateProdDefs()
                            ;LV_Modify(LV_GetNext(),, Dbc, Dnm, Dbp, Dsp)
                            LoadDefined()
                            Loop, % LV_GetCount() {
                                LV_GetText(ThisBar, A_Index, 1)
                                If (ThisBar = _Dbc) {
                                    GuiControl, Main:Focus, LV2
                                    SendInput, {Home}
                                    Loop, % A_Index - 1
                                        SendInput, {Down}
                                    Break
                                }
                            }
                        }
                        EditMod[1] := 0
                    } Else {
                        Loop, % LV_GetCount() {
                            LV_GetText(ThisBar, A_Index, 1)
                            If (ThisBar = Dbc) {
                                GuiControl, Main:Focus, LV2
                                SendInput, {Home}
                                Loop, % A_Index - 1
                                    SendInput, {Down}
                                Break
                            }
                        }
                    }
                    GuiControl, Main:Focus, LV2
                }
                GuiControl, Main:Enabled, Dbc
                GuiControl, Main:Enabled, Dnm
                GuiControl, Main:Enabled, Dbp
                GuiControl, Main:Enabled, Dsp
            }
        } Else If (RMS = "#4") {
            GuiControlGet, ThisFocus, Main:FocusV
            If (ThisFocus = "Pnm")
                Return
            Loop, % LV_GetCount() {
                LV_GetText(Tbc, A_Index, 1), LV_GetText(Tqn, A_Index, 3)
                ProdDefs["" Tbc ""][4] := Tqn
            }
            UpdateProdDefs()
            ;If (!DStatistic) {
            ;    If (ThisFocus = "Pnm") {
            ;        If (Pnm != "") && (ProdDefs["" Pnm ""][1]) {
            ;            Loop, % LV_GetCount() {
            ;                LV_GetText(ThisBc, A_Index, 1)
            ;                If (ThisBc = Pnm) {
            ;                    LV_Modify(A_Index, "Select")
            ;                    GuiControl, Main:Focus, LV3
            ;                    SendInput, {Home}
            ;                    Loop, % A_Index - 1
            ;                        SendInput, {Down}
            ;                    Gosub, DisplayQn
            ;                    Break
            ;                }
            ;            }
            ;        }
            ;    } Else If (ThisFocus = "Pqn") {
            ;        If (Pnm != "") && (Pqn != "") {
            ;            If Pqn is Digit
            ;            {
            ;                LV_GetText(BcId, Row, 1)
            ;                ProdDefs["" BcId ""][4] := Pqn
            ;                DB_Write(ThisN := "Stoc\" A_Now ".db", NowCh := BcId "|" Pqn "|" ProdDefs["" BcId ""][5])
            ;                LV_Modify(Row,,,, Pqn)

            ;                LoadStockChanges(ThisN)

            ;                If (ProdDefs["" BcId ""][5]) {
            ;                    OtherStc := ""
            ;                    For Other, Bcs in StrSplit(ProdDefs["" BcId ""][5], "/") {
            ;                        ProdDefs["" Bcs ""][4] := Pqn
            ;                        OtherStc .= Bcs "|" Pqn "."
            ;                    }
            ;                }
            ;                UpdateProdDefs()
            ;                LoadStockList()
            ;            }
            ;        }
            ;    }
            ;} Else If (ThisFocus = "Pnm") {
            ;    Loop, % LV_GetCount() {
            ;        LV_GetText(ThisBc, A_Index, 1)
            ;        If (ThisBc = Pnm) {
            ;            LV_Modify(A_Index, "Select")
            ;            GuiControl, Main:Focus, LV3
            ;            Break
            ;        }
            ;    }
            ;}
        } Else If (RMS = "#5") {
            LoadProf()
        } Else If (RMS = "#6") {
            If (UserName) && (UserPass) {
                If (UserName ~= ";|\||\/") {
                    ShakeControl("Main", UserName)
                    Return
                }
                If (UserPass ~= ";|\||\/") {
                    ShakeControl("Main", UserPass)
                    Return
                }
                If !InStr(CollectData := DB_Read("Sets\Lc.lic"), ";" UserName "/") {
                    DB_Write("Sets\Lc.lic", CollectData ";" UserName "/" UserPass)
                    LoadAccounts()
                }
            }
        } Else If (RMS = "#7") {
            If !InStr(KLB, "|") {
                FileRemoveDir, % "Kr\" ThisKLB, 1
            }
            GuiControl, Main:, GivenMoney
            GuiControl, Main:, AllSum
            GuiControl, Main:, Change
            GuiControl, Main:Hide, GivenMoney
            GuiControl, Main:Hide, AllSum
            GuiControl, Main:Hide, Change
            LoadKridis()
        } Else {
            SendInput, {Enter}
        }
    } Else If WinActive("ahk_id " Kr) {
        Gui, Kridi:Submit, NoHide
        If (KName ~= "[^A-Za-z0-9 ]") || (!KName) {
            ShakeControl("Kridi", KName)
            GuiControl, Kridi:Focus, KName
        } Else {
            Gui, Main:Default
            DB_Write(_This := "Curr\" A_Now ".db", TP "|" Sum_Data[2])

            Arr := StrSplit(Trim(StrSplit(Sum_Data[2], "> ")[2], "|"), "|")
            For Each, SO in Arr {
                ThisArr := StrSplit(SO, ";")
                ThisBc := ThisArr[1]
                ThisQn := StrSplit(ThisArr[3], "x")[2]
                ProdDefs["" ThisBc ""][4] := ProdDefs["" ThisBc ""][4] - ThisQn
                If (ProdDefs["" ThisBc ""][5]) {
                    For Other, Bcs in StrSplit(ProdDefs["" ThisBc ""][5], "/") {
                        ProdDefs["" Bcs ""][4] := ProdDefs["" Bcs ""][4] - ThisQn
                    }
                }
            }
            UpdateProdDefs()
            GuiControl, Main:, AllSum
            GuiControl, Main:, Change
            GuiControl, Main:Hide, GivenMoney
            GuiControl, Main:Hide, AllSum
            GuiControl, Main:Hide, Change
            GuiControl, Main:Show, Bc
            GuiControl, Main:Show, Nm
            GuiControl, Main:Show, Qn
            GuiControl, Main:Show, Sum
            GuiControl, Main:Show, AddEnter
            GuiControl, Main:Hide, SubKridi
            GuiControl, Main:, Bc
            GuiControl, Main:, Nm
            GuiControl, Main:, Qn
            GuiControl, Main:, Sum
            LV_Delete()
            If FileExist("Dump\" SessionID ".db")
                FileDelete, % "Dump\" SessionID ".db"
            GuiControl, Main:, GivenMoney

            EncVal := EncodeAlpha(KName)
            If !InStr(FileExist("Kr\" EncVal), "D") {
                FileCreateDir, % "Kr\" EncVal
            }
            FileCopy, % _This, % "Kr\" EncVal
            GuiControl, Kridi:, KName
            Gui, Kridi:Hide
            CheckListSum()
            GuiControl, Main:Enabled, Bc
            GuiControl, Main:Focus, Bc
        }
    }
    Sleep, 125
Return

Up::
    Gui, Main:Submit, NoHide
    Gui, Main:Default
    If (RMS = "#1") {
        GuiControlGet, Focused, Main:FocusV
        If (Focused = "LV0") {
            Row := LV_GetNext()
            If (Row) {
                LV_GetText(ThisQn, Row, 4)
                LV_GetText(ThisBc, Row, 1)
                VQ := StrSplit(ThisQn, "x")
                LV_Modify(Row,,, ProdDefs["" ThisBc ""][4] " --> " ProdDefs["" ThisBc ""][4] - (VQ[2] + 1),, VQ[1] "x" VQ[2] + 1, VQ[1] * (VQ[2] + 1))
                
            }
        } Else {
            If (LastR := LV_GetCount()) {
                LV_GetText(ThisQn, LastR, 4)
                LV_GetText(ThisBc, LastR, 1)
                VQ := StrSplit(ThisQn, "x")
                LV_Modify(LastR,,, ProdDefs["" ThisBc ""][4] " --> " ProdDefs["" ThisBc ""][4] - (VQ[2] + 1),, VQ[1] "x" VQ[2] + 1, VQ[1] * (VQ[2] + 1))    
            }
        }
        CreateNew("Bc", "LV0")
        CheckListSum()
    } Else If (RMS = "#4") {
        GuiControlGet, Focused, Main:FocusV
        If (Focused = "LV3") && (Psum) {
            If (Row := LV_GetNext()) {
                LV_GetText(STqn, Row, 3), LV_GetText(Tbc, Row, 1)
                LV_Modify(Row,,,, STqn += Psum)
                If (ProdDefs["" Tbc ""][5] != "") {
                    For oth, ers in StrSplit(ProdDefs["" Tbc ""][5], "/") {
                        ProdDefs["" ers ""][4] := STqn
                        LV_Modify(RowsArr["" ers ""][1],,,, STqn)
                    }
                }
            }
        }
    } Else {
        SendInput, {Up}
    }
    Sleep, 125
Return

Down::
    Gui, Main:Submit, NoHide
    Gui, Main:Default
    If (RMS = "#1") {
        GuiControlGet, Focused, Main:FocusV
        If (Focused = "LV0") {
            Row := LV_GetNext()
            If (Row) {
                LV_GetText(ThisQn, Row, 4)
                LV_GetText(ThisBc, Row, 1)
                VQ := StrSplit(ThisQn, "x")
                If (VQ[2] > 1) {
                    LV_Modify(Row,,, ProdDefs["" ThisBc ""][4] " --> " ProdDefs["" ThisBc ""][4] - (VQ[2] - 1),, VQ[1] "x" VQ[2] - 1, VQ[1] * (VQ[2] - 1))
                }
            }
        } Else {
            If (LastR := LV_GetCount()) {
                LV_GetText(ThisQn, LastR, 4)
                LV_GetText(ThisBc, LastR, 1)
                VQ := StrSplit(ThisQn, "x")
                If (VQ[2] > 1) {
                    LV_Modify(LastR,,, ProdDefs["" ThisBc ""][4] " --> " ProdDefs["" ThisBc ""][4] - (VQ[2] - 1),, VQ[1] "x" VQ[2] - 1, VQ[1] * (VQ[2] - 1))
                }
            }
        }
        CreateNew("Bc", "LV0")
        CheckListSum()
    } Else If (RMS = "#4") {
        GuiControlGet, Focused, Main:FocusV
        If (Focused = "LV3") && (Psum) {
            If (Row := LV_GetNext()) {
                LV_GetText(STqn, Row, 3), LV_GetText(Tbc, Row, 1)
                LV_Modify(Row,,,, STqn -= Psum)
                If (ProdDefs["" Tbc ""][5] != "") {
                    For oth, ers in StrSplit(ProdDefs["" Tbc ""][5], "/") {
                        ProdDefs["" ers ""][4] := Psum
                        LV_Modify(RowsArr["" ers ""][1],,,, STqn)
                    }
                }
            }
        }
    } Else {
        SendInput, {Down}
    }
    Sleep, 125
Return

Delete::
    Gui, Main:Default
    Gui, Main:Submit, NoHide
    If (RMS = "#1") {
        LV_Delete(LV_GetNext())
        CreateNew("Bc", "LV0")
        CheckListSum()
    } Else If (RMS = "#3") {
        LV_GetText(ThisID, LV_GetNext(), 1)
        ProdDefs.Delete("" ThisID "")
        UpdateProdDefs()
        LV_Delete(LV_GetNext())
    } Else If (RMS = "#6") {
        LV_GetText(Name, Row := LV_GetNext(), 1)
        LV_GetText(Pass, Row, 2)
        If InStr(US := DB_Read("Sets\Lc.lic"), Name "/" Pass) {
            DB_Write("Sets\Lc.lic", StrReplace(US, ";" Name "/" Pass))
        }
        LoadAccounts()
    } Else {
        SendInput, {Delete}
    }
    Sleep, 125
Return

Space::
    Gui, Main:Submit, NoHide
    Gui, Main:Default
    If (RMS = "#1") {
        LV_GetText(Bcc, 1, 1)
        If (Bcc) {
            GuiControl, Main:Hide, Bc
            GuiControl, Main:Hide, Nm
            GuiControl, Main:Hide, Qn
            GuiControl, Main:Hide, Sum
            GuiControl, Main:Hide, AddEnter
            GuiControl, Main:Show, SubKridi
            GuiControl, Main:Show, GivenMoney
            GuiControl, Main:Show, AllSum
            GuiControl, Main:Show, Change
            GuiControl, Main:, AllSum, % (Sum_Data := CalculateSum())[1]
            GuiControl, Main:Focus, GivenMoney
        }
        CheckListSum()
    } Else If (RMS = "#4") {
        ;DStatistic := !DStatistic
        ;GoSub, MainGuiSize
        ;If (DStatistic) {
        ;    ThisLoaded := ""
        ;    Loop, Parse, % "Pqn,PSum,StockSum,$Add,$Sub", `,
        ;    {
        ;        If InStr(A_LoopField, "$") {
        ;            GuiControl, Main:Show, % SubStr(A_LoopField, 2)
        ;        } Else {
        ;            GuiControl, Main:Hide, % A_LoopField
        ;        }
        ;    }
        ;} Else {
        ;    Loop, Parse, % "Pqn,PSum,StockSum,$Add,$Sub", `,
        ;    {
        ;        If InStr(A_LoopField, "$") {
        ;            GuiControl, Main:Hide, % SubStr(A_LoopField, 2)
        ;        } Else {
        ;            GuiControl, Main:Show, % A_LoopField
        ;        }
        ;    }
        ;}
        
    } Else If (RMS = "#7") {
        LV_GetText(Bcc, 1, 1)
        If (Bcc) && !InStr(KLB, "|") {
            GuiControl, Main:Show, GivenMoney
            GuiControl, Main:Show, AllSum
            GuiControl, Main:Show, Change
            GuiControl, Main:, AllSum, % (Sum_Data := CalculateSum())[1]
            GuiControl, Main:Focus, GivenMoney
        }
        CheckListSum()
    } Else {
        SendInput, {Space}
    }
    Sleep, 125
Return

^W::
    DB_Write(A_Desktop "\genFILE.db", Clipboard)
    Sleep, 125
Return

^F::
    If (RMS = "#1") {
        Gui, Main:Submit, NoHide
        Gui, Main:Default
        Lst := ""
        For Every, One in ProdDefs {
            If InStr(One[1], Bc)
                (A_Index = 1) ? Lst .= One[1] " [" Every "]||" : Lst .= One[1] " [" Every "]|"
        }
        Lst := Trim(Lst, "|")
        If (Lst) {
            GuiControl, Main:, CB, % "|" Lst
            GuiControl, Main:Focus, CB
            GuiControl, Main:Show, CB
            GuiControl, Main:Choose, CB, 1
        }
    } Else If (RMS = "#3") {
        Gui, Main:Submit, NoHide
        Gui, Main:Default
        LoadDefined()
    } Else {
        SendInput, ^F
    }
    Sleep, 125
Return
#If

AnalyzeAvail:
    Gui, Main:Submit, NoHide
    GuiControl, Main:Hide, CB
    GuiControl, Main:, Nm
    GuiControl, Main:, Sum
    GuiControl, Main:, Qn
    If (Bc) && (ProdDefs["" Bc ""][1] != "") {
        GuiControl, Main:, Nm, % ProdDefs["" Bc ""][1]
        GuiControl, Main:, Qn, % ProdDefs["" Bc ""][4]
        GuiControl, Main:, Sum, % ProdDefs["" Bc ""][3]
    }
Return
AnalyzeQn:
    Gui, Main:Submit, NoHide
    Value_Qn := StrSplit(Qn, "x")
    If (Value_Qn[1]) && (Value_Qn[2]) {
        GuiControl, Main:, Sum, % Value_Qn[1] * Value_Qn[2]
    }
Return
QuitMain:
    Gui, Main:Destroy
Return
QuitDefiner:
    Gui, Def:Destroy
Return
MainGuiClose:
    If (MM) {
        SetTimer, About, 0
        Gui, About:Show
        Loop, Parse, % "OpenMain,Submit,Define,Prof,Stockpile,Manage,Kridi", `,
            GuiControl, Main:Show, %A_LoopField%

        If (Level = "User") {
            Loop, Parse, % "Submit,Define,Prof,Stockpile,Manage,Kridi", `,
            {
                GuiControlGet, Enb, Main:Enabled, % A_LoopField
                If (Enb) {
                    GuiControl, Main:Disabled, % A_LoopField
                }
                GuiControlGet, Visi, Main:Visible, % A_LoopField
                If (Visi) {
                    GuiControl, Main:Hide, % A_LoopField
                }
            }
        }

        OnMessage(0, "MouseHover")

        Loop, Parse, % "1243567"
            GuiControl, Main:Hide, Btn%A_LoopField%

        Loop, Parse, % MainCtrlList "," EnsureCtrlList "," DefineCtrlList "," ProfitCtrlList "," StockPileCtrlList "," ManageCtrlList "," KridiCtrlList, `,
            GuiControl, Main:Hide, % StrReplace(A_LoopField, "$")

        SetTimer, Update, Off
        
        MM := !MM
        RMS := "#0.1"
        Gui, Main:-Resize -MinSize1000x500
        Gui, Main:Show, % "w800 h400 Center"
        Return
    }
Quit:
;SaveLogOut()
ExitApp

LoadCurrent() {
    global UsersSells := {}
    LV_Delete()
    OAPr := SPr := CP := 0
    GuiControl, Main:, ProfitEq, % OAPr
    GuiControl, Main:, Sold, % SPr
    GuiControl, Main:, Bought, % CP
    GuiControl, Main:, Currents, |
    GuiControl, Main:, Currents, All||
    Loop, Files, Curr\*.db
    {
        If (RD := DB_Read(A_LoopFileFullPath)) {
            Arr := CalcProfit(RD)
            If (RMS = "#2") {
                LV_Add("", A_LoopFileFullPath, Arr[1] ":    " Arr[4])
                ND := StrSplit(Arr[1], "|")
                If (ND.Length() = 2) {

                    If !UsersSells[ND[1]][1] {
                        GuiControl, Main:, Currents, % ND[1]
                        UsersSells[ND[1]] := [1, 0, 0, 0]
                    }
                    UsersSells[ND[1] "_" A_Index] := [A_LoopFileFullPath, Arr[1] ":    " Arr[4]]
                    UsersSells[ND[1]][2] += Arr[2][2]
                    UsersSells[ND[1]][3] += Arr[2][3]
                    UsersSells[ND[1]][4] += Arr[2][1]
                } Else {
                    UsersSells["_" A_Index] := [A_LoopFileFullPath, Arr[1] ":    " Arr[4]]
                    UsersSells["_"][2] += Arr[2][2]
                    UsersSells["_"][3] += Arr[2][3]
                    UsersSells["_"][4] += Arr[2][1]
                }
            } Else {
                Return
            }
            SPr += Arr[2][1]
            CP += Arr[2][2]
            OAPr += Arr[2][3]
        }
    }

    UsersSells["All"] := [1, CP, OAPr, SPr]

    If !LV_GetCount() {
        GuiControl, Main:Disabled, EnsBtn
    } Else {
        GuiControl, Main:, ProfitEq, % "+ " OAPr " " ConvertMillimsToDT(OAPr, "+")
        GuiControl, Main:, Sold, % "+ " SPr " " ConvertMillimsToDT(SPr, "+")
        GuiControl, Main:, Bought, % "- " CP " " ConvertMillimsToDT(CP, "-")
    }
}
GetBuyPriceByID(Data, TID) {
    Loop, Parse, Data, |
    {
        If (SubStr(A_LoopField, 1, InStr(A_LoopField, ";") - 1) = TID) {
            Return, StrSplit(A_LoopField, ";")[3]
    }
}
    Return, 0
}
CalcProfit(PData) {
    TrArr := StrSplit(PData, "> ")
    TimeDT := TrArr[1]
    RArr := StrSplit(TrArr[3], ";")
    Items := 0, Names := ""
    For Each, One in StrSplit(Trim(TrArr[2], "|"), "|") {
        Vals := StrSplit(One, ";")
        Items += StrSplit(Vals[3], "x")[2]
        Names .= (Names) ? "  :::  " Vals[2] : Vals[2]
    }
    Return, [TimeDT, [RArr[1], RArr[2], RArr[3]], Items, Names]
}
Correct(File) {
    RD := DB_Read(File)
    Arr := StrSplit(RD, "> ")
    _DDS := StrSplit(Trim(Arr[2], "|"), "|")
    
    NC := "", SP := BP := OA := 0

    For Each, SO in _DDS {
        DDS := StrSplit(SO, ";")
        Bc := DDS[1]

        If (ProdDefs["" Bc ""][1]) {
            Qn := StrSplit(DDS[3], "x")[2]
                        
            SP += ProdDefs["" Bc ""][3] * Qn
            BP += ProdDefs["" Bc ""][2] * Qn

            NC .= Bc ";" ProdDefs["" Bc ""][1] ";" ProdDefs["" Bc ""][3] "x" Qn ";" SP ";" ProdDefs["" Bc ""][2] "x" Qn ";" BP ";" SP - BP "|"

            OA += SP - BP
        }
    }
    DB_Write(A_LoopFileFullPath, Arr[1] "> " NC "> " SP ";" BP ";" OA)
}

LoadProf() {
    LV_Delete()
    OAPr := 0, SPr := 0, CP := 0
    GuiControl, Main:, OAProfit, % OAPr
    GuiControl, Main:, SPr, % SPr
    GuiControl, Main:, CPr, % CP
    
    Global Today, Yesterday
    ;Msgbox % Today "," Yesterday
    Range := 0, SysOBJ := ComObjCreate("Scripting.FileSystemObject")
    Loop, Files, Valid\*, D 
    {
        If (RMS = "#5") {
            Range += SysOBJ.GetFolder(A_LoopFileFullPath).Files.Count
        } Else {
            Return
        }
    }
    Range += SysOBJ.GetFolder("Curr").Files.Count

    GuiControl, Main:Show, PB
    GuiControl, Main:, PB, 0
    GuiControl, Main:+Range0-%Range%, PB
    ByName := {}

    Loop, Files, Valid\*.db, R F
    {
        ThisFileDate := SubStr(A_LoopFileName, 1, StrLen(A_LoopFileName) - 3)
        If (ThisFileDate >= Yesterday) && (ThisFileDate <= Today) {
            If (RD := DB_Read(A_LoopFileFullPath, 1)) {
                Arr := CalcProfit(RD)
                If (!Arr[2][1]) || (!Arr[2][1]) || (!Arr[2][3]) {
                    MsgBox, 64, % A_LoopFileFullPath, % "Corrupted file: " A_LoopFileFullPath " `n" ClipBoard := RD
                } Else {
                    If (RMS = "#5") {
                        LV_Add("", A_LoopFileFullPath, Arr[1], "+ " Arr[2][1] "  " ConvertMillimsToDT(Arr[2][1], "+")
                                                             , "- " Arr[2][2] "  " ConvertMillimsToDT(Arr[2][2], "-")
                                                             , "+ " Arr[2][3] "  " ConvertMillimsToDT(Arr[2][3], "+"))
                    } Else {
                        Return
                    }
                    SPr := Arr[2][1] + SPr
                    CP := Arr[2][2] + CP
                    OAPr := Arr[2][3] + OAPr
                }
            }
        }
        GuiControl, Main:, PB, +1
    }
    Loop, Files, Curr\*.db
    {
        ThisFileDate := SubStr(A_LoopFileName, 1, StrLen(A_LoopFileName) - 3)
        If (ThisFileDate >= Yesterday) && (ThisFileDate <= Today) {
            If (RD := DB_Read(A_LoopFileFullPath, 1)) {
                Arr := CalcProfit(RD)
                If (RMS = "#5") {
                    LV_Add("", A_LoopFileFullPath, Arr[1], "+ " Arr[2][1] "  " ConvertMillimsToDT(Arr[2][1], "+")
                                                         , "- " Arr[2][2] "  " ConvertMillimsToDT(Arr[2][2], "-")
                                                         , "+ " Arr[2][3] "  " ConvertMillimsToDT(Arr[2][3], "+"))
                } Else {
                    Return
                }
                SPr := Arr[2][1] + SPr
                CP := Arr[2][2] + CP
                OAPr := Arr[2][3] + OAPr
            }
        }
        GuiControl, Main:, PB, +1
    }
    GuiControl, Main:Hide, PB
    GuiControl, Main:, OAProfit, % OAPr " " ConvertMillimsToDT(OAPr)
    GuiControl, Main:, SPr, % SPr  " " ConvertMillimsToDT(SPr)
    GuiControl, Main:, CPr, % CP  " " ConvertMillimsToDT(CP)
}

ConvertMillimsToDT(Value, Sign := "") {
    If (Value = "...")
        Return
    ValueArr := StrSplit(Value / 1000, ".")
    Return, "(" (Sign ? " " Sign " " : "") ValueArr[1] (ValueArr[2] ? "." RTrim(ValueArr[2], 0) : "") " DT)"
}

LoadDefined() {
    global ProdDefs, RowsArr, Dbc, Dnm, Dbp, Dsp
    LV_Delete()
    AllItems := ""
    For Each, Item in ProdDefs {
        AllItems .= Each ","
    }
    Sort, AllItems, N D,
    RowsArr := {}, Counted := 0
    Loop, Parse, % Trim(AllItems, ","), `,
    {
        If (RMS = "#3") {
            If InStr(A_LoopField, Dbc) && InStr(ProdDefs["" A_LoopField ""][1], Dnm) && InStr(ProdDefs["" A_LoopField ""][2], Dbp) && InStr(ProdDefs["" A_LoopField ""][3], Dsp) {
                RowsArr["" A_LoopField ""] := [Counted += 1]
                LV_Add("", A_LoopField, Counted " | " ProdDefs["" A_LoopField ""][1], ProdDefs["" A_LoopField ""][2], ProdDefs["" A_LoopField ""][3])
            }
        } Else {
            Return
        }
    }
    LoadPrevPD()

}
LoadStockList() {
    global
    LV_Delete()
    AllItems := ""
    For Each, Item in ProdDefs {
        AllItems .= Each ","
    }
    Sort, AllItems, N D,
    Counted := OverAll := 0
    Skipped := "", RowsArr := {}
    Loop, Parse, % Trim(AllItems, ","), `,
    {
        If (Pnm) && !InStr(A_LoopField, Pnm) {
            Continue
        }
        If ValidPro(A_LoopField, ProdDefs["" A_LoopField ""][1], ProdDefs["" A_LoopField ""][2], ProdDefs["" A_LoopField ""][3]) {
            If (RMS = "#4") {
                ProdDefs["" A_LoopField ""][4] := (ProdDefs["" A_LoopField ""][4]) ? ProdDefs["" A_LoopField ""][4] : 0
                LV_Add("", A_LoopField, A_Index " | " ProdDefs["" A_LoopField ""][1], ProdDefs["" A_LoopField ""][4])
                SumArg := ProdDefs["" A_LoopField ""][4] "x" ProdDefs["" A_LoopField ""][2] " = " (Value := ProdDefs["" A_LoopField ""][4] * ProdDefs["" A_LoopField ""][2])
            } Else {
                Return
            }
            Sk := 0
            (!InStr(Skipped, "/" A_LoopField "/")) ? OverAll += Value : Sk := 1

            (ProdDefs["" A_LoopField ""][5]) ? Skipped .= "/" ProdDefs["" A_LoopField ""][5] "/"
            
            RowsArr["" A_LoopField ""] := [Counted += 1, Sk ? "-" : SumArg, (!Sk) ? OverAll " " ConvertMillimsToDT(OverAll) : "-"]
        }
    }
    RowsArr["OverAll"] := OverAll
}
ValidPro(_1, _2, _3, _4) {
    Rs := 1
    If (_1 = "") || (_2 = "") || (_3 _4 ~= "[^0-9]")
        Rs := 0
    Return, Rs
}
LoadInterfaceLng() {
    global
    If FileExist("AddLng.SETTING") {
        Loop, Read, AddLng.SETTING 
        {
            VFSK := StrSplit(A_LoopReadLine, ",")
            IniWrite, % VFSK[1], Setting.ini, % VFSK[2], % VFSK[3]
        }
        FileDelete, AddLng.SETTING
    }
    IniRead, LngSection, Setting.ini, UseLng, Use
    IniRead, StrList, Setting.ini, %LngSection%
    Loop, Parse, StrList, `n, `r
    {
        ID_Val := StrSplit(A_LoopField, "=")
        ID := ID_Val[1], Val := ID_Val[2]
        _%ID% := Val
    }
}
Version() {
    IniRead, Version, Setting.ini, Version, AppVer
Return, Version
}

UUID() {
    For obj in ComObjGet("winmgmts:{impersonationLevel=impersonate}!\\" . A_ComputerName . "\root\cimv2").ExecQuery("Select * From Win32_ComputerSystemProduct")
        return, obj.UUID
}
Encode(string) {
    VarSetCapacity(bin, StrPut(string, "UTF-8")) && len := StrPut(string, &bin, "UTF-8") - 1
    if !(DllCall("crypt32\CryptBinaryToString", "ptr", &bin, "uint", len, "uint", 0x1, "ptr", 0, "uint*", size))
        Return
    VarSetCapacity(buf, size << 1, 0)
    if !(DllCall("crypt32\CryptBinaryToString", "ptr", &bin, "uint", len, "uint", 0x1, "ptr", &buf, "uint*", size))
        Return
return, StrGet(&buf)
}
Decode(string) {
    if !(DllCall("crypt32\CryptStringToBinary", "ptr", &string, "uint", 0, "uint", 0x1, "ptr", 0, "uint*", size, "ptr", 0, "ptr", 0))
        Return
    VarSetCapacity(buf, size, 0)
    if !(DllCall("crypt32\CryptStringToBinary", "ptr", &string, "uint", 0, "uint", 0x1, "ptr", &buf, "uint*", size, "ptr", 0, "ptr", 0))
        Return
return, StrGet(&buf, size, "UTF-8")
}
ShakeControl(GUINm, ControlID) {
    GuiControlGet, GotPos, %GUINm%:Pos, %ControlID%
    GuiControl, %GUINm%: Move, %ControlID%, % "x" GotPosX - 1
    Loop, 10 {
        GuiControl, %GUINm%: Move, %ControlID%, % "x" GotPosX + 2
        Sleep, 25
        GuiControl, %GUINm%: Move, %ControlID%, % "x" GotPosX - 2
        Sleep, 25
    }
    GuiControl, %GUINm%: Move, %ControlID%, % "x" GotPosX
}
CalculateSum() {
    global
    Cost := Sum := 0
    FormatTime, OutTime, % A_Now, yyyy/MM/dd HH:mm:ss
    Data := OutTime "> "

    Loop, % LV_GetCount() {
        LV_GetText(Qn, A_Index, 4)
        If (!Qn) {
            Continue
        }
        LV_GetText(ThisSum, A_Index, 5)
        Sum += ThisSum
        LV_GetText(Bc, A_Index, 1)
        LV_GetText(Nm, A_Index, 3)
        
        BP := ProdDefs["" Bc ""][2]
        Qn_ := SubStr(Qn, InStr(Qn, "x") + 1)
        ThisCost := BP * Qn_
        Cost += ThisCost
        Data .= Bc ";" Nm ";" Qn ";" ThisSum ";" BP "x" Qn_ ";" ThisCost ";" ThisSum - ThisCost "|"
    }
    
    Data .= "> " Sum ";" Cost ";" Sum - Cost
    Return, [Sum, Trim(Data, "|"), OutTime]
}
DB_Write(FileName, Info) {
    Global RMS
    SetTimer, Update, Off
    If InStr(FileName, "\PD.db") && (RMS = "#3" || RMS = "#4") {
        FileCopy, % FileName, % "Sets\Bu\" A_Now ".Bu"
    }
    DBObj := FileOpen(FileName, "w")
    Loop, Parse, % "CH-26259084-DB"
        DBObj.WriteChar(Asc(A_LoopField))
    Loop, 1010
        DBObj.WriteChar(0)
    Loop, Parse, % Encode(Info)
        DBObj.WriteChar(Asc(A_LoopField))
    Loop, 1024
        DBObj.WriteChar(0)
    DBObj.Close()
    SetTimer, Update, On
}
DB_Read(FileName, FastMode := 0) {
    SetTimer, Update, Off
    DBObj := FileOpen(FileName, "r")
    If !(FastMode) {
        Hedr := ""
        Loop, 14 {
            Hedr .= Chr(DBObj.ReadChar())
        }
        If (Hedr != "CH-26259084-DB")
            Return, 0
        Info := ""
        DBObj.Pos := 1024
        Loop {
            Info .= (ThisChar := Chr(DBObj.ReadChar()))
        } Until (ThisChar = "")
    } Else {
        DBObj.RawRead(Data, Len := DBObj.Length())
        Pos := 1023, Info := ""
        While (Byte := NumGet(Data, Pos += 1, "Char")) {
            Info .= Chr(Byte)
        }
        DBObj.Close()
    }
    SetTimer, Update, On
    Return, Decode(Info)
}


Hide(ListCtrl) {
    Loop, Parse, ListCtrl, `,
        GuiControl, Main:Hide, % StrReplace(A_LoopField, "$")
}
Show(ListCtrl) {
    Loaded := 0
    Loop, Parse, ListCtrl, `,
    {
        If !InStr(A_LoopField, "$")
            GuiControl, Main:Show, % A_LoopField
    }
    Loaded := 1
}
CheckLicense() {
    If !FileExist("Sets\Lc.lic")
        Return, 0
    LC := DB_Read("Sets\Lc.lic")
    LC := StrSplit(LC, ";")
    If (UUID() != LC[1])
        Return, 0
Return, 1
}
CheckFoldersSet() {
    Folders := "Curr,Lib,Sets,Sets\Bu,Stoc,Valid,Dump,Kr,Log,Loads"
    Loop, Parse, Folders, `,
    {
        If !InStr(FileExist(A_LoopField), "D") {
            FileCreateDir, % A_LoopField
        }
    }
}
LoadBackground() {
    global
    If FileExist("Img\Prt4_199x10_4x430.png")
        FileDelete, Img\Prt4_199x10_4x430.png
    Loop, Files, % "Img\Prt*.png"
    {
        Name := SubStr(A_LoopFileName, 1, StrLen(A_LoopFileName) - 4)
        Set := StrSplit(Name, "_")
        PosArr := StrSplit(Set[2], "x")
        DemArr := StrSplit(Set[3], "x")
        Gui, Main:Add, Picture, % "x" PosArr[1] " y" PosArr[2] " w" DemArr[1] " h" DemArr[2] " v" Set[1], % "Img\" A_LoopFileName
    }
}
RemoveFromStock(BC, QN) {
    ProdDefs["" BC ""][4] := ProdDefs["" BC ""][4] - QN
    UpdateProdDefs()
}
RandomHexColor() {
    global
    Frag := Seq := ""
    Loop, 3 {
        Random, Bol, 0, 1
        If (Bol) {
            Random, Int, 0, 9
            Random, Bol, 0, 1
            If (Bol) {
                Random, AInt, 1, 6
                Random, Bol, 0, 1
                If (Bol)
                    Frag := Int Table[AInt]
                Else
                    Frag := Table[AInt] Int
            } Else {
                Random, _Int, 0, 9
                Random, Bol, 0, 1
                If (Bol)
                    Frag := Int _Int
                Else
                    Frag := _Int Int
            }
        } Else {
            Random, AInt, 1, 6
            Random, Bol, 0, 1
            If (Bol) {
                Random, Int, 1, 6
                Random, Bol, 0, 1
                If (Bol)
                    Frag := Int Table[AInt]
                Else
                    Frag := Table[AInt] Int
            } Else {
                Random, _AInt, 1, 6
                Random, Bol, 0, 1
                If (Bol)
                    Frag := AInt _AInt
                Else
                    Frag := _AInt AInt
            }
        }
        Seq .= Frag
    }
    Return, Seq
}
CreateNew(Controls, LV := "", Clear := 0) {
    global
    Gui, Main:Default
    Gui, Main:ListView, LV0
    List_ := ""
    Loop, Parse, Controls, `,
    {
        GuiControlGet, Content, Main:, % A_LoopField
        List_ .= A_LoopField "=" Content ";"
    }
    LV_ := "|"
    If (LV) {
        Loop, % LV_GetCount() {
            LV_GetText(Bc__, A_Index, 1)
            LV_GetText(QnBA__, A_Index, 2)
            LV_GetText(Nm__, A_Index, 3)
            LV_GetText(Qn__, A_Index, 4)
            LV_GetText(Sum__, A_Index, 5)
            LV_ .= Bc__ "/" QnBA__ "/" Nm__ "/" Qn__ "/" Sum__ "|"
        }
    }
    If (LV_ = "|")
        LV_ := ""
    If (SessionID)
        DB_Write("Dump\" SessionID ".db", Trim(List_, ";") LV_)
    If (Clear) {
        LV_Delete()
        Loop, Parse, Controls, `,
        {
            If (A_LoopField != "Qn")
                GuiControl, Main:, % A_LoopField
            Else
                GuiControl, Main:, % A_LoopField, % "x1"
        }
    }
}
RestoreSession(Data) {
    global
    Gui, Main:Default
    ArrayData := StrSplit(Data, ";")
    LV_Delete()
    For Each, Item in ArrayData {
        If !InStr(Item, "|") {
            CtlVal := StrSplit(Item, "=")
            GuiControl, Main:, % CtlVal[1], % CtlVal[2]
        } Else {
            Loop, Parse, % Trim(Item, "|"), |
            {
                If (A_Index > 1) {
                    CtlVals := StrSplit(A_LoopField, "/")
                    If (RMS = "#1") {
                        LV_Add("", CtlVals[1], CtlVals[2], CtlVals[3], CtlVals[4], CtlVals[5])
                    } Else {
                        Return
                    }
                    
                }
            }
        }
    }
    CheckListSum()
}
LoadDefinitions(Data) {
    Tmp := {}
    ;Msgbox % Data
    Loop, Parse, % Trim(Data, "|"), |
    {
        ThisDef := StrSplit(A_LoopField, ";")
        If (ThisDef.Length() >= 4) {
            Tmp["" ThisDef[1] ""] := [ThisDef[2], ThisDef[3], ThisDef[4], ThisDef[5], ThisDef[6] ? ThisDef[6] : ""]
        }
    }
    Return, Tmp
}

Ready() {
    Global
    If (req.readyState != 4)
    Return
    If (req.status == 200) {
        Msgbox % Lastest := req.responseText
    }
}

CheckForUpdates() {
    global
    SetWorkingDir, Update
    UrlDownloadToFile, % "http://dl.dropboxusercontent.com/s/afgulp0atp0lnuz/Version.txt", Version.txt
    Ver_Link := ""
    FileRead, Ver_Link, Version.txt
    Ver_Link := StrSplit(Trim(Ver_Link, """"), "|")
    Lastest := ""
    Lastest := Ver_Link[1], DL := Ver_Link[2]
    If (!Lastest)
        Return, _49
    FileDelete, Version.txt
    SetWorkingDir, % A_ScriptDir
    If !InStr(Lastest, ".")
        Lastest := Lastest ".0"
    If (Lastest > (Ver := Version())) {
        MsgBox, 36, % Lastest " " _50 , % _51 " " Lastest "?"
        IfMsgBox, Yes
        {
            Progress, w400 FS10 ZH18, % _47, % _46, % "Cash Helper v" Ver, Calibri
            SetWorkingDir, Update
            DownloadFile(StrReplace(DL, "https://www.dropbox.com", "http://dl.dropboxusercontent.com"), "Cassier-Update.zip")
        } Else
            Return, "SUCCESS"
    } Else {
        MsgBox,,, % _45
    }
    SetWorkingDir, % A_ScriptDir
}

DownloadFile(URL, SaveFileAs := "", Overwrite := True, UseProgressBar := True) {
    global
    if !SaveFileAs {
        SplitPath, URL, SaveFileAs
        StringReplace, SaveFileAs, SaveFileAs, `%20, %A_Space%, All
    }
    If (!Overwrite && FileExist(SaveFileAs))
        Return
    If (UseProgressBar) {
        WebRequest := ComObjCreate("WinHttp.WinHttpRequest.5.1")
        WebRequest.Open("HEAD", URL)
        WebRequest.Send()
        FinalSize := WebRequest.GetResponseHeader("Content-Length")
        File := FileOpen(SaveFileAs, "rw")
        SetTimer, UpdateProgressBar, 1000
    }

    UrlDownloadToFile, % URL, % SaveFileAs

    If (UseProgressBar) {
        SetTimer, UpdateProgressBar, Off
        Progress, Off
    }

    File.Close()
    If FileExist("Dest.txt") {
        FileDelete, Dest.txt
        If (ErrorLevel)
            Return, _53
    }
    FileAppend, % A_ScriptDir, Dest.txt
    Run, Apply.exe
    ExitApp
}

CheckForUpdatesStat() {
    IniRead, Stat, Setting.ini, Update, Upt
    If (Stat = "ERROR")
        Stat := 0
    Return, Stat
}
MouseHover() {
    global
    If WinActive("ahk_id " Main) || WinActive("ahk_id " Info) || WinActive("ahk_id " StSum) {
        If (A_GuiControl ~= "LV1|LV4") {
            Gui, Main:ListView, % A_GuiControl
            If (RMS ~= "#2|#5") {
                If (Row := LV_GetNext()) {
                    If (!ShowTT) {
                        ShowToolTipGui()
                        ShowTT := 1
                    }
                    If (ThisLoaded != Row) {
                        LV_GetText(FileName, Row, 1)
                        RawData := StrSplit(DB_Read(FileName), "> ")[2]
                        Items := StrSplit(Trim(RawData, "|"), "|")
                        Result := "=====================================================================`n"
                        AllProf := 0
                        For Each, One in Items {
                            DI := StrSplit(Trim(One, ";"), ";")
                            Result .= " " _38 ": " DI[2] "`n " _39 ": " DI[3] "=" DI[4] "   " ConvertMillimsToDT(DI[4]) "`n " _40 ": " DI[5] "=" DI[6] "   " ConvertMillimsToDT(DI[6]) "`n " _41 ": " DI[7] "   " ConvertMillimsToDT(DI[7]) "`n=====================================================================`n"
                            AllProf := AllProf + DI[7]
                        }
                        Result .= "`n " _42 ": " AllProf "   " ConvertMillimsToDT(AllProf)
                        GuiControl, ReIn:, DInfo, % Result
                        ThisLoaded := Row
                    }
                    (!FixedToolTip) ? ShowToolTipGui()
                } ;Else If (ShowTT) {
                ;    Gui, ReIn:Hide
                ;    ShowTT := 0
                ;}
            }
                ;Else If (RMS ~= "#4|#3") {
                ;    If (Row := LV_GetNext()) {
                ;        LV_GetText(Barc, Row, 1)
                ;        If (ProdDefs["" Barc ""][5] != "") {
                ;            For other, s in StrSplit(ProdDefs["" Barc ""][5], "/") {
                ;                If (RowsArr["" s ""][1]) {
                ;                    LV_Modify(RowsArr["" s ""][1], "+Select")
                ;                }
                ;            }
                ;        }
                ;    }
                ;}
            ;} Else {
            ;    If (A_GuiControl = "LV1" || A_GuiControl = "LV4") || (A_Gui = "ReIn") {
            ;        If (A_Gui != "ReIn") {
            ;            If (RMS = "#2")
            ;                Gui, Main:ListView, LV1
            ;            Else If (RMS = "#5")
            ;                Gui, Main:ListView, LV4
            ;            If (Row := LV_GetNext()) {
            ;                If (!ShowTT) {
            ;                    ShowToolTipGui()
            ;                    ShowTT := 1
            ;                }
            ;                If (ThisLoaded != Row) {
            ;                    LV_GetText(FileName, Row, 1)
            ;                    RawData := StrSplit(DB_Read(FileName), "> ")[2]
            ;                    Items := StrSplit(Trim(RawData, "|"), "|")
            ;                    Result := "=====================================================================`n"
            ;                    AllProf := 0
            ;                    For Each, One in Items {
            ;                        DI := StrSplit(Trim(One, ";"), ";")
            ;                        Result .= " " _38 ": " DI[2] "`n " _39 ": " DI[3] "=" DI[4] "`n " _40 ": " DI[5] "=" DI[6] "`n " _41 ": " DI[7] "`n=====================================================================`n"
            ;                        AllProf := AllProf + DI[7]
            ;                    }
            ;                    Result .= "`n " _42 ": " AllProf
            ;                    GuiControl, ReIn:, DInfo, % Result
            ;                    ThisLoaded := Row
            ;                }
            ;            }
            ;        }
            ;    } Else If (ShowTT) {
            ;        Gui, ReIn:Hide
            ;        ShowTT := 0
            ;    }
            ;}

        } Else If (A_GuiControl ~= "LV2|LV3") {
            If (!MultiSel)
                Return
            Gui, Main:ListView, % A_GuiControl
            If (Row := LV_GetNext()) {
                LV_GetText(Barc, Row, 1)
                If (ProdDefs["" Barc ""][5] != "") {
                    For other, s in StrSplit(ProdDefs["" Barc ""][5], "/") {
                        If (RowsArr["" s ""][1]) {
                            LV_Modify(RowsArr["" s ""][1], "+Select")
                        }
                    }
                }
            }
        } Else If (A_Gui = "StSum") {
            If (!MultiSel)
                Return
            Gui, StSum:Default
            If (Row := LV_GetNext()) {
                LV_GetText(Barc, Row, 1)
                If (ProdDefs["" Barc ""][5] != "") {
                    For other, s in StrSplit(ProdDefs["" Barc ""][5], "/") {
                        If (RowsArr["" s ""][1]) {
                            LV_Modify(RowsArr["" s ""][1], "+Select")
                        }
                    }
                }
            }
            Gui, Main:Default
        } Else If (ShowTT) && (A_Gui != "ReIn") {
            Gui, ReIn:Hide
            ShowTT := 0
        }
    }
}

ShowToolTipGui() {
    MouseGetPos, X, Y
    Global Info
    If (A_ScreenWidth - X > 800) && ((A_ScreenHeight - Y) > (A_ScreenHeight // 2))
        Gui, ReIn:Show, % "NoActivate x" (X += 20) " y" (Y += 10) " w806 h" (A_ScreenHeight // 2)  + 6
    Else If (A_ScreenWidth - X <= 800) && ((A_ScreenHeight - Y) > (A_ScreenHeight // 2)) {
        Gui, ReIn:Show, % "NoActivate x" (X -= 840) " y" (Y += 10) " w806 h" (A_ScreenHeight // 2)  + 6
    } Else If (A_ScreenWidth - X > 800) && ((A_ScreenHeight - Y) <= (A_ScreenHeight // 2)) {
        Gui, ReIn:Show, % "NoActivate x" (X += 20) " y" (Y -= (A_ScreenHeight // 2) + 30) " w806 h" (A_ScreenHeight // 2) + 6
    } Else {
        Gui, ReIn:Show, % "NoActivate x" (X -= 840) " y" (Y -= (A_ScreenHeight // 2) + 30) " w806 h" (A_ScreenHeight // 2) + 6
    }
    WinSet, Trans, 200, % "ahk_id " Info
}

UpdateProdDefs() {
    Global
    genData := ""
    For Each, Barcode in ProdDefs {
        genData .= Each ";" Barcode[1] ";" Barcode[2] ";" Barcode[3] ";" (Barcode[4] ? Barcode[4] : 0) (Barcode[5] ? ";" Barcode[5] : "") "|"
    }
    DB_Write("Sets\PD.db", genData)
}
CheckListSum() {
    global
    Everything := 0
    Loop, % LV_GetCount() {
        LV_GetText(Qn, A_Index, 4)
        If (Qn) {
            LV_GetText(ThisLSum, A_Index, 5)
            Everything += ThisLSum
        }
    }
    If (Everything) {
        GuiControl, Main:, ThisListSum, % Everything " " ConvertMillimsToDT(Everything)
        GuiControl, Main:, AllSum, % Everything 
    } Else {
        GuiControl, Main:, ThisListSum, % "---"
    }
}
AllButThis(All, This) {
    tmp := ""
    For every, one in All {
        If (one != This) {
            tmp .= one "/"
        }
    }
Return, Trim(tmp, "/")
}
GenColor(Arr) {
    EarlierData := ""
    If (FileExist("Sets\CS.db"))
        EarlierData := DB_Read("Sets\CS.db")
    Items := ""
    For Each, One in Arr {
        Items .= One ";"
    }
    Items := RandomHexColor() ";" Trim(Items, ";") "|"
    DB_Write("Sets\CS.db", EarlierData Items)
}
FindTheColor(ID) {
    For every, one in StrSplit(DB_Read("Sets\CS.db"), "|") {
        If InStr(one, ID ";") || InStr(one, ";" ID) {
            ThisOne := StrSplit(one, ";")
        Return, "0x" ThisOne[1]
    }
}
}
RemoveBC(Data, Bc) {
    NewData := ""
    For Any, Thing in StrSplit(Data, "/") {
        If (Thing != Bc) {
            NewData .= Thing "/"
        }
    }
    Return, Trim(NewData, "/")
}
LoadAccounts() {
    LV_Delete()
    AccInfo := StrSplit(DB_Read("Sets\Lc.lic"), ";")
    Loop, % AccInfo.Length() - 3 {
        NP := StrSplit(AccInfo[A_Index + 3], "/")
        LV_Add(, NP[1], NP[2])
    }
    GuiControl, Main:, UserName
    GuiControl, Main:, UserPass
    GuiControl, Main:Focus, UserName
}

LoadStockChanges(OneFile := "") {
    global
    GuiControl, Main:, Add
    GuiControl, Main:, Sub
    If (!OneFile) {
        StockChanges := ""
        Loop, Files, Stoc\*.db, FR
        {
            If (RD := DB_Read(A_LoopFileFullPath)) {
                Data := StrSplit(RD, "|")
                FormatTime, TD, % StrReplace(A_LoopFileName, ".db"), yyyy/MM/dd HH:mm:ss
                StockChanges .= Data[1] "|[" TD "]: " Data[2] "`n"
                If (Data[3]) {
                    For Ot, hers in StrSplit(Data[3], "/") {
                        StockChanges .= hers "|[" TD "]: " Data[2] "`n"
                    }
                }
            }
            StockChanges .= "`n"
        }
    } Else {
        If (RD := DB_Read(OneFile)) {
            Data := StrSplit(RD, "|")
            SplitPath, % OneFile,,,, OutNameNoExt
            FormatTime, TD, % OutNameNoExt, yyyy/MM/dd HH:mm:ss
            StockChanges .= Data[1] "|[" TD "]: " Data[2] "`n"
            If (Data[3]) {
                For Ot, hers in StrSplit(Data[3], "/") {
                    StockChanges .= hers "|[" TD "]: " Data[2] "`n"
                }
            }
        }
        StockChanges .= "`n"
    }

    SoldStoc := ""

    Loop, Files, Curr\*.db, FR
    {
        If (RD := DB_Read(A_LoopFileFullPath)) {
            FormatTime, TD, % StrReplace(A_LoopFileName, ".db"), yyyy/MM/dd HH:mm:ss
            IntersD := StrSplit(RD, "> ")[2]
            Loop, Parse, IntersD, |
            {
                If (A_LoopField) {
                    ThisInt := StrSplit(A_LoopField, ";")
                    SoldStoc .= ThisInt[1] "|[" TD "]: -" StrSplit(ThisInt[3], "x")[2] "`n"
                }
            }
        }
        SoldStoc .= "`n"
    }
    
    Loop, Files, Valid\*.db, FR
    {
        If (RD := DB_Read(A_LoopFileFullPath)) {
            FormatTime, TD, % StrReplace(A_LoopFileName, ".db"), yyyy/MM/dd HH:mm:ss
            IntersD := StrSplit(RD, "> ")[2]
            Loop, Parse, IntersD, |
            {
                If (A_LoopField) {
                    ThisInt := StrSplit(A_LoopField, ";")
                    SoldStoc .= ThisInt[1] "|[" TD "]: -" StrSplit(ThisInt[3], "x")[2] "`n"
                }
            }
        }
        SoldStoc .= "`n"
    }
}

GetKridiUsers() {
    KList := ""
    Loop, Files, Kr\*, D
    {
        SplitPath, % A_LoopFileFullPath,,,, OutNameNoExt
        KList .= DecodeAlpha(OutNameNoExt) "|"
    }
    Return, Trim(KList, "|")
}

SelectAll(HwD) {
    PostMessage, 0xB1, 0, -1,, % "ahk_id " HwD
}

LoadKridis() {
    LV_Delete()
    GuiControl, Main:, KLB, |
    Loop, Files, Kr\*.*, D 
    {
        SplitPath, % A_LoopFileFullPath,,,, OutNameNoExt
        If (RMS = "#7") {
            GuiControl, Main:, KLB, % DecodeAlpha(OutNameNoExt)
        } Else {
            Return
        }
    }
    GuiControl, Main:Choose, KLB, 1
    GoSub, DisplayKridi
}

LoadPrevPD() {
    GuiControl, Main:, PrevPD, |
    If FileExist("Sets\PD.db") {
        FormatTime, ThisTime, % A_Now, yyyy/MM/dd HH:mm:ss
        GuiControl, Main:, PrevPD, % "[0] " ThisTime "||"
    }
    Loop, Files, % "Sets\Bu\*.Bu", F
    {
        SplitPath, % A_LoopFileName,,,, OutNameNoExt
        FormatTime, ThisTime, % OutNameNoExt, yyyy/MM/dd HH:mm:ss
        If (RMS = "#3") {
            GuiControl, Main:, PrevPD, % "[" A_Index "] " ThisTime
        } Else {
            Return
        }
    }
    GuiControl, Main:Disabled, PDSave
}

LoadSetting() {
    IniRead, UPT, Setting.ini, Update, Upt
    If (UPT) && (UPT != "ERROR") {
        CheckForUpdates := 1
        GuiControl, Main:, CheckForUpdatesCB3, % Chr(252)
    } Else {
        CheckForUpdates := 0
        GuiControl, Main:, CheckForUpdatesCB3
    }

    IniRead, RemUser, Setting.ini, OtherSetting, RemUser
    OldLog := StrSplit(DB_Read("Sets\RL.db"), ";")
    If (RemUser) && (RemUser != "ERROR") && (RemUser = OldLog[1]) {
        RememberLogin := 1
        GuiControl, Main:, RememberLoginCB3, % Chr(252)
    } Else {
        RememberLogin := 0
        GuiControl, Main:, RememberLoginCB3
    }
}

EncodeAlpha(Str) {
    EncStr := ""
    Loop, Parse, Str
    {
        If (A_LoopField ~= "[A-Ya-y]") || (A_LoopField ~= "[0-8]")
            EncStr .= Chr(Asc(A_LoopField) + 1)
        Else If (A_LoopField = "Z")
            EncStr .= Chr(Asc(A_LoopField) - 25)
        Else If (A_LoopField = "9")
            EncStr .= "0"
        Else
            EncStr .= A_LoopField
    }
Return, EncStr
}

DecodeAlpha(Str) {
    DecStr := ""
    Loop, Parse, Str
    {
        If (A_LoopField ~= "[B-Zb-z]") || (A_LoopField ~= "[1-9]")
            DecStr .= Chr(Asc(A_LoopField) - 1)
        Else If (A_LoopField = "A")
            DecStr .= Chr(Asc(A_LoopField) + 25)
        Else If (A_LoopField = "0")
            DecStr .= "9"
        Else
            DecStr .= A_LoopField
    }
Return, DecStr
}

SaveLogIn() {
    Global
    LogD := (LogD := DB_Read("Log\Log.db")) ? LogD : ""
    LogN := "LogIn=" A_Now ";Level=" Level ";User=" TU
    DB_Write("Log\Log.db", LogD "|" LogN)
}

SaveLogOut() {
    Global
    LogD := (LogD := DB_Read("Log\Log.db")) ? LogD : ""
    LogN := "LogOut=" A_Now ";Level=" Level ";User=" TP
    DB_Write("Log\Log.db", LogD "|" LogN)
}

ChargeLogs() {
    GuiControl, Main:, ByDate, |
    LogD := StrSplit(DB_Read("Log\Log.db"), "|")

    For Every, Log in LogD {
        If (SubStr(Log, 1, 5) = "LogIn") {
            InInfo := StrSplit(Log, ";")
            InUser := StrSplit(InInfo[3], "=")[2]
            If (SubStr(LogD[Every + 1], 1, 6) = "LogOut") {
                OutInfo := StrSplit(LogD[Every + 1], ";")
                OutUser := StrSplit(OutInfo[3], "=")[2]
                If (InUser = OutUser) {
                    InTime := StrSplit(InInfo[1], "=")[2]
                    OutTime := StrSplit(OutInfo[1], "=")[2]

                    FormatTime, FormattedInTime, % InTime, yyyy/MM/dd HH:mm:ss
                    FormatTime, FormattedOutTime, % OutTime, yyyy/MM/dd HH:mm:ss

                    GuiControl, Main:, ByDate, % FormattedInTime " - " FormattedOutTime "   " InTime ";" OutTime
                }
            }
        }
    }
    GuiControl, Main:Choose, ByDate, 1
    GoSub, DisplayEqProf
}

VerifLoads() {
    LV_Delete()
    If !VerifyMD5("Loads\Mem.ld") {
        LoadObj := FileOpen("Loads\Mem.ld", "w")
        Loop, Files, Valid\*.db, R F
        {
            RD := DB_Read(A_LoopFileFullPath)
            If (RD) {
                Arr := CalcProfit(RD)
                SPr := Arr[2][1] + SPr, CP := Arr[2][2] + CP, OAPr := Arr[2][3] + OAPr
                SplitPath, % A_LoopFileFullPath,,,, OutNameNoExt
                LoadObj.WriteLine("'" A_LoopFileFullPath "' -> " OutNameNoExt " -> " Arr[1] "," Arr[2][1] "," Arr[2][2] "," Arr[2][3] ",")
            }
        }

        Loop, Files, Curr\*.db
        {
            RD := DB_Read(A_LoopFileFullPath)
            If (RD) {
                Arr := CalcProfit(RD)
                SPr := Arr[2][1] + SPr, CP := Arr[2][2] + CP, OAPr := Arr[2][3] + OAPr
                SplitPath, % A_LoopFileFullPath,,,, OutNameNoExt
                LoadObj.WriteLine("'" A_LoopFileFullPath "' -> " OutNameNoExt " -> " Arr[1] "," Arr[2][1] "," Arr[2][2] "," Arr[2][3] ",")
            }
        }

        LoadObj.Close()
        DB_Write("Sets\HS.db", HashFile("Loads\Mem.ld"))
    } Else {
        Obj := FileOpen("Loads\Mem.ld", "r"), Col1 := Col2 := Col3 := 0
        GuiControl, Main:, SPr, % Col1
        GuiControl, Main:, CPr, % Col2
        GuiControl, Main:, OAProfit, % Col3
        GuiControl, Main:, PB, 0
        GuiControl, Main:Show, PB
        While !Obj.AtEOF() {
            Elements := StrSplit(Obj.ReadLine(), " -> "), File := Trim(Elements[1], "'")
            Elements := StrSplit(Elements[3], ",")
            LV_Add("", File, Elements[1], Elements[2], Elements[3], Elements[4])
            Col1 += Elements[2],  Col2 += Elements[3],  Col3 += Elements[4]
        }
        Obj.Close()
        GuiControl, Main:, SPr, % Col1
        GuiControl, Main:, CPr, % Col2
        GuiControl, Main:, OAProfit, % Col3
        GuiControl, Main:Hide, PB
    }
}

VerifyMD5(FilePath) {
    If (HashFile(FilePath) != DB_Read("Sets\HS.db")) || (HashFile(FilePath) = -1)
        Return, 0
    Return, 1
}

LoadKridiUsers() {
    global PrevKridis := {}
    GuiControl, Kridi:, KLB, |
    Loop, Files, % "Kr\*", D
    {
        PrevKridis[DecName := DecodeAlpha(A_LoopFileName)] := CalculateTotal(A_LoopFileFullPath)
        GuiControl, Kridi:, KLB, % DecName
    }
}

CalculateTotal(Folder) {
    Total := 0
    Loop, Files, % Folder "\*.db", F
    {
        Total += StrSplit(StrSplit(DB_Read(A_LoopFileFullPath), "> ")[3], ";")[1]
    }
    Return, Total
}