#E::
{
	; Declaration of variables and environment
	SetMouseDelay(20)
	OKW_key := A_Clipboard
	regEx := "[0-9]", regEx2 := "[0-9]-[0-9]", regSiebel := "Siebel[\w\s]*"
	CoordMode "Pixel"
	workingDir := A_ScriptDir, siebelAchternaam := workingDir "\imgSearch\Achternaam.bmp", siebelBijlages := workingDir "\imgSearch\Bijlages.bmp", siebelHuishouden := workingDir "\imgSearch\Huishouden.bmp", siebelKlant := workingDir "\imgSearch\Klant.bmp", siebelPersonen := workingDir "\imgSearch\Personen.bmp", siebelPersonenB := workingDir "\imgSearch\PersonenBlack.bmp", siebelPersonenO := workingDir "\imgSearch\PersonenOrange.bmp", siebelZoekbar := workingDir "\imgSearch\Zoek.bmp"
	HHX := "", BlgX := "", ZkX := ""
	winIds := WinGetList()

	; Check of er wel een siebelID in de clipboard staat
	if (!RegExMatch(OKW_key, regEx) or !RegExMatch(OKW_key, regEx))
	{
		ToolTipFunctie("Clipboard bevat geen siebelID")
		Exit
	}

	; Check of Siebel open is, en open het
	ToolTipFunctie("Zoeken naar Siebel...")
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
	FindNClick(siebelHuishouden, 60, "Het programma kan de 'huishouden' knop niet vinden, het zal nu sluiten")
	FindNClick(siebelBijlages, 60, "Het programma kan de 'Bijlages' knop niet vinden, het zal nu sluiten")
	FindNClick(siebelZoekbar, 60, "Het programma kan de zoekbar niet vinden, het zal nu sluiten")

	; Autozoek de AFP
	SendInput ("aanvraag financiering particulier")
	sleep 500
	SendInput ("{Enter}")

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
				ToolTipFunctie(errorText)
				Exit
			}
			return
		}
	}
	MouseMove(xVar+xOff, yVar+yOff)
	Click
	return True
}
