global dyProject
global dyProjectList
global dyMasterDialog 
global dyScenePath
global dy3DdevPath 
global dyProjectPath
global dySelectedAssetCategory
global initProject

global LastSubRollout = 1	
global projectRollout
global sceneLoadRollout	
global loadAssetRollout
global assetRollout
global inforollout
	
rollout projectRollout "Project Settings"
(
	
 	dropdownList costumers "Client" 
	dropdownList projects "Project"	
	
	-- projectRollout functions
	on costumers selected id do (	
		projectdefinition = dyProjectBase+costumers.items[id]	 + "\\startup\\projectdefinition.ms"		
		if (doesFileExist projectdefinition) then(			
			filein(projectdefinition )	
			--try(
				projectRollout.projects.items = dyProjectList	
				inforollout.setinfo()
			--)catch(print "no project list in project deifinition")
			)
		else(
			-- do stuff			
			)

	)	
	on projects selected id do (	
		dyProject = projects.items[id]			
		initProject()		
		inforollout.setinfo()
	)	
	
	
	on projectRollout open do (
		dySafeInitProject()
		--dyProject = projects.items[id]	
		--initProject()		
		dyMasterDialog.init()
		)
)

rollout newprojectRollout "new Project (not currently working)" 
(
	edittext overrideVersion "Project name" 
	button newProjectBtn "Commit new project"
	checkbox create_project_folder_structure_chk_box "Create folder structure"
	checkbox set_to_current_Project_chk_box "Set as current project"
	
)
rollout newclientRollout "New Client (not currently working)"
(	
edittext overrideVersion "Client Name" 
button newClientBtn "Commit new client"
checkbox create_client_folder_structure_chk_box "Create folder structure"
	
)



rollout sceneNewRollout "new Scene"
(
	edittext sceneDescriptEdit "new scene description" 
	button saveAsNewDevScene "Save current Scene a new dev Scene"
	button newScenebtn "Create new empty dev scene"
	
	on newScenebtn pressed do
	(
	print sceneDescriptEdit.text
	if not (sceneDescriptEdit.text == "") then(
		-- load maxfile ?
		resetMaxFile #noprompt
		saveNewScene sceneDescriptEdit.text
		)

	)
	on saveAsNewDevScene pressed do
	(
	print sceneDescriptEdit.text
	if not (sceneDescriptEdit.text == "") then(
		saveNewScene sceneDescriptEdit.text
		)
	)	
	
	
)




rollout sceneLoadRollout "load Scene"
(
	dropdownList scenesddl "scenes"
	button loadScenebtn "load Scene"	
	
	on sceneLoadRollout open do (		
			items = #()
			scenefiles = getfiles (dy3DdevPath	+ "*.max")
			for file in scenefiles	do( 
				append items (getfilenamefile file ) 
				)
			scenesddl.items = items	
	)
	
	on loadScenebtn pressed do
	(
		filepath = dy3DdevPath + scenesddl.items[scenesddl.selection] + ".max"
		--print filepath
		loadmaxfile filepath
	)
	
	
)

rollout PublishSceneVersionRollout  "Publish Scene"
(
	button btnSceneVersionUp "Version Up" height:50 width:130
	
	button btnPublishSceneVersion "Publish" height:50 width:130
	
	on btnSceneVersionUp pressed do
	(
		if not (maxfilepath == "") then(	
			if  (maxfilepath == dy3DdevPath) then(
				-- check naming conventions....				
				saveNewScene()				
				) else(
				str = (substitutestring dy3DdevPath dyProjectbase "")
				messageBox ( "The scene does not lie correctly in the scene development folder\n" + str )
				)	
			)else(
				messageBox ( "The scene has not been saved as a development version yet." )			
			)
	)
	
		

	on btnPublishSceneVersion pressed do
	(
		if not (maxfilepath == "") then(	
			if  (maxfilepath == dy3DdevPath) then(
				-- check naming conventions....				
				publishSceneVersion()				
				) else(
				str = (substitutestring dy3DdevPath dyProjectbase "")
				messageBox ( "The scene does not lie correctly in the scene development folder\n" + str )
				)	
			)else(
				messageBox ( "The scene has not been saved as a development version yet." )			
			)
	)
	
)


