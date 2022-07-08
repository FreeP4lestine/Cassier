;/////////////////////////////////////////////////////////////////////////////////////////////////
/*
    User Accounts GUI labels
*/
;/////////////////////////////////////////////////////////////////////////////////////////////////
SelectUser:
    GuiControlGet, ULB, Users:, ULB
    If (ULB) {
        If (RD := DB_Read("Sets\" ULB ".chu")) {
            GuiControl, Users:, EName, % ULB
            GuiControl, Users:, EPass, % Trim(Trim(RD, "|"), ";")
        } Else {
            GuiControl, Users:, EName
            GuiControl, Users:, EPass
        }
        GuiControl, Users:Focus, EName
    }
Return

DeleteUser:
    GuiControlGet, ULB, Users:, ULB
    If (RD := DB_Read("Sets\" ULB ".chu")) {
        FileDelete, % "Sets\" ULB ".chu"
        If InStr(RD, ";") {
            FileDelete, % "Sets\License.ch"
            Reload
        }
        GuiControl, Users:, ULB, |
        GuiControl, Users:, EName
        GuiControl, Users:, EPass
        Ind := 0
        Loop, Files, Sets\*.chu
        {
            If (RD := DB_Read(A_LoopFileFullPath)) {
                Name := SubStr(A_LoopFileName, 1, - 4)
                GuiControl, Users:, ULB, %  Name
            }
        }
        GuiControl, Users:Focus, EName
    }
Return

AddUser:
    GuiControlGet, EName, Users:, EName
    GuiControlGet, EPass, Users:, EPass
    If !(EName EPass ~= ";|\||/") && (EName != "") && (EPass != "") {
        Affix := ""
        If (RD := DB_Read("Sets\" EName ".chu")) {
            If InStr(RD, ";")
                Affix .= ";"
            If InStr(RD, "|")
                Affix .= "|"
        }
        DB_Write("Sets\" EName ".chu", EPass Affix)
        GuiControl, Users:, EName
        GuiControl, Users:, EPass
        If (!RD)
            GuiControl, Users:, ULB, % EName
        GuiControl, Users:ChooseString, ULB, % "|" EName
        GuiControl, Users:Focus, EName
    }
Return
;//////////////////////////////////////////////////////////////////////////////////////////////////