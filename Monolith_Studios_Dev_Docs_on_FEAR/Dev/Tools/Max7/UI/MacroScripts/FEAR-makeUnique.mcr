--	Make Unique Macro Script
--
--	Written by Kevin Deadrick (Monolith) for F.E.A.R. project development.
-- 
--	v1.0 RELEASE
--
--	Macro Takes selection array and makes each object unique.
--


macroScript MakeUnique category:"FEAR" buttonText: "Make Unique"
(

on isEnabled return selection.count > 1 and superclassof selection[1].baseobject == GeometryClass
on execute do
(
MakeUniqueDebug = false

-- Establish Selection Array

	SelArray = selection as array

-- Check for objects.  If none then let user know

	if SelArray.count != 0 do 
	(
	if MakeUniqueDebug == true do (Print "Launching Modal Dialog")

-- Warn User before Progressing

		
			if queryBox "Are you sure you want to make these items unique?" title: "Confirm Operation!" beep:false then
		
			--qResult = queryBox()
			
			--if qResult == true do

			(
			
-- Establish Undo String

			local UndoString = "Make Selection Unique"
			undo label: undoString on
			
			if MakeUniqueDebug == true do (Print "You said yes!")

-- Search through the selection and make instanced objects unique

			for i in SelArray do
				(
				ArrayItem = i.name

				InstanceMgr.MakeObjectsUnique i #prompt
				
				if MakeUniqueDebug == true do (Print (ArrayItem as string + " is now Unique")) -- If Debug flagged report operation

				)
			print (SelArray.count as string + " Object(s) modified")
			)
		)

)
)