rollout assetRollout "Assets"
(
	dropdownList newAssetCategory "Choose category "
	
	button btnnewAssetCategoryBtn "New Category"  width:130 
	
	label AssetsDivider  "_________________________________________________________________________\n"
	
	edittext assetDescriptEdit "new asset"  align:#left	width:250 offset:[0,10]
	
	button btnnewAsset "save asset"   align:#right offset:[-30,-24]
	
	
	fn updateCategorylist = (
		
		direcorylist = getDirectories (customerModelLibrary+"*")
		categorylist = #("Choose Asset Category")
		for category in direcorylist do(			
			append categorylist (filenameFromPath category)
			)
		newAssetCategory.items = categorylist		
		dySelectedAssetCategory = customerModelLibrary +  newAssetCategory.items[1]		
					
		customerModelLibraryDev =dySelectedAssetCategory + @"\dev\\"
		loadAssetRollout.updateAssetCategory() 		
		
		)
	
	fn createCategory = (
		theObj = dotNetObject "MaxCustomControls.RenameInstanceDialog" "Type in  name of category"
		theobj.text ="New Category Name"
		DialogResult = theObj.Showmodal()
		--test if the ok button was pressed
		dotnet.compareenums TheObj.DialogResult ((dotnetclass "System.Windows.Forms.DialogResult").OK)
		--get the new text string
		NewStringEntered = theobj.InstanceName
		newpath = customerModelLibrary + NewStringEntered
		-- create folder
		dyDoesFolderExist newpath  create:True
		-- update category list
		updateCategorylist()
		
	)
	

		
	on assetRollout open do (		
		updateCategorylist()	
	)	

	on newAssetCategory selected categoryIndex do (
		print newAssetCategory.items[categoryIndex]
		dySelectedAssetCategory =  customerModelLibrary +  newAssetCategory.items[categoryIndex]	
		customerModelLibraryDev =dySelectedAssetCategory + @"\dev\\"
		loadAssetRollout.updateAssetCategory() 		
	)
	

	on btnnewAssetCategoryBtn pressed do
	(
	createCategory()
	)
	

	
	on btnnewAsset pressed do
	(
	
		print assetDescriptEdit.text
	
		if not (assetDescriptEdit.text == "") then(
		-- load maxfile ?
		resetMaxFile #noprompt
		
					
				saveNewAsset assetDescriptEdit.text
				
				aproblem = undefined -- reset array of problems in scene
					
		
		)
	)
)

rollout loadAssetRollout "LoadAssets (does not support vray proxies yet)"
(
	
	dropdownList assetsddl "Assets" width:200 align:#left
	button loadAssetbtn "load asset "		 align:#right offset:[0,-27]  width: 150
	checkbox mergeAsset_chk_box "Merge asset" align:#left
	checkbox openAsset_chk_box  "open asset" align:#right offset:[-200,-20]  
	
	
	fn updateAssetCategory = (
		
			items = #()
		print "updateAssetCategory"
		print dySelectedAssetCategory
			scenefiles = getfiles (dySelectedAssetCategory	+ "*.max")
			for file in scenefiles	do( 
				append items (getfilenamefile file ) 
				)
			assetsddl.items = items	
		
		)	
	on loadAssetRollout open do (
		
		updateAssetCategory() 		
	)	
	
	
	on loadAssetbtn pressed do
	(	
	modelFile = assetsddl.items[assetsddl.selection] + ".max"
		
	modelfilepath = customerModelLibrary +	modelFile
	if (dySelectedAssetCategory != undefined ) then(
	modelfilepath = dySelectedAssetCategory +	modelFile
	)
		
	if ( mergeAsset_chk_box.checked )then
		(
		print "Merging file"
		mergeMAXFile  modelfilepath #mergeDups #useSceneMtlDups #select quiet:true	
		)else(
			if ( openAsset_chk_box.checked )then
				(
				print "Opening file"
				loadMaxFile modelfilepath
				)
			
			)
	)

)



