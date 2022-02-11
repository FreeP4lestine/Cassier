#Include, <Class_CtlColors>
#NoTrayIcon
#SingleInstance, Force
Gui, Color, 0xD8D8AD
Gui, -Caption +ToolWindow
Gui, Add, Text, x150 y5 w100 h20 vT HwndTxt
CtlColors.Attach(Txt, "008000", "000000")
Gui, Font, s20 Bold italic, Calibri
Gui, Add, Text, x0 y25 Center h80 w400, Working on it...
Gui, Show, h70 w400
LoadX := 150
LoadSens := 0
SetTimer, Loading, 0
Return

Loading:
    If (!LoadSens) {
        LoadX += 2
        GuiControl, Move, % "T", % "x" ((LoadX > 150) ? LoadX : 150) " w" ((LoadX > 150) ? (250 - LoadX) : LoadX - 50)
        If (LoadX > 250) {
            LoadSens := !LoadSens
        }
    } Else {
        LoadX -= 2
        GuiControl, Move, % "T", % "x" ((LoadX > 150) ? LoadX : 150) " w" ((LoadX > 150) ? (250 - LoadX) : LoadX - 50)
        If (LoadX < 50) {
            LoadSens := 0
        }
    }
Return

