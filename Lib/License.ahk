;///////////////////////////////////////////////
/*
    Admin Registration Check
*/
;///////////////////////////////////////////////
LicenseExists() {
    If FileExist("Sets\License.ch") {
        License := ""

        DBObj     := FileOpen("Sets\License.ch", "r")
        Loop, % DBObj.Length()
            License .= Chr(DBObj.ReadChar())
        DBObj.Close()
        If (License = "CashHelperLicenseExists")
            Return, 1
    }
    Return, 0
}
;///////////////////////////////////////////////