rollout PublishAssetVersionRollout  "Publish or Version Up asset"
(	
	button btnAssetVersionUp "Version Up" height:50 width:130  
	button btnPublishAssetVersion "Publish"  width:130 height:50
	checkbox publishVrayProxy_chk_box "Publish as VrayProxy" align:#center
	--checkbox publishSeparate_chk_box "Publish each object as separete file (wip)" align:#center
	--checkbox global_asset_chk_box "is a global asset"
	
	on btnPublishAssetVersion pressed do
	(
		if not (maxfilepath == "") then(	
			if  ((substitutestring maxfilepath "\\" "" )== (substitutestring customerModelLibraryDev "\\" "" )  )then(
			
			criticalProblem = dyListCriticalProblems()
			if (criticalProblem != undefined  ) then (			
			
				if (criticalProblem.count == 0  ) then (	
					
					-- check naming conventions....				
					if ( publishVrayProxy_chk_box.checked )then
						(					
						publishAssetVersion asVrayProxy:true			
						) 
					else
						(					
						publishAssetVersion()
						)
					
					
					aproblem = undefined -- reset array of problems in scene
					
				) else ( dySceneCheckerFunc()	)
			
			)else ( dySceneCheckerFunc()	)		
						
					
			) else(
				str = (substitutestring customerModelLibraryDev dyProjectbase "")
				messageBox ( "The scene does not lie correctly in the scene development folder\n" + str )
				)	
			)else(
				messageBox ( "The scene has not been saved as a development version yet." )			
			)
	)
	
	
	
	
	
	on btnAssetVersionUp pressed do
	(
		if not (maxfilepath == "") then(	
			if  (substitutestring maxfilepath "\\" "" )== (substitutestring customerModelLibraryDev "\\" "" ) then(
				-- check naming conventions....				
				incrementAssetVersion()	
				--infotext.text = (maxfilepath+maxfilename)				
				) else(
				str = (substitutestring customerModelLibraryDev dyProjectbase "")
				messageBox ( "The scene does not lie correctly in the scene development folder\n" + str )
				)	
			)else(
				messageBox ( "The scene has not been saved as a development version yet." )			
			)		
	)	
	
	
)


