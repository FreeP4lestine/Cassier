;///////////////////////////////////////////////////////////////////////////////
/*
    Setup Details GUI
*/
;///////////////////////////////////////////////////////////////////////////////
Gui, Details:Color, 0xD8D8AD
Gui, Details:+HwndInfo -MinimizeBox
Gui, Details:Font, s15 Bold, Calibri
Gui, Details:Margin, 5, 5
Gui, Details:Add, ListBox, w200 r10 vReInLB gDisplayDetails AltSubmit
Gui, Details:Add, Edit, xp+210 yp w500 h200 ReadOnly vDInfo -E0x200 Border
Gui, Details:Add, Edit, xp yp+212 ReadOnly w500 vOverAll -E0x200 Border cGreen
Gui, Details:Add, Text, xm yp+45, % _123 ":"
Gui, Details:Add, Edit, xp yp+30 w300 vRemise ReadOnly -E0x200 Border cGreen
Gui, Details:Add, Text, xp yp+35, % _124 ":"
Gui, Details:Add, Edit, xp yp+30 w710 vClient -E0x200 Border ReadOnly
Gui, Details:Add, Text, xp yp+35 wp, % _125 ":"
Gui, Details:Add, Edit, xp yp+30 wp vSellDesc cBlue r10 -E0x200 Border ReadOnly
;///////////////////////////////////////////////////////////////////////////////