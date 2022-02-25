-- FUNKAR DETTA P� GRUPPER?!
-- m�ste extrahera fr�n grupper

global dyListMaterialsOnObject
global dyMaterialRenderElementsForObjects
global dyOBJRenderElementsForObjects

fn dyMaterialRenderElementsForObjects objlist =
(
    uniqueMaterials = #()
    for geomObj in objlist do
    (
        if(geomObj.material != undefined) then
        (
              uniqueMaterials = dyListMaterialsOnObject geomObj.material   uniqueMaterials
        )
        else
        (
            print ("Material for: " + geomObj.name + " is undefined, will be skipped")
        )   
    )
    
     matID = 1000 
    currentRenderElementMgr = maxOps.GetCurRenderElementMgr() -- Get render Manager
    MME = MultiMatteElement
    
    for mat in uniqueMaterials do (
        
        print (mat.name)        
        print matID
            
            materalId = "MtlID_"+mat.name
            -- set effects channel
            mat.effectsChannel = 0
            mat.override_effect_id = on
            mat.effect_id = matID                           
            --mat = "MtlID" + elementId as string -- name to new renderelement based on the effect id
            currentRenderElementMgr.addRenderElement (MME elementname:materalId enable:true isMatID:true)
            element = currentRenderElementMgr.GetRenderElement (currentRenderElementMgr.NumRenderElements()-1)          
            element.R_gbufIDOn = true
            element.R_gbufID = matID            
            element.G_gbufIDOn = false
            element.G_gbufID = matID            
            element.B_gbufIDOn = false
            element.B_gbufID = matID 
            matID =  matID + 1   
        )   
)



fn dyListMaterialsOnObject materialNode  uniqueMaterials =
(
	print materialNode.name
    if( (ClassOf materialNode ) == Multimaterial ) then
    ( 
        for i = 1 to materialNode.count do
        (
            multiMaterialNode = materialNode[i]
            if (multiMaterialNode != undefined ) then -- happens on some objects
            (
                dyListMaterialsOnObject multiMaterialNode  uniqueMaterials
            )           
        )
    )
	
	else if( (ClassOf materialNode ) == VRayBlendMtl ) then( 	
	dyListMaterialsOnObject materialNode.baseMtl   uniqueMaterials
	for multiMaterialSubNode in  materialNode.coatMtl  do 
		(	
		
		 if (multiMaterialSubNode != undefined) do(
			 --print multiMaterialNode
			 dyListMaterialsOnObject multiMaterialSubNode  uniqueMaterials
			 )	 	 
		)
	)
    else (
    if( (ClassOf materialNode ) ==  VrayMtl ) then 
    (        
        materalId = materialNode.name                   
                    appendifUnique uniqueMaterials materialNode
            )         
    )
    -- vrayblendmtl
    if( (ClassOf materialNode ) ==  VrayBlendMtl ) then 
    (
        materalId = materialNode.name
       
                materials = getClassInstances VrayMtl target:materialNode 
                for m in materials do
                (    
                    appendifUnique uniqueMaterials materialNode
                )           
    )
        return uniqueMaterials
)

fn  dyOBJRenderElementsForObjects objlist = 
(
	 matID = 1000  
    currentRenderElementMgr = maxOps.GetCurRenderElementMgr() -- Get render Manager
    MME = MultiMatteElement
    for obj in objlist do (
            materalId = "ObjID_"+obj.name
			obj.gbufferChannel = matID
            currentRenderElementMgr.addRenderElement (MME elementname:materalId enable:true isMatID:false)
            element = currentRenderElementMgr.GetRenderElement (currentRenderElementMgr.NumRenderElements()-1)          
            element.R_gbufIDOn = true
            element.R_gbufID = matID            
            element.G_gbufIDOn = false
            element.G_gbufID = matID            
            element.B_gbufIDOn = false
            element.B_gbufID = matID 
            matID =  matID + 1   
        )
)

