;////////////////////////////////////////////
/*
    Write a license
*/
;////////////////////////////////////////////
WriteLicense() {
    DBObj := FileOpen("Sets\License.ch", "w")
    Loop, Parse, % "CashHelperLicenseExists"
        DBObj.WriteChar(Asc(A_LoopField))
    DBObj.Close()
}
;////////////////////////////////////////////