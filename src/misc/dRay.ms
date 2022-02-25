fn dyObjectRay  IntersectObject OriginObject  samples axis:#z  positiveDir:false= (
	

	dirMultiplier = [0,0,-1]
		
	if positiveDir == true then (dir = 1) else(dir = -1)
	if axis == #x then (dirMultiplier  = [-1,0,0] *dir )
	if axis == #y then (dirMultiplier  = [0,-1,0]  *dir )	
	index = 3
	if axis == #x then (	index = 1)
	if axis == #y then (	index = 2)	
	
	if samples == 1 then (
		
		print "one sample: using center"
		p = dyRay OriginObject.center IntersectObject  axis:axis positiveDir:positiveDir
		
		if p != undefined then (		return p.pos[index] )
		else ( return undefined)
		
		)
		
	else 	(	
		
		print "multiple samples: Generating...."
		
		points = dyGenerateRandomPointsOnSurface OriginObject samples

		result = undefined
		
		for sPoint in points do (			
			
			p = dyRay sPoint IntersectObject axis:axis	positiveDir:positiveDir
			
			if result == undefined then (  
				if p != undefined then (
					result = p.pos[index]
					)
					else(
						--print "ray is undefined"
						result = undefined
						)
				) 
			
			else(	
				
				if positiveDir then (		
						try(
						if p.pos[index] < result then (result = p.pos[index])
						)catch(--print "undefined"
							result = undefined
							)
					
					)
					
					else (
						try(
						if p.pos[index]  > result then (result = p.pos[index])
							)catch(--print "undefined"
							result = undefined
							)
					
						)					
				)		
			)
			return result
		) -- end multple samples
)


	
	
fn dyRay origin IntersectObject axis:#z positiveDir:false= (
	
	dirMultiplier = [0,0,-1]
	if positiveDir == true then (dir = -1) else (dir =1) 
	if axis == #x then (dirMultiplier  = [-1,0,0] *dir )
	if axis == #y then (dirMultiplier  = [0,-1,0]  *dir )

	r=ray origin dirMultiplier
	if (i=(intersectray IntersectObject r))==undefined then
		(
			r.dir*=dirMultiplier * -1
			i=(intersectray IntersectObject r)	
		)
		
	return i 		
	
)
	


	
	
	