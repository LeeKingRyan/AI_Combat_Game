--
--	Copy Lite
--
--	Written by Kevin Deadrick (Monolith) for F.E.A.R. project development.
-- 
--	v1.0 RELEASE
--
--	Macro Takes selection array and makes each object unique.
--


macroScript CopyLT category:"FEAR" buttonText: "Copy Lite"
(
on isEnabled return selection.count > 0

on execute do
(
CopyLTDebug = false

-- Establish Selection Array

	SelArray = selection as array
	DuplicateArray = #()
-- Check for objects.  If none then let user know

	if SelArray.count == 0 do (messagebox "Please Select Some Objects!  " title: "WARNING: No Objects Selected!        ")

	if SelArray.count != 0 do 
	(
	if CopyLTDebug == true do (Print "Performing Copy")

			
			
-- Establish Undo String

		local UndoString = "Duplicate"
		undo label: undoString on

-- Search through the selection and make instanced objects unique
		
		for i in SelArray do
		(

		DuplicateObject = copy i
		append DuplicateArray DuplicateObject

		print (SelArray.count as string + " Object(s) Duplicated")
			
		)

		select DuplicateArray

		if CopyLTDebug == true do (print DuplicateArray)
	)

)) --- End Macroscript
