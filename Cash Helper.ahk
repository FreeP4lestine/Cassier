; Init
#NoEnv
#SingleInstance, Force
SendMode Input

; Class
#Include, Lib\Classes\Class_CtlColors.ahk
#Include, Lib\Classes\Class_ImageButton.ahk
#Include, Lib\Classes\Class_GDIplus.ahk

; Load
#Include, Lib\Language.ahk
#Include, Lib\GUILoading.ahk
#Include, Lib\GUIChart.ahk
#Include, Lib\GUISearch.ahk
#Include, Lib\GUIDetails.ahk
#Include, Lib\GUIKridi.ahk
#Include, Lib\GUIDBFile.ahk
#Include, Lib\GUIUsers.ahk
#Include, Lib\GUISell.ahk
#Include, Lib\GUIEnsure.ahk
#Include, Lib\GUIDefine.ahk
#Include, Lib\GUIStock.ahk
#Include, Lib\GUIReview.ahk
#Include, Lib\GUIKridiA.ahk

#Include, Lib\IniUpdateCheck.ahk
#Include, Lib\Folders.ahk
#Include, Lib\License.ahk
#Include, Lib\StartUp.ahk
Return
; Auto-Excu Section Ends Here {Init, Class, Load}

#Include, Lib\GUIChart_A.ahk
#Include, Lib\GUISearch_A.ahk
#Include, Lib\GUIDetails_A.ahk
#Include, Lib\GUIKridi_A.ahk
#Include, Lib\GUIDBFile_A.ahk
#Include, Lib\GUIUsers_A.ahk

#Include, Lib\WriteLicense.ahk
#Include, Lib\GUISell_A.ahk
#Include, Lib\GUIEnsure_A.ahk
#Include, Lib\GUIDefine_A.ahk
#Include, Lib\GUIStock_A.ahk
#Include, Lib\GUIReview_A.ahk
#Include, Lib\GUIKridiA_A.ahk
KEdit:
    GuiControlGet, KLBB, Main:, KLBB
    If (RD := DB_Read(FileToBeEdit := Kridiss[KLBB])) {
        Gui, Editf:Default
        Gui, Editf:ListView, LV
        Gui, Editf:Show
        LV_Delete()
        RWD := StrSplit(RD, "> ")
        PrevQn := {}
        For Every, Thing in StrSplit(Trim(RWD[2], "|"), "|") {
            EachOne := StrSplit(Trim(Thing, ";"), ";")
            LV_Add(, EachOne[1],, EachOne[2], EachOne[3], EachOne[4])
            PrevQn["" EachOne[1] ""] := StrSplit(EachOne[3], "x")[2]
        }
    }
    Gui, Editf:Default
Return

KDelete:
    GuiControlGet, KLBB, Main:, KLBB
    FileDelete, % Kridiss[KLBB]
    Gosub, ShowKridiInfo
Return

DisplayMetaK:
    GuiControlGet, KLBB, Main:, KLBB
    LV_Delete()
    If (RD := DB_Read(Kridiss[KLBB])) {
        RD := StrSplit(RD, "> ")
        For Each, One in StrSplit(Trim(RD[2], "|"), "|") {
            Vals := StrSplit(One, ";")
            LV_Add("",, Vals[2]
                      , Vals[3]
                      , Vals[4])
        }
        GuiControl, Main:, CashKE, % (V := StrSplit(RD[3], ";")[1]) " " ConvertMillimsToDT(V)
    }
Return

DisplayMetaK1:
    GuiControlGet, KLBB1, Main:, KLBB1
    If (RD := DB_Read(Payments[KLBB1])) {
        MsgBox, 64, % _164, % RD " " ConvertMillimsToDT(RD)
    }
Return

DisplayKridisUsers:
    LoadKridis()
Return

KUpdateVal:
    GuiControlGet, CashK, Main:, CashK
    GuiControlGet, KLESum, Main:, KLESum
    GuiControlGet, KMDSubmit, Main:, KMDSubmit
    KLESum := StrSplit(KLESum, " ")[1]
    If (KMDSubmit) {
        TmpCashK := StrSplit(KLESum, " ")[1]
        TmpCashK -= KMDSubmit
        TmpCashK := (TmpCashK >= 0) ? TmpCashK : 0
        GuiControl, Main:, CashK, % TmpCashK " " ConvertMillimsToDT(TmpCashK)
    } Else {
        GuiControl, Main:, CashK, % KLESum " " ConvertMillimsToDT(KLESum)
    }
Return

ShowKridiInfo:
    GuiControlGet, KLB, Main:, KLB
    GuiControl, Main:, KLBB, |
    GuiControl, Main:, KLBB1, |
    Kridiss := {}, Payments := {}, CashK := 0, OffK := 0
    Loop, Parse, KLB, |
    {
        Ind := 0
        KLB := A_LoopField
        Loop, Files, % Kridis[KLB] "\*.db"
        {
            If (RD := DB_Read(A_LoopFileFullPath)) {
                FormatTime, TS, % StrReplace(A_LoopFileName, ".db"), yyyy/MM/dd │ HH:mm:ss
                GuiControl, Main:, KLBB, % TS
                Kridiss[++Ind] := Kridis[KLB] "\" A_LoopFileName
                CashK += StrSplit(StrSplit(RD, "> ")[3], ";")[1]
            }
        }

        Ind := 0
        Loop, Files, % Kridis[KLB] "\*.Off"
        {
            If RD := DB_Read(A_LoopFileFullPath) {
                FormatTime, TS, % StrReplace(A_LoopFileName, ".Off"), yyyy/MM/dd │ HH:mm:ss
                GuiControl, Main:, KLBB1, % TS
                Payments[++Ind] := Kridis[KLB] "\" A_LoopFileName
                OffK += RD
            }
        }
    }
    GuiControl, Main:, CashK, % CashK - OffK " " ConvertMillimsToDT(CashK - OffK)
    GuiControl, Main:, KLESum, % CashK - OffK " " ConvertMillimsToDT(CashK - OffK)
    GuiControl, Main:, KMD, % Round((CashK - OffK) / AllCashK * 100, 1) " %"
    GuiControl, Main:Choose, KLBB, |1
Return

ShowRemise:
    If (RMS = "#2") {
        GuiControlGet, User, Main:, Currents
        If (ShowR := !ShowR) {
            ValS := UsersSells[User][2] - UsersSells[User][5]
            ValP := UsersSells[User][4] - UsersSells[User][5]
            GuiControl, Main:, Sold, % ((ValS >= 0) ? "+" : "") " " ValS " " ConvertMillimsToDT(ValS, (ValS >= 0) ? "+" : "")
            GuiControl, Main:, ProfitEq, % ((ValP >= 0) ? "+" : "") " " ValP " " ConvertMillimsToDT(ValP, (ValP >= 0) ? "+" : "")
        } Else {
            GuiControl, Main:, Sold, % "+ " UsersSells[User][2] " " ConvertMillimsToDT(UsersSells[User][2], "+") (UsersSells[User][5] ? " ↓" : "")
            GuiControl, Main:, ProfitEq, % "+ " UsersSells[User][4] " " ConvertMillimsToDT(UsersSells[User][4], "+") (UsersSells[User][5] ? " ↓" : "")
        }
    } Else If (RMS = "#5") {
        GuiControlGet, User, Main:, ProfByName
        If (ShowRR := !ShowRR) {
            ValS := ByName[User][2] - ByName[User][5]
            ValP := ByName[User][4] - ByName[User][5]
            GuiControl, Main:, SPr, % ((ValS >= 0) ? "+" : "") " " ValS " " ConvertMillimsToDT(ValS, (ValS >= 0) ? "+" : "")
            GuiControl, Main:, OAProfit, % ((ValP >= 0) ? "+" : "") " " ValP " " ConvertMillimsToDT(ValP, (ValP >= 0) ? "+" : "")
        } Else {
            GuiControl, Main:, SPr, % "+ " ByName[User][2] " " ConvertMillimsToDT(ByName[User][2], "+") (ByName[User][5] ? " ↓" : "")
            GuiControl, Main:, OAProfit, % "+ " ByName[User][4] " " ConvertMillimsToDT(ByName[User][4], "+") (ByName[User][5] ? " ↓" : "")
        }
    }
Return

RESETALL:
    MsgBox, 33, % _144 , % _145
    IfMsgBox, OK
    {
        For Every, Stock in ProdDefs {
            Stock[4] := 0
        }
        UpdateProdDefs()
        MsgBox, 64, % _146 , % _147
        GoSub, SearchStock
    }
Return

RESETSEL:
    GuiControlGet, SLB, Main:, SLB
    If (!SLB)
        Return
    MsgBox, 33, % _144 , % _148 "`n`n" ProdDefs["" LoadedStock[SLB] ""][1] " (" LoadedStock[SLB] ") "
    IfMsgBox, OK
    {
        ProdDefs["" LoadedStock[SLB] ""][4] := 0
        UpdateProdDefs()
        MsgBox, 64, % _146 , % _149 "`n`n" ProdDefs["" LoadedStock[SLB] ""][1] " (" LoadedStock[SLB] ") "
        GoSub, SearchStock
    }
Return

SelectPic:
    FileSelectFile, SelectedPic,,, % _136, *.GIF; *.JPG; *.BMP; *.ICO; *.CUR; *.ANI; *.PNG; *.TIF; *.Exif; *.WMF; *.EMF
    PicHolder := []
    If (SelectedPic) {
        GuiControl, Main:, ProductLogo, % SelectedPic
        PicHolder := [SelectedPic]
    } Else {
        GuiControl, Main:, ProductLogo, % "Img\AddPic.png"
    }
Return

DeleteCurr:
    LV_GetText(File, Row := LV_GetNext(), 1)
    If (File) {
        FileDelete, % File
        LV_Delete(Row)
        LoadCurrent()
    }
Return

EditCurr:
    If (Row := LV_GetNext()) {
        LV_GetText(FileToBeEdit, Row)
        If (FileToBeEdit) {
            If (RD := DB_Read(FileToBeEdit)) {
                Gui, Editf:Default
                Gui, Editf:ListView, LV
                LV_Delete()
                RWD := StrSplit(RD, "> ")
                PrevQn := {}
                For Every, Thing in StrSplit(Trim(RWD[2], "|"), "|") {
                    EachOne := StrSplit(Trim(Thing, ";"), ";")
                    LV_Add(, EachOne[1],, EachOne[2], EachOne[3], EachOne[4])
                    PrevQn["" EachOne[1] ""] := StrSplit(EachOne[3], "x")[2]
                }
            }
        }
        Gui, Editf:Show
        Gui, Main:Default
    }
