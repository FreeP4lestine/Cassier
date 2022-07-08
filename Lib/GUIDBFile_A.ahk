;///////////////////////////////////////////////////////////////////////////////////////////////////////////
/*
    DB File Edit GUI labels
*/
;///////////////////////////////////////////////////////////////////////////////////////////////////////////
ApplyEdit:
    Gui, Editf:Default
    Gui, Editf:ListView, LV
    Data := "", Sum := Cost := 0
    Loop, % LV_GetCount() {
        LV_GetText(Qn, A_Index, 4)
        If (!Qn) {
            Continue
        }
        LV_GetText(ThisSum, A_Index, 5)
        Sum += ThisSum
        LV_GetText(Bc, A_Index, 1)

        LV_GetText(Nm, A_Index, 3)
        BP := ProdDefs["" Bc ""][2]
        Qn_ := SubStr(Qn, InStr(Qn, "x") + 1)
        ThisCost := BP * Qn_
        Cost += ThisCost
        ProdDefs["" Bc ""][4] := ProdDefs["" Bc ""][4] + (PrevQn["" Bc ""] - Qn_)
        Data .= Bc ";" Nm ";" Qn ";" ThisSum ";" BP "x" Qn_ ";" ThisCost ";" ThisSum - ThisCost "|"
    }
    DB_Write(FileToBeEdit, RWD[1] "> " Data "> " Sum ";" Cost ";" Sum - Cost (RWD[4] ? "> " RWD[4] : ""))
    If (RMS = "#2")
        LoadCurrent()
    Else If (RMS = "#7"){
        LoadKridis()
    }
    Gui, Editf:Hide
    Gui, Main:Default
Return
;///////////////////////////////////////////////////////////////////////////////////////////////////////////