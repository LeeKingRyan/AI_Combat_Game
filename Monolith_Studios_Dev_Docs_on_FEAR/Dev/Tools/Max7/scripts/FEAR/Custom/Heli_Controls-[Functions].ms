fn createInitValues =
(

	-- Defines key 0 for all attributes
		if HeliDebug == true do (print "Creating Rig Defaults")
		animate on 
		(
		addNewKey PosNoise.Custom_Attributes.Drift_X.controller 0
		addNewKey PosNoise.Custom_Attributes.Drift_Y.controller 0
		addNewKey PosNoise.Custom_Attributes.Drift_Z.controller 0
		addNewKey PosNoise.Custom_Attributes.Time_X.controller 0
		addNewKey PosNoise.Custom_Attributes.Time_Y.controller 0
		addNewKey PosNoise.Custom_Attributes.Time_Z.controller 0
		addNewKey MotContr.Custom_Attributes.Sway_Y.controller 0
--		addNewKey LDSlider.value.controller 0				** DISABLED **
--		addNewKey RDSlider.value.controller 0				** DISABLED **
--		addNewKey FRotor.Custom_Attributes.Rotor_Speed.controller 0	** DISABLED **
--		addNewKey RRotor.Custom_Attributes.RRotor_Speed.controller 0	** DISABLED **
--		addNewKey RTilt.value.controller 0				** DISABLED **
		addNewKey MBank.value.controller 0 
		addNewKey ZElevation.value.controller 0
		
--		if ElevatorSlider != undefined do				** DISABLED **
--			(							** DISABLED **
--										** DISABLED **
--			addNewKey ElevatorSlider.value.controller 0		** DISABLED **
--			addNewKey RLDoorSlider.value.controller 0		** DISABLED **
--			addNewKey RRDoorSlider.value.controller 0		** DISABLED **
--			)							** DISABLED **
		
		if STarget != undefined do
			(
			addNewKey STarget.Custom_Attributes.Drift_X.controller 0
			addNewKey STarget.Custom_Attributes.Drift_Y.controller 0
			addNewKey STarget.Custom_Attributes.Drift_Z.controller 0
			addNewKey STarget.Custom_Attributes.Time_X.controller 0
			addNewKey STarget.Custom_Attributes.Time_Y.controller 0
			addNewKey STarget.Custom_Attributes.Time_Z.controller 0
			)
		)
	if mvSelect.rigSelect.selection == 1 then (createIntVal1 = true)
	if mvSelect.rigSelect.selection == 2 then (createIntVal2 = true)
	if mvSelect.rigSelect.selection == 3 then (createIntVal3 = true)
	if mvSelect.rigSelect.selection == 4 then (createIntVal4 = true)
	
)

fn UpdateUI = 
(
if HeliDebug == true do (print "Update the UI now!")
-- Drifts
mvDrifts.DriftX.value = PosNoise.Custom_Attributes.Drift_X
mvDrifts.DriftY.value = PosNoise.Custom_Attributes.Drift_Y
mvDrifts.DriftZ.value = PosNoise.Custom_Attributes.Drift_Z
mvDrifts.DTimeX.value = PosNoise.Custom_Attributes.Time_X
mvDrifts.DTimeY.value = PosNoise.Custom_Attributes.Time_Y
mvDrifts.DTimeZ.value = PosNoise.Custom_Attributes.Time_Z

-- Rotation Sway

mvDrifts.SwayY.value = MotContr.Custom_Attributes.Sway_Y

-- Sliders
	
-- mvDoors.LDoor.value = LDSlider.value		** DISABLED **
-- mvDoors.RDoor.value = RDSlider.value		** DISABLED **
-- mvRotors.RTiltSlider.value = RTilt.value	** DISABLED **
mvBank.MBankSlider.value = MBank.value

-- BLACKHAWK ONLY UPDATES

-- if ElevatorSlider != undefined do					** DISABLED **
--	(								** DISABLED **
--	mvElevator.RElevator.value = ElevatorSlider.value		** DISABLED **
--	mvDoors.RLDoor.value = RLDoorSlider.value			** DISABLED **
--	mvDoors.RRDoor.value = RRDoorSlider.value			** DISABLED **
--	)								** DISABLED **
-- BLACKHAWK ONLY UPDATES						

-- Rotor Speeds

-- mvRotors.FRotorSpeed.value = FRotor.Custom_Attributes.Rotor_Speed	** DISABLED **
-- mvRotors.RRotorSpeed.value = RRotor.Custom_Attributes.RRotor_Speed	** DISABLED **

-- Elevation

mvElevation.ZElevationControl.value = ZElevation.value

--HIND ONLY UPDATES

if STarget != undefined do
	(
	mvSpotlight.SDriftX.value = STarget.Custom_Attributes.Drift_X
	mvSpotlight.SDriftY.value = STarget.Custom_Attributes.Drift_Y
	mvSpotlight.SDriftZ.value = STarget.Custom_Attributes.Drift_Z
	mvSpotlight.SDTimeX.value = STarget.Custom_Attributes.Time_X
	mvSpotlight.SDTimeY.value = STarget.Custom_Attributes.Time_Y
	mvSpotlight.SDTimeZ.value = STarget.Custom_Attributes.Time_Z
	)

--HIND ONLY UPDATES
-- End UI Update

)

case FunctionCall of 
(
1: createInitValues()
2: UpdateUI()
)
