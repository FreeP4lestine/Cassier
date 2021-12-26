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

EBTN := [[0, 0xCCCCCC, , 0x000000, 0, , 0x6B8000, 1]
, [0, 0x008000, , 0xFFFFFF, 0, , 0xFFFFFF, 1]
, [0, 0x008000, , 0xFFFF00, 0, , 0xFFFFFF, 1]
, [0, 0x008000, , 0xFFFFFF, 0, , 0x008000, 1]]

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
MainCtrlList := "Bc,Qn,Nm,Sum,LV0,$GivenMoney,$AllSum,$Change"
Gui, Main:Font, s25
;Gui, Main:Add, Edit, xm+450 ym+10 w260 vBc Center -E0x200 gAnalyzeAvail Border
;Gui, Main:Add, Edit, xm+550 ym+80 w70 vQn Center -E0x200 ReadOnly HwndQn cGreen gAnalyzeAvail, x1
;CtlColors.Attach(Qn, "E6E6E6", "008000")
;Gui, Main:Add, Edit, xm+205 ym+80 w345 vNm -E0x200 ReadOnly HwndNm Center
;CtlColors.Attach(Nm, "E6E6E6", "008000")
;Gui, Main:Add, Edit, xm+620 ym+80 w345 vSum -E0x200 ReadOnly HwndSum Center
;CtlColors.Attach(Sum, "E6E6E6", "008000")
;Gui, Main:Font, s50
;Gui, Main:Add, Edit, xm+205 ym+20 w254 vGivenMoney -E0x200 cGreen gCalc Center Border Hidden
;Gui, Main:Add, Edit, xm+459 ym+20 w254 vAllSum HwndAS -E0x200 ReadOnly Center Hidden
;CtlColors.Attach(AS, "E6E6E6", "008000")
;Gui, Main:Add, Edit, xm+713 ym+20 w252 vChange HwndC -E0x200 ReadOnly Center Hidden
;CtlColors.Attach(C, "E6E6E6", "FF0000")
;Gui, Main:Font, s25
;Gui, Main:Add, ListView, xm+205 ym+145 w760 r7 -Hdr Grid vLV0 BackgroundE6E6E6, Barcode|Name|Quantity|Price
;Gui, Main:Default
;LV_ModifyCol(1, "0 Center")
;LV_ModifyCol(2, "250 Center")
;LV_ModifyCol(3, "250 Center")
;LV_ModifyCol(4, "256 Center")
; ==========================================================================================================

; Ensure Dot
EnsureCtrlList := "LV1,EBtn"
Gui, Main:Add, Button, xm+205 ym+20 vEBtn w760 h80 hwndBtn
ImageButton.Create(Btn, EBTN*)
Gui, Main:Add, ListView, xm+205 ym+145 w760 r7 -Hdr Grid vLV1 BackgroundE6E6E6, Barcode|Name|Quantity|Price
Gui, Main:Default
LV_ModifyCol(1, "0 Center")
LV_ModifyCol(2, "250 Center")
LV_ModifyCol(3, "250 Center")
LV_ModifyCol(4, "256 Center")
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
    ;    Gui, Seller:-Caption +HwndSell
    ;    Gui, Seller:Color, 0x35363A
    ;    Gui, Seller:Font, s10 Bold, Calibri
    ;    Gui, Seller:Add, Edit, xm ym w800 vMsg -E0x200 ReadOnly cFFFF00
    ;    Gui, Seller:Font, s15
    ;    Gui, Seller:Add, Button, xm+840 ym w119 h40 HwndExit gQuitSeller, % _3
    ;    ImageButton.Create(Exit, [[0, "Img\E_Normal.png",, 0xFF0000]
    ;    , [0, "Img\E_Hover.png" ,, 0xFFFFFF]
    ;    , [0, "Img\E_Hover.png" ,, 0xFF0000]]*)

    ;    Gui, Seller:Font, s25
    ;    Gui, Seller:Add, Edit, xm ym+50 w320 vBc Center -E0x200 h42 gAnalyzeAvail Border

    ;    Gui, Seller:Font, s50
    ;    Gui, Seller:Add, Edit, xm ym+50 w320 h90 vGivenMoney -E0x200 Border Hidden cGreen gCalc Center
    ;    Gui, Seller:Add, Edit, xm+320 ym+50 w320 h90 vAllSum HwndAS -E0x200 Border Hidden ReadOnly Center
    ;    CtlColors.Attach(AS, "FFFFFF", "008000")
    ;    Gui, Seller:Add, Edit, xm+640 ym+50 w320 h90 vChange HwndC -E0x200 Border Hidden ReadOnly Center
    ;    CtlColors.Attach(C, "FFFFFF", "FF0000")

    ;    Gui, Seller:Font, s25
    ;    Gui, Seller:Add, Edit, xm+320 ym+100 w320 vQn Center -E0x200 h42 ReadOnly Border HwndQn gAnalyzeAvail , x 1
    ;    CtlColors.Attach(Qn, "FFFFFF", "008000")
    ;    Gui, Seller:Add, Edit, xm ym+100 w320 vNm -E0x200 h42 ReadOnly HwndNm Center Border
    ;    CtlColors.Attach(Nm, "FFFFFF", "008000")
    ;    Gui, Seller:Add, Edit, xm+640 ym+100 w320 vSum -E0x200 h42 ReadOnly HwndSum Center Border
    ;    CtlColors.Attach(Sum, "FFFFFF", "008000")
    ;    Gui, Seller:Add, ListView, xm ym+150 w960 r10 -Hdr Grid vLV, Barcode|Name|Quantity|Price
    ;    Gui, Seller:Default
    ;
    ;    LV_ModifyCol(1, "0 Center")
    ;    LV_ModifyCol(2, "317 Center")
    ;    LV_ModifyCol(3, "320 Center")
    ;    LV_ModifyCol(4, "318 Center")
    ;
    ;    Gui, Seller:Font, s10
    ;    Gui, Seller:Add, Edit, xm+640 ym+600 w320 -E0x200 Right ReadOnly r2 vValid HwndValid -VScroll
    ;
    ;}
    ;Gui, Seller:Show, w1000 h700
    ;GuiControl, Seller:Focus, Bc
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

