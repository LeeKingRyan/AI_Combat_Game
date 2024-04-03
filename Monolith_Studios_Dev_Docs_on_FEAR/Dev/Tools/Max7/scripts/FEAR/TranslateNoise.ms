-- Positional / Rotational Noise Utility
--
--
--

-- Begin Script

global prDebug = false

-- Define Rollouts and Event Handlers

rollout prNoiseParams "Noise Parameters"
(
	group "Positional Noise: "
	(
	label pn_XCol "X" across: 3 offset: [50,0]
	label pn_YCol "Y" offset: [30,0]
	label pn_ZCol "Z" offset: [5,0]
	label pn_MinLabel "Min" across: 4 align: #right offset: [-5,0]
	spinner pn_MinX range: [-1000,1000,0] width: 60 align: #right offset: [0,0]
	spinner pn_MinY range: [-1000,1000,0] width: 60 align: #right offset: [0,0]
	spinner pn_MinZ range: [-1000,1000,0] width: 60 align: #right
	label pn_MaxLabel "Max" across: 4 align: #right offset: [-5,0]
	spinner pn_MaxX range: [-1000,1000,0] width: 60 align: #right offset: [0,0]
	spinner pn_MaxY range: [-1000,1000,0] width: 60 align: #right offset: [0,0]
	spinner pn_MaxZ range: [-1000,1000,0] width: 60 align: #right
	label pn_UseLabel "Translate Object in (Axis): " align: #left
	checkbutton pn_UseXPos "X" across: 3 width: 80
	checkbutton pn_UseYPos "Y" width: 80
	checkbutton pn_UseZPos "Z" width: 80
	)
	group "Rotational Noise: "
	(
	label rn_XCol "X" across: 3 offset: [50,0]
	label rn_YCol "Y" offset: [30,0]
	label rn_ZCol "Z" offset: [5,0]
	label rn_MinLabel "Min" across: 4 align: #right offset: [-5,0]
	spinner rn_MinX range: [-1000,1000,0] width: 60 align: #right offset: [0,0]
	spinner rn_MinY range: [-1000,1000,0] width: 60 align: #right offset: [0,0]
	spinner rn_MinZ range: [-1000,1000,0] width: 60 align: #right
	label rn_MaxLabel "Max" across: 4 align: #right offset: [-5,0]
	spinner rn_MaxX range: [-1000,1000,0] width: 60 align: #right offset: [0,0]
	spinner rn_MaxY range: [-1000,1000,0] width: 60 align: #right offset: [0,0]
	spinner rn_MaxZ range: [-1000,1000,0] width: 60 align: #right
	label rn_UseLabel "Rotate Object in (Axis): " align: #left
	checkbutton pn_UseXRot "X" across: 3 width: 80
	checkbutton pn_UseYRot "Y" width: 80
	checkbutton pn_UseZRot "Z" width: 80
	)
	group "Scale Noise: "
	(
	label sn_XCol "X" across: 3 offset: [50,0]
	label sn_YCol "Y" offset: [30,0]
	label sn_ZCol "Z" offset: [5,0]
	label sn_MinLabel "Min" across: 4 align: #right offset: [-5,0]
	spinner sn_MinX range: [0,1000,0] width: 60 align: #right offset: [0,0]
	spinner sn_MinY range: [0,1000,0] width: 60 align: #right offset: [0,0]
	spinner sn_MinZ range: [0,1000,0] width: 60 align: #right
	label sn_MaxLabel "Max" across: 4 align: #right offset: [-5,0]
	spinner sn_MaxX range: [0,1000,0] width: 60 align: #right offset: [0,0]
	spinner sn_MaxY range: [0,1000,0] width: 60 align: #right offset: [0,0]
	spinner sn_MaxZ range: [0,1000,0] width: 60 align: #right
	label sn_UseLabel "Scale Object in (Axis): " align: #left
	checkbutton sn_UseXScal "X" across: 3 width: 80
	checkbutton sn_UseYScal "Y" width: 80
	checkbutton sn_UseZScal "Z" width: 80
	checkbutton sn_Uniform "Make Scale Operation Uniform" width: 255
	)
	
-- Storage of Pos Settings

	on pn_MinX changed Value do
	(
	setIniSetting "$scripts/FEAR/PRS_Preferences.ini" "PosSettings" "MinX" (Value as string)
	)
	on pn_MinY changed Value do
	(
	setIniSetting "$scripts/FEAR/PRS_Preferences.ini" "PosSettings" "MinY" (Value as string)
	)
	on pn_MinZ changed Value do
	(
	setIniSetting "$scripts/FEAR/PRS_Preferences.ini" "PosSettings" "MinZ" (Value as string)
	)
	on pn_MaxX changed Value do
	(
	setIniSetting "$scripts/FEAR/PRS_Preferences.ini" "PosSettings" "MaxX" (Value as string)
	)
	on pn_MaxY changed Value do
	(
	setIniSetting "$scripts/FEAR/PRS_Preferences.ini" "PosSettings" "MaxY" (Value as string)
	)
	on pn_MaxZ changed Value do
	(
	setIniSetting "$scripts/FEAR/PRS_Preferences.ini" "PosSettings" "MaxZ" (Value as string)
	)
-- Storage of Rotation Settings

	on rn_MinX changed Value do
	(
	setIniSetting "$scripts/FEAR/PRS_Preferences.ini" "RotSettings" "MinX" (Value as string)
	)
	on rn_MinY changed Value do
	(
	setIniSetting "$scripts/FEAR/PRS_Preferences.ini" "RotSettings" "MinY" (Value as string)
	)
	on rn_MinZ changed Value do
	(
	setIniSetting "$scripts/FEAR/PRS_Preferences.ini" "RotSettings" "MinZ" (Value as string)
	)
	on rn_MaxX changed Value do
	(
	setIniSetting "$scripts/FEAR/PRS_Preferences.ini" "RotSettings" "MaxX" (Value as string)
	)
	on rn_MaxY changed Value do
	(
	setIniSetting "$scripts/FEAR/PRS_Preferences.ini" "RotSettings" "MaxY" (Value as string)
	)
	on rn_MaxZ changed Value do
	(
	setIniSetting "$scripts/FEAR/PRS_Preferences.ini" "RotSettings" "MaxZ" (Value as string)
	)
-- Storage of Scale Settings

	on sn_MinX changed Value do
	(
	setIniSetting "$scripts/FEAR/PRS_Preferences.ini" "ScaleSettings" "MinX" (Value as string)
	)
	on sn_MinY changed Value do
	(
	setIniSetting "$scripts/FEAR/PRS_Preferences.ini" "ScaleSettings" "MinY" (Value as string)
	)
	on sn_MinZ changed Value do
	(
	setIniSetting "$scripts/FEAR/PRS_Preferences.ini" "ScaleSettings" "MinZ" (Value as string)
	)
	on sn_MaxX changed Value do
	(
	setIniSetting "$scripts/FEAR/PRS_Preferences.ini" "ScaleSettings" "MaxX" (Value as string)
	)
	on sn_MaxY changed Value do
	(
	setIniSetting "$scripts/FEAR/PRS_Preferences.ini" "ScaleSettings" "MaxY" (Value as string)
	)
	on sn_MaxZ changed Value do
	(
	setIniSetting "$scripts/FEAR/PRS_Preferences.ini" "ScaleSettings" "MaxZ" (Value as string)
	)
	

	

)

