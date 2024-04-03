-- COMMENTED out various functions based on optimizations of Helicopter system.  NOTED below w/ ** DISABLED **


-----------------------------------------------------------------------
--User defined settings------------------------------------------------
-----------------------------------------------------------------------
displayHeliFloaterRun = true
-----------------------------------------------------------------------

-- Global Variables -- 

-- Init State Var

global createIntVal1 = false
global createIntVal2 = false
global createIntVal3 = false
global createIntVal4 = false
global Heli_Tracks

-- Track view Var

-- Var for Rig Switching

global PosNoise = execute("$BHRig_1_Positional_Noise")
global MotContr = execute("$BHRig_1_Motion_Control")
-- global LDSlider = execute("$BHRig_1_LDoor_Slider") ** DISABLED **
-- global RDSlider = execute("$BHRig_1_RDoor_Slider") ** DISABLED **
-- global FRotor = execute("$BHRig_1_F_Rotation") ** DISABLED **
-- global RRotor = execute("$BHRig_1_R_Rotation") ** DISABLED **
-- global RTilt = execute("$BHRig_1_Tilt_Slider") ** DISABLED **
global MBank = execute("$BHRig_1_Bank_Slider")
global ZElevation = execute("$BHRig_1_ElevationControl")
-- global ElevatorSlider = execute("$BHRig_1_RElevator_Control") ** DISABLED **
-- global RRDoorSlider = execute("$BHRig_1_RearDoorR_Slider")  ** DISABLED **
-- global RLDoorSlider = execute("$BHRig_1_RearDoorL_Slider")  ** DISABLED **

global FunctionCall 

global HeliDebug = false

-- Define Functions

-- Creates all the Tracks
fn createHeliTracks =
(
	
	-- Check for existing Track and remove if necessary
	CheckVar = Heli_Tracks
	if Heli_Tracks != undefined then (deleteTrackViewNode Heli_Tracks)

	-- Defines the TrackView Nodes 
	
		Heli_Tracks = newTrackViewNode "Current Helicopter Rigging"
		Heli_Drift = newTrackViewNode Heli_Tracks "Drift_Distance"
		Heli_DriftTime = newTrackViewNode Heli_Tracks "Drift_Time"
		Heli_Sway = newTrackViewNode Heli_Tracks "Rotational_Sway"
		Heli_Doors = newTrackViewNode Heli_Tracks "Doors"
--		Heli_Rotors = newTrackViewNode Heli_Tracks "Rotors" ** DISABLED **
		Heli_Bank = newTrackViewNode Heli_Tracks "Banking"
		Heli_Elv = newTrackViewNode Heli_Tracks "Elevation"
--		Heli_RElv = newTrackViewNode Heli_Tracks "Rear Elevator" ** DISABLED **

	-- Heli Controllers
	addTrackViewController Heli_Drift PosNoise.Custom_Attributes.Drift_X.controller "DriftX"
	addTrackViewController Heli_Drift PosNoise.Custom_Attributes.Drift_Y.controller "DriftY"
	addTrackViewController Heli_Drift PosNoise.Custom_Attributes.Drift_Z.controller "DriftZ"
	addTrackViewController Heli_DriftTime PosNoise.Custom_Attributes.Time_X.controller "DTime_X"
	addTrackViewController Heli_DriftTime PosNoise.Custom_Attributes.Time_Y.controller "DTime_Y"
	addTrackViewController Heli_DriftTime PosNoise.Custom_Attributes.Time_Z.controller "DTime_Z"
	addTrackViewController Heli_Sway MotContr.Custom_Attributes.Sway_Y.controller "Sway_Y"
--	addTrackViewController Heli_Doors LDSlider.value.controller "Left_Door" ** DISABLED **
--	addTrackViewController Heli_Doors RDSlider.value.controller "Right_Door" ** DISABLED **
--	addTrackViewController Heli_Doors RLDoorSlider.value.controller "Rear_DoorL"  ** DISABLED **
--	addTrackViewController Heli_Doors RRDoorSlider.value.controller "Rear_DoorR"  ** DISABLED **
--	addTrackViewController Heli_Rotors FRotor.Custom_Attributes.Rotor_Speed.controller "F_Rotation" ** DISABLED **
--	addTrackViewController Heli_Rotors RRotor.Custom_Attributes.RRotor_Speed.controller "R_Rotation" ** DISABLED **
--	addTrackViewController Heli_Rotors RTilt.value.controller "Rotor_Tilt" ** DISABLED **
	addTrackViewController Heli_Bank MBank.value.controller "Manual Banking"
	addTrackViewController Heli_Elv ZElevation.value.controller "ZHeight"
--	addTrackViewController Heli_RElv ElevatorSlider.value.controller "RearElevator" ** DISABLED **
	
	-- Update Var to signal complete
	
)

