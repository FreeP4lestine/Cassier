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
, [0, 0x008000, , 0xFFFFFF, 0, , 0xFFFFFF, 1]
, [0, 0x008000, , 0xFFFF00, 0, , 0xFFFFFF, 1]
, [0, 0x008000, , 0xFFFFFF, 0, , 0x008000, 1]]

EBTN := [ [0, 0xC6E9F4, , , 0, , 0x46B8DA, 1]
, [0, 0x86D0E7, , , 0, , 0x46B8DA, 1]
, [0, 0x46B8DA, , , 0, , 0x46B8DA, 1]
, [0, 0xF0F0F0, , , 0, , 0x46B8DA, 1] ]

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
Gui, Main:Add, Edit, xm+450 ym+10 w260 vBc Center -E0x200 gAnalyzeAvail Border
Gui, Main:Add, Edit, xm+460 ym+80 w250 vQn Center -E0x200 ReadOnly HwndQn gAnalyzeQn, x1
CtlColors.Attach(Qn, "E6E6E6", "008000")
Gui, Main:Add, Edit, xm+205 ym+80 w250 vNm -E0x200 ReadOnly HwndNm Center
CtlColors.Attach(Nm, "E6E6E6", "000080")
Gui, Main:Add, Edit, xm+715 ym+80 w250 vSum -E0x200 ReadOnly HwndSum Center
CtlColors.Attach(Sum, "E6E6E6", "800000")
Gui, Main:Font, s50
Gui, Main:Add, Edit, xm+205 ym+20 w254 vGivenMoney -E0x200 cGreen gCalc Center Border Hidden
Gui, Main:Add, Edit, xm+459 ym+20 w254 vAllSum HwndAS -E0x200 ReadOnly Center Hidden
CtlColors.Attach(AS, "E6E6E6", "008000")
Gui, Main:Add, Edit, xm+713 ym+20 w252 vChange HwndC -E0x200 ReadOnly Center Hidden
CtlColors.Attach(C, "E6E6E6", "FF0000")
Gui, Main:Font, s15
Gui, Main:Add, ListView, xm+205 ym+145 w760 r11 -Hdr Grid vLV0 BackgroundE6E6E6, Barcode|Name|Quantity|Price
Gui, Main:Default
LV_ModifyCol(1, "0 Center")
LV_ModifyCol(2, "250 Center")
LV_ModifyCol(3, "254 Center")
LV_ModifyCol(4, "252 Center")
; ==========================================================================================================

; Ensure Dot
EnsureCtrlList := "LV1,EBtn"
;Gui, Main:Font, s25
;Gui, Main:Add, Button, xm+205 ym+20 vEBtn w760 h80 hwndBtn, % _9
;ImageButton.Create(Btn, EBTN*)
;Gui, Main:Font, s15
;Gui, Main:Add, ListView, xm+205 ym+145 w760 r7 -Hdr Grid vLV1 BackgroundE6E6E6, Barcode|Name|Quantity|Price
;Gui, Main:Default
;LV_ModifyCol(1, "0 Center")
;LV_ModifyCol(2, "250 Center")
;LV_ModifyCol(3, "250 Center")
;LV_ModifyCol(4, "256 Center")
; ==========================================================================================================

; Define
;DefineCtrlList := "Dbc,Dnm,Dbp,Dsp,LV2"
;Gui, Main:Add, Edit, xm+205 ym+80 w185 Center Border vDbc HwndDbc_ -E0x200 gClearDbc
;CtlColors.Attach(Dbc_, "FFFFFF", "000000")
;Gui, Main:Add, Edit, xm+396 ym+80 w185 Center Border vDnm HwndDnm_ -E0x200 gClearDnm
;CtlColors.Attach(Dnm_, "FFFFFF", "000000")
;Gui, Main:Add, Edit, xm+589 ym+80 w185 Center Border vDbp HwndDbp_ -E0x200 gClearDbp
;CtlColors.Attach(Dbp_, "FFFFFF", "000000")
;Gui, Main:Add, Edit, xm+780 ym+80 w185 Center Border vDsp HwndDsp_ -E0x200 gClearDsp
;CtlColors.Attach(Dsp_, "FFFFFF", "000000")
;Gui, Main:Font, s15
;Gui, Main:Add, ListView, xm+205 ym+145 w760 r11 -Hdr Grid vLV2 BackgroundE6E6E6 c0x800000, Barcode|Name|Quantity|Price
;Gui, Main:Default
;LV_ModifyCol(1, "185 Center")
;LV_ModifyCol(2, "192 Center")
;LV_ModifyCol(3, "192 Center")
;LV_ModifyCol(4, "186 Center")

