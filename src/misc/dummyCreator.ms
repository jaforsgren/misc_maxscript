

-- Calculates the axis-aligned bounding box corners of an object
fn getAABBoxPoints obj = (
	local aabbPoints = #()

	-- Get minimum and maximum bounding box coordinates
	local bbMax = obj.max
	local bbMin = obj.min

	-- Build the axis-aligned bounding box corners

	append aabbPoints (Point3 bbMax.x bbMax.y bbMax.z)	-- top-right-front corner
	append aabbPoints (Point3 bbMax.x bbMin.y bbMax.z)	-- top-right-back corner
	append aabbPoints (Point3 bbMin.x bbMin.y bbMax.z)	-- top-left-back corner
	append aabbPoints (Point3 bbMin.x bbMax.y bbMax.z)	-- top-left-front corner

	append aabbPoints (Point3 bbMax.x bbMax.y bbMin.z)	-- bottom-right-front corner
	append aabbPoints (Point3 bbMax.x bbMin.y bbMin.z)	-- bottom-right-back corner
	append aabbPoints (Point3 bbMin.x bbMin.y bbMin.z)	-- bottom-left-back corner
	append aabbPoints (Point3 bbMin.x bbMax.y bbMin.z)	-- bottom-left-front corner

	return aabbPoints
)

-- Calculates the oriented bounding box corners of an object
fn getOBBoxPoints obj = (
	local obbPoints = #()

	-- World-space transform
	local worldSpaceXform = obj.transform

	-- World-space to object-space transform
	local objectSpaceXform = inverse worldSpaceXform

	-- Transform the object from world-space to object-space
	obj.transform *= objectSpaceXform

	-- Get the object-space axis-aligned bounding box corners
	aabbPoints = getAABBoxPoints obj

	-- Transform back to world-space
	obj.transform = worldSpaceXform

	-- Transform the eight corners from object-space to world-space
	for pt in aabbPoints do (
	append obbPoints (pt * worldSpaceXform)
	)

	return obbPoints
)


fn getSize obj = (
	
	bb = getOBBoxPoints obj
	print "\n\n"
	print bb
	print "======================"
	maxyVal = bb[1][2]
	minyVal =  bb[1][2]
	maxxVal =  bb[1][1]
	minxVal =  bb[1][1]
	
	for i in bb do (
	
		if ( i[1] > maxxVal ) then (maxxVal =  i[1]  )
		if ( i[1] < minxVal ) then (minxVal =  i[1]  )
	
		if ( i[2] > maxyVal ) then (maxyVal =  i[1]  )
		if ( i[2] < minyVal ) then (minyVal =  i[1]  )
			
	
	)
	
	sizeX = abs ( minxVal - maxxVal)
	print sizeX 
	--print minyVal
	--print maxyVal
	sizeY = abs( minyVal - maxyVal )
	
	--print sizeX 
	print sizeY
	
	return #(sizeX,sizeY)
	
)





fn RotatePivotOnly obj match =
(
	rot = match.transform  as quat
	rotValInv=inverse rot
	animate off in coordsys local obj.rotation*=RotValInv
	obj.objectoffsetrot*=RotValInv
	obj.objectoffsetpos*=RotValInv
)



newdummy = dummy()
newdummy.name = uniquename("Bounding_Box_01")

newdummy.rotation = $.rotation 
size = getsize $ 
Dumsize = Dummin - Dummax


dumsize.x = size[1]
dumsize.y = size[2]
dumsize.z = size[3]
dumsize.x = --abs(dumsize.x)
dumsize.y = --abs(dumsize.y)
dumsize.z = abs(dumsize.z)

newdummy.boxsize = dumsize
newdummy.pos = $.center
--rotatePivotOnly newdummy $
-- and now fix pivot.

--wdummy.pivot = [0,0,0]


/*
s = selection as array
for j in s do
(
j.parent = newdummy
)
*/