fn Slider_Update =
(
		FunctionCall = 2
		fileIn "Heli_Controls-[Functions].ms"

)
-- Define Rollout #1
rollout mvSelect "Rigging Select"
(
	group "Selected Helicopter"
	(
	dropdownlist rigSelect "Animate:" items:#("BHRig_1","BHRig_2","BHRig_3","BHRig_4")
	)
	on rigSelect selected i do 
	(
	if i == 1 then
		(                           
		if HeliDebug == true do (print "Animating Rig 1")
		PosNoise = execute("$BHRig_1_Positional_Noise")
		MotContr = execute("$BHRig_1_Motion_Control")  
--		LDSlider = execute("$BHRig_1_LDoor_Slider")    ** DISABLED **
--		RDSlider = execute("$BHRig_1_RDoor_Slider")    ** DISABLED **
--		FRotor = execute("$BHRig_1_F_Rotation")        ** DISABLED **
--		RRotor = execute("$BHRig_1_R_Rotation")        ** DISABLED **
--		RTilt = execute("$BHRig_1_Tilt_Slider")        ** DISABLED **
		MBank = execute("$BHRig_1_Bank_Slider")  
		ZElevation = execute ("$BHRig_1_ElevationControl")
--		ElevatorSlider = execute("$BHRig_1_RElevator_Control") ** DISABLED **
--		RRDoorSlider = execute("$BHRig_1_RearDoorR_Slider")  ** DISABLED **
--		RLDoorSlider = execute("$BHRig_1_RearDoorL_Slider")  ** DISABLED **

-- Update the UI NOW

		FunctionCall = 2
		fileIn "Heli_Controls-[Functions].ms"
-- End Update

		)
	if i == 2 then
		(                      
			
		CheckVar = execute("$BHRig_2_Positional_Noise")
		if CheckVar == undefined then 
			(
			messagebox "rigging not found"
			mvSelect.rigSelect.selection = 1
			)
		else
			(
			if HeliDebug == true do (print "Animating Rig 2")		
			PosNoise = execute("$BHRig_2_Positional_Noise")
			MotContr = execute("$BHRig_2_Motion_Control")  
--			LDSlider = execute("$BHRig_2_LDoor_Slider")    ** DISABLED **
--			RDSlider = execute("$BHRig_2_RDoor_Slider")    ** DISABLED **
--			FRotor = execute("$BHRig_2_F_Rotation")        ** DISABLED **
--			RRotor = execute("$BHRig_2_R_Rotation")        ** DISABLED **
--			RTilt = execute("$BHRig_2_Tilt_Slider")        ** DISABLED **
			MBank = execute("$BHRig_2_Bank_Slider")  
			ZElevation = execute ("$BHRig_2_ElevationControl")
--			ElevatorSlider = execute("$BHRig_2_RElevator_Control") ** DISABLED **
--			RRDoorSlider = execute("$BHRig_2_RearDoorR_Slider")  ** DISABLED **
--			RLDoorSlider = execute("$BHRig_2_RearDoorL_Slider")  ** DISABLED **
-- Update the UI NOW

			FunctionCall = 2
			fileIn "Heli_Controls-[Functions].ms"
-- End Update
			if createIntVal2 == false
			then
			(
			FunctionCall = 1
			if HeliDebug == true do (print "Attempting to Call Script")
			fileIn "Heli_Controls-[Functions].ms"
			)
			)
		)
	if i == 3 then
		(                          
		CheckVar = execute("$BHRig_3_Positional_Noise")
		if CheckVar == undefined then
			(
			messagebox "rigging not found"
			mvSelect.rigSelect.selection = 1
			)
		else
			(
			if HeliDebug == true do (print "Animating Rig 3")
			PosNoise = execute("$BHRig_3_Positional_Noise")
			MotContr = execute("$BHRig_3_Motion_Control")  
--			LDSlider = execute("$BHRig_3_LDoor_Slider")    ** DISABLED **
--			RDSlider = execute("$BHRig_3_RDoor_Slider")    ** DISABLED **
--			FRotor = execute("$BHRig_3_F_Rotation")        ** DISABLED **
--			RRotor = execute("$BHRig_3_R_Rotation")        ** DISABLED **
--			RTilt = execute("$BHRig_3_Tilt_Slider")        ** DISABLED **
			MBank = execute("$BHRig_3_Bank_Slider")  
			ZElevation = execute ("$BHRig_3_ElevationControl")
--			ElevatorSlider = execute("$BHRig_3_RElevator_Control") ** DISABLED **
--			RRDoorSlider = execute("$BHRig_3_RearDoorR_Slider")  ** DISABLED **
--			RLDoorSlider = execute("$BHRig_3_RearDoorL_Slider")  ** DISABLED **

-- Update the UI NOW

			FunctionCall = 2
			fileIn "Heli_Controls-[Functions].ms"
-- End Update

			if createIntVal3 == false
			then
			(
			FunctionCall = 1
			if HeliDebug == true do (print "Attempting to Call Script")
			fileIn "Heli_Controls-[Functions].ms"
			)
			)
		)
	if i == 4 then
		(                          
		CheckVar = execute("$BHRig_4_Positional_Noise")
		if CheckVar == undefined then
			(
			messagebox "rigging not found"
			mvSelect.rigSelect.selection = 1
			)
		else
			(
			if HeliDebug == true do (print "Animating Rig 4")
			PosNoise = execute("$BHRig_4_Positional_Noise")
			MotContr = execute("$BHRig_4_Motion_Control")  
--			LDSlider = execute("$BHRig_4_LDoor_Slider")    ** DISABLED **
--			RDSlider = execute("$BHRig_4_RDoor_Slider")    ** DISABLED **
--			FRotor = execute("$BHRig_4_F_Rotation")        ** DISABLED **
--			RRotor = execute("$BHRig_4_R_Rotation")        ** DISABLED **
--			RTilt = execute("$BHRig_4_Tilt_Slider")        ** DISABLED **
			MBank = execute("$BHRig_4_Bank_Slider")  
			ZElevation = execute ("$BHRig_4_ElevationControl")
--			ElevatorSlider = execute("$BHRig_4_RElevator_Control") ** DISABLED **
--			RRDoorSlider = execute("$BHRig_4_RearDoorR_Slider")  ** DISABLED **
--			RLDoorSlider = execute("$BHRig_4_RearDoorL_Slider")  ** DISABLED **

-- Update the UI NOW

			FunctionCall = 2
			fileIn "Heli_Controls-[Functions].ms"
-- End Update

			if createIntVal4 == false
			then
			(
			FunctionCall = 1
			if HeliDebug == true do (print "Attempting to Call Script")
			fileIn "Heli_Controls-[Functions].ms"
			)
			)
		)
	)
)
	

