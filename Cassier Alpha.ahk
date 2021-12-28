#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%

#Include, <Class_CtlColors>
#Include, <Class_ImageButton>
#Include, <UseGDIP>

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

LMBTN := [[0, 0xCCCCCC, , 0x000000, 0, , 0xFFFFFF, 1]
, [0, 0x3EB2FD, , 0xFFFFFF, 0, , 0xFFFFFF, 1]
, [0, 0x3EB2FD, , 0xFF0000, 0, , 0xFFFFFF, 1]
, [0, 0x3EB2FD, , 0x000000, 0, , 0x3EB2FD, 1]]

EBTN := [[0, 0xC6E6C6, , , 0, , 0x5CB85C, 1]
, [0, 0x91CF91, , , 0, , 0x5CB85C, 1]
, [0, 0x5CB85C, , , 0, , 0x5CB85C, 1]
, [0, 0xF0F0F0, , , 0, , 0x5CB85C, 1]]

;==============================================================================

Gui, Main:-Caption +HwndMain
Gui, Main:Add, Picture, x0 y0 w1000 h500, Img\bg.png

Gui, Main:Font, s10 Bold, Calibri
Gui, Main:Add, Button, xm+865 ym+465 w100 h20 HwndBtn gQuit, % _3
ImageButton.Create(Btn, RedBTN*)

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

; Main Controls
RMS := "#1"
MainCtrlList := "Bc,Qn,Nm,Sum,LV0,$GivenMoney,$AllSum,$Change"
Gui, Main:Font, s25
Gui, Main:Add, Edit, xm+460 ym+10 w250 vBc Center -E0x200 gAnalyzeAvail Border HwndBc_
CtlColors.Attach(Bc, "FFFFFF", "008000")
Gui, Main:Add, Edit, xm+460 ym+70 w250 vQn Center -E0x200 ReadOnly HwndQn gAnalyzeQn, x1
CtlColors.Attach(Qn, "E6E6E6", "008000")
Gui, Main:Add, Edit, xm+205 ym+70 w250 vNm -E0x200 ReadOnly HwndNm Center
CtlColors.Attach(Nm, "E6E6E6", "000080")
Gui, Main:Add, Edit, xm+715 ym+70 w250 vSum -E0x200 ReadOnly HwndSum Center
CtlColors.Attach(Sum, "E6E6E6", "800000")
Gui, Main:Font, s50
Gui, Main:Add, Edit, xm+205 ym+10 w254 vGivenMoney -E0x200 cBlue gCalc Center Border Hidden
Gui, Main:Add, Edit, xm+459 ym+10 w254 vAllSum HwndAS -E0x200 ReadOnly Center Hidden
CtlColors.Attach(AS, "E6E6E6", "008000")
Gui, Main:Add, Edit, xm+713 ym+10 w252 vChange HwndC -E0x200 ReadOnly Center Hidden
CtlColors.Attach(C, "E6E6E6", "FF0000")
Gui, Main:Font, s15
Gui, Main:Add, ListView, xm+205 ym+135 w760 r10 -Hdr Grid vLV0 BackgroundE6E6E6, Barcode|Name|Quantity|Price

Gui, Main:Default
Gui, Main:ListView, LV0
LV_ModifyCol(1, "0 Center")
LV_ModifyCol(2, "250 Center")
LV_ModifyCol(3, "254 Center")
LV_ModifyCol(4, "252 Center")
; ==========================================================================================================

; Ensure Dot
EnsureCtrlList := "LV1,EnsBtn"
Gui, Main:Font, s25
Gui, Main:Add, Button, xm+205 ym+30 vEnsBtn w760 h80 hwndBtn Hidden, % _9
ImageButton.Create(Btn, EBTN*)
Gui, Main:Font, s15
Gui, Main:Add, ListView, xm+205 ym+145 w760 r11 -Hdr Grid vLV1 BackgroundE6E6E6 Hidden, Barcode|Name|Quantity|Price

