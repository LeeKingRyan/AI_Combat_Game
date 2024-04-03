--
--	Kaldera Session Manager lite v1.01 for Max6, Kaldera plugin required (see www.Mankua.com).
--
--	Written by Kevin Deadrick (Monolith) for F.E.A.R. project development.
--
--	Stripped down version of Session Manager v1.10 for Max 6.  For more info please see the documentation 
--	for the full version of the Session Manager
--
--	v1.01
--	Fixed Base pathname bug.  Name now updates to undefined if cancled out of save file dialog
--	Fixed Bug w/ Normal space and green up settings not applying to all sessions.  Setting is now done at render time
--	Added a unhide all command to the start of each render option to ensure that target(s) and source are not hidden.




------------------------ Begin script

struct SessionMgrClass (LiteralName, DisplayName, Target, TSelectFaces, TMapChannel, TMatID, TMatIDAll, TVisible)

-- setting global var

global SessionMgr
global CurrentSelectNum = 1
global SDisplayName
global outfile = "undefined"
global RenderType

-- Establish File Arrays
		
		Outfile_C = #()
		Outfile_D = #()
		Outfile_N = #()
		Outfile_A = #()
		Outfile_L = #()
		Outfile_S = #()

-- end global var setup

IniTest = getFiles "$scripts/FEAR/KSM_Preferences.ini"

	if IniTest.count != 1 do
	(
setIniSetting "$scripts/FEAR/KSM_Preferences.ini" "Rollouts" "Help" (false as string)
setIniSetting "$scripts/FEAR/KSM_Preferences.ini" "Rollouts" "Settings" (true as string)
setIniSetting "$scripts/FEAR/KSM_Preferences.ini" "Rollouts" "Maps" (false as string)
setIniSetting "$scripts/FEAR/KSM_Preferences.ini" "Rollouts" "Rays and Hits" (false as string)
setIniSetting "$scripts/FEAR/KSM_Preferences.ini" "Rollouts" "output" (false as string)
setIniSetting "$scripts/FEAR/KSM_Preferences.ini" "Rollouts" "render" (false as string)
setIniSetting "$scripts/FEAR/KSM_Preferences.ini" "Rollouts" "sessions" (true as string)
setIniSetting "$scripts/FEAR/KSM_Preferences.ini" "Rollouts" "Target" (false as string)
setIniSetting "$scripts/FEAR/KSM_Preferences.ini" "Rollouts" "Tangent" "1"
setIniSetting "$scripts/FEAR/KSM_Preferences.ini" "Rollouts" "GreenUp" "1"
setIniSetting "$scripts/FEAR/KSM_Preferences.ini" "paths" "outfile" "undefined"
setIniSetting "$scripts/FEAR/KSM_Preferences.ini" "RenderSet" "complete" (false as string)
setIniSetting "$scripts/FEAR/KSM_Preferences.ini" "RenderSet" "Diffuse" (false as string)
setIniSetting "$scripts/FEAR/KSM_Preferences.ini" "RenderSet" "Normal" (false as string)
setIniSetting "$scripts/FEAR/KSM_Preferences.ini" "RenderSet" "Alpha" (false as string)
setIniSetting "$scripts/FEAR/KSM_Preferences.ini" "RenderSet" "Lighting" (false as string)
setIniSetting "$scripts/FEAR/KSM_Preferences.ini" "RenderSet" "shadow" (false as string)
setIniSetting "$scripts/FEAR/KSM_Preferences.ini" "RenderOptions" "Global" (false as string)
setIniSetting "$scripts/FEAR/KSM_Preferences.ini" "RenderOptions" "Composite" (true as string)
	
	print "Config File Created"
	)

if SessionMgr == undefined or debug != true do SessionMgr = SessionMgrClass()
	
	Session_Names = #()
	Session_Array = #()
	Source_Names = #()
	Source_Array = #()
	Render_Array =#()
	THelper_Array = $Helpers as array
	for i in THelper_Array do
	(
	HelperClass = ((classof i) as string) as name
	if HelperClass == #Kaldera_Session do append Session_Array i
	)
	for i in Session_Array do 
	(
	SName = i.name as string
	append Session_Names SName
	)

-- Rename Rollout

rollout mvHelp "Help and Info" 
(
	group "about"
	(
	label mvAbout_01 "Kaldera Session Manager Utility v1.01 (lite)"
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
	ShellLaunch "$max/help/KSM_Help.hlp" ""
	)

)

rollout mvConfig "Settings"
(
	group "Global Info / Options"
	(
	button mvUpdate "Update List" offset:[0,0] width: 270
	)

	on mvUpdate pressed do 
	(
	fileIn "KSM_UI_Builder_LT.ms"
	fileIn "KSM_StoreUI.ms"
	)
)