rollout mvDrifts "Drift Controls"
(
	
	-- Defining Groups -- 

-- Begin Distance Drift Controls ---------------------------------------
	
	group "Positional Drift"
	(
		label Distance "Drift Distance" alignment:#Right Pos:[15,26]
		spinner DriftX "Drift X (position noise)" range:[0, 4000, (PosNoise.Custom_Attributes.Drift_X)] type: #float scale:1 fieldwidth:50  
		spinner DriftY "Drift Y (position noise)" range:[0, 4000, (PosNoise.Custom_Attributes.Drift_Y)] type: #float scale:1 fieldwidth:50 
		spinner DriftZ "Drift Z (position noise)" range:[0, 4000, (PosNoise.Custom_Attributes.Drift_Z)] type: #float scale:1 fieldwidth:50 
		checkbox DX "X" pos:[15,117]
		checkbox DY "Y" pos:[50,117]
		checkbox DZ "Z" pos:[85,117]
		button KDistance "Create Key" toolTip:"Creates Key for checked values" pos:[200,117]
		label Time "Drift Time (Seconds)" alignment:#Right pos:[15,147]
		spinner DTimeX "Drift X (Time per cycle)" range:[0, 100, (PosNoise.Custom_Attributes.Time_X)] type: #float scale:1 fieldwidth:50 
		spinner DTimeY "Drift Y (Time per cycle)" range:[0, 100, (PosNoise.Custom_Attributes.Time_Y)] type: #float scale:1 fieldwidth:50 
		spinner DTimeZ "Drift Z (Time per cycle)" range:[0, 100, (PosNoise.Custom_Attributes.Time_Z)] type: #float scale:1 fieldwidth:50 
		checkbox TX "X" pos:[15,240]
		checkbox TY "Y" pos:[50,240]
		checkbox TZ "Z" pos:[85,240]
		button KTime "Create Key" toolTip:"Creates Key for checked values" pos:[200,240]
		button FetchPD "Fetch Positional Drift" toolTip:"Selects Dummy Object" width:255 pos:[15,270]

	)
	on FetchPD pressed do (select PosNoise)
-- Hooking spinners up to Custom Attributes on Positional Noise Dummy
	on DriftX entered do
	(
	(PosNoise.Custom_Attributes.Drift_X) = mvDrifts.DriftX.value
	)
	on DriftY entered do
	(
	(PosNoise.Custom_Attributes.Drift_Y) = mvDrifts.DriftY.value
	)
	on DriftZ entered do
	(
	(PosNoise.Custom_Attributes.Drift_Z) = mvDrifts.DriftZ.value
	)
	on TimeX entered do
	(
	(PosNoise.Custom_Attributes.Time_X) = mvDrifts.DTimeX.value
	)
	on DriftY entered do
	(
	(PosNoise.Custom_Attributes.Time_Y) = mvDrifts.DTimeY.value
	)
	on DriftZ entered do
	(
	(PosNoise.Custom_Attributes.Time_Z) = mvDrifts.DTimeZ.value
	)
-- Button Definitions

	on KDistance pressed do
	(
	if mvDrifts.DX.checked == true
	then
	(
		TStamp = sliderTime
		KeyVal = mvDrifts.DriftX.value
		(addNewKey posNoise.Custom_Attributes.Drift_X.controller TStamp).value = KeyVal 
		--Slider_Update()
		
	)
	if mvDrifts.DY.checked == true
	then
	(
		TStamp = sliderTime
		KeyVal = mvDrifts.DriftY.value
		(addNewKey posNoise.Custom_Attributes.Drift_Y.controller TStamp).value = KeyVal 
		--Slider_Update()
	)
	if MvDrifts.DZ.checked == true
	then
	(
		TStamp = sliderTime
		KeyVal = mvDrifts.DriftZ.value
		(addNewKey posNoise.Custom_Attributes.Drift_Z.controller TStamp).value = KeyVal 
		--Slider_Update()
	)
	)

	on KTime pressed do
	(
	if mvDrifts.TX.checked == true
	then
	(
		TStamp = sliderTime
		KeyVal = mvDrifts.DTimeX.value
		(addNewKey posNoise.Custom_Attributes.Time_X.controller TStamp).value = KeyVal 
		--Slider_Update()
	)
	if mvDrifts.TY.checked == true
	then
	(
		TStamp = sliderTime
		KeyVal = mvDrifts.DTimeY.value
		(addNewKey posNoise.Custom_Attributes.Time_Y.controller TStamp).value = KeyVal 
		--Slider_Update()
	)
	if mvDrifts.TZ.checked == true
	then
	(
		TStamp = sliderTime
		KeyVal = mvDrifts.DTimeZ.value
		(addNewKey posNoise.Custom_Attributes.Time_Z.controller TStamp).value = KeyVal 
		--Slider_Update()
	)
	)

-- End of Distance Drift Controls
-- Begin Rotation Sway Controls

	group "Rotational Sway"
	(
		spinner SwayY "Sway Y (rotational noise)" range:[0, 100, (MotContr.Custom_Attributes.Sway_Y)] type:#float scale:1 fieldwidth:50
		button KSwayY "Create Key" toolTip:"Creates Key for all values" pos:[200,360]
		button FetchRD "Fetch Rotational Drift" toolTip:"Selects Dummy Object" width:255 pos:[15,390]

	)
	
	on FetchRD pressed do (select MotContr)
	on SwayY entered do
	(
	(MotContr.Custom_Attributes.Sway_Y) = mvDrifts.SwayY.value
	)
	
	on KSwayY pressed do
	(
		TStamp = sliderTime
		KeyVal = mvDrifts.SwayY.value
		(addNewKey MotContr.Custom_Attributes.Sway_Y.controller TStamp).value = KeyVal 
		--Slider_Update()
	)
-- End of Rotation Sway Controls

)

