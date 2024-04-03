--	Collapse Elements
--
--	Written by Kevin Deadrick (Monolith) for F.E.A.R. project development.
-- 
--	v1.0 RELEASE
--
--	Macro Function: Extrude Edit Poly w/ zero length


macroScript ZeroExtrude
ButtonText:"Zero Length Extrude"
Category:"FEAR" 
Tooltip:"Zero Length Extrude" 
(

on isEnabled return selection.count == 1 and classof selection[1].baseobject == Editable_Poly
on execute do
(
polyop.ExtrudeFaces $.baseobject (polyop.GetFaceSelection $.baseobject) 0.0
)
)