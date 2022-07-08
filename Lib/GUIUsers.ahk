;/////////////////////////////////////////////////////////////////////////////////////////////
/*
    Setup User Accounts GUI
*/
;/////////////////////////////////////////////////////////////////////////////////////////////
Gui, Users:-MinimizeBox +HwndUr
Gui, Users:Font, s15 Bold, Calibri
Gui, Users:Margin, 15, 10
Gui, Users:Color, 0xD8D8AD
Gui, Users:Add, ListBox, HwndHCtrlULB w250 h500 vULB gSelectUser
CtlColors.Attach(HCtrl, "D8D8AD")
Gui, Users:Add, Edit, xp+270 yp+170 w272 vEName -E0x200 Border h30 Center
Gui, Users:Add, Edit, xp yp+35 w272 vEPass -E0x200 Border h30 Center cRed
Gui, Users:Font, s12
Gui, Users:Add, Button, % "xp yp+40 w132 h32 Center HwndHCtrl gAddUser", % "     " _140
ImageButton.Create(HCtrl, [ [0, "Img\DEA\1.png",, 0x008000]
                          , [0, "Img\DEA\2.png",, 0x0080FF]
                          , [0, "Img\DEA\3.png",, 0x008000]
                          , [0, "Img\DEA\4.png"]]*)
Gui, Users:Add, Button, % "xp+140 yp w132 h32 Center HwndHCtrl gDeleteUser", % "       " _130
ImageButton.Create(HCtrl, [ [0, "Img\DEC\1.png",, 0xFF0000]
                          , [0, "Img\DEC\2.png",, 0x0080FF]
                          , [0, "Img\DEC\3.png",, 0xFF0000]
                          , [0, "Img\DEC\4.png"]]*)
;/////////////////////////////////////////////////////////////////////////////////////////////