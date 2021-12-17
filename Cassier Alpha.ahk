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

GrayBTN := [[0, 0xFFFFFF, , 0xFF0000, 0, , 0x7C8187, 1]
, [0, 0x7C8187, , 0xFFFFFF, 0, , 0x7C8187, 1]
, [0, 0x7C8187, , 0xFFFF00, 0, , 0x7C8187, 1]
, [0, 0x6C7174, , 0x000000, 0, , 0xFFFFFF, 1]]

FileRead, ThisUMID, Privat\Setting

If (Decode(ThisUMID) != UUID()) {
    Gui, Verif:-Caption +HwndVerif
    Gui, Verif:Font, s15 Bold, Calibri
    Gui, Verif:Add, Picture, x0 y0 w750 h320, Img\bg.png
    Gui, Verif:Add, Text, xm ym BackgroundTrans cCA9548, % _1 " [" Version() "]"

    Gui, Verif:Add, Button, xm+667 y3 w60 h30 HwndExit gQuit, % _3
    ImageButton.Create(Exit, GrayBTN*)

    Gui, Verif:Font, s20

    Gui, Verif:Add, Edit, xm+150 ym+125 Center w400 r1 -E0x200 HwndPa vPa Password
    CtlColors.Attach(Pa, "0xFFFFFF", "FF0000")

    Gui, Verif:Add, Button, xm+203 ym+125 w300 h50 HwndEnter vEnter gEnter Hidden, % _2
    ImageButton.Create(Enter, RedBTN*)

    ;Gui, Verif:Add, Button, xm+500 ym+120 w100 h30, + User
    ;Gui, Verif:Add, Button, xm+600 ym+120 w100 h30, - User
    ;
    ;Gui, Verif:Add, Text, xm ym+75 0x10 w700
    ;Gui, Verif:Add, Text, xm ym+76 0x10 w700
    ;Gui, Verif:Add, Text, xm ym+77 0x10 w700
    ;Gui, Verif:Add, Text, xm ym+78 0x10 w700
    ;
    ;Gui, Verif:Add, Button, xm+500 ym+200 w200 h30, Profit Calculation
    ;Gui, Verif:Add, Button, xm+500 ym+160 w200 h30, Products Definitions
    ;Gui, Verif:Add, Button, xm+500 ym+240 w200 h30, Logs Information
    ;
    ;Gui, Verif:Add, Text, xm+490 ym+78 h220 0x11
    ;Gui, Verif:Add, Text, xm+488 ym+78 h220 0x11
    ;
    ;Gui, Verif:Font, s20
    ;
    ;Gui, Verif:Add, Button, xm+125 ym+120 w250 h70, Open My Cash Box
    ;Gui, Verif:Add, Button, xm+125 ym+200 w250 h70, Close (Log Out)
    ;GuiControl, Verif:Focus, Open My Cash Box

    Gui, Verif:Show, w750 h320
} Else
GoSub, Enter
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

Enter:
    Gui, Verif:Destroy
    Gui, Main:-Caption +HwndMain
    Gui, Main:Add, Picture, x0 y0 w750 h320, Img\bg.png
    Gui, Main:Font, s15 Bold, Calibri

    Gui, Main:Add, Text, xm ym+20 BackgroundTrans cCA9548, % _1 " [" Version() "]"

    Gui, Main:Add, Button, xm+603 ym+14 w126 h43 HwndExit gQuit, % _3
    ImageButton.Create(Exit, [[0, "Img\E_Normal.png",, 0xFF0000]
                          , [0, "Img\E_Hover.png" ,, 0xFFFFFF]
                          , [0, "Img\E_Hover.png" ,, 0xFF0000]]*)

    Gui, Main:Font, s25
    Gui, Main:Add, Button, xm+173 ym+97 HwndCB w372 h123 gOpenMain, % _4
    ImageButton.Create(CB, [[0, "Img\CB_Normal.png",, 0xFFFF00]
                          , [0, "Img\CB_Hover.png" ,, 0xFFFFFF]
                          , [0, "Img\CB_Hover.png" ,, 0xFFFF00]]*)

    Gui, Main:Font, s15
    Gui, Main:Add, Button, x5 ym+260 HwndDef w119 h40, % _5
    ImageButton.Create(Def, [[0, "Img\D_Normal.png",, 0x00FF00]
                          , [0, "Img\D_Hover.png" ,, 0xFFFFFF]
                          , [0, "Img\D_Hover.png" ,, 0x00FF00]]*)
    
    Gui, Main:Add, Button, x125 ym+260 HwndSto w119 h40, % _6
    ImageButton.Create(Sto, [[0, "Img\S_Normal.png",, 0x00FF00]
                            , [0, "Img\S_Hover.png" ,, 0xFFFFFF]
                            , [0, "Img\S_Hover.png" ,, 0x00FF00]]*)
    
    Gui, Main:Add, Button, x245 ym+261 HwndProf w120 h40, % _7
    ImageButton.Create(Prof, [[0, "Img\P_Normal.png",, 0x00FF00]
                            , [0, "Img\P_Hover.png" ,, 0xFFFFFF]
                            , [0, "Img\P_Hover.png" ,, 0x00FF00]]*)
                        

    Gui, Main:Show, w750 h320
Return

OpenMain:
    If !WinExist("ahk_id " Sell) {
        Gui, Seller:-Caption +HwndSell
        Gui, Seller:Color, White
        Gui, Seller:Font, s15 Bold, Calibri
        Gui, Seller:Add, Button, xm+915 y5 w60 h30 HwndExit gQuitSeller, % _3
        ImageButton.Create(Exit, RedBTN*)
    }
    Gui, Seller:Show, w1000 h700
Return

QuitSeller:
    Gui, Seller:Destroy
Return

Quit:
ExitApp

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