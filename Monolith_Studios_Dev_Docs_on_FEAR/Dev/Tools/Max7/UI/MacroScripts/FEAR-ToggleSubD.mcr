--	Toggle Sub Divisions
--
--	Written by Kevin Deadrick (Monolith) for F.E.A.R. project development.
-- 
--	v1.0 RELEASE
--
--	Macro Function: Toggles "Use Sub Division" settings on any edit poly objects within the selection set.


macroscript toggleSmoothing
ButtonText:"Toggle Smoothing"
Category:"FEAR" 
Tooltip:"Toggle Sub Division Smoothing"

(
on isEnabled return selection.count > 0 and superclassof selection[1].baseobject == GeometryClass

on execute do
	(
	for i in selection do
		(
		if classOf i == Editable_Poly do
			(
			case i.surfSubdivide of 
				(
				false: i.surfSubdivide = true
				true: i.surfSubdivide = false
				)
			)
		)
	)
)

