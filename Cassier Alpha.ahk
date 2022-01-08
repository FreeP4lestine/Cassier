#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%

#Include, <Class_CtlColors>
#Include, <Class_ImageButton>
#Include, <UseGDIP>
#Include, <Class_LVColors>

OnMessage(0x201, "WM_LBUTTONDOWN")

LoadInterfaceLng()

GreenBTN := [[0, 0xFFFFFF, , 0x008000, 0, , 0x008000, 1]
, [0, 0x008000, , 0xFFFFFF, 0, , 0x008000, 1]
, [0, 0x008000, , 0xFFFF00, 0, , 0x008000, 1]
, [0, 0x6C7174, , 0x000000, 0, , 0xFFFFFF, 1]]

RedBTN := [[0, 0xFFFFFF, , 0xFF0000, 0, , 0xD43F3A, 1]
, [0, 0xFF0000, , 0xFFFFFF, 0, , 0xD43F3A, 1]
, [0, 0xFF0000, , 0xFFFF00, 0, , 0xD43F3A, 1]
, [0, 0x6C7174, , 0x000000, 0, , 0xFFFFFF, 1]]

LMBTN := [[0, 0xCCCCCC, , 0x000000, 0, , 0x804000, 2]
, [0, 0x3EB2FD, , 0xFFFFFF, 0, , 0x804000, 2]
, [0, 0x3EB2FD, , 0xFF0000, 0, , 0x804000, 2]
, [0, 0x804000, , 0xFFFFFF, 0, , 0x804000, 2]]

EBTN := [[0, 0xC6E6C6, , , 0, , 0x5CB85C, 5]
, [0, 0x91CF91, , , 0, , 0x5CB85C, 5]
, [0, 0x5CB85C, , , 0, , 0x5CB85C, 5]
, [0, 0xF0F0F0, , , 0, , 0x5CB85C, 5]]

;==============================================================================

Gui, Main:-Caption +HwndMain MinSize1000x500
Gui, Main:Font, s10 Bold, Calibri
Gui, Main:Color, 0xB2DBC9
LoadBackground()

Gui, Main:Add, Text, x0 y0 w1000 h10 HwndTopText vTText
CtlColors.Attach(TopText, "80FF80", "000000")

Gui, Main:Add, Text, xm+75 ym+446 w50 BackgroundTrans c800000 vVer, % "v" Version()

If !CheckLicense() {
    Gui, Main:Add, Picture, x0 y10 vLicPic, Img\Lic.png
    Gui, Main:Add, Edit, xm+205 ym+135 w760 vEPassString Center
    Gui, Main:Add, Text, xm+205 ym+165 w760 vPassString Center BackgroundTrans, Please enter the KeyString
    RMS := "#0"
    Gui, Main:Show, w1000 h500
    Return
}

OpenApp:
Gui, Main:+Resize
Gui, Main:Font, s13
Gui, Main:Add, Button, x0 y10 HwndBtn w199 h40 gOpenMain Disabled vBtn1, % _4
ImageButton.Create(Btn, LMBTN*)

Gui, Main:Add, Button, x0 y90 HwndBtn w199 h40 gDefine vBtn2, % _5
ImageButton.Create(Btn, LMBTN*)

Gui, Main:Add, Button, x0 y130 HwndBtn w199 h40 gStockPile vBtn3, % _6
ImageButton.Create(Btn, LMBTN*)

Gui, Main:Add, Button, x0 y170 HwndBtn w199 h40 gProf vBtn4, % _7
ImageButton.Create(Btn, LMBTN*)

Gui, Main:Add, Button, x0 y50 HwndBtn w199 h40 gSubmit vBtn5, % _8
ImageButton.Create(Btn, LMBTN*)


Gui, Main:Font, s25, Consolas
Gui, Main:Add, Edit, xm y500 HwndE w175 vItemsSold -E0x200 ReadOnly Center Border, 0
CtlColors.Attach(E, "B2DBC9", "0000FF")

Gui, Main:Add, Edit, xm y528 HwndE w175 vSoldP -E0x200 ReadOnly Center Border, 0
CtlColors.Attach(E, "B2DBC9", "000000")