rollout mvMaps "Maps" 
(
	group "Map Listing"
	(
	label mvBasePathLabel "Base Pathname:" across: 1 
	button mvBasePath "Set Base Pathname" width: 200
	-- Complete Map
	label mvCompleteMapLabel "Complete Map:" offset:[-30,0] across: 2
	checkbutton mvCompleteRenderCheck "" offset:[55,-5] width: 19 height: 19 images:#("$UI/Icons/Monolith Productions/FEAR/KSM_02_i.bmp", "$UI/Icons/Monolith Productions/FEAR/KSM_02_a.bmp:", 2, 1, 2, 1, 1)
	button mvCompleteMap "Set Base Path" width: 270 enabled: false
	-- Diffuse Map
	label mvDiffuseMapLabel "Diffuse Map:" offset:[-30,1] across: 2
	checkbutton mvDiffuseRenderCheck "" offset:[55,-1] width: 19 height: 19 images:#("$UI/Icons/Monolith Productions/FEAR/KSM_02_i.bmp", "$UI/Icons/Monolith Productions/FEAR/KSM_02_a.bmp:", 2, 1, 2, 1, 1)
	button mvDiffuseMap "Set Base Path" width: 270 enabled: false offset:[0,1]
	-- Normal Map
	label mvNormalMapLabel "Normal Map:" offset:[-30,1] across: 2
	checkbutton mvNormalRenderCheck "" offset:[55,-1] width: 19 height: 19 images:#("$UI/Icons/Monolith Productions/FEAR/KSM_02_i.bmp", "$UI/Icons/Monolith Productions/FEAR/KSM_02_a.bmp:", 2, 1, 2, 1, 1)
	button mvNormalMap "Set Base Path" width: 270 enabled: false offset:[0,1]
	label mvNormalOptions "Normal Map Options"
	radiobuttons mvNormal_Tangent labels:#("Tangent","Worldspace") columns: 1 across: 2
	radiobuttons mvNormal_YSpace labels:#("Y up (Green)","Y down (Green)") columns: 1
	label mvBuffer_001 ""
	-- Alpha Map
	label mvAlphaMapLabel "Alpha Map:" offset:[-30,1] across: 2
	checkbutton mvAlphaRenderCheck "" offset:[55,-1] width: 19 height: 19 images:#("$UI/Icons/Monolith Productions/FEAR/KSM_02_i.bmp", "$UI/Icons/Monolith Productions/FEAR/KSM_02_a.bmp:", 2, 1, 2, 1, 1)
	button mvAlphaMap "Set Base Path" width: 270 enabled: false offset:[0,1]
	-- Lighting Map
	label mvLightingMapLabel "Lighting Map:" offset:[-30,1] across: 2
	checkbutton mvLightingRenderCheck "" offset:[55,-1] width: 19 height: 19 images:#("$UI/Icons/Monolith Productions/FEAR/KSM_02_i.bmp", "$UI/Icons/Monolith Productions/FEAR/KSM_02_a.bmp:", 2, 1, 2, 1, 1)
	button mvLightingMap "Set Base Path" width: 270 enabled: false offset:[0,1]
	-- Shadow Map
	label mvShadowMapLabel "Shadow Map:" offset:[-30,1] across: 2
	checkbutton mvShadowRenderCheck "" offset:[55,-1] width: 19 height: 19 images:#("$UI/Icons/Monolith Productions/FEAR/KSM_02_i.bmp", "$UI/Icons/Monolith Productions/FEAR/KSM_02_a.bmp:", 2, 1, 2, 1, 1)
	button mvShadowMap "Set Base Path" width: 270 enabled: false offset:[0,1]
	-- Height Map
	label mvHeightMapLabel "Height Map:" offset:[-30,1] across: 2
	checkbutton mvHeightRenderCheck "" offset:[55,-1] width: 19 height: 19 images:#("$UI/Icons/Monolith Productions/FEAR/KSM_02_i.bmp", "$UI/Icons/Monolith Productions/FEAR/KSM_02_a.bmp:", 2, 1, 2, 1, 1)
	button mvHeightMap "Set Base Path" width: 270 enabled: false offset:[0,1]
	)

-- Begin Set Base path setup

	on mvBasePath pressed do 
	(
	outfile = undefined
	outfile = getsavefilename types: "Targa files (*.tga)|*.tga|"
	if outfile == undefined do 
		(
		outfile = "undefined"
		mvMaps.mvBasePath.caption = "Set Base Pathname"
		mvMaps.mvCompleteMap.caption = "Set Base Pathname"
		mvMaps.mvDiffuseMap.caption = "Set Base Pathname"
		mvMaps.mvNormalMap.caption = "Set Base Pathname"
		mvMaps.mvAlphaMap.caption = "Set Base Pathname"
		mvMaps.mvLightingMap.caption = "Set Base Pathname"
		mvMaps.mvShadowMap.caption = "Set Base Pathname"
		mvMaps.mvHeightMap.caption = "Set Base Pathname"
		setIniSetting "$scripts/FEAR/KSM_Preferences.ini" "paths" "outfile" (outfile as string)
		)

	if outfile != "undefined" do mvMaps.mvBasePath.caption = getFilenamePath outfile 
	if outfile != "undefined" do
		(
		outPath = getFilenamePath outfile
		outfileName = getFilenameFile outfile
		outExten = getFilenameType outfile

		mvMaps.mvCompleteMap.caption = (outfileName + "_C" + outExten)
		mvMaps.mvDiffuseMap.caption = (outfileName + "_D" + outExten)
		mvMaps.mvNormalMap.caption = (outfileName + "_N" + outExten)
		mvMaps.mvAlphaMap.caption = (outfileName + "_A" + outExten)
		mvMaps.mvLightingMap.caption = (outfileName + "_L" + outExten)
		mvMaps.mvShadowMap.caption = (outfileName + "_S" + outExten)
		mvMaps.mvHeightMap.caption = (outfileName + "_H" + outExten)
		setIniSetting "$scripts/FEAR/KSM_Preferences.ini" "paths" "outfile" (outfile as string)
		)
	)

-- End Set Base path setup

-- set ini to remember render options:

	on mvCompleteRenderCheck changed state do
	(
	setIniSetting "$scripts/FEAR/KSM_Preferences.ini" "RenderSet" "complete" (mvMaps.mvCompleteRenderCheck.checked as string)
	)
	on mvDiffuseRenderCheck changed state do
	(
	setIniSetting "$scripts/FEAR/KSM_Preferences.ini" "RenderSet" "Diffuse" (mvMaps.mvDiffuseRenderCheck.checked as string)
	)
	on mvNormalRenderCheck changed state do
	(
	setIniSetting "$scripts/FEAR/KSM_Preferences.ini" "RenderSet" "Normal" (mvMaps.mvNormalRenderCheck.checked as string)
	)
	on mvAlphaRenderCheck changed state do
	(
	setIniSetting "$scripts/FEAR/KSM_Preferences.ini" "RenderSet" "Alpha" (mvMaps.mvAlphaRenderCheck.checked as string)
	)
	on mvLightingRenderCheck changed state do
	(
	setIniSetting "$scripts/FEAR/KSM_Preferences.ini" "RenderSet" "Lighting" (mvMaps.mvLightingRenderCheck.checked as string)
	)
	on mvShadowRenderCheck changed state do
	(
	setIniSetting "$scripts/FEAR/KSM_Preferences.ini" "RenderSet" "shadow" (mvMaps.mvShadowRenderCheck.checked as string)
	)
	on mvHeightRenderCheck changed state do
	(
	setIniSetting "$scripts/FEAR/KSM_Preferences.ini" "RenderSet" "Height" (mvMaps.mvHeightRenderCheck.checked as string)
	)
)

