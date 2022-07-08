CurrentVersion() {
    IniRead, CurrVer, % "Setting.ini", % "Version", % "AppVer"
    Return, CurrVer
}