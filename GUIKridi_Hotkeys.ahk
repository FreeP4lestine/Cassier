#If WinActive("ahk_id " Kridi)
    Enter::
        GuiControlGet, KName,, KName
        If (KName = "")
            GuiControlGet, KName,, KLB
        If (KName) {
            Obj := FileOpen("Dump\kridi.OK", "w")
            Obj.Write(KName)
            Obj.Close()
            ExitApp
        }
    Return
#If