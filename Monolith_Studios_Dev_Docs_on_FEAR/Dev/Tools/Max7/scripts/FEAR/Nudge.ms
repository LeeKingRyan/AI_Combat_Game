--	Nudge Utility v1.5
--
--	Written by Kevin Deadrick (Monolith) for F.E.A.R. project development.
-- 
--	v1.0 RELEASE
--
--	Added Sub Object recognition.
--	Added Axis Toggle
--	Added ability to utilize active grid as unit def
--
--	Comments / Bugs / Quesionts Email: kevind@lith.com
--
--	v1.1
--
--	Added separate  Rollout for Offset and Axis Controls to allow user to compact the UI more.
--	
--	v1.2
--
--	Added Checks for Modifiers.  Tool now prompts to collapse stack before using
--	Misc Bug Fixes and optimizations
--
--	v1.4
--
--	Added Rotation Nudge Functionality rotate_objects fn + GUI controls
--
--	v1.5
--	
--	Repaired Undo functionality on Rotational Nudge
--	Changed Offset Spinner to type #Float for greater nudging percision.
--	Fixed bug that would crash script when trying to translate sub-object(S) on Non-Geometry Class objects.

global Ndebug = false
global DistVal = 10
global ObjLevel
global ButtonCall

-- Function Calls

fn rotate_objects OffsetVal AxisVal = 
(
if Ndebug == true do (print ("Offset Value is: " + OffsetVal as string))
if Ndebug == true do (print ("Axis State is: " + AxisVal as string))

SubState = subObjectLevel
	if SubState == 0 or SubState == undefined then
		(
		SelectionArray = selection as array

		RotationAngle = case AxisVal of
					(
					1: eulerangles  OffsetVal 0 0 
					2: eulerangles  0 OffsetVal 0
					3: eulerangles  0 0 OffsetVal
					)

		for i in SelectionArray do
			(
			rotate i RotationAngle
			)
		)
	else
		(
		messagebox "Rotation Nudge will not work on Sub Object(s)" title: "Unable to Perform Operation!"
		)
)


rollout mvPanelControls "Nudge Options"
( -- Begin Rollout
	group "Offset Options"
	(
	label mvGridOffset "Offset (max units)" offset: [0,0] across: 2
	spinner mvDistance range:[0,10000,10] type: #float width: 50 offset: [-5,0]
	label mvUseGridLabel "Use Active Grid Settings:" offset: [0,0] across: 2 align: #left
	checkbox mvUseGrid offset: [65,0]
	)
	group "Axis Options"
	(
	label mvUpToggleLable "Up / Down" 
	radiobuttons mvUpToggle labels:#("Z axis", "Y axis") 
	)

	
	on mvUseGrid changed state do
	(
	if mvPanelControls.mvUseGrid.checked == true do (mvPanelControls.mvDistance.enabled = false)
	if mvPanelControls.mvUseGrid.checked == false do (mvPanelControls.mvDistance.enabled = true)
	)

	on mvDistance entered do
	(
	DInput = mvPanelControls.mvDistance.value
	
		if Ndebug == true do (print DInput)
	
	DistVal = DInput
	)

) -- End Rollout