Return


SortCurr:
    Gui, ListView, LV10
    LV_Delete()
    GuiControlGet, SortCurr, Main:, SortCurr
    GuiControlGet, ThisBc, Main:, SearchByC
    Sorted := (SortCurr = "Quantity") ? SortedQn : ((SortCurr = "Profit") ? SortedPr : ((SortCurr = "Sell Price") ? SortedSo : ((SortCurr = "Cost Price") ? SortedCo : "")))
    Charts := {}, Ind := 0 
    For Every, Line in Sorted {
        If InStr(Line[2], ThisBc) || InStr(ProdDefs["" Line[2] ""][1], ThisBc) {
            LV_Add(, A_Index " │ " ProdDefs["" Line[2] ""][1], Line[1])
        }
    }
    Gui, ListView, LV1
Return

AdditionalInfo:
    If (AdditionalInfo := !AdditionalInfo) {
        GuiControl, Main:Enabled, Remise
        GuiControl, Main:Enabled, Client
        GuiControl, Main:Enabled, SellDesc
        GuiControl, Main:,AdditionalInfoPic, % "Img\MIE.png"
    } Else {
        GuiControl, Main:Disabled, Remise
        GuiControl, Main:Disabled, Client
        GuiControl, Main:Disabled, SellDesc
        GuiControl, Main:,AdditionalInfoPic, % "Img\MID.png"
    }
    CheckListSum()
    If (Sum_Data[1]) {
        Sum_Data := CalculateSum()
    }
Return

ViewLastTrans:
    If RD := DB_Read(_This) {
        GuiControl, Details:, ReInLB, |
        GuiControl, Details:, DInfo
        GuiControl, Details:, Remise
        GuiControl, Details:, Client
        GuiControl, Details:, SellDesc
        Gui, Details:Show,, % _81
        RD := StrSplit(RD, "> ")
        MRD := StrSplit(Trim(RD[2], "|"), "|")
        ReInArr := {}, ReInArrOverAll := 0
        For Each, Product in MRD {
            DMRD := StrSplit(Trim(Product, ";"), ";")
            GuiControl, Details:, ReInLB, % DMRD[2]
            ReInArr[Each] := DMRD, ReInArrOverAll += DMRD[7]
        }
        AD := StrSplit(RD[4], ";")
        If (AD[1])
            GuiControl, Details:, Remise, % AD[1] " %"
        If (AD[2])
            GuiControl, Details:, Client, % AD[2]
        If (AD[3])
            GuiControl, Details:, SellDesc, % AD[3]
        GuiControl, Details:Choose, ReInLB, |1
        GuiControl, Details:, OverAll, % _128 ": " ReInArrOverAll " " ConvertMillimsToDT(ReInArrOverAll)
    }
Return

NowTime:
    FormatTime, NowTimeVar,, yyyy/MM/dd | HH:mm:ss
    GuiControl, Startup:, NowTime, % NowTimeVar
    GuiControl, Main:, NowTime, % NowTimeVar
Return

SellDesc:
    If (Sum_Data[1]) {
        Sum_Data := CalculateSum()
    }
Return

Client:
    If (Sum_Data[1]) {
        Sum_Data := CalculateSum()
    }
Return

Remise:
    GuiControlGet, Remise, Main:, Remise
    If (Remise > 100) 
        GuiControl, Main:, Remise, % Remise := ""
    CheckListSum()
    If (Sum_Data[1]) {
        Sum_Data := CalculateSum()
    }
Return

Continue:
    SetTimer, About, 0
    GuiControl, Main:Focus, OpenMain
Return

EditUser:
    LV_GetText(Name, Row := LV_GetNext(), 1)
    LV_GetText(Pass, Row, 2)
    If (Name != "" && Pass != "") {
        Loop {
            InputBox, NName, Edit name, Write a new user name,, 300, 120,,,,, % Name
            EL := ErrorLevel
        } Until ((NName) && !InStr(NName, ";") && !InStr(NName, "/")) || (EL ~= "1|2")
        If (!EL) {
            Loop {
                InputBox, NPass, Edit password, Write a new user password,, 300, 120,,,,, % Pass
                EL := ErrorLevel
            } Until (NPass) && !InStr(NPass, ";") && !InStr(NPass, "/") || (ErrorLevel ~= "1|2")
            If (!EL) {
                UserExist := 0
                Loop, % LV_GetCount() {
                    LV_GetText(ThisUNm, A_Index, 1)
                    If (ThisUNm = UNm) {
                        UserExist := A_Index
                        Break
                    }
                }
                If (!UserExist) {
                    LV_Modify(Row, "", NName, NPass)
                } Else {
                    GuiControl, Main:Focus, LV5
                    SendInput, {Home}
                    Loop, % (UserExist - 1)
                        SendInput, {Down}
                }
            }
        }
    }
Return
;AddUser:
;    Loop {
;        InputBox, UNm, % _87, % _92,, 300, 125,,,, 10
;        EL := ErrorLevel
;    } Until ((UNm) && !InStr(UNm, ";") && !InStr(UNm, "/")) || (EL ~= "1|2")
;    If (!EL) {
;        Loop {
;            InputBox, UPw, % _88, % _93,, 300, 125,,,, 10
;            EL := ErrorLevel
;        } Until (UPw) && !InStr(UPw, ";") && !InStr(UPw, "/") || (ErrorLevel ~= "1|2")
;        If (!EL) {
;            UserExist := 0
;            Loop, % LV_GetCount() {
;                LV_GetText(ThisUNm, A_Index, 1)
;                If (ThisUNm = UNm) {
;                    UserExist := A_Index
;                    Break
;                }
;            }
;            If (!UserExist) {
;                LV_Add("", UNm, UPw)
;                WriteNewAccount(UNm, UPw)
;            } Else {
;                GuiControl, Main:Focus, LV5
;                SendInput, {Home}
;                Loop, % UserExist - 1
;                    SendInput, {Down}
;            }
;        }
;    }
;Return
EDTime:
    Gui, Main:Submit, NoHide
    If (SinceBegin) {
        GuiControl, Main:Disable, Today
        GuiControl, Main:Disable, Yesterday
    } Else {
        GuiControl, Main:Enable, Today
        GuiControl, Main:Enable, Yesterday
    }
Return

DisplayChart:
    Gui, Chart:Show,, % _83
    GoSub, LoadLB
Return
GoLookUp:
    Gui, Main:Submit, NoHide
    LV_Delete()
    GuiControl, Main:, OAProfit, 0
    GuiControl, Main:, SPr, 0
    GuiControl, Main:, CPr, 0
    If (ProfByName != "All") {
        For Each, SO in ByName {
            If (SubStr(Each, 1, InStr(Each, "_") - 1) = ProfByName) {
                LV_Add(, SO[1], SO[2], SO[3], SO[4], SO[5])
            }
        }
    } Else {
        For Each, SO in ByName {
            If InStr(Each, "All_") {
                LV_Add(, SO[1], SO[2], SO[3], SO[4], SO[5])
            }
        }
    }
    GuiControl, Main:, SPr, % "+ " ByName[ProfByName][2] " " ConvertMillimsToDT(ByName[ProfByName][2], "+") (ByName[Currents][5] ? " ↓" : "")
    GuiControl, Main:, CPr, % "- " ByName[ProfByName][3] " " ConvertMillimsToDT(ByName[ProfByName][3], "-")
    GuiControl, Main:, OAProfit, % "+ " ByName[ProfByName][4] " " ConvertMillimsToDT(ByName[ProfByName][4], "+") (ByName[Currents][5] ? " ↓" : "")
Return
DisplayEqCurr:
    Gui, Main:Submit, NoHide
    LV_Delete()
    If (Currents != "All") {
        For Each, SO in UsersSells {
            If (SubStr(Each, 1, InStr(Each, "_") - 1) = Currents) {
                LV_Add(, SO[1], SO[2], SO[3])
            }
        }
    } Else {
        For Each, SO in UsersSells {
            If InStr(Each, "All_")
                LV_Add(, SO[1], SO[2], SO[3])
        }
    }
    GuiControl, Main:, Sold, % "+ " UsersSells[Currents][2] " " ConvertMillimsToDT(UsersSells[Currents][2], "+") (UsersSells[Currents][5] ? " ↓" : "")
    GuiControl, Main:, Bought, % "- " UsersSells[Currents][3] " " ConvertMillimsToDT(UsersSells[Currents][3], "-")
    GuiControl, Main:, ProfitEq, % "+ " UsersSells[Currents][4] " " ConvertMillimsToDT(UsersSells[Currents][4], "+") (UsersSells[Currents][5] ? " ↓" : "")
Return

CheckSNum:
    GuiControlGet, SNum, Main:, SNum
    Sign := SubStr(SNum, 1, 1)
    Rest := SubStr(SNum, 2)
    If (Rest ~= "[^0-9]") || (Sign ~= "[^0-9\-]") {
        GuiControl, Main:, SNum
    } Else If (StrLen(SNum) > 1) || (SNum >= 0) {
        ProdDefs["" LoadedStock[SLB] ""][4] := SNum
        GuiControlGet, SLB, Main:, SLB
        Val := ProdDefs["" LoadedStock[SLB] ""][4] * ProdDefs["" LoadedStock[SLB] ""][3]
        GuiControl, Main:, SMetaData, % ProdDefs["" LoadedStock[SLB] ""][4] " x " ProdDefs["" LoadedStock[SLB] ""][3] " = " Val " " ConvertMillimsToDT(Val)
        GuiControl, Main:, ProductInfo, % _27 ":`n      " LoadedStock[SLB]
                                        . "`n`n" _38 ":`n      " ProdDefs["" LoadedStock[SLB] ""][1] 
                                        . "`n`n" _40 ":`n      " ProdDefs["" LoadedStock[SLB] ""][2]
                                        . "`n`n" _39 ":`n      " ProdDefs["" LoadedStock[SLB] ""][3]
                                        . "`n`n" _68 ":`n      " ProdDefs["" LoadedStock[SLB] ""][4]
        STotal := 0
        For Every, Pro in LoadedStock {
            STotal += ProdDefs["" Pro ""][3] * ProdDefs["" Pro ""][4]
        }
        GuiControl, Main:, STotal, % STotal " " ConvertMillimsToDT(STotal)
    }
