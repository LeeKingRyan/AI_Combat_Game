--
--	Batch Export Macroscript ** Requires Monolith Tools Export
--
--	Written by Kevin Deadrick (Monolith) for F.E.A.R. project development.
--
--	v1.0 RELEASE
--
--	NOTE:  Tools do not allow maxscript access to tool functions.  As a result your objects must already
--	exist within the tools node tree in order to appear in the export dialog.
--	
--	NOTE:  This script will only export objects of GEOMETRY class.  All other objects will be ignored.
--
--	v1.2 UPDATE
--	Fixed multiple crash bugs and improved error handling
--	re-defined method of constructing the export tree(s)
--	Improved user messaging.  Script informs you when no valid export objects are present.


macroscript BatchExport
ButtonText:"Batch Export Scene"
Category:"FEAR" 
Tooltip:"Batch Export Scene"

(

ExportArray = #()
beDebug = true

-- Filter Selection to Geometry

max select all 

for i in selection do
	(
	if superclassof i.baseobject == GeometryClass do
		(
		objName = i.name as string
		
		if beDebug == true do (print ("Object: " + objName + " has been evaluated"))

		AttributeCount = custAttributes.count i
		if AttributeCount == 0 then 
			(
			if beDebug == true do (print ("Object: " + objName + " does not contain Export Information."))
			continue
			)
		else
			(	
			try ExportPath = i.ExportPath
			catch
				(
				if beDebug == true do (print ("Object: " + objName + " does not contain Export Information."))
				continue
				)
			if ExportPath == undefined then
				(
				if beDebug == true do (print ("Object: " + objName + " does not contain Export Information."))
				continue
				)
			else
				(
				if i.includeExport == true then 
					(
					if beDebug == true do (print (objName + " Include Export Checkbox = " + i.includeExport as string))
					if beDebug == true do (print ("Object: " + objName + " will be exported!"))
					append ExportArray i
					)
				else 
					(
					print ("Object: " + objName + " is NOT flagged for export!")
					continue
					)
				)
			)
		)
	)

max select none

-- Array now contains only valid export objects
	
	FileArray = #()

	if ExportArray.count > 0 then
	(
		while ExportArray.count > 0 do
		(
		BatchExport = #()
		FileSet = ExportArray[1].ExportPath
		
			for i in ExportArray do
			(
			if i.ExportPath == FileSet do (append BatchExport i)
			)
		
	-- Parse out the Batch List done Begin Export
		-- select BatchExport
		
	-- Filter out Objects flagged as no export include

		IncludeArray = #()
		for i in BatchExport do
		(
		if i.includeExport ==  true do -- If Object is to be exported send it through the options pipeline
		(
		append IncludeArray i
			
			if i.Weld_Points == true do
			(
			select i 
			macros.run "FEAR" "WeldPoints"
			max select none
			)
		)
		
		)
		
		select IncludeArray

		exportFile FileSet selectedOnly: true #noPrompt
		print ("File Has Been Exported")
		
		max select none

			for i in BatchExport do
			(
			IndexNumber = findItem ExportArray i

			if IndexNumber != undefined do (deleteItem ExportArray IndexNumber)
			)
		
		BatchExport = #()

		)
	)
	else
	(
	messagebox "The Scene Contains No Valid Export Objects!" title: "Export Alert!" beep: true
	)
)

