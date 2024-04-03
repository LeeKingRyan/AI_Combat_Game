--	Function Handling for Nudge Utility Panel v1.0
--
--	Written by Kevin Deadrick (Monolith) for F.E.A.R. project development.
-- 
--	v1.0 RELEASE
--
--	Added support for Sub Object Manipulation(s)

-- Begin Define Up Functions for Sub Objects

fn NudgeSubUp = 
(
-- Check for non poly object class

if superclassof $ != GeometryClass then
	(
	messagebox "Cannot Perform Operation on Non-Geometry Class Object!" title: "Alert" beep: true
	)
	else
	(
-- Set Selection Var
	
	local SubType

	Sel = selection as array
	if Ndebug == true do (print Sel[1].name)
	VertSel = Sel[1].selectedVerts
	if Ndebug == true do (print VertSel)
	EdgeSel = Sel[1].selectedEdges
	if Ndebug == true do (print EdgeSel)
	FaceSel = Sel[1].selectedFaces
	if Ndebug == true do (print FaceSel)

-- Establish SubType

	case ObjLevel of 
		(
		1: SubType = VertSel
		2: SubType = EdgeSel
		3: SubType = EdgeSel
		4: SubType = FaceSel
		5: SubType = FaceSel
		)

-- Check Grid State and Set Active Var

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
			
				YDistance = NDistance
				move SubType [0,YDistance,0]
				
			)
		if AxisState == 1 do
			(
			
				ZDistance = NDistance
				move SubType [0,0,ZDistance]
				
			)
	)
)

-- End Up
-- Begin Define Down Functions for Sub Objects

fn NudgeSubDown = 
(
-- Check for non poly object class

if superclassof $ != GeometryClass then
	(
	messagebox "Cannot Perform Operation on Non-Geometry Class Object!" title: "Alert" beep: true
	)
	else
	(
-- Set Selection Var
	
	local SubType

	Sel = selection as array
	if Ndebug == true do (print Sel[1].name)
	VertSel = Sel[1].selectedVerts
	if Ndebug == true do (print VertSel)
	EdgeSel = Sel[1].selectedEdges
	if Ndebug == true do (print EdgeSel)
	FaceSel = Sel[1].selectedFaces
	if Ndebug == true do (print FaceSel)

-- Establish SubType

	case ObjLevel of 
		(
		1: SubType = VertSel
		2: SubType = EdgeSel
		3: SubType = EdgeSel
		4: SubType = FaceSel
		5: SubType = FaceSel
		)

-- Check Grid State and Set Active Var

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
			
				YDistance = NDistance
				move SubType [0,YDistance,0]
				
			)
		if AxisState == 1 do
			(
			
				ZDistance = NDistance
				move SubType [0,0,ZDistance]
				
			)
	)
)

-- End Down
-- Begin Define Left Functions for Sub Objects

fn NudgeSubLeft = 
(
-- Check for non poly object class

if superclassof $ != GeometryClass then
	(
	messagebox "Cannot Perform Operation on Non-Geometry Class Object!" title: "Alert" beep: true
	)
	else
	(
-- Set Selection Var
	
	local SubType

	Sel = selection as array
	if Ndebug == true do (print Sel[1].name)
	VertSel = Sel[1].selectedVerts
	if Ndebug == true do (print VertSel)
	EdgeSel = Sel[1].selectedEdges
	if Ndebug == true do (print EdgeSel)
	FaceSel = Sel[1].selectedFaces
	if Ndebug == true do (print FaceSel)

-- Establish SubType

	case ObjLevel of 
		(
		1: SubType = VertSel
		2: SubType = EdgeSel
		3: SubType = EdgeSel
		4: SubType = FaceSel
		5: SubType = FaceSel
		)

-- Check Grid State and Set Active Var

	GridSet = mvPanelControls.mvUseGrid.checked	
	ActiveGridVal = getGridSpacing()

-- Check for Active Grid vs Manual Dist

	if GridSet == false do (NDistance = -DistVal)
	if GridSet == true do (NDistance = -ActiveGridVal)

			if Ndebug == true do (print SelectionArray)
			if Ndebug == true do (print NDistance)
	XDistance = NDistance
	move SubType [XDistance,0,0]
	)
)