rollout mvRays "Rays and Hits" 
(
	group "Ray Depth"
	(
	label mvRayOffsetLabel "Ray Offset:" across: 2 offset:[45,0]
	spinner mvRayOffset "" width:80 range:[0,1000000,5.0] type:#float offset:[-10,0]
	label mvRaylengthLabel "Ray Length:" across: 3 offset:[70,0]
	checkbox mvRayLengthEnable offset:[68,0]
	spinner mvRaylength "" width:80 range:[0,1000000,10] type:#float offset:[-22,0] enabled: false
	)
	group "Reslolve Hit"
	(
	radiobuttons mvHitResolve "" labels:#("Closest","Furthest","Mix") -- offset:[80,0]
	)

-- begin UI functions

	on mvRayOffset entered do 
		(
		SessionMgr.LiteralName.ray_offset = mvRays.mvRayOffset.value
		KalderaUpdate 0
		)
	on mvRayLength entered do
		(
		SessionMgr.LiteralName.ray_length = mvRays.mvRaylength.value
		KalderaUpdate 0
		)
	on mvRayLengthEnable changed state do
	(
		SessionMgr.LiteralName.use_ray_length = mvRays.mvRayLengthEnable.state
		mvRays.mvRaylength.enabled = mvRays.mvRayLengthEnable.state
		KalderaUpdate 0
		fileIn "KSM_UI_Builder_LT.ms"
	)

	on mvHitResolve changed state do
	(
		Ray_Resolve = case mvRays.mvHitResolve.state of
		(
		1: SessionMgr.LiteralName.hit_resolve = 0
		2: SessionMgr.LiteralName.hit_resolve = 1
		3: SessionMgr.LiteralName.hit_resolve = 2
		)
	KalderaUpdate(SessionMgr.LiteralName)
	)
)

