
fn CalculateVolumeAndCenterOfMass obj =
(
	if ( (superclassof obj) == GeometryClass) then (
	local Volume= 0.0
	local Center= [0.0, 0.0, 0.0]
	local theMesh = snapshotasmesh obj
	local numFaces = theMesh.numfaces
	for i = 1 to numFaces do
	(
	  local Face= getFace theMesh i
	  local vert2 = getVert theMesh Face.z
	  local vert1 = getVert theMesh Face.y
	  local vert0 = getVert theMesh Face.x
	  local dV = Dot (Cross (vert1 - vert0) (vert2 - vert0)) vert0
	  Volume+= dV
	  Center+= (vert0 + vert1 + vert2) * dV
	)
	delete theMesh
	Volume /= 6
	Center /= 24
	Center /= Volume
	return #(Volume,Center)
	) else (return #(0.0,[0,0,0])) 
)

fn getLargest objlist = (
	largest = objlist[1]
	largestval = abs( (CalculateVolumeAndCenterOfMass largest )[1] )
	for  node in  objlist do(
	
		nodeVal = 	abs ( (CalculateVolumeAndCenterOfMass node )[1] )	
	
		if ( nodeVal > largestval )  then (
			
			largest = node
			largestval = nodeVal
			)		
		)
	return largest
)
	

--getLargest (selection as array)



fn bemzUVWFlattenMap objArr mapChannel:1 = 
	(
		clearSelection()
		SetCommandPanelTaskMode #modify

		modName = "dyFlattenUnWrap"

		with redraw off
		(
			for node in objArr where validModifier node (modifier = Unwrap_uvw()) do
			(
				if ( (superclassof node) == GeometryClass) then (
					try(
					dyDeleteModifierByName #(node)  modName
					)catch()
					print node
					modifier.name = modName
					addModifier node modifier ui:on
					print mapChannel
					node.modifiers[1].setMapChannel mapChannel
					select node ; modPanel.setCurrentObject modifier
					print "unvwrapping"
					
					--node.modifiers[1].flattenMap 80.0 #([1,0,0], [-1,0,0], [0,1,0], [0,-1,0], [0,0,1], [0,0,-1]) 0.02 on 0 off on		

					-- determine if pillows are lying or standing:
					normallist = #([0,1,0], [0,-1,0], [1,0,0], [-1,0,0], [1,1,0], [-1,0,0])  
					angelTresh = 75.0-- funkar pa kuddar, men inte sits
					spacing = 0.02
					normalizeUV = off 
					layOutType = 1
					rotateClusters = off
					fillHoles  = on 
					
					a = (node.max - node.min)					
					x = abs(a[1])
					y = abs(a[2])
					z = abs(a[3])
					
					
					
					if z > y then (
						print "object is standing, applying normals"
						normallist = #([0,1,0], [0,-1,0], [1,0,0], [-1,0,0], [1,1,0], [-1,0,0])  
						)
					if y > z then (
						print "object is lying, applying normals"
						normallist = #([1,0,0], [-1,0,0], [0,1,0], [0,-1,0], [0,0,1], [0,0,-1]) 						)					
					if (y > x)  and (y > z)  then (
						print "object is standing against armrest, applying normals"
						normallist = #([0,1,0], [0,-1,0], [1,0,0], [-1,0,0], [1,1,0], [0,0,0])  	
						)				
							
					
					print "=========="
					base = getLargest objArr
					print base
					print node
					if node == base then (
						print "object is base, applying normals"
						normallist = #([0,1,0], [0,0,1], [0,0,1], [0,-1,0], [0,0,-1], [0,0,1]) 	
						angelTresh = 45.0-- funkar pa kuddar, men inte sits	
						rotateClusters = on						
						)
						
					node.modifiers[1].flattenMap angelTresh normallist spacing normalizeUV layOutType rotateClusters fillHoles
					
					
					)
			)
		)
	)
	
	
	
	
	fn dyDeleteModifierByName objlist modName =  (
	--	delete Edit_Mesh modifier
	for curObj in objlist do(
		for m in curObj.modifiers where m.name == modName do (
			print ("Deleteing modifier " + modName )
			deleteModifier curObj m
			)

		)
)






	

