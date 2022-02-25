	fn bakeCloth = (

	endframe = 15
	startframe = 0
	
LayerManager.newLayerFromName "Pillows"
	layer2= LayerManager.getLayerFromName "Pillows"
	layer2.current = true


	objs = selection as array

		if (selection[1] != undefined) then
		(
		obj = selection[1]
		snapshots = #()
		vertcount = getnumverts obj
		--tomesh = Edit_Mesh()
			--addModifier obj tomesh
		local	newobj = copy obj
			newobj.name = obj.name + "_simulated_"
			converttomesh newobj

		animatevertex newobj #all
		--addModifier newobj tomesh

		for f = startframe to endframe by 1 do
		(
		
			animate on (
				at time f
				(
					

					curobj = snapshot obj
					if (getnumverts curobj) == vertcount then
					(
						--progressupdate ((f * 100) * ticksperframe / (animationrange.end - animationrange.start) as integer)
						for v = 1 to vertcount do
						(
							coordsys world(
								newobj[4][1][v].controller.value = coordsys local((getvert curobj v))
								newobj.rotation.controller.value = coordsys local(curobj.rotation.controller.value)
								newobj.position.controller.value = coordsys local(curobj.position.controller.value)
								newobj.scale.controller.value = coordsys local(curobj.scale.controller.value)
							)
						)
						delete curobj					

					)
				) 


			)
		)
		
	
		layer0 = layermanager.getlayer 0
		layer0.current = true

		delete objs
		
		select newobj
		
	--	ProgressEnd ()
	)--if then
	
)

	
	
	
	
	
	
	
	
	
	
	
fn dropCushion objlist =		
(	
	
	
	filein(@"...\shared\workgroups\max\scripts\dyRay.ms")
	print "filin"
	filein(@"...\shared\workgroups\max\scripts\dyRay.ms")	
		
		
	--###########################################################################################
	-- CollisionSofa
	--######################################
		layer0 = layermanager.getlayer 0
		layer0.current = true
		
		
		--SofaParent = (dygetNodesRoot (selection as array))[1]
		SofaParent = (dygetNodesRoot objlist)[1]
		select objlist
		
		
		
		l = #()
		for i in selection do (
			
			if ( classof i) == Dummy then(
				print i.name
				)
			else(
				print i 
				new_obj = copy i
				append l new_obj
				)	
			
			)
			
		g = group l 
		g.parent = undefined
		g.name = "CollisionSofaGrp"
		select g
		
		max create mode
		disableSceneRedraw()
		with undo off
		(
	 
			local sel = for o in selection where superclassOf o == geometryClass collect o
			local meshO = sel[1]
			deleteItem sel (findItem sel meshO)
	 
			convertToMesh meshO
	 
			for o in sel do attach meshO o
			meshO.parent = undefined 
			meshO.name = "CollisionSofa"
			delete $CollisionSofaGrp
	 
		)
		enableSceneRedraw()	
			
		select $CollisionSofa



	--###########################################################################################
	--ProppingPlane
	-- important to try and get all dimensions before seting pos/ widht/height
	--######################################

	s = $CollisionSofa
	minPos = s.min[1]
	maxPos = s.max[1]	
	armchairlenght = 50	

	planelenght = 30
	p = plane()
	p.position.z = 55
	p.name = "PropPlane"
	p.position.x = $CollisionSofa.center[1]
	p.position.y = $CollisionSofa.center[2] -  (planelenght/2)
	p.width = ( (abs(maxPos - minPos) ) - armChairlenght  ) 
	p.length = planelenght
	
	
	maxX = dyObjectRay $CollisionSofa  $Propplane 10 axis:#x positiveDir:false	
	minX = dyObjectRay $CollisionSofa  $Propplane 10 axis:#x positiveDir:true		
	

	--#########################
	--  get edge of sofa
	--#########################
	
	redrawViews() 	
	sleep 1

	propPlane =$Propplane
	maxPos = undefined

	for i=1 to 20 do (
		print i 
		step = -7
		y = Propplane.min.y + ( i*step)
		pos =  [Propplane.center.x,y,Propplane.center.z]		
		p = dyRay pos $CollisionSofa --positiveDir:True
		
		if p != undefined then (	
		maxPos = p.pos.y		
		)
		else(
			exit
			)			
	)



	-- place propplane z axis
	propPlane= $Propplane
	i = dyObjectRay $CollisionSofa  $Propplane 30
	if i!=undefined then
		(
			propPlane.pos.z=i + 0.2
		)
	-- determine lenght of propplane... 
		


	redrawViews() 	
	sleep 1


	--#########################
	--  set widht and lenght
	--#########################

		-- place propplane y axis
	i = dyObjectRay $CollisionSofa  $Propplane 10 axis:#Y positiveDir:true	

	if i!=undefined then
		(
			if  maxpos!=undefined then (
				len = abs(maxpos - i)
				propPlane.length = len		
				propPlane.pos.y=(i + 1) - (propPlane.length/2)
			)
		)
	
		
		


	propPlane.pos.x = $CollisionSofa.center.x
	propPlane.width = abs(maxX-minX)-10
		


	redrawViews() 	
	sleep 1
		
		

		

	-- place propplane y axis
	i = dyObjectRay $CollisionSofa  $Propplane 50 axis:#Y positiveDir:true	
	if i!=undefined then
		(
			propPlane.pos.y= i - (propPlane.length/2)
		)
			
		

		









	redrawViews() 	
	sleep 1
		
		
		
	--#############################################################################################
	--Pillows
	--######################################


	pillowpath = @"...\Development\3D\Komponentbibliotek\Props_Sets\"
	p1 = pillowpath + "Pillow_Model001.max"
	p2 = pillowpath + "Pillow_Model002.max"
	p3 = pillowpath + "Pillow_Model001_small.max"

	LayerManager.newLayerFromName "Pillows"
	pillowLayer= LayerManager.getLayerFromName "Pillows"

	mergeMAXFile  p1 #mergeDups #useSceneMtlDups #select quiet:true
	pillow1 = selection[1]
	pillowLayer.addnode pillow1
	pillow1.parent = SofaParent
		redrawViews() 	
	sleep 1
	mergeMAXFile  p2 #mergeDups #useSceneMtlDups #select quiet:true
	pillow2 = selection[1]
	pillowLayer.addnode pillow2
	pillow2.parent = SofaParent
		redrawViews() 	
	sleep 1
	mergeMAXFile  p3 #mergeDups #useSceneMtlDups #select quiet:true
	pillow3 = selection[1]
	pillowLayer.addnode pillow3
	pillow2.parent = SofaParent
		redrawViews() 	
	sleep 1


	pillows = dyGetObjectsByLayerName "Pillows"-- ($Pillow* as array)



	--pillow2 =pillows[3]
	--pillow3 = pillows[2]

	intoSofa = 5
	intoSofaRight1 = 12
	intoSofaRight2 = 0
	
	



	pillow1.pos = propPlane.min 
	pillow1.position.x = pillow1.position.x + ( abs(pillow1.max[1]-pillow1.min[1]) *0.3 )	
	pillow1.position.y = propPlane.center.y  + intoSofa 
	pillow1 .rotation.x_rotation = 0
	pillow1 .rotation.y_rotation = 0
	pillow1 .rotation.z_rotation = 65
	redrawViews() 	
	sleep 1

	pillow2.pos = propPlane.max
	pillow2.position.x = pillow2.position.x  - ( abs(pillow2.max[1]-pillow2.min[1]) *0.4 ) + (3)
	pillow2.position.y = propPlane.center.y  + intoSofaRight1 
	pillow2.rotation.y_rotation = 0
	pillow2.rotation.z_rotation = -15

	redrawViews() 	
	sleep 1
	pillow3.pos = propPlane.max
	pillow3.position.z = pillow3.position.z +20
	pillow3.position.x = pillow3.position.x  - ( abs(pillow3.max[1]-pillow3.min[1]) *0.4 ) +(-10)
	pillow3.position.y = propPlane.center.y  + intoSofaRight2 
	pillow3.rotation.x_rotation = 0
	pillow3.rotation.y_rotation = 0
	pillow3.rotation.z_rotation = 0


	redrawViews() 	
	sleep 1


	--#############################################################################################
	--  SIM
	--######################################

	cloth_obj = #($CollisionSofa) + (($Pillow* )as array)

	for  pillow in cloth_obj do(
		print pillow
		for theModifier in pillow.modifiers where classOf theModifier == Cloth do (
			deleteModifier pillow theModifier
		)
	)

	pillows =  (($Pillow* )as array)
	clth=cloth()
	clth.enableEndFrame = true
	clth.endFrame = 30
	clth.selfCollision = True
	addmodifier cloth_obj clth



	--addmodifier  collesion_obj clth
	--addModifier collesion_obj (cloth_obj.modifiers[#Cloth])
	max modify mode

	--modpanel.setcurrentobject clth
	--clth.ClothOps.SetObjectType cloth_obj  2 true
		
		
		
	for i in cloth_obj do(
					
		

		if  (findItem  pillows i ) == 0 then  (
			--try(
			print i.name
			modpanel.setcurrentobject i
			clth.ClothOps.SetObjectType i 1 true  -- set as colisioen object
			clth.ClothOps.SetObjectProperty i "depth" 1.0
			clth.ClothOps.SetObjectProperty i "offSet" 0.1
			clth.ClothOps.SetObjectProperty i "dynFric" 0.1
			clth.ClothOps.SetObjectProperty i "staticFric" 0.5
			clth.ClothOps.SetObjectProperty i "EnableCollisions" true
			
			
			--)catch(print "Failed")		
		)else(
			
			modpanel.setcurrentobject i		
			clth.ClothOps.SetObjectType i 2 true	
			clth.ClothOps.setObjectProperty $ "damping" 0.2
			clth.ClothOps.setObjectProperty $ "Pressure" 15
		
			)	
		
	)

	select pillows[1]
	max modify mode

	clth.startframe
	clth.endframe
	clth.simulate true




	--#############################################################################################
	-- Cleanup 
	--######################################
	delete propPlane
	delete $CollisionSofa

	--bakeCloth()

	
	LayerManager.newLayerFromName "Sofa"
	sofaLayer= LayerManager.getLayerFromName "Sofa"

	try(
		sofaLayer.addNode sofaParent
		for  i in sofaParent.children do (  sofaLayer.addNode  i ) 
	)catch()	
	


	for i = (layerManager.count - 1) to 1 by -1 do (
		if (layerManager.deleteLayerByName (layerName = (layerManager.getLayer i).name)) then (
		format "Deleted empty layer: %\n" layerName
		)
	)
	pillows.parent = SofaParent

)



dropCushion ($*  as array)