-- Define Rollout #2
	
rollout mvDoors "Door Controls"
(
--	group "Front Door Sliders"
--	(
--		slider LDoor "Left Door Open / Close" range:[0, 0.8, LDSlider.value] type:#float orient:#horizontal
--		button KLDoor "Create Key" toolTip:"Creates Key for all values" pos:[200,80]
--		button FetchDL "Fetch Left Door" toolTip:"Selects Dummy Object" width:255 pos:[15,110]
--		slider RDoor "Right Door Open / Close" range:[0, 0.8, RDSlider.value] type:#float orient:#horizontal
--		button KRDoor "Create Key" toolTip:"Creates Key for all values" pos:[200,190]
--		button FetchDR "Fetch Right Door" toolTip:"Selects Dummy Object" width:255 pos:[15,220]

--	)
	
-- UI ** DISABLED **

--	group "Rear Doors"
	
--	(
--	slider RLDoor "Left Door Open / Close" range:[96.9, 283.9, RLDoorSlider.value] type:#float orient:#horizontal
--	button KRLDoor "Create Key" toolTip:"Creates Key for all values" pos:[200,76]
--	button FetchFDL "Fetch Left Door" toolTip:"Selects Dummy Object" width:255 pos:[15,106]
--	slider RRDoor "Right Door Open / Close" range:[96.9, 283.9, RRDoorSlider.value] type:#float orient:#horizontal
--	button KRRDoor "Create Key" toolTip:"Creates Key for all values" pos:[200,185]
--	button FetchFDR "Fetch Right Door" toolTip:"Selects Dummy Object" width:255 pos:[15,215]
--	)

-- Controls for Left Door
	
--	on FetchFDL pressed do (select RLDoorSlider)	** DISABLED **
--	on FetchFDR pressed do (select RRDoorSlider)	** DISABLED **
--	on FetchDL pressed do (select LDSlider)  ** DISABLED **
--	on FetchDR pressed do (select RDSlider)  ** DISABLED **

--	on LDoor changed val do
--	(
--	LDSlider.value = val
--	)
--	on KLDoor pressed do
--		(
--		TStamp = sliderTime
--		KeyVal = mvDoors.LDoor.value
--		(addNewKey LDSlider.value.controller TStamp).value = KeyVal 
--		--Slider_Update()
--	)

-- ** DISABLED **

-- Controls for Right Door

--	on RDoor changed val do
--	(
--	RDSlider.value = val
--	)
--	on KRDoor pressed do
--		(
--		TStamp = sliderTime
--		KeyVal = mvDoors.RDoor.value
--		(addNewKey RDSlider.value.controller TStamp).value = KeyVal 
--		--Slider_Update()
--		)

-- ** DISABLED **

-- Controls for Rear Left Door

--	on RLDoor changed val do
--  (
--	RLDoorSlider.value = val
--	)
--	on KRLDoor pressed do
--		(
--		TStamp = sliderTime
--		KeyVal = mvDoors.RLDoor.value
--		(addNewKey RLDoorSlider.value.controller TStamp).value = KeyVal 
--		--Slider_Update()
--		)
-- Controls for Rear Right Door

--	on RRDoor changed val do
--	(
--	RRDoorSlider.value = val
--	)
--	on KRRDoor pressed do
--		(
--		TStamp = sliderTime
--		KeyVal = mvDoors.RRDoor.value
--		(addNewKey RRDoorSlider.value.controller TStamp).value = KeyVal 
--		--Slider_Update()
--		)

)

