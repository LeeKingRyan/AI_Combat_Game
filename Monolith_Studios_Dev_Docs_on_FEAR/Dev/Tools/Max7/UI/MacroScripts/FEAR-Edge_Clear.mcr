--	Edge_Clear macro v1.0
--
--	Usage:  Utilizes auto edge w/ thresh of 1 to clear planer edges from selection set.
--
--	Written by Kevin Deadrick (Monolith) for F.E.A.R. project development.


macroScript Edge_Clear category:"FEAR" buttonText: "Edge Clear"
(
on isEnabled return selection.count > 0

on execute do
(

fn clearEdges threshold=
(

DebugMode = true

if DebugMode == true do (print selection.count)

-- store selection array
selArray = getCurrentSelection()

-- begin process
for i in selArray do
	(
	select i
	convertToMesh i -- Converts to Edit Mesh for meshops
--	i.allEdges = true
	select i
	max modify mode
	subObjectLevel = 2
	edgeSelSet=#()
	
-- Establish Edge List

	for face = 1 to i.numfaces do
		(
		for edge = 1 to 3 do
			(
			if (getedgevis i face edge) do (append edgeSelSet (((face-1)*3)+edge))
			)
		)
		
	setedgeselection i edgeSelSet

-- Use Auto Edge thresh 1.0

	meshop.autoedge i edgeSelSet threshold type: #SetClear

	if DebugMode == true do (print ("Operation complete on" + i.name))

	subObjectLevel = 0
2
	)

-- restore selection array

select selArray
)

-- define modal dialog rollout

rollout tRollout "Set Edge Threshold"
(
	spinner edgeThresh_spinner "Threshold: " range:[0.0,180.0,45.0] type: #float fieldWidth: 60 align: #center
	button setEdgeThresh "OK" width: 120 offset: [5,0] align: #center

	on setEdgeThresh pressed do
	(
	destroyDialog(tRollout)
	)
)

CreateDialog tRollout [125,64,0,0] escapeEnable: false style: #(#style_border,#style_sunkenedge,#style_toolwindow) modal: true

clearEdges(tRollout.edgeThresh_spinner.value)

-- print ("edge threshold reads:" + tRollout.edgeThresh_spinner.value as string)

)) -- End Macroscript