rollout prOperations "Noise Generation"
(
	group "Generate PRS Noise"
	(
	button po_Generate "Generate" width: 260 align: #center
	
	)

	on po_Generate pressed do
	(
	if selection.count == 0 do (messagebox "Please Select Some Objects to Translate!" title: "Alert!")
	if selection.count != 0 do
		(
		if prDebug == true do (print "Begin Randomize") -- Local Debug String
		local UndoString = "PSR Noise Operation(s)"
		undo label: undoString on
		for i in selection do
			(
		-- Positional Clauses
			
			if prNoiseParams.pn_UseXPos.checked == true do 
				(
				RandVal = random prNoiseParams.pn_MinX.value prNoiseParams.pn_MaxX.value
				move i [RandVal,0,0]
				)
			if prNoiseParams.pn_UseYPos.checked == true do 
				(
				RandVal = random prNoiseParams.pn_MinY.value prNoiseParams.pn_MaxY.value
				move i [0,RandVal,0]
				)
			if prNoiseParams.pn_UseZPos.checked == true do 
				(
				RandVal = random prNoiseParams.pn_MinZ.value prNoiseParams.pn_MaxZ.value
				move i [0,0,RandVal]
				)
		
		-- Rotation Clauses
			
			if prNoiseParams.pn_UseXRot.checked == true do 
				(
				RandVal = random prNoiseParams.rn_MinX.value prNoiseParams.rn_MaxX.value
				Rand_Rot = eulerangles RandVal 0 0 
				rotate i Rand_Rot
				)
			if prNoiseParams.pn_UseYRot.checked == true do 
				(
				RandVal = random prNoiseParams.rn_MinY.value prNoiseParams.rn_MaxY.value
				Rand_Rot = eulerangles  0 RandVal 0 
				rotate i Rand_Rot
				)
			if prNoiseParams.pn_UseZRot.checked == true do 
				(
				RandVal = random prNoiseParams.rn_MinZ.value prNoiseParams.rn_MaxZ.value
				Rand_Rot = eulerangles  0 0 RandVal 
				rotate i Rand_Rot
				)
		
		-- Scale Clauses

			if prNoiseParams.sn_UseXScal.checked == true do 
				(
					if prNoiseParams.sn_Uniform.checked != true do 
					(
					RandVal = random prNoiseParams.sn_MinX.value prNoiseParams.sn_MaxX.value
					scale i [RandVal,1,1]
					)
				)
			if prNoiseParams.sn_UseYScal.checked == true do 
				(
					if prNoiseParams.sn_Uniform.checked != true do 
					(
					RandVal = random prNoiseParams.sn_MinY.value prNoiseParams.sn_MaxY.value
					scale i [1,RandVal,1]
					)
				)
			if prNoiseParams.sn_UseZScal.checked == true do 
				(
					if prNoiseParams.sn_Uniform.checked != true do 
					(
					RandVal = random prNoiseParams.sn_MinZ.value prNoiseParams.sn_MaxZ.value
					scale i [1,1,RandVal]
					)
					
				)
			if prNoiseParams.sn_Uniform.checked == true do 
				(
				RandVal = random prNoiseParams.sn_MinX.value prNoiseParams.sn_MaxX.value
				scale i [RandVal,RandVal,RandVal]
				MinVal = prNoiseParams.sn_MinX.value
				MaxVal = prNoiseParams.sn_MaxX.value
				prNoiseParams.sn_MinZ.value = MinVal
				prNoiseParams.sn_MaxZ.value = MaxVal
				prNoiseParams.sn_MinY.value = MinVal
				prNoiseParams.sn_MaxY.value = MaxVal
				)
			)

		)
	)
	
)
rollout prHelp "Help and Info" rolledUp: true
(
	group "about"
	(
	label mvAbout_01 "PRS Noise Utility v1.0"
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
--	ShellLaunch "$max/help/KSM_Help.hlp" ""
	)

)
-- Define Functions

