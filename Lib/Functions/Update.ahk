CheckForUpdates() {
    Global  _49
          , _45
          , _50
          , _51
          , _47
          , _46
          , _106

    UrlDownloadToFile, % "https://raw.githubusercontent.com/FreeP4lestine/Cassier/main/Version.txt", % "Update\LatestVer.txt"
    FileReadLine, Latest, % "Update\LatestVer.txt", 1
    If (!Latest)
        Return, _49

    CurrVer := CurrentVersion()

    If (Latest > CurrVer) {
        MsgBox, 36, % Latest " " _50, % _51 " " Latest "?"
        IfMsgBox, Yes
        {
            Progress, w400 FS10 ZH18, % _47, % _46, % "Cash Helper v" Latest, Calibri
            DownloadFile("https://github.com/FreeP4lestine/Cassier/raw/main/Cassier-Update.zip", "Update\Cassier-Update.zip")
        }
    } Else {
        MsgBox, 64, % _106, % _45
    }
}