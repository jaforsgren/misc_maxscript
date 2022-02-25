fn dyDeleteModifierByName objlist modName =  (	
	--	delete Edit_Mesh modifier
	for curObj in objlist do(
		for m in curObj.modifiers where m.name == modName do (
			print ("Deleteing modifier " + modName )
			deleteModifier curObj m
			)

		)
)

	
fn dyUVWFlattenMap objArr mapChannel:1 = if objArr.count != 0 do
(
	clearSelection()
	SetCommandPanelTaskMode #modify
	
	modName = "dyFlattenUnWrap"
	
	with redraw off
	(
		for node in objArr where validModifier node (modifier = Unwrap_uvw()) do
		(
			if ( (superclassof node) == GeometryClass) then (
				dyDeleteModifierByName #(node)  modName
				modifier.name = modName
				addModifier node modifier ui:on
				node.modifiers[1].setMapChannel mapChannel
				select node ; modPanel.setCurrentObject modifier
				print "unvwrapping"
				node.modifiers[1].flattenMap 80.0 #([1,0,0], [-1,0,0], [0,1,0], [0,-1,0], [0,0,1], [0,0,-1]) 0.02 off 0 off on
				)
		)
	)
)
uvwFlattenMap (selection as array) mapChannel:1
