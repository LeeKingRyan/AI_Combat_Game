--	Explode Elements
--
--	Written by Kevin Deadrick (Monolith) for F.E.A.R. project development.
-- 
--	v1.0 RELEASE
--
--	Macro Function: Seperates Mesh into Element components.  Each element becomes a unique max node (object). 
--	Materials are retained.


macroscript ExplodeElement
ButtonText:"Explode Elements"
Category:"FEAR" 
Tooltip:"Explode Elements" 

(

on isEnabled return selection.count == 1 and superclassof selection[1].baseobject == GeometryClass
on execute do
	(
	emDebug = true -- Debug Set
	
	local UndoString = "Explode Mesh" -- Set undo string

-- Master Variables	

	MatName = $.material
	Original = selection[1]
	obj = copy selection[1]
	convertTo obj (Editable_Mesh) -- Make sure object is a "mesh" class type
	while obj.numfaces > 0 do
		(
-- Begin Chip off functions
		
		newObj = Editable_Mesh() -- Create Destination Mesh Obj
		NewObj.transform = obj.transform -- Set Transform
		tmesh = meshop.detachFaces obj (meshop.getElementsUsingFace obj #{1}) asmesh: true
		NewObj.mesh = tmesh		
		update newObj
		
-- Set Material(s)
		
		newObj.material = MatName
		
		if emDebug == true do (print newObj.material)
		
-- Convert over to EPoly (prefered)

		convertTo newObj (Editable_Poly)	
		)

		delete obj

		if querybox "Delete Original Mesh?        " beep: true title: "Confirm Operation:" then (delete Original) 
	)
)