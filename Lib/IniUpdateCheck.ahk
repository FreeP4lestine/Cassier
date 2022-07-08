;//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*
    Update Check
*/
;//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
IniRead, GoCheck, % "Config.ini", % "Config", % "Update"
If (GoCheck = "Yes") {
    If DllCall("Wininet.dll\InternetGetConnectedState", "Str", 0x40, "Int", 0) {
        IniRead, Current, % "Config.ini", % "Config", % "Current"
        SetWorkingDir, Update
        UrlDownloadToFile, % "https://raw.githubusercontent.com/FreeP4lestine/Cassier/main/Version.txt", % "Version.txt"

        If (ErrorLevel) {
            MsgBox, 48, % _13, % _165
            Return
        }

        FileRead, Latest, % "Version.txt"
        Latest := Trim(Latest, "`n")

        If (Latest > Current) {
            MsgBox, 36, % Latest " " _50 , % _51 " " Latest "?"
            IfMsgBox, Yes
            {
                UrlDownloadToFile, % "https://github.com/FreeP4lestine/Cassier/raw/main/Cassier-Update.zip", % "Cassier-Update.zip"
                If (ErrorLevel) {
                    MsgBox, 48, % _13, % _165
                    Return
                }
                Run, Apply.exe
                ExitApp
            }
        } Else {
            MsgBox,,, % _45
        }
        SetWorkingDir, % A_ScriptDir
    }
}
;//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////