#Requires AutoHotkey v2.0


; Globale Variablen definieren
global ProgName := "OEM-Info"
global ProgDate := "2026-01-21"
global ProgVer := "0.0.002"
global ProgAuthor := "KLiNG0NE"
global ProgUrl := "https://github.com/KLiNG0NE"
global IconFile := "favicon.ico"

; Programmnamen und -Version als Icon-Tip anzeigen
A_IconTip := ProgName " v" ProgVer
; Programm-Icon
TraySetIcon IconFile

; Dem Tray-Icon im Info-Bereich ein Menüpunkt für Rechtsklick hinzufügen
A_TrayMenu.Add("Info", (*) => MenuHelpInfo())

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
MainGui.Add("Text",, "Telefon:")
MainGui.Add("Text",, "Stunden:")
MainGui.Add("Text",, "Website:")
MainEditManuf := MainGui.Add("Edit", "w256 vManuf ym")
MainEditModel := MainGui.Add("Edit", "w256 vModel")
MainEditUrl := MainGui.Add("Edit", "w256 vUrl")
MainEditHour := MainGui.Add("Edit", "w256 vHour")
MainEditPhone := MainGui.Add("Edit", "w256 vPhone")

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
    Info.Add("Text",, "Website: " ProgUrl)

    ; 1. Den Text in einer Variable zusammenbauen (mit Chr(34) für die Anführungszeichen)
    ; LinkText := "Website: <a href=" . Chr(34) . ProgUrl . Chr(34) . ">Online</a>"
    LinkText := "Website: <a href=" . Chr(34) . ProgUrl . Chr(34) . ">" . ProgUrl . "</a>"

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

/* "Manufacturer"="Micro-Star International (MSI)"
"Model"="A320M-A PRO"
"SupportURL"="https://www.msi.com/Motherboard/A320M-A-PRO/"
"SupportHours"="Mo-Do 09:00 - 18:00 Uhr, Fr 09:00 - 17:00 Uhr"
"SupportPhone"="+49 69 40893 120"
"Logo"="C:\\WINDOWS\\oemlogo\\oemlogo.gigabyte.bmp" */