Gui, Main:Add, Edit, xm y556 HwndE w175 vProfitP -E0x200 ReadOnly Center Border, 0
CtlColors.Attach(E, "B2DBC9", "FF0000")

; Main Controls
RMS := "#1"
MainCtrlList := "Bc,Nm,Qn,Sum,LV0,$GivenMoney,$AllSum,$Change"
Gui, Main:Font, s25, Calibri
Gui, Main:Add, Edit, xm+460 ym+10 w250 vBc Center -E0x200 gAnalyzeAvail Border HwndBc_ Hidden
CtlColors.Attach(Bc, "FFFFFF", "008000")
Gui, Main:Add, Edit, xm+455 ym+70 w260 vQn Center -E0x200 ReadOnly HwndQn gAnalyzeQn Hidden, x1
CtlColors.Attach(Qn, "E6E6E6", "008000")
Gui, Main:Add, Edit, xm+205 ym+70 w250 vNm -E0x200 ReadOnly HwndNm Center Hidden
CtlColors.Attach(Nm, "E6E6E6", "000080")
Gui, Main:Add, Edit, xm+715 ym+70 w250 vSum -E0x200 ReadOnly HwndSum Center Hidden
CtlColors.Attach(Sum, "E6E6E6", "800000")
Gui, Main:Font, s50
Gui, Main:Add, Edit, xm+205 ym+10 w254 vGivenMoney -E0x200 gCalc Center Hidden
Gui, Main:Add, Edit, xm+460 ym+10 w254 vAllSum HwndAS -E0x200 ReadOnly Center Hidden
CtlColors.Attach(AS, "E6E6E6", "008000")
Gui, Main:Add, Edit, xm+715 ym+10 w252 vChange HwndC -E0x200 ReadOnly Center Hidden
CtlColors.Attach(C, "E6E6E6", "FF0000")
Gui, Main:Font, s15
Gui, Main:Add, ListView, xm+205 ym+135 w760 r10 -Hdr Grid vLV0 Hidden, Barcode|Name|Quantity|Price

Gui, Main:Default
Gui, Main:ListView, LV0
LV_ModifyCol(1, "0 Center")
LV_ModifyCol(2, "250 Center")
LV_ModifyCol(3, "254 Center")
LV_ModifyCol(4, "252 Center")
; ==========================================================================================================

; Ensure Dot Controls
EnsureCtrlList := "LV1,EnsBtn,Sold,Bought,ProfitEq"
Gui, Main:Font, s25
Gui, Main:Add, Button, xm+205 ym+30 vEnsBtn w760 h80 hwndBtn Hidden gValid, % _9
ImageButton.Create(Btn, EBTN*)
Gui, Main:Font, s15
Gui, Main:Add, ListView, xm+205 ym+135 w760 r10 -Hdr Grid vLV1 Hidden, SO

Gui, Main:Default
Gui, Main:ListView, LV1
LV_ModifyCol(1, "w760 Center")

Gui, Main:Font, s40
Gui, Main:Add, Edit, xm+206 ym+430 w260 vSold Center -E0x200 ReadOnly HwndE gAnalyzeQn Hidden
CtlColors.Attach(E, "FFFFFF", "FF0000")
Gui, Main:Add, Edit, xm+456 ym+430 w260 vBought -E0x200 ReadOnly HwndE Center Hidden
CtlColors.Attach(E, "FFFFFF", "000000")
Gui, Main:Add, Edit, xm+716 ym+430 w260 vProfitEq -E0x200 ReadOnly HwndE Center Hidden
CtlColors.Attach(E, "FFFFFF", "008000")

; ==========================================================================================================

; Define Controls
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
Gui, Main:Add, ListView, xm+205 ym+135 w760 r10 -Hdr Grid vLV2 c0x0000FF Hidden gEdit, Barcode|Name|Quantity|Price

Gui, Main:Default
Gui, Main:ListView, LV2
LV_ModifyCol(1, "185 Center")
LV_ModifyCol(2, "192 Center")
LV_ModifyCol(3, "192 Center")
LV_ModifyCol(4, "186 Center")
; ==========================================================================================================

