;///////////////////////////////////////////////////////////////////////////////
/*
    Details GUI labels
*/
;///////////////////////////////////////////////////////////////////////////////
DisplayDetails:
    GuiControlGet, ReInLB,, ReInLB
    If (ReInLB) {
        GuiControl, Details:, DInfo, % _27 ": " ReInArr[ReInLB][1]
        . "`n" _38 ": " ReInArr[ReInLB][2]
        . "`n" _39 ": " ReInArr[ReInLB][3] " = " ReInArr[ReInLB][4]
        . "`n" _40 ": " ReInArr[ReInLB][5] " = " ReInArr[ReInLB][6]
        . "`n" _41 ": " ReInArr[ReInLB][7]
    }
Return
;///////////////////////////////////////////////////////////////////////////////