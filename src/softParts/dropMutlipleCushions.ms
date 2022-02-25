thePath = @"\\DISKSTATION\Projects\Bemz\Development\3D\Komponentbibliotek\Sofas\"


if thePath != undefined do--if the user did not cancel
(
  theFiles = getFiles (thePath+"\\*.max") --collect all max files in the dir.
  for f in theFiles do-- go through all of them
  (
    print f
	loadMaxFile f--load the next file
	
	if (layer2= LayerManager.getLayerFromName "Pillows")== undefined then (
		  
		try(  
		dummyNodes = dyGetObjectsByLayerName "Dummys"
		delete dummyNodes
		)catch()
		try(  
		dummyNodes = $*Dummy
		delete dummyNodes
		)catch()
		
		
		
		newPath = thePath+"withCushions"
		dyDoesFolderExist (newPath) create:true
		  
		select $*
		
		
		  
		dropCushion (selection as array)
		  
		
		print (newPath +"\\"+ maxfilename ) 
		saveMaxfile (newPath +"\\"+ maxfilename)
	
)
	
 
   -- saveMaxFile f --save the file back to disk
  )--end f loop
 -- resetMaxFile #noPrompt --at the end, you can reset
)--end if 