ClearMsg:
    Gui, Def:Submit, NoHide
    If (Msg)
        GuiControl, Def:, Msg
Return

~Enter::
    If WinActive("ahk_id " Define) {
        Gui, Def:Submit, NoHide
        Filled := (DE1) && (DE2) && (DE3) && (DE4)
        If (Filled) {
            If DE1 is not Digit 
            {
                GuiControl, Def:, Msg, Error: The barcode should not contain anything but digits
                ShakeControl("Def", "DE1")
                Return
            }
            If (DE2 ~= "\[|;|\]") 
            {
                GuiControl, Def:, Msg, % "Error: The name of the product should not contain ""["" or "";"" (They are used by this app)"
                ShakeControl("Def", "DE2")
                Return
            }
            If DE3 is not Digit 
            {
                GuiControl, Def:, Msg, Error: The buy price should not contain anything but digits
                ShakeControl("Def", "DE3")
                Return
            }
            If DE4 is not Digit 
            {
                GuiControl, Def:, Msg, Error: The sell price should not contain anything but digits
                ShakeControl("Def", "DE4")
                Return
            }

            Encoded := Encode("[" DE1 ";" DE2 ";" DE3 ";" DE4 "]")
            If (SettingObj := FileOpen("Privat\Setting1.db", "r")) {
                Loop {
                    Data .= Chr(SettingObj.ReadUChar())
                    Position := InStr(Data, Encoded)
                } Until (SettingObj.AtEOF() || (Position))
                SettingObj.Close()
            }

            If (!Exist) {
                SettingObj := FileOpen("Privat\Setting1.db", "a")
                Loop, Parse, % Encoded
                    SettingObj.WriteUChar(Asc(A_LoopField))
                SettingObj.Close()
                Gui, Def:Default
                LV_Add("", DE1, DE2, DE3, DE4)
            }
        }
    }
    If WinActive("ahk_id " Sell) {
        Gui, Seller:Submit, NoHide
        GuiControlGet, Visi, Seller:Visible, Nm

        If (Visi) {
            If (Nm) {
                Gui, Seller:Default
                LV_Add("", Bc, Nm, Qn, Sum)
                GuiControl, Seller:, Bc
            }
        } Else {
            HistoryObj := FileOpen("Valid\" StrReplace(StrReplace(StrReplace(Sum_Data[3], " "), ":"), "/") ".db", "w")
            Loop, Parse, % Encode(Sum_Data[2])
                HistoryObj.WriteUChar(Asc(A_LoopField))
            HistoryObj.Close()

            GuiControl, Seller:, GivenMoney
            GuiControl, Seller:, AllSum
            GuiControl, Seller:, Change

            GuiControl, Seller:Hide, GivenMoney
            GuiControl, Seller:Hide, AllSum
            GuiControl, Seller:Hide, Change

            GuiControl, Seller:Show, Bc
            GuiControl, Seller:Show, Nm
            GuiControl, Seller:Show, Qn
            GuiControl, Seller:Show, Sum

            Gui, Seller:Default
            LV_Delete()
            GuiControl, Seller:Focus, Bc

            GuiControlGet, Valid, Seller:Hwnd, Valid
            CtlColors.Attach(Valid, "35363A", "00FF00")
            GuiControl, Seller:, Valid, % "Sell Operation Validated SUCESSFULLY!`n" Sum_Data[3]
        }
    }
Return

~Up::
    If WinActive("ahk_id " Main) {
        Gui, Main:Submit, NoHide
        Qn := SubStr(Qn, 2)
        GuiControl, Main:, Qn, % "x" Qn += 1
    }
    Sleep, 125
Return

~Down::
    If WinActive("ahk_id " Main) {
        Gui, Main:Submit, NoHide
        Qn := SubStr(Qn, 2)
        If (Qn > 1)
            GuiControl, Main:, Qn, % "x" Qn -= 1
    }
    Sleep, 125
Return

~Delete::
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
        Gui, Seller:Default
        LV_Delete(LV_GetNext())
    }