rollout mvOutput "Output and Filtering" 
(
	group "Output Settings"
	(
	label mvWidthLabel "Width:" across: 2 offset:[60,0]
	spinner mvWidth "" width:80 range:[0,1000000,0] type:#Integer offset:[-10,0]
	label mvHeightLabel "Height:" across: 2 offset:[60,0]
	spinner mvHeight "" width:80 range:[0,1000000,0] type:#Integer offset:[-10,0]
	checkbutton mvConstrainAspect "Constrain Aspect Ratio" offset:[30,-35] checked: true width: 24 height: 24 images:#("$UI/Icons/Monolith Productions/FEAR/KSM_01_i.bmp", "$UI/Icons/Monolith Productions/FEAR/KSM_01_a.bmp:", 2, 2, 1, 1, 1)
	button mvPreset_a "128 x 128" across: 2 width: 65 offset:[62,10] align:#right
	button mvPreset_b "256 x 256" width: 65 offset:[0,10] align:#right
	button mvPreset_c "512 x 512" width: 65 offset:[62,-2] across: 2 align:#right
	button mvPreset_d "1024 x 1024" width: 65 offset:[0,-2] align:#right
	checkbox mvPreset_Option "Make Presets Global" align:#left offset:[0,-20]

	)
	group "Filtering"
	(
	
	label mvPFilterLabel "Antialiasing:"  across: 2 offset:[90,0]
	spinner mvPFilter "" width:50 range:[0,10,0] type:#Integer offset:[3,0]
	label mvSFilterLabel "Skirt Filter:"  across: 2 offset:[85,0]
	spinner mvSFilter "" width:50 range:[0,10,0] type:#Integer offset:[3,0]
	label mvCropAlphaLabel "Crop Alpha:"  across: 2 offset:[88,0]
	checkbox mvCropAlpha "" offset:[110,0] checked: false
	)
-- begin Output controls
	on mvWidth entered do 
	(
	SessionMgr.LiteralName.rend_width = mvOutput.mvWidth.value
	if mvOutput.mvConstrainAspect.checked == true do 
		(
		SessionMgr.LiteralName.rend_height = mvOutput.mvWidth.value
		mvOutput.mvHeight.value = mvOutput.mvWidth.value
		)
	KalderaUpdate(SessionMgr.LiteralName)
	)
	on mvHeight entered do
	(
	SessionMgr.LiteralName.rend_height = mvOutput.mvHeight.value
	if mvOutput.mvConstrainAspect.checked == true do 
		(
		SessionMgr.LiteralName.rend_width = mvOutput.mvHeight.value
		mvOutput.mvWidth.value = mvOutput.mvHeight.value
		)
	KalderaUpdate(SessionMgr.LiteralName)
	)
	
	on mvConstrainAspect changed TheState do 
	(
		if mvOutput.mvConstrainAspect.checked == true do 
		(
		SessionMgr.LiteralName.rend_width = mvOutput.mvHeight.value
		mvOutput.mvWidth.value = mvOutput.mvHeight.value
		SessionMgr.LiteralName.rend_lock = true
		KalderaUpdate(SessionMgr.LiteralName)
		)
		
		if mvOutput.mvConstrainAspect.checked == false do 
		(
		SessionMgr.LiteralName.rend_lock = false
		KalderaUpdate(SessionMgr.LiteralName)
		)
	)
	on mvPreset_a pressed do
	(
		if mvPreset_Option.checked == false then
		(
		mvOutput.mvWidth.value = 128
		mvOutput.mvHeight.value = 128
		SessionMgr.LiteralName.rend_height = 128
		SessionMgr.LiteralName.rend_width = 128
		KalderaUpdate(SessionMgr.LiteralName)
		)
		else
		(
		for i in Session_Array do
			(
			i.rend_height = 128
			i.rend_width = 128
			KalderaUpdate(SessionMgr.LiteralName)
			)
		mvOutput.mvWidth.value = 128
		mvOutput.mvHeight.value = 128
		KalderaUpdate(SessionMgr.LiteralName)
		)
	)
	on mvPreset_b pressed do
	(
		if mvPreset_Option.checked == false then
		(
		mvOutput.mvWidth.value = 256
		mvOutput.mvHeight.value = 256
		SessionMgr.LiteralName.rend_height = 256
		SessionMgr.LiteralName.rend_width = 256
		KalderaUpdate(SessionMgr.LiteralName)
		)
		else
		(
		for i in Session_Array do
			(
			i.rend_height = 256
			i.rend_width = 256
			KalderaUpdate(SessionMgr.LiteralName)
			)
		mvOutput.mvWidth.value = 256
		mvOutput.mvHeight.value = 256
		KalderaUpdate(SessionMgr.LiteralName)
		)
	)
	on mvPreset_c pressed do
	(
		if mvPreset_Option.checked == false then
		(
		mvOutput.mvWidth.value = 512
		mvOutput.mvHeight.value = 512
		SessionMgr.LiteralName.rend_height = 512
		SessionMgr.LiteralName.rend_width = 512
		KalderaUpdate(SessionMgr.LiteralName)
		)
		else
		(
		for i in Session_Array do
			(
			i.rend_height = 512
			i.rend_width = 512
			KalderaUpdate(SessionMgr.LiteralName)
			)
		mvOutput.mvWidth.value = 512
		mvOutput.mvHeight.value = 512
		KalderaUpdate(SessionMgr.LiteralName)
		)
	)
	on mvPreset_d pressed do
	(
		if mvPreset_Option.checked == false then
		(
		mvOutput.mvWidth.value = 1024
		mvOutput.mvHeight.value = 1024
		SessionMgr.LiteralName.rend_height = 1024
		SessionMgr.LiteralName.rend_width = 1024
		KalderaUpdate(SessionMgr.LiteralName)
		)
		else
		(
		for i in Session_Array do
			(
			i.rend_height = 1024
			i.rend_width = 1024
			KalderaUpdate(SessionMgr.LiteralName)
			)
		mvOutput.mvWidth.value = 1024
		mvOutput.mvHeight.value = 1024
		KalderaUpdate(SessionMgr.LiteralName)
		)
	)


-- End Output controls
-- Begin Filter controls
	on mvPFilter entered do
	(
	SessionMgr.LiteralName.antialiasing = mvOutput.mvPFilter.value
	KalderaUpdate(SessionMgr.LiteralName)
	)
	
	on mvSFilter entered do
	(
	SessionMgr.LiteralName.prefiltering = mvOutput.mvSFilter.value
	KalderaUpdate(SessionMgr.LiteralName)
	)

	on mvCropAlpha changed TheState do
	(
	if mvOutput.mvCropAlpha.checked == true do 
		(
		SessionMgr.LiteralName.crop_alpha = true
		KalderaUpdate(SessionMgr.LiteralName)	
		)
	if mvOutput.mvCropAlpha.checked == false do
		(
		SessionMgr.LiteralName.crop_alpha = false
		KalderaUpdate(SessionMgr.LiteralName)	
		)
	)
-- End Filter controls
)

