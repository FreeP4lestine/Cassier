;///////////////////////////////////////////////////////////////////////////////////////////////////////
/*
    Setup Logging GUI
*/
;///////////////////////////////////////////////////////////////////////////////////////////////////////
Gui, Startup:Show, w820 h400, % _108
Gui, Startup: +HwndStart -MinimizeBox
Gui, Startup:Font, s12 Bold Italic, Calibri
Gui, Startup:Color, 0xD8D8AD
Gui, Startup:Add, Pic, x250 ym+100 vLogoUser, % "Img\User.png"
Gui, Startup:Add, Pic, xp yp+70 vLogoPass, % "Img\Keys.png"
Gui, Startup:Add, Text, x330 ym+100 w200 vAdminNameText BackgroundTrans, % "*" _110 ":"
Gui, Startup:Font, Norm Bold
Gui, Startup:Add, Edit, w200 vAdminName HwndHCtrl -E0x200 Border
CtlColors.Attach(HCtrl, "FFFFFF", "000000")
Gui, Startup:Font, Italic
Gui, Startup:Add, Text, xp yp+40 w200 vAdminPassText BackgroundTrans, % "*" _111 ":"
Gui, Startup:Font, Norm Bold
Gui, Startup:Add, Edit, w200 vAdminPass HwndHCtrl -E0x200 Border
CtlColors.Attach(HCtrl, "FFFFFF", "FF0000")
Gui, Startup:Font, s10
Gui, Startup:Add, CheckBox, w200 vSaveInput HwndHCtrl gRememberLogin, % _32
CtlColors.Attach(HCtrl, "D8D8AD")
Gui, Startup:Font, Norm Bold
Gui, Startup:Add, Button, x45 ym+330 w101 h35 HwndHCtrl gLaunchKeyboard
ImageButton.Create(HCtrl, [[0, "Img\KBD\1.png"]
                         , [0, "Img\KBD\2.png"]
                         , [0, "Img\KBD\3.png"]
                         , [0, "Img\KBD\4.png"]]*)