-- Create UI

if prGUI != undefined do (closeRolloutFloater prGUI)
	
	prGUI = newRolloutFloater "PRS Noise Utility v1.0" 300 562

	addRollout prNoiseParams prGUI
	addRollout prOperations prGUI
	addRollout prHelp prGUI

CheckFile = getFiles "$scripts/FEAR/PRS_Preferences.ini" 

print CheckFile.count

-- First Run Make the .ini if it doesn't exist

	if CheckFile.count != 1 then
	(
	print "Creating .ini"
	
	DefaultSpinner = 0
	
	setIniSetting "$scripts/FEAR/PRS_Preferences.ini" "PosSettings" "MinX" (DefaultSpinner as string)
	setIniSetting "$scripts/FEAR/PRS_Preferences.ini" "PosSettings" "MinY" (DefaultSpinner as string)
	setIniSetting "$scripts/FEAR/PRS_Preferences.ini" "PosSettings" "MinZ" (DefaultSpinner as string)
	setIniSetting "$scripts/FEAR/PRS_Preferences.ini" "PosSettings" "MaxX" (DefaultSpinner as string)
	setIniSetting "$scripts/FEAR/PRS_Preferences.ini" "PosSettings" "MaxY" (DefaultSpinner as string)
	setIniSetting "$scripts/FEAR/PRS_Preferences.ini" "PosSettings" "MaxZ" (DefaultSpinner as string)

	setIniSetting "$scripts/FEAR/PRS_Preferences.ini" "RotSettings" "MinX" (DefaultSpinner as string)
	setIniSetting "$scripts/FEAR/PRS_Preferences.ini" "RotSettings" "MinY" (DefaultSpinner as string)
	setIniSetting "$scripts/FEAR/PRS_Preferences.ini" "RotSettings" "MinZ" (DefaultSpinner as string)
	setIniSetting "$scripts/FEAR/PRS_Preferences.ini" "RotSettings" "MaxX" (DefaultSpinner as string)
	setIniSetting "$scripts/FEAR/PRS_Preferences.ini" "RotSettings" "MaxY" (DefaultSpinner as string)
	setIniSetting "$scripts/FEAR/PRS_Preferences.ini" "RotSettings" "MaxZ" (DefaultSpinner as string)

	setIniSetting "$scripts/FEAR/PRS_Preferences.ini" "ScaleSettings" "MinX" (DefaultSpinner as string)
	setIniSetting "$scripts/FEAR/PRS_Preferences.ini" "ScaleSettings" "MinY" (DefaultSpinner as string)
	setIniSetting "$scripts/FEAR/PRS_Preferences.ini" "ScaleSettings" "MinZ" (DefaultSpinner as string)
	setIniSetting "$scripts/FEAR/PRS_Preferences.ini" "ScaleSettings" "MaxX" (DefaultSpinner as string)
	setIniSetting "$scripts/FEAR/PRS_Preferences.ini" "ScaleSettings" "MaxY" (DefaultSpinner as string)
	setIniSetting "$scripts/FEAR/PRS_Preferences.ini" "ScaleSettings" "MaxZ" (DefaultSpinner as string)
	)