-- Define Rollout #3

--rollout mvRotors "Rotor Controls"
--(
--	group "Front and Rear Rotor"
--	(
--	label RSpeed "Rotor Speed" alignment:#Right Pos:[15,5]
--	spinner FRotorSpeed "Front Rotor Speed" range:[0, 100, (FRotor.Custom_Attributes.Rotor_Speed)] type:#float fieldwidth:50 
--	spinner RRotorSpeed "Rear Rotor Speed" range:[0, 100, (RRotor.Custom_Attributes.RRotor_Speed)] type:#float fieldwidth:50 
--	button FetchFR "Fetch Front Rotor" toolTip:"Selects Dummy Object" width:255 pos:[15,70]
--	button FetchRR "Fetch Rear Rotor" toolTip:"Selects Dummy Object" width:255 pos:[15,100]
--	slider RTiltSlider "Rotor Tilt" range:[1.4, 1.7, RTilt.value] type:#float orient:#horizontal
--	button KRotor "Create Key" toolTip:"Creates Key for checked values" pos:[200,180]
--	checkbox FRKeyable "Make Key" pos:[15,20]
--	checkbox RRKeyable "Make key" pos:[15,40]
--	checkbox TiltKeyable "Make Slider Key" pos:[15,180]
--	button FetchRT "Fetch Rotor Tilt" toolTip:"Selects Dummy Object" width:255 pos:[15,210]
--	)
--
-- Update Functions
--	on FetchFR pressed do (select FRotor)
--	on FetchRR pressed do (select RRotor)
--	on FetchRT pressed do (select RTilt)
--	
--	on FRotor entered do
--	(
--	(FRotor.Custom_Attributes.Rotor_Speed) = mvRotors.FRotorSpeed.value
--	)
--	on RRotor entered do
--	(
--	(RRotor.Custom_Attributes.RRotor_Speed) = mvRotors.RRotorSpeed.value
--	)
--	on RTiltSlider changed val do
--	(
--	RTilt.value = val
--	)
--	
-- Create Keys Function
	
--	on KRotor pressed do
--	(
--	if mvRotors.FRKeyable.checked == true
--		then
--		(
--		TStamp = sliderTime
--		KeyVal = mvRotors.FRotorSpeed.value
--		(addNewKey FRotor.Custom_Attributes.Rotor_Speed.controller TStamp).value = KeyVal 
--		--Slider_Update()
--		)
--	if mvRotors.RRKeyable.checked == true
--	then
--		(
--		TStamp = sliderTime
--		KeyVal = mvRotors.RRotorSpeed.value
--		(addNewKey RRotor.Custom_Attributes.RRotor_Speed.controller TStamp).value = KeyVal 
--		--Slider_Update()
--		)
--	if mvRotors.TiltKeyable.checked == true
--		then
--		(
--		TStamp = sliderTime
--		KeyVal = mvRotors.RTiltSlider.value
--		(addNewKey RTilt.value.controller TStamp).value = KeyVal 
--		--Slider_Update()
--		)
--	)
--
--)

