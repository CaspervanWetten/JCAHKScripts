!E::
{
	; Declaration of environment
	SetMouseDelay(20)
	DetectHiddenWindows 1
	OKW_key := A_Clipboard
	CoordMode "Pixel", "Window"
	
	; Variable declaration
	regEx := "[0-9]", regEx2 := "[0-9]-[0-9]", regSiebel := "Siebel.*", regPower := "RKS_GEN[\w\s]"
	workingDir := A_ScriptDir
	siebelAchternaam := workingDir "\imgSearch\Achternaam.bmp", siebelBijlages := workingDir "\imgSearch\Bijlages.bmp", siebelHuishouden := workingDir "\imgSearch\Huishouden.bmp", siebelKlant := workingDir "\imgSearch\Klant.bmp", siebelPersonen := workingDir "\imgSearch\Personen.bmp", siebelPersonenB := workingDir "\imgSearch\PersonenBlack.bmp", siebelPersonenO := workingDir "\imgSearch\PersonenOrange.bmp", siebelZoekbar := workingDir "\imgSearch\Zoek.bmp", siebelTab := workingDir "\imgSearch\Siebel.bmp", powerOntvang := workingDir "\imgSearch\Ontvang.bmp", powerActiviteit := workingDir "\imgSearch\Activiteit.bmp", powerOKW := workingDir "\imgSearch\OKW.bmp", powerVolgende := workingDir "\imgSearch\Volgende.bmp", powerKlant := workingDir "\imgSearch\powerKlant.bmp", 

	; Check of Powertools open is, en open het
	ToolTipFunctie("Zoeken naar de Powertools...")
	try {
		WinActivate("RKS_GEN")
	} catch {
		MsgBox("Powertools kan niet gevonden worden")
	}
	FindNClick(powerOntvang, 10, "Kan de powertools niet vinden")
	FindNClick(powerKlant, 30, "", False)
	sleep 90
	SendInput("{Ctrl down}")
	sleep 90
	SendInput("{Shift down}")
	sleep 90
	SendInput ("{Tab}")
	SendInput("{Shift up}")
	SendInput ("{Ctrl up}")
	FindNClick(powerActiviteit, 60, "De activiteit kan niet gevonden worden")
	
	if(!WinExist("Siebel")){
		sleep 850
		FindNClick(siebelTab, 10, "Siebel kan niet gevonden worden",,, True)
		Click "Down"
		sleep 100
		MouseMove(1920,-150)
		sleep 100
		Click "Up"
		SendInput ("{LWin down}")
		sleep 20
		SendInput ("{Up} {Up}")
		sleep 20
		SendInput ("{LWin up}")
	}
	WinActivate("Siebel")
	FindNClick(siebelBijlages, 60, "Het programma kan de 'Bijlages' knop niet vinden")
	sleep 500
	
	; ; Autozoek de AFP
	; SendInput ("^f")
	; sleep 50
	; SendInput ("aanvraag financiering particulier")
	; sleep 50 
	
	; Autozoek de AFP
	FindNClick(siebelZoekbar, 60, "Het programma kan de zoekbar niet vinden, het zal nu sluiten")
	SendInput ("aanvraag financiering particulier")
	sleep 500
	SendInput ("{Enter}")
	
	
	; Druk op de 'volgende' knop zodra deze beschikbaar is in de powertools 
	MouseGetPos &currentX, &currentY
	FindNClick(powerVolgende, 100, "", False,,, "Support")
	WinActivate("Siebel")
	MouseMove(currentX, currentY)
	
	return	
}





ToolTipFunctie(text, tijd := 2500)
{
	ToolTip(text)
	SetTimer () => ToolTip(), tijd
}

FindNClick(toSearch, range, errorText, error := True, xOff := 0, yOff := 0, hold := False, win := "")
{
	xVar := ""
	i := 0
	xLength := SysGet(78), yLength := SysGet(79)
	
	while(!xVar)
	{
		if(win){
			MsgBox(win)
			WinActivate(win)
		}
		
		ImageSearch &xVar, &yVar, 0, 0, 1920, 1080, toSearch
		Sleep 100
		i++
		if (i > range)
		{
			if(error)
			{
				MsgBox(errorText)
				Exit
			}
			return
		}
	}
	MouseMove(xVar+xOff, yVar+yOff)
	sleep 10
	Click "Down"
	if(!hold)
	{
	Click "Up"
	}
	sleep 100
	return True
}
