--	Weld Redundant Points
--
--	Written by Kevin Deadrick (Monolith) for F.E.A.R. project development.
-- 
--	v1.0 RELEASE
--
--	Macro Function: Welds all redundant points w/in 0.1 threshold for all objects in selection
--	

macroScript WeldPoints
ButtonText:"Weld Redundant Points"
Category:"FEAR" 
Tooltip:"Weld Redundant Points" 

(

on isEnabled return selection.count > 0 and superclassof selection[1].baseobject == GeometryClass

on execute do
(
	local UndoString = "Weld Redundant Points"
	undo label: undoString on
			
local wpDebug = true -- Set my local debug string
	
	SelectionArray = selection as array

	for i in selection do
	(
	
-- Convert to EPoly
	MeshObject = i
	convertTo i (Editable_Poly)

	if wpDebug == true do (print i) -- Print Debug selection

-- Set the Welding Threshold
	CurrentThreshold = MeshObject.weldThreshold -- Store Setting
	MeshObject.weldThreshold = 0.1
-- Weld Verticies
	polyOp.weldVertsbyThreshold MeshObject #all
-- Restore User Settings
	MeshObject.weldThreshold = CurrentThreshold -- Restore Setting
	)

)) -- End of Macroscript