;///////////////////////////////////////////////////////////////////////////////
/*
    Setup Details GUI
*/
;///////////////////////////////////////////////////////////////////////////////

#SingleInstance, Force

#Include, Lib\Language.ahk

Gui, Color, 0xD8D8AD
Gui, +HwndInfo +ToolWindow
Gui, Font, s15 Bold, Calibri
Gui, Margin, 5, 5
Gui, Add, ListBox, w200 r10 vReInLB gDisplayDetails AltSubmit
Gui, Add, Edit, xp+210 yp w500 h200 ReadOnly vDInfo -E0x200 Border -VScroll
Gui, Add, Edit, xp yp+212 ReadOnly w500 vOverAll -E0x200 Border cGreen Center
Gui, Add, Text, xm yp+45, % _123 ":"
Gui, Add, Edit, xp yp+30 w300 vRemise ReadOnly -E0x200 Border cGreen
Gui, Add, Text, xp yp+35, % _124 ":"
Gui, Add, Edit, xp yp+30 w710 vClient -E0x200 Border ReadOnly cBlue
Gui, Add, Text, xp yp+35 wp, % _125 ":"
Gui, Add, Edit, xp yp+30 wp vSellDesc cBlue r10 -E0x200 Border ReadOnly -VScroll
Gui, Show

FileRead, Content, %1%

Content := StrSplit(Content, "> ")
Sells   := StrSplit(Content[2], "|")

Array := {}, OverAll := 0
For Each, One in Sells {
    Section := StrSplit(One, ";")
    Array[A_Index] := [Section[1]       ; Barcode
                     , Section[2]       ; Name
                     , Section[3]       ; SellStr
                     , Section[4]       ; Sells
                     , Section[5]       ; BuyStr
                     , Section[6]       ; Buys
                     , Section[7]]      ; Profit
    GuiControl,, ReInLB, % Array[A_Index][2]
    OverAll += Section[7]
}

GuiControl,, OverAll, % OverAll " " ConvertMillimsToDT(OverAll)

If (Content[4]) {
    AddInfo := StrSplit(Content[4], ";")
    GuiControl,, Remise, % AddInfo[1] " %"
    GuiControl,, Client, % AddInfo[2]
    GuiControl,, SellDesc, % AddInfo[3]
}

GuiControl, Choose, ReInLB, |1
Return

#Include, GUIDetails_Labels.ahk
#Include, GUIDetails_Functions.ahk
;///////////////////////////////////////////////////////////////////////////////