Gui, Main:Show, w1000 h500
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
    GuiControl, Main:Disabled, Btn1

    ;If !WinExist("ahk_id " Sell) {
    ;    Gui, Main:-Caption +HwndSell
    ;    Gui, Main:Color, 0x35363A
    ;    Gui, Main:Font, s10 Bold, Calibri
    ;    Gui, Main:Add, Edit, xm ym w800 vMsg -E0x200 ReadOnly cFFFF00
    ;    Gui, Main:Font, s15
    ;    Gui, Main:Add, Button, xm+840 ym w119 h40 HwndExit gQuitSeller, % _3
    ;    ImageButton.Create(Exit, [[0, "Img\E_Normal.png",, 0xFF0000]
    ;    , [0, "Img\E_Hover.png" ,, 0xFFFFFF]
    ;    , [0, "Img\E_Hover.png" ,, 0xFF0000]]*)

    ;    Gui, Main:Font, s25
    ;    Gui, Main:Add, Edit, xm ym+50 w320 vBc Center -E0x200 h42 gAnalyzeAvail Border

    ;    Gui, Main:Font, s50
    ;    Gui, Main:Add, Edit, xm ym+50 w320 h90 vGivenMoney -E0x200 Border Hidden cGreen gCalc Center
    ;    Gui, Main:Add, Edit, xm+320 ym+50 w320 h90 vAllSum HwndAS -E0x200 Border Hidden ReadOnly Center
    ;    CtlColors.Attach(AS, "FFFFFF", "008000")
    ;    Gui, Main:Add, Edit, xm+640 ym+50 w320 h90 vChange HwndC -E0x200 Border Hidden ReadOnly Center
    ;    CtlColors.Attach(C, "FFFFFF", "FF0000")

    ;    Gui, Main:Font, s25
    ;    Gui, Main:Add, Edit, xm+320 ym+100 w320 vQn Center -E0x200 h42 ReadOnly Border HwndQn gAnalyzeAvail , x 1
    ;    CtlColors.Attach(Qn, "FFFFFF", "008000")
    ;    Gui, Main:Add, Edit, xm ym+100 w320 vNm -E0x200 h42 ReadOnly HwndNm Center Border
    ;    CtlColors.Attach(Nm, "FFFFFF", "008000")
    ;    Gui, Main:Add, Edit, xm+640 ym+100 w320 vSum -E0x200 h42 ReadOnly HwndSum Center Border
    ;    CtlColors.Attach(Sum, "FFFFFF", "008000")
    ;    Gui, Main:Add, ListView, xm ym+150 w960 r10 -Hdr Grid vLV, Barcode|Name|Quantity|Price
    ;    Gui, Main:Default
    ;
    ;    LV_ModifyCol(1, "0 Center")
    ;    LV_ModifyCol(2, "317 Center")
    ;    LV_ModifyCol(3, "320 Center")
    ;    LV_ModifyCol(4, "318 Center")
    ;
    ;    Gui, Main:Font, s10
    ;    Gui, Main:Add, Edit, xm+640 ym+600 w320 -E0x200 Right ReadOnly r2 vValid HwndValid -VScroll
    ;
    ;}
    ;Gui, Main:Show, w1000 h700
    ;GuiControl, Main:Focus, Bc
Return

Prof:
    Loop, Parse, % "1235"
        GuiControl, Main:Enabled, Btn%A_LoopField%
    GuiControl, Main:Disabled, Btn4
Return

