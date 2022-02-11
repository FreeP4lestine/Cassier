; <COMPILER: v1.1.33.10>
#NoEnv
#Persistent
#SingleInstance, Force
SendMode Input
SetWorkingDir %A_ScriptDir%
Class CtlColors {
Static Attached := {}
Static HandledMessages := {Edit: 0, ListBox: 0, Static: 0}
Static MessageHandler := "CtlColors_OnMessage"
Static WM_CTLCOLOR := {Edit: 0x0133, ListBox: 0x134, Static: 0x0138}
Static HTML := {AQUA: 0xFFFF00, BLACK: 0x000000, BLUE: 0xFF0000, FUCHSIA: 0xFF00FF, GRAY: 0x808080, GREEN: 0x008000
, LIME: 0x00FF00, MAROON: 0x000080, NAVY: 0x800000, OLIVE: 0x008080, PURPLE: 0x800080, RED: 0x0000FF
, SILVER: 0xC0C0C0, TEAL: 0x808000, WHITE: 0xFFFFFF, YELLOW: 0x00FFFF}
Static NullBrush := DllCall("GetStockObject", "Int", 5, "UPtr")
Static SYSCOLORS := {Edit: "", ListBox: "", Static: ""}
Static ErrorMsg := ""
Static InitClass := CtlColors.ClassInit()
__New() {
If (This.InitClass == "!DONE!") {
This["!Access_Denied!"] := True
Return False
}
}
__Delete() {
If This["!Access_Denied!"]
Return
This.Free()
}
ClassInit() {
CtlColors := New CtlColors
Return "!DONE!"
}
CheckBkColor(ByRef BkColor, Class) {
This.ErrorMsg := ""
If (BkColor != "") && !This.HTML.HasKey(BkColor) && !RegExMatch(BkColor, "^[[:xdigit:]]{6}$") {
This.ErrorMsg := "Invalid parameter BkColor: " . BkColor
Return False
}
BkColor := BkColor = "" ? This.SYSCOLORS[Class]
:  This.HTML.HasKey(BkColor) ? This.HTML[BkColor]
:  "0x" . SubStr(BkColor, 5, 2) . SubStr(BkColor, 3, 2) . SubStr(BkColor, 1, 2)
Return True
}
CheckTxColor(ByRef TxColor) {
This.ErrorMsg := ""
If (TxColor != "") && !This.HTML.HasKey(TxColor) && !RegExMatch(TxColor, "i)^[[:xdigit:]]{6}$") {
This.ErrorMsg := "Invalid parameter TextColor: " . TxColor
Return False
}
TxColor := TxColor = "" ? ""
:  This.HTML.HasKey(TxColor) ? This.HTML[TxColor]
:  "0x" . SubStr(TxColor, 5, 2) . SubStr(TxColor, 3, 2) . SubStr(TxColor, 1, 2)
Return True
}
Attach(HWND, BkColor, TxColor := "") {
Static ClassNames := {Button: "", ComboBox: "", Edit: "", ListBox: "", Static: ""}
Static BS_CHECKBOX := 0x2, BS_RADIOBUTTON := 0x8
Static ES_READONLY := 0x800
Static COLOR_3DFACE := 15, COLOR_WINDOW := 5
If (This.SYSCOLORS.Edit = "") {
This.SYSCOLORS.Static := DllCall("User32.dll\GetSysColor", "Int", COLOR_3DFACE, "UInt")
This.SYSCOLORS.Edit := DllCall("User32.dll\GetSysColor", "Int", COLOR_WINDOW, "UInt")
This.SYSCOLORS.ListBox := This.SYSCOLORS.Edit
}
This.ErrorMsg := ""
If (BkColor = "") && (TxColor = "") {
This.ErrorMsg := "Both parameters BkColor and TxColor are empty!"
Return False
}
If !(CtrlHwnd := HWND + 0) || !DllCall("User32.dll\IsWindow", "UPtr", HWND, "UInt") {
This.ErrorMsg := "Invalid parameter HWND: " . HWND
Return False
}
If This.Attached.HasKey(HWND) {
This.ErrorMsg := "Control " . HWND . " is already registered!"
Return False
}
Hwnds := [CtrlHwnd]
Classes := ""
WinGetClass, CtrlClass, ahk_id %CtrlHwnd%
This.ErrorMsg := "Unsupported control class: " . CtrlClass
If !ClassNames.HasKey(CtrlClass)
Return False
ControlGet, CtrlStyle, Style, , , ahk_id %CtrlHwnd%
If (CtrlClass = "Edit")
Classes := ["Edit", "Static"]
Else If (CtrlClass = "Button") {
IF (CtrlStyle & BS_RADIOBUTTON) || (CtrlStyle & BS_CHECKBOX)
Classes := ["Static"]
Else
Return False
}
Else If (CtrlClass = "ComboBox") {
VarSetCapacity(CBBI, 40 + (A_PtrSize * 3), 0)
NumPut(40 + (A_PtrSize * 3), CBBI, 0, "UInt")
DllCall("User32.dll\GetComboBoxInfo", "Ptr", CtrlHwnd, "Ptr", &CBBI)
Hwnds.Insert(NumGet(CBBI, 40 + (A_PtrSize * 2, "UPtr")) + 0)
Hwnds.Insert(Numget(CBBI, 40 + A_PtrSize, "UPtr") + 0)
Classes := ["Edit", "Static", "ListBox"]
}
If !IsObject(Classes)
Classes := [CtrlClass]
If (BkColor <> "Trans")
If !This.CheckBkColor(BkColor, Classes[1])
Return False
If !This.CheckTxColor(TxColor)
Return False
For I, V In Classes {
If (This.HandledMessages[V] = 0)
OnMessage(This.WM_CTLCOLOR[V], This.MessageHandler)
This.HandledMessages[V] += 1
}
If (BkColor = "Trans")
Brush := This.NullBrush
Else
Brush := DllCall("Gdi32.dll\CreateSolidBrush", "UInt", BkColor, "UPtr")
For I, V In Hwnds
This.Attached[V] := {Brush: Brush, TxColor: TxColor, BkColor: BkColor, Classes: Classes, Hwnds: Hwnds}
DllCall("User32.dll\InvalidateRect", "Ptr", HWND, "Ptr", 0, "Int", 1)
This.ErrorMsg := ""
Return True
}
Change(HWND, BkColor, TxColor := "") {
This.ErrorMsg := ""
HWND += 0
If !This.Attached.HasKey(HWND)
Return This.Attach(HWND, BkColor, TxColor)
CTL := This.Attached[HWND]
If (BkColor <> "Trans")
If !This.CheckBkColor(BkColor, CTL.Classes[1])
Return False
If !This.CheckTxColor(TxColor)
Return False
If (BkColor <> CTL.BkColor) {
If (CTL.Brush) {
If (Ctl.Brush <> This.NullBrush)
DllCall("Gdi32.dll\DeleteObject", "Prt", CTL.Brush)
This.Attached[HWND].Brush := 0
}
If (BkColor = "Trans")
Brush := This.NullBrush
Else
Brush := DllCall("Gdi32.dll\CreateSolidBrush", "UInt", BkColor, "UPtr")
For I, V In CTL.Hwnds {
This.Attached[V].Brush := Brush
This.Attached[V].BkColor := BkColor
}
}
For I, V In Ctl.Hwnds
This.Attached[V].TxColor := TxColor
This.ErrorMsg := ""
DllCall("User32.dll\InvalidateRect", "Ptr", HWND, "Ptr", 0, "Int", 1)
Return True
}
Detach(HWND) {
This.ErrorMsg := ""
HWND += 0
If This.Attached.HasKey(HWND) {
CTL := This.Attached[HWND].Clone()
If (CTL.Brush) && (CTL.Brush <> This.NullBrush)
DllCall("Gdi32.dll\DeleteObject", "Prt", CTL.Brush)
For I, V In CTL.Classes {
If This.HandledMessages[V] > 0 {
This.HandledMessages[V] -= 1
If This.HandledMessages[V] = 0
OnMessage(This.WM_CTLCOLOR[V], "")
}  }
For I, V In CTL.Hwnds
This.Attached.Remove(V, "")
DllCall("User32.dll\InvalidateRect", "Ptr", HWND, "Ptr", 0, "Int", 1)
CTL := ""
Return True
}
This.ErrorMsg := "Control " . HWND . " is not registered!"
Return False
}
Free() {
For K, V In This.Attached
If (V.Brush) && (V.Brush <> This.NullBrush)
DllCall("Gdi32.dll\DeleteObject", "Ptr", V.Brush)
For K, V In This.HandledMessages
If (V > 0) {
OnMessage(This.WM_CTLCOLOR[K], "")
This.HandledMessages[K] := 0
}
This.Attached := {}
Return True
}
IsAttached(HWND) {
Return This.Attached.HasKey(HWND)
}
}
CtlColors_OnMessage(HDC, HWND) {
Critical
If CtlColors.IsAttached(HWND) {
CTL := CtlColors.Attached[HWND]
If (CTL.TxColor != "")
DllCall("Gdi32.dll\SetTextColor", "Ptr", HDC, "UInt", CTL.TxColor)
If (CTL.BkColor = "Trans")
DllCall("Gdi32.dll\SetBkMode", "Ptr", HDC, "UInt", 1)
Else
DllCall("Gdi32.dll\SetBkColor", "Ptr", HDC, "UInt", CTL.BkColor)
Return CTL.Brush
}
}
Class ImageButton {
Static DefGuiColor  := ""
Static DefTxtColor := "Black"
Static LastError := ""
Static BitMaps := []
Static GDIPDll := 0
Static GDIPToken := 0
Static MaxOptions := 8
Static HTML := {BLACK: 0x000000, GRAY: 0x808080, SILVER: 0xC0C0C0, WHITE: 0xFFFFFF, MAROON: 0x800000
, PURPLE: 0x800080, FUCHSIA: 0xFF00FF, RED: 0xFF0000, GREEN: 0x008000, OLIVE: 0x808000
, YELLOW: 0xFFFF00, LIME: 0x00FF00, NAVY: 0x000080, TEAL: 0x008080, AQUA: 0x00FFFF, BLUE: 0x0000FF}
Static ClassInit := ImageButton.InitClass()
__New(P*) {
Return False
}
InitClass() {
GuiColor := DllCall("User32.dll\GetSysColor", "Int", 15, "UInt")
This.DefGuiColor := ((GuiColor >> 16) & 0xFF) | (GuiColor & 0x00FF00) | ((GuiColor & 0xFF) << 16)
Return True
}
BitmapOrIcon(O2, O3) {
Return (This.IsInt(O2) && (O3 = "HICON")) || (DllCall("GetObjectType", "Ptr", O2, "UInt") = 7) || FileExist(O2)
}
FreeBitmaps() {
For I, HBITMAP In This.BitMaps
DllCall("Gdi32.dll\DeleteObject", "Ptr", HBITMAP)
This.BitMaps := []
}
GetARGB(RGB) {
ARGB := This.HTML.HasKey(RGB) ? This.HTML[RGB] : RGB
Return (ARGB & 0xFF000000) = 0 ? 0xFF000000 | ARGB : ARGB
}
IsInt(Val) {
If Val Is Integer
Return True
Return False
}
PathAddRectangle(Path, X, Y, W, H) {
Return DllCall("Gdiplus.dll\GdipAddPathRectangle", "Ptr", Path, "Float", X, "Float", Y, "Float", W, "Float", H)
}
PathAddRoundedRect(Path, X1, Y1, X2, Y2, R) {
D := (R * 2), X2 -= D, Y2 -= D
DllCall("Gdiplus.dll\GdipAddPathArc"
, "Ptr", Path, "Float", X1, "Float", Y1, "Float", D, "Float", D, "Float", 180, "Float", 90)
DllCall("Gdiplus.dll\GdipAddPathArc"
, "Ptr", Path, "Float", X2, "Float", Y1, "Float", D, "Float", D, "Float", 270, "Float", 90)
DllCall("Gdiplus.dll\GdipAddPathArc"
, "Ptr", Path, "Float", X2, "Float", Y2, "Float", D, "Float", D, "Float", 0, "Float", 90)
DllCall("Gdiplus.dll\GdipAddPathArc"
, "Ptr", Path, "Float", X1, "Float", Y2, "Float", D, "Float", D, "Float", 90, "Float", 90)
Return DllCall("Gdiplus.dll\GdipClosePathFigure", "Ptr", Path)
}
SetRect(ByRef Rect, X1, Y1, X2, Y2) {
VarSetCapacity(Rect, 16, 0)
NumPut(X1, Rect, 0, "Int"), NumPut(Y1, Rect, 4, "Int")
NumPut(X2, Rect, 8, "Int"), NumPut(Y2, Rect, 12, "Int")
Return True
}
SetRectF(ByRef Rect, X, Y, W, H) {
VarSetCapacity(Rect, 16, 0)
NumPut(X, Rect, 0, "Float"), NumPut(Y, Rect, 4, "Float")
NumPut(W, Rect, 8, "Float"), NumPut(H, Rect, 12, "Float")
Return True
}
SetError(Msg) {
If (This.Bitmap)
DllCall("Gdiplus.dll\GdipDisposeImage", "Ptr", This.Bitmap)
If (This.Graphics)
DllCall("Gdiplus.dll\GdipDeleteGraphics", "Ptr", This.Graphics)
If (This.Font)
DllCall("Gdiplus.dll\GdipDeleteFont", "Ptr", This.Font)
This.Delete("Bitmap")
This.Delete("Graphics")
This.Delete("Font")
This.FreeBitmaps()
This.LastError := Msg
Return False
}
Create(HWND, Options*) {
Static BCM_GETIMAGELIST := 0x1603, BCM_SETIMAGELIST := 0x1602
, BS_CHECKBOX := 0x02, BS_RADIOBUTTON := 0x04, BS_GROUPBOX := 0x07, BS_AUTORADIOBUTTON := 0x09
, BS_LEFT := 0x0100, BS_RIGHT := 0x0200, BS_CENTER := 0x0300, BS_TOP := 0x0400, BS_BOTTOM := 0x0800
, BS_VCENTER := 0x0C00, BS_BITMAP := 0x0080
, BUTTON_IMAGELIST_ALIGN_LEFT := 0, BUTTON_IMAGELIST_ALIGN_RIGHT := 1, BUTTON_IMAGELIST_ALIGN_CENTER := 4
, ILC_COLOR32 := 0x20
, OBJ_BITMAP := 7
, RCBUTTONS := BS_CHECKBOX | BS_RADIOBUTTON | BS_AUTORADIOBUTTON
, SA_LEFT := 0x00, SA_CENTER := 0x01, SA_RIGHT := 0x02
, WM_GETFONT := 0x31
This.LastError := ""
HBITMAP := HFORMAT := PBITMAP := PBRUSH := PFONT := PPATH := 0
If !DllCall("User32.dll\IsWindow", "Ptr", HWND)
Return This.SetError("Invalid parameter HWND!")
If !(IsObject(Options)) || (Options.MinIndex() <> 1) || (Options.MaxIndex() > This.MaxOptions)
Return This.SetError("Invalid parameter Options!")
WinGetClass, BtnClass, ahk_id %HWND%
ControlGet, BtnStyle, Style, , , ahk_id %HWND%
If (BtnClass != "Button") || ((BtnStyle & 0xF ^ BS_GROUPBOX) = 0) || ((BtnStyle & RCBUTTONS) > 1)
Return This.SetError("The control must be a pushbutton!")
HFONT := DllCall("User32.dll\SendMessage", "Ptr", HWND, "UInt", WM_GETFONT, "Ptr", 0, "Ptr", 0, "Ptr")
DC := DllCall("User32.dll\GetDC", "Ptr", HWND, "Ptr")
DllCall("Gdi32.dll\SelectObject", "Ptr", DC, "Ptr", HFONT)
DllCall("Gdiplus.dll\GdipCreateFontFromDC", "Ptr", DC, "PtrP", PFONT)
DllCall("User32.dll\ReleaseDC", "Ptr", HWND, "Ptr", DC)
If !(This.Font := PFONT)
Return This.SetError("Couldn't get button's font!")
VarSetCapacity(RECT, 16, 0)
If !DllCall("User32.dll\GetWindowRect", "Ptr", HWND, "Ptr", &RECT)
Return This.SetError("Couldn't get button's rectangle!")
BtnW := NumGet(RECT,  8, "Int") - NumGet(RECT, 0, "Int")
BtnH := NumGet(RECT, 12, "Int") - NumGet(RECT, 4, "Int")
ControlGetText, BtnCaption, , ahk_id %HWND%
If (ErrorLevel)
Return This.SetError("Couldn't get button's caption!")
DllCall("Gdiplus.dll\GdipCreateBitmapFromScan0", "Int", BtnW, "Int", BtnH, "Int", 0
, "UInt", 0x26200A, "Ptr", 0, "PtrP", PBITMAP)
If !(This.Bitmap := PBITMAP)
Return This.SetError("Couldn't create the GDI+ bitmap!")
PGRAPHICS := 0
DllCall("Gdiplus.dll\GdipGetImageGraphicsContext", "Ptr", PBITMAP, "PtrP", PGRAPHICS)
If !(This.Graphics := PGRAPHICS)
Return This.SetError("Couldn't get the the GDI+ bitmap's graphics!")
DllCall("Gdiplus.dll\GdipSetSmoothingMode", "Ptr", PGRAPHICS, "UInt", 4)
DllCall("Gdiplus.dll\GdipSetInterpolationMode", "Ptr", PGRAPHICS, "Int", 7)
DllCall("Gdiplus.dll\GdipSetCompositingQuality", "Ptr", PGRAPHICS, "UInt", 4)
DllCall("Gdiplus.dll\GdipSetRenderingOrigin", "Ptr", PGRAPHICS, "Int", 0, "Int", 0)
DllCall("Gdiplus.dll\GdipSetPixelOffsetMode", "Ptr", PGRAPHICS, "UInt", 4)
This.BitMaps := []
For Idx, Opt In Options {
If !IsObject(Opt)
Continue
BkgColor1 := BkgColor2 := TxtColor := Mode := Rounded := GuiColor := Image := ""
Loop, % This.MaxOptions {
If (Opt[A_Index] = "")
Opt[A_Index] := Options[1, A_Index]
}
Mode := SubStr(Opt[1], 1 ,1)
If !InStr("0123456789", Mode)
Return This.SetError("Invalid value for Mode in Options[" . Idx . "]!")
If (Mode = 0) && This.BitmapOrIcon(Opt[2], Opt[3])
Image := Opt[2]
Else {
If !This.IsInt(Opt[2]) && !This.HTML.HasKey(Opt[2])
Return This.SetError("Invalid value for StartColor in Options[" . Idx . "]!")
BkgColor1 := This.GetARGB(Opt[2])
If (Opt[3] = "")
Opt[3] := Opt[2]
If !This.IsInt(Opt[3]) && !This.HTML.HasKey(Opt[3])
Return This.SetError("Invalid value for TargetColor in Options[" . Idx . "]!")
BkgColor2 := This.GetARGB(Opt[3])
}
If (Opt[4] = "")
Opt[4] := This.DefTxtColor
If !This.IsInt(Opt[4]) && !This.HTML.HasKey(Opt[4])
Return This.SetError("Invalid value for TxtColor in Options[" . Idx . "]!")
TxtColor := This.GetARGB(Opt[4])
Rounded := Opt[5]
If (Rounded = "H")
Rounded := BtnH * 0.5
If (Rounded = "W")
Rounded := BtnW * 0.5
If ((Rounded + 0) = "")
Rounded := 0
If (Opt[6] = "")
Opt[6] := This.DefGuiColor
If !This.IsInt(Opt[6]) && !This.HTML.HasKey(Opt[6])
Return This.SetError("Invalid value for GuiColor in Options[" . Idx . "]!")
GuiColor := This.GetARGB(Opt[6])
BorderColor := ""
If (Opt[7] <> "") {
If !This.IsInt(Opt[7]) && !This.HTML.HasKey(Opt[7])
Return This.SetError("Invalid value for BorderColor in Options[" . Idx . "]!")
BorderColor := 0xFF000000 | This.GetARGB(Opt[7])
}
BorderWidth := Opt[8] ? Opt[8] : 1
DllCall("Gdiplus.dll\GdipGraphicsClear", "Ptr", PGRAPHICS, "UInt", GuiColor)
If (Image = "") {
PathX := PathY := 0, PathW := BtnW, PathH := BtnH
DllCall("Gdiplus.dll\GdipCreatePath", "UInt", 0, "PtrP", PPATH)
If (Rounded < 1)
This.PathAddRectangle(PPATH, PathX, PathY, PathW, PathH)
Else
This.PathAddRoundedRect(PPATH, PathX, PathY, PathW, PathH, Rounded)
If (BorderColor <> "") && (BorderWidth > 0) && (Mode <> 7) {
DllCall("Gdiplus.dll\GdipCreateSolidFill", "UInt", BorderColor, "PtrP", PBRUSH)
DllCall("Gdiplus.dll\GdipFillPath", "Ptr", PGRAPHICS, "Ptr", PBRUSH, "Ptr", PPATH)
DllCall("Gdiplus.dll\GdipDeleteBrush", "Ptr", PBRUSH)
DllCall("Gdiplus.dll\GdipResetPath", "Ptr", PPATH)
PathX := PathY := BorderWidth, PathW -= BorderWidth, PathH -= BorderWidth, Rounded -= BorderWidth
If (Rounded < 1)
This.PathAddRectangle(PPATH, PathX, PathY, PathW - PathX, PathH - PathY)
Else
This.PathAddRoundedRect(PPATH, PathX, PathY, PathW, PathH, Rounded)
BkgColor1 := 0xFF000000 | BkgColor1
BkgColor2 := 0xFF000000 | BkgColor2
}
PathW -= PathX
PathH -= PathY
PBRUSH := 0
If (Mode = 0) {
DllCall("Gdiplus.dll\GdipCreateSolidFill", "UInt", BkgColor1, "PtrP", PBRUSH)
DllCall("Gdiplus.dll\GdipFillPath", "Ptr", PGRAPHICS, "Ptr", PBRUSH, "Ptr", PPATH)
}
Else If (Mode = 1) || (Mode = 2) {
This.SetRectF(RECTF, PathX, PathY, PathW, PathH)
DllCall("Gdiplus.dll\GdipCreateLineBrushFromRect", "Ptr", &RECTF
, "UInt", BkgColor1, "UInt", BkgColor2, "Int", Mode & 1, "Int", 3, "PtrP", PBRUSH)
DllCall("Gdiplus.dll\GdipSetLineGammaCorrection", "Ptr", PBRUSH, "Int", 1)
This.SetRect(COLORS, BkgColor1, BkgColor1, BkgColor2, BkgColor2)
This.SetRectF(POSITIONS, 0, 0.5, 0.5, 1)
DllCall("Gdiplus.dll\GdipSetLinePresetBlend", "Ptr", PBRUSH
, "Ptr", &COLORS, "Ptr", &POSITIONS, "Int", 4)
DllCall("Gdiplus.dll\GdipFillPath", "Ptr", PGRAPHICS, "Ptr", PBRUSH, "Ptr", PPATH)
}
Else If (Mode >= 3) && (Mode <= 6) {
W := Mode = 6 ? PathW / 2 : PathW
H := Mode = 5 ? PathH / 2 : PathH
This.SetRectF(RECTF, PathX, PathY, W, H)
DllCall("Gdiplus.dll\GdipCreateLineBrushFromRect", "Ptr", &RECTF
, "UInt", BkgColor1, "UInt", BkgColor2, "Int", Mode & 1, "Int", 3, "PtrP", PBRUSH)
DllCall("Gdiplus.dll\GdipSetLineGammaCorrection", "Ptr", PBRUSH, "Int", 1)
DllCall("Gdiplus.dll\GdipFillPath", "Ptr", PGRAPHICS, "Ptr", PBRUSH, "Ptr", PPATH)
}
Else {
DllCall("Gdiplus.dll\GdipCreatePathGradientFromPath", "Ptr", PPATH, "PtrP", PBRUSH)
DllCall("Gdiplus.dll\GdipSetPathGradientGammaCorrection", "Ptr", PBRUSH, "UInt", 1)
VarSetCapacity(ColorArray, 4, 0)
NumPut(BkgColor1, ColorArray, 0, "UInt")
DllCall("Gdiplus.dll\GdipSetPathGradientSurroundColorsWithCount", "Ptr", PBRUSH, "Ptr", &ColorArray
, "IntP", 1)
DllCall("Gdiplus.dll\GdipSetPathGradientCenterColor", "Ptr", PBRUSH, "UInt", BkgColor2)
FS := (BtnH < BtnW ? BtnH : BtnW) / 3
XScale := (BtnW - FS) / BtnW
YScale := (BtnH - FS) / BtnH
DllCall("Gdiplus.dll\GdipSetPathGradientFocusScales", "Ptr", PBRUSH, "Float", XScale, "Float", YScale)
DllCall("Gdiplus.dll\GdipFillPath", "Ptr", PGRAPHICS, "Ptr", PBRUSH, "Ptr", PPATH)
}
DllCall("Gdiplus.dll\GdipDeleteBrush", "Ptr", PBRUSH)
DllCall("Gdiplus.dll\GdipDeletePath", "Ptr", PPATH)
} Else {
If This.IsInt(Image)
If (Opt[3] = "HICON")
DllCall("Gdiplus.dll\GdipCreateBitmapFromHICON", "Ptr", Image, "PtrP", PBM)
Else
DllCall("Gdiplus.dll\GdipCreateBitmapFromHBITMAP", "Ptr", Image, "Ptr", 0, "PtrP", PBM)
Else
DllCall("Gdiplus.dll\GdipCreateBitmapFromFile", "WStr", Image, "PtrP", PBM)
DllCall("Gdiplus.dll\GdipDrawImageRectI", "Ptr", PGRAPHICS, "Ptr", PBM, "Int", 0, "Int", 0
, "Int", BtnW, "Int", BtnH)
DllCall("Gdiplus.dll\GdipDisposeImage", "Ptr", PBM)
}
If (BtnCaption <> "") {
DllCall("Gdiplus.dll\GdipStringFormatGetGenericTypographic", "PtrP", HFORMAT)
DllCall("Gdiplus.dll\GdipCreateSolidFill", "UInt", TxtColor, "PtrP", PBRUSH)
HALIGN := (BtnStyle & BS_CENTER) = BS_CENTER ? SA_CENTER
: (BtnStyle & BS_CENTER) = BS_RIGHT  ? SA_RIGHT
: (BtnStyle & BS_CENTER) = BS_Left   ? SA_LEFT
: SA_CENTER
DllCall("Gdiplus.dll\GdipSetStringFormatAlign", "Ptr", HFORMAT, "Int", HALIGN)
VALIGN := (BtnStyle & BS_VCENTER) = BS_TOP ? 0
: (BtnStyle & BS_VCENTER) = BS_BOTTOM ? 2
: 1
DllCall("Gdiplus.dll\GdipSetStringFormatLineAlign", "Ptr", HFORMAT, "Int", VALIGN)
DllCall("Gdiplus.dll\GdipSetTextRenderingHint", "Ptr", PGRAPHICS, "Int", 0)
VarSetCapacity(RECT, 16, 0)
NumPut(BtnW, RECT,  8, "Float")
NumPut(BtnH, RECT, 12, "Float")
DllCall("Gdiplus.dll\GdipDrawString", "Ptr", PGRAPHICS, "WStr", BtnCaption, "Int", -1
, "Ptr", PFONT, "Ptr", &RECT, "Ptr", HFORMAT, "Ptr", PBRUSH)
}
DllCall("Gdiplus.dll\GdipCreateHBITMAPFromBitmap", "Ptr", PBITMAP, "PtrP", HBITMAP, "UInt", 0X00FFFFFF)
This.BitMaps[Idx] := HBITMAP
DllCall("Gdiplus.dll\GdipDeleteBrush", "Ptr", PBRUSH)
DllCall("Gdiplus.dll\GdipDeleteStringFormat", "Ptr", HFORMAT)
}
DllCall("Gdiplus.dll\GdipDisposeImage", "Ptr", PBITMAP)
DllCall("Gdiplus.dll\GdipDeleteGraphics", "Ptr", PGRAPHICS)
DllCall("Gdiplus.dll\GdipDeleteFont", "Ptr", PFONT)
This.Delete("Bitmap")
This.Delete("Graphics")
This.Delete("Font")
HIL := DllCall("Comctl32.dll\ImageList_Create"
, "UInt", BtnW, "UInt", BtnH, "UInt", ILC_COLOR32, "Int", 6, "Int", 0, "Ptr")
Loop, % (This.BitMaps.MaxIndex() > 1 ? 6 : 1) {
HBITMAP := This.BitMaps.HasKey(A_Index) ? This.BitMaps[A_Index] : This.BitMaps.1
DllCall("Comctl32.dll\ImageList_Add", "Ptr", HIL, "Ptr", HBITMAP, "Ptr", 0)
}
VarSetCapacity(BIL, 20 + A_PtrSize, 0)
DllCall("User32.dll\SendMessage", "Ptr", HWND, "UInt", BCM_GETIMAGELIST, "Ptr", 0, "Ptr", &BIL)
IL := NumGet(BIL, "UPtr")
VarSetCapacity(BIL, 20 + A_PtrSize, 0)
NumPut(HIL, BIL, 0, "Ptr")
Numput(BUTTON_IMAGELIST_ALIGN_CENTER, BIL, A_PtrSize + 16, "UInt")
ControlSetText, , , ahk_id %HWND%
Control, Style, +%BS_BITMAP%, , ahk_id %HWND%
If(IL)
IL_Destroy(IL)
DllCall("User32.dll\SendMessage", "Ptr", HWND, "UInt", BCM_SETIMAGELIST, "Ptr", 0, "Ptr", 0)
DllCall("User32.dll\SendMessage", "Ptr", HWND, "UInt", BCM_SETIMAGELIST, "Ptr", 0, "Ptr", &BIL)
This.FreeBitmaps()
Return True
}
SetGuiColor(GuiColor) {
If !(GuiColor + 0) && !This.HTML.HasKey(GuiColor)
Return False
This.DefGuiColor := (This.HTML.HasKey(GuiColor) ? This.HTML[GuiColor] : GuiColor) & 0xFFFFFF
Return True
}
SetTxtColor(TxtColor) {
If !(TxtColor + 0) && !This.HTML.HasKey(TxtColor)
Return False
This.DefTxtColor := (This.HTML.HasKey(TxtColor) ? This.HTML[TxtColor] : TxtColor) & 0xFFFFFF
Return True
}
}
UseGDIP(Params*) {
Static GdipObject := ""
, GdipModule := ""
, GdipToken  := ""
Static OnLoad := UseGDIP()
If (GdipModule = "") {
If !DllCall("LoadLibrary", "Str", "Gdiplus.dll", "UPtr")
UseGDIP_Error("The Gdiplus.dll could not be loaded!`n`nThe program will exit!")
If !DllCall("GetModuleHandleEx", "UInt", 0x00000001, "Str", "Gdiplus.dll", "PtrP", GdipModule, "UInt")
UseGDIP_Error("The Gdiplus.dll could not be loaded!`n`nThe program will exit!")
VarSetCapacity(SI, 24, 0), NumPut(1, SI, 0, "UInt")
If DllCall("Gdiplus.dll\GdiplusStartup", "PtrP", GdipToken, "Ptr", &SI, "Ptr", 0)
UseGDIP_Error("GDI+ could not be startet!`n`nThe program will exit!")
GdipObject := {Base: {__Delete: Func("UseGDIP").Bind(GdipModule, GdipToken)}}
}
Else If (Params[1] = GdipModule) && (Params[2] = GdipToken)
DllCall("Gdiplus.dll\GdiplusShutdown", "Ptr", GdipToken)
}
UseGDIP_Error(ErrorMsg) {
MsgBox, 262160, UseGDIP, %ErrorMsg%
ExitApp
}
Class LV_Colors {
__New(HWND, StaticMode := False, NoSort := True, NoSizing := True) {
If (This.Base.Base.__Class)
Return False
If This.Attached[HWND]
Return False
If !DllCall("IsWindow", "Ptr", HWND)
Return False
VarSetCapacity(Class, 512, 0)
DllCall("GetClassName", "Ptr", HWND, "Str", Class, "Int", 256)
If (Class <> "SysListView32")
Return False
SendMessage, 0x1036, 0x010000, 0x010000, , % "ahk_id " . HWND
SendMessage, 0x1025, 0, 0, , % "ahk_id " . HWND
This.BkClr := ErrorLevel
SendMessage, 0x1023, 0, 0, , % "ahk_id " . HWND
This.TxClr := ErrorLevel
SendMessage, 0x101F, 0, 0, , % "ahk_id " . HWND
This.Header := ErrorLevel
This.HWND := HWND
This.IsStatic := !!StaticMode
This.AltCols := False
This.AltRows := False
This.NoSort(!!NoSort)
This.NoSizing(!!NoSizing)
This.OnMessage()
This.Critical := "Off"
This.Attached[HWND] := True
}
__Delete() {
This.Attached.Remove(HWND, "")
This.OnMessage(False)
WinSet, Redraw, , % "ahk_id " . This.HWND
}
Clear(AltRows := False, AltCols := False) {
If (AltCols)
This.AltCols := False
If (AltRows)
This.AltRows := False
This.Remove("Rows")
This.Remove("Cells")
Return True
}
AlternateRows(BkColor := "", TxColor := "") {
If !(This.HWND)
Return False
This.AltRows := False
If (BkColor = "") && (TxColor = "")
Return True
BkBGR := This.BGR(BkColor)
TxBGR := This.BGR(TxColor)
If (BkBGR = "") && (TxBGR = "")
Return False
This["ARB"] := (BkBGR <> "") ? BkBGR : This.BkClr
This["ART"] := (TxBGR <> "") ? TxBGR : This.TxClr
This.AltRows := True
Return True
}
AlternateCols(BkColor := "", TxColor := "") {
If !(This.HWND)
Return False
This.AltCols := False
If (BkColor = "") && (TxColor = "")
Return True
BkBGR := This.BGR(BkColor)
TxBGR := This.BGR(TxColor)
If (BkBGR = "") && (TxBGR = "")
Return False
This["ACB"] := (BkBGR <> "") ? BkBGR : This.BkClr
This["ACT"] := (TxBGR <> "") ? TxBGR : This.TxClr
This.AltCols := True
Return True
}
SelectionColors(BkColor := "", TxColor := "") {
If !(This.HWND)
Return False
This.SelColors := False
If (BkColor = "") && (TxColor = "")
Return True
BkBGR := This.BGR(BkColor)
TxBGR := This.BGR(TxColor)
If (BkBGR = "") && (TxBGR = "")
Return False
This["SELB"] := BkBGR
This["SELT"] := TxBGR
This.SelColors := True
Return True
}
Row(Row, BkColor := "", TxColor := "") {
If !(This.HWND)
Return False
If This.IsStatic
Row := This.MapIndexToID(Row)
This["Rows"].Remove(Row, "")
If (BkColor = "") && (TxColor = "")
Return True
BkBGR := This.BGR(BkColor)
TxBGR := This.BGR(TxColor)
If (BkBGR = "") && (TxBGR = "")
Return False
This["Rows", Row, "B"] := (BkBGR <> "") ? BkBGR : This.BkClr
This["Rows", Row, "T"] := (TxBGR <> "") ? TxBGR : This.TxClr
Return True
}
Cell(Row, Col, BkColor := "", TxColor := "") {
If !(This.HWND)
Return False
If This.IsStatic
Row := This.MapIndexToID(Row)
This["Cells", Row].Remove(Col, "")
If (BkColor = "") && (TxColor = "")
Return True
BkBGR := This.BGR(BkColor)
TxBGR := This.BGR(TxColor)
If (BkBGR = "") && (TxBGR = "")
Return False
If (BkBGR <> "")
This["Cells", Row, Col, "B"] := BkBGR
If (TxBGR <> "")
This["Cells", Row, Col, "T"] := TxBGR
Return True
}
NoSort(Apply := True) {
If !(This.HWND)
Return False
If (Apply)
This.SortColumns := False
Else
This.SortColumns := True
Return True
}
NoSizing(Apply := True) {
Static OSVersion := DllCall("GetVersion", "UChar")
If !(This.Header)
Return False
If (Apply) {
If (OSVersion > 5)
Control, Style, +0x0800, , % "ahk_id " . This.Header
This.ResizeColumns := False
}
Else {
If (OSVersion > 5)
Control, Style, -0x0800, , % "ahk_id " . This.Header
This.ResizeColumns := True
}
Return True
}
OnMessage(Apply := True) {
If (Apply) && !This.HasKey("OnMessageFunc") {
This.OnMessageFunc := ObjBindMethod(This, "On_WM_Notify")
OnMessage(0x004E, This.OnMessageFunc)
}
Else If !(Apply) && This.HasKey("OnMessageFunc") {
OnMessage(0x004E, This.OnMessageFunc, 0)
This.OnMessageFunc := ""
This.Remove("OnMessageFunc")
}
WinSet, Redraw, , % "ahk_id " . This.HWND
Return True
}
Static Attached := {}
On_WM_NOTIFY(W, L, M, H) {
Critical, % This.Critical
If ((HCTL := NumGet(L + 0, 0, "UPtr")) = This.HWND) || (HCTL = This.Header) {
Code := NumGet(L + (A_PtrSize * 2), 0, "Int")
If (Code = -12)
Return This.NM_CUSTOMDRAW(This.HWND, L)
If !This.SortColumns && (Code = -108)
Return 0
If !This.ResizeColumns && ((Code = -306) || (Code = -326))
Return True
}
}
NM_CUSTOMDRAW(H, L) {
Static SizeNMHDR := A_PtrSize * 3
Static SizeNCD := SizeNMHDR + 16 + (A_PtrSize * 5)
Static OffItem := SizeNMHDR + 16 + (A_PtrSize * 2)
Static OffItemState := OffItem + A_PtrSize
Static OffCT :=  SizeNCD
Static OffCB := OffCT + 4
Static OffSubItem := OffCB + 4
DrawStage := NumGet(L + SizeNMHDR, 0, "UInt")
, Row := NumGet(L + OffItem, "UPtr") + 1
, Col := NumGet(L + OffSubItem, "Int") + 1
, Item := Row - 1
If This.IsStatic
Row := This.MapIndexToID(Row)
If (DrawStage = 0x030001) {
UseAltCol := !(Col & 1) && (This.AltCols)
, ColColors := This["Cells", Row, Col]
, ColB := (ColColors.B <> "") ? ColColors.B : UseAltCol ? This.ACB : This.RowB
, ColT := (ColColors.T <> "") ? ColColors.T : UseAltCol ? This.ACT : This.RowT
, NumPut(ColT, L + OffCT, "UInt"), NumPut(ColB, L + OffCB, "UInt")
Return (!This.AltCols && !This.HasKey(Row) && (Col > This["Cells", Row].MaxIndex())) ? 0x00 : 0x20
}
If (DrawStage = 0x010001) {
If (This.SelColors) && DllCall("SendMessage", "Ptr", H, "UInt", 0x102C, "Ptr", Item, "Ptr", 0x0002, "UInt") {
NumPut(NumGet(L + OffItemState, "UInt") & ~0x0011, L + OffItemState, "UInt")
If (This.SELB <> "")
NumPut(This.SELB, L + OffCB, "UInt")
If (This.SELT <> "")
NumPut(This.SELT, L + OffCT, "UInt")
Return 0x02
}
UseAltRow := (Item & 1) && (This.AltRows)
, RowColors := This["Rows", Row]
, This.RowB := RowColors ? RowColors.B : UseAltRow ? This.ARB : This.BkClr
, This.RowT := RowColors ? RowColors.T : UseAltRow ? This.ART : This.TxClr
If (This.AltCols || This["Cells"].HasKey(Row))
Return 0x20
NumPut(This.RowT, L + OffCT, "UInt"), NumPut(This.RowB, L + OffCB, "UInt")
Return 0x00
}
Return (DrawStage = 0x000001) ? 0x20 : 0x00
}
MapIndexToID(Row) {
SendMessage, 0x10B4, % (Row - 1), 0, , % "ahk_id " . This.HWND
Return ErrorLevel
}
BGR(Color, Default := "") {
Static Integer := "Integer"
Static HTML := {AQUA: 0xFFFF00, BLACK: 0x000000, BLUE: 0xFF0000, FUCHSIA: 0xFF00FF, GRAY: 0x808080, GREEN: 0x008000
, LIME: 0x00FF00, MAROON: 0x000080, NAVY: 0x800000, OLIVE: 0x008080, PURPLE: 0x800080, RED: 0x0000FF
, SILVER: 0xC0C0C0, TEAL: 0x808000, WHITE: 0xFFFFFF, YELLOW: 0x00FFFF}
If Color Is Integer
Return ((Color >> 16) & 0xFF) | (Color & 0x00FF00) | ((Color & 0xFF) << 16)
Return (HTML.HasKey(Color) ? HTML[Color] : Default)
}
}
LV_SetSelColors(HLV, BkgClr := "", TxtClr := "", Dummy := "") {
Static OffCode := A_PtrSize * 2
, OffStage := A_PtrSize * 3
, OffItem := (A_PtrSize * 5) + 16
, OffItemState := OffItem + A_PtrSize
, OffClrText := (A_PtrSize * 8) + 16
, OffClrTextBk := OffClrText + 4
, Controls := {}
, MsgFunc := Func("LV_SetSelColors")
, IsActive := False
Local Item, H, LV, Stage
If (Dummy = "") {
If (BkgClr = "") && (TxtClr = "")
Controls.Delete(HLV)
Else {
If (BkgClr <> "")
Controls[HLV, "B"] := ((BkgClr & 0xFF0000) >> 16) | (BkgClr & 0x00FF00) | ((BkgClr & 0x0000FF) << 16)
If (TxtClr <> "")
Controls[HLV, "T"] := ((TxtClr & 0xFF0000) >> 16) | (TxtClr & 0x00FF00) | ((TxtClr & 0x0000FF) << 16)
}
If (Controls.MaxIndex() = "") {
If (IsActive) {
OnMessage(0x004E, MsgFunc, 0)
IsActive := False
}  }
Else If !(IsActive) {
OnMessage(0x004E, MsgFunc)
IsActive := True
}  }
Else {
H := NumGet(BkgClr + 0, "UPtr")
If (LV := Controls[H]) && (NumGet(BkgClr + OffCode, "Int") = -12) {
Stage := NumGet(BkgClr + OffStage, "UInt")
If (Stage = 0x00010001) {
Item := NumGet(BkgClr + OffItem, "UPtr")
If DllCall("SendMessage", "Ptr", H, "UInt", 0x102C, "Ptr", Item, "Ptr", 0x0002, "UInt") {
NumPut(NumGet(BkgClr + OffItemState, "UInt") & ~0x0011, BkgClr + OffItemState, "UInt")
If (LV.B <> "")
NumPut(LV.B, BkgClr + OffClrTextBk, "UInt")
If (LV.T <> "")
NumPut(LV.T, BkgClr + OffClrText, "UInt")
Return 0x02
}  }
Else If (Stage = 0x00000001)
Return 0x20
Return 0x00
}  }  }
LoadInterfaceLng()
Gui, Startup:-Caption
Gui, Startup:Font, Bold s12, Calibri
html := "<html><body style='background-color: transparent' style='overflow:hidden' leftmargin='0' topmargin='0'><img src='" A_ScriptDir "\Img\Load.gif' width=" w " height=" h " border=0 padding=0></body></html>"
Gui, Startup:Add, ActiveX, x0 y0 w960 h540 vAG, Shell.Explorer
AG.navigate("about:blank")
AG.document.write(html)
Gui, Startup:Show, w960 h565
Gui, Startup:Add, Progress, x0 w960 y540 c0x008000 h25 BackgroundWhite vUPProg
Gui, Startup:Add, Text, x0 w960 y540 Center h25 vStat BackgroundTrans, % _22
GuiControl, Startup:+Redraw, Stat
GuiControl, Startup:Disabled, AG
If (CheckForUpdatesStat()) {
If DllCall("Wininet.dll\InternetGetConnectedState", "Str", 0x40, "Int", 0)
CheckForUpdates()
}
Gui, StartUp:Destroy
CheckFoldersSet()
GreenBTN := [[0, 0xFFFFFF, , 0x008000, 0, , 0x008000, 1]
, [0, 0x008000, , 0xFFFFFF, 0, , 0x008000, 1]
, [0, 0x008000, , 0xFFFF00, 0, , 0x008000, 1]
, [0, 0x6C7174, , 0x000000, 0, , 0xFFFFFF, 1]]
RedBTN := [[0, 0xFFFFFF, , 0xFF0000, 0, , 0xD43F3A, 1]
, [0, 0xFF0000, , 0xFFFFFF, 0, , 0xD43F3A, 1]
, [0, 0xFF0000, , 0xFFFF00, 0, , 0xD43F3A, 1]
, [0, 0x6C7174, , 0xFFFFFF, 0, , 0xFFFFFF, 1]]
LMBTN := [[0, 0x80FFFFFF, , 0x000000, 0, , 0x80F0AD4E]
, [0, 0x80F0AD4E, , 0x000000, 0, , 0x80F0AD4E]
, [0, 0x80F0AD4E, , 0xFF0000, 0, , 0x80F0AD4E]
, [0, 0x80F0AD4E, , 0x000000, 0, , 0x80F0AD4E]]
EBTN := [[0, 0xC6E6C6, , , 0, , 0x5CB85C, 5]
, [0, 0x91CF91, , , 0, , 0x5CB85C, 5]
, [0, 0x5CB85C, , , 0, , 0x5CB85C, 5]
, [0, 0xF0F0F0, , , 0, , 0x5CB85C, 5]]
BMBTN := [[0, 0x80FFFFFF, , 0x000000, 0, , 0x80FFFFFF]
, [0, 0x80F0AD4E, , 0x000000, 0, , 0x80FFFFFF]
, [0, 0x80F0AD4E, , 0xFF0000, 0, , 0x80FFFFFF]
, [0, 0x80F0AD4E, , 0x000000, 0, , 0x80F0AD4E]]
HH := A_ScreenHeight // 2
Gui, ReIn:+HwndInfo -Caption AlwaysOnTop ToolWindow MinSize800x%HH% MaxSize800x%HH% Resize
Gui, ReIn:Font, s15 Bold, Consolas
Gui, ReIn:Add, Edit, x0 y0 w800 h%HH% ReadOnly HwndE vDInfo
CtlColors.Attach(E, "E2E09A", "000000")
Gui, Kridi:Color, 0xD8D8AD
Gui, Kridi:-MinimizeBox +HwndKr AlwaysOnTop
Gui, Kridi:Font, s15 Bold, Calibri
Gui, Kridi:Add, Edit, xm ym w300 Center vKName HwndKE gCheckKExist Border -E0x200
CtlColors.Attach(KE, "FFFFFF", "008000")
Gui, Kridi:Font, Italic
Gui, Kridi:Add, ListBox, w300 vKLB r10 gWriteItDown HwndLB
Gui, Main: +HwndMain
Gui, Main:Font, s10 Bold, Calibri
Gui, Main:Color, 0xD8D8AD
LoadBackground()
Gui, Main:Add, Text, x0 y0 w203 h10 HwndTopText vTText
CtlColors.Attach(TopText, "008000", "000000")
Pass := 0
Global RMS
If !CheckLicense() {
Gui, Main:Add, Picture, x0 y10 h419 vLicPic, Img\Lic.png
Gui, Main:Add, Edit, xm+205 ym+135 w760 vEPassString Center
Gui, Main:Add, Text, xm+205 ym+165 w760 vPassString Center BackgroundTrans, Please enter the KeyString
RMS := "#-1"
Gui, Main:Show, w1000 h500
Return
}
OpenApp:
RMS := "#0"
Gui, Main:+Resize
Gui, Main:Font, s13
Gui, Main:Add, Button, x0 y10 HwndBtn w199 h40 gOpenMain Disabled Hidden vBtn1, % _4
ImageButton.Create(Btn, LMBTN*)
Gui, Main:Add, Button, x0 y50 HwndBtn w199 h40 gSubmit vBtn2 Hidden, % _8
ImageButton.Create(Btn, LMBTN*)
Gui, Main:Add, Button, x0 y90 HwndBtn w199 h40 gDefine vBtn3 Hidden, % _5
ImageButton.Create(Btn, LMBTN*)
Gui, Main:Add, Button, x0 y130 HwndBtn w199 h40 gStockPile vBtn4 Hidden, % _6
ImageButton.Create(Btn, LMBTN*)
Gui, Main:Add, Button, x0 y170 HwndBtn w199 h40 gProf vBtn5 Hidden, % _7
ImageButton.Create(Btn, LMBTN*)
Gui, Main:Add, Button, x0 y210 HwndBtn w199 h40 gManage vBtn6 Hidden, % _28
ImageButton.Create(Btn, LMBTN*)
Gui, Main:Add, Button, x0 y250 HwndBtn w199 h40 gKridi vBtn7 Hidden, % _29
ImageButton.Create(Btn, LMBTN*)
global TU, TP
Gui, Main:Add, Edit, xm ym+150 vTU w178 Center -E0x200 HwndE
CtlColors.Attach(E, "FFFFFF", "000000")
Gui, Main:Add, Edit, xm+200 ym+150 vTP w178 Center -E0x200 Password HwndTP_
CtlColors.Attach(TP_, "FFFFFF", "FF0000")
Gui, Main:Add, Button, xm ym+150 w178 HwndBtn vReload gReload Hidden, Reload
ImageButton.Create(Btn, GreenBTN*)
MainCtrlList := "Bc,$CB,Nm,Stck,Qn,Sum,LV0,ThisListSum,,$GivenMoney,$AllSum,$Change,$ItemsSold,$SoldP,$ProfitP,DiscountPic,Percent"
Gui, Main:Font, s25, Consolas
Gui, Main:Add, Edit, xm y500 HwndE w175 vItemsSold -E0x200 Hidden ReadOnly Center Border, 0
CtlColors.Attach(E, "D8D8AD", "000000")
Gui, Main:Add, Edit, xm y528 HwndE w175 vSoldP -E0x200 Hidden ReadOnly Center Border, 0
CtlColors.Attach(E, "D8D8AD", "008000")
Gui, Main:Add, Edit, xm y556 HwndE w175 vProfitP -E0x200 Hidden ReadOnly Center Border, 0
CtlColors.Attach(E, "D8D8AD", "FF0000")
Ind := "", Xb := 217
Gui, Main:Font, s25 Bold, Calibri
Gui, Main:Add, Edit, xm+380 ym+10 w250 -VScroll vBc Center -E0x200 gAnalyzeAvail Border HwndBc_ Hidden
CtlColors.Attach(Bc_, "FFFFFF", "008000")
GuiControlGet, ThisPos, Main:Pos, Bc
ThisPosX -= 10
Gui, Main:Add, ComboBox, xm+%ThisPosX% ym+58 w250 vCB r10 Simple 0x100 Center gChooseItem HwndLB_ Hidden ReadOnly
CtlColors.Attach(LB_, "FFFFFF", "008000")
Gui, Main:Add, Edit, xm+205 ym+10 w175 vStck -E0x200 ReadOnly HwndE Center Hidden
CtlColors.Attach(E, "D8D8AD", "FF0000")
Gui, Main:Add, Edit, xm+205 ym+70 w250 vNm -E0x200 ReadOnly HwndNm Center Hidden
CtlColors.Attach(Nm, "FFFFFF", "000080")
Gui, Main:Add, Edit, xm+455 ym+70 w260 vQn Center -E0x200 ReadOnly HwndQn gAnalyzeQn Hidden, x1
CtlColors.Attach(Qn, "FFFFFF", "008000")
Gui, Main:Add, Edit, xm+715 ym+70 w250 vSum -E0x200 ReadOnly HwndSum Center Hidden
CtlColors.Attach(Sum, "FFFFFF", "800000")
Gui, Main:Add, Edit, xm+715 ym+370 w250 vThisListSum -E0x200 Border ReadOnly HwndThisListSum Center Hidden
CtlColors.Attach(ThisListSum, "FCEFDC", "800000")
Gui, Main:Font, s15
Gui, Main:Add, Edit, xm+635 ym+370 w40 vPercent HwndPercent_ -E0x200 Border Center Hidden Number gCheckIntCalc, 0
Gui, Main:Add, Pic, xm+670 ym+370 vDiscountPic Hidden, Img\DC.png
Gui, Main:Font, s15
Loop, 7 {
Gui, Main:Add, Button, xm+%Xb% ym+300 w25 h25 vOpenSess%Ind% HwndOpenSess%Ind%_ gUpdateSession Center Hidden, % A_Index
MainCtrlList .= ",OpenSess" Ind
ImageButton.Create(OpenSess%Ind%_, BMBTN*)
Ind := A_Index
Xb += 25
}
GuiControl, Main: Disabled, OpenSess
Gui, Main:Font, s50
Gui, Main:Add, Edit, xm+205 ym+10 w254 vGivenMoney -E0x200 gCalc Center Hidden
Gui, Main:Add, Edit, xm+460 ym+10 w254 vAllSum HwndAS -E0x200 ReadOnly Center Hidden
CtlColors.Attach(AS, "FFFFFF", "008000")
Gui, Main:Add, Edit, xm+715 ym+10 w252 vChange HwndC -E0x200 ReadOnly Center Hidden
CtlColors.Attach(C, "FFFFFF", "FF0000")
Gui, Main:Font, s25
Gui, Main:Add, ListView, xm+205 ym+135 w760 r10 -Hdr Grid vLV0 BackgroundFCEFDC HwndHLV Hidden -Multi, Barcode|QN|Name|Quantity|Price
Gui, Main:Default
Gui, Main:ListView, LV0
LV_ModifyCol(1, "0 Center")
LV_ModifyCol(2, "180")
LV_ModifyCol(3, "234 Center")
LV_ModifyCol(4, "232 Center")
LV_ModifyCol(5, "230 Center")
EnsureCtrlList := "LV1,EnsBtn,$Sold,$Bought,$ProfitEq"
Gui, Main:Font, s25
Gui, Main:Add, Button, xm+205 ym+30 vEnsBtn w760 h80 hwndEnsBtn_ Hidden gValid, % _9
ImageButton.Create(EnsBtn_, EBTN*)
Gui, Main:Font, s15
Gui, Main:Add, ListView, xm+205 ym+135 w760 r10 -Hdr Grid vLV1 BackgroundDEFCDC HwndHLV Hidden -Multi, FN|SO
Gui, Main:Default
Gui, Main:ListView, LV1
LV_ModifyCol(1, "0")
LV_ModifyCol(2, "760 Center")
Gui, Main:Font, s40
Gui, Main:Add, Edit, xm+206 ym+430 w260 vSold Center -E0x200 ReadOnly HwndE gAnalyzeQn Hidden
CtlColors.Attach(E, "00FF00", "000000")
Gui, Main:Add, Edit, xm+456 ym+430 w260 vBought -E0x200 ReadOnly HwndE Center Hidden
CtlColors.Attach(E, "FF8080", "000000")
Gui, Main:Add, Edit, xm+716 ym+430 w260 vProfitEq -E0x200 ReadOnly HwndE Center Hidden
CtlColors.Attach(E, "00FF00", "000000")
Gui, Main:Font, s15
DefineCtrlList := "Dbc,Dnm,Dbp,Dsp,LV2,PrevPD,PDSave"
Gui, Main:Add, Edit, xm+205 ym+80 w185 Center Border vDbc HwndDbc_ -E0x200 gClearDbc Hidden
CtlColors.Attach(Dbc_, "FFFFFF", "000000")
Gui, Main:Add, Edit, xm+396 ym+80 w185 Center Border vDnm HwndDnm_ -E0x200 gClearDnm Hidden
CtlColors.Attach(Dnm_, "FFFFFF", "000000")
Gui, Main:Add, Edit, xm+589 ym+80 w185 Center Border vDbp HwndDbp_ -E0x200 gClearDbp Hidden
CtlColors.Attach(Dbp_, "FFFFFF", "000000")
Gui, Main:Add, Edit, xm+780 ym+80 w185 Center Border vDsp HwndDsp_ -E0x200 gClearDsp Hidden
CtlColors.Attach(Dsp_, "FFFFFF", "000000")
Gui, Main:Font, s12
Gui, Main:Add, DDL, xm+780 ym+50 w185 Center Border vPrevPD r10 gPrevPDAnalyze Hidden
Gui, Main:Add, Button, xm+780 ym+20 w185 h25 Center Border vPDSave HwndPDSave_ gApplyPD Hidden, % _30
ImageButton.Create(PDSave_, RedBtn*)
Gui, Main:Font, s15
Gui, Main:Add, ListView, xm+205 ym+135 w760 r10 -Hdr Grid vLV2 HwndHLV BackgroundDCFCF9 Hidden gEdit, Barcode|Name|Quantity|Price
Gui, Main:Default
Gui, Main:ListView, LV2
LV_ModifyCol(1, "185 Center")
LV_ModifyCol(2, "192 Center")
LV_ModifyCol(3, "192 Center")
LV_ModifyCol(4, "186 Center")
StockPileCtrlList := "Pnm,Pqn,PSum,LV3,StockSum,$Add,$Sub"
Gui, Main:Font, s25
Gui, Main:Add, Edit, xm+205 ym+50 w253 Center vPnm HwndPnm_ -E0x200 Hidden
CtlColors.Attach(Pnm_, "E6E6E6", "000000")
Gui, Main:Add, Edit, xm+458 ym+50 w253 Center vPqn HwndPqn_ -E0x200 Hidden
CtlColors.Attach(Pqn_, "E6E6E6", "0000FF")
Gui, Main:Add, Edit, xm+711 ym+50 w253 Center vPSum HwndPSum_ -E0x200 Hidden ReadOnly
CtlColors.Attach(PSum_, "E6E6E6", "000000")
Gui, Main:Add, Edit, xm+711 ym+50 w253 Center vStockSum HwndStockSum_ -E0x200 Hidden Border ReadOnly
CtlColors.Attach(StockSum_, "FFFFFF", "000000")
Gui, Main:Font, s15, Consolas
Gui, Main:Add, Edit, xm+585 ym+135 w253 r2 vAdd HwndAdd_ -E0x200 Hidden ReadOnly Border
CtlColors.Attach(Add_, "FFFFFF", "000000")
Gui, Main:Add, Edit, xm+585 ym+135 w253 r2 vSub HwndSub_ -E0x200 Hidden ReadOnly Border
CtlColors.Attach(Sub_, "FFFFFF", "FF0000")
Gui, Main:Font, s15, Calibri
Gui, Main:Add, ListView, xm+205 ym+135 w760 r10 -Hdr Grid vLV3 BackgroundF4FCDC HwndHLV gDisplayQn Hidden -Multi, Barcode|Name|Quantity|ThisSum
Gui, Main:Default
Gui, Main:ListView, LV3
LV_ModifyCol(1, "0 Center")
LV_ModifyCol(2, "377 Center")
LV_ModifyCol(3, "380 Center")
LV_ModifyCol(4, "380 Center")
ProfitCtrlList := "SPr,CPr,OAProfit,LV4,Today,Yesterday"
Gui, Main:Font, s25
TodayDate := A_Now
Gui, Main:Add, DateTime, xm+205 ym+350 w345 vToday Choose%TodayDate% Hidden, yyyy.MM.dd | HH:mm:ss
TodayDate += -1, Days
Gui, Main:Add, DateTime, xm+605 ym+350 w345 vYesterday Choose%TodayDate% Hidden, yyyy.MM.dd | HH:mm:ss
Gui, Main:Font, s15
Gui, Main:Add, ListView, xm+205 ym+135 w760 r10 -Hdr Grid vLV4 BackgroundFCDCDC HwndHLV gDisplayQn Hidden -Multi, FN|Date|BP|SP|Pr
Gui, Main:Add, Edit, xm+776 ym+90 -E0x200 ReadOnly vOAProfit w189 Hidden Center cRed Border HwndE
CtlColors.Attach(E, "00FF00", "000000")
Gui, Main:Add, Edit, xm+586 ym+90 -E0x200 ReadOnly vCPr w189 Hidden Center cRed Border HwndE
CtlColors.Attach(E, "FF8080", "000000")
Gui, Main:Add, Edit, xm+396 ym+90 -E0x200 ReadOnly vSPr w189 Hidden Center cRed Border HwndE
CtlColors.Attach(E, "00FF00", "000000")
Gui, Main:Add, DropDownList, xm+205 ym+90 ReadOnly vByDate w189 Hidden Border r10 gDisplayEqProf
Gui, Main:Default
Gui, Main:ListView, LV4
LV_ModifyCol(1, "0")
LV_ModifyCol(2, "189 Center")
LV_ModifyCol(3, "189 Center")
LV_ModifyCol(4, "189 Center")
LV_ModifyCol(5, "189 Center")
ManageCtrlList := "UserName,UserPass,LV5,CheckForUpdates,RememberLogin"
Gui, Main:Add, Edit, xm+205 ym+10 w200 -E0x200 vUserName Hidden HwndE Border Right cRed
Gui, Main:Add, Edit, xm+405 ym+10 w200 -E0x200 vUserPass Hidden HwndE Border
Gui, Main:Font, s10
Gui, Main:Add, CheckBox, xm+615 ym+10 vCheckForUpdates gCheckForUpdates Hidden, % _31
Gui, Main:Add, CheckBox, xm+615 ym+30 vRememberLogin gRememberLogin Hidden, % _32
Gui, Main:Font, s15
Gui, Main:Add, ListView, xm+205 ym+50 w400 r10 -Hdr Grid vLV5 HwndHLV Hidden -Multi cBlue, N|P
Gui, Main:Default
Gui, Main:ListView, LV5
LV_ModifyCol(1, "198 Right")
LV_ModifyCol(2, "198")
KridiCtrlList := "KLB,LV0,ThisListSum"
Gui, Main:Add, ListBox, xm+205 ym+135 w210 vKLB Hidden HwndKLB gDisplayKridi
CtlColors.Attach(KLB, "FCEFDC", "000000")
Gui, Main:Font, s15
Gui, Main:Show, % "w800 h67"
LoadX := 0
IniRead, Log, Setting.ini, OtherSetting, RemUser
OldLog := StrSplit(DB_Read("Sets\RL.db"), ";")
If (OldLog[1] = Log) {
GuiControl, Main:, TU, % Log
GuiControl, Main:, TP, % OldLog[2]
}
Return
Continue:
Gui, Main:Font, s15
Gui, Main:Add, Button, xm+199 ym+10 w140 h90 gCheckAndRun HwndBtn vOpenMain
ImageButton.Create(Btn, [ [0, "Img\OM\1.png"]
, [0, "Img\OM\2.png"]
, [0, "Img\OM\3.png"]
, [0, "Img\OM\4.png"]]*)
Gui, Main:Add, Button, xm+344 ym+10 w140 h90 gCheckAndRun HwndBtn vSubmit
ImageButton.Create(Btn, [ [0, "Img\ED\1.png"]
, [0, "Img\ED\2.png"]
, [0, "Img\ED\3.png"]
, [0, "Img\ED\4.png"]]*)
Gui, Main:Add, Button, xm+489 ym+10 w140 h90 gCheckAndRun HwndBtn vDefine
ImageButton.Create(Btn, [ [0, "Img\DE\1.png"]
, [0, "Img\DE\2.png"]
, [0, "Img\DE\3.png"]
, [0, "Img\DE\4.png"]]*)
Gui, Main:Add, Button, xm+634 ym+10 w140 h90 gCheckAndRun HwndBtn vStockpile
ImageButton.Create(Btn, [ [0, "Img\ST\1.png"]
, [0, "Img\ST\2.png"]
, [0, "Img\ST\3.png"]
, [0, "Img\ST\4.png"]]*)
Gui, Main:Add, Button, xm+199 ym+110 w140 h90 gCheckAndRun HwndBtn vProf
ImageButton.Create(Btn, [ [0, "Img\PR\1.png"]
, [0, "Img\PR\2.png"]
, [0, "Img\PR\3.png"]
, [0, "Img\PR\4.png"]]*)
Gui, Main:Add, Button, xm+344 ym+110 w140 h90 gCheckAndRun HwndBtn vManage
ImageButton.Create(Btn, [ [0, "Img\MN\1.png"]
, [0, "Img\MN\2.png"]
, [0, "Img\MN\3.png"]
, [0, "Img\MN\4.png"]]*)
Gui, Main:Add, Button, xm+489 ym+110 w140 h90 gCheckAndRun HwndBtn vKridi
ImageButton.Create(Btn, [ [0, "Img\KR\1.png"]
, [0, "Img\KR\2.png"]
, [0, "Img\KR\3.png"]
, [0, "Img\KR\4.png"]]*)
RMS := "#0.1"
Gui, Main:-Resize
Gui, Main:Show, % "w800 h400 Center"
About =
(

Cash Helper v4.0 Released!
This is a free app made in purpose to help a friend
Many thanks to the next:

Ismail Jarallah: 
Debugging the app
Suggesting ideas
Real-Time testing
Verifying the app effectiveness

Muhammad Abdelmumen:
Initial ideas of app
Verifying the app effectiveness

Atef Naji:
Verifying the app effectiveness
Suggesting ideas
)
Gui, About:+ParentMain
Gui, About:Color, 0xD8D8AD
Gui, About:Font, s10 Bold Italic, Calibri
Gui, About: -Caption
Gui, About:Add, Edit, x0 y0 w190 vAboutText Center -E0x200 ReadOnly -VScroll HwndE, % About
CtlColors.Attach(E, "FFFFFF", "000000")
GuiControlGet, Height, About:Pos, AboutText
Gui, About:Add, Edit, x0 y%HeightH% w190 vAboutText_ Center -E0x200 ReadOnly -VScroll HwndE, % About
CtlColors.Attach(E, "FFFFFF", "000000")
Gui, About:Show, x5 y27 h%HeightH%
SetTimer, About, 0
GuiControl, Main:Focus, OpenMain
Return
KridiGuiClose:
Gui, Kridi:Hide
GuiControl, Main:Focus, Bc
Return
DisplayEqProf:
Gui, Main:Submit, NoHide
ByDate := SubStr(ByDate, InStr(ByDate, " ",, 0))
Arr := StrSplit(ByDate, ";")
GuiControl, Main:, Today, % Arr[2]
GuiControl, Main:, Yesterday, % Arr[1]
GoSub, DisplayEqProfit
Return
About:
YPos += 1
GuiControl, About:Move, AboutText, % "y" YPos
GuiControl, About:Move, AboutText_, % "y" YPos - HeightH
If (Ypos = HeightH) {
YPos := 0
}
Sleep, 25
Return
RememberLogin:
Gui, Main:Submit, NoHide
If (RememberLogin) {
IniWrite, % TP, Setting.ini, OtherSetting, RemUser
DB_Write("Sets\RL.db", TP ";" TU)
} Else {
IniWrite, % "", Setting.ini, OtherSetting, RemUser
FileDelete, Sets\RL.db
}
Return
CheckForUpdates:
Gui, Main:Submit, NoHide
If (CheckForUpdates)
IniWrite, 1, Setting.ini, Update, Upt
Else
IniWrite, 0, Setting.ini, Update, Upt
Return
ApplyPD:
Gui, Main:Submit, NoHide
RegExMatch(PrevPD, "\[\d+\]", PrevID)
If (PrevID != "[0]") {
Loop, Files, % "Sets\Bu\*.bu"
{
If ("[" A_Index "]" = PrevID) {
FileCopy, % "Sets\PD.db", % "Sets\Bu\" A_Now ".Bu"
FileCopy, % A_LoopFileFullPath, % "Sets\PD.db", 1
GuiControl, Main:Disabled, PDSave
LoadPrevPD()
ProdDefs := LoadDefinitions(DB_Read("Sets\PD.db"))
LoadDefined()
Break
}
}
}
Return
PrevPDAnalyze:
Gui, Main:Submit, NoHide
GuiControl, Main:Enabled, PDSave
RegExMatch(PrevPD, "\[\d+\]", PrevID)
If (PrevID = "[0]") {
LV_Delete()
PDAllItems := ""
PDProdDefs := LoadDefinitions(DB_Read("Sets\PD.db"))
For Each, Item in PDProdDefs {
PDAllItems .= Each ","
}
Sort, PDAllItems, N D,
Loop, Parse, % Trim(PDAllItems, ","), `,
LV_Add("", A_LoopField, PDProdDefs["" A_LoopField ""][1], PDProdDefs["" A_LoopField ""][2], PDProdDefs["" A_LoopField ""][3])
GuiControl, Main:Disabled, PDSave
} Else {
Loop, Files, % "Sets\Bu\*.bu"
{
If ("[" A_Index "]" = PrevID) {
LV_Delete()
PDAllItems := ""
PDProdDefs := LoadDefinitions(DB_Read(A_LoopFileFullPath))
For Each, Item in PDProdDefs {
PDAllItems .= Each ","
}
Sort, PDAllItems, N D,
Loop, Parse, % Trim(PDAllItems, ","), `,
LV_Add("", A_LoopField, PDProdDefs["" A_LoopField ""][1], PDProdDefs["" A_LoopField ""][2], PDProdDefs["" A_LoopField ""][3])
Break
}
}
}
Return
DisplayKridi:
LV_Delete()
Gui, Main:Submit, NoHide
Loop, Files, % "Kr\" (ThisKLB := EncodeAlpha(KLB)) "\*.db"
{
Index := A_Index
If (RD := DB_Read(A_LoopFileFullPath)) {
Arr__ := StrSplit(RD, "> ")
Items := StrSplit(Trim(Arr__[2], "|"), "|")
For Each, One in Items {
ThisOne := StrSplit(One, ";")
LV_Add("", ThisOne[1], Index, ThisOne[2], ThisOne[3], ThisOne[4])
}
}
}
CheckListSum()
Return
CheckKExist:
Gui, Kridi:Submit, NoHide
If InStr(FileExist("Kr\" KName), "D") {
GuiControl, Kridi:ChooseString, KLB, % KName
}
Return
WriteItDown:
Gui, Kridi:Submit, NoHide
If (KLB) {
GuiControl, Kridi:, KName, % KLB
GuiControl, Kridi:Focus, KName
SelectAll(KE)
}
Return
CheckAndRun:
SetTimer, About, Off
Gui, About:Hide
Loop, Parse, % "OpenMain,Submit,Define,Prof,Stockpile,Manage,Kridi", `,
GuiControl, Main:Hide, %A_LoopField%
Global ProdDefs := {}
If FileExist("Sets\PD.db")
ProdDefs := LoadDefinitions(DB_Read("Sets\PD.db"))
SessionID := "OpenSess"
LastMDate := ""
FileGetTime, PBMData, Sets\PD.db, M
Table := ["A", "B", "C", "D", "E", "F"]
FileGetTime, PBMData, Sets\PD.db, M
CoordMode, Mouse, Screen
OnMessage(0x200, "MouseHover")
Loop, Parse, % "1243567"
GuiControl, Main:Show, Btn%A_LoopField%
SetTimer, Update, 250
Gui, Main:+Resize
Gui, Main:Show, % "Maximize"
Gosub, % A_GuiControl
MM := 1
Return
Reload:
Reload
Return
ChooseItem:
Gui, Main:Submit, NoHide
Bc := SubStr(CB, InStr(CB, " ",, 0) + 1)
GuiControl, Main:, Bc, % Trim(Bc, "[]")
Return
DisplayEqProfit:
Gui, Main:Submit, NoHide
LV_Delete()
If (Today >= Yesterday) {
OAPr := CP := SPr := 0
GuiControl, Main:, OAProfit, % OAPr
GuiControl, Main:, SPr, % SPr
GuiControl, Main:, CPr, % CP
LV_Delete()
Loop, Files, Valid\*.db, R F
{
ThisDate := SubStr(A_LoopFileName, 1, StrLen(A_LoopFileName) - 3)
If ThisDate Between %Yesterday% and %Today%
{
RD := DB_Read(A_LoopFileFullPath)
If (RD) {
Arr := CalcProfit(RD)
If (!Arr[2][2]) {
Correct(A_LoopFileFullPath)
RD := DB_Read(A_LoopFileFullPath)
Arr := CalcProfit(RD)
}
LV_Add("", A_LoopFileFullPath, Arr[1], "+ " Arr[2][1], "- " Arr[2][2], "+ " Arr[2][3])
SPr := Arr[2][1] + SPr
CP := Arr[2][2] + CP
OAPr := Arr[2][3] + OAPr
}
}
}
Loop, Files, Curr\*.db
{
ThisDate := SubStr(A_LoopFileName, 1, StrLen(A_LoopFileName) - 3)
If ThisDate Between %Yesterday% and %Today%
{
RD := DB_Read(A_LoopFileFullPath)
If (RD) {
Arr := CalcProfit(RD)
If (!Arr[2][2]) {
Correct(A_LoopFileFullPath)
RD := DB_Read(A_LoopFileFullPath)
Arr := CalcProfit(RD)
}
LV_Add("", A_LoopFileFullPath, Arr[1], "+ " Arr[2][1], "- " Arr[2][2], "+ " Arr[2][3])
SPr := Arr[2][1] + SPr
CP := Arr[2][2] + CP
OAPr := Arr[2][3] + OAPr
}
}
}
GuiControl, Main:, OAProfit, % OAPr
GuiControl, Main:, SPr, % SPr
GuiControl, Main:, CPr, % CP
}
Return
WM_LBUTTONDOWN:
PostMessage 0xA1, 2
Return
UpdateSession:
Gui, Main:Submit, NoHide
Loop, Parse, % ",1,2,3,4,5,6", `,
GuiControl, Main:Enable, % "OpenSess" A_LoopField
GuiControl, Main:Disabled, % A_GuiControl
SessionID := A_GuiControl
If FileExist("Dump\" SessionID ".db")
RestoreSession(DB_Read("Dump\" SessionID ".db"))
Else {
Loop, Parse, % StrReplace(MainCtrlList, "$"), `,
{
If (A_LoopField != "Qn")
GuiControl, Main:, % A_LoopField
Else
GuiControl, Main:, % A_LoopField, % "x1"
}
LV_Delete()
}
GuiControl, Main:Hide, GivenMoney
GuiControl, Main:Hide, AllSum
GuiControl, Main:Hide, Change
GuiControl, Main:Hide, CB
GuiControl, Main:Show, Bc
GuiControl, Main:Show, Nm
GuiControl, Main:Show, Qn
GuiControl, Main:Show, Sum
GuiControl, Main:Show, Stck
GuiControl, Main:Focus, Bc
Return
InfoButtonOK:
Gui, Info:Destroy
Return
:*C:LetAppRunOnThisMachine::
If (RMS = "#-1") {
Pass := 1
ADMUsername := ADMPassword := ""
GuiControl, Main:, PassString, Create ADM username
}
Return
MainGuiSize:
WinGetPos,,, Width, Height, % "ahk_id " Main
Height -= 35
GuiControl, Main:Move, % "TText", % "x0 w" Width
GuiControl, Main:Move, % "Prt1", % "y" Height - 55 " w" Width - 199
GuiControl, Main:Move, % "Prt2", % "y" Height - 55
GuiControl, Main:Move, % "Prt3", % "y" Height - 60 " w" Width
GuiControl, Main:Move, % "Prt4", % "h" Height
GuiControl, Main:Move, % "Prt5", % "x" Width - 57 " y" Height - 45
Loop, 5 {
GuiControl, Main:+Redraw, % "Prt" A_Index
}
If (RMS = "#0") {
GuiControl, Main:Move, TU, % "y" Height - 45
GuiControl, Main:+Redraw, TU
GuiControl, Main:Move, TP, % "y" Height - 45
GuiControl, Main:+Redraw, TP
}
Width -= 30
Third := (Width - 217) // 3
If (RMS != "#0") {
GuiControl, Main:Move, Reload, % "y" Height - 45
GuiControl, Main:+Redraw, Reload
GuiControl, Main:Move, TP, % "y" Height - 45
GuiControl, Main:+Redraw, TP
}
If (RMS = "#1") {
InitY := 108
GuiControl, Main:Move, % "ItemsSold", % "y" Height - InitY - (50 * 2)
GuiControl, Main:Move, % "SoldP", % "y" Height - InitY - 50
GuiControl, Main:Move, % "ProfitP", % "y" Height - InitY
GuiControl, Main:Move, % "Bc", % "w" Third
GuiControl, Main:Move, % "CB", % "w" Third
GuiControl, Main:Move, % "Nm", % "w" Third
GuiControl, Main:Move, % "Qn", % "x" Third + 217 " w" Third
GuiControl, Main:Move, % "Sum", % "x" (Third * 2) + 217 " w" Third
GuiControl, Main:Move, % "LV0", % "x" 217 " w" (Third * 3) " h" Height - 260
Gui, Main:ListView, LV0
LV_ModifyCol(3, (Val := Third) - 61)
LV_ModifyCol(4, Val - 62)
LV_ModifyCol(5, Val - 61)
GuiControl, Main:Move, % "ThisListSum", % "x" (Third * 2) + 217 " y" Height - 118 " w" Third
GuiControl, Main:Move, % "DiscountPic", % "x" (Third * 2) + 170 " y" Height - 110
GuiControl, Main:Move, % "Percent", % "x" (Third * 2) + 130 " y" Height - 110
GuiControl, Main:Move, % "GivenMoney", % "w" Third
GuiControl, Main:Move, % "AllSum", % "x" Third + 217 " w" Third
GuiControl, Main:Move, % "Change", % "x" (Third * 2) + 217 " w" Third
ThisY := Height - 85
GuiControl, Main:Move, % "OpenSess", % "x" 217 " y" ThisY
GuiControl, Main:Move, % "OpenSess" 1, % "x" 243 " y" ThisY
GuiControl, Main:Move, % "OpenSess" 2, % "x" 269 " y" ThisY
GuiControl, Main:Move, % "OpenSess" 3, % "x" 295 " y" ThisY
GuiControl, Main:Move, % "OpenSess" 4, % "x" 321 " y" ThisY
GuiControl, Main:Move, % "OpenSess" 5, % "x" 347 " y" ThisY
GuiControl, Main:Move, % "OpenSess" 6, % "x" 373 " y" ThisY
If (Loaded) {
Loop, Parse, % ",1,2,3,4,5,6", `,
GuiControl, Main:+Redraw, % "OpenSess" A_LoopField
GuiControl, Main:+Redraw, % "DiscountPic"
GuiControl, Main:+Redraw, % "Percent"
GuiControl, Main:+Redraw, % "ThisListSum"
}
} Else If (RMS = "#2") {
GuiControl, Main:Move, % "EnsBtn", % "w" (Third * 3)
GuiControl, Main:, % "EnsBtn", % _9
ImageButton.Create(EnsBtn_, EBTN*)
GuiControl, Main:Move, % "LV1", % "w" (Third * 3) " h" Height - 300
Gui, Main:ListView, LV1
LV_ModifyCol(2, (Third * 3) - 22)
GuiControl, Main:Move, % "Sold", % "y" Height - 150 " w" Third
GuiControl, Main:Move, % "Bought", % "x" Third + 217 " y" Height - 150 " w" Third
GuiControl, Main:Move, % "ProfitEq", % "x" (Third * 2) + 217 " y" Height - 150 " w" Third
} Else If (RMS = "#3") {
Quarter := (Width - 217) // 4
GuiControl, Main:Move, % "Dbc", % "w" Quarter
GuiControl, Main:Move, % "Dnm", % "x" Quarter + 217 " w" Quarter
GuiControl, Main:Move, % "Dbp", % "x" (Quarter * 2) + 217 " w" Quarter
GuiControl, Main:Move, % "Dsp", % "x" (Quarter * 3) + 217 " w" Quarter
GuiControl, Main:Move, % "PrevPD", % "x" (Quarter * 3) + 217 " w" Quarter
GuiControl, Main:Move, % "PDSave", % "x" (Quarter * 3) + 217 " w" Quarter
GuiControl, Main:, % "PDSave", % _30
ImageButton.Create(PDSave_, RedBTN*)
If (Loaded) {
GuiControl, Main:+Redraw, % "PDSave"
}
GuiControl, Main:Move, % "LV2", % "w" (Quarter * 4) " h" Height - 220
Gui, Main:ListView, LV2
LV_ModifyCol(1, (Val := Quarter) - 2)
LV_ModifyCol(2, Val - 1)
LV_ModifyCol(3, Val)
LV_ModifyCol(4, Val - 1)
} Else If (RMS = "#4") {
GuiControl, Main:Move, % "Pnm", % "w" Third
Gui, Main:ListView, LV3
If (!DStatistic) {
GuiControl, Main:Move, % "Pqn", % "x" Third + 217 " w" Third
GuiControl, Main:Move, % "Psum", % "x" (Third * 2) + 217 " w" Third
GuiControl, Main:Move, % "LV3", % "w" (Third * 3) " h" Height - 270
GuiControl, Main:Move, % "StockSum", % "x" (Third * 2) + 217 " y" Height - 120 " w" Third
LV_ModifyCol(2, (Val := Third) - 3)
LV_ModifyCol(3, Val - 1)
LV_ModifyCol(4, Val - 1)
} Else {
GuiControl, Main:Move, % "Add", % "x" Third + 217 "w" Third " h" Height - 270
GuiControl, Main:Move, % "Sub", % "x" Third*2 + 217 " w" Third " h" Height - 270
GuiControl, Main:Move, % "LV3", % "w" Third " h" Height - 270
LV_ModifyCol(2, Third - 5)
LV_ModifyCol(3, "0")
LV_ModifyCol(4, "0")
}
} Else If (RMS = "#5") {
Quarter := (Width - 217) // 4
GuiControl, Main:Move, % "SPr", % "x" Quarter + 217 " w" Quarter
GuiControl, Main:Move, % "ByDate", % "x" 217 " w" Quarter - 20
GuiControl, Main:Move, % "CPr", % "x" (Quarter * 2) + 217 " w" Quarter
GuiControl, Main:Move, % "OAProfit", % "x" (Quarter * 3) + 217 "w" Quarter
GuiControl, Main:Move, % "Today", % "x" 217 " y" Height - 115
GuiControl, Main:Move, % "Yesterday", % "x" Width - 350 " y" Height - 115
GuiControl, Main:Move, % "LV4", % "w" (Quarter * 4) " h" Height - 260
Gui, Main:ListView, LV4
LV_ModifyCol(2, (Val := Quarter) - 3)
LV_ModifyCol(3, Val)
LV_ModifyCol(4, Val)
LV_ModifyCol(5, Val - 1)
} Else If (RMS = "#6") {
GuiControl, Main:Move, % "LV5", % "h" Height - 140
} Else If (RMS = "#7") {
GuiControl, Main:Move, % "GivenMoney", % "w" Third
GuiControl, Main:Move, % "AllSum", % "x" Third + 217 " w" Third
GuiControl, Main:Move, % "Change", % "x" (Third * 2) + 217 " w" Third
GuiControl, Main:Move, % "KLB", % "x" 217 " h" Height - 260
GuiControl, Main:Move, % "LV0", % "x" 437 " w" (Third * 3) - 220 " h" Height - 260
GuiControl, Main:Move, % "ThisListSum", % "x" (Third * 2) + 217 " y" Height - 118 " w" Third
Gui, Main:ListView, LV0
LV_ModifyCol(3, (Val := Third) - 135)
LV_ModifyCol(4, Val - 135)
LV_ModifyCol(5, Val - 134)
}
Return
CheckIntCalc:
Gui, Main:Submit, NoHide
If (Percent) && (Percent > 100) {
GuiControl, Main:, Percent, 100
SelectAll(Percent_)
}
Return
Update:
If WinActive("ahk_id " Main) {
If (Level = "User") {
Loop, 6 {
GuiControlGet, Enb, Main:Enabled, % "Btn" A_Index + 1
If (Enb) {
GuiControl, Main:Disabled, % "Btn" A_Index + 1
}
GuiControlGet, Visi, Main:Visible, % "Btn" A_Index + 1
If (Visi) {
GuiControl, Main:Hide, % "Btn" A_Index + 1
}
}
If (RMS = "#0.1") {
Loop, Parse, % "Submit,Define,Prof,Stockpile,Manage,Kridi", `,
{
GuiControlGet, Enb, Main:Enabled, % A_LoopField
If (Enb) {
GuiControl, Main:Disabled, % A_LoopField
}
GuiControlGet, Visi, Main:Visible, % A_LoopField
If (Visi) {
GuiControl, Main:Hide, % A_LoopField
}
}
}
}
FileGetTime, ThisMData, Curr, M
If (ThisMData != LastMDate) {
Nb := SPr := OAPr := 0
Loop, Files, Curr\*.db
{
RD := DB_Read(A_LoopFileFullPath)
If (RD) {
Arr := CalcProfit(RD)
SPr := Arr[2][1] + SPr
OAPr := Arr[2][3] + OAPr
Nb := Nb + Arr[3]
}
}
GuiControl, Main:, ItemsSold, % Nb
GuiControl, Main:, SoldP, % SPr
GuiControl, Main:, ProfitP, % OAPr
LastMDate := ThisMData
}
If FileExist("Sets\PD.db") {
FileGetTime, _ThisMData, Sets\PD.db, M
If (PBMData != _ThisMData) {
ProdDefs := LoadDefinitions(DB_Read("Sets\PD.db"))
PBMData := _ThisMData
}
}
If (RMS = "#1") {
GuiControlGet, Visi, Main:Visible, CB
If (Visi) {
GuiControlGet, ThisFocus, Main:FocusV
If (ThisFocus != "CB") {
GuiControl, Main:Hide, CB
}
MouseGetPos,,,, OutputVarControl
If !(OutputVarControl ~= "Edit7|ComboLBox1") {
GuiControl, Main:+Redraw, CB
}
}
}
}
Return
OpenMain:
RMS := "#1"
Loop, Parse, % "1243567"
GuiControl, Main:Disabled, Btn%A_LoopField%
Run, Loading,,, OutPID
Gui, Main:+Disabled
Gosub, MainGuiSize
Hide(EnsureCtrlList "," DefineCtrlList "," StockPileCtrlList "," ProfitCtrlList "," ManageCtrlList "," KridiCtrlList)
Show(MainCtrlList)
Gui, Main:ListView, LV0
Gui, Main:Submit, NoHide
Loop, Parse, % "243567"
GuiControl, Main:Enabled, Btn%A_LoopField%
If FileExist("Dump\" SessionID ".db")
RestoreSession(DB_Read("Dump\" SessionID ".db"))
Gui, Main:-Disabled
Process, Close, % OutPID
GuiControl, Main:Focus, Bc
Return
Submit:
RMS := "#2"
Gosub, MainGuiSize
Loop, Parse, % "1243567"
GuiControl, Main:Disabled, Btn%A_LoopField%
Run, Loading,,, OutPID
Gui, Main:+Disabled
Hide(MainCtrlList "," DefineCtrlList "," StockPileCtrlList "," ProfitCtrlList "," ManageCtrlList "," KridiCtrlList)
Show(EnsureCtrlList)
Gui, Main:ListView, LV1
GuiControl, Main:Enabled, EnsBtn
LoadCurrent()
Loop, Parse, % "134567"
GuiControl, Main:Enabled, Btn%A_LoopField%
Gui, Main:-Disabled
Process, Close, % OutPID
GuiControl, Main:Focus, EnsBtn
Return
Define:
RMS := "#3"
Gosub, MainGuiSize
Loop, Parse, % "1243567"
GuiControl, Main:Disabled, Btn%A_LoopField%
Run, Loading,,, OutPID
Gui, Main:+Disabled
Hide(MainCtrlList "," EnsureCtrlList "," StockPileCtrlList "," ProfitCtrlList "," ManageCtrlList "," KridiCtrlList)
Show(DefineCtrlList)
Gui, Main:ListView, LV2
LoadDefined()
LoadPrevPD()
Loop, Parse, % "124567"
GuiControl, Main:Enabled, Btn%A_LoopField%
Gui, Main:-Disabled
Process, Close, % OutPID
GuiControl, Main:Focus, Dbc
Return
StockPile:
RMS := "#4"
DStatistic := 0
Gosub, MainGuiSize
Loop, Parse, % "1243567"
GuiControl, Main:Disabled, Btn%A_LoopField%
Run, Loading,,, OutPID
Gui, Main:+Disabled
Hide(MainCtrlList "," EnsureCtrlList "," DefineCtrlList "," ProfitCtrlList "," ManageCtrlList "," KridiCtrlList)
Show(StockPileCtrlList)
Gui, Main:ListView, LV3
LoadStockList()
Loop, Parse, % "123567"
GuiControl, Main:Enabled, Btn%A_LoopField%
Gui, Main:-Disabled
Process, Close, % OutPID
GuiControl, Main:, Pnm
GuiControl, Main:Focus, Pnm
Return
Prof:
RMS := "#5"
Gosub, MainGuiSize
Loop, Parse, % "1234567"
GuiControl, Main:Disabled, Btn%A_LoopField%
Run, Loading,,, OutPID
Gui, Main:+Disabled
Hide(MainCtrlList "," EnsureCtrlList "," DefineCtrlList "," StockPileCtrlList "," ManageCtrlList "," KridiCtrlList)
Show(ProfitCtrlList)
Gui, Main:ListView, LV4
LoadProf()
Loop, Parse, % "123467"
GuiControl, Main:Enabled, Btn%A_LoopField%
Gui, Main:-Disabled
Process, Close, % OutPID
GuiControl, Main:Focus, LV4
Return
Manage:
RMS := "#6"
Gosub, MainGuiSize
Loop, Parse, % "1234567"
GuiControl, Main:Disabled, Btn%A_LoopField%
Run, Loading,,, OutPID
Gui, Main:+Disabled
Hide(MainCtrlList "," EnsureCtrlList "," DefineCtrlList "," StockPileCtrlList "," ProfitCtrlList "," KridiCtrlList)
Show(ManageCtrlList)
Gui, Main:ListView, LV5
LoadAccounts()
LoadSetting()
Loop, Parse, % "123457"
GuiControl, Main:Enabled, Btn%A_LoopField%
GuiControl, Main:Focus, UserName
Gui, Main:-Disabled
Process, Close, % OutPID
GuiControl, Main:Focus, LV5
Return
Kridi:
RMS := "#7"
Gosub, MainGuiSize
Loop, Parse, % "1234567"
GuiControl, Main:Disabled, Btn%A_LoopField%
Run, Loading,,, OutPID
Gui, Main:+Disabled
Hide(MainCtrlList "," EnsureCtrlList "," DefineCtrlList "," StockPileCtrlList "," ProfitCtrlList "," ManageCtrlList)
Show(KridiCtrlList)
Gui, Main:ListView, LV0
LoadKridis()
Loop, Parse, % "123456"
GuiControl, Main:Enabled, Btn%A_LoopField%
Gui, Main:-Disabled
Process, Close, % OutPID
GuiControl, Main:Focus, KLB
Return
Edit:
LV_GetText(EBc, Row := LV_GetNext(), 1)
EditMod := [1, EBc]
LV_GetText(ENm, Row, 2)
LV_GetText(EBp, Row, 3)
LV_GetText(ESp, Row, 4)
GuiControl, Main:, Dbc, % EBc
GuiControl, Main:, Dnm, % ENm
GuiControl, Main:, Dbp, % EBp
GuiControl, Main:, Dsp, % ESp
Return
Calc:
Gui, Main:Submit, NoHide
GuiControl, Main:, Change
If GivenMoney is not Digit
{
ShakeControl("Main", GivenMoney)
} Else If (GivenMoney >= AllSum) {
GuiControl, Main:, Change, % GivenMoney - AllSum
}
Return
Valid:
FileCreateDir, % "Valid\" Now := A_Now
FileMove, % "Curr\*.db", % "Valid\" Now
Gui, Main:Default
LV_Delete()
GuiControl, Main:Disabled, EnsBtn
GuiControl, Main:, Sold
GuiControl, Main:, Bought
GuiControl, Main:, ProfitEq
Return
DisplayQn:
If (!DStatistic) {
LV_GetText(Sqn, Row := LV_GetNext(), 3)
LV_GetText(Snm, Row, 2)
LV_GetText(Sid, Row, 1)
LV_GetText(Ssum, Row, 4)
GuiControl, Main:, Pqn, % Sqn
GuiControl, Main:, Pnm, % Snm
GuiControl, Main:, Psum, % Ssum
SelectionQn := Sid
GuiControl, Main:Focus, Pqn
SelectAll(Pqn_)
EditStock := 1
}
Return
ClearDbc:
Gui, Main:Submit, NoHide
CtlColors.Change(Dbc_, "FFFFFF", "000000")
If (Dbc ~= "[^0-9A-Za-z]") {
CtlColors.Change(Dbc_, "FF8080", "000000")
ShakeControl("Main", "Dbc")
}
Return
ClearDnm:
Gui, Main:Submit, NoHide
CtlColors.Change(Dnm_, "FFFFFF", "000000")
If (Dnm ~= "\[|\]|\;|\$|\||\/") {
CtlColors.Change(Dnm_, "FF8080", "000000")
ShakeControl("Main", "Dnm")
}
Return
ClearDbp:
Gui, Main:Submit, NoHide
CtlColors.Change(Dbp_, "FFFFFF", "000000")
If (Dbp ~= "[^0-9]") {
CtlColors.Change(Dbp_, "FF8080", "000000")
ShakeControl("Main", "Dbp")
}
Return
ClearDsp:
Gui, Main:Submit, NoHide
CtlColors.Change(Dsp_, "FFFFFF", "000000")
If (Dsp ~= "[^0-9]") {
CtlColors.Change(Dsp_, "FF8080", "000000")
ShakeControl("Main", "Dsp")
}
Return
#If WinActive("ahk_id " Main)
^s::
If (RMS="#3") {
Gui, Main:Submit, NoHide
Gui, Main:Default
If (Row := LV_GetNext()) {
NRow := 0, TmpArr := []
While (NRow != Row) {
If (A_Index = 1)
NRow := Row
If (NRow) {
LV_GetText(Bc, NRow, 1)
TmpArr.Push(Bc)
}
NRow := LV_GetNext(NRow)
}
If (TmpArr.MaxIndex() >= 2) {
NotAlreadyDefined := 1
For All, Things in TmpArr {
If (ProdDefs["" Things ""][5]) {
NotAlreadyDefined := 0
Break
}
}
StockedTogether := ""
If (NotAlreadyDefined) {
SetQn := ProdDefs["" TmpArr[1] ""][4] ? ProdDefs["" TmpArr[1] ""][4] : 0
For Each, One in TmpArr {
StockedTogether .= "| " ProdDefs["" One ""][1] " |"
ProdDefs["" One ""][4] := SetQn
ProdDefs["" One ""][5] := AllButThis(TmpArr, One)
}
MsgBox, 64, Applied, The next list of products are added to the same stock option:`n`n%StockedTogether%`n`nStock = %SetQn%
} Else {
For Each, One in TmpArr {
For _Each, _One in ProdDefs {
If InStr(_One[5], One) {
ProdDefs["" _Each ""][5] := RemoveBC(ProdDefs["" _Each ""][5], One)
}
}
ProdDefs["" One ""][5] := ""
StockedTogether .= "| " ProdDefs["" One ""][1] " |"
}
MsgBox, 64, Applied, The next list of products are removed from the same stock option:`n`n%StockedTogether%
}
UpdateProdDefs()
}
}
}
Return
#If
#If WinActive("ahk_id " Main)
Esc::
If (RMS="#1") {
GuiControlGet, Visi, Main:Visible, Nm
If (!Visi) {
GuiControl, Main:Hide, GivenMoney
GuiControl, Main:Hide, AllSum
GuiControl, Main:Hide, Change
GuiControl, Main:Hide, CB
GuiControl, Main:Show, Bc
GuiControl, Main:Show, Nm
GuiControl, Main:Show, Qn
GuiControl, Main:Show, Sum
GuiControl, Main:Show, Stck
}
}
Return
#If
#If WinActive("ahk_id " Main)
Right::
If (RMS="#1") {
Gui, Main:Submit, NoHide
Gui, Main:Default
Loop, Parse, % ",1,2,3,4,5,6", `,
GuiControl, Main:Enable, % "OpenSess" A_LoopField
If (SessionID != "OpenSess6") {
If RegExMatch(SessionID, "\d+", Mark) {
GuiControl, Main:Disabled, % "OpenSess" Mark + 1
SessionID := "OpenSess" Mark + 1
} Else {
GuiControl, Main:Disabled, % "OpenSess1"
SessionID := "OpenSess1"
}
} Else {
GuiControl, Main:Disabled, % "OpenSess"
SessionID := "OpenSess"
}
If FileExist("Dump\" SessionID ".db") {
RestoreSession(DB_Read("Dump\" SessionID ".db"))
} Else {
Loop, Parse, % StrReplace(MainCtrlList, "$"), `,
{
If (A_LoopField != "Qn")
GuiControl, Main:, % A_LoopField
Else
GuiControl, Main:, % A_LoopField, % "x1"
}
LV_Delete()
}
GuiControl, Main:Hide, GivenMoney
GuiControl, Main:Hide, AllSum
GuiControl, Main:Hide, Change
GuiControl, Main:Hide, CB
GuiControl, Main:Show, Bc
GuiControl, Main:Show, Nm
GuiControl, Main:Show, Qn
GuiControl, Main:Show, Sum
GuiControl, Main:Show, Stck
GuiControl, Main:Focus, Bc
} Else {
SendInput, {Right}
}
Sleep, 125
Return
#If
#If WinActive("ahk_id " Main)
Left::
If (RMS="#1") {
Gui, Main:Default
Gui, Main:Submit, NoHide
Loop, Parse, % ",1,2,3,4,5,6", `,
GuiControl, Main:Enable, % "OpenSess" A_LoopField
If (SessionID != "OpenSess") {
RegExMatch(SessionID, "\d+", Mark)
If (Mark > 1) {
GuiControl, Main:Disabled, % "OpenSess" Mark - 1
SessionID := "OpenSess" Mark - 1
} Else {
GuiControl, Main:Disabled, % "OpenSess"
SessionID := "OpenSess"
}
} Else {
GuiControl, Main:Disabled, % "OpenSess6"
SessionID := "OpenSess6"
}
If FileExist("Dump\" SessionID ".db")
RestoreSession(DB_Read("Dump\" SessionID ".db"))
Else {
Loop, Parse, % StrReplace(MainCtrlList, "$"), `,
{
If (A_LoopField != "Qn")
GuiControl, Main:, % A_LoopField
Else
GuiControl, Main:, % A_LoopField, % "x1"
}
LV_Delete()
}
GuiControl, Main:Hide, GivenMoney
GuiControl, Main:Hide, AllSum
GuiControl, Main:Hide, Change
GuiControl, Main:Hide, CB
GuiControl, Main:Show, Bc
GuiControl, Main:Show, Nm
GuiControl, Main:Show, Qn
GuiControl, Main:Show, Sum
GuiControl, Main:Show, Stck
GuiControl, Main:Focus, Bc
} Else {
SendInput, {Left}
}
Sleep, 125
Return
#If
#If WinActive("ahk_id " Main) && (Level = "Admin")
Tab::
If (RMS = "#1") {
If (HLM := !HLM) {
Loop, Parse, % "ItemsSold,SoldP,ProfitP", `,
GuiControl, Main:Show, % A_LoopField
} Else {
Loop, Parse, % "ItemsSold,SoldP,ProfitP", `,
GuiControl, Main:Hide, % A_LoopField
}
} Else If (RMS = "#2") {
If (HLM := !HLM) {
Loop, Parse, % "Sold,Bought,ProfitEq", `,
GuiControl, Main:Show, % A_LoopField
} Else {
Loop, Parse, % "Sold,Bought,ProfitEq", `,
GuiControl, Main:Hide, % A_LoopField
}
} Else {
SendInput, {Tab}
}
Sleep, 125
Return
#If
#If WinActive("ahk_id " Main) or WinActive("ahk_id " Kr)
Enter::
If WinActive("ahk_id " Main) {
Gui, Main:Submit, NoHide
Gui, Main:Default
If (RMS = "#-1") {
If (Pass) {
If (EPassString) && (!ADMUsername) {
ADMUsername := EPassString
EPassString := ""
GuiControl, Main:, PassString, Create ADM password
GuiControl, Main:, EPassString
}
If (EPassString) && (!ADMPassword) {
ADMPassword := EPassString
If !FileExist("Sets\Lc.lic")
DB_Write("Sets\Lc.lic", UUID() ";" ADMUsername ";" ADMPassword)
Else {
LC := DB_Read("Sets\Lc.lic")
LC := StrSplit(LC, ";")
If (Encode(UUID()) != LC[1])
DB_Write("Sets\Lc.lic", UUID() ";" ADMUsername ";" ADMPassword)
}
GuiControl, Main:Hide, LicPic
GuiControl, Main:Hide, EPassString
GuiControl, Main:Hide, PassString
Reload
}
}
} Else If (RMS = "#0") {
Level := ""
If (!TU) {
ShakeControl("Main", "TU")
Return
}
If (!TP) {
ShakeControl("Main", "TP")
Return
}
EverythingSetting := StrSplit(DB_Read("Sets\Lc.lic"), ";")
If (TU == EverythingSetting[2]) && (TP == EverythingSetting[3]) {
GuiControl, Main:Hide, TU
GuiControl, Main:+ReadOnly -Password, TP
CtlColors.Change(TP_, "80FF80", "008000")
GuiControl, Main:, TP, % TU
GuiControl, Main:, TU, % TP
GuiControl, Main:Show, Reload
Level := "Admin"
RMS := "#0.1"
SaveLogIn()
Gosub, Continue
} Else {
If (OtherUsers := EverythingSetting[4]) {
LOGSArray := {}
Loop, % EverythingSetting.MaxIndex() - 3 {
UP := StrSplit(EverythingSetting[A_Index + 3], "/")
LOGSArray["" UP[1] ""] := "" UP[2] ""
}
If (LOGSArray["" TU ""] == TP) {
GuiControl, Main:Hide, TU
GuiControl, Main:+ReadOnly -Password, TP
CtlColors.Change(TP_, "80FF80", "008000")
GuiControl, Main:, TP, % TU
GuiControl, Main:, TU, % TP
GuiControl, Main:Show, Reload
Level := "User"
RMS := "#0.1"
SaveLogIn()
Gosub, Continue
}
}
}
} Else If (RMS = "#1") {
GuiControl, Main:Disabled, Bc
GuiControlGet, Visi, Main:Visible, Nm
If (Visi) {
GuiControl, Main:, Bc, % Bc "."
Bc := Bc "."
Loop, Parse, % Trim(Bc, "."), % "."
{
If (ProdDefs["" A_LoopField ""][1] != "") {
ThisQ := StrSplit(Qn, "x")[2]
JobDone := 0
Loop, % LV_GetCount() {
LV_GetText(ThisBc, A_Index, 1)
If (ThisBc = A_LoopField) {
LV_GetText(ThisQn, A_Index, 4)
ThisQn := StrSplit(ThisQn, "x")
LV_Modify(A_Index,,, ProdDefs["" A_LoopField ""][4] " --> " ProdDefs["" A_LoopField ""][4] - (ThisQn[2] + ThisQ),, ProdDefs["" A_LoopField ""][3] "x" ThisQn[2] + ThisQ, ProdDefs["" A_LoopField ""][3] * (ThisQn[2] + ThisQ))
JobDone := 1
Break
}
}
If (!JobDone)
LV_Add("", A_LoopField, ProdDefs["" A_LoopField ""][4] " --> " ProdDefs["" A_LoopField ""][4] - ThisQ, ProdDefs["" A_LoopField ""][1], ProdDefs["" A_LoopField ""][3] "x" ThisQ, ProdDefs["" A_LoopField ""][3]*ThisQ)
GuiControl, Main:, Bc
}
}
GuiControl, Main:, Bc
GuiControl, Main:, Qn, x1
} Else {
GuiControlGet, Visi, Main:Visible, CB
If (Visi) {
Gui, Main:Submit, NoHide
Bc := SubStr(CB, InStr(CB, " ",, 0) + 1)
GuiControl, Main:, Bc, % Trim(Bc, "[]")
} Else {
If (GivenMoney) && (Change = "") {
ShakeControl("Main", "GivenMoney")
Return
}
DB_Write(_This := "Curr\" A_Now ".db", TP "|" Sum_Data[2])
Arr := StrSplit(Trim(StrSplit(Sum_Data[2], "> ")[2], "|"), "|")
For Each, SO in Arr {
ThisArr := StrSplit(SO, ";")
ThisBc := ThisArr[1]
ThisQn := StrSplit(ThisArr[3], "x")[2]
ProdDefs["" ThisBc ""][4] := ProdDefs["" ThisBc ""][4] - ThisQn
If (ProdDefs["" ThisBc ""][5]) {
For Other, Bcs in StrSplit(ProdDefs["" ThisBc ""][5], "/") {
ProdDefs["" Bcs ""][4] := ProdDefs["" Bcs ""][4] - ThisQn
}
}
}
UpdateProdDefs()
GuiControl, Main:, AllSum
GuiControl, Main:, Change
GuiControl, Main:Hide, GivenMoney
GuiControl, Main:Hide, AllSum
GuiControl, Main:Hide, Change
GuiControl, Main:Show, Bc
GuiControl, Main:Show, Nm
GuiControl, Main:Show, Qn
GuiControl, Main:Show, Sum
GuiControl, Main:Show, Stck
GuiControl, Main:, Bc
GuiControl, Main:, Nm
GuiControl, Main:, Qn, x1
GuiControl, Main:, Sum
LV_Delete()
GuiControl, Main:Focus, Bc
If FileExist("Dump\" SessionID ".db")
FileDelete, % "Dump\" SessionID ".db"
If (!GivenMoney) {
LoadKridiUsers()
Gui, Kridi:Show,, % _34
GuiControl, Kridi:Focus, KName
}
GuiControl, Main:, GivenMoney
}
}
CheckListSum()
GuiControl, Main:Enabled, Bc
If !WinActive("ahk_id " Kr) {
GuiControl, Main:Focus, Bc
}
} Else If (RMS = "#3") {
Filled := (Dbc) && (Dnm) && (Dbp) && (Dsp)
If (Filled) {
If (Dbc ~= "[^0-9A-Za-z]") {
ShakeControl("Main", "Dbc")
Return
}
If (Dnm ~= "\[|\]|\;|\$|\||\/") {
ShakeControl("Main", "Dnm")
Return
}
If (Dbp ~= "[^0-9]") {
ShakeControl("Main", "Dbp")
Return
}
If (Dsp ~= "[^0-9]") {
ShakeControl("Main", "Dsp")
Return
}
GuiControl, Main:Disabled, Dbc
GuiControl, Main:Disabled, Dnm
GuiControl, Main:Disabled, Dbp
GuiControl, Main:Disabled, Dsp
If (!EditMod[1]) {
If (ProdDefs["" Dbc ""][1] = "") {
ProdDefs["" Dbc ""] := [Dnm,Dbp,Dsp,0,ProdDefs["" Dbc ""][5]]
UpdateProdDefs()
LoadDefined()
GuiControl, Main:, Dbc
GuiControl, Main:, Dnm
GuiControl, Main:, Dbp
GuiControl, Main:, Dsp
GuiControl, Main:Focus, Dbc
} Else {
LV_Modify(0, "-Select")
Loop, % LV_GetCount() {
LV_GetText(ThisBar, A_Index, 1)
If (ThisBar = Dbc) {
GuiControl, Main:Focus, LV2
SendInput, {Home}
Loop, % A_Index - 1
SendInput, {Down}
Break
}
}
}
} Else {
Temp := ProdDefs.Clone()
If (Dbc = EditMod[2])
Temp.Remove("" Dbc "")
If (Temp["" Dbc ""][1] = "") {
Modify := 0
Loop, % LV_GetCount() {
LV_GetText(ThisBar, A_Index, 1)
If (ThisBar = Dbc) {
Modify := 1
ProdDefs["" Dbc ""] := [Dnm,Dbp,Dsp,0,ProdDefs["" Dbc ""][5]]
LV_Modify(A_Index, "Select")
Break
}
}
If (!Modify) {
Loop, % LV_GetCount() {
LV_GetText(ThisBar, A_Index, 1)
If (ThisBar = EditMod[2]) {
Modify := 1
ProdDefs.Delete("" EditMod[2] "")
ProdDefs["" Dbc ""] := [Dnm,Dbp,Dsp,0,ProdDefs["" Dbc ""][5]]
GuiControl, Main:Focus, LV2
SendInput, {Home}
Loop, % A_Index - 1
SendInput, {Down}
Break
}
}
}
If (Modify) {
UpdateProdDefs()
LV_Modify(LV_GetNext(),, Dbc, Dnm, Dbp, Dsp)
LoadDefined()
Loop, % LV_GetCount() {
LV_GetText(ThisBar, A_Index, 1)
If (ThisBar = Dbc){
GuiControl, Main:Focus, LV2
SendInput, {Home}
Loop, % A_Index - 1
SendInput, {Down}
Break
}
}
GuiControl, Main:, Dbc
GuiControl, Main:, Dnm
GuiControl, Main:, Dbp
GuiControl, Main:, Dsp
}
EditMod[1] := 0
} Else {
Loop, % LV_GetCount() {
LV_GetText(ThisBar, A_Index, 1)
If (ThisBar = Dbc) {
GuiControl, Main:Focus, LV2
SendInput, {Home}
Loop, % A_Index - 1
SendInput, {Down}
Break
}
}
}
GuiControl, Main:Focus, LV2
}
GuiControl, Main:Enabled, Dbc
GuiControl, Main:Enabled, Dnm
GuiControl, Main:Enabled, Dbp
GuiControl, Main:Enabled, Dsp
}
} Else If (RMS = "#4") {
GuiControlGet, ThisFocus, Main:FocusV
If (!DStatistic) {
If (ThisFocus = "Pnm") {
If (Pnm != "") && (ProdDefs["" Pnm ""][1]) {
Loop, % LV_GetCount() {
LV_GetText(ThisBc, A_Index, 1)
If (ThisBc = Pnm) {
LV_Modify(A_Index, "Select")
GuiControl, Main:Focus, LV3
SendInput, {Home}
Loop, % A_Index - 1
SendInput, {Down}
Gosub, DisplayQn
Break
}
}
}
} Else If (ThisFocus = "Pqn") {
If (Pnm != "") && (Pqn != "") {
If Pqn is Digit
{
LV_GetText(BcId, Row, 1)
ProdDefs["" BcId ""][4] := Pqn
DB_Write(ThisN := "Stoc\" A_Now ".db", NowCh := BcId "|" Pqn "|" ProdDefs["" BcId ""][5])
LoadStockChanges(ThisN)
If (ProdDefs["" BcId ""][5]) {
OtherStc := ""
For Other, Bcs in StrSplit(ProdDefs["" BcId ""][5], "/") {
ProdDefs["" Bcs ""][4] := Pqn
OtherStc .= Bcs "|" Pqn "."
}
}
UpdateProdDefs()
LoadStockList()
}
}
}
} Else If (ThisFocus = "Pnm") {
Loop, % LV_GetCount() {
LV_GetText(ThisBc, A_Index, 1)
If (ThisBc = Pnm) {
LV_Modify(A_Index, "Select")
GuiControl, Main:Focus, LV3
Break
}
}
}
} Else If (RMS = "#5") {
GoSub, DisplayEqProfit
} Else If (RMS = "#6") {
If (UserName) && (UserPass) {
If (UserName ~= ";|\||\/") {
ShakeControl("Main", UserName)
Return
}
If (UserPass ~= ";|\||\/") {
ShakeControl("Main", UserPass)
Return
}
If !InStr(CollectData := DB_Read("Sets\Lc.lic"), ";" UserName "/") {
DB_Write("Sets\Lc.lic", CollectData ";" UserName "/" UserPass)
LoadAccounts()
}
}
} Else If (RMS = "#7") {
If (Change != "") {
FileRemoveDir, % "Kr\" ThisKLB, 1
GuiControl, Main:, GivenMoney
GuiControl, Main:, AllSum
GuiControl, Main:, Change
GuiControl, Main:Hide, GivenMoney
GuiControl, Main:Hide, AllSum
GuiControl, Main:Hide, Change
LoadKridis()
}
} Else {
SendInput, {Enter}
}
} Else If WinActive("ahk_id " Kr) {
Gui, Kridi:Show
Gui, Kridi:Submit, NoHide
If (KName ~= "[^A-Za-z0-9]") {
ShakeControl("Kridi", KName)
} Else {
EncVal := EncodeAlpha(KName)
If !InStr(FileExist("Kr\" EncVal), "D") {
FileCreateDir, % "Kr\" EncVal
}
FileCopy, % _This, % "Kr\" EncVal
GuiControl, Kridi:, KName
Gui, Kridi:Hide
GuiControl, Main:Focus, Bc
}
}
Sleep, 125
Return
#If
#If WinActive("ahk_id " Main)
Up::
Gui, Main:Submit, NoHide
Gui, Main:Default
If (RMS = "#1") {
GuiControlGet, Focused, Main:FocusV
If (Focused = "LV0") {
Row := LV_GetNext()
If (Row) {
LV_GetText(ThisQn, Row, 4)
LV_GetText(ThisBc, Row, 1)
VQ := StrSplit(ThisQn, "x")
LV_Modify(Row,,, ProdDefs["" ThisBc ""][4] " --> " ProdDefs["" ThisBc ""][4] - (VQ[2] + 1),, VQ[1] "x" VQ[2] + 1, VQ[1] * (VQ[2] + 1))
}
} Else {
If (LastR := LV_GetCount()) {
LV_GetText(ThisQn, LastR, 4)
LV_GetText(ThisBc, LastR, 1)
VQ := StrSplit(ThisQn, "x")
LV_Modify(LastR,,, ProdDefs["" ThisBc ""][4] " --> " ProdDefs["" ThisBc ""][4] - (VQ[2] + 1),, VQ[1] "x" VQ[2] + 1, VQ[1] * (VQ[2] + 1))
} Else {
_Qn := SubStr(Qn, 1, InStr(Qn, "x") - 1)
Qn := SubStr(Qn, InStr(Qn, "x") + 1)
GuiControl, Main:, Qn, % _Qn "x" Qn += 1
}
}
CreateNew("Bc,Nm,Qn,Sum,ThisListSum", "LV0")
CheckListSum()
} Else {
SendInput, {Up}
}
Sleep, 125
Return
#If
#If WinActive("ahk_id " Main)
Down::
Gui, Main:Submit, NoHide
Gui, Main:Default
If (RMS = "#1") {
GuiControlGet, Focused, Main:FocusV
If (Focused = "LV0") {
Row := LV_GetNext()
If (Row) {
LV_GetText(ThisQn, Row, 4)
LV_GetText(ThisBc, Row, 1)
VQ := StrSplit(ThisQn, "x")
If (VQ[2] > 1) {
LV_Modify(Row,,, ProdDefs["" ThisBc ""][4] " --> " ProdDefs["" ThisBc ""][4] - (VQ[2] - 1),, VQ[1] "x" VQ[2] - 1, VQ[1] * (VQ[2] - 1))
}
}
} Else {
If (LastR := LV_GetCount()) {
LV_GetText(ThisQn, LastR, 4)
LV_GetText(ThisBc, LastR, 1)
VQ := StrSplit(ThisQn, "x")
If (VQ[2] > 1) {
LV_Modify(LastR,,, ProdDefs["" ThisBc ""][4] " --> " ProdDefs["" ThisBc ""][4] - (VQ[2] - 1),, VQ[1] "x" VQ[2] - 1, VQ[1] * (VQ[2] - 1))
}
} Else {
_Qn := SubStr(Qn, 1, InStr(Qn, "x") - 1)
Qn := SubStr(Qn, InStr(Qn, "x") + 1)
If (Qn > 1)
GuiControl, Main:, Qn, % _Qn "x" Qn -= 1
}
}
CreateNew("Bc,Nm,Qn,Sum,ThisListSum", "LV0")
CheckListSum()
} Else {
SendInput, {Down}
}
Sleep, 125
Return
#If
#If WinActive("ahk_id " Main)
Delete::
Gui, Main:Default
Gui, Main:Submit, NoHide
If (RMS = "#1") {
LV_Delete(LV_GetNext())
CreateNew("Bc,Nm,Qn,Sum,ThisListSum", "LV0")
CheckListSum()
} Else If (RMS = "#3") {
LV_GetText(ThisID, LV_GetNext(), 1)
ProdDefs.Delete("" ThisID "")
UpdateProdDefs()
LV_Delete(LV_GetNext())
} Else If (RMS = "#6") {
LV_GetText(Name, Row := LV_GetNext(), 1)
LV_GetText(Pass, Row, 2)
If InStr(US := DB_Read("Sets\Lc.lic"), Name "/" Pass) {
DB_Write("Sets\Lc.lic", StrReplace(US, ";" Name "/" Pass))
}
LoadAccounts()
} Else {
SendInput, {Delete}
}
Sleep, 125
Return
#If
#If WinActive("ahk_id " Main)
Space::
Gui, Main:Submit, NoHide
Gui, Main:Default
If (RMS = "#1") {
LV_GetText(Bcc, 1, 1)
If (Bcc) {
GuiControl, Main:Hide, Bc
GuiControl, Main:Hide, Nm
GuiControl, Main:Hide, Qn
GuiControl, Main:Hide, Sum
GuiControl, Main:Hide, Stck
GuiControl, Main:Show, GivenMoney
GuiControl, Main:Show, AllSum
GuiControl, Main:Show, Change
GuiControl, Main:, AllSum, % (Sum_Data := CalculateSum())[1]
GuiControl, Main:Focus, GivenMoney
}
CheckListSum()
} Else If (RMS = "#4") {
DStatistic := !DStatistic
GoSub, MainGuiSize
If (DStatistic) {
ThisLoaded := ""
Loop, Parse, % "Pqn,PSum,StockSum,$Add,$Sub", `,
{
If InStr(A_LoopField, "$") {
GuiControl, Main:Show, % SubStr(A_LoopField, 2)
} Else {
GuiControl, Main:Hide, % A_LoopField
}
}
} Else {
Loop, Parse, % "Pqn,PSum,StockSum,$Add,$Sub", `,
{
If InStr(A_LoopField, "$") {
GuiControl, Main:Hide, % SubStr(A_LoopField, 2)
} Else {
GuiControl, Main:Show, % A_LoopField
}
}
}
} Else If (RMS = "#7") {
LV_GetText(Bcc, 1, 1)
If (Bcc) {
GuiControl, Main:Show, GivenMoney
GuiControl, Main:Show, AllSum
GuiControl, Main:Show, Change
GuiControl, Main:, AllSum, % (Sum_Data := CalculateSum())[1]
GuiControl, Main:Focus, GivenMoney
}
CheckListSum()
} Else {
SendInput, {Space}
}
Sleep, 125
Return
#If
#If WinActive("ahk_id " Main)
^W::
DB_Write(A_Desktop "\genFILE.db", Clipboard)
Sleep, 125
Return
#If
#If WinActive("ahk_id " Main)
^F::
If (RMS = "#1") {
Gui, Main:Submit, NoHide
Gui, Main:Default
Lst := ""
For Every, One in ProdDefs {
If InStr(One[1], Bc)
(A_Index = 1) ? Lst .= One[1] " [" Every "]||" : Lst .= One[1] " [" Every "]|"
}
Lst := Trim(Lst, "|")
If (Lst) {
GuiControl, Main:, CB, % "|" Lst
GuiControl, Main:Focus, CB
GuiControl, Main:Show, CB
GuiControl, Main:Choose, CB, 1
}
} Else If (RMS = "#3") {
Gui, Main:Submit, NoHide
Gui, Main:Default
LV_Delete()
If (Dbc != "") || (Dnm != "") || (Dbp != "") || (Dsp != "") {
For Each, Item in ProdDefs {
If InStr(Each, Dbc) && InStr(Item[1], Dnm) && InStr(Item[2], Dbp) && InStr(Item[3], Dsp) {
LV_Add("", Each, Item[1], Item[2], Item[3])
}
}
} Else {
For Each, Item in ProdDefs {
LV_Add("", Each, Item[1], Item[2], Item[3])
}
}
} Else {
SendInput, ^F
}
Sleep, 125
Return
#If
AnalyzeAvail:
Gui, Main:Submit, NoHide
GuiControl, Main:Hide, CB
GuiControl, Main:, Stck
GuiControl, Main:, Nm
GuiControl, Main:, Sum
Value_Qn := StrSplit(Qn, "x")
GuiControl, Main:, Qn, % "x" Value_Qn[2]
If (Bc) {
If (ProdDefs["" Bc ""][1] != "") {
GuiControl, Main:, Nm, % ProdDefs["" Bc ""][1]
Value_Qn := StrSplit(Qn, "x")
GuiControl, Main:, Qn, % ProdDefs["" Bc ""][3] "x" Value_Qn[2]
GuiControl, Main:, Sum, % ProdDefs["" Bc ""][3] * Value_Qn[2]
GuiControl, Main:, Stck, % (ProdDefs["" Bc ""][4]) ? ProdDefs["" Bc ""][4] : 0
}
}
CreateNew("Bc,Nm,Qn,Sum,ThisListSum", "LV0")
Return
AnalyzeQn:
Gui, Main:Submit, NoHide
Value_Qn := StrSplit(Qn, "x")
If (Value_Qn[1]) && (Value_Qn[2]) {
GuiControl, Main:, Sum, % Value_Qn[1] * Value_Qn[2]
}
CreateNew("Bc,Nm,Qn,Sum,ThisListSum", "LV0")
Return
QuitMain:
Gui, Main:Destroy
Return
QuitDefiner:
Gui, Def:Destroy
Return
MainGuiClose:
If (MM) {
SetTimer, About, 0
Gui, About:Show
Loop, Parse, % "OpenMain,Submit,Define,Prof,Stockpile,Manage,Kridi", `,
GuiControl, Main:Show, %A_LoopField%
If (Level = "User") {
Loop, Parse, % "Submit,Define,Prof,Stockpile,Manage,Kridi", `,
{
GuiControlGet, Enb, Main:Enabled, % A_LoopField
If (Enb) {
GuiControl, Main:Disabled, % A_LoopField
}
GuiControlGet, Visi, Main:Visible, % A_LoopField
If (Visi) {
GuiControl, Main:Hide, % A_LoopField
}
}
}
OnMessage(0, "MouseHover")
Loop, Parse, % "1243567"
GuiControl, Main:Hide, Btn%A_LoopField%
Loop, Parse, % MainCtrlList "," EnsureCtrlList "," DefineCtrlList "," ProfitCtrlList "," StockPileCtrlList "." ManageCtrlList "," KridiCtrlList, `,
GuiControl, Main:Hide, % StrReplace(A_LoopField, "$")
SetTimer, Update, Off
MM := !MM
RMS := "#0.1"
Gui, Main:-Resize
Gui, Main:Show, % "w800 h400 Center"
Return
}
Quit:
SaveLogOut()
ExitApp
LoadCurrent() {
global
LV_Delete()
OAPr := 0, SPr := 0, CP := 0
Loop, Files, Curr\*.db
{
RD := DB_Read(A_LoopFileFullPath)
If (RD) {
SplitPath, % A_LoopFileName,,,, OutNameNoExt
FormatTime, ThisTime, % OutNameNoExt, yyyy/MM/dd HH:mm:ss
LV_Add("", A_LoopFileFullPath, ((RD ~= "\|\d+\/\d+\/\d+ \d+\:\d+\:\d+> ") ? SubStr(RD, 1, InStr(RD, "|") - 1) "|" : "") _19 ": " ThisTime)
Arr := CalcProfit(RD)
SPr := Arr[2][1] + SPr
CP := Arr[2][2] + CP
OAPr := Arr[2][3] + OAPr
}
}
If !LV_GetCount() {
GuiControl, Main:Disabled, EnsBtn
} Else {
GuiControl, Main:, ProfitEq, % OAPr
GuiControl, Main:, Sold, % SPr
GuiControl, Main:, Bought, % CP
}
}
GetBuyPriceByID(Data, TID) {
Loop, Parse, Data, |
{
If (SubStr(A_LoopField, 1, InStr(A_LoopField, ";") - 1) = TID) {
Return, StrSplit(A_LoopField, ";")[3]
}
}
Return, 0
}
CalcProfit(PData) {
TrArr := StrSplit(PData, "> ")
TimeDT := TrArr[1]
RArr := StrSplit(TrArr[3], ";")
Return, [TimeDT, [RArr[1], RArr[2], RArr[3]], StrSplit(StrSplit(TrArr[2], ";")[3], "x")[2]]
}
Correct(File) {
RD := DB_Read(File)
Arr := StrSplit(RD, "> ")
_DDS := StrSplit(Trim(Arr[2], "|"), "|")
NC := "", SP := BP := OA := 0
For Each, SO in _DDS {
DDS := StrSplit(SO, ";")
Bc := DDS[1]
If (ProdDefs["" Bc ""][1]) {
Qn := StrSplit(DDS[3], "x")[2]
SP += ProdDefs["" Bc ""][3] * Qn
BP += ProdDefs["" Bc ""][2] * Qn
NC .= Bc ";" ProdDefs["" Bc ""][1] ";" ProdDefs["" Bc ""][3] "x" Qn ";" SP ";" ProdDefs["" Bc ""][2] "x" Qn ";" BP ";" SP - BP "|"
OA += SP - BP
}
}
DB_Write(A_LoopFileFullPath, Arr[1] "> " NC "> " SP ";" BP ";" OA)
}
LoadProf() {
LV_Delete()
OAPr := 0, SPr := 0, CP := 0
GuiControl, Main:, OAProfit, % OAPr
GuiControl, Main:, SPr, % SPr
GuiControl, Main:, CPr, % CP
DayAgo := A_Now
DayAgo += -1, days
Loop, Files, Valid\*.db, R F
{
If (SubStr(A_LoopFileName, 1, StrLen(A_LoopFileName) - 3) >= DayAgo) {
RD := DB_Read(A_LoopFileFullPath)
If (RD) {
Arr := CalcProfit(RD)
If (!Arr[2][1]) || (!Arr[2][1]) || (!Arr[2][3]) {
MsgBox, % A_LoopFileFullPath, % "Corrupted file: " A_LoopFileFullPath " `n" ClipBoard := RD
} Else {
LV_Add("", A_LoopFileFullPath, Arr[1], "+ " Arr[2][1], "- " Arr[2][2], "+ " Arr[2][3])
SPr := Arr[2][1] + SPr
CP := Arr[2][2] + CP
OAPr := Arr[2][3] + OAPr
}
}
}
}
Loop, Files, Curr\*.db
{
If (SubStr(A_LoopFileName, 1, StrLen(A_LoopFileName) - 3) >= DayAgo) {
RD := DB_Read(A_LoopFileFullPath)
If (RD) {
Arr := CalcProfit(RD)
LV_Add("", A_LoopFileFullPath, Arr[1], "+ " Arr[2][1], "- " Arr[2][2], "+ " Arr[2][3])
SPr := Arr[2][1] + SPr
CP := Arr[2][2] + CP
OAPr := Arr[2][3] + OAPr
}
}
}
GuiControl, Main:, OAProfit, % OAPr
GuiControl, Main:, SPr, % SPr
GuiControl, Main:, CPr, % CP
}
LoadDefined() {
global
LV_Delete()
AllItems := ""
For Each, Item in ProdDefs {
AllItems .= Each ","
}
Sort, AllItems, N D,
Loop, Parse, % Trim(AllItems, ","), `,
LV_Add("", A_LoopField, ProdDefs["" A_LoopField ""][1], ProdDefs["" A_LoopField ""][2], ProdDefs["" A_LoopField ""][3])
LoadPrevPD()
}
LoadStockList() {
global
LV_Delete()
AllItems := ""
For Each, Item in ProdDefs {
AllItems .= Each ","
}
Sort, AllItems, N D,
Counted := OverAll := 0
Skipped := ""
Loop, Parse, % Trim(AllItems, ","), `,
{
If ValidPro(A_LoopField, ProdDefs["" A_LoopField ""][1], ProdDefs["" A_LoopField ""][2], ProdDefs["" A_LoopField ""][3]) {
LV_Add("", A_LoopField, ProdDefs["" A_LoopField ""][1], (ProdDefs["" A_LoopField ""][4] ? ProdDefs["" A_LoopField ""][4] : 0), Vale := ((ProdDefs["" A_LoopField ""][4] ? ProdDefs["" A_LoopField ""][4] : 0) "x" ProdDefs["" A_LoopField ""][2] " = " (ProdDefs["" A_LoopField ""][4] ? ProdDefs["" A_LoopField ""][4] : 0) * ProdDefs["" A_LoopField ""][2]))
If (!InStr(Skipped, "/" A_LoopField) && !InStr(Skipped, A_LoopField "/")) {
OverAll := OverAll + (ProdDefs["" A_LoopField ""][4] * ProdDefs["" A_LoopField ""][2])
} Else {
LV_Modify(A_Index,,,,, Vale " [Skipped]")
}
If (ProdDefs["" A_LoopField ""][5]) {
Skipped .= ProdDefs["" A_LoopField ""][5] "/"
}
Counted := Counted + 1
}
}
If (OverAll) && (Counted)
GuiControl, Main:, StockSum, % OverAll " | [" Counted "]"
Else
GuiControl, Main:, StockSum, % "---"
GuiControl, Main:, Pqn
GuiControl, Main:, Psum
GuiControl, Main:Focus, Pnm
SelectAll(Pnm_)
}
ValidPro(_1, _2, _3, _4) {
Rs := 1
If (_1 = "") || (_2 = "") || (_3 _4 ~= "[^0-9]")
Rs := 0
Return, Rs
}
LoadInterfaceLng() {
global
IniRead, LngSection, Setting.ini, UseLng, Use
IniRead, StrList, Setting.ini, %LngSection%
Loop, Parse, StrList, `n, `r
{
ID_Val := StrSplit(A_LoopField, "=")
ID := ID_Val[1], Val := ID_Val[2]
_%ID% := Val
}
}
Version() {
IniRead, Version, Setting.ini, Version, AppVer
Return, Version
}
UUID() {
For obj in ComObjGet("winmgmts:{impersonationLevel=impersonate}!\\" . A_ComputerName . "\root\cimv2").ExecQuery("Select * From Win32_ComputerSystemProduct")
return, obj.UUID
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
Decode(string) {
if !(DllCall("crypt32\CryptStringToBinary", "ptr", &string, "uint", 0, "uint", 0x1, "ptr", 0, "uint*", size, "ptr", 0, "ptr", 0))
Return
VarSetCapacity(buf, size, 0)
if !(DllCall("crypt32\CryptStringToBinary", "ptr", &string, "uint", 0, "uint", 0x1, "ptr", &buf, "uint*", size, "ptr", 0, "ptr", 0))
Return
return, StrGet(&buf, size, "UTF-8")
}
ShakeControl(GUINm, ControlID) {
GuiControlGet, GotPos, %GUINm%:Pos, %ControlID%
GuiControl, %GUINm%: Move, %ControlID%, % "x" GotPosX - 1
Loop, 10 {
GuiControl, %GUINm%: Move, %ControlID%, % "x" GotPosX + 2
Sleep, 25
GuiControl, %GUINm%: Move, %ControlID%, % "x" GotPosX - 2
Sleep, 25
}
GuiControl, %GUINm%: Move, %ControlID%, % "x" GotPosX
}
CalculateSum() {
global
Cost := Sum := 0
FormatTime, OutTime, % A_Now, yyyy/MM/dd HH:mm:ss
Data := OutTime "> "
Loop, % LV_GetCount() {
LV_GetText(ThisSum, A_Index, 5)
Sum += ThisSum
LV_GetText(Bc, A_Index, 1)
LV_GetText(Nm, A_Index, 3)
LV_GetText(Qn, A_Index, 4)
BP := ProdDefs["" Bc ""][2]
Qn_ := SubStr(Qn, InStr(Qn, "x") + 1)
ThisCost := BP * Qn_
Cost += ThisCost
Data .= Bc ";" Nm ";" Qn ";" ThisSum ";" BP "x" Qn_ ";" ThisCost ";" ThisSum - ThisCost "|"
}
Data .= "> " Sum ";" Cost ";" Sum - Cost
Return, [Sum, Trim(Data, "|"), OutTime]
}
DB_Write(FileName, Info) {
SetTimer, Update, Off
If InStr(FileName, "\PD.db") && (RMS = "#3" || RMS = "#5")
FileCopy, % FileName, % "Sets\Bu\" A_Now ".Bu"
DBObj := FileOpen(FileName, "w")
Loop, Parse, % "CH-26259084-DB"
DBObj.WriteChar(Asc(A_LoopField))
Loop, 1010
DBObj.WriteChar(0)
Loop, Parse, % Encode(Info)
DBObj.WriteChar(Asc(A_LoopField))
Loop, 1024
DBObj.WriteChar(0)
DBObj.Close()
SetTimer, Update, On
}
DB_Read(FileName) {
SetTimer, Update, Off
DBObj := FileOpen(FileName, "r")
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
SetTimer, Update, On
Return, Decode(Info)
}
Hide(ListCtrl) {
Loaded := 0
Loop, Parse, ListCtrl, `,
{
GuiControl, Main:Hide, % StrReplace(A_LoopField, "$")
}
}
Show(ListCtrl) {
global
Loaded := 0
WinGetPos,,, Width,, % "ahk_id " Main
Loop, Parse, ListCtrl, `,
{
If !InStr(A_LoopField, "$") {
GuiControlGet, Post, Main:Pos, % A_LoopField
GuiControl, Main:Move, % A_LoopField, % "x" PostX + Width
GuiControl, Main:Show, % A_LoopField
}
LT := Width // 4, J := 4
If !InStr(A_LoopField, "OpenSess") {
Loop, % LT {
If !InStr(A_LoopField, "$") {
GuiControlGet, Post, Main:Pos, % A_LoopField
GuiControl, Main:Move, % A_LoopField, % "x" PostX - J
}
}
} Else {
Loop, % LT // 2 {
If !InStr(A_LoopField, "$") {
GuiControlGet, Post, Main:Pos, % A_LoopField
GuiControl, Main:Move, % A_LoopField, % "x" PostX - J * 2
}
}
}
}
Loaded := 1
}
CheckLicense() {
If !FileExist("Sets\Lc.lic")
Return, 0
LC := DB_Read("Sets\Lc.lic")
LC := StrSplit(LC, ";")
If (UUID() != LC[1])
Return, 0
Return, 1
}
CheckFoldersSet() {
Folders := "Curr,Lib,Sets,Sets\Bu,Stoc,Valid,Dump,Kr,Log"
Loop, Parse, Folders, `,
{
If !InStr(FileExist(A_LoopField), "D") {
FileCreateDir, % A_LoopField
}
}
}
LoadBackground() {
global
Loop, Files, % "Img\Prt*.png"
{
Name := SubStr(A_LoopFileName, 1, StrLen(A_LoopFileName) - 4)
Set := StrSplit(Name, "_")
PosArr := StrSplit(Set[2], "x")
DemArr := StrSplit(Set[3], "x")
Gui, Main:Add, Picture, % "x" PosArr[1] " y" PosArr[2] " w" DemArr[1] " h" DemArr[2] " v" Set[1], % "Img\" A_LoopFileName
}
}
RemoveFromStock(BC, QN) {
ProdDefs["" BC ""][4] := ProdDefs["" BC ""][4] - QN
UpdateProdDefs()
}
RandomHexColor() {
global
Frag := Seq := ""
Loop, 3 {
Random, Bol, 0, 1
If (Bol) {
Random, Int, 0, 9
Random, Bol, 0, 1
If (Bol) {
Random, AInt, 1, 6
Random, Bol, 0, 1
If (Bol)
Frag := Int Table[AInt]
Else
Frag := Table[AInt] Int
} Else {
Random, _Int, 0, 9
Random, Bol, 0, 1
If (Bol)
Frag := Int _Int
Else
Frag := _Int Int
}
} Else {
Random, AInt, 1, 6
Random, Bol, 0, 1
If (Bol) {
Random, Int, 1, 6
Random, Bol, 0, 1
If (Bol)
Frag := Int Table[AInt]
Else
Frag := Table[AInt] Int
} Else {
Random, _AInt, 1, 6
Random, Bol, 0, 1
If (Bol)
Frag := AInt _AInt
Else
Frag := _AInt AInt
}
}
Seq .= Frag
}
Return, Seq
}
CreateNew(Controls, LV := "", Clear := 0) {
global
Gui, Main:Default
Gui, Main:ListView, LV0
List_ := ""
Loop, Parse, Controls, `,
{
GuiControlGet, Content, Main:, % A_LoopField
List_ .= A_LoopField "=" Content ";"
}
LV_ := "|"
If (LV) {
Loop, % LV_GetCount() {
LV_GetText(Bc__, A_Index, 1)
LV_GetText(QnBA__, A_Index, 2)
LV_GetText(Nm__, A_Index, 3)
LV_GetText(Qn__, A_Index, 4)
LV_GetText(Sum__, A_Index, 5)
LV_ .= Bc__ "/" QnBA__ "/" Nm__ "/" Qn__ "/" Sum__ "|"
}
}
If (LV_ = "|")
LV_ := ""
DB_Write("Dump\" SessionID ".db", Trim(List_, ";") LV_)
If (Clear) {
LV_Delete()
Loop, Parse, Controls, `,
{
If (A_LoopField != "Qn")
GuiControl, Main:, % A_LoopField
Else
GuiControl, Main:, % A_LoopField, % "x1"
}
}
}
RestoreSession(Data) {
global
Gui, Main:Default
ArrayData := StrSplit(Data, ";")
LV_Delete()
For Each, Item in ArrayData {
If !InStr(Item, "|") {
CtlVal := StrSplit(Item, "=")
GuiControl, Main:, % CtlVal[1], % CtlVal[2]
} Else {
Loop, Parse, % Trim(Item, "|"), |
{
If (A_Index > 1) {
CtlVals := StrSplit(A_LoopField, "/")
LV_Add("", CtlVals[1], CtlVals[2], CtlVals[3], CtlVals[4], CtlVals[5])
}
}
}
}
CheckListSum()
}
LoadDefinitions(Data) {
Tmp := {}
Loop, Parse, % Trim(Data, "|"), |
{
ThisDef := StrSplit(A_LoopField, ";")
Tmp["" ThisDef[1] ""] := [ThisDef[2], ThisDef[3], ThisDef[4], ThisDef[5], ThisDef[6] ? ThisDef[6] : ""]
}
Return, Tmp
}
CheckForUpdates() {
global
GuiControl, Startup:, Stat, % _23
JsonKey := "{"
. "`n ""type"": ""service_account"","
. "`n ""project_id"": ""cassier"","
. "`n ""private_key_id"": ""a4dcb0edcb51cfb9109fffcaf9087ad77d5b89ed"","
. "`n ""private_key"": ""-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQC1025anDEc9hjY\nRlaQaJ6azis+uYSbl52g4S2beQ8L0CWy3ODiECrXGclV+KuHULDQGZcqKL1zDPZ4\n2P/77Et6Mr+tUqMBfV3AgWbNsvF0zfpv8c7/Oa068wV9vlzRckZK9fSJ19kdxYlf\ns7ZxeJiYndo1WD17ZUh0WElMO7eGQN7Ntgjj5Zkn5ARpBUlCVo5Ou2YItaLz0jty\nuA762PVW+GK0kv5vfXLbPNHZ35VY0RbaIPakEaeQKEC0lRNv1omiQV8DwkqPjNLD\nkCFfV2yQ+cNUNhv610r1Z79gPIcC2+bNg3DiFXuyE5iU6p78wpdZhLChYx7rVjrA\nE8sG1QrJAgMBAAECggEAEAiWCk+l29yhrtSioB2LOuU9fMyY/0Vv5RAzC6r+fJEW\nxr57TPcvzlCb55GQwqAHCQ3wpAsvclx59+8ewThovkMiXuZsffgJn+BpUDzcb1Hi\nKL2LsaFRTGNb7RovwiWcqDiNhbUIeshNoShOSS3hIVG6770ZWTvCfcWMdR7HXYNN\nqfb3CKlWw8eFfnrOu5nnuUcouSIPu9Neow7rXT5xZGQpNQ3AbhacHVXf7LMCXUKH\nKsWi5n+/QsYiuX+R9avksI81/14Pt1FZI8+dUVZj17exSlz8WOGF91CPEAQxIuxv\nDOxBYIOQFCKoJU22baymuGO7g86WO9I9d9uyb8dwJwKBgQDuu8+RA9OHnP+TFViw\nT3TD+VtQz5HWeW5dpLHp6rTOZLe2CBnzORYMPbZPni4Oqo0G5NEBtdiRWEj43Sjx\nK/Xpyar/Vzj0jMkHpFHmsjrZtblTdl0L94iGgfPuCrU3er4P073TjZuhJQoazZSn\n8PUMR8uGoncd431O/CAOI9HR0wKBgQDC+fcLYozcNR18XsQopSxtHCuTs7Gy1bWY\n2ZePMnr5R0eJSKQoycjXkDAaiujGjyWtbVzsgzBrZsmy7MYoPlQ733wIKSJPOI1w\nExysKy6fEabn3b8/+bEmccE04FCXjMuzL2cYzUqXza7waMDl3RixvBkks1LX6vCe\n4NTKsyZzcwKBgHsExpn4eckZCs3VIyV/XDEcToTe4Uy+uDODCbb7Hf55Af3IQO8H\njKf0KPzwCtW95vwVbupNtXJ4JuoutMlKGOdG51m6rXu/DFxmvVl+oDrNnNk4Vgwz\nmuONFZClbepP0p6/QsM/5mFsf79+DktYLD4OxP70uyLotgq8exwuMxHHAoGAFboT\nHHKr7bIBiiVpSHo3fCUiegARMjN8W/8LU4q1h2e5AgRVPrJVrifEJIEMNWwoL647\nJ6Pq1l0K5uRZpIxliJJ72ND0oM1VfYKztD/PnywxZC8iq7dgVT9h30mL0Yd//4St\nwWbHBCmIcAPMUxETOmMSjjNpbOQiUiINtFTIWR8CgYAUCKpuI3Azrj12mQiWl4gB\npKf9ejar0BZI6wnPkw+kiBz69arPSImQ2kmD/1zNr2T/ls+BJtaBC8pT4DsY9R/t\no+lOahSqIv9FTl0BpzFUq7oYcV6a0J4OwMYDofMrOii/qlLK3o1OMV8Kj9UfjZg7\nIv1i7pY9Baq81qbosT+cJQ==\n-----END PRIVATE KEY-----\n"","
. "`n ""client_email"": ""firebase-adminsdk-nwpgf@cassier.iam.gserviceaccount.com"","
. "`n ""client_id"": ""112531104458713251383"","
. "`n ""auth_uri"": ""https://accounts.google.com/o/oauth2/auth"","
. "`n ""token_uri"": ""https://oauth2.googleapis.com/token"","
. "`n ""auth_provider_x509_cert_url"": ""https://www.googleapis.com/oauth2/v1/certs"","
. "`n ""client_x509_cert_url"": ""https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-nwpgf`%40cassier.iam.gserviceaccount.com"""
. "`n}"
SetWorkingDir, Update
If FileExist("LogKey.Json")
FileDelete, LogKey.Json
FileAppend, % JsonKey, LogKey.Json
RunWait, Updater.exe r "AppVer",, Hide
FileDelete, LogKey.Json
Lastest := ""
FileRead, Lastest, Version.txt
If (!Lastest)
Return
FileDelete, Version.txt
SetWorkingDir, % A_ScriptDir
If !InStr(Lastest, ".")
Lastest := Lastest ".0"
IniRead, Current, Setting.ini, Version, AppVer
If (Lastest > Current) {
GuiControl, Startup:, Stat, % _24
MsgBox, 36, % _20 " " Lastest, % _21 " " Lastest "?"
IfMsgBox, Yes
{
GuiControl, Startup:, Stat, % _25
SetWorkingDir, Update
If FileExist("DL.txt")
FileDelete, DL.txt
If FileExist("LogKey.Json")
FileDelete, LogKey.Json
FileAppend, % JsonKey, LogKey.Json
RunWait, Updater.exe dn "/",, Hide
FileDelete, LogKey.Json
FileRead, DL, DL.txt
FileDelete, DL.txt
DownloadFile(DL, "Cassier-Update.zip")
}
}
SetWorkingDir, % A_ScriptDir
}
DownloadFile(URL, SaveFileAs := "", Overwrite := True, UseProgressBar := True) {
global
if !SaveFileAs {
SplitPath, URL, SaveFileAs
StringReplace, SaveFileAs, SaveFileAs, `%20, %A_Space%, All
}
If (!Overwrite && FileExist(SaveFileAs))
Return
If (UseProgressBar) {
WebRequest := ComObjCreate("WinHttp.WinHttpRequest.5.1")
WebRequest.Open("HEAD", URL)
WebRequest.Send()
FinalSize := WebRequest.GetResponseHeader("Content-Length")
File := FileOpen(SaveFileAs, "rw")
SetTimer, __UpdateProgressBar, 1000
}
UrlDownloadToFile, % URL, % SaveFileAs
If (UseProgressBar) {
SetTimer, __UpdateProgressBar, Off
File.Close()
If FileExist("Dest.txt")
FileDelete, Dest.txt
FileAppend, % A_ScriptDir, Dest.txt
Run, Apply.exe
ExitApp
}
Return
}
__UpdateProgressBar:
CurrentSize := File.Length
LastSizeTick := CurrentSizeTick
LastSize := CurrentSize
PercentDone := Round(CurrentSize/FinalSize*100)
GuiControl, Startup:, UPProg, % PercentDone
GuiControl, Startup:, Stat, % PercentDone " % - " _26
Return
CheckForUpdatesStat() {
IniRead, Stat, Setting.ini, Update, Upt
If (Stat = "ERROR")
Stat := 0
Return, Stat
}
MouseHover() {
global
If !GetKeyState("F1") {
If (A_GuiControl = "LV1" || A_GuiControl = "LV4" || A_GuiControl = "LV3") {
If (RMS = "#2")
Gui, Main:ListView, LV1
Else If (RMS = "#5")
Gui, Main:ListView, LV4
Else If (RMS = "#4")
Gui, Main:ListView, LV3
If (RMS ~= "#2|#5") {
If (Row := LV_GetNext()) {
If (!ShowTT) {
MouseGetPos, X, Y
X += 20
Y += 10
HH := A_ScreenHeight // 2
Gui, ReIn:Show, NoActivate x%X% y%Y% w800 h%HH%
ShowTT := 1
}
If (ThisLoaded != Row) {
LV_GetText(FileName, Row, 1)
RawData := StrSplit(DB_Read(FileName), "> ")[2]
Items := StrSplit(Trim(RawData, "|"), "|")
Result := "=====================================================================`n"
AllProf := 0
For Each, One in Items {
DI := StrSplit(Trim(One, ";"), ";")
Result .= " Name: " DI[2] "`n Sold Price: " DI[3] "=" DI[4] "`n Buy Price: " DI[5] "=" DI[6] "`n Profit Made: " DI[7] "`n=====================================================================`n"
AllProf := AllProf + DI[7]
}
Result .= "`n OverAll Profit: " AllProf
GuiControl, ReIn:, DInfo, % Result
ThisLoaded := Row
}
MouseGetPos, X, Y
X += 20
Y += 10
HH := A_ScreenHeight // 2
Gui, ReIn:Show, NoActivate x%X% y%Y% h%HH%
} Else If (ShowTT) {
Gui, ReIn:Hide
ShowTT := 0
}
}
} Else If (ShowTT) {
Gui, ReIn:Hide
ShowTT := 0
}
}
}
UpdateProdDefs() {
Global
genData := ""
For Each, Barcode in ProdDefs {
genData .= Each ";" Barcode[1] ";" Barcode[2] ";" Barcode[3] ";" (Barcode[4] ? Barcode[4] : 0) (Barcode[5] ? ";" Barcode[5] : "") "|"
}
DB_Write("Sets\PD.db", genData)
}
CheckListSum() {
global
Everything := 0
Loop, % LV_GetCount() {
LV_GetText(ThisLSum, A_Index, 5)
Everything += ThisLSum
}
If (Everything) {
GuiControl, Main:, ThisListSum, % Everything
} Else {
GuiControl, Main:, ThisListSum, % "---"
}
}
AllButThis(All, This) {
tmp := ""
For every, one in All {
If (one != This) {
tmp .= one "/"
}
}
Return, Trim(tmp, "/")
}
GenColor(Arr) {
EarlierData := ""
If (FileExist("Sets\CS.db"))
EarlierData := DB_Read("Sets\CS.db")
Items := ""
For Each, One in Arr {
Items .= One ";"
}
Items := RandomHexColor() ";" Trim(Items, ";") "|"
DB_Write("Sets\CS.db", EarlierData Items)
}
FindTheColor(ID) {
For every, one in StrSplit(DB_Read("Sets\CS.db"), "|") {
If InStr(one, ID ";") || InStr(one, ";" ID) {
ThisOne := StrSplit(one, ";")
Return, "0x" ThisOne[1]
}
}
}
RemoveBC(Data, Bc) {
NewData := ""
For Any, Thing in StrSplit(Data, "/") {
If (Thing != Bc) {
NewData .= Thing "/"
}
}
Return, Trim(NewData, "/")
}
LoadAccounts() {
LV_Delete()
AccInfo := StrSplit(DB_Read("Sets\Lc.lic"), ";")
Loop, % AccInfo.Length() - 3 {
NP := StrSplit(AccInfo[A_Index + 3], "/")
LV_Add(, NP[1], NP[2])
}
GuiControl, Main:, UserName
GuiControl, Main:, UserPass
GuiControl, Main:Focus, UserName
}
LoadStockChanges(OneFile := "") {
global
GuiControl, Main:, Add
GuiControl, Main:, Sub
If (!OneFile) {
StockChanges := ""
Loop, Files, Stoc\*.db, FR
{
If (RD := DB_Read(A_LoopFileFullPath)) {
Data := StrSplit(RD, "|")
FormatTime, TD, % StrReplace(A_LoopFileName, ".db"), yyyy/MM/dd HH:mm:ss
StockChanges .= Data[1] "|[" TD "]: " Data[2] "`n"
If (Data[3]) {
For Ot, hers in StrSplit(Data[3], "/") {
StockChanges .= hers "|[" TD "]: " Data[2] "`n"
}
}
}
StockChanges .= "`n"
}
} Else {
If (RD := DB_Read(OneFile)) {
Data := StrSplit(RD, "|")
SplitPath, % OneFile,,,, OutNameNoExt
FormatTime, TD, % OutNameNoExt, yyyy/MM/dd HH:mm:ss
StockChanges .= Data[1] "|[" TD "]: " Data[2] "`n"
If (Data[3]) {
For Ot, hers in StrSplit(Data[3], "/") {
StockChanges .= hers "|[" TD "]: " Data[2] "`n"
}
}
}
StockChanges .= "`n"
}
SoldStoc := ""
Loop, Files, Curr\*.db, FR
{
If (RD := DB_Read(A_LoopFileFullPath)) {
FormatTime, TD, % StrReplace(A_LoopFileName, ".db"), yyyy/MM/dd HH:mm:ss
IntersD := StrSplit(RD, "> ")[2]
Loop, Parse, IntersD, |
{
If (A_LoopField) {
ThisInt := StrSplit(A_LoopField, ";")
SoldStoc .= ThisInt[1] "|[" TD "]: -" StrSplit(ThisInt[3], "x")[2] "`n"
}
}
}
SoldStoc .= "`n"
}
Loop, Files, Valid\*.db, FR
{
If (RD := DB_Read(A_LoopFileFullPath)) {
FormatTime, TD, % StrReplace(A_LoopFileName, ".db"), yyyy/MM/dd HH:mm:ss
IntersD := StrSplit(RD, "> ")[2]
Loop, Parse, IntersD, |
{
If (A_LoopField) {
ThisInt := StrSplit(A_LoopField, ";")
SoldStoc .= ThisInt[1] "|[" TD "]: -" StrSplit(ThisInt[3], "x")[2] "`n"
}
}
}
SoldStoc .= "`n"
}
}
GetKridiUsers() {
KList := ""
Loop, Files, Kr\*, D
{
SplitPath, % A_LoopFileFullPath,,,, OutNameNoExt
KList .= DecodeAlpha(OutNameNoExt) "|"
}
Return, Trim(KList, "|")
}
LoadKridiUsers() {
GuiControl, Kridi:, KLB, |
GuiControl, Kridi:, KLB, % GetKridiUsers()
}
SelectAll(HwD) {
PostMessage, 0xB1, 0, -1,, % "ahk_id " HwD
}
LoadKridis() {
LV_Delete()
GuiControl, Main:, KLB, |
Loop, Files, Kr\*.*, D
{
SplitPath, % A_LoopFileFullPath,,,, OutNameNoExt
GuiControl, Main:, KLB, % DecodeAlpha(OutNameNoExt)
}
GuiControl, Main:Choose, KLB, 1
GoSub, DisplayKridi
}
LoadPrevPD() {
GuiControl, Main:, PrevPD, |
If FileExist("Sets\PD.db") {
FormatTime, ThisTime, % A_Now, yyyy/MM/dd HH:mm:ss
GuiControl, Main:, PrevPD, % "[0] " ThisTime "||"
}
Loop, Files, % "Sets\Bu\*.Bu", F
{
SplitPath, % A_LoopFileName,,,, OutNameNoExt
FormatTime, ThisTime, % OutNameNoExt, yyyy/MM/dd HH:mm:ss
GuiControl, Main:, PrevPD, % "[" A_Index "] " ThisTime
}
GuiControl, Main:Disabled, PDSave
}
LoadSetting() {
IniRead, UPT, Setting.ini, Update, Upt
If (UPT) && (UPT != "ERROR") {
GuiControl, Main:, CheckForUpdates, 1
} Else {
GuiControl, Main:, CheckForUpdates, 0
}
IniRead, RemUser, Setting.ini, OtherSetting, RemUser
OldLog := StrSplit(DB_Read("Sets\RL.db"), ";")
If (RemUser) && (RemUser != "ERROR") && (RemUser = OldLog[1]) {
GuiControl, Main:, RememberLogin, 1
} Else {
GuiControl, Main:, RememberLogin, 0
}
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
SaveLogIn() {
Global
LogD := (LogD := DB_Read("Log\Log.db")) ? LogD : ""
LogN := "LogIn=" A_Now ";Level=" Level ";User=" TU
DB_Write("Log\Log.db", LogD "|" LogN)
}
SaveLogOut() {
Global
LogD := (LogD := DB_Read("Log\Log.db")) ? LogD : ""
LogN := "LogOut=" A_Now ";Level=" Level ";User=" TP
DB_Write("Log\Log.db", LogD "|" LogN)
}
ChargeLogs() {
GuiControl, Main:, ByDate, |
LogD := StrSplit(DB_Read("Log\Log.db"), "|")
For Every, Log in LogD {
If (SubStr(Log, 1, 5) = "LogIn") {
InInfo := StrSplit(Log, ";")
InUser := StrSplit(InInfo[3], "=")[2]
If (SubStr(LogD[Every + 1], 1, 6) = "LogOut") {
OutInfo := StrSplit(LogD[Every + 1], ";")
OutUser := StrSplit(OutInfo[3], "=")[2]
If (InUser = OutUser) {
InTime := StrSplit(InInfo[1], "=")[2]
OutTime := StrSplit(OutInfo[1], "=")[2]
FormatTime, FormattedInTime, % InTime, yyyy/MM/dd HH:mm:ss
FormatTime, FormattedOutTime, % OutTime, yyyy/MM/dd HH:mm:ss
GuiControl, Main:, ByDate, % FormattedInTime " - " FormattedOutTime "   " InTime ";" OutTime
}
}
}
}
GuiControl, Main:Choose, ByDate, 1
GoSub, DisplayEqProf
}