Return

DisplayStockEq:
    GuiControlGet, SLB, Main:, SLB
    Val := ProdDefs["" LoadedStock[SLB] ""][4] * ProdDefs["" LoadedStock[SLB] ""][3]
    GuiControl, Main:, SMetaData, % ProdDefs["" LoadedStock[SLB] ""][4] " x " ProdDefs["" LoadedStock[SLB] ""][3] " = " Val " " ConvertMillimsToDT(Val)
    GuiControl, Main:, ProductInfo, % _27 ":`n      " LoadedStock[SLB]
                                    . "`n" _38 ":`n      " ProdDefs["" LoadedStock[SLB] ""][1]  
                                    . "`n" _40 ":`n      " ProdDefs["" LoadedStock[SLB] ""][2]
                                    . "`n" _39 ":`n      " ProdDefs["" LoadedStock[SLB] ""][3]
                                    . "`n" _68 ":`n      " ProdDefs["" LoadedStock[SLB] ""][4]
    GuiControl, Main:, SNum, % ProdDefs["" LoadedStock[SLB] ""][4]
Return

SearchStock:
    GuiControl, Main:, SLB, |
    LoadedStock := {}, STotal := Ind := 0
    GuiControlGet, SBc, Main:, SBc
    For Every, Pro in ProdDefs {
        If InStr(Every, SBc) || InStr(Pro[1], SBc) {
            GuiControl, Main:, SLB, % ++Ind " │ " Pro[1]
            LoadedStock[Ind] := "" Every ""
            STotal += Pro[3] * Pro[4]
        }
    }
    GuiControl, Main:Choose, SLB, |1
    GuiControl, Main:, STotal, % STotal " " ConvertMillimsToDT(STotal)
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

CheckForUpdates:
    If (CheckForUpdates := !CheckForUpdates) {
        IniWrite, 1, Setting.ini, Update, Upt
        GuiControl, Main:, CheckForUpdatesCB3, % Chr(252)
    } Else {
        IniWrite, 0, Setting.ini, Update, Upt
        GuiControl, Main:, CheckForUpdatesCB3
    }
