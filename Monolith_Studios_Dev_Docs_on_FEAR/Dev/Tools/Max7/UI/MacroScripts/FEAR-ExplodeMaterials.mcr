--	Explode Elements
--
--	Written by Kevin Deadrick (Monolith) for F.E.A.R. project development.
-- 
--	v1.0 RELEASE
--
--	Macro Function: Seperates Mesh into Material components.  Each Material ID becomes a unique max node (object). 
--	Materials are retained.


macroscript ExplodeMaterials
ButtonText:"Explode Materials"
Category:"FEAR" 
Tooltip:"Explode Materials" 

(

on isEnabled return selection.count == 1 and superclassof selection[1].baseobject == GeometryClass
on execute do
	(
	emDebug = false -- Debug Set
	
	local UndoString = "Explode Materials" -- Set undo string
	local MeshCount = 0

-- Master Variables	

	MatName = $.material
	Original = selection[1]
	obj = copy selection[1]
	convertTo obj (Editable_Mesh) -- Make sure object is a "mesh" class type
	while obj.numfaces > 0 do
		(
-- Begin Chip off functions
		
		MatID = getFaceMatID obj 1 -- Sets Testing ID
		MeshArray = meshop.getElementsUsingFace obj #all
		DetachArray = #()

			for i in MeshArray do
			(
			MatCheck = getFaceMatID obj i
			if MatCheck == MatID do (append DetachArray i)
			)
-- End Building of Detach Array, Begin Detach Process

		if emDebug == true do (print MatID)

		newObj = Editable_Mesh() -- Create Destination Mesh Obj
		NewObj.transform = obj.transform -- Set Transform

-- Set ID to chip off
		tmesh = meshop.detachFaces obj DetachArray asmesh: true
		NewObj.mesh = tmesh		
		update newObj
		
-- Set Material(s)
		
		newObj.material = MatName
		
		if emDebug == true do (print newObj.material)
		
-- Convert over to EPoly (prefered)

		convertTo newObj (Editable_Poly)
		MeshCount += 1
		)

		delete obj
		
print (MeshCount as string + " Objects Created!")

		if querybox "Delete Original Mesh?        " beep: true title: "Confirm Operation:" then (delete Original) 
	)
)