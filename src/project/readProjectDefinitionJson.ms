
 struct ProjectDefintions (
	Project = "Autumn_201project017",
    Task   = "1.1",
    Environment = "Environment001_01",
	SubProducts = #()
	Configuration =#()
)

 struct Configuration (
	Filename = "",
	Product = #()
)

 struct Product (
	name = "",
    Model   = "",
    Elevation = "",
	subProducts = #()
)
 struct subProduct (
	  name = "",
    Model   = "",
    subProducts = #()
)

fn recurseJData jdata=(
	tab=""
	fn tabIn=(tab += "\t")
	fn tabOut=(	try(tab = replace tab 1 1 "")catch())
	tabIn()
	JTokenTypes = #("\\","\\")
	local data=jdata
	local typeIndex=data.type.value__
	local dType=JTokenTypes[typeIndex+1]

	case data.hasValues of (
	true:(
		case data.type.value__ of (
				4:(		
					local key=data.name
					local val=data.value
					format "\n%:" key
					recurseJData val
				)
				1: (
					format "\n%{" tab
					local oc=0
					local objData=data.first
					for oc=1 to data.count do(
						if objData == undefined do(format " ERROR: obj: %" objdata; continue)
						recurseJData(objData)
						objData=objData.next
					)
					oc=0
				)

				2: (
					format "\n%[" "" 
					local jArray=data	
					for i=1 to jArray.count do(
						element=jArray.item(i-1)
						recurseJData(element)
					)
					format "\n%]" ""
				)	
			)
		)
		false:(
			case data.type.value__ of (
				6:(
						format " %"data.value
					)
				7:(
						format " %"data.value
					)
				8:(
					format "\"%\""data.value 
					)
				9:(
					format " %"data.value
					)
				default: (
					format "% WARNING: unexpected JTokenType (%-%) in {%}" tab typeIndex dType currentItem
					)
			)
		)
	)
)