Return
DebugMode:
    If (DebugMode := !DebugMode) {
        IniWrite, 1, % DebugModeSetting, DebugMode, DM
        GuiControl, Main:, DebugModeCB3, % Chr(252)
    } Else {
        IniWrite, 0, % DebugModeSetting, DebugMode, DM
        GuiControl, Main:, DebugModeCB3
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
    For Each, One in KridiArr {
        ThisKridiSum := 0
        InStr(KLB, "|") ? (LV_Add(), LV_Add("",, "* " One), LV_Add())
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
    PostMessage 0xA1,1 2
Return
UpdateSession:
    Gui, Main:Default
    NoCreateNe := 1
    For Every, Ctrl in StrSplit(MainCtrlListE, ",") {
        GuiControl, Main:, % Ctrl
    }
    LV_Delete()

    For Every, Ctrl in StrSplit(MainCtrlList, ",") {
        If !InStr(Ctrl, "$")
            GuiControl, Main:Show, % Ctrl
        Else
            GuiControl, Main:Hide, % Ctrl
    }

    If !GetKeyState("Left", "P") && !GetKeyState("Right", "P") {
        GuiControl, Main:Enabled, % SessionID
        GuiControl, Main:Disabled, % A_GuiControl
        SessionID := A_GuiControl
    }

    If FileExist("Dump\" SessionID ".db")
        RestoreSession(DB_Read("Dump\" SessionID ".db"))
    NoCreateNe := 0
Return
MainGuiClose:
    If (PrevSelection[1] != "") {
        GuiControl, StartUp:Enabled, % PrevSelection[2]
    }
    Gui, Main:Hide
Return
CheckIntCalc:
    Gui, Main:Submit, NoHide
    If (Percent) && (Percent > 100) {
        GuiControl, Main:, Percent, 100
        SelectAll(Percent_)
    }
Return

OpenMainTimer:
    ToolTip, % RMS
    If (RMS != "#1") {
        SetTimer, OpenMainTimer, Off
        Return
    }
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
Return
OpenMain:
    If (PrevSelection[1] != "") {
        For Each, Ctrl in StrSplit(PrevSelection[1], ",")
            GuiControl, Main:Hide, % StrReplace(Ctrl, "$")
        GuiControl, StartUp:Enabled, % PrevSelection[2]
        GuiControl, Main:Enabled, % PrevSelection[3]
    }
    GuiControl, StartUp:Disabled, % "OpenMain"
    GuiControl, Main:Disabled, % "OpenMain1"
    For Each, Ctrl in StrSplit(MainCtrlList, ",") {
        If !InStr(Ctrl, "$")
            GuiControl, Main:Show, % Ctrl
    }
    PrevSelection   := [MainCtrlList, "OpenMain", "OpenMain1"]
    RMS             := "#1"
    SessionID       := "OpenSess1"
    Spaced          := 0
    
    Gui, Main:Default
    Gui, Main:ListView, LV0
    If FileExist("Dump\" SessionID ".db")
        RestoreSession(DB_Read("Dump\" SessionID ".db"))
    ProdDefs := LoadDefinitions(DB_Read("Sets\PD.db"))
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
    If (HLM) {
        Loop, Parse, % "ItemsSold,CostP,SoldP,ProfitP", `,
            GuiControl, Main:Show, % A_LoopField
    } Else {
        Loop, Parse, % "ItemsSold,CostP,SoldP,ProfitP", `,
            GuiControl, Main:Hide, % A_LoopField
    }
    Gui, Main:Show, Maximize
Return
Submit:
    If (PrevSelection[1] != "") {
        For Each, Ctrl in StrSplit(PrevSelection[1], ",")
            GuiControl, Main:Hide, % StrReplace(Ctrl, "$")
        GuiControl, StartUp:Enabled, % PrevSelection[2]
        GuiControl, Main:Enabled, % PrevSelection[3]
    }
    GuiControl, StartUp:Disabled, % "Submit"
    GuiControl, Main:Disabled, % "Submit1"
    For Each, Ctrl in StrSplit(EnsureCtrlList, ",") {
        If !InStr(Ctrl, "$")
            GuiControl, Main:Show, % Ctrl
    }
    PrevSelection   := [EnsureCtrlList, "Submit", "Submit1"]
    RMS             := "#2"
    
    Gui, Main:Default
    Gui, Main:ListView, LV1
    If (HLM) {
        Loop, Parse, % "Sold,Bought,ProfitEq,SoldText,BoughtText,ProfitEqText", `,
            GuiControl, Main:Show, % A_LoopField
    } Else {
        Loop, Parse, % "Sold,Bought,ProfitEq,SoldText,BoughtText,ProfitEqText", `,
            GuiControl, Main:Hide, % A_LoopField
    }
    ProdDefs := LoadDefinitions(DB_Read("Sets\PD.db"))
    LoadCurrent()
    Gui, Main:Show, Maximize
Return
Define:
    If (PrevSelection[1] != "") {
        For Each, Ctrl in StrSplit(PrevSelection[1], ",")
            GuiControl, Main:Hide, % StrReplace(Ctrl, "$")
        GuiControl, StartUp:Enabled, % PrevSelection[2]
        GuiControl, Main:Enabled, % PrevSelection[3]
    }
    
    GuiControl, StartUp:Disabled, % "Define"
    GuiControl, Main:Disabled, % "Define1"
    For Each, Ctrl in StrSplit(DefineCtrlList, ",") {
        If !InStr(Ctrl, "$")
            GuiControl, Main:Show, % Ctrl
    }
    PrevSelection   := [DefineCtrlList, "Define", "Define1"]
    RMS             := "#3"
    
    Gui, Main:Default
    Gui, Main:ListView, LV2
    ProdDefs := LoadDefinitions(DB_Read("Sets\PD.db"))
    LoadDefined(1)
    Gui, Main:Show, Maximize
Return
StockPile:
    If (PrevSelection[1] != "") {
        For Each, Ctrl in StrSplit(PrevSelection[1], ",")
            GuiControl, Main:Hide, % StrReplace(Ctrl, "$")
        GuiControl, StartUp:Enabled, % PrevSelection[2]
        GuiControl, Main:Enabled, % PrevSelection[3]
    }
    
    GuiControl, StartUp:Disabled, % "StockPile"
    GuiControl, Main:Disabled, % "StockPile1"
    For Each, Ctrl in StrSplit(StockPileCtrlList, ",") {
        If !InStr(Ctrl, "$")
            GuiControl, Main:Show, % Ctrl
    }
    PrevSelection   := [StockPileCtrlList, "StockPile", "StockPile1"]
    RMS             := "#4"
    
    Gui, Main:Default
    Gui, Main:ListView, LV3
    ProdDefs := LoadDefinitions(DB_Read("Sets\PD.db"))
    GoSub, SearchStock
    Gui, Main:Show, Maximize
Return
Prof:
    If (PrevSelection[1] != "") {
        For Each, Ctrl in StrSplit(PrevSelection[1], ",")
            GuiControl, Main:Hide, % StrReplace(Ctrl, "$")
        GuiControl, StartUp:Enabled, % PrevSelection[2]
        GuiControl, Main:Enabled, % PrevSelection[3]
    }
    
    GuiControl, StartUp:Disabled, % "Prof"
    GuiControl, Main:Disabled, % "Prof1"
    For Each, Ctrl in StrSplit(ProfitCtrlList, ",") {
        If !InStr(Ctrl, "$")
            GuiControl, Main:Show, % Ctrl
    }
    PrevSelection   := [ProfitCtrlList, "Prof", "Prof1"]
    RMS             := "#5"
    ProdDefs        := LoadDefinitions(DB_Read("Sets\PD.db"))
    
    Gui, Main:Default
    Gui, Main:ListView, LV4
    Gui, Main:Show, Maximize

    Yesterday := Today := A_Now
    GuiControl, Main:, Today, % Today
    Yesterday += -1, Days
    GuiControl, Main:, Yesterday, % Yesterday

    LoadProf()
Return
Manage:
    If (PrevSelection[1] != "") {
        For Each, Ctrl in StrSplit(PrevSelection[1], ",")
            GuiControl, Main:Hide, % StrReplace(Ctrl, "$")
            GuiControl, StartUp:Enabled, % PrevSelection[2]
            GuiControl, Main:Enabled, % PrevSelection[3]
    }
    
    GuiControl, StartUp:Disabled, % "Manage"
    GuiControl, Main:Disabled, % "Manage1"
    For Each, Ctrl in StrSplit(ManageCtrlList, ",") {
        If !InStr(Ctrl, "$")
            GuiControl, Main:Show, % Ctrl
    }
    PrevSelection   := [ManageCtrlList, "Manage", "Manage1"]
    RMS             := "#6"
    
    Gui, Main:Default
    Gui, Main:ListView, LV5
    Gui, Main:Show, Maximize
Return
Kridi:
    If (PrevSelection[1] != "") {
        For Each, Ctrl in StrSplit(PrevSelection[1], ",")
            GuiControl, Main:Hide, % StrReplace(Ctrl, "$")
            GuiControl, StartUp:Enabled, % PrevSelection[2]
            GuiControl, Main:Enabled, % PrevSelection[3]
    }
    
    GuiControl, StartUp:Disabled, % "Kridi"
    GuiControl, Main:Disabled, % "Kridi1"
    For Each, Ctrl in StrSplit(KridiCtrlList, ",") {
        If !InStr(Ctrl, "$")
            GuiControl, Main:Show, % Ctrl
    }
    PrevSelection   := [KridiCtrlList, "Kridi", "Kridi1"]
    RMS             := "#7"
    ProdDefs        := LoadDefinitions(DB_Read("Sets\PD.db"))
    
    Gui, Main:Default
    Gui, Main:ListView, LV6
    Gui, Main:Show, Maximize
    LoadKridis()
Return

Progress:
    If (PrevSelection[1] != "") {
        For Each, Ctrl in StrSplit(PrevSelection[1], ",")
            GuiControl, Main:Hide, % StrReplace(Ctrl, "$")
            GuiControl, StartUp:Enabled, % PrevSelection[2]
            GuiControl, Main:Enabled, % PrevSelection[3]
    }
    
    GuiControl, StartUp:Disabled, % "Progress"
    GuiControl, Main:Disabled, % "Progress1"
    For Each, Ctrl in StrSplit(ProgressCtrlList, ",") {
        If !InStr(Ctrl, "$")
            GuiControl, Main:Show, % Ctrl
    }
    PrevSelection   := [ProgressCtrlList, "Progress", "Progress1"]
    RMS             := "#8"
    
    Gui, Main:Default
    Gui, Main:ListView, LV6
    Gui, Main:Show, Maximize

    If (DaysNB := NumGet(&WorkChart + 4 * A_PtrSize)) {
        SVals := []
        CVals := []
        PVals := []

        For Day, Each in WorkChart {
            SVals.Push([Day, Each[1]])
            CVals.Push([Day, Each[2]])
            PVals.Push([Day, Each[3]])
        }

        ObjPlot := FileOpen("PlotData.txt", "w")
        Loop, % DaysNB {
            ObjPlot.Write((A_Index > 1 ? "`n" : "") A_Index - 1 "," SVals[A_Index][1] "," SVals[A_Index][2] "," CVals[A_Index][2] "," PVals[A_Index][2])
        }
        ObjPlot.Close()
    }
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
ClearDbc:
    GuiControlGet, Dbc, Main:, Dbc
    If (Dbc ~= "[^0-9A-Za-z]") {
        GuiControl, Main:, Dbc, % RegExReplace(Dbc, "[^0-9A-Za-z]")
        SendInput, {End}
    }
Return
ClearDnm:
    GuiControlGet, Dnm, Main:, Dnm
    If (Dnm ~= "\[|\]|\;|\$|\||\/") {
        GuiControl, Main:, Dnm, % RegExReplace(Dnm, "\[|\]|\;|\$|\||\/")
        SendInput, {End}
    }
Return

#If WinActive("ahk_id " Main)
Space::
    Gui, Main:Default
    If (RMS = "#1") {
        GuiControlGet, Focused, Main:FocusV
        If (Focused ~= "Client|SellDesc") {
            SendInput, {Space}
        } Else {
            LV_GetText(C1L1, 1, 1)
            If (C1L1) {
                GuiControl, Main:Hide, Bc
                GuiControl, Main:Hide, Nm
                GuiControl, Main:Hide, Qn
                GuiControl, Main:Hide, Sum
                GuiControl, Main:Hide, AddEnter
                GuiControl, Main:Show, SubKridi
                GuiControl, Main:Show, GivenMoney
                GuiControl, Main:Show, AllSum
                GuiControl, Main:Show, Change
                Sum_Data := []
                GuiControl, Main:, AllSum, % (Sum_Data := CalculateSum())[1]
                GuiControl, Main:Focus, GivenMoney
            }
            CheckListSum()
        }
    } Else If (RMS ~= "#2|#5") {
        LV_GetText(File, LV_GetNext(), 1)
        If RD := DB_Read(File) {
            GuiControl, Details:, ReInLB, |
            GuiControl, Details:, DInfo
            GuiControl, Details:, Remise
            GuiControl, Details:, Client
            GuiControl, Details:, SellDesc
            Gui, Details:Show,, % _81
            RD := StrSplit(RD, "> ")
            MRD := StrSplit(Trim(RD[2], "|"), "|")
            ReInArr := {}, ReInArrOverAll := 0
            For Each, Product in MRD {
                DMRD := StrSplit(Trim(Product, ";"), ";")
                GuiControl, Details:, ReInLB, % DMRD[2]
                ReInArr[Each] := DMRD, ReInArrOverAll += DMRD[7]
            }

            AD := StrSplit(RD[4], ";")

            If (AD[1])
                GuiControl, Details:, Remise, % AD[1] " %" ((AD[1]) ? "    ↓ " Round(StrSplit(RD[3], ";")[1] * AD[1] / 100) " " ConvertMillimsToDT(Round(StrSplit(RD[3], ";")[1] * AD[1] / 100)) : "")
            If (AD[2])
                GuiControl, Details:, Client, % AD[2]
            If (AD[3])
                GuiControl, Details:, SellDesc, % AD[3]

            GuiControl, Details:Choose, ReInLB, |1
            GuiControl, Details:, OverAll, % _128 ": " ReInArrOverAll " " ConvertMillimsToDT(ReInArrOverAll) ((AD[1]) ? "    ↓ " ReInArrOverAll - Round(StrSplit(RD[3], ";")[1] * AD[1] / 100) " " ConvertMillimsToDT(ReInArrOverAll - Round(StrSplit(RD[3], ";")[1] * AD[1] / 100)) : "")
        }
    } Else If (RMS = "#4") {
    } Else If (RMS = "#6") {
        SendInput, {Space}
    } Else If (RMS = "#7") {
        ;LV_GetText(Bcc, 1, 1)
        ;If (Bcc) && !InStr(KLB, "|") {
        ;    InputBox, AdminPass, % _102, % _103,, 400, 130,,,, 10
        ;    If (ErrorLevel)
        ;        Return
        ;    If (AdminPass == TU) {
        ;        GuiControl, Main:Show, GivenMoney
        ;        GuiControl, Main:Show, AllSum
        ;        GuiControl, Main:Show, Change
        ;        GuiControl, Main:, AllSum, % (Sum_Data := CalculateSum())[1]
        ;        GuiControl, Main:Focus, GivenMoney
        ;    }
        ;}
        ;CheckListSum()
    } Else {
        SendInput, {Space}
    }
    Sleep, 125
Return
^W::
    DB_Write(A_Desktop "\genFILE.db", Clipboard)
    Sleep, 125
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
            GuiControl, Main:, Transc, % "`n " TP
            CtlColors.Change(TR, "80C0FF", "000000")
            GuiControl, Main:, TranscOK, Img\Idle.png
            GuiControl, Main:+Redraw, TranscOK
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
            Spaced := 0
        }
    }
Return
Right::
    If (RMS="#1") {
        GuiControl, Main:Enabled, % SessionID
        SessNum := SubStr(SessionID, 9, 1)
        If (++SessNum = 8)
            SessNum := 1
        GuiControl, Main:Disabled, % SessionID := "OpenSess" SessNum

        GoSub, UpdateSession
    } Else {
        SendInput, {Right}
    }
    Sleep, 125
Return
Left::
    If (RMS="#1") {
        GuiControl, Main:Enabled, % SessionID
        SessNum := SubStr(SessionID, 9, 1)
        If (--SessNum = 0)
            SessNum := 7
        GuiControl, Main:Disabled, % SessionID := "OpenSess" SessNum

        GoSub, UpdateSession
    } Else {
        SendInput, {Left}
    }
    Sleep, 125
Return
^Tab::
    If (FoundUsers[AdminName][2] = "ADM") {
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
                Loop, Parse, % "Sold,Bought,ProfitEq,SoldText,BoughtText,ProfitEqText", `,
                    GuiControl, Main:Show, % A_LoopField
            } Else {
                Loop, Parse, % "Sold,Bought,ProfitEq,SoldText,BoughtText,ProfitEqText", `,
                    GuiControl, Main:Hide, % A_LoopField
            }
        }
    } Else {
        SendInput, {Tab}
    }
    Sleep, 125
Return
#If

#If WinActive("ahk_id " Main) or WinActive("ahk_id " Ef)
Up::
    If WinActive("ahk_id " Main) {
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
            CreateNew()
            CheckListSum()
        } Else If (RMS = "#4") {
            GuiControlGet, SNumC, Main:, SNumC
            GuiControlGet, SNum, Main:, OldSNum := SNum
            If (SNumC) {
                GuiControl, Main:, SNum, % SNum += SNumC
                GuiControlGet, SLB, Main:, SLB
                ProdDefs["" LoadedStock[SLB] ""][4] += SNumC
            } Else {
                GuiControl, Main:, SNum, % SNum += 1
                GuiControlGet, SLB, Main:, SLB
                ProdDefs["" LoadedStock[SLB] ""][4] += 1
            }
            GoSub, DisplayStockEq
            STotal := 0
            For Every, Pro in LoadedStock {
                STotal += ProdDefs["" Pro ""][3] * ProdDefs["" Pro ""][4]
            }
            GuiControl, Main:, STotal, % STotal " " ConvertMillimsToDT(STotal)
        } Else {
            SendInput, {Up}
        }
    } Else {
        Gui, Editf:Default
        Gui, Editf:ListView, LV
        If (Row := LV_GetNext()) || (Row := LV_GetCount()) {
            LV_GetText(QnSP, Row, 4)
            QnSP := StrSplit(QnSP, "x")
            LV_Modify(Row,,,,, QnSP[1] "x" ++QnSP[2], QnSP[1] * QnSP[2])
        }
        Gui, Main:Default
    }
    Sleep, 125
Return
Down::
    If WinActive("ahk_id " Main) {
        Gui, Main:Submit, NoHide
        Gui, Main:Default
        If (RMS = "#1") {
            GuiControlGet, Focused, Main:FocusV
            If (Focused = "LV0") {
                If (Row := LV_GetNext()) {
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
            CreateNew()
            CheckListSum()
        } Else If (RMS = "#4") {
            GuiControlGet, SNumC, Main:, SNumC
            GuiControlGet, SNum, Main:, OldSNum := SNum
            If (SNumC) {
                GuiControl, Main:, SNum, % SNum -= SNumC
                GuiControlGet, SLB, Main:, SLB
                ProdDefs["" LoadedStock[SLB] ""][4] -= SNumC
            } Else {
                GuiControl, Main:, SNum, % SNum -= 1
                GuiControlGet, SLB, Main:, SLB
                ProdDefs["" LoadedStock[SLB] ""][4] -= 1
            }
            GoSub, DisplayStockEq
            STotal := 0
            For Every, Pro in LoadedStock {
                STotal += ProdDefs["" Pro ""][3] * ProdDefs["" Pro ""][4]
            }
            GuiControl, Main:, STotal, % STotal " " ConvertMillimsToDT(STotal)
        } Else {
            SendInput, {Down}
        }
    } Else {
        Gui, Editf:Default
        Gui, Editf:ListView, LV
        If (Row := LV_GetNext()) || (Row := LV_GetCount()) {
            LV_GetText(QnSP, Row, 4)
            QnSP := StrSplit(QnSP, "x")
            LV_Modify(Row,,,,, QnSP[1] "x" (--QnSP[2] ? QnSP[2] : ++QnSP[2]), QnSP[1] * QnSP[2])
        }
        Gui, Main:Default
    }
    Sleep, 125
Return
Delete::
    If WinActive("ahk_id " Main) {
        Gui, Main:Default
        Gui, Main:Submit, NoHide
        If (RMS = "#1") {
            LV_Delete(LV_GetNext())
            CreateNew()
            CheckListSum()
        }
        Else If (RMS = "#2") {
            GoSub, DeleteCurr
        } Else If (RMS = "#3") {
            LV_GetText(ThisID, LV_GetNext(), 1)
            ProdDefs.Delete("" ThisID "")
            UpdateProdDefs()
            LV_Delete(LV_GetNext())
        } Else If (RMS = "#6") {
            ;If ((Row := LV_GetNext()) > 1) {
            ;    LV_GetText(Name, Row := LV_GetNext(), 1)
            ;    LV_GetText(Pass, Row, 2)
            ;    If InStr(US := DB_Read("Sets\Lc.lic"), Name "/" Pass) {
            ;        DB_Write("Sets\Lc.lic", StrReplace(US, ";" Name "/" Pass))
            ;    }
            ;    LoadAccounts()
            ;}
        } Else {
            SendInput, {Delete}
        } 
    } Else If WinActive("ahk_id " Ef) {
        Gui, Editf:Default
        Gui, Editf:ListView, LV
        If (LV_GetCount() > 1) {
            LV_Delete(LV_GetNext())
        }
        Gui, Main:Default
    }
    Sleep, 125
Return
#If

#If WinActive("ahk_id " Main) or WinActive("ahk_id " Search)
^F::
    If (RMS = "#1") {
        GuiControl, Search:, SNM_, |
        Lst := 1, Found := {}, Found[1] := ""
        GuiControl, Search:, SNM_, % "Ø"
        For Every, One in ProdDefs {
            If InStr(One[1], Bc) {
                Found[++Lst] := "" Every ""
                GuiControl, Search:, SNM_, % One[1]
            }
        }
        If (Lst > 1) {
            WinGetPos, X, Y, W,, % "ahk_id " Main
            X += 230, Y += 120
            GuiControl, Search:, Founds, % "[ " Lst - 1 " ]"
            Gui, Search:Show, x%X% y%Y% NA, % _82
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

#If WinActive("ahk_id " Main) or WinActive("ahk_id " Kr) ||  WinActive("ahk_id " Start)
Enter::
    If WinActive("ahk_id " Main) {
        Gui, Main:Submit, NoHide
        Gui, Main:Default
        If (RMS = "#1") {
            GuiControl, Main:Disabled, Bc
            GuiControlGet, Visi, Main:Visible, Nm
            If (Visi) {
                If (ProdDefs["" (Barcode := Bc) ""][1] != "") {
                    Nm := ProdDefs["" Barcode ""][1]
                    SellPrice := ProdDefs["" Barcode ""][3]
                    ThisCurrQuantity := ProdDefs["" Barcode ""][4] ? ProdDefs["" Barcode ""][4] : 0
                    QuantitySumArg := SellPrice "x1"
                    JobDone := 0
                    Loop, % LV_GetCount() {
                        LV_GetText(ThisBc, Row := A_Index, 1)
                        If (ThisBc = Barcode) {
                            LV_GetText(AddedCurrQuantity, Row, 2), AddedCurrQuantity := StrSplit(AddedCurrQuantity, "  ►  ")
                            LV_GetText(AddedQuantitySumArg, Row, 4), AddedQuantitySumArg := StrSplit(AddedQuantitySumArg, "x"), QuantitySumArg := AddedQuantitySumArg[1] "x" AddedQuantitySumArg[2] + 1
                            LV_GetText(PreviousSum, Row, 5)
                            SellPrice := ProdDefs["" Barcode ""][3]
                            LV_Modify(Row,,, AddedCurrQuantity[1] "  ►  " AddedCurrQuantity[2] - 1,, QuantitySumArg, PreviousSum + SellPrice)
                            JobDone := 1
                            Break
                        }
                    }
                    If (!JobDone) {
                        LV_Add("", Barcode, ThisCurrQuantity "  ►  " ThisCurrQuantity - 1, Nm, QuantitySumArg, SellPrice)
                    }
                }
                CreateNew()
            } Else {
                GuiControlGet, Visi, Main:Visible, CB
                If (Visi) {
                    Gui, Main:Submit, NoHide
                    Bc := SubStr(CB, InStr(CB, " ",, 0) + 1)
                    GuiControl, Main:, Bc, % Trim(Bc, "[]")
                } Else {
                    DB_Write(_This := "Curr\" (ThisInst := A_Now) ".db", AdminName "|" Sum_Data[2])
                    
                    For Every, Qn in ProdDefsTmp {
                        ProdDefs["" Every ""][4] -= Qn
                    }

                    UpdateProdDefs()
                    GuiControl, Main:, AllSum
                    GuiControl, Main:, Change
                    GuiControl, Main:, GivenMoney
                    GuiControl, Main:Hide, GivenMoney
                    GuiControl, Main:Hide, AllSum
                    GuiControl, Main:Hide, Change
                    GuiControl, Main:Show, Bc
                    GuiControl, Main:Show, Nm
                    GuiControl, Main:Show, Qn
                    GuiControl, Main:Show, Sum
                    GuiControl, Main:Show, AddEnter
                    GuiControl, Main:Hide, SubKridi
                    GuiControl, Main:, Remise
                    GuiControl, Main:, Client
                    GuiControl, Main:, SellDesc
                    LV_Delete()
                    If FileExist("Dump\" SessionID ".db")
                        FileDelete, % "Dump\" SessionID ".db"
                    TrancsView(1, 1)
                }
            }
            CheckListSum()
            GuiControl, Main:Enabled, Bc
            GuiControl, Main:, Bc
            GuiControl, Main:Focus, Bc
        } Else If (RMS = "#3") {
            If (Dbc) && (Dnm) && (Dbp) && (Dsp) {
                GuiControl, Main:Disabled, Dbc
                GuiControl, Main:Disabled, Dnm
                GuiControl, Main:Disabled, Dbp
                GuiControl, Main:Disabled, Dsp
                If (!EditMod[1]) {
                    If (ProdDefs["" (AddedDbc := Dbc) ""][1] = "") {
                        ProdDefs["" Dbc ""] := [Dnm,Dbp,Dsp,0]
                        UpdateProdDefs()
                        LoadDefined(1)
                        LV_Modify(0, "-Select")
                        Loop, % LV_GetCount() {
                            LV_GetText(ThisBar, A_Index, 1)
                            If (ThisBar = AddedDbc) {
                                GuiControl, Main:Focus, LV2
                                SendInput, {Home}
                                Loop, % A_Index - 1
                                    SendInput, {Down}
                                Break
                            }
                        }
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
                            GuiControl, Main:Focus, Dbc
                            UpdateProdDefs()
                            LoadDefined(1)
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
                GuiControl, Main:, Dbc
                GuiControl, Main:, Dnm
                GuiControl, Main:, Dbp
                GuiControl, Main:, Dsp
                GuiControl, Main:Enabled, Dbc
                GuiControl, Main:Enabled, Dnm
                GuiControl, Main:Enabled, Dbp
                GuiControl, Main:Enabled, Dsp
            }
            GuiControl, Main:Focus, Dbc
        } Else If (RMS = "#4") {
            UpdateProdDefs()
        } Else If (RMS = "#5") {
            LoadProf()
        } Else If (RMS = "#6") {
            SendInput, {Enter}
        } Else If (RMS = "#7") {
            GuiControlGet, KMDSubmit, Main:, KMDSubmit
            If (!KMDSubmit)
                Return
            InputBox, EAdminPass, % _102, % _103,, 400, 130,,,, 10
            If (ErrorLevel)
                Return
            If (EAdminPass == AdminPass) {
                If (CashK) {
                    GuiControlGet, KLB, Main:, KLB
                    If StrSplit(CashK, " ")[1] {
                        DB_Write(Kridis[KLB] "\" A_Now ".Off", KMDSubmit)
                    } Else {
                        FileRemoveDir, % Kridis[KLB], 1
                    }
                    LoadKridis()
                }
                GuiControl, Main:, KMDSubmit
            }
        }
    } Else If WinActive("ahk_id " Kr) {
        Gui, Kridi:Submit, NoHide
        If (KName ~= "[^A-Za-z0-9 ]") || (!KName) {
            ShakeControl("Kridi", KName)
            GuiControl, Kridi:Focus, KName
        } Else {
            Gui, Main:Default
            DB_Write(_This := "Curr\" A_Now ".db", AdminName "|" Sum_Data[2])
            EncVal := EncodeAlpha(KName)
            If !InStr(FileExist("Kr\" EncVal), "D") {
                FileCreateDir, % "Kr\" EncVal
            }
            FileCopy, % _This, % "Kr\" EncVal
            GuiControl, Kridi:, KName
            Gui, Kridi:Hide

            For Every, Qn in ProdDefsTmp {
                ProdDefs["" Every ""][4] -= Qn
            }

            UpdateProdDefs()
            GuiControl, Main:, AllSum
            GuiControl, Main:, Change
            GuiControl, Main:, GivenMoney
            GuiControl, Main:Hide, GivenMoney
            GuiControl, Main:Hide, AllSum
            GuiControl, Main:Hide, Change
            GuiControl, Main:Show, Bc
            GuiControl, Main:Show, Nm
            GuiControl, Main:Show, Qn
            GuiControl, Main:Show, Sum
            GuiControl, Main:Show, AddEnter
            GuiControl, Main:Hide, SubKridi
            GuiControl, Main:, Remise
            GuiControl, Main:, Client
            GuiControl, Main:, SellDesc
            LV_Delete()
            If FileExist("Dump\" SessionID ".db")
                FileDelete, % "Dump\" SessionID ".db"
            TrancsView(1, 1)

            GuiControl, Main:Enabled, Bc
            GuiControl, Main:Focus, Bc
            CheckListSum()
        }
    } Else If WinActive("ahk_id " Start) {
        GuiControlGet, AdminNameText, Startup:Visible, AdminNameText
        If (AdminNameText) {
            GuiControlGet, AdminNameText, Startup:, AdminNameText
            If (AdminNameText = "Login:")
                GoSub, NextLog
            Else
                GoSub, NextNewLog
        } Else {
            SendInput, {Enter}
        }
    }
    Sleep, 125
Return
#If

AnalyzeAvail:
    Gui, Main:Submit, NoHide
    If (Bc = "") {
        GuiControl, Main:, Nm
        GuiControl, Main:, Sum
        GuiControl, Main:, Qn
        CreateNew()
        Return
    }
    If WinExist("ahk_id " Search) {
        GoSub, ^F
    } Else If (ProdDefs["" Bc ""][1] != "") {
        GuiControl, Main:, Nm, % ProdDefs["" Bc ""][1]
        GuiControl, Main:, Qn, % ProdDefs["" Bc ""][4]
        GuiControl, Main:, Sum, % ProdDefs["" Bc ""][3]
    } Else {
        GuiControl, Main:, Nm
        GuiControl, Main:, Sum
        GuiControl, Main:, Qn
    }
Return
StartupGuiClose:
ExitApp

CalcProfit(PData) {
    TrArr := StrSplit(PData, "> ")
    TimeDT := TrArr[1]
    RArr := StrSplit(TrArr[3], ";")
    Items := 0, Names := "", CProByQn := {}
    For Each, One in StrSplit(Trim(TrArr[2], "|"), "|") {
        Vals := StrSplit(One, ";")
        PQ := StrSplit(Vals[3], "x")[2]
        Items += PQ
        Names .= (Names) ? " , " Vals[2] : Vals[2]
        If (CProByQn["" Vals[1] ""].Length() != 4)
            CProByQn["" Vals[1] ""] := [0, 0, 0, 0]
        CProByQn["" Vals[1] ""][1] += PQ
        CProByQn["" Vals[1] ""][2] += Vals[7]
        CProByQn["" Vals[1] ""][3] += Vals[4]
        CProByQn["" Vals[1] ""][4] += Vals[6]
    }

    Return, [ TimeDT
            , RArr
            , Items
            , Names
            , StrSplit(TrArr[2], ";")
            , TrArr[4] ? StrSplit(TrArr[4], ";") : 0
            , CProByQn
            , StrSplit(TrArr[3], ";")]
}
CalculateSum() {
    Global ProdDefs, ProdDefsTmp := {}, AdditionalInfo, _13
    Cost := Sum := 0
    FormatTime, OutTime, % A_Now, yyyy/MM/dd HH:mm:ss
    Data := OutTime "> "
    Loop, % LV_GetCount() {
        LV_GetText(Bc, A_Index, 1)
        LV_GetText(Qn, A_Index, 4)
        Qn := StrSplit(Qn, "x")[2]
        If (!Qn) || (!Bc) {
            MsgBox, 16, % _13, % _160 "`nRow: " A_Index
            Continue
        }
        Name    := ProdDefs["" Bc ""][1]
        SellStr := ProdDefs["" Bc ""][3] "x" Qn
        Sell    := ProdDefs["" Bc ""][3] * Qn
        Sum     += Sell
        BuyStr  := ProdDefs["" Bc ""][2] "x" Qn
        Buy     := ProdDefs["" Bc ""][2] * Qn

        Cost += Buy
        Data .= Bc ";" Name ";" SellStr ";" Sell ";" BuyStr ";" Buy ";" Sell - Buy "|"
        ProdDefsTmp["" Bc ""] := Qn_
    }
    Data .= "> " Sum ";" Cost ";" Sum - Cost
    If (AdditionalInfo) {
        GuiControlGet, Remise, Main:, Remise
        GuiControlGet, Client, Main:, Client
        GuiControlGet, SellDesc, Main:, SellDesc
        Data .= "> " Remise ";" Client ";" SellDesc
    }
    Return, [Sum, Trim(Data, "|"), OutTime]
}
CalculateTotal(Folder) {
    Total := 0
    Loop, Files, % Folder "\*.db", F
    {
        Total += StrSplit(StrSplit(DB_Read(A_LoopFileFullPath), "> ")[3], ";")[1]
    }
    Return, Total
}

CheckForUpdatesStat() {
    IniRead, Stat, Setting.ini, Update, Upt
    If (Stat = "ERROR")
        Stat := 0
Return, Stat
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
CheckListSum() {
    Global AdditionalInfo
    Everything := 0
    Loop, % LV_GetCount() {
        LV_GetText(Qn, A_Index, 4)
        If (Qn) {
            LV_GetText(ThisLSum, A_Index, 5)
            Everything += ThisLSum
        }
    }
    If (Everything) {
        GuiControlGet, Remise, Main:, Remise
        If (Remise) && (AdditionalInfo) {
            OrgEverything := Everything
            Everything -= Round(Remise / 100 * Everything)
        }
        GuiControl, Main:, ThisListSum, % Everything " " ConvertMillimsToDT(Everything) ((Remise && AdditionalInfo) ? "`t↓ " OrgEverything " " ConvertMillimsToDT(OrgEverything) : "")
        GuiControl, Main:, AllSum, % Everything
    } Else {
        GuiControl, Main:, ThisListSum, % "---"
    }
}
ConvertMillimsToDT(Value, Sign := "") {
    If (Value = "..." || !Value)
        Return
    ValueArr := StrSplit(Value / 1000, ".")
    Return, "(" (Sign ? " " Sign " " : "") ValueArr[1] (ValueArr[2] ? "." RTrim(ValueArr[2], 0) : "") " DT)"
}

RestoreSession(Data) {
    Gui, Main:Default
    Global MainCtrlListE, RMS
    For Each, Ctrl in StrSplit(MainCtrlListE, ",") {
        GuiControl, Main:, % Ctrl
    }
    LV_Delete()

    For Each, Item in StrSplit(Data, ";") {
        If !InStr(Item, "|") {
            CtrlC := StrSplit(Item, "=")
            GuiControl, Main:, % CtrlC[1], % CtrlC[2]
        } Else {
            For Each, Line in StrSplit(Item, "|") {
                Column := StrSplit(Line, "/")
                If (RMS = "#1") {
                    LV_Add("", Column[1], Column[2], Column[3], Column[4], Column[5])
                } Else {
                    Return
                }
            }
        }
    }
    GuiControl, Main:Focus, Bc
}

CreateNew() {
    Global SessionID, MainCtrlListE, NoCreateNe
    Content := ""
    For Each, Ctrl in StrSplit(MainCtrlListE, ",") {
        GuiControlGet, CtrlC, Main:, % Ctrl
        Content .= Content ? ";" Ctrl "=" CtrlC : Ctrl "=" CtrlC
    }
    Loop, % LV_GetCount() {
        LV_GetText(Bc, A_Index, 1)
        LV_GetText(QnC, A_Index, 2)
        LV_GetText(Nm, A_Index, 3)
        LV_GetText(Qn, A_Index, 4)
        LV_GetText(Sum, A_Index, 5)
        Content .= InStr(Content, "/") ? "|" Bc "/" QnC "/" Nm "/" Qn "/" Sum : ";" Bc "/" QnC "/" Nm "/" Qn "/" Sum
    }
    (!NoCreateNe) ? DB_Write("Dump\" SessionID ".db", Content)
}
LoadCurrent() {
    global RMS, UsersSells := {}, SortedQn, SortedPr, SortedSo, SortedCo, Remi := 0
    LV_Delete()
    Gui, Main:ListView, LV10
    LV_Delete()
    Gui, Main:ListView, LV1
    OAPr := SPr := CP := 0
    ProByQn := {}, SortCo := SortSo := SortQn := SortPr := ""
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
                If (Arr[6][1]) {
                    LV_Add("", A_LoopFileFullPath, Arr[1], Names := "↓ | " Arr[4])
                    Remi := Round(Arr[8][1] * Arr[6][1]/100)
                } Else {
                    LV_Add("", A_LoopFileFullPath, Arr[1], Names := Arr[4])
                    Remi := 0
                }
                ND := StrSplit(Arr[1], "|")
                If (ND.Length() = 2) {
                    If !UsersSells[ND[1]][1] {
                        GuiControl, Main:, Currents, % ND[1]
                        UsersSells[ND[1]] := [1, 0, 0, 0, 0]
                    }
                    UsersSells[ND[1] "_" A_Index] := [A_LoopFileFullPath, Arr[1], Names]
                    UsersSells[ND[1]][2] += Arr[2][1]
                    UsersSells[ND[1]][3] += Arr[2][2]
                    UsersSells[ND[1]][4] += Arr[2][3]
                    UsersSells[ND[1]][5] += Remi
                }
                UsersSells["All_" A_Index] := [A_LoopFileFullPath, Arr[1], Names]
            } Else {
                Return
            }

            SPr     +=    Arr[2][1]
            CP      +=    Arr[2][2]
            OAPr    +=    Arr[2][3]
            OARemi  += Remi

            For Each, One in Arr[7] {
                If !ProByQn.HasKey("" Each "")
                    ProByQn["" Each ""] := [0, 0, 0, 0]
                ProByQn["" Each ""][1] += One[1]
                ProByQn["" Each ""][2] += One[2]
                ProByQn["" Each ""][3] += One[3]
                ProByQn["" Each ""][4] += One[4]
            }
        }
    }
    UsersSells["All"] := [1, SPr, CP, OAPr, OARemi]
    SortedQn := []
    SortedPr := []
    SortedSo := []
    SortedCo := []

    If !LV_GetCount() {
        GuiControl, Main:Disabled, EnsBtn
        GuiControl, Main:Disabled, Chart
    } Else {
        For Each, One in ProByQn {
            SortedQn.Push([One[1], Each])
            SortedPr.Push([One[2], Each])
            SortedSo.Push([One[3], Each])
            SortedCo.Push([One[4], Each])
        }
    
        SortedQn := SortArr(SortedQn)
        SortedPr := SortArr(SortedPr)
        SortedSo := SortArr(SortedSo)
        SortedCo := SortArr(SortedCo)

        GuiControl, Main:, ProfitEq, % "+ " OAPr " " ConvertMillimsToDT(OAPr, "+") (OARemi ? " ↓" : "")
        GuiControl, Main:, Bought, % "- " CP " " ConvertMillimsToDT(CP, "-")
        GuiControl, Main:, Sold, % "+ " SPr " " ConvertMillimsToDT(SPr, "+") (OARemi ? " ↓" : "")
        GuiControl, Main:Choose, SortCurr, |1
        GuiControl, Main:Enabled, EnsBtn
        GuiControl, Main:Enabled, Chart
    }
}

LoadProf() {
    Global SinceBegin, RMS, SortedQn, SortedPr, SortedSo, SortedCo, WorkChart := {}, ByName := {}, _94, _95, _96, _97, Remi := 0
    LV_Delete()
    OARemi := OAPr := 0, SPr := 0, CP := 0
    GuiControl, Main:, OAProfit, % OAPr
    GuiControl, Main:, SPr, % SPr
    GuiControl, Main:, CPr, % CP

    GuiControl, Main:, ProfByName, % "|"
    GuiControl, Main:, ProfByName, % "All||"
    Range := 0

    Loop, Files, Valid\*.db, R F
    {
        ++Range
        GuiControl, Main:, PBText, % Range " found."
    }
    Loop, Files, Curr\*.db
    {
        ++Range
        GuiControl, Main:, PBText, % Range " found."
    }
    GuiControl, Main:Show, PB
    GuiControl, Main:, PB, % p := 0
    GuiControl, Main:+Range0-%Range%, PB

    GuiControlGet, Today, Main:, Today
    GuiControlGet, Yesterday, Main:, Yesterday

    GuiControlGet, SinceBegin, Main:, SinceBegin
    GuiControl, Main:Disabled, SinceBegin
    GuiControl, Main:Disabled, Chart
    ProByQn := {}
    Loop, Files, Valid\*.db, R F
    {
        If (!SinceBegin) {
            ThisFileDate := SubStr(A_LoopFileName, 1, StrLen(A_LoopFileName) - 3)
            IncludeIt := (ThisFileDate >= Yesterday) && (ThisFileDate <= Today)
        } Else If (!IncludeIt) {
            IncludeIt := 1
        }
        If (IncludeIt) {
            If (RD := DB_Read(A_LoopFileFullPath, 1)) {
                Arr := CalcProfit(RD)
                If (!Arr[2][1]) || (!Arr[2][2]) || (!Arr[2][3]) {
                    FileMove, % A_LoopFileFullPath, Unvalid
                } Else If (RMS = "#5") {
                    TRow := LV_Add("", A_LoopFileFullPath, Arr[1], Arg1 := "+ " Arr[2][1] " " ConvertMillimsToDT(Arr[2][1], "+") (Arr[6][1] ? " ↓" : "")
                                                                 , Arg2 := "- " Arr[2][2] " " ConvertMillimsToDT(Arr[2][2], "-")
                                                                 , Arg3 := "+ " Arr[2][3] " " ConvertMillimsToDT(Arr[2][3], "+") (Arr[6][1] ? " ↓" : ""))
                    Remi := Arr[6][1] ? Round(Arr[8][1] * Arr[6][1]/100) : 0
                    If ((ND := StrSplit(Arr[1], "|")).Length() = 2) {
                        If !ByName[ND[1]][1] {
                            GuiControl, Main:, ProfByName, % ND[1]
                            ByName[ND[1]] := [1, 0, 0, 0, 0]
                        }
                        ByName[ND[1] "_" A_Index] := [A_LoopFileFullPath, Arr[1], Arg1, Arg2, Arg3]
                        ByName[ND[1]][2] += Arr[2][1]
                        ByName[ND[1]][3] += Arr[2][2]
                        ByName[ND[1]][4] += Arr[2][3]
                        ByName[ND[1]][5] += Remi
                    }
                    ByName["All_" A_Index] := [A_LoopFileFullPath, Arr[1], Arg1, Arg2, Arg3]
                    SPr += Arr[2][1]
                    CP += Arr[2][2]
                    OAPr += Arr[2][3]
                    OARemi += Remi

                    For Each, One in Arr[7] {
                        If !ProByQn.HasKey("" Each "")
                            ProByQn["" Each ""] := [0, 0, 0, 0]
                        ProByQn["" Each ""][1] += One[1]
                        ProByQn["" Each ""][2] += One[2]
                        ProByQn["" Each ""][3] += One[3]
                        ProByQn["" Each ""][4] += One[4]
                    }
                } Else {
                    Return
                }
                DS := SubStr(A_LoopFileName, 1, 14)
                FormatTime, DS, % DS, yyyy/MM/dd
                If !WorkChart.HasKey(DS) {
                    WorkChart[DS] := [0, 0, 0]
                }
                If RD := DB_Read(A_LoopFileFullPath) {
                    Summ := StrSplit(StrSplit(RD, "> ")[3], ";")
                    WorkChart[DS][1] += Summ[1]
                    WorkChart[DS][2] += Summ[2]
                    WorkChart[DS][3] += Summ[3]
                }
            }
        }
        GuiControl, Main:, PB, % ++p
    }
    Loop, Files, Curr\*.db
    {
        If (!SinceBegin) {
            ThisFileDate := SubStr(A_LoopFileName, 1, StrLen(A_LoopFileName) - 3)
            IncludeIt := (ThisFileDate >= Yesterday) && (ThisFileDate <= Today)
        } Else If (!IncludeIt) {
            IncludeIt := 1
        }
        If (IncludeIt) {
            If (RD := DB_Read(A_LoopFileFullPath, 1)) {
                Arr := CalcProfit(RD)
                If (!Arr[2][1]) || (!Arr[2][2]) || (!Arr[2][3]) {
                    FileMove, % A_LoopFileFullPath, Unvalid
                } Else If (RMS = "#5") {
                    TRow := LV_Add("", A_LoopFileFullPath, Arr[1], Arg1 := "+ " Arr[2][1] " " ConvertMillimsToDT(Arr[2][1], "+") (Arr[6][1] ? " ↓" : "")
                                                                 , Arg2 := "- " Arr[2][2] " " ConvertMillimsToDT(Arr[2][2], "-")
                                                                 , Arg3 := "+ " Arr[2][3] " " ConvertMillimsToDT(Arr[2][3], "+") (Arr[6][1] ? " ↓" : ""))
                    Remi := Arr[6][1] ? Round(Arr[8][1] * Arr[6][1]/100) : 0
                    If ((ND := StrSplit(Arr[1], "|")).Length() = 2) {
                        If !ByName[ND[1]][1] {
                            ByName[ND[1]] := [1, 0, 0, 0, 0]
                            GuiControl, Main:, ProfByName, % ND[1]
                        }
                        ByName[ND[1] "_" A_Index] := [A_LoopFileFullPath, Arr[1], Arg1, Arg2, Arg3]
                        ByName[ND[1]][2] += Arr[2][1]
                        ByName[ND[1]][3] += Arr[2][2]
                        ByName[ND[1]][4] += Arr[2][3]
                        ByName[ND[1]][5] += Remi
                    }
                    ByName["All_" A_Index] := [A_LoopFileFullPath, Arr[1], Arg1, Arg2, Arg3]
                    SPr     += Arr[2][1]
                    CP      += Arr[2][2]
                    OAPr    += Arr[2][3]
                    OARemi += Remi

                    For Each, One in Arr[7] {
                        If !ProByQn.HasKey("" Each "")
                            ProByQn["" Each ""] := [0, 0, 0, 0]
                        ProByQn["" Each ""][1] += One[1]
                        ProByQn["" Each ""][2] += One[2]
                        ProByQn["" Each ""][3] += One[3]
                        ProByQn["" Each ""][4] += One[4]
                    }
                } Else {
                    Return
                }
                DS := SubStr(A_LoopFileName, 1, 14)
                FormatTime, DS, % DS, yyyy/MM/dd
                If !WorkChart.HasKey(DS) {
                    WorkChart[DS] := [0, 0, 0]
                }
                If RD := DB_Read(A_LoopFileFullPath) {
                    Summ := StrSplit(StrSplit(RD, "> ")[3], ";")
                    WorkChart[DS][1] += Summ[1]
                    WorkChart[DS][2] += Summ[2]
                    WorkChart[DS][3] += Summ[3]
                }
            }
        }
        GuiControl, Main:, PB, % ++p
    }
    ByName["All"] := [1, SPr, CP, OAPr, OARemi]

    SortedQn := []
    SortedPr := []
    SortedSo := []
    SortedCo := []

    For Each, One in ProByQn {
        SortedQn.Push([One[1], Each])
        SortedPr.Push([One[2], Each])
        SortedSo.Push([One[3], Each])
        SortedCo.Push([One[4], Each])
    }

    SortedQn := SortArr(SortedQn)
    SortedPr := SortArr(SortedPr)
    SortedSo := SortArr(SortedSo)
    SortedCo := SortArr(SortedCo)

    GuiControl, Main:Hide, PB
    GuiControl, Main:, SPr, % "+ " SPr " " ConvertMillimsToDT(SPr, "+") (OARemi ? " ↓" : "")
    GuiControl, Main:, CPr, % "- " CP " " ConvertMillimsToDT(CP, "-")
    GuiControl, Main:, OAProfit, % "+ " OAPr " " ConvertMillimsToDT(OAPr, "+") (OARemi ? " ↓" : "")
    GuiControl, Main:Enabled, Chart
    GuiControl, Main:Enabled, SinceBegin
}

SortArr(Arr) {
    x := 0, Len := Arr.Length()
    While (++x < Len) {
        y := x
        While (++y <= Len) {
            If (Arr[y][1] > Arr[x][1]) {
                Per := Arr[y]
                Arr[y] := Arr[x]
                Arr[x] := Per
            }
        }
    }
    Return, Arr
}

LoadDefined(Clear := 0) {
    global ProdDefs, RowsArr, Dbc, Dnm, Dbp, Dsp, EditMod, RMS
    LV_Delete()
    If (Clear) {
        GuiControl, Main:, Dbc
        GuiControl, Main:, Dnm
        GuiControl, Main:, Dbp
        GuiControl, Main:, Dsp
    }
    AllItems := ""
    For Each, Item in ProdDefs {
        AllItems .= Each ","
    }
    Sort, AllItems, N D,
    RowsArr := {}, Counted := 0
    Loop, Parse, % Trim(AllItems, ","), `,
    {
        If (RMS = "#3") {
            If (Clear) {
                RowsArr["" A_LoopField ""] := [Counted += 1]
                LV_Add("", A_LoopField, Counted " | " ProdDefs["" A_LoopField ""][1], ProdDefs["" A_LoopField ""][2], ProdDefs["" A_LoopField ""][3])
            } Else If InStr(A_LoopField, Dbc) && InStr(ProdDefs["" A_LoopField ""][1], Dnm) && InStr(ProdDefs["" A_LoopField ""][2], Dbp) && InStr(ProdDefs["" A_LoopField ""][3], Dsp) {
                RowsArr["" A_LoopField ""] := [Counted += 1]
                LV_Add("", A_LoopField, Counted " | " ProdDefs["" A_LoopField ""][1], ProdDefs["" A_LoopField ""][2], ProdDefs["" A_LoopField ""][3])
            }
        } Else {
            Return
        }
    }
    EditMod[1] := 0
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
DB_Read(FileName, FastMode := 0) {
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
LoadBackground() {
    Global Prt1, Prt2, Prt3, Prt4
    Gui, Main:Add, Picture, % "x199 y445 w801 h55 vPrt1", % "Img\Prt1_199x445_801x55.png"
    Gui, Main:Add, Picture, % "x0 y445 w199 h55 vPrt2", % "Img\Prt2_0x445_199x55.png"
    Gui, Main:Add, Picture, % "x0 y440 w1000 h5 vPrt3", % "Img\Prt3_0x440_1000x5.png"
    Gui, Main:Add, Picture, % "x204 y10 w5 h373 vPrt4", % "Img\Prt4_204x10_5x373.png"
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


LoadDefinitions(Data) {
    Tmp := {}
    Loop, Parse, % Trim(Data, "|"), |
    {
        ThisDef := StrSplit(A_LoopField, ";")
        If (ThisDef.Length() >= 4) {
            Tmp["" ThisDef[1] ""] := [RTrim(ThisDef[2], "0"), ThisDef[3], ThisDef[4], ThisDef[5], ThisDef[6] ? ThisDef[6] : ""]
        }
    }
    Return, Tmp
}

MouseHover() {
}
ShowToolTipGui() {
    Gui, Details:Show
    MouseGetPos, X, Y
    Global Info
    If (A_ScreenWidth - X > 800) && ((A_ScreenHeight - Y) > (A_ScreenHeight // 2))
    Gui, Details:Show, % "NoActivate x" (X += 20) " y" (Y += 10)
    Else If (A_ScreenWidth - X <= 800) && ((A_ScreenHeight - Y) > (A_ScreenHeight // 2)) {
        Gui, Details:Show, % "NoActivate x" (X -= 840) " y" (Y += 10)
    } Else If (A_ScreenWidth - X > 800) && ((A_ScreenHeight - Y) <= (A_ScreenHeight // 2)) {
        Gui, Details:Show, % "NoActivate x" (X += 20) " y" (Y -= (A_ScreenHeight // 2) + 30)
    } Else {
        Gui, Details:Show, % "NoActivate x" (X -= 840) " y" (Y -= (A_ScreenHeight // 2) + 30)
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

WriteNewAccount(nwUN, nwPW) {
    AccInfo := DB_Read("Sets\Lc.lic")
    DB_Write("Sets\Lc.lic", AccInfo ";" nwUN "/" nwPW)
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
    Global RMS, Kridis := {}, AllCashK := 0
    LV_Delete()
    GuiControl, Main:, KLE
    GuiControl, Main:, CashK
    GuiControl, Main:, CashKE
    GuiControl, Main:, KMD
    GuiControl, Main:, KLESum
    GuiControl, Main:, KMDSubmit
    GuiControl, Main:, KLB, |
    GuiControl, Main:, KLBB, |
    GuiControl, Main:, KLBB1, |
    GuiControlGet, KLE, Main:, KLE
    Ind := 0
    Loop, Files, Kr\*.*, D
    {
        SplitPath, % A_LoopFileFullPath,,,, OutNameNoExt
        If (RMS = "#7") {
            If InStr(Dec := DecodeAlpha(OutNameNoExt), KLE) {
                GuiControl, Main:, KLB, % Dec
                Kridis[++Ind] := A_LoopFileFullPath
            }
        } Else {
            Return
        }
    }
    For Each, Directory in Kridis {
        Loop, Files, % Directory "\*.db"
        {
            If (RD := DB_Read(Directory "\" A_LoopFileName)) {
                AllCashK += StrSplit(StrSplit(RD, "> ")[3], ";")[1]
            }
        }
    }
    Loop, Files, % "Kr\*.Off", R
    {
        If (RD := DB_Read(A_LoopFileFullPath)) {
            AllCashK -= RD
        }
    }
    GuiControl, Main:Choose, KLB, |1
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
    IniRead, Debug, Setting.ini, DebugMode, DM
    If (Debug) && (Debug != "ERROR") {
        DebugMode := 1
        GuiControl, Main:, DebugModeCB3, % Chr(252)
    } Else {
        DebugMode := 0
        GuiControl, Main:, DebugModeCB3
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
LoadKridiUsers() {
    global PrevKridis := {}
    GuiControl, Kridi:, KLB, |
    Loop, Files, % "Kr\*", D
    {
        PrevKridis[DecName := DecodeAlpha(A_LoopFileName)] := CalculateTotal(A_LoopFileFullPath)
        GuiControl, Kridi:, KLB, % DecName
    }
}
RunWaitMany(commands) {
    shell := ComObjCreate("WScript.Shell")
    exec := shell.Exec(ComSpec " /Q /K echo off")
    exec.StdIn.WriteLine(commands "`nexit")
return exec.StdOut.ReadAll()
}
SlideTheControl(List) {
    Global Width
    Loop, Parse, List, `,
    {
        GuiControlGet, CtrlPos, Main:Pos, % A_LoopField
        GuiControl, Main:Move, % A_LoopField, % "x" CtrlPosX + Width
        GuiControl, Main:Show, % A_LoopField
        X := 0
        Loop {
            X += 2
            GuiControl, Main:Move, % A_LoopField, % "x" CtrlPosX + Width - X
        } Until (X >= Width)
    }
}

ReWriteAccounts() {
    Global FoundUsers
    UUID := StrSplit(DB_Read("Sets\Lc.lic"), ";")[1]
    USR := "", ADM := ""
    For Each, Us in FoundUsers {
        If (Us[2] = "ADM")
            ADM := Each ";" Us[1]
        Else {
            USR .= USR ? ";" Each "/" Us[1] : Each "/" Us[1]
        }
    }
    DB_Write("Sets\Lc.lic", UUID ";" ADM ";" USR)
}

LoadAccounts() {
    Global FoundUsers
    AllUsers := StrSplit(DB_Read("Sets\Lc.lic"), ";"), FoundUsers := {}
    AllUsers.RemoveAt(1)
    FoundUsers[AllUsers.RemoveAt(1)] := [AllUsers.RemoveAt(1), "ADM", 1]
    Loop, % AllUsers.Count() {
        NamePass := StrSplit(AllUsers[A_Index], "/")
        FoundUsers[NamePass[1]] := [NamePass[2], "USR", A_Index + 1]
    }
}

TrancsView(Tranc, View) {
    Global _126, THCtrl
    If (View) {
        GuiControl, Main:Show, Transc
        GuiControl, Main:Show, TranscOK
        If (Tranc) {
            FormatTime, Now, % A_Now, dddd 'at' HH:mm:ss
            CtlColors.Change(THCtrl, "008000", "FFFFFF")
            GuiControl, Main:, Transc, % Now " - " _126 "  "
            GuiControl, Main:, TranscOK, Img\OK.png
        } Else {
            CtlColors.Change(THCtrl, "CCCCCC")
            GuiControl, Main:, Transc
            GuiControl, Main:, TranscOK, Img\Idle.png
        }
    } Else {
        GuiControl, Main:Hide, Transc
        GuiControl, Main:Hide, TranscOK
    }
}

SetExplorerTheme(HCTL) {
    If (DllCall("GetVersion", "UChar") > 5) {
        VarSetCapacity(ClassName, 1024, 0)
        If DllCall("GetClassName", "Ptr", HCTL, "Str", ClassName, "Int", 512, "Int") {
            Return !DllCall("UxTheme.dll\SetWindowTheme", "Ptr", HCTL, "WStr", "Explorer", "Ptr", 0)
        }
    }
   Return False
}