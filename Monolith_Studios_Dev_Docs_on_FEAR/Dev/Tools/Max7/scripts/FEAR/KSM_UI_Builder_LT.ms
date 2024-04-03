
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
RebuildCustomRenderList()
