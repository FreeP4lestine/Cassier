GuiClose:
ExitApp

DisplayDetails:
    GuiControlGet, ReInLB,, ReInLB
    If (ReInLB) {
        GuiControl,, DInfo, % _27 ": " Array[ReInLB][1]
                       . "`n" _38 ": " Array[ReInLB][2]
                       . "`n" _39 ": " Array[ReInLB][3] " = " Array[ReInLB][4]
                       . "`n" _40 ": " Array[ReInLB][5] " = " Array[ReInLB][6]
                       . "`n" _41 ": " Array[ReInLB][7]
    }
    
Return