-- Load Last Settings if they exist

	else
	(

	print "Loading Presets"

-- Load Pos Settings

	prNoiseParams.pn_MinX.value = execute(getIniSetting "$scripts/FEAR/PRS_Preferences.ini" "PosSettings" "MinX")
	prNoiseParams.pn_MinY.value = execute(getIniSetting "$scripts/FEAR/PRS_Preferences.ini" "PosSettings" "MinY")
	prNoiseParams.pn_MinZ.value = execute(getIniSetting "$scripts/FEAR/PRS_Preferences.ini" "PosSettings" "MinZ")
	prNoiseParams.pn_MaxX.value = execute(getIniSetting "$scripts/FEAR/PRS_Preferences.ini" "PosSettings" "MaxX")
	prNoiseParams.pn_MaxY.value = execute(getIniSetting "$scripts/FEAR/PRS_Preferences.ini" "PosSettings" "MaxY")
	prNoiseParams.pn_MaxZ.value = execute(getIniSetting "$scripts/FEAR/PRS_Preferences.ini" "PosSettings" "MaxZ")

-- Load Rotation Settings

	prNoiseParams.rn_MinX.value = execute(getIniSetting "$scripts/FEAR/PRS_Preferences.ini" "RotSettings" "MinX")
	prNoiseParams.rn_MinY.value = execute(getIniSetting "$scripts/FEAR/PRS_Preferences.ini" "RotSettings" "MinY")
	prNoiseParams.rn_MinZ.value = execute(getIniSetting "$scripts/FEAR/PRS_Preferences.ini" "RotSettings" "MinZ")
	prNoiseParams.rn_MaxX.value = execute(getIniSetting "$scripts/FEAR/PRS_Preferences.ini" "RotSettings" "MaxX")
	prNoiseParams.rn_MaxY.value = execute(getIniSetting "$scripts/FEAR/PRS_Preferences.ini" "RotSettings" "MaxY")
	prNoiseParams.rn_MaxZ.value = execute(getIniSetting "$scripts/FEAR/PRS_Preferences.ini" "RotSettings" "MaxZ")
	
-- Load Scale Settings
	
	prNoiseParams.sn_MinX.value = execute(getIniSetting "$scripts/FEAR/PRS_Preferences.ini" "ScaleSettings" "MinX")
	prNoiseParams.sn_MinY.value = execute(getIniSetting "$scripts/FEAR/PRS_Preferences.ini" "ScaleSettings" "MinY")
	prNoiseParams.sn_MinZ.value = execute(getIniSetting "$scripts/FEAR/PRS_Preferences.ini" "ScaleSettings" "MinZ")
	prNoiseParams.sn_MaxX.value = execute(getIniSetting "$scripts/FEAR/PRS_Preferences.ini" "ScaleSettings" "MaxX")
	prNoiseParams.sn_MaxY.value = execute(getIniSetting "$scripts/FEAR/PRS_Preferences.ini" "ScaleSettings" "MaxY")
	prNoiseParams.sn_MaxZ.value = execute(getIniSetting "$scripts/FEAR/PRS_Preferences.ini" "ScaleSettings" "MaxZ")


	if prDebug == true do (print "Previous Settings Restored")
	)



-- End Script