-- UI ** DISABLED **

-- Define Rollout #4

rollout mvBank "Bank Controls"
(
	group "Y axis Banking"
	(
	slider MBankSlider "Rotation" range:[-0.5, 0.5, 0] type:#float orient:#horizontal
	button KBank "Create Key" toolTip:"Creates Key for all values" pos:[200,75]
	button FetchBS "Fetch Bank" toolTip:"Selects Dummy Object" width:255 pos:[15,105]
	)
	on FetchBS pressed do (select MBank)
	on MBankSlider changed val do
	(
	MBank.value = val
	)
	on KBank pressed do
		(
		TStamp = sliderTime
		KeyVal = mvBank.MBankSlider.value
		(addNewKey MBank.value.controller TStamp).value = KeyVal 
		--Slider_Update()
		)
)

-- Define Rollout #5

rollout mvElevation "Elevation Controls"
(
	group "Main Elevation"
	(
	label ZHeight "Z Height Offset" alignment:#Right Pos:[15,5]
	spinner ZElevationControl "Elevation (in Max Units)" range:[-4000, 40000, ZElevation.value] type: #float scale:1 fieldwidth:50 
	button KElevation "Create Key" toolTip:"Creates Key for all values" pos:[200,55]
	button FetchEv "Fetch Elevation" toolTip:"Selects Dummy Object" width:255 pos:[15,85]
	)
	on FetchEv pressed do (select ZElevation)
	on ZElevationControl entered do
	(
	ZElevation.value = mvElevation.ZElevationControl.value
	)
	on KElevation pressed do
		(
		TStamp = sliderTime
		KeyVal = mvElevation.ZElevationControl.value
		(addNewKey zElevation.value.controller TStamp).value = KeyVal 
		--Slider_Update()
		)
)

