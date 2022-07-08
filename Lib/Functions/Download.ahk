DownloadFile(URL, SaveFileAs, Overwrite := 1, UseProgressBar := 1) {
    Global UpdateFile
         , FinalSize
    If (!Overwrite && FileExist(SaveFileAs))
        Return
    If (UseProgressBar) {
        WebRequest := ComObjCreate("WinHttp.WinHttpRequest.5.1")
        WebRequest.Open("HEAD", URL)
        WebRequest.Send()
        FinalSize := WebRequest.GetResponseHeader("Content-Length")
        UpdateFile := FileOpen(SaveFileAs, "r")
        UpdateFile.Length()
        SetTimer, % "UpdateProgressBar", % "1000"
    }

    UrlDownloadToFile, % URL, % SaveFileAs

    If (UseProgressBar) {
        SetTimer, % "UpdateProgressBar", % "Off"
        Progress, % "Off"
    }

    UpdateFile.Close()
    Run, % "Update\Apply.exe"
ExitApp
}