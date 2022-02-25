thePath = @"...\Development\3D\Komponentbibliotek\Sofas_noDisplace\"
if thePath != undefined do--if the user did not cancel
(
  theFiles = getFiles (thePath+"\\*.max") --collect all max files in the dir.
  for f in theFiles do-- go through all of them
  (
    print f
	loadMaxFile f--load the next file	
	print (thePath +"\\"+ +"noDisplace_"+ maxfilename ) 
	saveMaxfile (thePath +"\\"+"noDisplace_"+ maxfilename)
	

	
 
   -- saveMaxFile f --save the file back to disk
  )--end f loop
 -- resetMaxFile #noPrompt --at the end, you can reset
)--end if 