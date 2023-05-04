; The GUI part
Gui, Add, Text,, the number of times to run the script: ; Add a text label
Gui, Add, Edit, vNumber w100 ; Add a textbox and assign it a variable name Number
Gui, Add, Button,, Run ; Add a button
GuiControl,, Number, 0 ; Set the default value of the textbox to 1
Gui Show ; Show the GUI

ButtonRun: ; Define what happens when the button is clicked
GuiControlGet Number ; Get the value of the textbox
Loop %Number% ; Loop as many times as the value
{
    ; Run your script here
    WinWait, qBittorrent v4.3.7,
    IfWinNotActive, qBittorrent v4.3.7,, WinActivate,qBittorrent v4.3.7,
    WinWaitActive,qBittorrent v4.3.7,
    Send,{F2}
    WinWait,Renaming,
    IfWinNotActive,Renaming,, WinActivate,Renaming,
    WinWaitActive,Renaming,
    Send, {RIGHT}{LEFT}{CTRLDOWN}{BACKSPACE}{BACKSPACE}{BACKSPACE}{BACKSPACE}{CTRLUP}{BACKSPACE}{BACKSPACE}{ENTER}
    WinWait,qBittorrent v4.3.7,
    IfWinNotActive,qBittorrent v4.3.7,, WinActivate,qBittorrent v4.3.7,
    WinWaitActive,qBittorrent v4.3.7,
    Send,{UP}
}

^!g::Gui Show ; To show the GUI when Ctrl+Alt+g is pressed