rollout mvRender "Render" 
(
	-- Filter Function
	fn Session_Filt obj = classof obj.baseObject == Kaldera_Session
	progressBar mvRenderProgress value: 0 height: 5 color:red
	group "Render Globals"
	(
	button mvRenderActive "Render Active" across: 2 width:130 
	button mvRenderAll "Render All" width:130 
	)
	group "Render Custom"
	(
	label mvRenderListLabel "Build Custom Render List: (below)"
	listbox mvRenderList ""
	button mvAddSession "Add" width:50 offset:[-15,0] across: 3 
	button mvSubSession "Reset" width:50 offset:[-40,0] 
	button mvRenderCustom "R E N D E R" width:130 offset:[-25,0] 
	label mvPresetLabel "Custom Render List Presets:" align:#left
	button mvLoadPreset "Load Preset" across: 2 width: 125
	button mvSavePreset "Save Preset" width: 125
	)
	group "Global Illumination"
	(
	colorpicker mvGlobalColor "Sky Color:" color: white across: 3 offset:[5,4] 
	label mvUseGlobalLabel "Use Global Illumination: " offset:[35,6]
	checkbox mvUseGlobal offset:[65,6]
	label mvSpacer_01 "" height: 1

	)
	group "Post Render Options"
	(
	checkbox mvCompositeDO "Composite Final Maps" offset:[0,0]
	checkbox mvDeleteSourceDO "Delete Component Maps"  offset:[0,0] 
	)

	on mvRenderActive pressed do
	(
	if outfile != "undefined" then
		(
		RenderType = 1
		fileIn "KSM_RenderScripts.ms"
		)
		else
		(
		messagebox "Please Set Base Pathname before Rendering!  " title: "ALERT!"
		)
	)

	on mvRenderAll pressed do
	(
	if outfile != "undefined" then
		(
		RenderType = 2
		fileIn "KSM_RenderScripts.ms"
		)
		else
		(
		messagebox "Please Set Base Pathname before Rendering!  " title: "ALERT!"
		)
	)

	on mvAddSession pressed do  
		(
		Render_Array = selectByName title: "Select Sessions to Render"  showHidden: true filter: Session_Filt
		fileIn "KSM_UI_Builder.ms"
		)
		
	on mvSubSession pressed do
		(
		Render_Array = #()
		fileIn "KSM_UI_Builder.ms"
		)
	on mvRenderCustom pressed do
	(
	if outfile != "undefined" then
		(
		RenderType = 3
		fileIn "KSM_RenderScripts.ms"
		)
		else
		(
		messagebox "Please Set Base Pathname before Rendering!  " title: "ALERT!"
		)
	)

-- establish global illumination .ini setting

	on mvUseGlobal changed state do 
	(
	setIniSetting "$scripts/FEAR/KSM_Preferences.ini" "RenderOptions" "Global" (mvRender.mvUseGlobal.checked as string)
	
	)

-- estabish post render controls
	
	on mvCompositeDo changed state do
	(
	if mvRender.mvCompositeDo.checked == true do (mvRender.mvDeleteSourceDO.enabled = true)
	if mvRender.mvCompositeDo.checked == false do (mvRender.mvDeleteSourceDO.enabled = false)
	setIniSetting "$scripts/FEAR/KSM_Preferences.ini" "RenderOptions" "Composite" (mvRender.mvCompositeDo.checked as string)
	fileIn "KSM_UI_Builder.ms"
	)

-- establish preset controls

	on mvSavePreset pressed do
	(
	SaveName = getSaveFileName \
	types:"Render List Preset (*.ini)|*.ini|All|*.*|"
	if SaveName != undefined do
	(
	Storage_array = #()
	for i in Render_Array do
		(
		Name = i.name
		append Storage_array Name
		)
	setIniSetting SaveName "RenderPreset" "Name_Array" (Storage_array as String)
	print "Preset Save Successful"
	)
	)
	-- Load Preset Functions

	on mvLoadPreset pressed do
	(
	LoadName = getOpenFileName \ 
	types:"Render List Preset (*.ini)|*.ini|All|*.*|" 
		if LoadName != undefined do
		(
		Render_Array = #()
		Test_Array = execute(getIniSetting LoadName "RenderPreset" "Name_Array")
			for i in Test_Array do
				(
				TestName = i
				for j in Session_Array do
					(
					if j.name == TestName do
						(
						append Render_Array j
						)
					)
				)
		fileIn "KSM_UI_Builder.ms"
		)

	)
	
)