rollout mvNudgeControls "Nudge Controls"
(  -- Begin Rollout
	group "Nudge Controls"
	(
	button mvNudgeUp "Up" width: 32 height: 32 images:#("$UI/Icons/Monolith Productions/FEAR/NUDGE_01_i.bmp", "$UI/Icons/Monolith Productions/FEAR/NUDGE_01_a.bmp:", 12, 1, 2, 1, 1)
	button mvNudgeLeft "Left" across: 2 width: 32 height: 32 images:#("$UI/Icons/Monolith Productions/FEAR/NUDGE_01_i.bmp", "$UI/Icons/Monolith Productions/FEAR/NUDGE_01_a.bmp:", 12, 8, 7, 1, 1)
	button mvNudgeRight "Right" width: 32 height: 32 images:#("$UI/Icons/Monolith Productions/FEAR/NUDGE_01_i.bmp", "$UI/Icons/Monolith Productions/FEAR/NUDGE_01_a.bmp:", 12, 3, 4, 1, 1)
	button mvNudgeDown "Down" width: 32 height: 32 images:#("$UI/Icons/Monolith Productions/FEAR/NUDGE_01_i.bmp", "$UI/Icons/Monolith Productions/FEAR/NUDGE_01_a.bmp:", 12, 6, 5, 1, 1)
	)
	
	local UndoString = "Nudge Operation"


-- Begin Up Controls

	on mvNudgeUp pressed do with undo label: undoString on
	(

-- Code block for Base Object Translation
	SubState = subObjectLevel
	if Ndebug == true do (print ("substate = " + SubState as string))
	if Ndebug == true do (print ("Class of Selection is: " + SuperClassof $ as string))
	if SubState == 0 or SubState == undefined do 
		(
-- Set Var

			SelectionArray = selection as array
			GridSet = mvPanelControls.mvUseGrid.checked
			ActiveGridVal = getGridSpacing()
		
-- Check for Active Grid vs Manual Dist

			if GridSet == false do (NDistance = DistVal)
			if GridSet == true do (NDistance = ActiveGridVal)

			AxisState = mvPanelControls.mvUpToggle.state

				if Ndebug == true do (print SelectionArray)
				if Ndebug == true do (print NDistance)

			if AxisState == 2 do
				(
					for i in SelectionArray do
					(
					YDistance = NDistance
					move i [0,YDistance,0]
					)
				)
			if AxisState == 1 do
				(
					for i in SelectionArray do
					(
					ZDistance = NDistance
					move i [0,0,ZDistance]
					)
				)
		)
		
		if SubState != undefined do
		(
			if SubState > 0 then
			(
			ButtonCall = 1

			case SubState of
				(
				1: ObjLevel = 1 
				2: ObjLevel = 2 
				3: ObjLevel = 3
				4: ObjLevel = 4
				5: ObjLevel = 5
				)
			
			fileIn "Nudge_Sub.ms"
			)
		)
	)
-- End Up Controls

-- Begin Down Controls
	on mvNudgeDown pressed do with undo label: undoString on
	(
-- Code block for Base Object Translation
	SubState = subObjectLevel
	if SubState == 0 or SubState == undefined do 
		(
-- Set Var

		SelectionArray = selection as array
		GridSet = mvPanelControls.mvUseGrid.checked
		ActiveGridVal = getGridSpacing()
		
-- Check for Active Grid vs Manual Dist

		if GridSet == false do (NDistance = -DistVal)
		if GridSet == true do (NDistance = -ActiveGridVal)

		AxisState = mvPanelControls.mvUpToggle.state

			if Ndebug == true do (print SelectionArray)
			if Ndebug == true do (print NDistance)

		if AxisState == 2 do
			(
				for i in SelectionArray do
				(
				YDistance = NDistance
				move i [0,YDistance,0]
				)
			)
		if AxisState == 1 do
			(
				for i in SelectionArray do
				(
				ZDistance = NDistance
				move i [0,0,ZDistance]
				)
			)
		)
		if SubState != undefined do
		(
			if SubState > 0 then
			(
			ButtonCall = 2

			case SubState of
				(
				1: ObjLevel = 1 
				2: ObjLevel = 2 
				3: ObjLevel = 3
				4: ObjLevel = 4
				5: ObjLevel = 5
				)
			
			fileIn "Nudge_Sub.ms"	
			)
		)
	)
-- End Down Controls

-- Begin Left Controls

	on mvNudgeLeft pressed do with undo label: undoString on
	(
-- Code block for Base Object Translation

	SubState = subObjectLevel
	
		if SubState == 0 or SubState == undefined do 
		(

-- Set Var

		SelectionArray = selection as array
		GridSet = mvPanelControls.mvUseGrid.checked
		ActiveGridVal = getGridSpacing()
	
-- Check for Active Grid vs Manual Dist

		if GridSet == false do (NDistance = -DistVal)
		if GridSet == true do (NDistance = -ActiveGridVal)
			
			for i in SelectionArray do
				(
				XDistance = NDistance
				move i [XDistance,0,0]
				)
		)
	
	if SubState != undefined do
		(
			if SubState > 0 then
			(
			ButtonCall = 3

			case SubState of
				(
				1: ObjLevel = 1 
				2: ObjLevel = 2 
				3: ObjLevel = 3
				4: ObjLevel = 4
				5: ObjLevel = 5
				)
			
			fileIn "Nudge_Sub.ms"	
			)
		)
	)
-- End Left Controls

-- Begin Right Controls
	
	on mvNudgeRight pressed do with undo label: undoString on
	(
	
	SubState = subObjectLevel
	
	if SubState == 0 or SubState == undefined do 
	(

-- Set Var

	SelectionArray = selection as array
	GridSet = mvPanelControls.mvUseGrid.checked
	ActiveGridVal = getGridSpacing()
	
-- Check for Active Grid vs Manual Dist

	if GridSet == false do (NDistance = DistVal)
	if GridSet == true do (NDistance = ActiveGridVal)
		
		for i in SelectionArray do
			(
			XDistance = NDistance
			move i [XDistance,0,0]
			)
	)
	if SubState != undefined do
		(
			if SubState > 0 then
			(
			ButtonCall = 4

			case SubState of
				(
				1: ObjLevel = 1 
				2: ObjLevel = 2 
				3: ObjLevel = 3
				4: ObjLevel = 4
				5: ObjLevel = 5
				)
			
			fileIn "Nudge_Sub.ms"	
			)
		)
	
	)
-- End Right Controls
) -- End Rollout

rollout mvRotationNudge "Rotation Nudge"
(
	group "Nudge Controls"
	(
	label mvLabel_01 "Offset Value:" across: 3 align: #left offset: [0,10]
	spinner mvRotationOffset range:[-360, 360, 15] scale: 15 align: #center width: 50 offset: [10,10]
	button mvRotate width: 32 height: 32 align: #right images:#("$UI/Icons/Monolith Productions/FEAR/NUDGE_01_i.bmp", "$UI/Icons/Monolith Productions/FEAR/NUDGE_01_a.bmp:", 12, 10, 9, 1, 1)
	label mvLabel_02 "Rotation Axis"
	radiobuttons mvRotationToggle labels:#("X axis","Y axis","Z axis")
	)
	
	local UndoString = "Nudge Operation"

	on mvRotate pressed do with undo label: undoString on
	(
	OffsetVal = mvRotationNudge.mvRotationOffset.value
	AxisVal = mvRotationNudge.mvRotationToggle.state
	result = rotate_objects OffsetVal AxisVal
	)

)
rollout mvNudgeHelp "Help"
(
	label mvAbout_01 "Nudge Utility Panel v1.5"
	label mvAbout_02 "Writen for F.E.A.R"
	label mvAbout_03 "Copyright 2004 Monolith Productions"
	label mvAbout_04 "Support email: kevind@lith.com"
	label mvAbout_05 "DO NOT DISTRIBUTE"
)
	if NudgePanel != undefined do (closeRolloutFloater NudgePanel)
	
	NudgePanel = newRolloutFloater "Nudge Utility v1.5" 200 379
	
	addRollout mvNudgeControls NudgePanel rolledup: false
	addRollout mvPanelControls NudgePanel rolledup: false
	addRollout mvRotationNudge NudgePanel rolledup: true
	addRollout mvNudgeHelp NudgePanel rolledup: true