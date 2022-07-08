;////////////////////////////////////////////////////////////////////////////////////////////////
/*
    Kridi GUI labels
*/
;////////////////////////////////////////////////////////////////////////////////////////////////
CheckKExist:
    GuiControl, Kridi:Choose, KLB, 0
    Gui, Kridi:Submit, NoHide
    GuiControl, Kridi:ChooseString, KLB, % KName
    Gui, Kridi:Submit, NoHide
    GuiControl, Kridi:, Total, % PrevKridis[KLB] " " ConvertMillimsToDT(PrevKridis[KLB])
Return

WriteItDown:
    Gui, Kridi:Submit, NoHide
    If (KLB) {
        GuiControl, Kridi:, KName, % KLB
        GuiControl, Kridi:Focus, KName
        SelectAll(KE)
    }
Return
;////////////////////////////////////////////////////////////////////////////////////////////////