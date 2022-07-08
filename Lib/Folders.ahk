;///////////////////////////////////////
/*
    Cash Helper Folders Set
*/
;///////////////////////////////////////
Array := [ "Curr"
         , "Sets"
         , "Valid"
         , "Dump"
         , "Kr"
         , "Unvalid" ]

For Every, Folder in Array {
    If !FolderExist(Folder) {
        FileCreateDir, % Folder
    }
}

FolderExist(Folder) {
    Return InStr(FileExist(Folder), "D")
}
;///////////////////////////////////////