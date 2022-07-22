GuiClose:
ExitApp

LaunchKeyboard:
    Run, osk.exe
Return

SubKridi:
    Obj     := FileOpen("Dump\" Session ".session", "r")
    TObj    := FileOpen("Dump\tmp.kridi", "w")

    While !Obj.AtEOF() {
        TObj.Write(Obj.ReadLine())
    }

    Obj.Close()
    TObj.Close()

    Run, % "GUIKridi" (A_IsCompiled ? ".exe" : ".ahk")
Return

Calc:
    GuiControlGet, GivenMoney,, GivenMoney
    GuiControlGet, AllSum,, AllSum
    GuiControl, , Change

    Change := GivenMoney - AllSum
    If GivenMoney is Digit
    {
        GuiControl, , Change, % (Change >= 0) ? Change : 0
    }
Return

AnalyzeAvail:
    GuiControlGet, Bc,, Bc
    GuiControl, , Nm
    GuiControl, , Sum
    GuiControl, , Qn
    If (Bc = "") {
        If (AddEnter) {
            GuiControl, Disabled, AddEnter
        }
        Return
    }
    If (ProdDefs.HasKey("" Bc "")) {
        GuiControl, , Nm, % ProdDefs["" Bc ""]["Name"]
        GuiControl, , Qn, % ProdDefs["" Bc ""]["Quantity"]
        GuiControl, , Sum, % ProdDefs["" Bc ""]["SellPrice"]
    }
    CheckBarcode()
Return

Remise:
    GuiControlGet, Remise, , Remise
    If (Remise > 100) 
        GuiControl, , Remise, % Remise := ""
    CalculateSum()
Return

Client:
    SellDesc:
        CalculateSum()
    Return
Return

AdditionalInfo:
    If (AdditionalInfo := !AdditionalInfo) {
        GuiControl, Enabled, Remise
        GuiControl, Enabled, Client
        GuiControl, Enabled, SellDesc
        GuiControl, ,AdditionalInfoPic, % "Img\MIE.png"
    } Else {
        GuiControl, Disabled, Remise
        GuiControl, Disabled, Client
        GuiControl, Disabled, SellDesc
        GuiControl, ,AdditionalInfoPic, % "Img\MID.png"
    }
    CalculateSum()
Return

ViewLastTrans:
    If (LastestSO) {
        Run, % "GUIDetails" (A_IsCompiled ? ".exe" : ".ahk") " " LastestSO
    }
Return

Session1:
    Session := 1
    Loop, 10 {
        If (A_Index = 1) {
            GuiControl, Disabled, Session%A_Index%
        } Else {
            GuiControl, Enabled, Session%A_Index%
        }
    }

    RestoreSession()
    CalculateSum()
Return

Session2:
    Session := 2
    Loop, 10 {
        If (A_Index = 2) {
            GuiControl, Disabled, Session%A_Index%
        } Else {
            GuiControl, Enabled, Session%A_Index%
        }
    }

    RestoreSession()
    CalculateSum()
Return

Session3:
    Session := 3
    Loop, 10 {
        If (A_Index = 3) {
            GuiControl, Disabled, Session%A_Index%
        } Else {
            GuiControl, Enabled, Session%A_Index%
        }
    }

    RestoreSession()
    CalculateSum()
Return

Session4:
    Session := 4
    Loop, 10 {
        If (A_Index = 4) {
            GuiControl, Disabled, Session%A_Index%
        } Else {
            GuiControl, Enabled, Session%A_Index%
        }
    }

    RestoreSession()
    CalculateSum()
Return

Session5:
    Session := 5
    Loop, 10 {
        If (A_Index = 5) {
            GuiControl, Disabled, Session%A_Index%
        } Else {
            GuiControl, Enabled, Session%A_Index%
        }
    }

    RestoreSession()
    CalculateSum()
Return

Session6:
    Session := 6
    Loop, 10 {
        If (A_Index = 6) {
            GuiControl, Disabled, Session%A_Index%
        } Else {
            GuiControl, Enabled, Session%A_Index%
        }
    }

    RestoreSession()
    CalculateSum()
Return

Session7:
    Session := 7
    Loop, 10 {
        If (A_Index = 7) {
            GuiControl, Disabled, Session%A_Index%
        } Else {
            GuiControl, Enabled, Session%A_Index%
        }
    }

    RestoreSession()
    CalculateSum()
Return

Session8:
    Session := 8
    Loop, 10 {
        If (A_Index = 8) {
            GuiControl, Disabled, Session%A_Index%
        } Else {
            GuiControl, Enabled, Session%A_Index%
        }
    }

    RestoreSession()
    CalculateSum()
Return

Session9:
    Session := 9
    Loop, 10 {
        If (A_Index = 9) {
            GuiControl, Disabled, Session%A_Index%
        } Else {
            GuiControl, Enabled, Session%A_Index%
        }
    }

    RestoreSession()
    CalculateSum()
Return

Session10:
    Session := 10
    Loop, 10 {
        If (A_Index = 10) {
            GuiControl, Disabled, Session%A_Index%
        } Else {
            GuiControl, Enabled, Session%A_Index%
        }
    }

    RestoreSession()
    CalculateSum()
Return