rollout rename_rollout "Enter New Session Name" 

  ( 

    edittext Session_name text: (SessionMgr.LiteralName.name as string) bold: true

    button rename_them "RENAME Active Session..." 

    on rename_them pressed do 

    ( 
	if Session_Name.text != "" then
	(
	NewName_Value = rename_rollout.Session_Name.text as name
	SessionMgr.LiteralName.name = NewName_Value
	destroyDialog rename_Rollout
	fileIn "KSM_UI_Builder_LT.ms"
	KalderaSession (SessionMgr.LiteralName)
	KalderaUpdate (SessionMgr.LiteralName)
	)
    )--end on 

)--end rollout 

rollout mvSessions "Session Listing"
(
	group "Sessions"
	(
	label mvDirections_01 "Select Active Session from List (below)"
	listbox mvSession_List "" items:Session_Names selection: CurrentSelectNum
	-- button mvCloneSession "Clone" width: 80 across: 3 Temporarily Removed
	-- button mvDeleteSession "Delete" width: 80 Temporarily Removed
	button mvRenameSession "Rename Active Session" width: 260
	)
	
	on mvSession_List selected sel do 
	(
	-- print ("Current Kaldera Session:" + sel as string) use for debug
	if sel == undefined do sel = 1
	SessionMgr.LiteralName = Session_Array[sel]
	SessionMgr.DisplayName = Session_Names[sel]
	SDisplayName = SessionMgr.DisplayName
	KalderaSession (SessionMgr.LiteralName)
	KalderaUpdate (SessionMgr.LiteralName)
	fileIn "KSM_UI_Builder_LT.ms"
	)
	
	on mvSession_List doubleClicked sel do
	(
	-- print ("Current Kaldera Session:" + sel as string) use for debug
	if sel == undefined do sel = 1
	SessionMgr.LiteralName = Session_Array[sel]
	SessionMgr.DisplayName = Session_Names[sel]
	SDisplayName = SessionMgr.DisplayName
	KalderaSession (SessionMgr.LiteralName)
	KalderaUpdate (SessionMgr.LiteralName)
	fileIn "KSM_UI_Builder_LT.ms"
	Select SessionMgr.LiteralName
	)

	on mvCloneSession pressed do 
	(
	copy SessionMgr.LiteralName isSelected:off name:("clone_" + SessionMgr.DisplayName)
	CurrentSelectNum = 1
	mvSessions.mvSession_List.selection = CurrentSelectNum
	FullUpdate()
	)
	
	on mvDeleteSession pressed do 
	(
	delete SessionMgr.LiteralName
	CurrentSelectNum = 1
	mvSessions.mvSession_List.selection = CurrentSelectNum
	CSessionList()
	mvSessions.mvSession_List.items = Session_Names
	)

	on mvRenameSession pressed do
	(
	createDialog rename_rollout 250 50
	)

)
rollout mvTarget_Source "Target and Source" 
(
	
	group "Target Object"
	(
	edittext mvTarget_Display "" text:"Option Disabled" width:145 enabled: false
	pickbutton mvTarget_Picker "Pick Object" pos:[165, 25] width:110 enabled: false
	spinner mvTargetMChannel "Mapping Channel:" range:[0,99,1] pos:[195,50] width:80 type:#integer
	checkbox mvSelFaces_Only "Selected Faces" pos:[15,50] alignment:#right
	spinner mvTargetMatID "" range:[0,250,1] pos:[225,70] width:50 type:#integer enabled: true
	label mvTargetMatLabel "Material ID:" pos:[139,70]
	checkbutton mvTargetMatID_All "All" pos:[198,69] width:25 height:17 
	checkbutton mvTargetVis "Target Visible" pos:[15,70]
	)
	group "Source Objects"
	(
	listbox mvSource_List "" 
	button mvSource_Add "Add" pos:[15,263] width:80 across:3 enabled: false
	button mvSource_Selected "Selected" width:80 enabled: false
	button mvSource_Remove "Remove" width:80 enabled: false
	spinner mvSourceMatID "" range:[0,250,1] pos:[225,288] width:50 type:#integer enabled: false
	label mvSourceMatLabel "Material ID:" pos:[139,288]
	checkbutton mvSourceMatID_All "All" pos:[198,288] width:25 height:17 
	checkbox mvSourceSelFaces_Only "Selected Faces" pos:[15,288]
	checkbox mvSourceHierarchy "Include Heirarchy" pos:[15,308]
	button mvIsolateSource "Isolate Source Objects" width: 270
	)
-- begin controls for Target group
	on mvTargetMChannel entered do 
	(
	SessionMgr.LiteralName.target_map_id = mvTarget_Source.mvTargetMChannel.value
	KalderaUpdate (SessionMgr.LiteralName)
	)
	on mvTargetMatID entered do 
	(
	SessionMgr.LiteralName.target_mat_id = mvTarget_Source.mvTargetMatID.value
	KalderaUpdate (SessionMgr.LiteralName)
	)
	on mvTargetMatID_All changed state do
	(
		SessionMgr.LiteralName.target_mats_all = mvTarget_Source.mvTargetMatID_All.checked
		if mvTarget_Source.mvTargetMatID_All.checked == true do (mvTarget_Source.mvTargetMatID.enabled = false)
		if mvTarget_Source.mvTargetMatID_All.checked == false do (mvTarget_Source.mvTargetMatID.enabled = true)
		KalderaUpdate (SessionMgr.LiteralName)
		fileIn "KSM_UI_Builder_LT.ms"
	)
	on mvSelFaces_Only changed state do 
	(
	SessionMgr.LiteralName.target_selected = mvTarget_Source.mvSelFaces_Only.checked
	KalderaUpdate (SessionMgr.LiteralName)
	)
	on mvTargetVis changed state do 
	(
	SessionMgr.LiteralName.target_render = mvTarget_Source.mvTargetVis.checked
	KalderaUpdate (SessionMgr.LiteralName)
	)

-- Begin Target Select / Display Controls (on hold)

-- Begin Source Controls

	on mvSourceMatID entered do 
	(
	SessionMgr.LiteralName.source_mat_id = mvTarget_Source.mvSourceMatID.value
	KalderaUpdate (SessionMgr.LiteralName)
	)
	on mvSourceSelFaces_Only changed state do 
	(
	SessionMgr.LiteralName.source_selected = mvTarget_Source.mvSourceSelFaces_Only.checked
	KalderaUpdate (SessionMgr.LiteralName)
	)
	on mvSourceHierarchy changed state do 
	(
	SessionMgr.LiteralName.hierarchy = mvTarget_Source.mvSourceHierarchy.checked
	KalderaUpdate (SessionMgr.LiteralName)
	)

	on mvSourceMatID_All changed state do
	(
		SessionMgr.LiteralName.source_mats_all = mvTarget_Source.mvSourceMatID_All.checked
		if mvTarget_Source.mvSourceMatID_All.checked == true do (mvTarget_Source.mvSourceMatID.enabled = false)
		if mvTarget_Source.mvSourceMatID_All.checked == false do (mvTarget_Source.mvSourceMatID.enabled = true)
		KalderaUpdate (SessionMgr.LiteralName)
		fileIn "KSM_UI_Builder_LT.ms"
	)
-- Begin Source Button Controls
	on mvSource_Add pressed do
	(
	)
	on mvSource_Selected pressed do
	(
	Current_Selection = selection
	for i in Current_Selection do
		(
		append SessionMgr.LiteralName.Target_Object i
		)
	KalderaUpdate(SessionMgr.LiteralName)
	)
	on mvIsolateSource pressed do
	(
	clearSelection() 
	max unhide all
	select Source_Array
	max hide inv
	deselect Source_Array
	)

)