; StockPile Controls
StockPileCtrlList := "Pnm,Pqn,LV3"
Gui, Main:Font, s25
Gui, Main:Add, Edit, xm+205 ym+50 w380 Right ReadOnly vPnm HwndPnm_ -E0x200 Hidden
CtlColors.Attach(Pnm_, "E6E6E6", "000000")
Gui, Main:Add, Edit, xm+585 ym+50 w380 Left vPqn HwndPqn_ -E0x200 Hidden
CtlColors.Attach(Pqn_, "E6E6E6", "0000FF")
Gui, Main:Font, s15
Gui, Main:Add, ListView, xm+205 ym+135 w760 r10 -Hdr Grid vLV3 c0xFF0000 gDisplayQn Hidden, Barcode|Name|Quantity

Gui, Main:Default
Gui, Main:ListView, LV3
LV_ModifyCol(1, "0 Center")
LV_ModifyCol(2, "377 Right")
LV_ModifyCol(3, "380 Left")
; ==========================================================================================================

; Profit Controls
ProfitCtrlList := "SPr,CPr,OAProfit,LV4"
Gui, Main:Font, s15

Gui, Main:Add, ListView, xm+205 ym+135 w760 r10 -Hdr Grid vLV4 c0x008000 gDisplayQn Hidden, Date|BP|SP|Pr

Gui, Main:Add, Edit, xm+776 ym+90 -E0x200 ReadOnly vOAProfit w189 Hidden Center cRed Border HwndE
CtlColors.Attach(E, "80FF00", "000000")
Gui, Main:Add, Edit, xm+586 ym+90 -E0x200 ReadOnly vCPr w189 Hidden Center cRed Border HwndE
CtlColors.Attach(E, "FF8080", "000000")
Gui, Main:Add, Edit, xm+396 ym+90 -E0x200 ReadOnly vSPr w189 Hidden Center cRed Border HwndE
CtlColors.Attach(E, "80FF00", "000000")

Gui, Main:Default
Gui, Main:ListView, LV4
LV_ModifyCol(1, "189 Center")
LV_ModifyCol(2, "189 Center")
LV_ModifyCol(3, "189 Center")
LV_ModifyCol(4, "189 Center")
; ==========================================================================================================

Gui, Main:Default
Gui, Main:ListView, LV0

Gui, Main:Show, % "x" 5 " y" 0 " w" A_ScreenWidth - 20 " h" A_ScreenHeight - 55

ProductBase := DB_Read("Sets\PD.db")
CheckFoldersSet()

Loop, Parse, % "2435"
    GuiControl, Main:Enabled, Btn%A_LoopField%
Hide(EnsureCtrlList "," DefineCtrlList "," StockPileCtrlList "," ProfitCtrlList)
GuiControl, Main:Disabled, Btn1
Show(MainCtrlList)
RMS := "#1"
Gui, Main:ListView, LV0

LastMDate := ""
Table := ["A", "B", "C", "D", "E", "F"]
SetTimer, Update, 250
Return

:*C:LetAppRunOnThisMachine::
    ADMUsername := ADMPassword := ""
    GuiControl, Main:, PassString, Create ADM username
Return

