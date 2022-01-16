
#NoEnv
#Persistent
SendMode Input
SetWorkingDir %A_ScriptDir%

#Include, <Class_CtlColors>
#Include, <Class_ImageButton>
#Include, <UseGDIP>
#Include, <Class_LVColors>

OnMessage(0x201, "WM_LBUTTONDOWN")

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

;==============================================================================

Gui, Main:-Caption +HwndMain MinSize1000x600
Gui, Main:Font, s10 Bold, Calibri
Gui, Main:Color, 0xD8D8AD
LoadBackground()

Gui, Main:Add, Text, x0 y0 w1000 h10 HwndTopText vTText
CtlColors.Attach(TopText, "3F627F", "000000")

Gui, Main:Add, Text, xm+75 ym+446 w50 BackgroundTrans c800000 vVer, % "v" Version()

If !CheckLicense() {
    Gui, Main:Add, Picture, x0 y10 h419 vLicPic, Img\Lic.png
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
CtlColors.Attach(E, "D8D8AD", "000000")

Gui, Main:Add, Edit, xm y528 HwndE w175 vSoldP -E0x200 ReadOnly Center Border, 0
CtlColors.Attach(E, "D8D8AD", "008000")

Gui, Main:Add, Edit, xm y556 HwndE w175 vProfitP -E0x200 ReadOnly Center Border, 0
CtlColors.Attach(E, "D8D8AD", "FF0000")

; Main Controls
RMS := "#1"
MainCtrlList := "Bc,Nm,Stck,Qn,Sum,OpenSess,LV0,$GivenMoney,$AllSum,$Change"
;Gui, Main:Add, Text, xm+360 ym+10 w100 vBcText Right, % _27
Ind := "", Xb := 217
Gui, Main:Font, s25, Calibri
Gui, Main:Add, Edit, xm+380 ym+10 w250 -VScroll vBc Center -E0x200 gAnalyzeAvail Border HwndBc_ Hidden
CtlColors.Attach(Bc_, "FFFFFF", "008000")
Gui, Main:Add, Edit, xm+205 ym+10 w175 vStck -E0x200 ReadOnly HwndE Center Hidden
CtlColors.Attach(E, "D8D8AD", "FF0000")
Gui, Main:Add, Edit, xm+205 ym+70 w250 vNm -E0x200 ReadOnly HwndNm Center Hidden
CtlColors.Attach(Nm, "FFFFFF", "000080")
Gui, Main:Add, Edit, xm+455 ym+70 w260 vQn Center -E0x200 ReadOnly HwndQn gAnalyzeQn Hidden, x1
CtlColors.Attach(Qn, "FFFFFF", "008000")
Gui, Main:Add, Edit, xm+715 ym+70 w250 vSum -E0x200 ReadOnly HwndSum Center Hidden
CtlColors.Attach(Sum, "FFFFFF", "800000")

Loop, 7 {
    Gui, Main:Add, Button, xm+%Xb% ym+300 w100 h48 vOpenSess%Ind% HwndBtn gUpdateSession Center, % A_Index
    MainCtrlList .= ",OpenSess" Ind
    ImageButton.Create(Btn, BMBTN*)
    Ind := A_Index
    Xb += 100
}

Gui, Main:Font, s50
Gui, Main:Add, Edit, xm+205 ym+10 w254 vGivenMoney -E0x200 gCalc Center Hidden
Gui, Main:Add, Edit, xm+460 ym+10 w254 vAllSum HwndAS -E0x200 ReadOnly Center Hidden
CtlColors.Attach(AS, "FFFFFF", "008000")
Gui, Main:Add, Edit, xm+715 ym+10 w252 vChange HwndC -E0x200 ReadOnly Center Hidden
CtlColors.Attach(C, "FFFFFF", "FF0000")
Gui, Main:Font, s15
Gui, Main:Add, ListView, xm+205 ym+135 w760 r10 -Hdr Grid vLV0 BackgroundFCEFDC HwndHLV Hidden, Barcode|Name|Quantity|Price
Gui, Main:Default
Gui, Main:ListView, LV0
LV_ModifyCol(1, "0 Center")
LV_ModifyCol(2, "250 Center")
LV_ModifyCol(3, "254 Center")
LV_ModifyCol(4, "252 Center")

GuiControl, Main: Disabled, OpenSess
GuiControl, Main: +Redraw, OpenSess
;ThisInst := New LV_Colors(HLV)
;ThisInst.SelectionColors("0x00FF00", "0x000000")

; ==========================================================================================================

; Ensure Dot Controls
EnsureCtrlList := "LV1,EnsBtn,Sold,Bought,ProfitEq"
Gui, Main:Font, s25
Gui, Main:Add, Button, xm+205 ym+30 vEnsBtn w760 h80 hwndBtn Hidden gValid, % _9
ImageButton.Create(Btn, EBTN*)
Gui, Main:Font, s15
Gui, Main:Add, ListView, xm+205 ym+135 w760 r10 -Hdr Grid vLV1 BackgroundDEFCDC HwndHLV Hidden, SO
;ThisInst := New LV_Colors(HLV)
;ThisInst.SelectionColors("0x00FF00", "0x000000")

Gui, Main:Default
Gui, Main:ListView, LV1
LV_ModifyCol(1, "w760 Center")

Gui, Main:Font, s40
Gui, Main:Add, Edit, xm+206 ym+430 w260 vSold Center -E0x200 ReadOnly HwndE gAnalyzeQn Hidden
CtlColors.Attach(E, "00FF00", "000000")
Gui, Main:Add, Edit, xm+456 ym+430 w260 vBought -E0x200 ReadOnly HwndE Center Hidden
CtlColors.Attach(E, "FF8080", "000000")
Gui, Main:Add, Edit, xm+716 ym+430 w260 vProfitEq -E0x200 ReadOnly HwndE Center Hidden
CtlColors.Attach(E, "00FF00", "000000")

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
Gui, Main:Add, ListView, xm+205 ym+135 w760 r10 -Hdr Grid vLV2 HwndHLV BackgroundDCFCF9 Hidden gEdit, Barcode|Name|Quantity|Price
;ThisInst := New LV_Colors(HLV)
;ThisInst.SelectionColors("0x00FF00", "0x000000")

Gui, Main:Default
Gui, Main:ListView, LV2
LV_ModifyCol(1, "185 Center")
LV_ModifyCol(2, "192 Center")
LV_ModifyCol(3, "192 Center")
LV_ModifyCol(4, "186 Center")
; ==========================================================================================================

; StockPile Controls
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
Gui, Main:Add, ListView, xm+205 ym+135 w760 r10 -Hdr Grid vLV3 BackgroundF4FCDC HwndHLV gDisplayQn Hidden, Barcode|Name|Quantity|ThisSum
;ThisInst := New LV_Colors(HLV)
;ThisInst.SelectionColors("0x00FF00", "0x000000")

Gui, Main:Default
Gui, Main:ListView, LV3
LV_ModifyCol(1, "0 Center")
LV_ModifyCol(2, "377 Center")
LV_ModifyCol(3, "380 Center")
LV_ModifyCol(4, "380 Center")
; ==========================================================================================================

; Profit Controls
ProfitCtrlList := "SPr,CPr,OAProfit,LV4"
Gui, Main:Font, s15

Gui, Main:Add, ListView, xm+205 ym+135 w760 r10 -Hdr Grid vLV4 BackgroundFCDCDC HwndHLV gDisplayQn Hidden, Date|BP|SP|Pr
;ThisInst := New LV_Colors(HLV)
;ThisInst.SelectionColors("0x00FF00", "0x000000")

Gui, Main:Add, Edit, xm+776 ym+90 -E0x200 ReadOnly vOAProfit w189 Hidden Center cRed Border HwndE
CtlColors.Attach(E, "00FF00", "000000")
Gui, Main:Add, Edit, xm+586 ym+90 -E0x200 ReadOnly vCPr w189 Hidden Center cRed Border HwndE
CtlColors.Attach(E, "FF8080", "000000")
Gui, Main:Add, Edit, xm+396 ym+90 -E0x200 ReadOnly vSPr w189 Hidden Center cRed Border HwndE
CtlColors.Attach(E, "00FF00", "000000")

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

Gosub, OpenMain

LastMDate := ""
Table := ["A", "B", "C", "D", "E", "F"]

SetTimer, Update, 250

FileGetTime, PBMData, Sets\PD.db, M

Global ProdDefs
If FileExist("Sets\PD.db")
    ProdDefs := LoadDefinitions(DB_Read("Sets\PD.db"))
HLM := 1
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
Return

UpdateSession:
    Gui, Main:Submit, NoHide
    Loop, Parse, % ",1,2,3,4,5,6", `,
        GuiControl, Main:Enable, % "OpenSess" A_LoopField
    GuiControl, Main:Disabled, % A_GuiControl
    RegExMatch(A_GuiControl, "\d", Mark)
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
Return

InfoButtonOK:
    Gui, Info:Destroy
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

    InitY := 108
    GuiControl, Main:Move, % "ItemsSold", % "y" Height - InitY - (50 * 2)
    GuiControl, Main:Move, % "SoldP", % "y" Height - InitY - 50
    GuiControl, Main:Move, % "ProfitP", % "y" Height - InitY
    GuiControl, Main:+Redraw, % "ItemsSold"
    GuiControl, Main:+Redraw, % "SoldP"
    GuiControl, Main:+Redraw, % "ProfitP"

    Third := (Width - 217) // 3

    If (RMS = "#1") {
    ; #1
        GuiControl, Main:Move, % "Bc", % "w" Third
        GuiControl, Main:Move, % "Nm", % "w" Third
        GuiControl, Main:Move, % "Qn", % "x" Third + 217 " w" Third
        GuiControl, Main:Move, % "Sum", % "x" (Third * 2) + 217 " w" Third

        GuiControl, Main:Move, % "LV0", % "w" (Third * 3) " h" Height - 260

        Gui, Main:ListView, LV0
        LV_ModifyCol(2, (Val := Third) - 1)
        LV_ModifyCol(3, Val - 2)
        LV_ModifyCol(4, Val - 1)

        GuiControl, Main:Move, % "GivenMoney", % "w" Third
        GuiControl, Main:Move, % "AllSum", % "x" Third + 217 " w" Third
        GuiControl, Main:Move, % "Change", % "x" (Third * 2) + 217 " w" Third

        GuiControl, Main:Move, % "OpenSess", % "x" 216 " y" Height - 108
        GuiControl, Main:+Redraw, % "OpenSess"
        GuiControl, Main:Move, % "OpenSess" 1, % "x" 319 " y" Height - 108
        GuiControl, Main:+Redraw, % "OpenSess" 1
        GuiControl, Main:Move, % "OpenSess" 2, % "x" 421 " y" Height - 108
        GuiControl, Main:+Redraw, % "OpenSess" 2
        GuiControl, Main:Move, % "OpenSess" 3, % "x" 523 " y" Height - 108
        GuiControl, Main:+Redraw, % "OpenSess" 3
        GuiControl, Main:Move, % "OpenSess" 4, % "x" 625 " y" Height - 108
        GuiControl, Main:+Redraw, % "OpenSess" 4
        GuiControl, Main:Move, % "OpenSess" 5, % "x" 727 " y" Height - 108
        GuiControl, Main:+Redraw, % "OpenSess" 5
        GuiControl, Main:Move, % "OpenSess" 6, % "x" 829 " y" Height - 108
        GuiControl, Main:+Redraw, % "OpenSess" 6
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
    If WinActive("ahk_id " Main) {
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
            If (PBMData != ThisMData) {
                ProdDefs := LoadDefinitions(DB_Read("Sets\PD.db"))
            }
        }

        If (RMS = "#1") {
            GuiControlGet, Visi, Main:Visible, Nm
            If (Visi) {
                GuiControlGet, Foc, Main:Focus
                If !(Foc ~= "bEdit1|SysListView321|Button\d+\b") {
                    GuiControl, Main:Focus, Bc
                }
            }
        }
    }
Return

OpenMain:
    RMS := "#1"
    Gosub, MainGuiSize
    Loop, Parse, % "12435"
        GuiControl, Main:Disabled, Btn%A_LoopField%
    Hide(EnsureCtrlList "," DefineCtrlList "," StockPileCtrlList "," ProfitCtrlList)
    Show(MainCtrlList)
    Gui, Main:ListView, LV0
    Gui, Main:Submit, NoHide
    ;CheckSession(OpenSess)
    Loop, Parse, % "2435"
        GuiControl, Main:Enabled, Btn%A_LoopField%

    If FileExist("Dump\" SessionID ".db")
        RestoreSession(DB_Read("Dump\" SessionID ".db"))
Return

Submit:
    RMS := "#2"
    Gosub, MainGuiSize
    Loop, Parse, % "12435"
        GuiControl, Main:Disabled, Btn%A_LoopField%
    Hide(MainCtrlList "," DefineCtrlList "," StockPileCtrlList "," ProfitCtrlList)
    Show(EnsureCtrlList)
    Gui, Main:ListView, LV1
    GuiControl, Main:Enabled, EnsBtn
    LoadCurrent()
    Loop, Parse, % "1234"
        GuiControl, Main:Enabled, Btn%A_LoopField%
Return

Define:
    RMS := "#3"
    Gosub, MainGuiSize
    Loop, Parse, % "12435"
        GuiControl, Main:Disabled, Btn%A_LoopField%
    Hide(MainCtrlList "," EnsureCtrlList "," StockPileCtrlList "," ProfitCtrlList)
    Show(DefineCtrlList)
    Gui, Main:ListView, LV2
    LoadDefined()
    Loop, Parse, % "1435"
        GuiControl, Main:Enabled, Btn%A_LoopField%
Return

StockPile:
    RMS := "#4"
    Gosub, MainGuiSize
    Loop, Parse, % "12435"
        GuiControl, Main:Disabled, Btn%A_LoopField%
    Hide(MainCtrlList "," EnsureCtrlList "," DefineCtrlList "," ProfitCtrlList)
    Show(StockPileCtrlList)
    Gui, Main:ListView, LV3
    LoadStockList()
    Loop, Parse, % "1245"
        GuiControl, Main:Enabled, Btn%A_LoopField%
Return

Prof:
    RMS := "#5"
    Gosub, MainGuiSize
    Loop, Parse, % "12435"
        GuiControl, Main:Disabled, Btn%A_LoopField%
    Hide(MainCtrlList "," EnsureCtrlList "," DefineCtrlList "," StockPileCtrlList)
    Show(ProfitCtrlList)
    Gui, Main:ListView, LV4
    LoadProf()
    Loop, Parse, % "1235" 
        GuiControl, Main:Enabled, Btn%A_LoopField%
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
    If (GivenMoney >= AllSum) {
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
    GuiControl, Main:Focus, Pnm
    PostMessage, 0xB1, 0, -1,, % "ahk_id " Pnm_
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
        ;ToolTip, % SessionID
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
        GuiControl, Main:Focus, Bc
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
        GuiControl, Main:Focus, Bc
    }
    Sleep, 125
Return
#If

#If WinActive("ahk_id " Main)
Tab::
    If (HLM := !HLM) {
        Loop, Parse, % "ItemsSold,SoldP,ProfitP", `,
            GuiControl, Main:Show, % A_LoopField
    } Else {
        Loop, Parse, % "ItemsSold,SoldP,ProfitP", `,
            GuiControl, Main:Hide, % A_LoopField
    }
    Sleep, 125
Return
#If 

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
            GuiControl, Main:, Bc, % Bc "."
            Bc := Bc "."

            Loop, Parse, % Trim(Bc, "."), % "."
            {
                If (ProdDefs["" A_LoopField ""] != "") {
                    ThisQ := StrSplit(Qn, "x")[2]
                    JobDone := 0
                    Loop, % LV_GetCount() {
                        LV_GetText(ThisBc, A_Index, 1)

                        If (ThisBc = A_LoopField) {
                            LV_GetText(ThisQn, A_Index, 3)
                            LV_GetText(ThisSum, A_Index, 4)
                            ThisQn := StrSplit(ThisQn, "x")
                            _Qn := StrSplit(Qn, "x")
                            LV_Modify(A_Index,,,, _Qn[1] "x" ThisQn[2] + _Qn[2], _Qn[1] * (ThisQn[2] + _Qn[2]))
                            JobDone := 1
                            Break
                        }
                    }
                    If (!JobDone)
                        LV_Add("", A_LoopField, ProdDefs["" A_LoopField ""][1], ProdDefs["" A_LoopField ""][3] "x" ThisQ, ProdDefs["" A_LoopField ""][3]*ThisQ)
                    CreateNew("Bc,Nm,Qn,Sum", "LV0")
                }
            }
            GuiControl, Main:, Bc
        } Else {
            If (Change != "") {
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
                GuiControl, Main:Show, Stck

                GuiControl, Main:, Bc
                GuiControl, Main:, Nm
                GuiControl, Main:, Qn, x1
                GuiControl, Main:, Sum

                LV_Delete()
                GuiControl, Main:Focus, Bc

                If (Sessions[OpenSess]) {
                    Sessions.Remove(Sessions)
                }
            } Else {
                ShakeControl("Main", "GivenMoney")
            }
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

            If (!EditMod[1]) {
                If !(ProdDefs["" Dbc ""][1]) {
                    ProdDefs["" Dbc ""] := [Dnm,Dbp,Dsp,0]

                    genData := ""
                    For Each, Barcode in ProdDefs {
                        genData .= Each ";" Barcode[1] ";" Barcode[2] ";" Barcode[3] ";" (Barcode[4] ? Barcode[4] : 0) "|" 
                    }

                    DB_Write("Sets\PD.db", genData)
                    LV_Add("", Dbc, Dnm, Dbp, Dsp)
                    GuiControl, Main:, Dbc
                    GuiControl, Main:, Dnm
                    GuiControl, Main:, Dbp
                    GuiControl, Main:, Dsp
                    GuiControl, Main:Focus, Dbc
                } Else {
                    For Each, Barcode in ProdDefs {
                        If (Each = Dbc) {
                            Exist := 1
                            Row := A_Index
                        }
                    }
                    GuiControl, Main:Focus, LV2
                    SendInput, {Home}
                    If (Row - 1) {
                        Loop, % Row - 1
                            SendInput, {Down}
                    }
                }
            } Else {
                Exist := 0

                For Each, Barcode in ProdDefs {
                    If (Each = Dbc) && (Dbc != EditMod[2]) {
                        Exist := 1
                        Row := A_Index
                    }
                }

                If (!Exist) {
                    ProdDefs.Remove(PrevBc)
                    ProdDefs["" Dbc ""] := [Dnm,Dbp,Dsp,0]

                    genData := ""
                    For Each, Barcode in ProdDefs {
                        If (Each)
                            genData .= Each ";" Barcode[1] ";" Barcode[2] ";" Barcode[3] ";" (Barcode[4] ? Barcode[4] : 0) "|" 
                    }

                    LV_Modify(EditMod[2],, Dbc, Dnm, Dbp, Dsp)

                    DB_Write("Sets\PD.db", genData)
                    GuiControl, Main:, Dbc
                    GuiControl, Main:, Dnm
                    GuiControl, Main:, Dbp
                    GuiControl, Main:, Dsp

                    EditMod[1] := 0
                    GuiControl, Main:Focus, Dbc
                } Else {
                    GuiControl, Main:Focus, LV2
                    SendInput, {Home}
                    Loop, % Row - 1
                        SendInput, {Down}
                }
            }
        }
    } Else If (RMS = "#4") {
        If (Pnm != "") && (Pqn != "") {
            LV_GetText(BcId, Row, 1)

            ProdDefs["" BcId ""] := [ProdDefs["" BcId ""][1], ProdDefs["" BcId ""][2], ProdDefs["" BcId ""][3], Pqn]

            genData := ""
            For Each, Barcode in ProdDefs {
                If (Each)
                    genData .= Each ";" Barcode[1] ";" Barcode[2] ";" Barcode[3] ";" (Barcode[4] ? Barcode[4] : 0) "|" 
            }

            GuiControl, Main:, Psum, % Pqn "x" ProdDefs["" BcId ""][2] " = " (Pqn * ProdDefs["" BcId ""][2])
            LV_Modify(Row,,,, Pqn, Pqn "x" ProdDefs["" BcId ""][2] " = " (Pqn * ProdDefs["" BcId ""][2]))

            OverAll := 0
            For Each, Item in ProdDefs {
                OverAll := OverAll + (Item[4] * Item[2])
            }
            GuiControl, Main:, StockSum, % OverAll

            DB_Write("Sets\PD.db", genData)
        }
    } Else If (RMS = "#5") {
        SumCol1 := SumCol2 := SumCol3 := 0
        If (Row := LV_GetNext()) {
            NRow := 0
            While (NRow != Row) {
                If (A_Index = 1)
                    NRow := Row
                If (NRow) {
                    LV_GetText(C1, NRow, 2)
                    SumCol1 := SumCol1 + SubStr(C1, 3)
                    LV_GetText(C2, NRow, 3)
                    SumCol2 := SumCol2 + SubStr(C2, 3)
                    LV_GetText(C3, NRow, 4)
                    SumCol3 := SumCol3 + SubStr(C3, 3)
                }
                NRow := LV_GetNext(NRow)
            }
            GuiControl, Main:, SPr, % SumCol1
            GuiControl, Main:, CPr, % SumCol2
            GuiControl, Main:, OAProfit, % SumCol3
        } Else {
            Loop, % LV_GetCount() {
                LV_GetText(C1, A_Index, 2)
                SumCol1 := SumCol1 + SubStr(C1, 3)
                LV_GetText(C2, A_Index, 3)
                SumCol2 := SumCol2 + SubStr(C2, 3)
                LV_GetText(C3, A_Index, 4)
                SumCol3 := SumCol3 + SubStr(C3, 3)
            }
            GuiControl, Main:, SPr, % SumCol1
            GuiControl, Main:, CPr, % SumCol2
            GuiControl, Main:, OAProfit, % SumCol3
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
        CreateNew("Bc,Nm,Qn,Sum", "LV0")
    } Else {
        SendInput, {Up}
        Sleep, 125
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
        CreateNew("Bc,Nm,Qn,Sum", "LV0")
    } Else {
        SendInput, {Down}
        Sleep, 125
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

        ProdDefs.Remove("" ThisID "")

        genData := ""
        For Each, Barcode in ProdDefs {
            If (Each)
                genData .= Each ";" Barcode[1] ";" Barcode[2] ";" Barcode[3] ";" (Barcode[4] ? Barcode[4] : 0) "|" 
        }

        DB_Write("Sets\PD.db", genData)
        LV_Delete(LV_GetNext())
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
            If FileExist("Dump\" SessionID ".db")
                FileDelete, % "Dump\" SessionID ".db"
        }
    } Else {
        SendInput, {Space}
    }
    Sleep, 125
Return
#If

#If WinActive("ahk_id " Main)
^F::
    If (RMS = "#3") {
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
    } Else If (RMS = "#4") {
        Gui, Main:Submit, NoHide
        Gui, Main:Default
        ;LV_Delete()
        If (Pnm != "") {
            For Each, Item in ProdDefs {
                If (Each = RTrim(Pnm, " :")) {
                    GuiControl, Main:Focus, LV3
                    SendInput, {Home}
                    Loop, % A_Index - 1
                        SendInput, {Down}
                    GuiControl, Main:+Redraw, Pnm
                    GuiControl, Main:+Redraw, Pqn
                    Gosub, DisplayQn
                    Break
                }
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

    GuiControl, Main:, Stck
    GuiControl, Main:, Nm
    GuiControl, Main:, Sum
    Value_Qn := StrSplit(Qn, "x")

    GuiControl, Main:, Qn, % "x" Value_Qn[2]

    CtlColors.Change(Bc_, "FFFFFF", "008000")
    If (Bc) {
        If (Bc ~= "[^0-9\.]")
        {
            CtlColors.Change(Bc_, "FF8080", "008000")
            ShakeControl("Main", "Bc")
            Return
        }
        Arr := StrSplit(Bc, ".")
        Bc := Arr[Arr.MaxIndex()]
        If (ProdDefs["" Bc ""] != "") {
            GuiControl, Main:, Nm, % ProdDefs["" Bc ""][1]
            Value_Qn := StrSplit(Qn, "x")
            GuiControl, Main:, Qn, % ProdDefs["" Bc ""][3] "x" Value_Qn[2]
            GuiControl, Main:, Sum, % ProdDefs["" Bc ""][3] * Value_Qn[2]
            GuiControl, Main:, Stck, % (ProdDefs["" Bc ""][4]) ? ProdDefs["" Bc ""][4] : 0
            GuiControl, Main:, Bc, % Bc
            CreateNew("Bc,Nm,Qn,Sum", "LV0")
        }
        PostMessage, 0xB1, 0, -1,, % "ahk_id " Bc_
    }
Return

AnalyzeQn:
    Gui, Main:Submit, NoHide
    Value_Qn := StrSplit(Qn, "x")
    If (Value_Qn[1]) && (Value_Qn[2]) {
        GuiControl, Main:, Sum, % Value_Qn[1] * Value_Qn[2]
        CreateNew("Bc,Nm,Qn,Sum", "LV0")
    }
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
            LV_Add("", _19 ": " ThisTime)
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
    RD := DB_Read(A_LoopFileFullPath)
    DDS := StrSplit((Arr := StrSplit(RD, "> "))[2], ";")
    Bc := DDS[1]
    Qn := StrSplit(DDS[3], "x")[2]
    If (ProdDefs["" Bc ""][1]) {
        DB_Write(A_LoopFileFullPath, Arr[1] "> " Bc ";" ProdDefs["" Bc ""][1] ";" ProdDefs["" Bc ""][3] "x" Qn ";" ProdDefs["" Bc ""][3] * Qn ";" ProdDefs["" Bc ""][2] "x" Qn ";" ProdDefs["" Bc ""][2] * Qn "> " ProdDefs["" Bc ""][3] * Qn ";" ProdDefs["" Bc ""][2] * Qn ";" (ProdDefs["" Bc ""][3] * Qn) - (ProdDefs["" Bc ""][2] * Qn))
    }
}

LoadProf() {
    LV_Delete()
    OAPr := 0, SPr := 0, CP := 0

    Loop, Files, Valid\*.db, R F
    {
        RD := DB_Read(A_LoopFileFullPath)
        If (RD) {
            Arr := CalcProfit(RD)
            If (!Arr[2][2]) {
                Correct(A_LoopFileFullPath)
                RD := DB_Read(A_LoopFileFullPath)
                Arr := CalcProfit(RD)
            }
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
            If (!Arr[2][2]) {
                Correct(A_LoopFileFullPath)
                RD := DB_Read(A_LoopFileFullPath)
                Arr := CalcProfit(RD)
            }
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
    LV_Delete()
    For Each, Item in ProdDefs {
        LV_Add("", Each, Item[1], Item[2], Item[3])
    }
}

LoadStockList() {
    global
    LV_Delete()
    OverAll := 0
    For Each, Item in ProdDefs {
        LV_Add("", Each, Item[1], (Item[4] ? Item[4] : 0), (Item[4] ? (Item[4] "x" Item[2] " = " Item[4] * Item[2]) : 0))
        OverAll := OverAll + (Item[4] * Item[2])
    }
    GuiControl, Main:, StockSum, % OverAll
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

        If !InStr(A_LoopField, "OpenSess") {
            Loop, % LT {
                If !InStr(A_LoopField, "$") {
                    GuiControlGet, Post, Main:Pos, % A_LoopField
                    GuiControl, Main:Move, % A_LoopField, % "x" PostX - J
                }
            }
        } Else {
            GuiControlGet, Post, Main:Pos, % A_LoopField
            GuiControl, Main:Move, % A_LoopField, % "x" PostX - Width
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
    Folders := "Curr,Lib,Sets,Stoc,Valid,Dump"
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

CreateNew(Controls, LV := "", Clear := 0) {
    global
    Gui, Main:Default
    Gui, Main:ListView, LV0
    List_ := ""
    Loop, Parse, Controls, `,
    {
        GuiControlGet, Content, Main:, % A_LoopField
        If (A_LoopField = "Bc")
            List_ .= A_LoopField "=" Trim(Content, ".") ";"
        Else
            List_ .= A_LoopField "=" Content ";"
    }

    LV_ := "|"
    If (LV) {
        Loop, % LV_GetCount() {
            LV_GetText(Bc__, A_Index, 1)
            LV_GetText(Nm__, A_Index, 2)
            LV_GetText(Qn__, A_Index, 3)
            LV_GetText(Sum__, A_Index, 4)
            LV_ .= Bc__ "/" Nm__ "/" Qn__ "/" Sum__ "|"
        }
    }

    If (LV_ = "|")
        LV_ := ""
    ;ToolTip % Trim(List_, ";") LV_
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

    For Each, Item in ArrayData {
        If !InStr(Item, "|") {
            CtlVal := StrSplit(Item, "=")
            GuiControl, Main:, % CtlVal[1], % CtlVal[2]
        } Else {
            LV_Delete()
            Loop, Parse, % Trim(Item, "|"), |
            {
                If (A_Index > 1) {
                    CtlVals := StrSplit(A_LoopField, "/")
                    LV_Add("", CtlVals[1], CtlVals[2], CtlVals[3], CtlVals[4])
                }
            }
        }
    }
}