Gui, Main:Default
Gui, Main:ListView, LV1
LV_ModifyCol(1, "0 Center")
LV_ModifyCol(2, "250 Center")
LV_ModifyCol(3, "250 Center")
LV_ModifyCol(4, "256 Center")
; ==========================================================================================================

; Define
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
Gui, Main:Add, ListView, xm+205 ym+145 w760 r11 -Hdr Grid vLV2 BackgroundE6E6E6 c0x800000 Hidden, Barcode|Name|Quantity|Price

Gui, Main:Default
Gui, Main:ListView, LV2
LV_ModifyCol(1, "185 Center")
LV_ModifyCol(2, "192 Center")
LV_ModifyCol(3, "192 Center")
LV_ModifyCol(4, "186 Center")
; ==========================================================================================================

; StockPile
StockPileCtrlList := "Pnm,Pqn,LV3"
Gui, Main:Font, s25
Gui, Main:Add, Edit, xm+205 ym+50 w380 Right ReadOnly vPnm HwndPnm_ -E0x200 Hidden
CtlColors.Attach(Pnm_, "E6E6E6", "000000")
Gui, Main:Add, Edit, xm+585 ym+50 w380 Left vPqn HwndPqn_ -E0x200 Hidden
CtlColors.Attach(Pqn_, "E6E6E6", "0000FF")
Gui, Main:Font, s15
Gui, Main:Add, ListView, xm+205 ym+145 w760 r11 -Hdr Grid vLV3 BackgroundE6E6E6 c0x800000 gDisplayQn Hidden, Barcode|Name|Quantity

Gui, Main:Default
Gui, Main:ListView, LV3
LV_ModifyCol(1, "0 Center")
LV_ModifyCol(2, "377 Right")
LV_ModifyCol(3, "380 Left")

Gui, Main:Show, w1000 h500
Gui, Main:Default
Gui, Main:ListView, LV0
Return

:*C:GenUMIDForThisUser::
    If FileExist("Privat\Setting") {
        Msgbox, 64, Defined, Defined log in setting!
        Return
    }
    FileAppend, % Encode(UUID()), Privat\Setting
    GuiControl, Verif:Show, Enter
    GuiControl, Verif:Hide, Pa
Return

OpenMain:
    Loop, Parse, % "2435"
        GuiControl, Main:Enabled, Btn%A_LoopField%
    Hide(EnsureCtrlList "," DefineCtrlList "," StockPileCtrlList "," ProfitCtrlList)
    GuiControl, Main:Disabled, Btn1
    Show(MainCtrlList)
    RMS := "#1"
    Gui, Main:ListView, LV0
Return

Submit:
    Loop, Parse, % "1234"
        GuiControl, Main:Enabled, Btn%A_LoopField%
    Hide(MainCtrlList "," DefineCtrlList "," StockPileCtrlList "," ProfitCtrlList)
    GuiControl, Main:Disabled, Btn5
    Show(EnsureCtrlList)
    RMS := "#2"
    Gui, Main:ListView, LV1
Return

Define:
    Loop, Parse, % "1435"
        GuiControl, Main:Enabled, Btn%A_LoopField%
    Hide(MainCtrlList "," EnsureCtrlList "," StockPileCtrlList "," ProfitCtrlList)
    GuiControl, Main:Disabled, Btn2
    Show(DefineCtrlList)
    Gui, Main:ListView, LV2
    LoadDefined()
    RMS := "#3"
Return

StockPile:
    Loop, Parse, % "1245"
        GuiControl, Main:Enabled, Btn%A_LoopField%
    Hide(MainCtrlList "," EnsureCtrlList "," DefineCtrlList "," ProfitCtrlList)
    GuiControl, Main:Disabled, Btn3
    Show(StockPileCtrlList)
    Gui, Main:ListView, LV3
    LoadStockList()
    RMS := "#4"
