


fn saveSceneVersion = (
	
	dySafeInitProject()	
	
	-- create dev folder if it does not exist
	dyDoesFolderExist dy3DdevPath  create:True
	
	-- save new version
	newVersionName = ( incrementVersion maxfilename )
	
	-- if it does differ from previous version...	
	newFilePath = (dy3DdevPath + newVersionName +".max")	
	oldFilepath = (maxfilepath + maxfilename)
	
	/*
	if ( (getFileSize oldFilepath) != (getFileSize newFilePath)   ) then
	(
	print "different"	
	)else(
		print "same"
		)
		
	*/
	
	saveMaxfile newFilePath
	
)


fn publishSceneVersion =
(
	
	dySafeInitProject()
	
	-- prePublish tests
	
	--dyPrePublish()
	
	-- create scene folder if it does not exist
	dyDoesFolderExist dyScenePath  create:True
	
	newFilePath =dyScenePath + substitutestring maxfilename	("_"+(getVersion maxfilename)[1]) ""
	
	saveMaxfile newFilePath useNewFile:false
		
)
	

publishSceneVersion()



	
	

