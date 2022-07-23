#If WinActive("ahk_id " Main)
    Enter::
        GuiControlGet, Bc, , Bc
        GuiControl, Disabled, Bc
        If (!Selling) {
            Barcode := Bc
            If (ProdDefs["" Barcode ""]["Name"] != "")
            && (ProdDefs["" Barcode ""]["SellPrice"] != "") 
            && (ProdDefs["" Barcode ""]["Quantity"] != "") {
                Nm                  := ProdDefs["" Barcode ""]["Name"]
                SellPrice           := ProdDefs["" Barcode ""]["SellPrice"]
                ThisCurrQuantity    := ProdDefs["" Barcode ""]["Quantity"] ? ProdDefs["" Barcode ""]["Quantity"] : 0
                QuantitySumArg      := SellPrice "x1"

                JobDone             := 0
                Loop, % LV_GetCount() {
                    LV_GetText(ThisBc, Row := A_Index, 1)
                    If (ThisBc = Barcode) {
                        LV_GetText(AddedCurrQuantity, Row, 2), AddedCurrQuantity := StrSplit(AddedCurrQuantity, "  >>  ")
                        LV_GetText(AddedQuantitySumArg, Row, 4), AddedQuantitySumArg := StrSplit(AddedQuantitySumArg, "x"), QuantitySumArg := AddedQuantitySumArg[1] "x" AddedQuantitySumArg[2] + 1
                        LV_GetText(PreviousSum, Row, 5)
                        SellPrice := ProdDefs["" Barcode ""]["SellPrice"]
                        LV_Modify(Row,,, AddedCurrQuantity[1] "  >>  " AddedCurrQuantity[2] - 1,, QuantitySumArg, PreviousSum + SellPrice)
                        JobDone := 1
                        Break
                    }
                }
                If (!JobDone) {
                    LV_Add("", Barcode, ThisCurrQuantity "  >>  " ThisCurrQuantity - 1, Nm, QuantitySumArg, SellPrice)
                }
                CalculateSum()
                WriteSession()
            }
        } Else {
            FormatTime, OutTime, % (Now := A_Now), yyyy/MM/dd HH:mm:ss
            Obj     := FileOpen(LastestSO := "Curr\" Now ".sell", "w")
            Obj.Write(AdminName "|" OutTime)

            IniRead, Counter, Dump\Last10S.ini, Counter, Counter
            If Counter is not Digit
                Counter := 0
            Loop, % LV_GetCount() {
                LV_GetText(Bc, A_Index, 1)
                LV_GetText(Qn, A_Index, 4)
                Qn := StrSplit(Qn, "x")[2]

                If (!Qn) || (!Bc) {
                    MsgBox, 16, % _13, % _160 "`nRow: " A_Index
                    Continue
                }

                ProdDefs["" Bc ""]["Quantity"] -= Qn

                FileRead, Content, % "Sets\Def\" Bc ".def"
                Content := StrSplit(Content, ";")

                DefObj := FileOpen("Sets\Def\" Bc ".def", "w")
                DefObj.Write(Content[1] ";" Content[2] ";" Content[3] ";" Content[4] - Qn)
                DefObj.Close()

                Name    := ProdDefs["" Bc ""]["Name"]
                SellStr := ProdDefs["" Bc ""]["SellPrice"] "x" Qn
                Sell    := ProdDefs["" Bc ""]["SellPrice"] * Qn
                Sum     += Sell
                BuyStr  := ProdDefs["" Bc ""]["BuyPrice"] "x" Qn
                Buy     := ProdDefs["" Bc ""]["BuyPrice"] * Qn

                Cost += Buy
                Obj.Write(((A_Index > 1) ? "|" : "> ") Bc ";" Name ";" SellStr ";" Sell ";" BuyStr ";" Buy ";" Sell - Buy)

                If (Counter < 10) {
                    IniRead, Output, Dump\Last10S.ini, Last10S, %Bc%
                    If (Output && Output != "ERROR") {
                        IniDelete, Dump\Last10S.ini, Last10S, %Bc%
                    } Else {
                        ++Counter
                    }
                } Else {
                    IniRead, Output, Dump\Last10S.ini, Last10S, %Bc%
                    If (Output && Output != "ERROR") {
                        IniDelete, Dump\Last10S.ini, Last10S, %Bc%
                    } Else {
                        IniRead, Output, Dump\Last10S.ini, Last10S
                        IniDelete, Dump\Last10S.ini, Last10S, % SubStr(Output, 1, InStr(Output, "=") - 1)
                    }
                }
                IniWrite, %Qn%, Dump\Last10S.ini, Last10S, %Bc%
            }
            Obj.Write("> " Sum ";" Cost ";" Sum - Cost)
            IniWrite, %Counter%, Dump\Last10S.ini, Counter, Counter

            GuiControlGet, Remise, , Remise
            GuiControlGet, Client, , Client
            GuiControlGet, SellDesc, , SellDesc
            If (AdditionalInfo) && (Remise || Client || SellDesc) {
                Obj.Write("> " Remise ";" Client ";" SellDesc)
            }
            Obj.Close()

            If FileExist("Dump\kridi.OK") {
                FileRead, KName, Dump\kridi.OK
                If !InStr(FileExist("KR\" KName), "D") {
                    FileCreateDir, % "KR\" KName
                }
                FileCopy, % LastestSO, % "KR\" KName
                If FileExist("Dump\kridi.OK")
                    FileDelete, Dump\kridi.OK
            }

            CartView()
            WriteSession()
            CalculateSum()
            CheckLatestSells()
            TrancsView(1, 1)
            Selling := 0
        }
        GuiControl, Enabled, Bc
        GuiControl, , Bc
        GuiControl, Focus, Bc
        CheckListView()
        Sleep, 125
    Return

    Space::
        GuiControlGet, FocusedControl, FocusV
        If (FocusedControl ~= "Client|SellDesc") {
            SendInput, {Space}
        } Else {
            If LV_GetCount() {
                SellView()
                AllSum := 0
                Loop, % LV_GetCount() {
                    LV_GetText(ThisAllSum, A_Index, 5)
                    AllSum += ThisAllSum
                }
                GuiControl, , AllSum, % AllSum
                GuiControl, Disabled, AddEnter
                GuiControl, Enabled, SubKridi
                GuiControl, Focus, GivenMoney
                CalculateSum()
                Selling := 1
            } Else {
                GuiControl, Focus, Bc
            }
        }
        Sleep, 125
    Return

    Left::
        If !(--Session) {
            Session += 10
        }

        Loop, 10 {
            If (A_Index = Session) {
                GuiControl, Disabled, Session%A_Index%
            } Else {
                GuiControl, Enabled, Session%A_Index%
            }
        }

        RestoreSession()
        CalculateSum()
        CheckListView()
        Sleep, 125
    Return

    Right::
        If (++Session = 11) {
            Session -= 10
        }

        Loop, 10 {
            If (A_Index = Session) {
                GuiControl, Disabled, Session%A_Index%
            } Else {
                GuiControl, Enabled, Session%A_Index%
            }
        }

        RestoreSession()
        CalculateSum()
        CheckListView()
        Sleep, 125
    Return

    Up::
        GuiControlGet, Focused, FocusV
        If (Focused = "ListView") {
            If (Row := LV_GetNext()) {
                LV_GetText(ThisQn, Row, 4)
                LV_GetText(ThisBc, Row, 1)
                VQ := StrSplit(ThisQn, "x")
                LV_Modify(Row,,, ProdDefs["" ThisBc ""]["Quantity"] "  >>  " ProdDefs["" ThisBc ""]["Quantity"] - (VQ[2] + 1),, VQ[1] "x" VQ[2] + 1, VQ[1] * (VQ[2] + 1))
            }
        } Else {
            If (Row := LV_GetCount()) {
                LV_GetText(ThisQn, Row, 4)
                LV_GetText(ThisBc, Row, 1)
                VQ := StrSplit(ThisQn, "x")
                LV_Modify(Row,,, ProdDefs["" ThisBc ""]["Quantity"] "  >>  " ProdDefs["" ThisBc ""]["Quantity"] - (VQ[2] + 1),, VQ[1] "x" VQ[2] + 1, VQ[1] * (VQ[2] + 1))
            }
        }
        CalculateSum()
        WriteSession()
        Sleep, 125
    Return

    Down::
        GuiControlGet, Focused, FocusV
        If (Focused = "ListView") {
            If (Row := LV_GetNext()) {
                LV_GetText(ThisQn, Row, 4)
                LV_GetText(ThisBc, Row, 1)
                VQ := StrSplit(ThisQn, "x")
                If (VQ[2] > 1) {
                    LV_Modify(Row,,, ProdDefs["" ThisBc ""]["Quantity"] "  >>  " ProdDefs["" ThisBc ""]["Quantity"] - (VQ[2] - 1),, VQ[1] "x" VQ[2] - 1, VQ[1] * (VQ[2] - 1))
                }
            }
        } Else {
            If (Row := LV_GetCount()) {
                LV_GetText(ThisQn, Row, 4)
                LV_GetText(ThisBc, Row, 1)
                VQ := StrSplit(ThisQn, "x")
                If (VQ[2] > 1) {
                    LV_Modify(Row,,, ProdDefs["" ThisBc ""]["Quantity"] "  >>  " ProdDefs["" ThisBc ""]["Quantity"] - (VQ[2] - 1),, VQ[1] "x" VQ[2] - 1, VQ[1] * (VQ[2] - 1))
                }
            }
        }
        CalculateSum()
        WriteSession()
        Sleep, 125
    Return

    Delete::
        GuiControlGet, Focused, FocusV
        If (Focused = "ListView") && (Row := LV_GetNext()) {
            LV_Delete(Row)
            CalculateSum()
            WriteSession()
        }
        CheckListView()
    Return

    Esc::
        CartView()
        WriteSession()
        CheckBarcode()
    Return

    ^F::
        GuiControlGet, Bc,, Bc
        GuiControl,, Search, |
        SearchList := []
        For Every, Product in ProdDefs {
            If InStr(Product["Name"], Bc) {
                SearchList.Push("" Every "")
                GuiControl, , Search, % Product["Name"]
            }
        }
    Return
#If