-- Begin Core functions

fn FullUpdate =
(
	CSessionList()
	fileIn "KSM_UI_Builder_LT.ms"
	--RebuildUI()
	Initilize_UI()
	--ToolUpdate()
)
fn CSessionList = 
(
	Session_Names = #()
	Session_Array = #()
	THelper_Array = $Helpers as array
	for i in THelper_Array do
	(
	HelperClass = ((classof i) as string) as name
	if HelperClass == #Kaldera_Session do append Session_Array i
	)
	for i in Session_Array do 
	(
	SName = i.name as string
	append Session_Names SName
	)
	mvSessions.mvSession_List.items = Session_Names

)
-- Filename Functions
fn SetSlots =
(
	if outfile != "undefined" then
	(
	outPath = getFilenamePath outfile
	outfileName = getFilenameFile outfile
	outExten = getFilenameType outfile

	mvMaps.mvCompleteMap.caption = (outfileName + "_C" + outExten)
	mvMaps.mvDiffuseMap.caption = (outfileName + "_D" + outExten)
	mvMaps.mvNormalMap.caption = (outfileName + "_N" + outExten)
	mvMaps.mvAlphaMap.caption = (outfileName + "_A" + outExten)
	mvMaps.mvLightingMap.caption = (outfileName + "_L" + outExten)
	mvMaps.mvShadowMap.caption = (outfileName + "_S" + outExten)
	)
	else
	(
	mvMaps.mvBasePath.caption = "Set Base Pathname"
	mvMaps.mvCompleteMap.caption = "Set Base Pathname"
	mvMaps.mvDiffuseMap.caption = "Set Base Pathname"
	mvMaps.mvNormalMap.caption = "Set Base Pathname"
	mvMaps.mvAlphaMap.caption = "Set Base Pathname"
	mvMaps.mvLightingMap.caption = "Set Base Pathname"
	mvMaps.mvShadowMap.caption = "Set Base Pathname"
	)

)
fn Initilize_UI =
(
-- begin Ini pre-fetch
	-- Set UI Values

	mvHelp.open = execute(getIniSetting "$scripts/FEAR/KSM_Preferences.ini" "Rollouts" "help")
	--mvTarget_Source.open = execute(getIniSetting "$scripts/FEAR/KSM_Preferences.ini" "Rollouts" "Target")
	mvMaps.open = execute(getIniSetting "$scripts/FEAR/KSM_Preferences.ini" "Rollouts" "Maps")
	--mvRays.open = execute(getIniSetting "$scripts/FEAR/KSM_Preferences.ini" "Rollouts" "Rays and Hits")
	--mvOutput.open = execute(getIniSetting "$scripts/FEAR/KSM_Preferences.ini" "Rollouts" "output")
	mvRender.open = execute(getIniSetting "$scripts/FEAR/KSM_Preferences.ini" "Rollouts" "render")
	outfile = getIniSetting "$scripts/FEAR/KSM_Preferences.ini" "paths" "outfile"
	mvMaps.mvBasePath.caption = getFilenamePath outfile 
	setSlots()
	mvMaps.mvNormal_Tangent.state = (SessionMgr.LiteralName.normals_space + 1)
	
	if SessionMgr.LiteralName.green_up == true do 
		(
		-- print "Got TRUE" use for debug
		mvMaps.mvNormal_YSpace.state = 1
		)
	if SessionMgr.LiteralName.green_up == false do
		(
		-- print "Got False" use for debug
		mvMaps.mvNormal_YSpace.state = 2
		)
	mvMaps.mvCompleteRenderCheck.checked = execute(getIniSetting "$scripts/FEAR/KSM_Preferences.ini" "RenderSet" "complete")
	mvMaps.mvDiffuseRenderCheck.checked = execute(getIniSetting "$scripts/FEAR/KSM_Preferences.ini" "RenderSet" "Diffuse")
	mvMaps.mvNormalRenderCheck.checked = execute(getIniSetting "$scripts/FEAR/KSM_Preferences.ini" "RenderSet" "Normal")
	mvMaps.mvAlphaRenderCheck.checked = execute(getIniSetting "$scripts/FEAR/KSM_Preferences.ini" "RenderSet" "Alpha")
	mvMaps.mvLightingRenderCheck.checked = execute(getIniSetting "$scripts/FEAR/KSM_Preferences.ini" "RenderSet" "Lighting")
	mvMaps.mvShadowRenderCheck.checked = execute(getIniSetting "$scripts/FEAR/KSM_Preferences.ini" "RenderSet" "shadow")
	mvRender.mvCompositeDo.checked = execute(getIniSetting "$scripts/FEAR/KSM_Preferences.ini" "RenderOptions" "Composite") 
	mvRender.mvUseGlobal.checked = execute(getIniSetting "$scripts/FEAR/KSM_Preferences.ini" "RenderOptions" "Global")	
	
	if mvRender.mvCompositeDo.checked == true do (mvRender.mvDeleteSourceDO.enabled = true)
	if mvRender.mvCompositeDo.checked == false do (mvRender.mvDeleteSourceDO.enabled = false)

-- end Ini pre-fetch
	
	kalderaStart(SessionMgr.LiteralName)
	kalderaUpdate(SessionMgr.LiteralName)

-- Set Callback

	callbacks.addScript #filePostOpen "resetPathVal()" id:#KSMOpen 
)
fn resetPathVal =
(
-- Reset Path Dir
	
	outfile = "undefined"
	setIniSetting "$scripts/FEAR/KSM_Preferences.ini" "paths" "outfile" (outfile as string)
	SetSlots()
		Session_Names = #()
		Session_Array = #()
		Source_Names = #()
		Source_Array = #()
		Render_Array =#()

-- messagebox "Base Pathname has been reset!" title: "Notification:"

-- Reset Arrays and re - Init the UI

	fileIn "KSM_UI_Builder_LT.ms"
)
	if SessionFloater != undefined then (closeRolloutFloater SessionFloater)
	
	
	SessionFloater = newRolloutFloater "Kaldera Session Manager LT v1.01" 300 800 

	addRollout mvHelp SessionFloater
	addRollout mvConfig SessionFloater
	addRollout mvSessions SessionFloater
	--addRollout mvTarget_Source SessionFloater
	addRollout mvMaps SessionFloater
	--addRollout mvRays SessionFloater
	--addRollout mvOutput SessionFloater
	addRollout mvRender SessionFloater
	
utility utl_Session_Controller "Kaldera Session Manager LT v1.01" width:162 height:156
(
	label aboutme01 "for Support email:"
	label aboutme02 "kevind@lith.com"  width:86 height:13
)
-- Initilizes the UI Interface and sets arrays for start

CSessionList()
fileIn "KSM_UI_Builder_LT.ms"
Initilize_UI()
fileIn "KSM_StoreUI.ms"

-- Clause to Shut down callback when floater is not open

-- callbacks.broadcastCallback #filePostOpen