MainGuiSize:
    WinGetPos,,, Width, Height, % "ahk_id " Main
    Height -= 10
    GuiControl, Main:Move, % "TText", % "w" Width
    GuiControl, Main:Move, % "Prt1", % "y" Height - 55 " w" Width - 199
    GuiControl, Main:Move, % "Prt2", % "y" Height - 55
    GuiControl, Main:Move, % "Prt3", % "y" Height - 60 " w" Width
    GuiControl, Main:Move, % "Prt4", % " h" Height - 70
    Loop, 4 {
        GuiControl, Main:+Redraw, % "Prt" A_Index
    }

    Width -= 30
    GuiControl, Main:Move, % "Ver", % "y" Height - 47
    GuiControl, Main:+Redraw, % "Ver"

    InitY := 126
    GuiControl, Main:Move, % "ItemsSold", % "y" Height - InitY - (50 * 2)
    GuiControl, Main:Move, % "SoldP", % "y" Height - InitY - 50
    GuiControl, Main:Move, % "ProfitP", % "y" Height - InitY
    GuiControl, Main:+Redraw, % "ItemsSold"
    GuiControl, Main:+Redraw, % "SoldP"
    GuiControl, Main:+Redraw, % "ProfitP"

    Third := (Width - 217) // 3

    If (RMS = "#1") {
    ; #1
        GuiControl, Main:Move, % "Bc", % "x" Third + 217 " w" Third
        GuiControl, Main:Move, % "Nm", % "w" Third
        GuiControl, Main:Move, % "Qn", % "x" Third + 217 " w" Third
        GuiControl, Main:Move, % "Sum", % "x" (Third * 2) + 217 " w" Third

        GuiControl, Main:Move, % "LV0", % "w" (Third * 3) " h" Height - 220
        Gui, Main:ListView, LV0
        LV_ModifyCol(2, (Val := Third) - 1)
        LV_ModifyCol(3, Val - 2)
        LV_ModifyCol(4, Val - 1)

        GuiControl, Main:Move, % "GivenMoney", % "w" Third
        GuiControl, Main:Move, % "AllSum", % "x" Third + 217 " w" Third
        GuiControl, Main:Move, % "Change", % "x" (Third * 2) + 217 " w" Third
    } Else If (RMS = "#2") {
    ; #2
        GuiControl, Main:Move, % "EnsBtn", % "w" (Third * 3)
        GuiControl, Main:, % "EnsBtn", % _9
        GuiControlGet, Btn, Main:Hwnd, EnsBtn
        ImageButton.Create(Btn, EBTN*)
        GuiControl, Main:+Redraw, % "EnsBtn"
        GuiControl, Main:Move, % "LV1", % "w" (Third * 3) " h" Height - 300
        Gui, Main:ListView, LV1
        LV_ModifyCol(1, (Third * 3) - 5)

        GuiControl, Main:Move, % "Sold", % "y" Height - 150 " w" Third
        GuiControl, Main:Move, % "Bought", % "x" Third + 217 " y" Height - 150 " w" Third
        GuiControl, Main:Move, % "ProfitEq", % "x" (Third * 2) + 217 " y" Height - 150 " w" Third

    } Else If (RMS = "#3") {
    ; #3
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
    ; #4
        Half := (Width - 217) // 2
        GuiControl, Main:Move, % "Pnm", % "w" Half
        GuiControl, Main:Move, % "Pqn", % "x" Half + 217 " w" Half
        GuiControl, Main:Move, % "LV3", % "w" (Half * 2) " h" Height - 220

        Gui, Main:ListView, LV3
        LV_ModifyCol(2, (Val := Half) - 3)
        LV_ModifyCol(3, Val)
    } Else If (RMS = "#5") {
    ; #4
        Quarter := (Width - 217) // 4
        ; SPr,CPr,OAProfit
        GuiControl, Main:Move, % "SPr", % "x" Quarter + 217 " w" Quarter
        GuiControl, Main:Move, % "CPr", % "x" (Quarter * 2) + 217 " w" Quarter
        GuiControl, Main:Move, % "OAProfit", % "x" (Quarter * 3) + 217 "w" Quarter

        GuiControl, Main:Move, % "LV4", % "w" (Quarter * 4) " h" Height - 220
        Gui, Main:ListView, LV4
        LV_ModifyCol(1, (Val := Quarter) - 3)
        LV_ModifyCol(2, Val)
        LV_ModifyCol(3, Val)
        LV_ModifyCol(4, Val - 1)
    }
Return

Update:
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

    If (RMS = "#1") {
        GuiControlGet, Visi, Main:Visible, Nm
        If (Visi) {
            GuiControlGet, Foc, Main:Focus
            If !(Foc ~= "Edit1|SysListView321|Button") {
                GuiControl, Main:Focus, Bc
            }
        }
    }
    ;CtlColors.Change(TopText, RandomHexColor(), "000000")
Return