Return

Prof:
    Loop, Parse, % "1235" 
        GuiControl, Main:Enabled, Btn%A_LoopField%
    Hide(MainCtrlList "," EnsureCtrlList "," DefineCtrlList "," StockPileCtrlList)
    GuiControl, Main:Disabled, Btn4
    Show(ProfitCtrlList)
    RMS := "#5"
    Gui, Main:ListView, LV4
Return

Enter:
    Gui, Verif:Destroy
    Gui, Main:-Caption +HwndMain
    Gui, Main:Color, 0x35363A
    ;Gui, Main:Add, Picture, x0 y0 w750 h320, Img\bg.png
    Gui, Main:Font, s15 Bold, Calibri

    Gui, Main:Add, Text, xm ym BackgroundTrans cCA9548, % _1 " [" Version() "]"

    Gui, Main:Add, Button, xm+590 ym w119 h40 HwndExit gQuit, % _3
    ImageButton.Create(Exit, [[0, "Img\E_Normal.png",, 0xFF0000]
    , [0, "Img\E_Hover.png" ,, 0xFFFFFF]
    , [0, "Img\E_Hover.png" ,, 0xFF0000]]*)

    Gui, Main:Font, s25
    Gui, Main:Add, Button, xm+173 ym+80 HwndCB w372 h123 gOpenMain, % _4
    ImageButton.Create(CB, [[0, "Img\cb_Normal.png",, 0xFFFF00]
    , [0, "Img\cb_Hover.png" ,, 0xFFFFFF]
    , [0, "Img\cb_Hover.png" ,, 0xFFFF00]]*)

    Gui, Main:Font, s15
    Gui, Main:Add, Button, x5 ym+260 HwndDef w119 h40 gDefine, % _5
    ImageButton.Create(Def, [[0, "Img\D_Normal.png",, 0x00FF00]
    , [0, "Img\D_Hover.png" ,, 0xFFFFFF]
    , [0, "Img\D_Hover.png" ,, 0x00FF00]]*)

    Gui, Main:Add, Button, x125 ym+260 HwndSto w119 h40 gStockPile, % _6
    ImageButton.Create(Sto, [[0, "Img\D_Normal.png",, 0x00FF00]
    , [0, "Img\D_Hover.png" ,, 0xFFFFFF]
    , [0, "Img\D_Hover.png" ,, 0x00FF00]]*)

    Gui, Main:Add, Button, x245 ym+261 HwndProf w119 h40, % _7
    ImageButton.Create(Prof, [[0, "Img\D_Normal.png",, 0x00FF00]
    , [0, "Img\D_Hover.png" ,, 0xFFFFFF]
    , [0, "Img\D_Hover.png" ,, 0x00FF00]]*)

    Gui, Main:Show, w750 h320
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

    If (RMS = "#1") {
        GuiControlGet, Visi, Main:Visible, Nm
        If (Visi) {
            Filled := (Nm) && (Qn) && (Sum)
            If (Filled) {
                LV_Add("", Bc, Nm, Qn, Sum)
                GuiControl, Main:, Bc
            }
        } Else {
            DB_Write("Curr\" A_Now ".db", Sum_Data[2])

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
    }
    If (RMS = "#3") {
        Filled := (Dbc) && (Dnm) && (Dbp) && (Dsp)
        Msgbox % Dsp
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

            If !InStr(PrevData, "|" Dbc) && (InStr(PrevData, Dbc) != 1) {
                DB_Write("Sets\PD.db", PrevData "|" Dbc ";" Dnm ";" Dbp ";" Dsp)
                
                LV_Add("", Dbc, Dnm, Dbp, Dsp)
            }
        }
    }

    If (RMS = "#4") {
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
                    If (Pqn > Defs[5])
                        NewData := StrReplace(NewData, A_LoopField, Defs[1] ";" Defs[2] ";" Defs[3] ";" Defs[4] ";" Pqn)
                    DB_Write("Sets\PD.db", NewData)
                    LV_Modify(Row,,,, Pqn)
                    Break
                }
            }
        }
    }
