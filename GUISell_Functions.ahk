ConvertMillimsToDT(Value, Sign := "") {
    If (Value = "..." || !Value)
        Return
    ValueArr := StrSplit(Value / 1000, ".")
    Return, "(" (Sign ? " " Sign " " : "") ValueArr[1] (ValueArr[2] ? "." RTrim(ValueArr[2], 0) : "") " DT)"
}

RestoreSession() {
    Global Session
    If LV_GetCount()
        LV_Delete()

    If FileExist("Dump\" Session ".session") {
        Obj := FileOpen("Dump\" Session ".session", "r")
        While !Obj.AtEOF() {
            Line := Trim(Obj.ReadLine(), "`n")
            Col := StrSplit(Line, ",")
            LV_Add(, Col[1], Col[2], Col[3], Col[4], Col[5])
        }
        Obj.Close()
    }
    GuiControl, Focus, Bc
    CheckListView()
}

WriteSession() {
    Global Session
    Obj := FileOpen("Dump\" Session ".session", "w")
    Loop, % LV_GetCount() {
        LV_GetText(Col1, A_Index, 1)
        LV_GetText(Col2, A_Index, 2)
        LV_GetText(Col3, A_Index, 3)
        LV_GetText(Col4, A_Index, 4)
        LV_GetText(Col5, A_Index, 5)
        Obj.WriteLine(Col1 "," Col2 "," Col3 "," Col4 "," Col5)
    }
    Obj.Close()
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

LoadDefinitions() {
    Definitions := {}
    Loop, Files, Sets\Def\*.Def
    {
        FileRead, Content, % A_LoopFileFullPath
        Content := StrSplit(Content, ";")
        Definitions["" StrReplace(A_LoopFileName, ".def") ""] := { "Name"        :   Content[1]
                                                                 , "BuyPrice"    :   Content[2]
                                                                 , "SellPrice"   :   Content[3]
                                                                 , "Quantity"    :   Content[4] }
    }
    Return, Definitions
}

CalculateSum() {
    Global AdditionalInfo
    CharSum := 0
    Loop, % LV_GetCount() {
        LV_GetText(ThisCharSum, A_Index, 5)
        CharSum += ThisCharSum
    }
    If (CharSum) {
        GuiControlGet, Remise, , Remise
        CharSumRemise := CharSum
        If (Remise) && (AdditionalInfo) {
            CharSumRemise -= Round(Remise / 100 * CharSum)
        }
        GuiControl, , ThisListSum, % CharSumRemise " " ConvertMillimsToDT(CharSumRemise)
        GuiControl, , AllSum, % CharSumRemise
    } Else {
        GuiControl, , ThisListSum, 0
    }
}

CartView() {
    Global Selling
    Selling := 0
    GuiControl, Enabled, AddEnter
    GuiControl, Disabled, SubKridi
    GuiControl, Disabled, AddSubmit
    GuiControl, Disabled, AddSell
    GuiControl, Disabled, Cancel
    GuiControl, , AllSum
    GuiControl, , Change
    GuiControl, , GivenMoney
    GuiControl, Hide, GivenMoney
    GuiControl, Hide, AllSum
    GuiControl, Hide, Change
    GuiControl, Show, Bc
    GuiControl, Show, Nm
    GuiControl, Show, Qn
    GuiControl, Show, Sum
    GuiControl, , Remise
    GuiControl, , Client
    GuiControl, , SellDesc
    LV_Delete()
    GuiControl, Focus, Bc
}

SellView() {
    Global Selling
    Selling := 1
    GuiControl, Enabled, AddSubmit
    GuiControl, Disabled, AddEnter
    GuiControl, Enabled, Cancel
    GuiControl, Disabled, AddSell
    GuiControl, Enabled, SubKridi
    GuiControl, Hide, Bc
    GuiControl, Hide, Nm
    GuiControl, Hide, Qn
    GuiControl, Hide, Sum
    GuiControl, Show, GivenMoney
    GuiControl, Show, AllSum
    GuiControl, Show, Change
    GuiControl, Focus, GivenMoney
}

TrancsView(Tranc, View) {
    Global _126, THCtrl
    If (View) {
        GuiControl, Show, Transc
        GuiControl, Show, TranscOK
        If (Tranc) {
            FormatTime, Now, % A_Now, dddd 'at' HH:mm:ss
            CtlColors.Change(THCtrl, "008000", "FFFFFF")
            GuiControl, , Transc, % Now " - " _126 "  "
            GuiControl, , TranscOK, Img\OK.png
        } Else {
            CtlColors.Change(THCtrl, "CCCCCC")
            GuiControl, , Transc
            GuiControl, , TranscOK, Img\Idle.png
        }
    } Else {
        GuiControl, Hide, Transc
        GuiControl, Hide, TranscOK
    }
}

CheckListView() {
    GuiControlGet, AddSell, Enabled, AddSell
    GuiControlGet, Cancel, Enabled, Cancel
    If LV_GetCount() {
        If !AddSell
            GuiControl, Enabled, AddSell
        If !Cancel
            GuiControl, Enabled, Cancel
    } Else {
        If AddSell
            GuiControl, Disabled, AddSell
        If Cancel
            GuiControl, Disabled, Cancel
    }
}

CheckBarcode() {
    
    GuiControl, Disabled, AddEnter
}