OpenMain:
    RMS := "#1"
    Gosub, MainGuiSize
    Loop, Parse, % "2435"
        GuiControl, Main:Enabled, Btn%A_LoopField%
    Hide(EnsureCtrlList "," DefineCtrlList "," StockPileCtrlList "," ProfitCtrlList)
    GuiControl, Main:Disabled, Btn1
    Show(MainCtrlList)
    Gui, Main:ListView, LV0
Return

Submit:
    RMS := "#2"
    Gosub, MainGuiSize
    Loop, Parse, % "1234"
        GuiControl, Main:Enabled, Btn%A_LoopField%
    Hide(MainCtrlList "," DefineCtrlList "," StockPileCtrlList "," ProfitCtrlList)
    GuiControl, Main:Disabled, Btn5
    Show(EnsureCtrlList)
    Gui, Main:ListView, LV1
    GuiControl, Main:Enabled, EnsBtn
    LoadCurrent()
Return

Define:
    RMS := "#3"
    Gosub, MainGuiSize
    Loop, Parse, % "1435"
        GuiControl, Main:Enabled, Btn%A_LoopField%
    Hide(MainCtrlList "," EnsureCtrlList "," StockPileCtrlList "," ProfitCtrlList)
    GuiControl, Main:Disabled, Btn2
    Show(DefineCtrlList)
    Gui, Main:ListView, LV2
    LoadDefined()
Return

StockPile:
    RMS := "#4"
    Gosub, MainGuiSize
    Loop, Parse, % "1245"
        GuiControl, Main:Enabled, Btn%A_LoopField%
    Hide(MainCtrlList "," EnsureCtrlList "," DefineCtrlList "," ProfitCtrlList)
    GuiControl, Main:Disabled, Btn3
    Show(StockPileCtrlList)
    Gui, Main:ListView, LV3
    LoadStockList()
Return

Prof:
    RMS := "#5"
    Gosub, MainGuiSize
    Loop, Parse, % "1235" 
        GuiControl, Main:Enabled, Btn%A_LoopField%
    Hide(MainCtrlList "," EnsureCtrlList "," DefineCtrlList "," StockPileCtrlList)
    GuiControl, Main:Disabled, Btn4
    Show(ProfitCtrlList)
    Gui, Main:ListView, LV4
    LoadProf()
Return

