Gui, Add, Button, w200 gSelectPD, 1 - Update PD.db
Gui, Add, Button, w200 gKridi, 2 - Kridis
Gui, Add, Button, w200 gSellDB, 3 - Sell TimeStamp.db
Gui, Show
Return

GuiClose:
ExitApp

SellDB:
    FileSelectFolder, Folder
    If (Folder) {
        Loop, Files, %Folder%\*.db, R
        {
            RD := DB_Read(A_LoopFileFullPath)
            If (RD) {
                SplitPath, % A_LoopFileFullPath,, OutDir,, OutNameNoExt
                FileAppend, % RD, % OutDir "\" OutNameNoExt ".sell"
            }
        }
        Msgbox % "OK"
    }
Return

Kridi:
    FileSelectFolder, Folder
    If (Folder) {
        Folders := []
        Loop, Files, %Folder%\*, D
            Folders.Push(A_LoopFileFullPath)

        For Every, Dir in Folders {
            SplitPath, % Dir, OutFileName, OutDir
            FileMoveDir, % Dir, % OutDir "\" DecodeAlpha(OutFileName)
        }
        Msgbox % "OK"
    }

Return

SelectPD:
    FileSelectFile, File
    If (File) {
        SplitPath, % File,, OutDir

        If !InStr(FileExist(OutDir "\Def"), "D") {
            FileCreateDir, % OutDir "\Def"
        }

        For each, one in StrSplit(DB_Read(File), "|") {
            _one := StrSplit(one, ";")
            If (_one[2] && _one[3] && _one[4])
                FileAppend, % _one[2] ";" _one[3] ";" _one[4] ";" (_one[5] ? _one[5] : 0), % OutDir "\Def\" _one[1] ".def"
        }
        Msgbox % "OK"
    }
Return

DB_Read(FileName, FastMode := 0) {
    DBObj := FileOpen(FileName, "r")
    If !(FastMode) {
        Hedr := ""
        Loop, 14 {
            Hedr .= Chr(DBObj.ReadChar())
        }
        If (Hedr != "CH-26259084-DB")
            Return, 0
        Info := ""
        DBObj.Pos := 1024
        Loop {
            Info .= (ThisChar := Chr(DBObj.ReadChar()))
        } Until (ThisChar = "")
    } Else {
        DBObj.RawRead(Data, Len := DBObj.Length())
        Pos := 1023, Info := ""
        While (Byte := NumGet(Data, Pos += 1, "Char")) {
            Info .= Chr(Byte)
        }
        DBObj.Close()
    }
Return, Decode(Info)
}

Decode(string) {
    if !(DllCall("crypt32\CryptStringToBinary", "ptr", &string, "uint", 0, "uint", 0x1, "ptr", 0, "uint*", size, "ptr", 0, "ptr", 0))
        Return
    VarSetCapacity(buf, size, 0)
    if !(DllCall("crypt32\CryptStringToBinary", "ptr", &string, "uint", 0, "uint", 0x1, "ptr", &buf, "uint*", size, "ptr", 0, "ptr", 0))
        Return
return, StrGet(&buf, size, "UTF-8")
}

DecodeAlpha(Str) {
    DecStr := ""
    Loop, Parse, Str
    {
        If (A_LoopField ~= "[B-Zb-z]") || (A_LoopField ~= "[1-9]")
            DecStr .= Chr(Asc(A_LoopField) - 1)
        Else If (A_LoopField = "A")
            DecStr .= Chr(Asc(A_LoopField) + 25)
        Else If (A_LoopField = "0")
            DecStr .= "9"
        Else
            DecStr .= A_LoopField
    }
Return, DecStr
}

Encode(string) {
    VarSetCapacity(bin, StrPut(string, "UTF-8")) && len := StrPut(string, &bin, "UTF-8") - 1
    if !(DllCall("crypt32\CryptBinaryToString", "ptr", &bin, "uint", len, "uint", 0x1, "ptr", 0, "uint*", size))
        Return
    VarSetCapacity(buf, size << 1, 0)
    if !(DllCall("crypt32\CryptBinaryToString", "ptr", &bin, "uint", len, "uint", 0x1, "ptr", &buf, "uint*", size))
        Return
return, StrGet(&buf)
}

EncodeAlpha(Str) {
    EncStr := ""
    Loop, Parse, Str
    {
        If (A_LoopField ~= "[A-Ya-y]") || (A_LoopField ~= "[0-8]")
            EncStr .= Chr(Asc(A_LoopField) + 1)
        Else If (A_LoopField = "Z")
            EncStr .= Chr(Asc(A_LoopField) - 25)
        Else If (A_LoopField = "9")
            EncStr .= "0"
        Else
            EncStr .= A_LoopField
    }
Return, EncStr
}