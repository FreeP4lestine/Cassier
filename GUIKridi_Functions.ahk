LoadKridiUsers() {
    GuiControl, , KLB, |
    Loop, Files, % "Kr\*", D
        GuiControl,, KLB, % A_LoopFileName

    MaxValue := 0
    Obj := FileOpen("Dump\tmp.kridi", "r")
    While !Obj.AtEOF() {
        Line := Obj.ReadLine()
        Col     := StrSplit(Line, ",")
        LV_Add(, Col[1], Col[2], Col[3], Col[4], Col[5])
        MaxValue += Col[5]
    }
    Obj.Close()
    GuiControl,, Total, % "+" MaxValue " " ConvertMillimsToDT(MaxValue, "+")
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

ConvertMillimsToDT(Value, Sign := "") {
    If (Value = "..." || !Value)
        Return
    ValueArr := StrSplit(Value / 1000, ".")
    Return, "(" (Sign ? " " Sign " " : "") ValueArr[1] (ValueArr[2] ? "." RTrim(ValueArr[2], 0) : "") " DT)"
}