Return

~Space::
    If WinActive("ahk_id " Sell) {
        Gui, Seller:Default
        Gui, Seller:Submit, NoHide
        GuiControl, Seller:, Msg
        LV_GetText(Noun, 1, 1)
        If (Noun) {
            GuiControl, Seller:Hide, Bc
            GuiControl, Seller:Hide, Nm
            GuiControl, Seller:Hide, Qn
            GuiControl, Seller:Hide, Sum
            GuiControl, Seller:Show, GivenMoney
            GuiControl, Seller:Show, AllSum
            GuiControl, Seller:Show, Change
            GuiControl, Seller:, AllSum, % (Sum_Data := CalculateSum())[1]
            Sleep, 1000
            GuiControl, Seller:Focus, GivenMoney
        } Else If (Nm) {
            GuiControl, Seller:, Msg, Warning: No records are found, press ENTER please!
        }
    }
Return

Calc:
    Gui, Seller:Submit, NoHide
    GuiControl, Seller:, Msg
    GuiControl, Seller:, Change
    If GivenMoney is not Digit
    {
        GuiControl, Seller:, Msg, Warning: The given money input should not contain anything but digits!
        Return
    }
    If (GivenMoney > AllSum) {
        GuiControl, Seller:, Change, % GivenMoney - AllSum
    }
Return

AnalyzeAvail:
    Gui, Seller:Submit, NoHide
    GuiControl, Seller:, Nm
    GuiControl, Seller:, Sum
    GuiControl, Seller:, Msg
    If Bc is not Digit
    {
        GuiControl, Seller:, Msg, Error: The barcode should not contain anything but digits
        GuiControl, Seller:, Bc
        ShakeControl("Seller", "Bc")
        Return
    }
    If (SettingObj := FileOpen("Privat\Setting1.db", "r")) && (Bc) {
        AllData := ""
        While (!SettingObj.AtEOF())
            AllData .= Chr(SettingObj.ReadUChar())
        _AllData := ""
        Loop, Parse, AllData, `n, `r
            _AllData .= Decode(A_LoopField) "`n"

        Loop, Parse, _AllData, `n, `r
        {
            Defs := StrSplit(A_LoopField, ";")
            Defs[1] := SubStr(Defs[1], 2)
            Defs[4] := SubStr(Defs[4], 1, StrLen(Defs[4]) - 1)
            If (Defs[1] = Bc) {
                GuiControl, Seller:, Nm, % Defs[2] " (" Defs[4] ")"
                GuiControl, Seller:, Sum, % Defs[4] * SubStr(Qn, 3)
                Break
            }
        }
    }
Return

QuitSeller:
    Gui, Seller:Destroy
Return

QuitDefiner:
    Gui, Def:Destroy
Return

Quit:
ExitApp

LoadDefined() {
    If (SettingObj := FileOpen("Privat\Setting1.db", "r")) {
        Data := ""
        While !SettingObj.AtEOF() {
            Data .= Chr(SettingObj.ReadUChar())
        }
        Gui, Def:Default
        Loop, Parse, % Data, `n, `r
        {
            Defs := StrSplit(Trim(Decode(A_LoopField), "[]"), ";")
            If (Defs.MaxIndex() = 4)
                LV_Add("", Defs[1], Defs[2], Defs[3], Defs[4])
        }
        SettingObj.Close()
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
    Gui, Seller:Default
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
    } Until (!ThisChar)
Return, Decode(Info)
}