Return
#If

#If WinActive("ahk_id " Main)
Up::
    Gui, Main:Submit, NoHide
    Gui, Main:Default
    _Qn := SubStr(Qn, 1, InStr(Qn, "x") - 1)
    Qn := SubStr(Qn, InStr(Qn, "x") + 1)
    GuiControl, Main:, Qn, % _Qn "x" Qn += 1
    Sleep, 125
Return
#If

#If WinActive("ahk_id " Main)
Down::
    Gui, Main:Submit, NoHide
    Gui, Main:Default
    _Qn := SubStr(Qn, 1, InStr(Qn, "x") - 1)
    Qn := SubStr(Qn, InStr(Qn, "x") + 1)
    If (Qn > 1)
        GuiControl, Main:, Qn, % _Qn "x" Qn -= 1
    Sleep, 125
Return
#If

#If WinActive("ahk_id " Main)
Delete::
    If WinActive("ahk_id " Define) {
        Gui, Def:Default
        SettingObj := FileOpen("Privat\Setting1.db", "r")

        LV_GetText(Bc, Row := LV_GetNext(), 1)
        LV_GetText(Nm, Row, 2)
        LV_GetText(BP, Row, 3)
        LV_GetText(Sp, Row, 4)

        GetData := ""
        While !SettingObj.AtEOF() {
            GetData .= Chr(SettingObj.ReadUChar())
        }
        SettingObj.Close()

        SettingObj := FileOpen("Privat\Setting1.db", "w")
        Loop, Parse, % StrReplace(GetData, Encode("[" Bc ";" Nm ";" BP ";" Sp "]"))
            SettingObj.WriteUChar(Asc(A_LoopField))
        SettingObj.Close()

        LV_Delete(LV_GetNext())
    }
    If WinActive("ahk_id " Sell) {
        
        LV_Delete(LV_GetNext())
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
    } Else If (RMS = "#3") {
        SendInput, {Space}
    }
Return
#If

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

AnalyzeAvail:
    Gui, Main:Submit, NoHide

    GuiControl, Main:, Nm
    GuiControl, Main:, Sum
    GuiControl, Main:, Qn, x1

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

LoadDefined() {
    Data := DB_Read("Sets\PD.db")
    
    LV_Delete()
    Loop, Parse, % Data, |
    {
        Defs := StrSplit(A_LoopField, ";")
        If (Defs.MaxIndex() = 4)
            LV_Add("", Defs[1], Defs[2], Defs[3], Defs[4])
    }
}

LoadStockList() {
    LV_Delete()
    Data := DB_Read("Sets\PD.db")
    
    Loop, Parse, Data, |
    {
        Defs := StrSplit(A_LoopField, ";")
        If (Defs[5])
            LV_Add("", Defs[1], Defs[2], Defs[5])
        Else
            LV_Add("", Defs[1], Defs[2], 0)
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
    Sum := 0
    FormatTime, OutTime, % A_Now, yyyy/MM/dd HH:mm:ss
    Data := OutTime "> "
    Loop, % LV_GetCount() {
        LV_GetText(ThisSum, A_Index, 4)
        Sum += ThisSum

        LV_GetText(Bc, A_Index, 1)
        LV_GetText(Nm, A_Index, 2)
        LV_GetText(Qn, A_Index, 3)

        Data .= Bc ";" Nm ";" Qn ";" ThisSum "|"
    }
    Data .= "> " Sum
Return, [Sum, Trim(Data, "|"), OutTime]
}

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
        GuiControl, Main:Hide, % A_LoopField
    }
}

Show(ListCtrl) {
    Loop, Parse, ListCtrl, `,
    {
        If !InStr(A_LoopField, "$")
            GuiControl, Main:Show, % A_LoopField
    }
}