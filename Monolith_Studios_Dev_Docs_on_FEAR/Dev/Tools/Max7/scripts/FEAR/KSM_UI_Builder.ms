fn UpdateSource_Array =
(
	mvTarget_Source.mvSource_List.items = #()
	Source_Names = #()
	Source_Array = SessionMgr.LiteralName.source_objects as array
	for i in Source_Array do
	(
	if i != undefined then
		(
		SourceName = i.name
		)
	else
		(
		SourceName = "[Deleted Node]"
		)
	append Source_Names SourceName
	mvTarget_Source.mvSource_List.items = Source_Names
	
	)
)
fn UpdateSessionList =
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
fn MakeSelection =
(
	
	CurrentSelectNum = mvSessions.mvSession_List.selection
	print CurrentSelectNum
	if CurrentSelectNum == undefined do CurrentSelectNum = 1
	SessionMgr.LiteralName = Session_Array[CurrentSelectNum]
	print SessionMgr.LiteralName
	SessionMgr.DisplayName = Session_Names[CurrentSelectNum]
	print SessionMgr.DisplayName
	SDisplayName = SessionMgr.DisplayName
)
fn ToolUpdate =
(
-- SessionMgr.LiteralName (Current Session Variable)
	-- Create Some local variables
	local Trend_lock = SessionMgr.LiteralName.rend_lock
	local Trend_width = SessionMgr.LiteralName.rend_width
	local Trend_height = SessionMgr.LiteralName.rend_height
	local Tcrop = SessionMgr.LiteralName.crop_alpha
	local TAlias = SessionMgr.LiteralName.antialiasing
	local TSkirt = SessionMgr.LiteralName.prefiltering
	local TRayOffset = SessionMgr.LiteralName.ray_offset
	local TRayLength = SessionMgr.LiteralName.ray_length
	local TRayLengthEnable = SessionMgr.LiteralName.use_ray_length
	local TTargetMC = SessionMgr.LiteralName.target_map_id
	local TTargetAll = SessionMgr.LiteralName.target_mats_all
	local TTargetMatID = SessionMgr.LiteralName.target_mat_id
	local TTargetSel = SessionMgr.LiteralName.target_selected
	local TargetVis = SessionMgr.LiteralName.target_render
	local sourceMatID = SessionMgr.LiteralName.source_mat_id
	local sourceMatIDALL = SessionMgr.LiteralName.source_mats_all
	local sourceHeirarchy = SessionMgr.LiteralName.hierarchy
	local sourceSelFaces = SessionMgr.LiteralName.source_selected


-- begin setting of output rollout
	mvOutput.mvWidth.value = Trend_width
	mvOutput.mvHeight.value = Trend_height
	mvOutput.mvConstrainAspect.checked = Trend_lock
	mvOutput.mvPFilter.value = TAlias
	mvOutput.mvSFilter.value = TSkirt
	mvOutput.mvCropAlpha.checked = Tcrop
-- begin setting of Ray rollout
	mvRays.mvRayOffset.value = TRayOffset
	mvRays.mvRaylength.value = TRayLength
	mvRays.mvRayLengthEnable.checked = TRayLengthEnable
	if mvRays.mvRayLengthEnable.checked == true do mvRays.mvRaylength.enabled = true
	mvRays.mvHitResolve.state = (SessionMgr.LiteralName.hit_resolve + 1)
-- begin setting of Target rollout
	mvTarget_Source.mvTargetMChannel.value = TTargetMC
	mvTarget_Source.mvTargetMatID_All.checked = TTargetAll
	mvTarget_Source.mvTargetMatID.value = (TTargetMatID + 1)
	mvTarget_Source.mvSelFaces_Only.checked = TTargetSel
	mvTarget_Source.mvTargetVis.checked = TargetVis
	if TTargetAll == true do mvTarget_Source.mvTargetMatID.enabled = false
	if TTargetAll == false do mvTarget_Source.mvTargetMatID.enabled = true
-- begin setting of Source rollout
	mvTarget_Source.mvSourceMatID.value = (sourceMatID + 1)
	mvTarget_Source.mvSourceMatID_All.checked = sourceMatIDALL
	mvTarget_Source.mvSourceHierarchy.checked = sourceHeirarchy
	mvTarget_Source.mvSourceSelFaces_Only.checked = sourceSelFaces
	if sourceMatIDALL == true do mvTarget_Source.mvSourceMatID.enabled = false
	if sourceMatIDALL == false do mvTarget_Source.mvSourceMatID.enabled = true

	mvSessions.mvRenameSession.caption = ("Active Session :  " + SessionMgr.DisplayName)

-- begin setting of Render Rollout

	if mvRender.mvCompositeDo.checked == true do (mvRender.mvDeleteSourceDO.enabled = true)
	if mvRender.mvCompositeDo.checked == false do (mvRender.mvDeleteSourceDO.enabled = false)

-- update Position
	
	--local LastPos = execute(getIniSetting "$scripts/FEAR/KSM_Preferences.ini" "General" "DialogPos")
	--SessionFloater.pos = LastPos

-- SessionMgr UI Initialized

	KalderaUpdate(SessionMgr.LiteralName)
)
fn RebuildCustomRenderList = 
(
	if Render_Array != undefined do
	(
	Render_Names = #()
	for i in Render_Array do 
	(
	RListName = i.name
	append Render_Names RListName
	)
	mvRender.mvRenderList.items = Render_Names
	)
)
UpdateSessionList()
MakeSelection()
ToolUpdate()
UpdateSource_Array()
RebuildCustomRenderList()
