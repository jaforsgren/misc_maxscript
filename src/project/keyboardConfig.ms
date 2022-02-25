

	if (sysInfo.username == "p3") then (
		if (maxfilename == "") then (
			units.SystemType = #centimeters
			units.DisplayType == #metric
			)		
		IInteractionMode.CurrentMode = #MayaMode
		actionMan.loadKeyboardFile "c:\\Users\\jfo\\Dropbox\\Workgroups\\3dsMax\\JohanMaxStartUI.kbdx"
		
		
		print "Loaded Config, welcome Johan."
		true
	)		
