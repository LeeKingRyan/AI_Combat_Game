macroscript BatchExportCA
ButtonText:"Batch Export Attributes"
Category:"FEAR" 
Tooltip:"Batch Export Attributes"

(

on isEnabled return selection.count > 0 

on execute do
(
for i in selection do
	(
	if superclassof i.baseobject == GeometryClass do (fileIn "$scripts\FEAR\BatchExport_CA.ms")
	)
)


) -- End Macroscript