-- End Left
-- Begin Define Right Functions for Sub Objects

fn NudgeSubRight = 
(
-- Check for non poly object class

if superclassof $ != GeometryClass then
	(
	messagebox "Cannot Perform Operation on Non-Geometry Class Object!" title: "Alert" beep: true
	)
	else
	(
-- Set Selection Var
	
	local SubType

	Sel = selection as array
	if Ndebug == true do (print Sel[1].name)
	VertSel = Sel[1].selectedVerts
	if Ndebug == true do (print VertSel)
	EdgeSel = Sel[1].selectedEdges
	if Ndebug == true do (print EdgeSel)
	FaceSel = Sel[1].selectedFaces
	if Ndebug == true do (print FaceSel)

-- Establish SubType

	case ObjLevel of 
		(
		1: SubType = VertSel
		2: SubType = EdgeSel
		3: SubType = EdgeSel
		4: SubType = FaceSel
		5: SubType = FaceSel
		)

-- Check Grid State and Set Active Var

	GridSet = mvPanelControls.mvUseGrid.checked	
	ActiveGridVal = getGridSpacing()

-- Check for Active Grid vs Manual Dist

	if GridSet == false do (NDistance = DistVal)
	if GridSet == true do (NDistance = ActiveGridVal)

			if Ndebug == true do (print SelectionArray)
			if Ndebug == true do (print NDistance)
	XDistance = NDistance
	move SubType [XDistance,0,0]
	)
)

-- End Functions for Sub Objects

-- Begin Function Call Handling

	if ButtonCall == 1 do
	(

-- Check for Modifiers and prompt for collapse if necessary

		SelectionArray = selection as array
		
		SelectObj = SelectionArray[1]

		ModCheck = SelectObj.Modifiers

		if ModCheck.count == 0 then 
		(NudgeSubUp())
		
		else 
			(
			if querybox "Unable To Translate With Modifiers Present! Collapse Stack?" title: "Alert!" beep: true then
				(
				collapseStack SelectObj
				subObjectLevel = ObjLevel
				NudgeSubUp()
				)

			)

	)
	
	if ButtonCall == 2 do
	(

-- Check for Modifiers and prompt for collapse if necessary

		SelectionArray = selection as array
		
		SelectObj = SelectionArray[1]

		ModCheck = SelectObj.Modifiers

		if ModCheck.count == 0 then 
		(NudgeSubDown())
		
		else 
			(
			if querybox "Unable To Translate With Modifiers Present! Collapse Stack?" title: "Alert!" beep: true then
				(
				collapseStack SelectObj
				subObjectLevel = ObjLevel
				NudgeSubDown()
				)

			)
	
	)

	if ButtonCall == 3 do
	(

-- Check for Modifiers and prompt for collapse if necessary

		SelectionArray = selection as array
		
		SelectObj = SelectionArray[1]

		ModCheck = SelectObj.Modifiers

		if ModCheck.count == 0 then 
		(NudgeSubLeft())
		
		else 
			(
			if querybox "Unable To Translate With Modifiers Present! Collapse Stack?" title: "Alert!" beep: true then
				(
				collapseStack SelectObj
				subObjectLevel = ObjLevel
				NudgeSubLeft()
				)

			)	
	
	
	)
	
	if ButtonCall == 4 do
	(

-- Check for Modifiers and prompt for collapse if necessary

		SelectionArray = selection as array
		
		SelectObj = SelectionArray[1]

		ModCheck = SelectObj.Modifiers

		if ModCheck.count == 0 then 
		(NudgeSubRight())
		
		else 
			(
			if querybox "Unable To Translate With Modifiers Present! Collapse Stack?" title: "Alert!" beep: true then
				(
				collapseStack SelectObj
				subObjectLevel = ObjLevel
				NudgeSubRight()
				)

			)	
	
	)

-- End Function Call Handling
-- End Script