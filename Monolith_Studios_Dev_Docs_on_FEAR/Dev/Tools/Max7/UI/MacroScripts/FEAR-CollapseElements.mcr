--	Collapse Elements
--
--	Written by Kevin Deadrick (Monolith) for F.E.A.R. project development.
-- 
--	v1.0 RELEASE
--
--	Macro Function: Collapses Selection to a single mesh object


macroScript CollapseElements
ButtonText:"Collapse Elements"
Category:"FEAR" 
Tooltip:"Collapse Elements" 
(

on isEnabled return selection.count > 1 and superclassof selection[1].baseobject == GeometryClass
on execute do
(
cmDebug = false

selectedObjects = selection as array
OperationArray = #()
local UndoString = "Collapse Mesh"
undo label: undoString on	
-- Filter out non geomtery objects

for i in selectedObjects do
	(
	if superclassof i.baseobject == GeometryClass do(append OperationArray i)
	)

	if cmDebug == true do (print selectedObjects)

-- Begin Operation if more than 2 objects are selected!

	if cmDebug == true do (print "Get Ready to Collapse!")
	BaseObject = OperationArray[1] -- Establish Base Object as 1st in array
	if cmDebug == true do (print BaseObject)
	
	convertTo BaseObject (Editable_Poly) -- Let's make sure the Base Object is in fact an Epoly

	for i in OperationArray do
		(
		if i != BaseObject do
			(
			convertTo i (Editable_Poly) -- Just in case let's convert to EPoly
			polyOp.attach BaseObject i 
			)
		)
	select BaseObject
	
)
)