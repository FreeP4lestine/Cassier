#NoEnv
#Persistent
#SingleInstance, Force
SendMode Input
SetWorkingDir %A_ScriptDir%

#Include, <Class_CtlColors>
#Include, <Class_ImageButton>
#Include, <UseGDIP>
#Include, <Class_LVColors>

LoadInterfaceLng()
Gui, Startup:-Caption
Gui, Startup:Font, Bold s12, Calibri
html := "<html><body style='background-color: transparent' style='overflow:hidden' leftmargin='0' topmargin='0'><img src='" A_ScriptDir "\Img\Load.gif' width=" w " height=" h " border=0 padding=0></body></html>"
Gui, Startup:Add, ActiveX, x0 y0 w960 h540 vAG, Shell.Explorer
AG.navigate("about:blank")
AG.document.write(html)
Gui, Startup:Show, w960 h565
Gui, Startup:Add, Progress, x0 w960 y540 c0x008000 h25 BackgroundWhite vUPProg
Gui, Startup:Add, Text, x0 w960 y540 Center h25 vStat BackgroundTrans, % _22
GuiControl, Startup:+Redraw, Stat
GuiControl, Startup:Disabled, AG
If (CheckForUpdatesStat()) {
    If DllCall("Wininet.dll\InternetGetConnectedState", "Str", 0x40, "Int", 0)
        CheckForUpdates()
}
Gui, StartUp:Destroy
CheckFoldersSet()
GreenBTN := [[0, 0xFFFFFF, , 0x008000, 0, , 0x008000, 1]
, [0, 0x008000, , 0xFFFFFF, 0, , 0x008000, 1]
, [0, 0x008000, , 0xFFFF00, 0, , 0x008000, 1]
, [0, 0x6C7174, , 0x000000, 0, , 0xFFFFFF, 1]]
RedBTN := [[0, 0xFFFFFF, , 0xFF0000, 0, , 0xD43F3A, 1]
, [0, 0xFF0000, , 0xFFFFFF, 0, , 0xD43F3A, 1]
, [0, 0xFF0000, , 0xFFFF00, 0, , 0xD43F3A, 1]
, [0, 0x6C7174, , 0x000000, 0, , 0xFFFFFF, 1]]
LMBTN := [[0, 0x80FFFFFF, , 0x000000, 0, , 0x80F0AD4E]
, [0, 0x80F0AD4E, , 0x000000, 0, , 0x80F0AD4E]
, [0, 0x80F0AD4E, , 0xFF0000, 0, , 0x80F0AD4E]
, [0, 0x80F0AD4E, , 0x000000, 0, , 0x80F0AD4E]]
EBTN := [[0, 0xC6E6C6, , , 0, , 0x5CB85C, 5]
, [0, 0x91CF91, , , 0, , 0x5CB85C, 5]
, [0, 0x5CB85C, , , 0, , 0x5CB85C, 5]
, [0, 0xF0F0F0, , , 0, , 0x5CB85C, 5]]
BMBTN := [[0, 0x80FFFFFF, , 0x000000, 0, , 0x80FFFFFF]
, [0, 0x80F0AD4E, , 0x000000, 0, , 0x80FFFFFF]
, [0, 0x80F0AD4E, , 0xFF0000, 0, , 0x80FFFFFF]
, [0, 0x80F0AD4E, , 0x000000, 0, , 0x80F0AD4E]]
HH := A_ScreenHeight // 2
Gui, ReIn:+HwndInfo -Caption AlwaysOnTop ToolWindow MinSize800x%HH% MaxSize800x%HH% Resize
Gui, ReIn:Font, s15 Bold, Consolas
Gui, ReIn:Add, Edit, x0 y0 w800 h%HH% ReadOnly HwndE vDInfo
CtlColors.Attach(E, "E2E09A", "000000")
Gui, Main: +HwndMain MinSize1000x600
Gui, Main:Font, s10 Bold, Calibri
Gui, Main:Color, 0xD8D8AD
LoadBackground()
Gui, Main:Add, Text, x0 y0 w1000 h10 HwndTopText vTText
CtlColors.Attach(TopText, "9EA7AD", "000000")
Pass := 0
If !CheckLicense() {
    Gui, Main:Add, Picture, x0 y10 h419 vLicPic, Img\Lic.png
    Gui, Main:Add, Edit, xm+205 ym+135 w760 vEPassString Center
    Gui, Main:Add, Text, xm+205 ym+165 w760 vPassString Center BackgroundTrans, Please enter the KeyString
    RMS := "#-1"
    Gui, Main:Show, w1000 h500
    Return
}
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
    Gui, Main:Add, Button, x0 y210 HwndBtn w199 h40 gManage vBtn6 Hidden, % "Management"
    ImageButton.Create(Btn, LMBTN*)
    global TU, TP
    Gui, Main:Add, Edit, xm ym+150 vTU w178 Center -E0x200 HwndE
    CtlColors.Attach(E, "FFFFFF", "000000")
    Gui, Main:Add, Edit, xm+200 ym+150 vTP w178 Center -E0x200 Password HwndTP_
    CtlColors.Attach(TP_, "FFFFFF", "FF0000")
    Gui, Main:Add, Button, xm ym+150 w178 HwndBtn vReload gReload, Reload
    ImageButton.Create(Btn, GreenBTN*)
    GuiControl, Main:Hide, Reload
    MainCtrlList := "Bc,$CB,Nm,Stck,Qn,Sum,LV0,ThisListSum,$GivenMoney,$AllSum,$Change,$ItemsSold,$SoldP,$ProfitP"
    Gui, Main:Font, s25, Consolas
    Gui, Main:Add, Edit, xm y500 HwndE w175 vItemsSold -E0x200 Hidden ReadOnly Center Border, 0
    CtlColors.Attach(E, "D8D8AD", "000000")
    Gui, Main:Add, Edit, xm y528 HwndE w175 vSoldP -E0x200 Hidden ReadOnly Center Border, 0
    CtlColors.Attach(E, "D8D8AD", "008000")
    Gui, Main:Add, Edit, xm y556 HwndE w175 vProfitP -E0x200 Hidden ReadOnly Center Border, 0
    CtlColors.Attach(E, "D8D8AD", "FF0000")
    Ind := "", Xb := 217
    Gui, Main:Font, s25 Bold, Calibri
    Gui, Main:Add, Edit, xm+380 ym+10 w250 -VScroll vBc Center -E0x200 gAnalyzeAvail Border HwndBc_ Hidden
    CtlColors.Attach(Bc_, "FFFFFF", "008000")
    GuiControlGet, ThisPos, Main:Pos, Bc
    ThisPosX -= 10
    Gui, Main:Add, ComboBox, xm+%ThisPosX% ym+58 w250 vCB r10 Simple 0x100 Center gChooseItem HwndLB_ Hidden ReadOnly
    CtlColors.Attach(LB_, "FFFFFF", "008000")
    Gui, Main:Add, Edit, xm+205 ym+10 w175 vStck -E0x200 ReadOnly HwndE Center Hidden
    CtlColors.Attach(E, "D8D8AD", "FF0000")
    Gui, Main:Add, Edit, xm+205 ym+70 w250 vNm -E0x200 ReadOnly HwndNm Center Hidden
    CtlColors.Attach(Nm, "FFFFFF", "000080")
    Gui, Main:Add, Edit, xm+455 ym+70 w260 vQn Center -E0x200 ReadOnly HwndQn gAnalyzeQn Hidden, x1
    CtlColors.Attach(Qn, "FFFFFF", "008000")
    Gui, Main:Add, Edit, xm+715 ym+70 w250 vSum -E0x200 ReadOnly HwndSum Center Hidden
    CtlColors.Attach(Sum, "FFFFFF", "800000")
    Gui, Main:Add, Edit, xm+715 ym+370 w250 vThisListSum -E0x200 Border ReadOnly HwndThisListSum Center Hidden
    CtlColors.Attach(ThisListSum, "FCEFDC", "800000")
    Gui, Main:Font, s15
    Loop, 7 {
        Gui, Main:Add, Button, xm+%Xb% ym+300 w25 h25 vOpenSess%Ind% HwndOpenSess%Ind%_ gUpdateSession Center Hidden, % A_Index
        MainCtrlList .= ",OpenSess" Ind
        ImageButton.Create(OpenSess%Ind%_, BMBTN*)
        Ind := A_Index
        Xb += 25
    }
    GuiControl, Main: Disabled, OpenSess
    Gui, Main:Font, s50
    Gui, Main:Add, Edit, xm+205 ym+10 w254 vGivenMoney -E0x200 gCalc Center Hidden
    Gui, Main:Add, Edit, xm+460 ym+10 w254 vAllSum HwndAS -E0x200 ReadOnly Center Hidden
    CtlColors.Attach(AS, "FFFFFF", "008000")
    Gui, Main:Add, Edit, xm+715 ym+10 w252 vChange HwndC -E0x200 ReadOnly Center Hidden
    CtlColors.Attach(C, "FFFFFF", "FF0000")
    Gui, Main:Font, s25
    Gui, Main:Add, ListView, xm+205 ym+135 w760 r10 -Hdr Grid vLV0 BackgroundFCEFDC HwndHLV Hidden -Multi, Barcode|QN|Name|Quantity|Price
    Gui, Main:Default
    Gui, Main:ListView, LV0
    LV_ModifyCol(1, "0 Center")
    LV_ModifyCol(2, "180")
    LV_ModifyCol(3, "234 Center")
    LV_ModifyCol(4, "232 Center")
    LV_ModifyCol(5, "230 Center")
    EnsureCtrlList := "LV1,EnsBtn,$Sold,$Bought,$ProfitEq"
    Gui, Main:Font, s25
    Gui, Main:Add, Button, xm+205 ym+30 vEnsBtn w760 h80 hwndBtn Hidden gValid, % _9
    ImageButton.Create(Btn, EBTN*)
    Gui, Main:Font, s15
    Gui, Main:Add, ListView, xm+205 ym+135 w760 r10 -Hdr Grid vLV1 BackgroundDEFCDC HwndHLV Hidden -Multi, FN|SO
    Gui, Main:Default
    Gui, Main:ListView, LV1
    LV_ModifyCol(1, "0")
    LV_ModifyCol(2, "760 Center")
    Gui, Main:Font, s40
    Gui, Main:Add, Edit, xm+206 ym+430 w260 vSold Center -E0x200 ReadOnly HwndE gAnalyzeQn Hidden
    CtlColors.Attach(E, "00FF00", "000000")
    Gui, Main:Add, Edit, xm+456 ym+430 w260 vBought -E0x200 ReadOnly HwndE Center Hidden
    CtlColors.Attach(E, "FF8080", "000000")
    Gui, Main:Add, Edit, xm+716 ym+430 w260 vProfitEq -E0x200 ReadOnly HwndE Center Hidden
    CtlColors.Attach(E, "00FF00", "000000")
    Gui, Main:Font, s15
    DefineCtrlList := "Dbc,Dnm,Dbp,Dsp,LV2"
    Gui, Main:Add, Edit, xm+205 ym+80 w185 Center Border vDbc HwndDbc_ -E0x200 gClearDbc Hidden
    CtlColors.Attach(Dbc_, "FFFFFF", "000000")
    Gui, Main:Add, Edit, xm+396 ym+80 w185 Center Border vDnm HwndDnm_ -E0x200 gClearDnm Hidden
    CtlColors.Attach(Dnm_, "FFFFFF", "000000")
    Gui, Main:Add, Edit, xm+589 ym+80 w185 Center Border vDbp HwndDbp_ -E0x200 gClearDbp Hidden
    CtlColors.Attach(Dbp_, "FFFFFF", "000000")
    Gui, Main:Add, Edit, xm+780 ym+80 w185 Center Border vDsp HwndDsp_ -E0x200 gClearDsp Hidden
    CtlColors.Attach(Dsp_, "FFFFFF", "000000")
    Gui, Main:Font, s15
    Gui, Main:Add, ListView, xm+205 ym+135 w760 r10 -Hdr Grid vLV2 HwndHLV2 BackgroundDCFCF9 Hidden gEdit, Barcode|Name|Quantity|Price
    Gui, Main:Default
    Gui, Main:ListView, LV2
    LV_ModifyCol(1, "185 Center")
    LV_ModifyCol(2, "192 Center")
    LV_ModifyCol(3, "192 Center")
    LV_ModifyCol(4, "186 Center")
    StockPileCtrlList := "Pnm,Pqn,PSum,LV3,StockSum"
    Gui, Main:Font, s25
    Gui, Main:Add, Edit, xm+205 ym+50 w253 Center vPnm HwndPnm_ -E0x200 Hidden
    CtlColors.Attach(Pnm_, "E6E6E6", "000000")
    Gui, Main:Add, Edit, xm+458 ym+50 w253 Center vPqn HwndPqn_ -E0x200 Hidden
    CtlColors.Attach(Pqn_, "E6E6E6", "0000FF")
    Gui, Main:Add, Edit, xm+711 ym+50 w253 Center vPSum HwndPSum_ -E0x200 Hidden ReadOnly
    CtlColors.Attach(PSum_, "E6E6E6", "000000")
    Gui, Main:Add, Edit, xm+585 ym+300 w253 Center vStockSum HwndStockSum_ -E0x200 Hidden ReadOnly
    CtlColors.Attach(StockSum_, "FFFFFF", "FF0000")
    Gui, Main:Font, s15
    Gui, Main:Add, ListView, xm+205 ym+135 w760 r10 -Hdr Grid vLV3 BackgroundF4FCDC HwndHLV3 gDisplayQn Hidden -Multi, Barcode|Name|Quantity|ThisSum
    Gui, Main:Default
    Gui, Main:ListView, LV3
    LV_ModifyCol(1, "0 Center")
    LV_ModifyCol(2, "377 Center")
    LV_ModifyCol(3, "380 Center")
    LV_ModifyCol(4, "380 Center")
    ProfitCtrlList := "SPr,CPr,OAProfit,LV4,Today,Yesterday"
    Gui, Main:Font, s25
    TodayDate := A_Now
    Gui, Main:Add, DateTime, xm+205 ym+350 w345 vToday Choose%TodayDate% gDisplayEqProfit Hidden, yyyy.MM.dd | HH:mm:ss
    TodayDate += -1, Days
    Gui, Main:Add, DateTime, xm+605 ym+350 w345 vYesterday Choose%TodayDate% gDisplayEqProfit Hidden, yyyy.MM.dd | HH:mm:ss
    Gui, Main:Font, s15
    Gui, Main:Add, ListView, xm+205 ym+135 w760 r10 -Hdr Grid vLV4 BackgroundFCDCDC HwndHLV gDisplayQn Hidden -Multi, FN|Date|BP|SP|Pr
    Gui, Main:Add, Edit, xm+776 ym+90 -E0x200 ReadOnly vOAProfit w189 Hidden Center cRed Border HwndE
    CtlColors.Attach(E, "00FF00", "000000")
    Gui, Main:Add, Edit, xm+586 ym+90 -E0x200 ReadOnly vCPr w189 Hidden Center cRed Border HwndE
    CtlColors.Attach(E, "FF8080", "000000")
    Gui, Main:Add, Edit, xm+396 ym+90 -E0x200 ReadOnly vSPr w189 Hidden Center cRed Border HwndE
    CtlColors.Attach(E, "00FF00", "000000")
    Gui, Main:Default
    Gui, Main:ListView, LV4
    LV_ModifyCol(1, "0")
    LV_ModifyCol(2, "189 Center")
    LV_ModifyCol(3, "189 Center")
    LV_ModifyCol(4, "189 Center")
    LV_ModifyCol(5, "189 Center")
    ManageCtrlList := "UserName,UserPass,LV5"
    Gui, Main:Add, Edit, xm+205 ym+10 w200 -E0x200 vUserName Hidden HwndE Border Right cRed
    Gui, Main:Add, Edit, xm+405 ym+10 w200 -E0x200 vUserPass Hidden HwndE Border
    Gui, Main:Add, ListView, xm+205 ym+50 w400 r10 -Hdr Grid vLV5 HwndHLV Hidden -Multi cBlue, N|P
    Gui, Main:Default
    Gui, Main:ListView, LV5
    LV_ModifyCol(1, "198 Right")
    LV_ModifyCol(2, "198")
    Gui, Main:Font, s15
    Gui, Main:Show, % "Maximize" ; 5 " y" 0 " w" A_ScreenWidth - 20 " h" A_ScreenHeight - 80
