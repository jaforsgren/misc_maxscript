	
	

	
	
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
		
	select meshOw
		
		