--	Export Attributes v1.1
--
--
--	Written by Kevin Deadrick (Monolith) for F.E.A.R. project development.
-- 
--	v1.0 RELEASE
--
--	Script adds custom attributes to selected poly object.  These Attributes are used by FEAR-BatchExport.mcr macro.
--
--	Use FEAR-BatchExport_CA.mcr to apply attributes.
--
--	v1.1
--	Added improved error handeling
--	Fixed bug that allowed assigning of Multiple Attributes to single object
--	Fixed bug that allowed assigning of attributes to non-Geometry class objects
--	Fixed Critical Error in filepath setting.  Added Error Handling.
--

ExportPathCA = attributes ExportInfo -- Begin Attribute Definition
(

parameters ExportInfo rollout: FE_Export 
	(

	ExportPath type: #filename
	OutDisplay type: #string ui: FE_Pathname
	includeExport type: #boolean ui: FE_Include
	Weld_Points type: #boolean ui: FE_WeldPoints
	)

rollout FE_Export "Export Information"
(
	group "File Options: "
	(
	label FE_PathLabel "Output File: " align: #left offset: [2,0]
	edittext FE_Pathname width: 135 enabled: false
	button FE_PathSelect "Set Path" width: 135
	checkbox FE_Include "Include in Export" align: #left offset: [2,0]
	)
	group "Brush Options: "
	(
	checkbox FE_WeldPoints "Weld Redundant Points" align: #left offset: [2,0]
	)
	
	on FE_PathSelect pressed do
	(
	local outfile = undefined
	try outfile = getsavefilename types: "Fear World (*.world00c)|*.world00c|"
	catch
		(
		messagebox "Script Encountered Error during setfile process!" title: "Critical Error!" beep: true
		print "Unable to establish savefile"
		)
	if outfile != undefined do
		(

		outPath = getFilenamePath outfile
		outfileName = getFilenameFile outfile
		outExten = getFilenameType outfile
		
		OutDisplay = (" ...\ " + outfileName as string + outExten as string)

		FE_Export.FE_Pathname.text = OutDisplay
		
		ExportPath = outfile -- Set / Store the Export path and filename
		if FEDebug == true do (print ExportPath)
		
		)
	)

)
)

for i in selection do
(
	
	AttributeCount = custAttributes.count i	
	if AttributeCount == 0 do
	(
	if superclassof i == GeometryClass do
		(
		custAttributes.add i ExportPathCA -- Actually adds the Attributes
		)
	)
)