Edit:
    LV_GetText(EBc, Row := LV_GetNext(), 1)
    EditMod := [1, Row]
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
    GuiControl, Main:, Msg
    GuiControl, Main:, Change
    If GivenMoney is not Digit
    {
        GuiControl, Main:, Msg, Warning: The given money input should not contain anything but digits!
        Return
    }
    If (GivenMoney > AllSum) {
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
    GuiControl, Main:, Pqn, % Sqn 
    GuiControl, Main:, Pnm, % Snm " :"
    SelectionQn := Sid
Return

ClearDbc:
    Gui, Main:Submit, NoHide
    CtlColors.Change(Dbc_, "FFFFFF", "000000")
    If (Dbc ~= "[^0-9]") {
        CtlColors.Change(Dbc_, "FF8080", "000000")
        ShakeControl("Main", "Dbc")
    }
Return

ClearDnm:
    Gui, Main:Submit, NoHide
    CtlColors.Change(Dnm_, "FFFFFF", "000000")
    If (Dnm ~= "\[|\]|\;|\$") {
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
Enter::
    Gui, Main:Submit, NoHide
    Gui, Main:Default

    If (RMS = "#0") {
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
            GoSub, OpenApp
        }
    } Else If (RMS = "#1") {
        GuiControlGet, Visi, Main:Visible, Nm
        If (Visi) {
            Filled := (Nm) && (Qn) && (Sum)
            If (Filled) {
                LV_Add("", Bc, Nm, Qn, Sum)
                GuiControl, Main:, Bc
            }
        } Else {
            DB_Write("Curr\" A_Now ".db", Sum_Data[2])
            Arr := StrSplit(Trim(StrSplit(Sum_Data[2], "> ")[2], "|"), "|")

            For Each, SO in Arr {

                ThisArr := StrSplit(SO, ";")
                ThisBc := ThisArr[1]
                ThisQn := StrSplit(ThisArr[3], "x")[2]
                
                RemoveFromStock(ThisBc, ThisQn)
            }

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

            GuiControl, Main:, Bc
            GuiControl, Main:, Nm
            GuiControl, Main:, Qn, x1
            GuiControl, Main:, Sum

            LV_Delete()
            GuiControl, Main:Focus, Bc

        }
    } Else If (RMS = "#3") {
        Filled := (Dbc) && (Dnm) && (Dbp) && (Dsp)
        If (Filled) {
            If Dbc is not Digit 
            {
                ShakeControl("Main", "Dbc")
                Return
            }
            If (Dnm ~= "\[|;|\]") 
            {
                ShakeControl("Main", "Dnm")
                Return
            }
            If Dbp is not Digit 
            {
                ShakeControl("Main", "Dbp")
                Return
            }
            If Dsp is not Digit 
            {
                ShakeControl("Main", "Dsp")
                Return
            }

            PrevData := ""
            If FileExist("Sets\PD.db") {
                PrevData := DB_Read("Sets\PD.db")
            }

            If ((!EditMod[1])) {
                If !InStr(PrevData, "|" Dbc) && (InStr(PrevData, Dbc) != 1) {
                    DB_Write("Sets\PD.db", PrevData "|" Dbc ";" Dnm ";" Dbp ";" Dsp)
                    LV_Add("", Dbc, Dnm, Dbp, Dsp)
                }
            } Else {
                Loop, Parse, PrevData, |
                {
                    If (Dbc = SubStr(A_LoopField, 1, InStr(A_LoopField, ";") - 1)) {
                        Elmts := StrSplit(A_LoopField, ";")
                        PrevData := StrReplace(PrevData, A_LoopField, Dbc ";" Dnm ";" Dbp ";" Dsp)
                        LV_Modify(EditMod[2],, Dbc, Dnm, Dbp, Dsp)
                        DB_Write("Sets\PD.db", PrevData)
                        Break
                    }
                }
            }
        }
    } Else If (RMS = "#4") {
        If (Pnm) {
            LV_GetText(BcId, LV_GetNext(), 1)
            LV_GetText(NmId, LV_GetNext(), 2)

            Data := DB_Read("Sets\PD.db")
            NewData := Data
            Loop, Parse, Data, |
            {
                If (SubStr(A_LoopField, 1, InStr(A_LoopField, ";")) = SelectionQn ";") {
                    Defs := StrSplit(A_LoopField, ";")
                    If !(Defs[5])
                        Defs[5] := 0
                    If (Pqn > Defs[5]) {
                        NewData := StrReplace(NewData, A_LoopField, Defs[1] ";" Defs[2] ";" Defs[3] ";" Defs[4] ";" Pqn)
                        DB_Write("Sets\PD.db", NewData)
                        LV_Modify(Row,,,, Pqn)
                    }
                    Break
                }
            }
        }
    } Else {
        SendInput, {Enter}
    }
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
                LV_GetText(ThisQn, Row := LV_GetNext(), 3)
                VQ := StrSplit(ThisQn, "x")
                LV_Modify(Row,,,, VQ[1] "x" VQ[2] + 1)
                LV_Modify(Row,,,,, VQ[1] * (VQ[2] + 1))
                Sleep, 125
            }
        } Else {
            _Qn := SubStr(Qn, 1, InStr(Qn, "x") - 1)
            Qn := SubStr(Qn, InStr(Qn, "x") + 1)
            GuiControl, Main:, Qn, % _Qn "x" Qn += 1
            Sleep, 125
        }
    } Else {
        SendInput, {Up}
    }
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
                LV_GetText(ThisQn, Row := LV_GetNext(), 3)
                VQ := StrSplit(ThisQn, "x")
                If (VQ[2] > 1) {
                    LV_Modify(Row,,,, VQ[1] "x" VQ[2] - 1)
                    LV_Modify(Row,,,,, VQ[1] * (VQ[2] - 1))
                }
                Sleep, 125
            }
        } Else {
            _Qn := SubStr(Qn, 1, InStr(Qn, "x") - 1)
            Qn := SubStr(Qn, InStr(Qn, "x") + 1)
            If (Qn > 1)
                GuiControl, Main:, Qn, % _Qn "x" Qn -= 1
            Sleep, 125
        }
    } Else {
        SendInput, {Down}
    }