Define:
    Loop, Parse, % "1435"
        GuiControl, Main:Enabled, Btn%A_LoopField%
    GuiControl, Main:Disabled, Btn2
    LoadDefined()
    ;If !WinExist("ahk_id " Define) {
    ;    Gui, Def:-Caption +HwndDefine
    ;    Gui, Def:Color, 0x35363A
    ;    Gui, Def:Font, s10 Bold, Calibri
    ;    Gui, Def:Add, Edit, xm ym w800 vMsg -E0x200 ReadOnly cFF0000
    ;    Gui, Def:Font, s15
    ;    Gui, Def:Add, Button, xm+840 ym w119 h40 HwndExit gQuitDefiner, % _3
    ;    ImageButton.Create(Exit, [[0, "Img\E_Normal.png",, 0xFF0000]
    ;    , [0, "Img\E_Hover.png" ,, 0xFFFFFF]
    ;    , [0, "Img\E_Hover.png" ,, 0xFF0000]]*)
    ;    xp := 0
    ;    Loop, 4 {
    ;        Gui, Def:Add, Edit, xm+%xp% ym+50 w239 Center vDE%A_Index% -E0x200 gClearMsg
    ;        xp += 240
    ;    }
    ;    Gui, Def:Add, ListView, xm ym+85 w%xp% -Hdr Grid r20 BackgroundGray, Barcode|Name|Buy Price|Sell Price
    ;    Gui, Def:Default
    ;    LV_ModifyCol(1, "237 +Center")
    ;    LV_ModifyCol(2, "240 +Center")
    ;    LV_ModifyCol(3, "240 +Center")
    ;    LV_ModifyCol(4, "239 +Center")
    ;    LoadDefined()
    ;}
    ;Gui, Def:Show, w1000 h700
    ;GuiControl, Def:Focus, DE1
Return

StockPile:
    Loop, Parse, % "1245"
        GuiControl, Main:Enabled, Btn%A_LoopField%
    GuiControl, Main:Disabled, Btn3

    ;
    ;If !WinExist("ahk_id " SP) {
    ;    Gui, Stock:-Caption +HwndDefine
    ;    Gui, Stock:Color, 0x35363A
    ;    Gui, Stock:Font, s10 Bold, Calibri
    ;    Gui, Stock:Add, Edit, xm ym w800 vMsg -E0x200 ReadOnly cFF0000
    ;    Gui, Stock:Font, s15
    ;    Gui, Stock:Add, Button, xm+840 ym w119 h40 HwndExit gQuitStock, % _3
    ;    ImageButton.Create(Exit, [[0, "Img\E_Normal.png",, 0xFF0000]
    ;    , [0, "Img\E_Hover.png" ,, 0xFFFFFF]
    ;    , [0, "Img\E_Hover.png" ,, 0xFF0000]]*)
    ;    ;xp := 0
    ;    ;Loop, 4 {
    ;    ;    Gui, Def:Add, Edit, xm+%xp% ym+50 w239 Center vDE%A_Index% -E0x200 gClearMsg
    ;    ;    xp += 240
    ;    ;}
    ;    ;Gui, Def:Add, ListView, xm ym+85 w%xp% -Hdr Grid r20 BackgroundGray, Barcode|Name|Buy Price|Sell Price
    ;    ;Gui, Def:Default
    ;    ;LV_ModifyCol(1, "237 +Center")
    ;    ;LV_ModifyCol(2, "240 +Center")
    ;    ;LV_ModifyCol(3, "240 +Center")
    ;    ;LV_ModifyCol(4, "239 +Center")
    ;}
    ;Gui, Stock:Show, w1000 h700
Return

Submit:
    Loop, Parse, % "1234"
        GuiControl, Main:Enabled, Btn%A_LoopField%
    GuiControl, Main:Disabled, Btn5

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
        Filled := (Nm) && (Qn) && (Sum)
        If (Filled) {
            LV_Add("", Bc, Nm, Qn, Sum)
        }
    }
    If (RMS = "#3") {
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

            If !InStr(PrevData, "[" Dbc) {
                DB_Write("Sets\PD.db", PrevData "[" Dbc ";" Dnm ";" Dbp ";" Dsp "]")
                Gui, Main:Default
                LV_Add("", Dbc, Dnm, Dbp, Dsp)
            }
        }
    }
    If WinActive("ahk_id " Sell) {
        Gui, Main:Submit, NoHide
        GuiControlGet, Visi, Main:Visible, Nm

        If (Visi) {
            If (Nm) {
                Gui, Main:Default
                LV_Add("", Bc, Nm, Qn, Sum)
                GuiControl, Main:, Bc
            }
        } Else {
            HistoryObj := FileOpen("Valid\" StrReplace(StrReplace(StrReplace(Sum_Data[3], " "), ":"), "/") ".db", "w")
            Loop, Parse, % Encode(Sum_Data[2])
                HistoryObj.WriteUChar(Asc(A_LoopField))
            HistoryObj.Close()

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

            Gui, Main:Default
            LV_Delete()
            GuiControl, Main:Focus, Bc

            GuiControlGet, Valid, Main:Hwnd, Valid
            CtlColors.Attach(Valid, "35363A", "00FF00")
            GuiControl, Main:, Valid, % "Sell Operation Validated SUCESSFULLY!`n" Sum_Data[3]
        }
    }
Return
#If

#If WinActive("ahk_id " Main)
    Up::
    Gui, Main:Submit, NoHide
    _Qn := SubStr(Qn, 1, InStr(Qn, "x") - 1)
    Qn := SubStr(Qn, InStr(Qn, "x") + 1)
    GuiControl, Main:, Qn, % _Qn "x" Qn += 1
    Sleep, 125
Return
#If

#If WinActive("ahk_id " Main)
Down::
    Gui, Main:Submit, NoHide
    _Qn := SubStr(Qn, 1, InStr(Qn, "x") - 1)
    Qn := SubStr(Qn, InStr(Qn, "x") + 1)
    If (Qn > 1)
        GuiControl, Main:, Qn, % _Qn "x" Qn -= 1
    Sleep, 125
Return
#If

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
        Gui, Main:Default
        LV_Delete(LV_GetNext())
    }
