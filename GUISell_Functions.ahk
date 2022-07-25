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
    GuiControlGet, AddUp, Enabled, AddUp
    GuiControlGet, AddDown, Enabled, AddDown
    GuiControlGet, AddDelete, Enabled, AddDelete
    If LV_GetCount() {
        If (!AddSell)
            GuiControl, Enabled, AddSell
        If (!Cancel)
            GuiControl, Enabled, Cancel
        If (!AddUp)
            GuiControl, Enabled, AddUp
        If (!AddDown)
            GuiControl, Enabled, AddDown
        If (!AddDelete)
            GuiControl, Enabled, AddDelete
    } Else {
        If (AddSell)
            GuiControl, Disabled, AddSell
        If (Cancel)
            GuiControl, Disabled, Cancel
        If (AddUp)
            GuiControl, Disabled, AddUp
        If (AddDown)
            GuiControl, Disabled, AddDown
        If (AddDelete)
            GuiControl, Disabled, AddDelete
    }
}

CheckBarcode() {
    GuiControlGet, Bc,, Bc
    GuiControlGet, AddEnter, Enabled, AddEnter
    If (Bc != "") {
        If (!AddEnter)
            GuiControl, Enabled, AddEnter
    } Else If (AddEnter) {
        GuiControl, Disabled, AddEnter
    }
}

CheckLatestSells() {
    Global ProdDefs, SearchList := []
    If FileExist("Dump\Last10S.ini") {
        IniRead, Output, Dump\Last10S.ini, Last10S
        If (Output && Output != "ERROR") {
            Dummy := ""
            Loop, Parse, Output, `n, `r
            {
                Dummy := Dummy ? SubStr(A_LoopField, 1, InStr(A_LoopField, "=") - 1) "|" Dummy : SubStr(A_LoopField, 1, InStr(A_LoopField, "=") - 1)
            }
            GuiControl,, Search, |
            For Each, Bc in StrSplit(Dummy, "|") {
                GuiControl,, Search, %  " -- " ProdDefs["" Bc ""]["Name"] " -- "
                SearchList.Push("" Bc "")
            }
        }
    }
}

CalculateCurrent() {
    Global _37
    S := B := P := I := 0
    Loop, Files, Curr\*.sell
    {
        FileRead, Content, % A_LoopFileFullPath
        Content := StrSplit(StrSplit(Content, "> ")[2], "|")
        For Each, One in Content {
            F := StrSplit(One, ";")
            I += StrSplit(F[3], "x")[2]
            S += F[4]
            B += F[6]
            P += F[7]
        }
    }

    GuiControl,, ItemsSold, % I " " _37
    GuiControl,, SoldP,     % S "`n" ConvertMillimsToDT(S)
    GuiControl,, CostP,     % B "`n" ConvertMillimsToDT(B)
    GuiControl,, ProfitP,   % P "`n" ConvertMillimsToDT(P)

    Return, [I, S, B, P]
}

LogIn(Username, Password) {
    If !FileExist("Sets\" Username ".chu") || (!RD := DB_Read("Sets\" Username ".chu")) {
        Return, 0
    }

    Pass := Trim(Trim(RD, "|"), ";")
    If !(Pass == Password)
        Return, 0
    
    If InStr(RD, ";")
        Return, 1
    Return, 2
}

Decode(string) {
    if !(DllCall("crypt32\CryptStringToBinary", "ptr", &string, "uint", 0, "uint", 0x1, "ptr", 0, "uint*", size, "ptr", 0, "ptr", 0))
        Return
    VarSetCapacity(buf, size, 0)
    if !(DllCall("crypt32\CryptStringToBinary", "ptr", &string, "uint", 0, "uint", 0x1, "ptr", &buf, "uint*", size, "ptr", 0, "ptr", 0))
        Return
    return, StrGet(&buf, size, "UTF-8")
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