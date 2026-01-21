#Requires AutoHotkey v2.0


; Globale Variablen definieren
global ProgName := "OEM-Info"
global ProgDate := "2026-01-21"
global ProgVer := "0.0.003"
global ProgAuthor := "KLiNG0NE"
global ProgUrl := "https://github.com/KLiNG0NE"
global IconFile := "favicon.ico"

; Programmnamen und -Version als Icon-Tip anzeigen
A_IconTip := ProgName " v" ProgVer
; Programm-Icon
TraySetIcon IconFile

; Dem Tray-Icon im Info-Bereich ein Menüpunkt für Rechtsklick hinzufügen
A_TrayMenu.Add("Info", (*) => MenuHelpInfo())


valueManuf := RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation", "Manufacturer")
valueModel := RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation", "Model")
valueUrl := RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation", "SupportURL")
valueHours := RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation", "SupportHours")
valuePhone := RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation", "SupportPhone")

MainGui := Gui("+Resize", ProgName " v" ProgVer)
MainGui.SetFont("s13", "Courier New")

FileMenu := Menu()
FileMenu.Add("Settings", MenuFileExit)
FileMenu.Add("Exit", MenuFileExit)

HelpMenu := Menu()
HelpMenu.Add("Info", MenuHelpInfo)

MainMenuBar := MenuBar()
MainMenuBar.Add("File", FileMenu)
MainMenuBar.Add("?", HelpMenu)
MainGui.MenuBar := MainMenuBar

MainGui.Add("Text",, "Hersteller:")
MainGui.Add("Text",, "Modell:*")
MainGui.Add("Text",, "Website:")
MainGui.Add("Text",, "Stunden:")
MainGui.Add("Text",, "Telefon:")
MainEditManuf := MainGui.Add("Edit", "w512 vManuf ym", valueManuf)
MainEditModel := MainGui.Add("Edit", "w512 vModel", valueModel)
MainEditUrl := MainGui.Add("Edit", "w512 vUrl", valueUrl)
MainEditHours := MainGui.Add("Edit", "w512 vHours", valueHours)
MainEditPhone := MainGui.Add("Edit", "w512 vPhone", valuePhone)

MainGui.Show()

MenuFileExit(*)
{
    WinClose()
}

MenuHelpInfo(*)
{
    global MainGui, IconFile, ProgName, ProgVer, ProgDate, ProgAuthor, ProgUrl
    Info := Gui("+owner" MainGui.Hwnd)
    MainGui.Opt("+Disabled")
    
    Info.AddPicture("w32 h32", IconFile)
    Info.SetFont("s16", "Courier New")
    Info.Add("Text",, ProgName)
    Info.SetFont("s13", "Courier New")
    Info.Add("Text",, "Version: " ProgVer)
    Info.Add("Text",, "Datum:   " ProgDate)
    Info.Add("Text",, "Author:  " ProgAuthor)

    ; https und http aus "ProgUrl" entfernen
    ProgUrlShort := RegExReplace(ProgUrl, "^https?://")
    ; 1. Den Text in einer Variable zusammenbauen (mit Chr(34) für die Anführungszeichen)
    ; LinkText := "Website: <a href=" . Chr(34) . ProgUrl . Chr(34) . ">Online</a>"
    LinkText := "Website: <a href=" . Chr(34) . ProgUrl . Chr(34) . ">" . ProgUrlShort . "</a>"

    ; 2. Die Variable an das Gui-Objekt übergeben
    Info.Add("Link",, LinkText)

    Info.Add("Button", "Default", "&Ok").OnEvent("Click", Info_Close)
    Info.OnEvent("Close", Info_Close)
    Info.OnEvent("Escape", Info_Close)
    Info.Title := "Information"
    Info.Show()

    Info_Close(*)
    {
        MainGui.Opt("-Disabled")
        Info.Destroy()
    }
}