Return
#If

#If WinActive("ahk_id " Main)
Delete::
    Gui, Main:Default
    Gui, Main:Submit, NoHide

    If (RMS = "#1") {
        LV_Delete(LV_GetNext())
    } Else If (RMS = "#3") {
        LV_GetText(ThisID, LV_GetNext(), 1)
        GetData := DB_Read("Sets\PD.db")

        NewData := ""
        Loop, Parse, GetData, |
        {
            If (SubStr(A_LoopField, 1, InStr(A_LoopField, ";") - 1) != ThisID)
                NewData .= A_LoopField "|"
        }

        DB_Write("Sets\PD.db", Trim(NewData, "|"))

        LV_Delete(LV_GetNext())
    } Else {
        SendInput, {Delete}
    }
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
            GuiControl, Main:Show, GivenMoney
            GuiControl, Main:Show, AllSum
            GuiControl, Main:Show, Change
            GuiControl, Main:, AllSum, % (Sum_Data := CalculateSum())[1]
            GuiControl, Main:Focus, GivenMoney
        }
    } Else {
        SendInput, {Space}
    }
Return
#If

AnalyzeAvail:
    Gui, Main:Submit, NoHide

    GuiControl, Main:, Nm
    GuiControl, Main:, Sum
    Value_Qn := StrSplit(Qn, "x")

    GuiControl, Main:, Qn, % "x" Value_Qn[2]

    CtlColors.Change(Bc_, "FFFFFF", "008000")
    If (Bc) {
        If Bc is not Digit
        {
            CtlColors.Change(Bc_, "FF8080", "008000")
            ShakeControl("Main", "Bc")
            Return
        }

        Data := DB_Read("Sets\PD.db")

        Loop, Parse, Data, |
        {
            If (SubStr(A_LoopField, 1, InStr(A_LoopField, ";")) = Bc ";") {
                Defs := StrSplit(A_LoopField, ";")
                GuiControl, Main:, Nm, % Defs[2]
                Value_Qn := StrSplit(Qn, "x")
                GuiControl, Main:, Qn, % Defs[4] "x" Value_Qn[2]
                GuiControl, Main:, Sum, % Defs[4] * Value_Qn[2]
                Break
            }
    }
}
Return