Return

~Space::
    If WinActive("ahk_id " Sell) {
        Gui, Main:Default
        Gui, Main:Submit, NoHide
        GuiControl, Main:, Msg
        LV_GetText(Noun, 1, 1)
        If (Noun) {
            GuiControl, Main:Hide, Bc
            GuiControl, Main:Hide, Nm
            GuiControl, Main:Hide, Qn
            GuiControl, Main:Hide, Sum
            GuiControl, Main:Show, GivenMoney
            GuiControl, Main:Show, AllSum
            GuiControl, Main:Show, Change
            GuiControl, Main:, AllSum, % (Sum_Data := CalculateSum())[1]
            Sleep, 1000
            GuiControl, Main:Focus, GivenMoney
        } Else If (Nm) {
            GuiControl, Main:, Msg, Warning: No records are found, press ENTER please!
        }
    }
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

AnalyzeAvail:
    Gui, Main:Submit, NoHide

    GuiControl, Main:, Nm
    GuiControl, Main:, Sum
    GuiControl, Main:, Qn, x1

    CtlColors.Change(Bc, "FFFFFF", "008000")
    If (Bc) {
        If Bc is not Digit
        {
            CtlColors.Change(Bc, "FF8080", "008000")
            ShakeControl("Main", "Bc")
            Return
        }

        Data := DB_Read("Sets\PD.db")
        Data := SubStr(Data, 2, StrLen(Data) - 2)

        Loop, Parse, Data, ][
        {
            If (SubStr(A_LoopField, 1, InStr(A_LoopField, ";")) = Bc ";") {
                Defs := StrSplit(A_LoopField, ";")
            GuiControl, Main:, Nm, % Defs[2]
            GuiControl, Main:, Qn, % Defs[4] Qn
            GuiControl, Main:, Sum, % Defs[4] * SubStr(Qn, InStr(Qn, "x") + 1)
            Break
        }
    }
}
Return

AnalyzeQn:
    Gui, Main:Submit, NoHide
    Value := SubStr(Qn, 1, InStr(Qn, "x") - 1), Qn := SubStr(Qn, InStr(Qn, "x") + 1)
    If (Value) && (Qn)
        GuiControl, Main:, Sum, % Value * Qn
Return

QuitMain:
    Gui, Main:Destroy
Return

QuitDefiner:
    Gui, Def:Destroy
Return

Quit:
ExitApp

LoadDefined() {
    Data := DB_Read("Sets\PD.db")
    Data := SubStr(Data, 2, StrLen(Data) - 2)
    Gui, Main:Default
    LV_Delete()
    Loop, Parse, % Data, ][
    {
        Defs := StrSplit(A_LoopField, ";")
        If (Defs.MaxIndex() = 4)
            LV_Add("", Defs[1], Defs[2], Defs[3], Defs[4])
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
    Gui, Main:Default
    Sum := 0
    FormatTime, OutTime, % A_Now, yyyy/MM/dd HH:mm:ss
    Data := OutTime "> "
    Loop, % LV_GetCount() {
        LV_GetText(ThisSum, A_Index, 4)
        Sum += ThisSum

        LV_GetText(Bc, A_Index, 1)
        LV_GetText(Nm, A_Index, 2)
        LV_GetText(Qn, A_Index, 3)

        Data .= "[" Bc ";" Nm ";" Qn ";" ThisSum "]"
    }
    Data .= "> " Sum
Return, [Sum, Data, OutTime]
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