rollout mailKitten "MailKitten"
(
	label maillbl "Send selected object to someone special <3"
	button MailDorbtn "Send mail to p1" width:175 align:#left
	button Mailholbtn "Send mail to p2" width:175 align:#right offset:[0,-26.5]
	button MailJfobtn "Send mail to p3" width:175 align:#left
	button MailOtherBtn "Send mail to to that other desktop"width:175 align:#right offset:[0,-26.5]
	button getMailBtn "Get mail"width:360 height:50 align:#center
	
	
	
	fn sendTo toWho =(
		tempfolder = @"\\path\to\shared\tmpFolder\"
		tempfolderTo = tempfolder+toWho+"\\"
		dyDoesFolderExist tempfolderTo  create:True
		saveNodes selection (tempfolderTo+"tmp.max") quiet:true
	)
	
	on MailDorbtn pressed do 	(	sendTo "p1"	)	
	on Mailholbtn pressed do 	(	sendTo "p2"	)	
	on MailJfobtn pressed do 	(	sendTo "p3"	)	
	on MailOtherBtn pressed do 	(	sendTo "other"	)	
on getMailBtn pressed do 	(mergeMAXFile   (@"\\path\to\shared\tmpFolder\" +sysInfo.username +"\\tmp.max" )  #mergeDups #select )
	
)

rollout renderRollout "Render Stuff"
(
	button loadpresetbtn "load production presets (wip)" align:#left	
	
	on loadpresetbtn pressed do
	(
		dyVrayProductionPreset ""
	)	
		
)
rollout renderElementsRollout "Renderelements"
(
	
		button btn "objid from all objects" width:175 align:#left
		button btn2 "matid from all objects" width:175 align:#right offset:[0,-26.5]
		button btn3 "objid from selected objects " width:175 align:#left
		button btn4 "matid from selected objects "width:175 align:#right offset:[0,-26.5]
		button btn5 "objid from hero models (wip) " width:175 align:#left
		button btn6 "matid from hero models (wip)"	width:175 align:#right	offset:[0,-26.5]
		
		on btn1 pressed do
		(
		dyOBJRenderElementsForObjects (geometry as array)
		)
		on btn4 pressed do
		(
		dyMaterialRenderElementsForObjects (selection as array )
		)	
		on btn2 pressed do
		(
		dyMaterialRenderElementsForObjects (geometry as array)
		)	
		on btn3 pressed do
		(
		dyOBJRenderElementsForObjects (selection as array)
		)
		
	
)


rollout objRollout "Obj Utils"
(

	button DyBatchExportDialogShowbtn "batch Export utility" align:#left
	
	
	button dyObjectReplacerShowbtn "Replace objects utility" align:#left
	
	button dyRenameAllbyLayerbtn	 "rename all objects by layer" align:#left
	
		
	button createVrMeshbtn	 "create new vrmesh" align:#left

	
	
	on DyBatchExportDialogShowbtn	 pressed do
	(
		DyBatchExportDialogShow()
	)	
	
	on dyObjectReplacerShowbtn pressed do 
	(
		dyObjectReplacerShow()
	)
	
	on createVrMeshbtn	 pressed do
	(
		StartObjectCreation VRayProxy
	)	
	
	button exportFoldertoVrMeshbtn	 "export folder to vrmesh (wip)" align:#left
	
	on exportFoldertoVrMeshbtn	 pressed do
	(
		dyRenameAllbyLayer()
	)	
	

)

rollout meshRollout "Mesh Utils"
(
	button dydetachPolygonsbtn	 "detach Polygon islands" align:#left
	on dydetachPolygonsbtn	 pressed do
	(
		dydetachPolygons()
	)	
)



rollout lightRollout "Light stuff"
(
	button threepointbtn "create three point light (wip)" align:#left

)

rollout materialRollout "Material Stuff"
(
	
	
	button VrayCleanUnusedMaterials "Clean unused materials" align:#left	
	on VrayCleanUnusedMaterials pressed do
	(
		dyVrayCleanUnusedMaterials()
	)
	button relinkMaterialsBtn "relink materials"  align:#left	
	on relinkMaterialsBtn pressed do
	(
		dyUpdateMaterials (selection as array)
	)
	button dyExtractMaterialbtn "Exctract Material from scenes/folder"  align:#left	
	on dyExtractMaterialbtn pressed do
	(
		dyExtractMaterial()
	)
	button dyMaterialStufferbtn "Move materials to Matlib"  align:#left	
	on dyMaterialStufferbtn pressed do
	(		
		dyMaterialStuffer()
	)	
	
		button vrayMatConverterbtn "Open Vray Material Converter"  align:#left	
	on vrayMatConverterbtn pressed do
	(	
	createDialog vraySceneConverterRollout
)	
	
)





rollout textureRollout "Texture Stuff"
(
	button dyVrayInsertTileBitmapTexbtn "tile all bitmaps"  align:#left	
	on dyVrayInsertTileBitmapTexbtn pressed do
	(
		dyVrayInsertTileBitmapTex()
	)		
	button dyVrayBitmapNoFilteringbtn "turn of bitmap filtering for all bitmaps" align:#right	offset:[-0,-26.5]
	on dyVrayBitmapNoFilteringbtn pressed do
	(
		dyVrayBitmapNoFiltering()
	)		
	
	button dybmapNamefromFilenamebtn "bitmap node name from filename"  align:#left	
	on dybmapNamefromFilenamebtn pressed do
	(
		dybmapNamefromFilename()
	)	
	
)


rollout nukeRollout "Nuke"
(
	button sendToNukebtn "send To Nuke " align:#left	
	on sendToNukebtn pressed do
	(
		dyNuke()
	)
)

rollout psRollout "Photoshop (not currently working)"
(
	button sendToPSbtn "send To Photoshop (wip) " align:#left	
	button sendBitMapToPSbtn "send selected bitmap to PS (wip) " align:#left	
	on  sendToPSbtn pressed do
	(
		--dySendToNuke()
	)
	
)

rollout aeRollout "After Effects"
(
	button sendToAEbtn "send To After Effects" align:#left	
	on  sendToAEbtn pressed do
	(
		dyAE()
	)
	
)


rollout inforollout "info"
(
	label infolabel "info"   align:#center
	label Actionlabel ""   align:#center
	
	
	fn setinfo = (
		infolabel.text = ("Working in project "+dyproject+"   ("+dyCustomer+")")
		)
	on inforollout open do (		
		setinfo()
	)	
	
)

dyMasterDialog_Rollouts = #(
#("Project",#(projectRollout,newclientRollout,newprojectRollout,inforollout)),
#("Scene",#(sceneNewRollout,sceneLoadRollout,PublishSceneVersionRollout,inforollout)),
#("Asset",#(assetRollout,loadAssetRollout,PublishAssetVersionRollout,inforollout)),
#("InterOp",#(nukeRollout,psRollout,aeRollout,mailKitten,inforollout)),	
#("obj Utils",#(objRollout,meshRollout,inforollout)),
#("Render Utils",#(renderRollout,lightRollout,renderElementsRollout,inforollout)),
#("Mat utils",#(materialRollout,textureRollout,inforollout))
)	

rollout dyMasterDialog "DynaGraph Master Dialog"
(
	dotNetControl dn_tabs "System.Windows.Forms.TabControl" height:20 width:400 align:#center
	subRollout theSubRollout width:400 height: 500 align:#center
	
	
	
	label infolabel "info"  width:400 height:16	 align:#center offset:[200,0]
	--edittext infotext    width:390 height: 30 align:#center offset:[-2,0]
	
	
		local projectDirs
	
	-- #######################################
	-- functions
	-- #######################################
	
	
	


	
	fn initproject2 = (
		print "init project"
		
		client = projectRollout.costumers.items[projectRollout.costumers.selection]
		dyCustomer = client		
		
		print client
		
		-- project texture directory			
		filein(dyProjectBase + dyCustomer +   "\\startup\\projectdefinition.ms" )
		
		projectRollout.projects.items  = dyProjectList
		
		)
	
	
	fn init =
	(
		items = #()
		projectDirs = #()			
		
				
		for projectShare in dyProjectShares do
		(
			paths = filterString projectShare "\\"
			print paths[paths.count]			
			append items paths[paths.count]
			--append projectDirs projectShare
		)
				
		projectRollout.costumers.items = items		
	
		if (dyCustomer == undefined ) then(
			projectRollout.costumers.selection = 1
			client = projectRollout.costumers.items[projectRollout.costumers.selection]
			dyCustomer = client	
			
			) else (
			projectRollout.costumers.selected = dyCustomer
		)
		
		
			
		try(initProject() )catch(dyProjectList= #("please reload client")	)		
		filein(dyProjectBase + dyCustomer +   "\\startup\\projectdefinition.ms" )		
		projectRollout.projects.items = dyProjectList
	
		if (dyProject == undefined ) then(
			projectRollout.projects.selection = 1
			project = projectRollout.projects.items[projectRollout.projects.selection]
			dyProject = project	
			) else (			
			projectRollout.projects.selected = dyProject
			)
				
		initProject()
		
	)
	
	-- #######################################
	-- Actions
	-- #######################################

	on dn_tabs Selected itm do
	(
		if LastSubRollout != (itm.TabPageIndex+1) do --do not update if the same tab clicked twice
		(
			for subroll in dyMasterDialog_Rollouts[LastSubRollout][2] do
			
			removeSubRollout theSubRollout subroll
			--theSubRollout.subroll.visible  = false
			for subroll in dyMasterDialog_Rollouts[LastSubRollout = itm.TabPageIndex+1][2] do
			--theSubRollout.subroll.visible  = true		
			addSubRollout theSubRollout subroll
		) 
	)--end tabs clicked


	
on projectRollout.projects selected project do (

	)	

	on dyMasterDialog open do
	(
		for aTab in dyMasterDialog_Rollouts do
		(
			dn_tabs.TabPages.add aTab[1]
		)
		for subroll in dyMasterDialog_Rollouts[1][2] do (
			
		addSubRollout theSubRollout subroll	
		)
	)
	
) --end rollout


fn dyMasterDialogShow = (
	filein(dyProjectBase + dyCustomer +   "\\startup\\projectdefinition.ms" )	
	initProject()
	try(destroyDialog dyMasterDialog )catch()
	dySafeInitProject()
	dyMasterDialog.init()
	createDialog dyMasterDialog 400 530
	

)
			
	



