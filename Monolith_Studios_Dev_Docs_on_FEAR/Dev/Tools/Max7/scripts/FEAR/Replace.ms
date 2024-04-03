--	Replace Utility v1.1
--
--	Written by Kevin Deadrick (Monolith) for F.E.A.R. project development.
--
--	v1.0 RELEASE
--
--	v1.1 
--
--	Fixed Misc bugs
--	Switched to Matrix3 transform for placing new objects
--	Added naming inheritance 


-- Begin Script

global RArray = #()
global RArrayNames = #()
global Source = undefined
global ruDebug = false
global CopyState = 2


-- Define Rollouts

rollout ruObject "Replace Function(s)"
(
	fn GeometryType obj = superclassof obj.baseobject == GeometryClass -- Filter Function

	group "Source Object:"
	(
	button ruSourcePick "Pick Object" width: 220
	)
	group "Replace Operations:"
	(
	button ruReplace "Replace Objects" width: 220
	)

-- Begin Replace Controls
	
	
	on ruSourcePick pressed do
	(
	Source = selectByName title: "Select Source Object" filter: GeometryType single: true 
		if Source != undefined do
		(
		ruObject.ruSourcePick.caption = ("Max Node: " + Source.name)
		)
	)

	on ruReplace pressed do
	(
	if Source == undefined or RArray.count == 0 do (messagebox "Set Source and/or Replacement Array!     " title: "Alert: Setup Not Complete!")
		if source != undefined and RArray.count > 0 do
		(

		
		if ruDebug == true do (print "Replacing Objects")
		
-- Store Positions and Delete Array Objects
			
			for i in RArray do
			(
			Transform = i.transform
			StoreName = i.name
			if ruDebug == true do (print Transform)
			
			delete i
			
			if ruDebug == true do (print CopyState)
			
			case CopyState of 
			(
			1: (NewObj = copy Source)
			2: (NewObj = instance Source)
			3: (NewObj = reference Source)
			)

			if ruDebug == true do (print NewObj)
			
			NewObj.transform = Transform
			NewObj.name = StoreName

			if ruDebug == true do (print NewObj.name)
			)
		print (RArray.count as string + " Ojbects Replaced!")
		RArray = #()
		RArrayNames = #()
		fileIn "RU_Extension.ms"
		
		)
	
	)

)

rollout ruTarget "Replace Options"
(
	fn GeometryType obj = superclassof obj.baseobject == GeometryClass -- Filter Function
	
	group "Replacement Array:"
	(
	listbox ruArray height: 10
	button ruArrayAdd "ADD" width: 65 across: 3 align: #left offset: [3,0]
	button ruArraySelected "SELECTED" width: 65 align: #left offset: [3,0]
	button ruArrayRemove "REMOVE" width: 65 align: #left offset: [3,0]
	button ruArrayReset "RESET" width: 205 align: #center 
	)
	group "Replacement Options:"
	(
	label ruRTypeLabel "Duplication Method:" align: #left
	radiobuttons ruRType labels:#("Copy","Instance","Reference") default: 2
	)

-- Begin List Management Controls
	on ruArrayAdd pressed do
	(
	AddArray = selectByName title: "Select Objects to Replace" filter: GeometryType
		if AddArray != undefined do
		(
		for i in AddArray do
		(
			if RArray.count != 0 do
			(
			local ParseList = false
				for j in RArray do
				(
				if ruDebug == true do (print "Parsing List")
				if j == i do (ParseList = true)
				if ruDebug == true do (print i)
				if ruDebug == true do (print j)
				)
			if ParseList == false do (append RArray i)

			)
			if RArray.count == 0 do
			(
			append RArray i
			if ruDebug == true do (print "Updated List")
			)

		)
		for i in RArray do
		(
		ObjName = i.name
		
		if ruDebug == true do (print ObjName)
			if RArrayNames.count > 0 do
			(
			local NameParse = false
			for j in RArrayNames do
				(
				if ObjName == j do (NameParse = true)
				)
			if NameParse == false do (append RArrayNames ObjName)
			)
			if RArrayNames.count == 0 do
			(
			append RArrayNames ObjName
			if ruDebug == true do (print "Updated List!")
			)
		)
	ruTarget.ruArray.items = RArrayNames
	))

	on ruArraySelected pressed do
	(
	AddArray = selection as array
		if AddArray != undefined do
		(
		for i in AddArray do
		(
			if RArray.count != 0 do
			(
			local ParseList = false
				for j in RArray do
				(
				if ruDebug == true do (print "Parsing List")
				if j == i do (ParseList = true)
				if ruDebug == true do (print i)
				if ruDebug == true do (print j)
				)
			if ParseList == false do (append RArray i)

			)
			if RArray.count == 0 do
			(
			append RArray i
			if ruDebug == true do (print "Updated List")
			)

		)
		for i in RArray do
		(
		ObjName = i.name
		
		if ruDebug == true do (print ObjName)
			if RArrayNames.count > 0 do
			(
			local NameParse = false
			for j in RArrayNames do
				(
				if ObjName == j do (NameParse = true)
				)
			if NameParse == false do (append RArrayNames ObjName)
			)
			if RArrayNames.count == 0 do
			(
			append RArrayNames ObjName
			if ruDebug == true do (print "Updated List!")
			)
		)
	ruTarget.ruArray.items = RArrayNames
	))

	on ruArrayReset pressed do
	(
		RArray = #()
		RArrayNames = #()
		ruTarget.ruArray.items = RArrayNames
	)
	on ruArrayRemove pressed do
	(
	
		if RArray.count != 0 do
		(
		RemoveSelection = ruTarget.ruArray.selected
		IndexCount = findItem RArrayNames RemoveSelection
		deleteItem RArrayNames IndexCount
		deleteItem RArray IndexCount
		ruTarget.ruArray.items = RArrayNames
		if ruDebug == true do (print "Updated List!")
		)

	)
	
	on ruArray doubleClicked do 
	(
	ObjSel = ruTarget.ruArray.selected
	IndexCount = findItem RArrayNames ObjSel
	select RArray[IndexCount]
	) -- End List Controls

	on ruRType changed state do
	(
	CopyState = case ruTarget.ruRType.state of 
			(
			1: 1
			2: 2
			3: 3
			)
	)

)

rollout ruHelp "Help and Info" rolledUp: true
(
	group "about"
	(
	label mvAbout_01 "Replace Utility v1.1"
	label mvAbout_02 "Writen for F.E.A.R"
	label mvAbout_03 "Copyright 2004 Monolith Productions"
	label mvAbout_04 "Support email: kevind@lith.com"
	label mvAbout_05 "DO NOT DISTRIBUTE"
	)
	group "Help File"
	(
	button mvHelp "Display Help"
	)
	
	on mvHelp pressed do
	(

	)

)

if ruGUI != undefined do (closeRolloutFloater ruGUI)

ruGUI = newRolloutFloater "Replace Utility v1.1" 250 476

addRollout ruObject ruGUI
addRollout ruTarget ruGUI
addRollout ruHelp ruGUI

-- End Script