-- Define Rollout #6

--rollout mvElevator "Rear Elevator"
--(
--	group "Rear Elevator Controls"
--	(
--	slider RElevator "Rotation" range:[0, 0.5, 0] type:#float orient:#horizontal
--	button KRElevator "Create Key" toolTip:"Creates Key for all values" pos:[200,75]
--	button FetchEl "Fetch Elevator Control" toolTip:"Selects Dummy Object" width:255 pos:[15,105]
--	)
--	on FetchEl pressed do (select ElevatorSlider)
--	on RElevator changed val do
--		(
--		ElevatorSlider.value = val
--		)
--	on KRElevator pressed do
--		(
--		TStamp = sliderTime
--		KeyVal =mvElevator.RElevator.value
--		(addNewKey ElevatorSlider.value.controller TStamp).value = KeyVal 
--		--Slider_Update()
--		)
--)

-- UI ** DISABLED **

rollout mvCreateHeliTracks "Track View Utilities"
(
	group "Helicopter Rig Tracks"
	(
	button mvCHTdo "Create Heli Tracks" width: 255
	)

	on mvCHTdo pressed do
	(
	createHeliTracks()
	)
)
-- this created the floater and you can specify it's dimentions

	if HeliFloater != undefined do
	(
		closeRolloutFloater HeliFloater
	)
	
	HeliFloater = newRolloutFloater "Helicopter Rigging v1.1" 300 800
	addRollout mvSelect HeliFloater 
	addRollout mvDrifts HeliFloater
--	addRollout mvDoors HeliFloater rolledUp: true
--	addRollout mvRotors HeliFloater rolledUp: true		** DISABLED **
	addRollout mvBank HeliFloater rolledUp: true
	addRollout mvElevation HeliFloater rolledUp: true
--	addRollout mvElevator HeliFloater rolledUp: true	** DISABLED **
	addRollout mvCreateHeliTracks HeliFloater rolledUp: true

		
 	if createIntVal1 == false then -- Create Rig #1's Defaults if necessary
 	(
 	FunctionCall = 1
 	fileIn "Heli_Controls-[Functions].ms"
 	if HeliDebug == true do (print "Attempting to Call Script")
 	)

registerTimeCallback Slider_Update

--
--
--
--
--
--
--
--
