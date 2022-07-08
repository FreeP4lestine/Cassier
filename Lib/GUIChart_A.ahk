;///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*
    Chart GUI labels
*/
;///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
LoadLB:
    GuiControl, Chart:, LB, |
    GuiControlGet, DDL, Chart:, DDL
    GuiControlGet, SeachBc, Chart:, SeachBc
    Sorted := (DDL = "Quantity") ? SortedQn : ((DDL = "Profit") ? SortedPr : ((DDL = "Sell Price") ? SortedSo : ((DDL = "Cost Price") ? SortedCo : "")))
    Charts := {}, Ind := 0 
    For Every, Line in Sorted {
        If InStr(Line[2], SeachBc) || InStr(ProdDefs["" Line[2] ""][1], SeachBc) {
            GuiControl, Chart:, LB, % A_Index " │ " ProdDefs["" Line[2] ""][1] " │ " Line[1]
            Charts[++Ind] := [Line[1], "" Line[2] ""]
        }
    }
    GuiControl, Chart:Choose, LB, |1
Return

DisplaySellInfo:
    GuiControlGet, LB, Chart:, LB
    If (LB) {
        GuiControlGet, DDL, Chart:, DDL
        Per := Round(Charts[LB][1] / Charts[1][1] * 100)
        GuiControl, Chart:, CB, % (Per >= 1) ? Per : 1
        GuiControl, Chart:, CR, % "[ " DDL ": " Charts[LB][1] " ]"
                                . "`n`n" _38 ": " ProdDefs["" Charts[LB][2] ""][1]
                                . "`n" _27 ": " Charts[LB][2]
                                . "`n" _40 ": " ProdDefs["" Charts[LB][2] ""][2]
                                . "`n" _39 ": " ProdDefs["" Charts[LB][2] ""][3]
                                . "`n" _41 ": " ProdDefs["" Charts[LB][2] ""][3] - ProdDefs["" Charts[LB][2] ""][2]
    }
Return
;///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////