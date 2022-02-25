cloth_obj = $
clth=cloth()
clth.enableEndFrame = true
clth.endFrame = 15
addmodifier $* clth
pillows = (selection as array)
objs  = objects as array
--addmodifier  collesion_obj clth
--addModifier collesion_obj (cloth_obj.modifiers[#Cloth])
max modify mode
--modpanel.setcurrentobject clth
--clth.ClothOps.SetObjectType cloth_obj  2 true
for i in objs do(
	if  (findItem  pillows i ) == 0 then  (
		--try(
		print i.name
		modpanel.setcurrentobject i
		clth.ClothOps.SetObjectType i 1 false  -- set as colisioen object
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
		clth.ClothOps.setObjectProperty $ "Pressure" 10
		)
)
clth.simulate true