Return
Continue:
    Loop, Parse, % "124356"
        GuiControl, Main:Show, Btn%A_LoopField%
    Gui, Main:Default
    Gui, Main:ListView, LV0
    Gosub, OpenMain
    LastMDate := ""
    Table := ["A", "B", "C", "D", "E", "F"]
    SetTimer, Update, 250
    FileGetTime, PBMData, Sets\PD.db, M
    Global ProdDefs
    If FileExist("Sets\PD.db")
        ProdDefs := LoadDefinitions(DB_Read("Sets\PD.db"))
    HLM := 0
    Gui, Main:Submit, NoHide
    SessionID := "OpenSess"
    If FileExist("Dump\" SessionID ".db")
        RestoreSession(DB_Read("Dump\" SessionID ".db"))
    If (DB_Read("Sets\Vr.db") != Version()) {
        Gui, Info:-SysMenu
        Gui, Info:Font, s15 Bold, Consolas
        Gui, Info:Add, Text, x0 y10 w400 ReadOnly cRed Center vTitle, % "Bilan mta3 version " Version()
        Gui, Info:Font, s12
        Gui, Info:Add, Edit, x0 y50 h400 w400 ReadOnly Center HwndE, % "Awel 7aja n7eb ngoulha hiya fenetre "
        . "hadhi bech dema tadhher fi koll mis a jour jdid"
        . " w ken t7eb tna7iha mech mochkla"
        . "`n`n7wayej li mil mafroudh tsal7ou:"
        . "`n1 - Calcul mta3 arba7 (ken thamma zeroat)"
        . "`n2 - 3amlan page jdida el tasjil el bi3an"
        . "`n`n7wayej li mil mafroudh walou a7san:"
        . "`n1 - Ki teskani martin nafs 7aja mara lawla tenzd lil lista w ba3din twali tzid ken el kimia"
        . "`n2 - Affichange mta3 lista li fi sabban essel3a walla mrateb (m s8ir lil kbir)"
        . "`n3 - Ki tzid barcode yabda deja mawjoud el barnamij automatic ihizzik gdah"
        . "`n`n7aja zedtha:"
        . "`n1 - recherche fil menu mta3 sabban essel3a"
        . "`nSahil yasser iste3mala, ekteb men fog (Kima bech tsob sel3a jdida) chnoi t7eb twem fi barcod willa esm willa 7ata lo5rin, ba3din cliki [Ctrl + F] iwali idhahrellek lista mta3 sel3a masbouba li fiha haka li t7awem 3lih"
        . "`n`n7wayej nchallah bech nzidhom:"
        . "`n1 - boutonat el kol 5dema fi testa3mil fiha clavier"
        . "`n2 - tsawir lil grafique mta3 barnamij"
        . "`n3 - statistic mfassal lil arba7 fih b detail ach tba3 w bgedech w wagtech ila5 ila5..."
        . "`n4 - 3amlan option el terji3 essel3a"
        . "`n`nMouch akid yet3emlou fi mis a jour jay ama fi agrab wa9t nchallah."
        . "`nClicki OK bech tsaker el fenetre"
        CtlColors.Attach(E, "FFFFFF", "000000")
        Gui, Info:Add, Button, x10 y460 w380 HwndBtn, OK
        ImageButton.Create(Btn, GreenBTN*)
        Gui, Info:Show, w400 h500, % " "
        GuiControl, Info:Focus, Title
        DB_Write("Sets\Vr.db", Version())
    }
    CoordMode, Mouse, Screen
    OnMessage(0x200, "MouseHover")
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
    If (Today >= Yesterday) {
        OAPr := CP := SPr := 0
        LV_Delete()
        Loop, Files, Valid\*.db, R F
        {
            ThisDate := SubStr(A_LoopFileName, 1, StrLen(A_LoopFileName) - 3)
            If ThisDate Between %Yesterday% and %Today%
            {
                RD := DB_Read(A_LoopFileFullPath)
                If (RD) {
                    Arr := CalcProfit(RD)
                    If (!Arr[2][2]) {
                        Correct(A_LoopFileFullPath)
                        RD := DB_Read(A_LoopFileFullPath)
                        Arr := CalcProfit(RD)
                    }
                    LV_Add("", A_LoopFileFullPath, Arr[1], "+ " Arr[2][1], "- " Arr[2][2], "+ " Arr[2][3])
                    SPr := Arr[2][1] + SPr
                    CP := Arr[2][2] + CP
                    OAPr := Arr[2][3] + OAPr
                }
            }
        }
        Loop, Files, Curr\*.db
        {
            ThisDate := SubStr(A_LoopFileName, 1, StrLen(A_LoopFileName) - 3)
            If ThisDate Between %Yesterday% and %Today%
            {
                RD := DB_Read(A_LoopFileFullPath)
                If (RD) {
                    Arr := CalcProfit(RD)
                    If (!Arr[2][2]) {
                        Correct(A_LoopFileFullPath)
                        RD := DB_Read(A_LoopFileFullPath)
                        Arr := CalcProfit(RD)
                    }
                    LV_Add("", A_LoopFileFullPath, Arr[1], "+ " Arr[2][1], "- " Arr[2][2], "+ " Arr[2][3])
                    SPr := Arr[2][1] + SPr
                    CP := Arr[2][2] + CP
                    OAPr := Arr[2][3] + OAPr
                }
            }
        }
        GuiControl, Main:, OAProfit, % OAPr
        GuiControl, Main:, SPr, % SPr
        GuiControl, Main:, CPr, % CP
    }
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
Return
InfoButtonOK:
    Gui, Info:Destroy
Return
:*C:LetAppRunOnThisMachine::
    If (RMS = "#-1") {
        Pass := 1
        ADMUsername := ADMPassword := ""
        GuiControl, Main:, PassString, Create ADM username
    }
Return
MainGuiSize:
    WinGetPos,,, Width, Height, % "ahk_id " Main
    Height -= 35
    GuiControl, Main:Move, % "TText", % "w" Width
    GuiControl, Main:Move, % "Prt1", % "y" Height - 55 " w" Width - 199
    GuiControl, Main:Move, % "Prt2", % "y" Height - 55
    GuiControl, Main:Move, % "Prt3", % "y" Height - 60 " w" Width
    GuiControl, Main:Move, % "Prt4", % "h" Height
    GuiControl, Main:Move, % "Prt5", % "x" Width - 57 " y" Height - 45
    Loop, 5 {
        GuiControl, Main:+Redraw, % "Prt" A_Index
    }
    If (RMS = "#0") {
        GuiControl, Main:Move, TU, % "y" Height - 45
        GuiControl, Main:+Redraw, TU
        GuiControl, Main:Move, TP, % "y" Height - 45
        GuiControl, Main:+Redraw, TP
    }
    Width -= 30
    Third := (Width - 217) // 3
    If (RMS != "#0") {
        GuiControl, Main:Move, Reload, % "y" Height - 45
        GuiControl, Main:+Redraw, Reload
        GuiControl, Main:Move, TP, % "y" Height - 45
        GuiControl, Main:+Redraw, TP
    }
    If (RMS = "#1") {
        InitY := 108
        GuiControl, Main:Move, % "ItemsSold", % "y" Height - InitY - (50 * 2)
        GuiControl, Main:Move, % "SoldP", % "y" Height - InitY - 50
        GuiControl, Main:Move, % "ProfitP", % "y" Height - InitY
        GuiControl, Main:Move, % "Bc", % "w" Third
        GuiControl, Main:Move, % "CB", % "w" Third
        GuiControl, Main:Move, % "Nm", % "w" Third
        GuiControl, Main:Move, % "Qn", % "x" Third + 217 " w" Third
        GuiControl, Main:Move, % "Sum", % "x" (Third * 2) + 217 " w" Third
        GuiControl, Main:Move, % "LV0", % "w" (Third * 3) " h" Height - 260
        GuiControl, Main:Move, % "ThisListSum", % "x" (Third * 2) + 217 " y" Height - 118 " w" Third
        GuiControl, Main:+Redraw, % "Offer"
        GuiControl, Main:+Redraw, % "Discount"
        GuiControl, Main:+Redraw, % "Percent"
        GuiControl, Main:+Redraw, % "ThisListSum"
        Gui, Main:ListView, LV0
        LV_ModifyCol(3, (Val := Third) - 61)
        LV_ModifyCol(4, Val - 62)
        LV_ModifyCol(5, Val - 61)
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
        If (Loaded) {
            Loop, Parse, % ",1,2,3,4,5,6", `,
                GuiControl, Main:+Redraw, % "OpenSess" A_LoopField
        }
    } Else If (RMS = "#2") {
        GuiControl, Main:Move, % "EnsBtn", % "w" (Third * 3)
        GuiControl, Main:, % "EnsBtn", % _9
        GuiControlGet, Btn, Main:Hwnd, EnsBtn
        ImageButton.Create(Btn, EBTN*)
        GuiControl, Main:+Redraw, % "EnsBtn"
        GuiControl, Main:Move, % "LV1", % "w" (Third * 3) " h" Height - 300
        Gui, Main:ListView, LV1
        LV_ModifyCol(2, (Third * 3) - 22)
        GuiControl, Main:Move, % "Sold", % "y" Height - 150 " w" Third
        GuiControl, Main:Move, % "Bought", % "x" Third + 217 " y" Height - 150 " w" Third
        GuiControl, Main:Move, % "ProfitEq", % "x" (Third * 2) + 217 " y" Height - 150 " w" Third
    } Else If (RMS = "#3") {
        Quarter := (Width - 217) // 4
        GuiControl, Main:Move, % "Dbc", % "w" Quarter
        GuiControl, Main:Move, % "Dnm", % "x" Quarter + 217 " w" Quarter
        GuiControl, Main:Move, % "Dbp", % "x" (Quarter * 2) + 217 " w" Quarter
        GuiControl, Main:Move, % "Dsp", % "x" (Quarter * 3) + 217 " w" Quarter
        GuiControl, Main:Move, % "LV2", % "w" (Quarter * 4) " h" Height - 220
        Gui, Main:ListView, LV2
        LV_ModifyCol(1, (Val := Quarter) - 2)
        LV_ModifyCol(2, Val - 1)
        LV_ModifyCol(3, Val)
        LV_ModifyCol(4, Val - 1)
    } Else If (RMS = "#4") {
        GuiControl, Main:Move, % "Pnm", % "w" Third
        GuiControl, Main:Move, % "Pqn", % "x" Third + 217 " w" Third
        GuiControl, Main:Move, % "Psum", % "x" (Third * 2) + 217 " w" Third
        GuiControl, Main:Move, % "LV3", % "w" (Third * 3) " h" Height - 270
        GuiControl, Main:Move, % "StockSum", % "x" (Third * 2) + 217 " y" Height - 120 " w" Third
        Gui, Main:ListView, LV3
        LV_ModifyCol(2, (Val := Third) - 3)
        LV_ModifyCol(3, Val - 1)
        LV_ModifyCol(4, Val - 1)
    } Else If (RMS = "#5") {
        Quarter := (Width - 217) // 4
        GuiControl, Main:Move, % "SPr", % "x" Quarter + 217 " w" Quarter
        GuiControl, Main:Move, % "CPr", % "x" (Quarter * 2) + 217 " w" Quarter
        GuiControl, Main:Move, % "OAProfit", % "x" (Quarter * 3) + 217 "w" Quarter
        GuiControl, Main:Move, % "Today", % "x" 217 " y" Height - 115
        GuiControl, Main:Move, % "Yesterday", % "x" Width - 350 " y" Height - 115
        GuiControl, Main:Move, % "LV4", % "w" (Quarter * 4) " h" Height - 260
        Gui, Main:ListView, LV4
        LV_ModifyCol(2, (Val := Quarter) - 3)
        LV_ModifyCol(3, Val)
        LV_ModifyCol(4, Val)
        LV_ModifyCol(5, Val - 1)
    } Else If (RMS = "#6") {
        GuiControl, Main:Move, % "LV5", % "h" Height - 140
    }
Return

Update:
    If WinActive("ahk_id " Main) {
        If (Level = "User") {
            Loop, 5 {
                GuiControlGet, Enb, Main:Enabled, % "Btn" A_Index + 1
                If (Enb) {
                    GuiControl, Main:Disabled, % "Btn" A_Index + 1
                }
            }
        }
        FileGetTime, ThisMData, Curr, M
        If (ThisMData != LastMDate) {
            Nb := SPr := OAPr := 0
            Loop, Files, Curr\*.db
            {
                RD := DB_Read(A_LoopFileFullPath)
                If (RD) {
                    Arr := CalcProfit(RD)
                    SPr := Arr[2][1] + SPr
                    OAPr := Arr[2][3] + OAPr
                    Nb := Nb + Arr[3]
                }
            }
            GuiControl, Main:, ItemsSold, % Nb
            GuiControl, Main:, SoldP, % SPr
            GuiControl, Main:, ProfitP, % OAPr
            LastMDate := ThisMData
        }
        If FileExist("Sets\PD.db") {
            FileGetTime, _ThisMData, Sets\PD.db, M
            If (PBMData != _ThisMData) {
                ProdDefs := LoadDefinitions(DB_Read("Sets\PD.db"))
                PBMData := _ThisMData
            }
        }
        If (RMS = "#1") {
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
    GuiControl, Main:Focus, Bc
    Gosub, MainGuiSize
    Loop, Parse, % "124356"
        GuiControl, Main:Disabled, Btn%A_LoopField%
    Hide(EnsureCtrlList "," DefineCtrlList "," StockPileCtrlList "," ProfitCtrlList "," ManageCtrlList)
    Show(MainCtrlList)
    Gui, Main:ListView, LV0
    Gui, Main:Submit, NoHide
    Loop, Parse, % "24356"
        GuiControl, Main:Enabled, Btn%A_LoopField%
    If FileExist("Dump\" SessionID ".db")
        RestoreSession(DB_Read("Dump\" SessionID ".db"))
Return
Submit:
    RMS := "#2"
    Gosub, MainGuiSize
    Loop, Parse, % "124356"
        GuiControl, Main:Disabled, Btn%A_LoopField%
    Hide(MainCtrlList "," DefineCtrlList "," StockPileCtrlList "," ProfitCtrlList "," ManageCtrlList)
    Show(EnsureCtrlList)
    Gui, Main:ListView, LV1
    GuiControl, Main:Enabled, EnsBtn
    LoadCurrent()
    Loop, Parse, % "13456"
        GuiControl, Main:Enabled, Btn%A_LoopField%
Return
Define:
    RMS := "#3"
    Gosub, MainGuiSize
    Loop, Parse, % "124356"
        GuiControl, Main:Disabled, Btn%A_LoopField%
    Hide(MainCtrlList "," EnsureCtrlList "," StockPileCtrlList "," ProfitCtrlList "," ManageCtrlList)
    Show(DefineCtrlList)
    Gui, Main:ListView, LV2
    LoadDefined()
    Loop, Parse, % "12456"
        GuiControl, Main:Enabled, Btn%A_LoopField%
Return
StockPile:
    RMS := "#4"
    Gosub, MainGuiSize
    Loop, Parse, % "124356"
        GuiControl, Main:Disabled, Btn%A_LoopField%
    Hide(MainCtrlList "," EnsureCtrlList "," DefineCtrlList "," ProfitCtrlList "," ManageCtrlList)
    Show(StockPileCtrlList)
    Gui, Main:ListView, LV3
    LoadStockList()
    Loop, Parse, % "12356"
        GuiControl, Main:Enabled, Btn%A_LoopField%
Return
Prof:
    RMS := "#5"
    Gosub, MainGuiSize
    Loop, Parse, % "123456"
        GuiControl, Main:Disabled, Btn%A_LoopField%
    Hide(MainCtrlList "," EnsureCtrlList "," DefineCtrlList "," StockPileCtrlList "," ManageCtrlList)
    Show(ProfitCtrlList)
    Gui, Main:ListView, LV4
    LoadProf()
    Loop, Parse, % "12346"
        GuiControl, Main:Enabled, Btn%A_LoopField%
Return
Manage:
    RMS := "#6"
    Gosub, MainGuiSize
    Loop, Parse, % "123456"
        GuiControl, Main:Disabled, Btn%A_LoopField%
    Hide(MainCtrlList "," EnsureCtrlList "," DefineCtrlList "," StockPileCtrlList "," ProfitCtrlList)
    Show(ManageCtrlList)
    Gui, Main:ListView, LV5
    LoadAccounts()
    Loop, Parse, % "12345"
        GuiControl, Main:Enabled, Btn%A_LoopField%
    GuiControl, Main:Focus, UserName
Return
Edit:
    LV_GetText(EBc, Row := LV_GetNext(), 1)
    EditMod := [1, EBc]
    LV_GetText(ENm, Row, 2)
    LV_GetText(EBp, Row, 3)
    LV_GetText(ESp, Row, 4)
    GuiControl, Main:, Dbc, % EBc
    GuiControl, Main:, Dnm, % ENm
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
    FileCreateDir, % "Valid\" Now := A_Now
    FileMove, % "Curr\*.db", % "Valid\" Now
    Gui, Main:Default
    LV_Delete()
    GuiControl, Main:Disabled, EnsBtn
    GuiControl, Main:, Sold
    GuiControl, Main:, Bought
    GuiControl, Main:, ProfitEq
Return
DisplayQn:
    LV_GetText(Sqn, Row := LV_GetNext(), 3)
    LV_GetText(Snm, Row, 2)
    LV_GetText(Sid, Row, 1)
    LV_GetText(Ssum, Row, 4)
    GuiControl, Main:, Pqn, % Sqn
    GuiControl, Main:, Pnm, % Snm
    GuiControl, Main:, Psum, % Ssum
    SelectionQn := Sid
    GuiControl, Main:Focus, Pqn
    PostMessage, 0xB1, 0, -1,, % "ahk_id " Pqn_
    EditStock := 1
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
^s::
    If (RMS="#3") {
        Gui, Main:Submit, NoHide
        Gui, Main:Default
        If (Row := LV_GetNext()) {
            NRow := 0, TmpArr := []
            While (NRow != Row) {
                If (A_Index = 1)
                    NRow := Row
                If (NRow) {
                    LV_GetText(Bc, NRow, 1)
                    TmpArr.Push(Bc)
                }
                NRow := LV_GetNext(NRow)
            }
            If (TmpArr.MaxIndex() >= 2) {
                NotAlreadyDefined := 1
                For All, Things in TmpArr {
                    If (ProdDefs["" Things ""][5]) {
                        NotAlreadyDefined := 0
                        Break
                    }
                }
                StockedTogether := ""
                If (NotAlreadyDefined) {
                    SetQn := ProdDefs["" TmpArr[1] ""][4] ? ProdDefs["" TmpArr[1] ""][4] : 0
                    For Each, One in TmpArr {
                        StockedTogether .= "| " ProdDefs["" One ""][1] " |"
                        ProdDefs["" One ""][4] := SetQn
                        ProdDefs["" One ""][5] := AllButThis(TmpArr, One)
                    }
                    MsgBox, 64, Applied, The next list of products are added to the same stock option:`n`n%StockedTogether%`n`nStock = %SetQn%
                } Else {
                    For Each, One in TmpArr {
                        For _Each, _One in ProdDefs {
                            If InStr(_One[5], One) {
                                ProdDefs["" _Each ""][5] := RemoveBC(ProdDefs["" _Each ""][5], One)
                            }
                        }
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
#If

#If WinActive("ahk_id " Main)
Esc::
    If (RMS="#1") {
        GuiControlGet, Visi, Main:Visible, Nm
        If (!Visi) {
            GuiControl, Main:Hide, GivenMoney
            GuiControl, Main:Hide, AllSum
            GuiControl, Main:Hide, Change
            GuiControl, Main:Hide, CB
            GuiControl, Main:Show, Bc
            GuiControl, Main:Show, Nm
            GuiControl, Main:Show, Qn
            GuiControl, Main:Show, Sum
            GuiControl, Main:Show, Stck
        }
    }
Return
#If

#If WinActive("ahk_id " Main)
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

#If
    #If WinActive("ahk_id " Main)
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
#If

#If WinActive("ahk_id " Main) && (Level = "Admin")
Tab::
    If (RMS = "#1") {
        If (HLM := !HLM) {
            Loop, Parse, % "ItemsSold,SoldP,ProfitP", `,
                GuiControl, Main:Show, % A_LoopField
        } Else {
            Loop, Parse, % "ItemsSold,SoldP,ProfitP", `,
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
    Sleep, 125
Return
#If

#If WinActive("ahk_id " Main)
Enter::
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
        Level := ""
        If (!TU) {
            ShakeControl("Main", "TU")
            Return
        }
        If (!TP) {
            ShakeControl("Main", "TP")
            Return
        }
        EverythingSetting := StrSplit(DB_Read("Sets\Lc.lic"), ";")
        If (TU == EverythingSetting[2]) && (TP == EverythingSetting[3]) {
            GuiControl, Main:Hide, TU
            GuiControl, Main:+ReadOnly -Password +Left, TP
            CtlColors.Change(TP_, "80FF80", "008000")
            GuiControl, Main:, TP, % TU
            GuiControl, Main:Show, Reload

            Level := "Admin"
            Gosub, Continue
        } Else {
            If (OtherUsers := EverythingSetting[4]) {
                LOGSArray := {}
                Loop, % EverythingSetting.MaxIndex() - 3 {
                    UP := StrSplit(EverythingSetting[A_Index + 3], "/")
                    LOGSArray["" UP[1] ""] := "" UP[2] ""
                }
                If (LOGSArray["" TU ""] == TP) {
                    GuiControl, Main:Hide, TU
                    GuiControl, Main:+ReadOnly -Password +Left, TP
                    CtlColors.Change(TP_, "80FF80", "008000")
                    GuiControl, Main:, TP, % TU
                    GuiControl, Main:Show, Reload
                    Level := "User"
                    Gosub, Continue
                }
            }
        }
    } Else If (RMS = "#1") {
        GuiControl, Main:Disabled, Bc
        GuiControlGet, Visi, Main:Visible, Nm
        If (Visi) {
            GuiControl, Main:, Bc, % Bc "."
            Bc := Bc "."
            Loop, Parse, % Trim(Bc, "."), % "."
            {
                If (ProdDefs["" A_LoopField ""][1] != "") {
                    ThisQ := StrSplit(Qn, "x")[2]
                    JobDone := 0
                    Loop, % LV_GetCount() {
                        LV_GetText(ThisBc, A_Index, 1)
                        If (ThisBc = A_LoopField) {
                            LV_GetText(ThisQn, A_Index, 4)
                            ThisQn := StrSplit(ThisQn, "x")
                            LV_Modify(A_Index,,, ProdDefs["" A_LoopField ""][4] " --> " ProdDefs["" A_LoopField ""][4] - (ThisQn[2] + ThisQ),, ProdDefs["" A_LoopField ""][3] "x" ThisQn[2] + ThisQ, ProdDefs["" A_LoopField ""][3] * (ThisQn[2] + ThisQ))
                            JobDone := 1
                            Break
                        }
                    }
                    If (!JobDone)
                        LV_Add("", A_LoopField, ProdDefs["" A_LoopField ""][4] " --> " ProdDefs["" A_LoopField ""][4] - ThisQ, ProdDefs["" A_LoopField ""][1], ProdDefs["" A_LoopField ""][3] "x" ThisQ, ProdDefs["" A_LoopField ""][3]*ThisQ)
                    GuiControl, Main:, Bc
                }
            }
            GuiControl, Main:, Bc
            GuiControl, Main:, Qn, x1
        } Else {
            GuiControlGet, Visi, Main:Visible, CB
            If (Visi) {
                Gui, Main:Submit, NoHide
                Bc := SubStr(CB, InStr(CB, " ",, 0) + 1)
                GuiControl, Main:, Bc, % Trim(Bc, "[]")
            } Else {
                If (Change != "") {
                    If !InStr(FileExist("Curr\" TU), "D")
                        FileCreateDir, % "Curr\" TU
                    DB_Write("Curr\" TU "\" A_Now ".db", Sum_Data[2])
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

                    GuiControl, Main:, GivenMoney
                    GuiControl, Main:, AllSum
                    GuiControl, Main:, Change
                    GuiControl, Main:Hide, GivenMoney
                    GuiControl, Main:Hide, AllSum
                    GuiControl, Main:Hide, Change
                    GuiControl, Main:Show, Bc
                    GuiControl, Main:Show, Nm
                    GuiControl, Main:Show, Qn
                    GuiControl, Main:Show, Sum
                    GuiControl, Main:Show, Stck
                    GuiControl, Main:, Bc
                    GuiControl, Main:, Nm
                    GuiControl, Main:, Qn, x1
                    GuiControl, Main:, Sum
                    LV_Delete()
                    GuiControl, Main:Focus, Bc
                    If FileExist("Dump\" SessionID ".db")
                        FileDelete, % "Dump\" SessionID ".db"
                } Else {
                    ShakeControl("Main", "GivenMoney")
                }
            }
        }
        CheckListSum()
        GuiControl, Main:Enabled, Bc
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
            If (!EditMod[1]) {
                If (ProdDefs["" Dbc ""][1] = "") {
                    ProdDefs["" Dbc ""] := [Dnm,Dbp,Dsp,0,ProdDefs["" Dbc ""][5]]
                    UpdateProdDefs()
                    LoadDefined()
                    GuiControl, Main:, Dbc
                    GuiControl, Main:, Dnm
                    GuiControl, Main:, Dbp
                    GuiControl, Main:, Dsp
                    GuiControl, Main:Focus, Dbc
                } Else {
                    LoadDefined()
                    GuiControl, Main:Focus, LV2
                    SendInput, {Home}
                    Loop, % LV_GetCount() {
                        LV_GetText(ThisBar, A_Index, 1)
                        If (ThisBar = Dbc)
                            Break
                        SendInput, {Down}
                    }
                }
            } Else {
                Temp := ProdDefs.Clone()
                If (Dbc = EditMod[2])
                    Temp.Remove("" Dbc "")
                If (Temp["" Dbc ""][1] = "") {
                    Modify := 0
                    GuiControl, Main:Focus, LV2
                    SendInput, {Home}
                    Loop, % LV_GetCount() {
                        LV_GetText(ThisBar, A_Index, 1)
                        If (ThisBar = Dbc) {
                            Modify := 1
                            ProdDefs["" Dbc ""] := [Dnm,Dbp,Dsp,0,ProdDefs["" Dbc ""][5]]
                            Break
                        }
                        SendInput, {Down}
                    }
                    If (!Modify) {
                        SendInput, {Home}
                        Loop, % LV_GetCount() {
                            LV_GetText(ThisBar, A_Index, 1)
                            If (ThisBar = EditMod[2]) {
                                Modify := 1
                                ProdDefs.Delete("" EditMod[2] "")
                                ProdDefs["" Dbc ""] := [Dnm,Dbp,Dsp,0,ProdDefs["" Dbc ""][5]]
                                Break
                            }
                            SendInput, {Down}
                        }
                    }
                    If (Modify) {
                        UpdateProdDefs()
                        LV_Modify(LV_GetNext(),, Dbc, Dnm, Dbp, Dsp)
                        LoadDefined()
                        GuiControl, Main:Focus, LV2
                        SendInput, {Home}
                        Loop, % LV_GetCount() {
                            LV_GetText(ThisBar, A_Index, 1)
                            If (ThisBar = Dbc)
                                Break
                            SendInput, {Down}
                        }
                        GuiControl, Main:, Dbc
                        GuiControl, Main:, Dnm
                        GuiControl, Main:, Dbp
                        GuiControl, Main:, Dsp
                    }
                    EditMod[1] := 0
                } Else {
                    GuiControl, Main:Focus, LV2
                    SendInput, {Home}
                    Loop, % LV_GetCount() {
                        LV_GetText(ThisBar, A_Index, 1)
                        If (ThisBar = Dbc)
                            Break
                        SendInput, {Down}
                    }
                }
            }
        }
    } Else If (RMS = "#4") {
        GuiControlGet, ThisFocus, Main:FocusV
        If (ThisFocus = "Pnm") {
            Gui, Main:Submit, NoHide
            Gui, Main:Default
            If (Pnm != "") && (ProdDefs["" Pnm ""][1]) {
                GuiControl, Main:Focus, LV3
                SendInput, {Home}
                Loop, % LV_GetCount() - 1 {
                    LV_GetText(ThisBc, A_Index, 1)
                    If (ThisBc = Pnm) {
                        Gosub, DisplayQn
                        Break
                    }
                    SendInput, {Down}
                }
                GuiControl, Main:+Redraw, Pnm
                GuiControl, Main:+Redraw, Pqn
            }
    } Else If (ThisFocus = "Pqn") {
        If (Pnm != "") && (Pqn != "") {
            If Pqn is Digit
            {
                LV_GetText(BcId, Row, 1)
                ProdDefs["" BcId ""] := [ProdDefs["" BcId ""][1], ProdDefs["" BcId ""][2], ProdDefs["" BcId ""][3], Pqn, ProdDefs["" BcId ""][5]]
                If (ProdDefs["" BcId ""][5]) {
                    For Other, Bcs in StrSplit(ProdDefs["" BcId ""][5], "/") {
                        ProdDefs["" Bcs ""][4] := Pqn
                    }
                }
                UpdateProdDefs()
                LoadStockList()
            }
        }
    }
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
    } Else {
        SendInput, {Enter}
    }
    Sleep, 125
Return
#If

#If WinActive("ahk_id " Main)
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
            } Else {
                _Qn := SubStr(Qn, 1, InStr(Qn, "x") - 1)
                Qn := SubStr(Qn, InStr(Qn, "x") + 1)
                GuiControl, Main:, Qn, % _Qn "x" Qn += 1
            }
        }
        CreateNew("Bc,Nm,Qn,Sum,ThisListSum", "LV0")
        CheckListSum()
    } Else {
        SendInput, {Up}
    }
    Sleep, 125
Return
#If

#If WinActive("ahk_id " Main)
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
            } Else {
                _Qn := SubStr(Qn, 1, InStr(Qn, "x") - 1)
                Qn := SubStr(Qn, InStr(Qn, "x") + 1)
                If (Qn > 1)
                    GuiControl, Main:, Qn, % _Qn "x" Qn -= 1
            }
        }
        CreateNew("Bc,Nm,Qn,Sum,ThisListSum", "LV0")
        CheckListSum()
    } Else {
        SendInput, {Down}
    }
    Sleep, 125
Return
#If

#If WinActive("ahk_id " Main)
Delete::
    Gui, Main:Default
    Gui, Main:Submit, NoHide
    If (RMS = "#1") {
        LV_Delete(LV_GetNext())
        CreateNew("Bc,Nm,Qn,Sum,ThisListSum", "LV0")
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
#If
#If WinActive("ahk_id " Main)
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
            GuiControl, Main:Hide, Stck
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
#If

#If WinActive("ahk_id " Main)
^W::
    DB_Write(A_Desktop "\genFILE.db", Clipboard)
    Sleep, 125
Return
#If

#If WinActive("ahk_id " Main)
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
            ;GuiControl, Main:+Redraw, CB
        }
    } Else If (RMS = "#3") {
        Gui, Main:Submit, NoHide
        Gui, Main:Default
        LV_Delete()
        If (Dbc != "") || (Dnm != "") || (Dbp != "") || (Dsp != "") {
            For Each, Item in ProdDefs {
                If InStr(Each, Dbc) && InStr(Item[1], Dnm) && InStr(Item[2], Dbp) && InStr(Item[3], Dsp) {
                    LV_Add("", Each, Item[1], Item[2], Item[3])
                }
            }
        } Else {
            For Each, Item in ProdDefs {
                LV_Add("", Each, Item[1], Item[2], Item[3])
            }
        }
    } Else {
        SendInput, ^F
    }
    Sleep, 125
Return
#If

AnalyzeAvail:
    Gui, Main:Submit, NoHide
    GuiControl, Main:Hide, CB
    GuiControl, Main:, Stck
    GuiControl, Main:, Nm
    GuiControl, Main:, Sum
    Value_Qn := StrSplit(Qn, "x")
    GuiControl, Main:, Qn, % "x" Value_Qn[2]
    If (Bc) {
        If (ProdDefs["" Bc ""][1] != "") {
            GuiControl, Main:, Nm, % ProdDefs["" Bc ""][1]
            Value_Qn := StrSplit(Qn, "x")
            GuiControl, Main:, Qn, % ProdDefs["" Bc ""][3] "x" Value_Qn[2]
            GuiControl, Main:, Sum, % ProdDefs["" Bc ""][3] * Value_Qn[2]
            GuiControl, Main:, Stck, % (ProdDefs["" Bc ""][4]) ? ProdDefs["" Bc ""][4] : 0
        }
    }
    CreateNew("Bc,Nm,Qn,Sum,ThisListSum", "LV0")
Return
AnalyzeQn:
    Gui, Main:Submit, NoHide
    Value_Qn := StrSplit(Qn, "x")
    If (Value_Qn[1]) && (Value_Qn[2]) {
        GuiControl, Main:, Sum, % Value_Qn[1] * Value_Qn[2]
    }
    CreateNew("Bc,Nm,Qn,Sum,ThisListSum", "LV0")
Return
QuitMain:
    Gui, Main:Destroy
Return
QuitDefiner:
    Gui, Def:Destroy
Return
MainGuiClose:
Quit:
ExitApp
LoadCurrent() {
    global
    LV_Delete()
    OAPr := 0, SPr := 0, CP := 0
    Loop, Files, Curr\*.db
    {
        RD := DB_Read(A_LoopFileFullPath)
        If (RD) {
            SplitPath, % A_LoopFileName,,,, OutNameNoExt
            FormatTime, ThisTime, % OutNameNoExt, yyyy/MM/dd HH:mm:ss
            LV_Add("", A_LoopFileFullPath, _19 ": " ThisTime)
            Arr := CalcProfit(RD)
            SPr := Arr[2][1] + SPr
            CP := Arr[2][2] + CP
            OAPr := Arr[2][3] + OAPr
        }
    }
    If !LV_GetCount() {
        GuiControl, Main:Disabled, EnsBtn
    } Else {
        GuiControl, Main:, ProfitEq, % OAPr
        GuiControl, Main:, Sold, % SPr
        GuiControl, Main:, Bought, % CP
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
Return, [TimeDT, [RArr[1], RArr[2], RArr[3]], StrSplit(StrSplit(TrArr[2], ";")[3], "x")[2]]
}
Correct(File) {
    RD := DB_Read(File)
    Arr := StrSplit(RD, "> ")
    _DDS := StrSplit(Trim(Arr[2], "|"), "|")
    
    NC := "", SP := BP := OA := 0

    For Each, SO in _DDS {
        ;Msgbox % SO
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
    ;Msgbox, % RD "`n`n" Arr[1] "> " NC "> " SP ";" BP ";" OA
    DB_Write(A_LoopFileFullPath, Arr[1] "> " NC "> " SP ";" BP ";" OA)
}
LoadProf() {
    LV_Delete()
    OAPr := 0, SPr := 0, CP := 0
    DayAgo := A_Now
    DayAgo += -1, days
    Loop, Files, Valid\*.db, R F
    {
        If (SubStr(A_LoopFileName, 1, StrLen(A_LoopFileName) - 3) >= DayAgo) {
            RD := DB_Read(A_LoopFileFullPath)
            If (RD) {
                Arr := CalcProfit(RD)
                ;If (!Arr[2][2]) {
                ;    Correct(A_LoopFileFullPath)
                ;    RD := DB_Read(A_LoopFileFullPath)
                ;    Arr := CalcProfit(RD)
                ;}
                If (!Arr[2][1]) || (!Arr[2][1]) || (!Arr[2][3]) {
                    MsgBox, % A_LoopFileFullPath, % "Corrupted file: " A_LoopFileFullPath " `n" ClipBoard := RD
                } Else {
                    LV_Add("", A_LoopFileFullPath, Arr[1], "+ " Arr[2][1], "- " Arr[2][2], "+ " Arr[2][3])
                    SPr := Arr[2][1] + SPr
                    CP := Arr[2][2] + CP
                    OAPr := Arr[2][3] + OAPr
                }
            }
        }
    }
    Loop, Files, Curr\*.db
    {
        ;Correct(A_LoopFileFullPath)
        If (SubStr(A_LoopFileName, 1, StrLen(A_LoopFileName) - 3) >= DayAgo) {
            RD := DB_Read(A_LoopFileFullPath)
            If (RD) {
                Arr := CalcProfit(RD)
                ;If (!Arr[2][2]) {
                ;    Correct(A_LoopFileFullPath)
                ;    RD := DB_Read(A_LoopFileFullPath)
                ;    Arr := CalcProfit(RD)
                ;}
                LV_Add("", A_LoopFileFullPath, Arr[1], "+ " Arr[2][1], "- " Arr[2][2], "+ " Arr[2][3])
                SPr := Arr[2][1] + SPr
                CP := Arr[2][2] + CP
                OAPr := Arr[2][3] + OAPr
            }
        }
    }
    GuiControl, Main:, OAProfit, % OAPr
    GuiControl, Main:, SPr, % SPr
    GuiControl, Main:, CPr, % CP
}
LoadDefined() {
    global
    LV_Delete()
    AllItems := ""
    For Each, Item in ProdDefs {
        AllItems .= Each ","
    }
    Sort, AllItems, N D,
    Loop, Parse, % Trim(AllItems, ","), `,
        LV_Add("", A_LoopField, ProdDefs["" A_LoopField ""][1], ProdDefs["" A_LoopField ""][2], ProdDefs["" A_LoopField ""][3])
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
    Skipped := ""
    Loop, Parse, % Trim(AllItems, ","), `,
    {
        If ValidPro(A_LoopField, ProdDefs["" A_LoopField ""][1], ProdDefs["" A_LoopField ""][2], ProdDefs["" A_LoopField ""][3]) {
            LV_Add("", A_LoopField, ProdDefs["" A_LoopField ""][1], (ProdDefs["" A_LoopField ""][4] ? ProdDefs["" A_LoopField ""][4] : 0), Vale := ((ProdDefs["" A_LoopField ""][4] ? ProdDefs["" A_LoopField ""][4] : 0) "x" ProdDefs["" A_LoopField ""][2] " = " (ProdDefs["" A_LoopField ""][4] ? ProdDefs["" A_LoopField ""][4] : 0) * ProdDefs["" A_LoopField ""][2]))
            If (!InStr(Skipped, "/" A_LoopField) && !InStr(Skipped, A_LoopField "/")) {
                OverAll := OverAll + (ProdDefs["" A_LoopField ""][4] * ProdDefs["" A_LoopField ""][2])
            } Else {
                LV_Modify(A_Index,,,,, Vale " [Skipped]")
            }
            If (ProdDefs["" A_LoopField ""][5]) {
                Skipped .= ProdDefs["" A_LoopField ""][5] "/"
            }
            Counted := Counted + 1
        }
    }
    If (OverAll) && (Counted)
        GuiControl, Main:, StockSum, % OverAll " | [" Counted "]"
    Else
        GuiControl, Main:, StockSum, % "---"
    GuiControl, Main:, Pqn
    GuiControl, Main:, Psum
    GuiControl, Main:Focus, Pnm
    PostMessage, 0xB1, 0, -1,, % "ahk_id " Pnm_
}
ValidPro(_1, _2, _3, _4) {
    Rs := 1
    If (_1 = "") || (_2 = "") || (_3 _4 ~= "[^0-9]")
        Rs := 0
Return, Rs
}
LoadInterfaceLng() {
    global
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
WM_LBUTTONDOWN:
    PostMessage 0xA1, 2
Return
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
        LV_GetText(ThisSum, A_Index, 5)
        Sum += ThisSum
        LV_GetText(Bc, A_Index, 1)
        LV_GetText(Nm, A_Index, 3)
        LV_GetText(Qn, A_Index, 4)
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
    SetTimer, Update, Off
    MsgBox, % FileName
    If InStr(FileName, "\PD.db")
        FileCopy, % FileName, % "Sets\Bu\" A_Now ".Bu"
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
DB_Read(FileName) {
    SetTimer, Update, Off
    DBObj := FileOpen(FileName, "r")
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
    SetTimer, Update, On
Return, Decode(Info)
}
Hide(ListCtrl) {
    Loop, Parse, ListCtrl, `,
    {
        GuiControl, Main:Hide, % StrReplace(A_LoopField, "$")
    }
}
Show(ListCtrl) {
    global
    Loaded := 0
    WinGetPos,,, Width,, % "ahk_id " Main
    Loop, Parse, ListCtrl, `,
    {
        If !InStr(A_LoopField, "$") {
            GuiControlGet, Post, Main:Pos, % A_LoopField
            GuiControl, Main:Move, % A_LoopField, % "x" PostX + Width
            GuiControl, Main:Show, % A_LoopField
        }
        LT := Width // 4, J := 4
        If !InStr(A_LoopField, "OpenSess") {
            Loop, % LT {
                If !InStr(A_LoopField, "$") {
                    GuiControlGet, Post, Main:Pos, % A_LoopField
                    GuiControl, Main:Move, % A_LoopField, % "x" PostX - J
                }
            }
        } Else {
            Loop, % LT // 2 {
                If !InStr(A_LoopField, "$") {
                    GuiControlGet, Post, Main:Pos, % A_LoopField
                    GuiControl, Main:Move, % A_LoopField, % "x" PostX - J * 2
                }
            }
        }
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
    Folders := "Curr,Lib,Sets,Sets\Bu,Stoc,Valid,Dump"
    Loop, Parse, Folders, `,
    {
        If !InStr(FileExist(A_LoopField), "D") {
            FileCreateDir, % A_LoopField
        }
    }
}
LoadBackground() {
    global
    Loop, Files, % "Img\Prt*.png"
    {
        Name := SubStr(A_LoopFileName, 1, StrLen(A_LoopFileName) - 4)
        Set := StrSplit(Name, "_")
        PosArr := StrSplit(Set[2], "x")
        DemArr := StrSplit(Set[3], "x")
        If (A_Index = 5)
            Gui, Main:Add, Picture, % "x" PosArr[1] " y" PosArr[2] " w" DemArr[1] " h" DemArr[2] " v" Set[1] " gWM_LBUTTONDOWN", % "Img\" A_LoopFileName
        Else
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
                    LV_Add("", CtlVals[1], CtlVals[2], CtlVals[3], CtlVals[4], CtlVals[5])
                }
            }
        }
    }
    CheckListSum()
}
LoadDefinitions(Data) {
    Tmp := {}
    Loop, Parse, % Trim(Data, "|"), |
    {
        ThisDef := StrSplit(A_LoopField, ";")
        Tmp["" ThisDef[1] ""] := [ThisDef[2], ThisDef[3], ThisDef[4], ThisDef[5], ThisDef[6] ? ThisDef[6] : ""]
    }
Return, Tmp
}
CheckForUpdates() {
    global
    GuiControl, Startup:, Stat, % _23
    JsonKey := "{"
    . "`n ""type"": ""service_account"","
    . "`n ""project_id"": ""cassier"","
    . "`n ""private_key_id"": ""a4dcb0edcb51cfb9109fffcaf9087ad77d5b89ed"","
    . "`n ""private_key"": ""-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQC1025anDEc9hjY\nRlaQaJ6azis+uYSbl52g4S2beQ8L0CWy3ODiECrXGclV+KuHULDQGZcqKL1zDPZ4\n2P/77Et6Mr+tUqMBfV3AgWbNsvF0zfpv8c7/Oa068wV9vlzRckZK9fSJ19kdxYlf\ns7ZxeJiYndo1WD17ZUh0WElMO7eGQN7Ntgjj5Zkn5ARpBUlCVo5Ou2YItaLz0jty\nuA762PVW+GK0kv5vfXLbPNHZ35VY0RbaIPakEaeQKEC0lRNv1omiQV8DwkqPjNLD\nkCFfV2yQ+cNUNhv610r1Z79gPIcC2+bNg3DiFXuyE5iU6p78wpdZhLChYx7rVjrA\nE8sG1QrJAgMBAAECggEAEAiWCk+l29yhrtSioB2LOuU9fMyY/0Vv5RAzC6r+fJEW\nxr57TPcvzlCb55GQwqAHCQ3wpAsvclx59+8ewThovkMiXuZsffgJn+BpUDzcb1Hi\nKL2LsaFRTGNb7RovwiWcqDiNhbUIeshNoShOSS3hIVG6770ZWTvCfcWMdR7HXYNN\nqfb3CKlWw8eFfnrOu5nnuUcouSIPu9Neow7rXT5xZGQpNQ3AbhacHVXf7LMCXUKH\nKsWi5n+/QsYiuX+R9avksI81/14Pt1FZI8+dUVZj17exSlz8WOGF91CPEAQxIuxv\nDOxBYIOQFCKoJU22baymuGO7g86WO9I9d9uyb8dwJwKBgQDuu8+RA9OHnP+TFViw\nT3TD+VtQz5HWeW5dpLHp6rTOZLe2CBnzORYMPbZPni4Oqo0G5NEBtdiRWEj43Sjx\nK/Xpyar/Vzj0jMkHpFHmsjrZtblTdl0L94iGgfPuCrU3er4P073TjZuhJQoazZSn\n8PUMR8uGoncd431O/CAOI9HR0wKBgQDC+fcLYozcNR18XsQopSxtHCuTs7Gy1bWY\n2ZePMnr5R0eJSKQoycjXkDAaiujGjyWtbVzsgzBrZsmy7MYoPlQ733wIKSJPOI1w\nExysKy6fEabn3b8/+bEmccE04FCXjMuzL2cYzUqXza7waMDl3RixvBkks1LX6vCe\n4NTKsyZzcwKBgHsExpn4eckZCs3VIyV/XDEcToTe4Uy+uDODCbb7Hf55Af3IQO8H\njKf0KPzwCtW95vwVbupNtXJ4JuoutMlKGOdG51m6rXu/DFxmvVl+oDrNnNk4Vgwz\nmuONFZClbepP0p6/QsM/5mFsf79+DktYLD4OxP70uyLotgq8exwuMxHHAoGAFboT\nHHKr7bIBiiVpSHo3fCUiegARMjN8W/8LU4q1h2e5AgRVPrJVrifEJIEMNWwoL647\nJ6Pq1l0K5uRZpIxliJJ72ND0oM1VfYKztD/PnywxZC8iq7dgVT9h30mL0Yd//4St\nwWbHBCmIcAPMUxETOmMSjjNpbOQiUiINtFTIWR8CgYAUCKpuI3Azrj12mQiWl4gB\npKf9ejar0BZI6wnPkw+kiBz69arPSImQ2kmD/1zNr2T/ls+BJtaBC8pT4DsY9R/t\no+lOahSqIv9FTl0BpzFUq7oYcV6a0J4OwMYDofMrOii/qlLK3o1OMV8Kj9UfjZg7\nIv1i7pY9Baq81qbosT+cJQ==\n-----END PRIVATE KEY-----\n"","
    . "`n ""client_email"": ""firebase-adminsdk-nwpgf@cassier.iam.gserviceaccount.com"","
    . "`n ""client_id"": ""112531104458713251383"","
    . "`n ""auth_uri"": ""https://accounts.google.com/o/oauth2/auth"","
    . "`n ""token_uri"": ""https://oauth2.googleapis.com/token"","
    . "`n ""auth_provider_x509_cert_url"": ""https://www.googleapis.com/oauth2/v1/certs"","
    . "`n ""client_x509_cert_url"": ""https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-nwpgf`%40cassier.iam.gserviceaccount.com"""
    . "`n}"
    SetWorkingDir, Update
    If FileExist("LogKey.Json")
        FileDelete, LogKey.Json
    FileAppend, % JsonKey, LogKey.Json
    RunWait, Updater.exe r "AppVer",, Hide
    FileDelete, LogKey.Json
    Lastest := ""
    FileRead, Lastest, Version.txt
    If (!Lastest)
        Return
    FileDelete, Version.txt
    SetWorkingDir, % A_ScriptDir
    If !InStr(Lastest, ".")
        Lastest := Lastest ".0"
    IniRead, Current, Setting.ini, Version, AppVer
    If (Lastest > Current) {
        GuiControl, Startup:, Stat, % _24
        MsgBox, 36, % _20 " " Lastest, % _21 " " Lastest "?"
        IfMsgBox, Yes
        {
            GuiControl, Startup:, Stat, % _25
            SetWorkingDir, Update
            If FileExist("DL.txt")
                FileDelete, DL.txt
            If FileExist("LogKey.Json")
                FileDelete, LogKey.Json
            FileAppend, % JsonKey, LogKey.Json
            RunWait, Updater.exe dn "/",, Hide
            FileDelete, LogKey.Json
            FileRead, DL, DL.txt
            FileDelete, DL.txt
            DownloadFile(DL, "Cassier-Update.zip")
        }
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
        SetTimer, __UpdateProgressBar, 1000
    }
    UrlDownloadToFile, % URL, % SaveFileAs
    If (UseProgressBar) {
        SetTimer, __UpdateProgressBar, Off
        File.Close()
        If FileExist("Dest.txt")
            FileDelete, Dest.txt
        FileAppend, % A_ScriptDir, Dest.txt
        Run, Apply.exe
        ExitApp
    }
Return
}
__UpdateProgressBar:
    CurrentSize := File.Length
    LastSizeTick := CurrentSizeTick
    LastSize := CurrentSize
    PercentDone := Round(CurrentSize/FinalSize*100)
    GuiControl, Startup:, UPProg, % PercentDone
    GuiControl, Startup:, Stat, % PercentDone " % - " _26
Return
CheckForUpdatesStat() {
    IniRead, Stat, Setting.ini, Update, Upt
    If (Stat = "ERROR")
        Stat := 0
Return, Stat
}
MouseHover() {
    global
    If !GetKeyState("F1") {
        If (A_GuiControl = "LV1" || A_GuiControl = "LV4") {
            If (RMS = "#2")
                Gui, Main:ListView, LV1
            Else
                Gui, Main:ListView, LV4
            If (Row := LV_GetNext()) {
                If (!ShowTT) {
                    MouseGetPos, X, Y
                    X += 20
                    Y += 10
                    HH := A_ScreenHeight // 2
                    Gui, ReIn:Show, NoActivate x%X% y%Y% w800 h%HH%
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
                        Result .= " Name: " DI[2] "`n Sold Price: " DI[3] "=" DI[4] "`n Buy Price: " DI[5] "=" DI[6] "`n Profit Made: " DI[7] "`n=====================================================================`n"
                        AllProf := AllProf + DI[7]
                    }
                    Result .= "`n OverAll Profit: " AllProf
                    GuiControl, ReIn:, DInfo, % Result
                    ThisLoaded := Row
                }
                MouseGetPos, X, Y
                X += 20
                Y += 10
                HH := A_ScreenHeight // 2
                Gui, ReIn:Show, NoActivate x%X% y%Y% h%HH%
            } Else If (ShowTT) {
                Gui, ReIn:Hide
                ShowTT := 0
            }
        } Else If (ShowTT) {
            Gui, ReIn:Hide
            ShowTT := 0
        }
    }
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
        LV_GetText(ThisLSum, A_Index, 5)
        Everything += ThisLSum
    }
    If (Everything) {
        GuiControl, Main:, ThisListSum, % Everything
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