LoadDefinitions(Data) {
    Tmp := {}
    Loop, Parse, % Trim(Data, "|"), |
    {
        ThisDef := StrSplit(A_LoopField, ";")
        Tmp["" ThisDef[1] ""] := [ThisDef[2], ThisDef[3], ThisDef[4], ThisDef[5]]
    }
    Return, Tmp
}

CheckForUpdates() {
    global
    GuiControl, Startup:, Stat, % _23
    JsonKey := "{"
         . "`n  ""type"": ""service_account"","
         . "`n  ""project_id"": ""cassier"","
         . "`n  ""private_key_id"": ""a4dcb0edcb51cfb9109fffcaf9087ad77d5b89ed"","
         . "`n  ""private_key"": ""-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQC1025anDEc9hjY\nRlaQaJ6azis+uYSbl52g4S2beQ8L0CWy3ODiECrXGclV+KuHULDQGZcqKL1zDPZ4\n2P/77Et6Mr+tUqMBfV3AgWbNsvF0zfpv8c7/Oa068wV9vlzRckZK9fSJ19kdxYlf\ns7ZxeJiYndo1WD17ZUh0WElMO7eGQN7Ntgjj5Zkn5ARpBUlCVo5Ou2YItaLz0jty\nuA762PVW+GK0kv5vfXLbPNHZ35VY0RbaIPakEaeQKEC0lRNv1omiQV8DwkqPjNLD\nkCFfV2yQ+cNUNhv610r1Z79gPIcC2+bNg3DiFXuyE5iU6p78wpdZhLChYx7rVjrA\nE8sG1QrJAgMBAAECggEAEAiWCk+l29yhrtSioB2LOuU9fMyY/0Vv5RAzC6r+fJEW\nxr57TPcvzlCb55GQwqAHCQ3wpAsvclx59+8ewThovkMiXuZsffgJn+BpUDzcb1Hi\nKL2LsaFRTGNb7RovwiWcqDiNhbUIeshNoShOSS3hIVG6770ZWTvCfcWMdR7HXYNN\nqfb3CKlWw8eFfnrOu5nnuUcouSIPu9Neow7rXT5xZGQpNQ3AbhacHVXf7LMCXUKH\nKsWi5n+/QsYiuX+R9avksI81/14Pt1FZI8+dUVZj17exSlz8WOGF91CPEAQxIuxv\nDOxBYIOQFCKoJU22baymuGO7g86WO9I9d9uyb8dwJwKBgQDuu8+RA9OHnP+TFViw\nT3TD+VtQz5HWeW5dpLHp6rTOZLe2CBnzORYMPbZPni4Oqo0G5NEBtdiRWEj43Sjx\nK/Xpyar/Vzj0jMkHpFHmsjrZtblTdl0L94iGgfPuCrU3er4P073TjZuhJQoazZSn\n8PUMR8uGoncd431O/CAOI9HR0wKBgQDC+fcLYozcNR18XsQopSxtHCuTs7Gy1bWY\n2ZePMnr5R0eJSKQoycjXkDAaiujGjyWtbVzsgzBrZsmy7MYoPlQ733wIKSJPOI1w\nExysKy6fEabn3b8/+bEmccE04FCXjMuzL2cYzUqXza7waMDl3RixvBkks1LX6vCe\n4NTKsyZzcwKBgHsExpn4eckZCs3VIyV/XDEcToTe4Uy+uDODCbb7Hf55Af3IQO8H\njKf0KPzwCtW95vwVbupNtXJ4JuoutMlKGOdG51m6rXu/DFxmvVl+oDrNnNk4Vgwz\nmuONFZClbepP0p6/QsM/5mFsf79+DktYLD4OxP70uyLotgq8exwuMxHHAoGAFboT\nHHKr7bIBiiVpSHo3fCUiegARMjN8W/8LU4q1h2e5AgRVPrJVrifEJIEMNWwoL647\nJ6Pq1l0K5uRZpIxliJJ72ND0oM1VfYKztD/PnywxZC8iq7dgVT9h30mL0Yd//4St\nwWbHBCmIcAPMUxETOmMSjjNpbOQiUiINtFTIWR8CgYAUCKpuI3Azrj12mQiWl4gB\npKf9ejar0BZI6wnPkw+kiBz69arPSImQ2kmD/1zNr2T/ls+BJtaBC8pT4DsY9R/t\no+lOahSqIv9FTl0BpzFUq7oYcV6a0J4OwMYDofMrOii/qlLK3o1OMV8Kj9UfjZg7\nIv1i7pY9Baq81qbosT+cJQ==\n-----END PRIVATE KEY-----\n"","
         . "`n  ""client_email"": ""firebase-adminsdk-nwpgf@cassier.iam.gserviceaccount.com"","
         . "`n  ""client_id"": ""112531104458713251383"","
         . "`n  ""auth_uri"": ""https://accounts.google.com/o/oauth2/auth"","
         . "`n  ""token_uri"": ""https://oauth2.googleapis.com/token"","
         . "`n  ""auth_provider_x509_cert_url"": ""https://www.googleapis.com/oauth2/v1/certs"","
         . "`n  ""client_x509_cert_url"": ""https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-nwpgf`%40cassier.iam.gserviceaccount.com"""
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

UpdateSessionView() {
    global
    Loop, Parse, % ",1,2,3,4,5,6", `,
    {
        Ind := A_LoopField
        Loop, Parse, MainCtrlList, `,
            GuiControl, Main:Hide, % StrReplace(A_LoopField, "$") Ind
    }
    Loop, Parse, MainCtrlList, `,
    {
        Sleep, 10
        If !InStr(A_LoopField, "$")
            GuiControl, Main:Show, % StrReplace(A_LoopField, "$") SessionID
    }
}