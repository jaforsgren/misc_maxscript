




sittKuddar = #()
ryggKuddar = #()
sidoKuddar = #()
soffBen = #()
	
heromodels = (selection as array)

tmplist = heromodels


-- filter 
for nodeM in tmplist do (
	
	print nodeM.name
	if ( (superclassof nodeM) == GeometryClass) then (
	
	if nodeM.min[3] <= 1.0 then (
		print "under"
		if (abs (CalculateVolumeAndCenterOfMass nodeM)[1]) <=1000 then (
			print nodeM.name
			i = ( finditem 	tmplist nodeM)
			tmplist = (deleteItem tmplist i)
			append soffBen nodeM 
			)
		
		)
		)			

	
)

-- filter bas
base = getLargest heromodels
i = ( finditem 	tmplist base)
tmplist = (deleteItem tmplist i)
base.name = "Soffa_bas"	

for node in tmplist do (
	
	if ( (superclassof node) == GeometryClass) then (
			
		a = (node.max - node.min)					
		x = abs(a[1])
		y = abs(a[2])
		z = abs(a[3])
		
		
		
		if z > y then (
			print "object is standing, renaming"
			appendifUnique ryggKuddar node			
			)
		if y > z then (
			print "object is lying, renaming"
			appendifUnique sittKuddar node		
			)					
		if (y > x)  and (y > z)  then (
			print "object is standing against armrest, renaming"
			appendifUnique sidoKuddar node		
			)	
	)

)

i = 1
for node in sittKuddar do (
	node.name = "Soffa_sittKudde_"+(i as string)
	i = i+1	
	)
i = 1
for node in sidoKuddar do (
	node.name = "Soffa_sidoKudde_"+(i as string)
	i = i+1	
	)	
i = 1
for node in ryggKuddar do (
	node.name = "Soffa_ryggKudde_"+(i as string)
	i = i+1	
	)	
i = 1	
for node in soffBen do (
	node.name = "Soffa_soffBen"+(i as string)
	i = i+1	
	)	

	
	