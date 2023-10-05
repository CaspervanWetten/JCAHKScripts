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
	siebelAchternaam := workingDir "\imgSearch\Achternaam.bmp", siebelBijlages := workingDir "\imgSearch\Bijlages.bmp", siebelHuishouden := workingDir "\imgSearch\Huishouden.bmp", siebelKlant := workingDir "\imgSearch\Klant.bmp", siebelPersonen := workingDir "\imgSearch\Personen.bmp", siebelPersonenB := workingDir "\imgSearch\PersonenBlack.bmp", siebelPersonenO := workingDir "\imgSearch\PersonenOrange.bmp", siebelZoekbar := workingDir "\imgSearch\Zoek.bmp", powerOntvang := workingDir "\imgSearch\Ontvang.bmp", powerActiviteit := workingDir "\imgSearch\Activiteit.bmp", powerOKW := workingDir "\imgSearch\OKW.bmp", powerVolgende := workingDir "\imgSearch\Volgende.bmp"
	
	
	; Check of Powertools open is, en open het
	ToolTipFunctie("Zoeken naar de Powertools...")
	winIds := WinGetList() ; This happens here because there's (only sometimes!) a 'window unknown' error in line 21 (ifRegex), which somehow can't find the title of the windowID it gathered 0.1ms ago, I moved it down and it (seems) to work much better
	for id in winIds
	{
		if(RegExMatch(WinGetTitle(id), regPower))
		{
			WinActivate(id)
		}
	}
	
	sleep 800
	FindNClick(powerOntvang, 10, "Kan de powertools niet vinden")
	ToolTipFunctie("Zoeken naar de activiteiten knop...")
	FindNClick(powerActiviteit, 60, "Kan de activiteit niet ontvangen")
	ToolTipFunctie("Zoeken naar de OKW Key...")
	FindNClick(powerOKW, 80, "Kan de OKW key niet vinden",,, yOff := 40)
	click
	sleep 400
	SendInput ("^c")
	sleep 150	
	; Check of er wel een siebelID in de clipboard staat
	if (!RegExMatch(OKW_key, regEx) or !RegExMatch(OKW_key, regEx))
	{
		MsgBox("Clipboard bevat geen siebelID")
		Exit
	}

	sleep 200
	FindNClick(powerVolgende, 10, "", False)
	
	; Check of Siebel open is, en open het
	ToolTipFunctie("Zoeken naar Siebel...")
	sleep 20
	winIds := WinGetList()
	for id in winIds
	{
		if(RegExMatch(WinGetTitle(id), regSiebel))
		{
			WinActivate(id)
		}
	}
	
	; vind de correcte personenknop ( oranje [als die actief is], of zwart) en klik dan op die, selecteer daarna de klant-id zoekbalk
	if !FindNClick(siebelPersonenO, 5, "", False)
	{
		FindNClick(siebelPersonenB, 5, "Siebel kan niet gevonden worden`nWeet je zeker dat het openstaat?")
	}
	FindNClick(siebelKlant, 10, "Kan de klantenzoekbox niet vinden")
	
	; plak de gekopieerde klantcode in de zoekbalk, als het een dubbele code is, haal dan de tweede code weg, en druk op enter (i.e., het zoek process), klik daarna op de bovenste naam
	SendInput ("^v")
	if RegExMatch(OKW_key, regEx2)
	{
		sleep 200
		SendInput ("^{BS}")
		sleep 200
		SendInput ("{BS}")
	}
	sleep 200
	SendInput ("{Enter}")
	FindNClick(siebelPersonen, 120, "Er lijkt geen resultaat gevonden te zijn",,, 50)
	
	; vind en klik op de correcte knoppen
	FindNClick(siebelHuishouden, 60, "Het programma kan de 'huishouden' knop niet vinden")
	FindNClick(siebelBijlages, 60, "Het programma kan de 'Bijlages' knop niet vinden")
	sleep 500
	
	; Autozoek de AFP
	SendInput ("^f")
	sleep 50
	SendInput ("aanvraag financiering particulier")
	sleep 50 
	
	return
}

ToolTipFunctie(text, tijd := 2500)
{
	ToolTip(text)
	SetTimer () => ToolTip(), tijd
}

FindNClick(toSearch, range, errorText, error := True, xOff := 0, yOff := 0)
{
	xVar := ""
	i := 0
	xLength := SysGet(78), yLength := SysGet(79)
	
	while(!xVar)
	{
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
	Click
	return True
}