If LicenseExists() {
    GuiControl, Startup:, AdminNameText, % _35 ":"
    GuiControl, Startup:, AdminPassText, % _88 ":"
    Gui, Startup:Add, Button, xm+720 ym+330 w40 h40 HwndHCtrl vNext gNextLog
    ImageButton.Create(HCtrl, [ [0, "Img\NEXT\1.png"]
                              , [0, "Img\NEXT\2.png"]
                              , [0, "Img\NEXT\3.png"]
                              , [0, "Img\NEXT\4.png"]]*)
    Gui, Startup:Add, Button, xp-50 yp w40 h40 HwndHCtrl vPrev gPrevLog
    ImageButton.Create(HCtrl, [ [0, "Img\PREV\1.png"]
                              , [0, "Img\PREV\2.png"]
                              , [0, "Img\PREV\3.png"]
                              , [0, "Img\PREV\4.png"]]*)
    Gui, Startup:Add, Button, x375 y270 HwndHCtrl vNewUser gNewUser w100 h30 Left, % "           " _150
    ImageButton.Create(HCtrl, [ [0, "Img\NU\1.png",, 0x008000]
                              , [0, "Img\NU\2.png",, 0x008000]
                              , [0, "Img\NU\3.png",, 0x008000]
                              , [0, "Img\NU\4.png",, 0x999999]]*)
    IniRead, Save, % "Config.ini", % "Config", % "Save"
    If (RD := DB_Read("Sets\" Save ".chu")) {
        GuiControl, Startup:, AdminName, % Save
        AdminPass := StrReplace(StrReplace(RD, "|"), ";")
        GuiControl, Startup:, AdminPass, % AdminPass
        GuiControl, Startup:, SaveInput, 1
    }
} Else {
    Gui, Startup:Add, Button, xm+720 ym+330 w40 h40 HwndHCtrl vNext gNextNewLog
    ImageButton.Create(HCtrl, [ [0, "Img\NEXT\1.png"]
                              , [0, "Img\NEXT\2.png"]
                              , [0, "Img\NEXT\3.png"]
                              , [0, "Img\NEXT\4.png"]]*)
}
Return

LaunchKeyboard:
    Run, osk.exe
Return

RememberLogin:
    GuiControlGet, AdminName, Startup:, AdminName
    GuiControlGet, AdminPass, Startup:, AdminPass
    GuiControlGet, SaveInput, Startup:, SaveInput
    If (RD := DB_Read("Sets\" AdminName ".chu")) {
        If (SaveInput)
            IniWrite, % AdminName, % "Config.ini", Config, Save
        Else
            IniWrite, % "", % "Config.ini", Config, Save
    }
Return

NextLog:
    GuiControlGet, AdminName, Startup:, AdminName
    GuiControlGet, AdminPass, Startup:, AdminPass
    
    If !FileExist("Sets\" AdminName ".chu") {
        MsgBox, 48, % _112 , % _166
        Return
    }

    If (!RD := DB_Read("Sets\" AdminName ".chu")) {
        MsgBox, 48, % _112 , % _166
        Return
    }

    If (StrReplace(StrReplace(RD, "|"), ";") != AdminPass) {
        MsgBox, 48, % _112 , % _166
        Return
    }

    GuiControlGet, SaveInput, Startup:, SaveInput
    If (SaveInput)
        IniWrite, % AdminName, % "Config.ini", Config, Save
    Else
        IniWrite, % "", % "Config.ini", Config, Save

    Gui, Startup: +Disabled
    Gui, Load:Show
    If WinExist("ahk_id " Ur)
        Gui, Users:Hide

    GuiControl, Startup:Hide, LogoUser
    GuiControl, Startup:Hide, LogoPass
    GuiControl, Startup:Hide, AdminNameText
    GuiControl, Startup:+Disabled +Center, AdminName
    GuiControl, Startup:Move, AdminName, x4 y7
    GuiControl, Startup:Hide, AdminPassText
    GuiControl, Startup:Hide, AdminPass
    GuiControl, Startup:Disabled, Next
    GuiControl, Startup:Enabled, PREV
    GuiControl, Startup:Hide, SaveInput
    GuiControl, Startup:Hide, NewUser
    Gui, Startup:Font, s10
    Gui, Startup:Add, Edit, x1 ym+30 w199 r19 -E0x200 -VScroll HwndHCtrl ReadOnly Center, % "`nCash Helper v" Version() " Released!"
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
    CtlColors.Attach(HCtrl, "D8D8AD")
    Loop, 9 {
        Gui, Startup:Add, Text, % "y" A_Index + 6 " x" 210 + A_Index " w425 h1 HwndHCtrl"
        CtlColors.Attach(HCtrl, "717100")
    }
    Gui, Startup:Add, Text, % "y16 x221 w595 h2 HwndHCtrl"
    CtlColors.Attach(HCtrl, "717100")
    Gui, Startup:Add, Edit, xm+630 y2 w180 vNowTime -E0x200 HwndHCtrl Center h15, ---
    CtlColors.Attach(HCtrl, "D8D8AD")
    Loop, 10 {
        Gui, Startup:Add, Text, % "y" A_Index + 7 " x" 207 + A_Index " w1 h381 HwndHCtrl"
        CtlColors.Attach(HCtrl, "717100")
    }
    Loop, 10 {
        Gui, Startup:Add, Text, % "y" A_Index + 388 " x" 5 + A_Index " w198 h1 HwndHCtrl"
        CtlColors.Attach(HCtrl, "717100")
    }
    
    PrevSelection := ""
    Gui, Startup:Font, s12
    Gui, Startup:Add, Button, xp+210 ym+15 w140 h90 gOpenMain HwndHCtrl vOpenMain, % "`n`n`n" _115
    ImageButton.Create(HCtrl, [ [0, "Img\OM\1.png"]
                              , [0, "Img\OM\2.png",, 0x0080FF]
                              , [0, "Img\OM\3.png",, 0xFF0000]
                              , [0, "Img\OM\4.png"]]*)
    Gui, Main:+Resize +HwndMain
    Gui, Main:Margin, 10, 10
    Gui, Main:Color, 0xD8D8AD
    Gui, Main:Font, s12 Bold, Calibri
    Gui, Main:Add, Button, % "x" A_ScreenWidth - 120 " y" A_ScreenHeight - 110 " w101 h35 HwndHCtrl gLaunchKeyboard"
    ImageButton.Create(HCtrl, [[0, "Img\KBD\1.png"]
                             , [0, "Img\KBD\2.png"]
                             , [0, "Img\KBD\3.png"]
                             , [0, "Img\KBD\4.png"]]*)
    Gui, Main:Add, Button, xm ym HwndHCtrl w192 h40 gOpenMain Left vOpenMain1, % "                " _115
    ImageButton.Create(HCtrl, [[0, "Img\LMBOM\1.png"]
                             , [0, "Img\LMBOM\2.png",, 0x0080FF, 3, , 0xD8D8AD]
                             , [0, "Img\LMBOM\3.png",, 0xFF0000, 3, , 0xD8D8AD]
                             , [0, "Img\LMBOM\4.png"]]*)
    If InStr(RD, ";") {
        Gui, Startup:Add, Button, xp+150 yp w140 h90 gSubmit HwndHCtrl vSubmit, % "`n`n`n" _116
        ImageButton.Create(HCtrl, [ [0, "Img\ED\1.png"]
                                  , [0, "Img\ED\2.png",, 0x0080FF]
                                  , [0, "Img\ED\3.png",, 0xFF0000]
                                  , [0, "Img\ED\4.png"]]*)
        Gui, Startup:Add, Button, xp+150 yp w140 h90 gDefine HwndHCtrl vDefine, % "`n`n`n" _117
        ImageButton.Create(HCtrl, [ [0, "Img\DE\1.png"]
                                  , [0, "Img\DE\2.png",, 0x0080FF]
                                  , [0, "Img\DE\3.png",, 0xFF0000]
                                  , [0, "Img\DE\4.png"]]*)
        Gui, Startup:Add, Button, xp+150 yp w140 h90 gStockPile HwndHCtrl vStockpile, % "`n`n`n" _118
        ImageButton.Create(HCtrl, [ [0, "Img\ST\1.png"]
                                  , [0, "Img\ST\2.png",, 0x0080FF]
                                  , [0, "Img\ST\3.png",, 0xFF0000]
                                  , [0, "Img\ST\4.png"]]*)
        Gui, Startup:Add, Button, xp-450 yp+100 w140 h90 gProf HwndHCtrl vProf, % "`n`n`n" _119
        ImageButton.Create(HCtrl, [ [0, "Img\PR\1.png"]
                                  , [0, "Img\PR\2.png",, 0x0080FF]
                                  , [0, "Img\PR\3.png",, 0xFF0000]
                                  , [0, "Img\PR\4.png"]]*)
                                    Gui, Startup:Add, Button, xp+150 yp w140 h90 gKridi HwndHCtrl vKridi, % "`n`n`n" _121
        ImageButton.Create(HCtrl, [ [0, "Img\KR\1.png"]
                                  , [0, "Img\KR\2.png",, 0x0080FF]
                                  , [0, "Img\KR\3.png",, 0xFF0000]
                                  , [0, "Img\KR\4.png"]]*)
        Gui, Startup:Add, Button, xp+150 yp w140 h90 gManage HwndHCtrl vManage, % "`n`n`n" _120
        ImageButton.Create(HCtrl, [ [0, "Img\MN\1.png"]
                                  , [0, "Img\MN\2.png",, 0x0080FF]
                                  , [0, "Img\MN\3.png",, 0xFF0000]
                                  , [0, "Img\MN\4.png"]]*)
        Gui, Startup:Add, Button, xp+150 yp w140 h90 gProgress HwndHCtrl vProgress, % "`n`n`n" _163
        ImageButton.Create(HCtrl, [ [0, "Img\PG\1.png"]
                                  , [0, "Img\PG\2.png",, 0x0080FF]
                                  , [0, "Img\PG\3.png",, 0xFF0000]
                                  , [0, "Img\PG\4.png"]]*)
        Gui, Main:Add, Button, xp yp+42 HwndHCtrl w192 h40 gSubmit Left vSubmit1, % "                " _116
        ImageButton.Create(HCtrl, [[0, "Img\LMBED\1.png"]
                                 , [0, "Img\LMBED\2.png",, 0x0080FF, 3, , 0xD8D8AD]
                                 , [0, "Img\LMBED\3.png",, 0xFF0000, 3, , 0xD8D8AD]
                                 , [0, "Img\LMBED\4.png"]]*)
        Gui, Main:Add, Button, xp yp+42 HwndHCtrl w192 h40 gDefine Left vDefine1, % "                " _117
        ImageButton.Create(HCtrl, [[0, "Img\LMBDE\1.png"]
                                 , [0, "Img\LMBDE\2.png",, 0x0080FF, 3, , 0xD8D8AD]
                                 , [0, "Img\LMBDE\3.png",, 0xFF0000, 3, , 0xD8D8AD]
                                 , [0, "Img\LMBDE\4.png"]]*)
        Gui, Main:Add, Button, xp yp+42 HwndHCtrl w192 h40 gStockPile Left vStockpile1, % "                " _118
        ImageButton.Create(HCtrl, [[0, "Img\LMBST\1.png"]
                                 , [0, "Img\LMBST\2.png",, 0x0080FF, 3, , 0xD8D8AD]
                                 , [0, "Img\LMBST\3.png",, 0xFF0000, 3, , 0xD8D8AD]
                                 , [0, "Img\LMBST\4.png"]]*)
        Gui, Main:Add, Button, xp yp+42 HwndHCtrl w192 h40 gProf Left vProf1, % "                " _119
        ImageButton.Create(HCtrl, [[0, "Img\LMBPR\1.png"]
                                 , [0, "Img\LMBPR\2.png",, 0x0080FF, 3, , 0xD8D8AD]
                                 , [0, "Img\LMBPR\3.png",, 0xFF0000, 3, , 0xD8D8AD]
                                 , [0, "Img\LMBPR\4.png"]]*)
        Gui, Main:Add, Button, xp yp+42 HwndHCtrl w192 h40 gKridi Left vKridi1, % "                " _121
        ImageButton.Create(HCtrl, [[0, "Img\LMBKR\1.png"]
                                 , [0, "Img\LMBKR\2.png",, 0x0080FF, 3, , 0xD8D8AD]
                                 , [0, "Img\LMBKR\3.png",, 0xFF0000, 3, , 0xD8D8AD]
                                 , [0, "Img\LMBKR\4.png"]]*)
        Gui, Main:Add, Button, xp yp+42 HwndHCtrl w192 h40 gManage Left vManage1, % "                " _120
        ImageButton.Create(HCtrl, [[0, "Img\LMBMN\1.png"]
                                 , [0, "Img\LMBMN\2.png",, 0x0080FF, 3, , 0xD8D8AD]
                                 , [0, "Img\LMBMN\3.png",, 0xFF0000, 3, , 0xD8D8AD]
                                 , [0, "Img\LMBMN\4.png"]]*)
        Gui, Main:Add, Button, xp yp+42 HwndHCtrl w192 h40 gProgress Left vProgress1, % "                " _163
        ImageButton.Create(HCtrl, [[0, "Img\LMBPG\1.png"]
                                 , [0, "Img\LMBPG\2.png",, 0x0080FF, 3, , 0xD8D8AD]
                                 , [0, "Img\LMBPG\3.png",, 0xFF0000, 3, , 0xD8D8AD]
                                 , [0, "Img\LMBPG\4.png"]]*)
    }
    Loop, 10 {
        Gui, Main:Add, Text, % "y" A_Index + 10 " x" 210 + A_Index " w" A_ScreenWidth - 410 " h1 HwndHCtrl"
        CtlColors.Attach(HCtrl, "717100")
    }
    
    Gui, Main:Add, Text, % "y21 x221 w" A_ScreenWidth - 230 " h2 HwndHCtrl"
    CtlColors.Attach(HCtrl, "717100")
    Gui, Main:Add, Edit, % "x" A_ScreenWidth - 189 " y5 w180 vNowTime -E0x200 HwndHCtrl Center h15", ---
    CtlColors.Attach(HCtrl, "D8D8AD")
    Loop, 10 {
        Gui, Main:Add, Text, % "y" A_Index + 12 " x" 208 + A_Index " w1 h" A_ScreenHeight - 90 " HwndHCtrl"
        CtlColors.Attach(HCtrl, "717100")
    }
    Loop, 10 {
        Gui, Main:Add, Text, % "y" A_Index + A_ScreenHeight - 78 " x" 3 + A_Index " w203 h1 HwndHCtrl"
        CtlColors.Attach(HCtrl, "717100")
    }

    Gui, Startup: -Disabled
    Gui, Load:Hide
    SetTimer, NowTime, 1000
Return

PrevLog:
    Reload
Return

NewUser:
    GuiControlGet, AdminName, StartUp:, AdminName
    GuiControlGet, AdminPass, StartUp:, AdminPass
    ThisUser := DB_Read("Sets\" AdminName ".chu")
    If InStr(ThisUser, ";") && (StrReplace(StrReplace(ThisUser, "|"), ";") = AdminPass) {
        GuiControl, Users:, ULB, |
        GuiControl, Users:, EName
        GuiControl, Users:, EPass
        Ind := 0
        Loop, Files, Sets\*.chu
        {
            If (RD := DB_Read(A_LoopFileFullPath)) {
                Name := SubStr(A_LoopFileName, 1, - 4)
                GuiControl, Users:, ULB, %  Name
            }
        }
        Gui, Users:Show
        GuiControl, Users:Focus, EName
    } Else {
        MsgBox, 48, % _112 , % _151
    }
Return

NextNewLog:
    Gui, Startup:Submit, NoHide
    If ((AdminName AdminPass) ~= ";|\||/") && (AdminPass != "") && (AdminPass != "") {
        MsgBox, 48, % _112 , % _113
        Return
    }
    WriteLicense()
    GuiControlGet, SaveInput, StartUp:, SaveInput
    DB_Write("Sets\" AdminName ".chu", AdminPass ";")
    If (SaveInput)
        IniWrite, % AdminName, % "Config.ini", Config, Save
    Reload
Return
;///////////////////////////////////////////////////////////////////////////////////////////////////////