AnalyzeQn:
    Gui, Main:Submit, NoHide
    Value_Qn := StrSplit(Qn, "x")
    If (Value_Qn[1]) && (Value_Qn[2])
        GuiControl, Main:, Sum, % Value_Qn[1] * Value_Qn[2]
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
    LV_Delete()
    OAPr := 0, SPr := 0, CP := 0
    Loop, Files, Curr\*.db
    {
        RD := DB_Read(A_LoopFileFullPath)
        If (RD) {
            SplitPath, % A_LoopFileName,,,, OutNameNoExt
            FormatTime, ThisTime, % OutNameNoExt, yyyy/MM/dd HH:mm:ss
            LV_Add("", "Sell Operation Was Done At: " ThisTime)
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


LoadProf() {
    LV_Delete()
    ;LoadedBase := DB_Read("Sets\PD.db")
    OAPr := 0, SPr := 0, CP := 0

    Loop, Files, Valid\*.db, R F
    {
        RD := DB_Read(A_LoopFileFullPath)
        If (RD) {
            Arr := CalcProfit(RD)
            LV_Add("", Arr[1], "+ " Arr[2][1], "- " Arr[2][2], "+ " Arr[2][3])
            SPr := Arr[2][1] + SPr
            CP := Arr[2][2] + CP
            OAPr := Arr[2][3] + OAPr
        }
    }

    Loop, Files, Curr\*.db
    {
        RD := DB_Read(A_LoopFileFullPath)
        If (RD) {
            Arr := CalcProfit(RD)
            LV_Add("", Arr[1], "+ " Arr[2][1], "- " Arr[2][2], "+ " Arr[2][3])
            SPr := Arr[2][1] + SPr
            CP := Arr[2][2] + CP
            OAPr := Arr[2][3] + OAPr
        }
    }
    GuiControl, Main:, OAProfit, % OAPr
    GuiControl, Main:, SPr, % SPr
    GuiControl, Main:, CPr, % CP
}

LoadDefined() {
    Data := DB_Read("Sets\PD.db")
    LV_Delete()
    Loop, Parse, % Data, |
    {
        Defs := StrSplit(A_LoopField, ";")
        If (Defs.MaxIndex() >= 4)
            LV_Add("", Defs[1], Defs[2], Defs[3], Defs[4])
    }
}

LoadStockList() {
    LV_Delete()
    Data := DB_Read("Sets\PD.db")
    
    If (Data) {
        Loop, Parse, Data, |
        {
            Defs := StrSplit(A_LoopField, ";")
            If (Defs[5])
                LV_Add("", Defs[1], Defs[2], Defs[5])
            Else
                LV_Add("", Defs[1], Defs[2], 0)
        }
    }
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

WM_LBUTTONDOWN() {
    PostMessage 0xA1, 2
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
        LV_GetText(ThisSum, A_Index, 4)
        Sum += ThisSum
        
        LV_GetText(Bc, A_Index, 1)
        LV_GetText(Nm, A_Index, 2)
        LV_GetText(Qn, A_Index, 3)

        BP := GetBuyPriceByID(ProductBase, Bc)
        Qn_ := SubStr(Qn, InStr(Qn, "x") + 1)
        ThisCost := BP * Qn_
        Cost += ThisCost

        Data .= Bc ";" Nm ";" Qn ";" ThisSum ";" BP "x" Qn_ ";" ThisCost ";" ThisSum - ThisCost "|"
    }
    Data .= "> " Sum ";" Cost ";" Sum - Cost
Return, [Sum, Trim(Data, "|"), OutTime]
}

;2021/12/30 21:56:19> 5;7ajaO5ra;2000x3;6000;1000x3;3000;3000|3;Gaucho;400x5;2000;250x5;1250;750|1;Ticket;1250x2;2500;1000x2;2000;500|10;Ehhaa;400x5;2000;200x5;1000;1000|> 12500;7250;5250

DB_Write(FileName, Info) {
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
}

DB_Read(FileName) {
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
    WinGetPos,,, Width,, % "ahk_id " Main
    Loop, Parse, ListCtrl, `,
    {
        If !InStr(A_LoopField, "$") {
            GuiControlGet, Post, Main:Pos, % A_LoopField
            GuiControl, Main:Move, % A_LoopField, % "x" PostX + Width
        }

        If !InStr(A_LoopField, "$") {
            GuiControl, Main:Show, % A_LoopField
        }

        LT := Width // 4, J := 4

        Loop, % LT {
            If !InStr(A_LoopField, "$") {
                GuiControlGet, Post, Main:Pos, % A_LoopField
                GuiControl, Main:Move, % A_LoopField, % "x" PostX - J
            }
        }
    }
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
    Folders := "Curr,Lib,Sets,Stoc,Valid"
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

        Gui, Main:Add, Picture, % "x" PosArr[1] " y" PosArr[2] " w" DemArr[1] " h" DemArr[2] " v" Set[1], % "Img\" A_LoopFileName
    }
}

RemoveFromStock(BC, QN) {
    Data := ""
    For Index, Item in StrSplit(DB_Read("Sets\PD.db"), "|") {
        Line := Item
        ThisArr := StrSplit(Item, ";")
        If ((ThisBc := ThisArr[1]) = BC) {

            If (ThisArr[5] > QN)
                ThisArr[5] := ThisArr[5] - QN
            Else
                ThisArr[5] := 0
            Line := ThisArr[1] ";" ThisArr[2] ";" ThisArr[3] ";" ThisArr[4] ";" ThisArr[5]

        }
        Data .= Line "|"
    }
    DB_Write("Sets\PD.db", Trim(Data, "|"))
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