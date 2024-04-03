fn Composite_C = 
(
	outPath = getFilenamePath outfile
	outfileName = getFilenameFile outfile
	outExten = getFilenameType outfile

BaseColor = color 0 0 0 0

	try Refmap = openBitmap Outfile_C[1]

	catch 
	(
	messagebox "Failed to Open Composite_C Map" title: "Critical Error" beep: true
	return 0
	)

	bitmapOut_C = bitmap Refmap.width Refmap.height color: BaseColor
	bitmapOut_C.filename = (outPath + outfileName + "_C" + outExten)

	close Refmap

for i in Outfile_C do
(
	try bitmap1 = openBitMap i
	
	catch
	(
	messagebox "Failed to Open Component map!" title: "Critical Error" beep: true
	return 0
	)

	for y in 1 to bitmap1.height do
	for x in 1 to bitmap1.width do
	(
	PixelColor = (getpixels bitmap1 [x-1,y-1] 1)[1]

		
		if PixelColor.alpha == 255 do
		(
		OutColor = color PixelColor.r PixelColor.g PixelColor.b
		OutColor.alpha = 255
		setpixels bitmapOut_C [x,y] #(OutColor)
		)
	)
	
close bitmap1
)
save bitmapOut_C
gc()
print "Complete Map Composited!"
)
fn Composite_D = 
(
	outPath = getFilenamePath outfile
	outfileName = getFilenameFile outfile
	outExten = getFilenameType outfile

BaseColor = color 0 0 0 0
	
	try Refmap = openBitmap Outfile_D[1]

	catch 
	(
	messagebox "Failed to Open Composite_D Map" title: "Critical Error" beep: true
	return 0
	)
	
	bitmapOut_D = bitmap Refmap.width Refmap.height color: BaseColor
	bitmapOut_D.filename = (outPath + outfileName + "_D" + outExten)

	close Refmap
	
for i in Outfile_D do
(
	try bitmap1 = openBitMap i
	
	catch
	(
	messagebox "Failed to Open Component map!" title: "Critical Error" beep: true
	return 0
	)

	for y in 1 to bitmap1.height do
	for x in 1 to bitmap1.width do
	(
	PixelColor = (getpixels bitmap1 [x-1,y-1] 1)[1]

		
		if PixelColor.alpha == 255 do
		(
		OutColor = color PixelColor.r PixelColor.g PixelColor.b
		OutColor.alpha = 255
		setpixels bitmapOut_D [x,y] #(OutColor)
		)
	)
close bitmap1
)
save bitmapOut_D
gc()
print "Diffuse Map Composited!"
)
fn Composite_N = 
(
	outPath = getFilenamePath outfile
	outfileName = getFilenameFile outfile
	outExten = getFilenameType outfile

BaseColor = color 0 0 0 0

	try Refmap = openBitmap Outfile_N[1]

	catch 
	(
	messagebox "Failed to Open Composite_N Map" title: "Critical Error" beep: true
	return 0
	)
	
	bitmapOut_N = bitmap Refmap.width Refmap.height color: BaseColor
	bitmapOut_N.filename = (outPath + outfileName + "_N" + outExten)

	close Refmap

for i in Outfile_N do
(
	try bitmap1 = openBitMap i
	
	catch
	(
	messagebox "Failed to Open Component map!" title: "Critical Error" beep: true
	return 0
	)

	for y in 1 to bitmap1.height do
	for x in 1 to bitmap1.width do
	(
	PixelColor = (getpixels bitmap1 [x-1,y-1] 1)[1]

		
		if PixelColor.alpha == 255 do
		(
		OutColor = color PixelColor.r PixelColor.g PixelColor.b
		OutColor.alpha = 255
		setpixels bitmapOut_N [x,y] #(OutColor)
		)
	)
close bitmap1
)
save bitmapOut_N
gc()
print "Normals Map Composited!"
)
fn Composite_A = 
(
	outPath = getFilenamePath outfile
	outfileName = getFilenameFile outfile
	outExten = getFilenameType outfile

BaseColor = color 0 0 0 0

	try Refmap = openBitmap Outfile_A[1]

	catch 
	(
	messagebox "Failed to Open Composite_A Map" title: "Critical Error" beep: true
	return 0
	)

	bitmapOut_A = bitmap Refmap.width Refmap.height color: BaseColor
	bitmapOut_A.filename = (outPath + outfileName + "_A" + outExten)

	close Refmap

for i in Outfile_A do
(
	try bitmap1 = openBitMap i
	
	catch
	(
	messagebox "Failed to Open Component map!" title: "Critical Error" beep: true
	return 0
	)

	for y in 1 to bitmap1.height do
	for x in 1 to bitmap1.width do
	(
	PixelColor = (getpixels bitmap1 [x-1,y-1] 1)[1]

		
		if PixelColor.alpha == 255 do
		(
		OutColor = color PixelColor.r PixelColor.g PixelColor.b
		OutColor.alpha = 255
		setpixels bitmapOut_A [x,y] #(OutColor)
		)
	)
	close bitmap1
)
save bitmapOut_A
gc()
print "Alpha Map Composited!"
)
fn Composite_L = 
(
	outPath = getFilenamePath outfile
	outfileName = getFilenameFile outfile
	outExten = getFilenameType outfile

BaseColor = color 0 0 0 0

	try Refmap = openBitmap Outfile_L[1]

	catch 
	(
	messagebox "Failed to Open Composite_L Map" title: "Critical Error" beep: true
	return 0
	)

	bitmapOut_L = bitmap Refmap.width Refmap.height color: BaseColor
	bitmapOut_L.filename = (outPath + outfileName + "_L" + outExten)

	close Refmap
	

for i in Outfile_L do
(
	try bitmap1 = openBitMap i
	
	catch
	(
	messagebox "Failed to Open Component map!" title: "Critical Error" beep: true
	return 0
	)

	for y in 1 to bitmap1.height do
	for x in 1 to bitmap1.width do
	(
	PixelColor = (getpixels bitmap1 [x-1,y-1] 1)[1]

		
		if PixelColor.alpha == 255 do
		(
		OutColor = color PixelColor.r PixelColor.g PixelColor.b
		OutColor.alpha = 255
		setpixels bitmapOut_L [x,y] #(OutColor)
		)
	)
	close bitmap1
)
save bitmapOut_L
gc()
print "Lighting Map Composited!"
)
fn Composite_S = 
(
	outPath = getFilenamePath outfile
	outfileName = getFilenameFile outfile
	outExten = getFilenameType outfile

BaseColor = color 0 0 0 0

	try Refmap = openBitmap Outfile_S[1]

	catch 
	(
	messagebox "Failed to Open Composite_S Map" title: "Critical Error" beep: true
	return 0
	)

	bitmapOut_S = bitmap Refmap.width Refmap.height color: BaseColor
	bitmapOut_S.filename = (outPath + outfileName + "_S" + outExten)

	close Refmap
	
for i in Outfile_S do
(
	try bitmap1 = openBitMap i
	
	catch
	(
	messagebox "Failed to Open Component map!" title: "Critical Error" beep: true
	return 0
	)

	for y in 1 to bitmap1.height do
	for x in 1 to bitmap1.width do
	(
	PixelColor = (getpixels bitmap1 [x-1,y-1] 1)[1]

		
		if PixelColor.alpha == 255 do
		(
		OutColor = color PixelColor.r PixelColor.g PixelColor.b
		OutColor.alpha = 255
		setpixels bitmapOut_S [x,y] #(OutColor)
		)
	)
	close bitmap1
)
save bitmapOut_S
gc()
print "Shadow Map Composited!"
)

fn Composite_H = 
(
	outPath = getFilenamePath outfile
	outfileName = getFilenameFile outfile
	outExten = getFilenameType outfile

BaseColor = color 0 0 0 0

	try Refmap = openBitmap Outfile_H[1]

	catch 
	(
	messagebox "Failed to Open Composite_H Map" title: "Critical Error" beep: true
	return 0
	)

	bitmapOut_H = bitmap Refmap.width Refmap.height color: BaseColor
	bitmapOut_H.filename = (outPath + outfileName + "_H" + outExten)

	close Refmap
	

for i in Outfile_H do
(
	try bitmap1 = openBitMap i
	
	catch
	(
	messagebox "Failed to Open Component map!" title: "Critical Error" beep: true
	return 0
	)

	for y in 1 to bitmap1.height do
	for x in 1 to bitmap1.width do
	(
	PixelColor = (getpixels bitmap1 [x-1,y-1] 1)[1]

		
		if PixelColor.alpha == 255 do
		(
		OutColor = color PixelColor.r PixelColor.g PixelColor.b
		OutColor.alpha = 255
		setpixels bitmapOut_H [x,y] #(OutColor)
		)
	)
close bitmap1
	
)
save bitmapOut_H
gc()
print "Height Map Composited!"
)

fn RenderActive =
(
	outPath = getFilenamePath outfile
	outfileName = getFilenameFile outfile
	outExten = getFilenameType outfile

	ExtCheck = #("C","D","N","L","S","H")
	for i in ExtCheck do
	(
	if doesFileExist (outpath + outfileName + "_" + i + outExten) == true do
		(
		if querybox "Outfile(s) already exist.  Continue with Render Process?" title: "Warning!" then
			(
			print "Continuing with Render Process"
			exit
			)
			else
			(
			print "User Aborted Rendering Process"
			return 0
			)
		)
	)
	max unhide all
	kalderaStart (SessionMgr.LiteralName)
	CurrentSession = SessionMgr.LiteralName
	outPath = getFilenamePath outfile
	outfileName = getFilenameFile outfile
	outExten = getFilenameType outfile

	if mvMaps.mvLightingRenderCheck.checked == true do
	(
	if mvRender.mvUseGlobal.checked == true do
		(
		Sky_Color = mvRender.mvGlobalColor.color
		Sky_Light = Skylight name: "Global" position:[0,0,50] color: Sky_Color
		sceneradiosity.radiosity = Light_Tracer()
		)
	)

-- Clear out / override Kaldera Panel 
	
	SessionMgr.LiteralName.save_complete = false
	SessionMgr.LiteralName.view_complete = false
	CurrentSession.name_complete = "Set File Name"
	SessionMgr.LiteralName.save_diffuse = false
	SessionMgr.LiteralName.view_diffuse = false
	CurrentSession.name_diffuse = "Set File Name"
	SessionMgr.LiteralName.save_normals = false
	SessionMgr.LiteralName.view_normals = false
	CurrentSession.name_normals = "Set File Name"
	SessionMgr.LiteralName.save_alpha = false
	SessionMgr.LiteralName.view_alpha = false
	CurrentSession.name_alpha = "Set File Name"
	SessionMgr.LiteralName.save_lighting = false
	SessionMgr.LiteralName.view_lighting = false
	CurrentSession.name_lighting = "Set File Name"
	SessionMgr.LiteralName.save_shadow = false
	SessionMgr.LiteralName.view_shadow = false
	CurrentSession.name_shadow = "Set File Name"
	SessionMgr.LiteralName.save_heights = false
	SessionMgr.LiteralName.view_heights = false
	CurrentSession.name_heights = "Set File Name"

-- Check for Base Path

		if outfile != undefined do
		(
-- Check for and setup necessary map slots

		if mvMaps.mvCompleteRenderCheck.checked == true do
			(
			CurrentSession.save_complete = true
			CurrentSession.view_complete = true
			CurrentSession.name_complete = (outPath + outfileName + "_" + SDisplayName + "_C" + outExten)
			KalderaUpdate (SessionMgr.LiteralName)
			)
		
		if mvMaps.mvDiffuseRenderCheck.checked == true do
			(
			CurrentSession.save_diffuse = true
			CurrentSession.view_diffuse = false
			CurrentSession.name_diffuse = (outPath + outfileName + "_" + SDisplayName + "_D" + outExten)
			KalderaUpdate (SessionMgr.LiteralName)
			)
		
		if mvMaps.mvNormalRenderCheck.checked == true do
			(
			CurrentSession.save_normals = true
			CurrentSession.view_normals = false
			CurrentSession.name_normals = (outPath + outfileName + "_" + SDisplayName + "_N" + outExten)
			KalderaUpdate (SessionMgr.LiteralName)
			if mvMaps.mvNormal_Tangent.state == 1 then
				(
				CurrentSession.normals_space = 0
				)
				else
				(
				CurrentSession.normals_space = 1 
				)
			if mvMaps.mvNormal_YSpace.state == 1 then
				(
				CurrentSession.green_up = false
				)
				else
				(
				CurrentSession.green_up = true
				)
			)
		if mvMaps.mvAlphaRenderCheck.checked == true do 
			(
			CurrentSession.save_alpha = true
			CurrentSession.view_alpha = false
			CurrentSession.name_alpha = (outPath + outfileName + "_" + SDisplayName + "_A" + outExten)
			KalderaUpdate (SessionMgr.LiteralName)
			)
		if mvMaps.mvLightingRenderCheck.checked == true do 
			(
			CurrentSession.save_lighting = true
			CurrentSession.view_lighting = false
			CurrentSession.name_lighting = (outPath + outfileName + "_" + SDisplayName + "_L" + outExten)
			KalderaUpdate (SessionMgr.LiteralName)
			)
		
		if mvMaps.mvShadowRenderCheck.checked == true do
			(
			CurrentSession.save_shadow = true
			CurrentSession.view_shadow = false
			CurrentSession.name_shadow = (outPath + outfileName + "_" + SDisplayName + "_S" + outExten)
			KalderaUpdate (SessionMgr.LiteralName)
			)
		if mvMaps.mvHeightRenderCheck.checked == true do
			(
			CurrentSession.save_heights = true
			CurrentSession.view_heights = false
			CurrentSession.name_heights = (outPath + outfileName + "_" + SDisplayName + "_H" + outExten)
			KalderaUpdate (SessionMgr.LiteralName)
			)
		
		)
-- Map Setup Complete... Start your Render
		
		print "Rendering Current Session"
		kalderaRender CurrentSession
		KalderaUpdate (SessionMgr.LiteralName)
		if mvMaps.mvLightingRenderCheck.checked == true do
		(
		if mvRender.mvUseGlobal.checked == true do
			(
			sceneradiosity.radiosity = undefined
			delete Sky_Light
			)
		)
)
fn RenderAll = 
(
	outPath = getFilenamePath outfile
	outfileName = getFilenameFile outfile
	outExten = getFilenameType outfile

	ExtCheck = #("C","D","N","L","S","H")
	for i in ExtCheck do
	(
	if doesFileExist (outpath + outfileName + "_" + i + outExten) == true do
		(
		if querybox "Outfile(s) already exist.  Continue with Render Process?" title: "Warning!" then
			(
			print "Continuing with Render Process"
			exit
			)
			else
			(
			print "User Aborted Rendering Process"
			return 0
			)
		)
	)
	max unhide all
	kalderaStart (SessionMgr.LiteralName)

-- Clear out the File Arrays
		
		Outfile_C = #()
		Outfile_D = #()
		Outfile_N = #()
		Outfile_A = #()
		Outfile_L = #()
		Outfile_S = #()
		Outfile_H = #()

-- Begin Render Loop

	local SessionCount = 0
for i in Session_Array do
	(
	SessionCount += 1
	mvRender.mvRenderProgress.value = 100.0*SessionCount/Session_Array.count
	
	CurrentSession = i
	outPath = getFilenamePath outfile
	outfileName = getFilenameFile outfile
	outExten = getFilenameType outfile
	
	if mvMaps.mvLightingRenderCheck.checked == true do
	(
	if mvRender.mvUseGlobal.checked == true do
		(
		Sky_Color = mvRender.mvGlobalColor.color
		Sky_Light = Skylight name: "Global" position:[0,0,50] color: Sky_Color
		sceneradiosity.radiosity = Light_Tracer()
		)
	)

	KalderaSession (CurrentSession)
-- Clear out / override Kaldera Panel 
	
	CurrentSession.save_complete = false
	CurrentSession.view_complete = false
	CurrentSession.name_complete = "Set File Name"
	CurrentSession.save_diffuse = false
	CurrentSession.view_diffuse = false
	CurrentSession.name_diffuse = "Set File Name"
	CurrentSession.save_normals = false
	CurrentSession.view_normals = false
	CurrentSession.name_normals = "Set File Name"
	CurrentSession.save_alpha = false
	CurrentSession.view_alpha = false
	CurrentSession.name_alpha = "Set File Name"
	CurrentSession.save_lighting = false
	CurrentSession.view_lighting = false
	CurrentSession.name_lighting = "Set File Name"
	CurrentSession.save_shadow = false
	CurrentSession.view_shadow = false
	CurrentSession.name_shadow = "Set File Name"
	SessionMgr.LiteralName.view_heights = false
	CurrentSession.name_heights = "Set File Name"

-- Check for Base Path

		if outfile != undefined do
		(
-- Check for and setup necessary map slots

		if mvMaps.mvCompleteRenderCheck.checked == true do
			(
			CurrentSession.save_complete = true
			CurrentSession.view_complete = true
			CurrentSession.name_complete = (outPath + outfileName + "_" + i.name + "_C" + outExten)
			KalderaUpdate (CurrentSession)
			append Outfile_C CurrentSession.name_complete
			)
		
		if mvMaps.mvDiffuseRenderCheck.checked == true do
			(
			CurrentSession.save_diffuse = true
			CurrentSession.view_diffuse = false
			CurrentSession.name_diffuse = (outPath + outfileName + "_" + i.name + "_D" + outExten)
			KalderaUpdate (CurrentSession)
			append Outfile_D CurrentSession.name_diffuse
			)
		
		if mvMaps.mvNormalRenderCheck.checked == true do
			(
			CurrentSession.save_normals = true
			CurrentSession.view_normals = false
			CurrentSession.name_normals = (outPath + outfileName + "_" + i.name + "_N" + outExten)
			KalderaUpdate (CurrentSession)
			append Outfile_N CurrentSession.name_normals
			if mvMaps.mvNormal_Tangent.state == 1 then
				(
				CurrentSession.normals_space = 0
				)
				else
				(
				CurrentSession.normals_space = 1 
				)
			if mvMaps.mvNormal_YSpace.state == 1 then
				(
				CurrentSession.green_up = false
				)
				else
				(
				CurrentSession.green_up = true
				)
			)
		if mvMaps.mvAlphaRenderCheck.checked == true do 
			(
			CurrentSession.save_alpha = true
			CurrentSession.view_alpha = false
			CurrentSession.name_alpha = (outPath + outfileName + "_" + i.name + "_A" + outExten)
			KalderaUpdate (CurrentSession)
			append Outfile_A CurrentSession.name_alpha
			)
		if mvMaps.mvLightingRenderCheck.checked == true do 
			(
			CurrentSession.save_lighting = true
			CurrentSession.view_lighting = false
			CurrentSession.name_lighting = (outPath + outfileName + "_" + i.name + "_L" + outExten)
			KalderaUpdate (CurrentSession)
			append Outfile_L CurrentSession.name_lighting
			)
		
		if mvMaps.mvShadowRenderCheck.checked == true do
			(
			CurrentSession.save_shadow = true
			CurrentSession.view_shadow = false
			CurrentSession.name_shadow = (outPath + outfileName + "_" + i.name + "_S" + outExten)
			KalderaUpdate (CurrentSession)
			append Outfile_S CurrentSession.name_shadow	
			)
		if mvMaps.mvHeightRenderCheck.checked == true do
			(
			CurrentSession.save_heights = true
			CurrentSession.view_heights = false
			CurrentSession.name_heights = (outPath + outfileName + "_" + i.name + "_H" + outExten)
			KalderaUpdate (CurrentSession)
			append Outfile_H CurrentSession.name_heights	
			)
		
		)
-- Map Setup Complete... Start your Render
	
		print "Rendering Current Session"

		kalderaRender CurrentSession
		KalderaUpdate (CurrentSession)

		if mvMaps.mvLightingRenderCheck.checked == true do
		(
		if mvRender.mvUseGlobal.checked == true do
			(
			sceneradiosity.radiosity = undefined
			delete Sky_Light
			)
		)
	)

-- Refresh UI
	
	KalderaSession (SessionMgr.LiteralName)
	KalderaUpdate (SessionMgr.LiteralName)
		
-- Composit the Bitmap if asked to

	if mvRender.mvCompositeDO.checked == true do 
		(
		print "Compositing Final Maps!"
-- Reset Progress bar for composite tracking

		totalComposite = (Outfile_C.count + Outfile_D.count + Outfile_N.count + Outfile_A.count + Outfile_L.count + Outfile_S.count + Outfile_H.count)
		SessionCount = 0
		mvRender.mvRenderProgress.value = 100.0*SessionCount/totalComposite
		
-- Begin Composite Process

		if mvMaps.mvCompleteRenderCheck.checked == true do (Composite_C())
		SessionCount += 1
		mvRender.mvRenderProgress.value = 100.0*SessionCount/totalComposite
		if mvMaps.mvDiffuseRenderCheck.checked == true do (Composite_D())
		SessionCount += 1
		mvRender.mvRenderProgress.value = 100.0*SessionCount/totalComposite
		if mvMaps.mvNormalRenderCheck.checked == true do (Composite_N())
		SessionCount += 1
		mvRender.mvRenderProgress.value = 100.0*SessionCount/totalComposite
		if mvMaps.mvAlphaRenderCheck.checked == true do (Composite_A())
		SessionCount += 1
		mvRender.mvRenderProgress.value = 100.0*SessionCount/totalComposite
		if mvMaps.mvLightingRenderCheck.checked == true do (Composite_L())
		SessionCount += 1
		mvRender.mvRenderProgress.value = 100.0*SessionCount/totalComposite		
		if mvMaps.mvShadowRenderCheck.checked == true do (Composite_S())
		SessionCount += 1
		mvRender.mvRenderProgress.value = 100.0*SessionCount/totalComposite
		if mvMaps.mvHeightRenderCheck.checked == true do (Composite_H())
		SessionCount += 1
		mvRender.mvRenderProgress.value = 100.0*SessionCount/totalComposite
		print "Bitmaps have been created"

-- Clean up if asked to
			if mvRender.mvDeleteSourceDO.checked == true do
			(
			ComponentArray = #(Outfile_C,Outfile_D,Outfile_N,Outfile_A,Outfile_L,Outfile_S,Outfile_H)
				for item in ComponentArray do
				(
				if item != undefined do 
					(
					for i in item do 
						(
						try deleteFile  i
						catch 
							(
							messagebox "Error Deleting Component Map!" title: "Critical Error" beep: true
							print "Unable To Delete Component Maps!"
							return 0
							)
						)
					)
				)	
			)
		)
	

-- Clear the progress bar

	SessionCount = 0
	mvRender.mvRenderProgress.value = 100.0*SessionCount/Session_Array.count
)
fn RenderCustom =
(
	outPath = getFilenamePath outfile
	outfileName = getFilenameFile outfile
	outExten = getFilenameType outfile

	ExtCheck = #("C","D","N","L","S","H")
	for i in ExtCheck do
	(
	if doesFileExist (outpath + outfileName + "_" + i + outExten) == true do
		(
		if querybox "Outfile(s) already exist.  Continue with Render Process?" title: "Warning!" then
			(
			print "Continuing with Render Process"
			exit
			)
			else
			(
			print "User Aborted Rendering Process"
			return 0
			)
		)
	)
	
	max unhide all
	kalderaStart (SessionMgr.LiteralName)
	if Render_Array.count == 0 then 
	(
	messagebox "Please build a custom render list first!  " title: "Alert!"
	)

	else
	(
		
-- Clear out the File Arrays
	
	Outfile_C = #()
	Outfile_D = #()
	Outfile_N = #()
	Outfile_A = #()
	Outfile_L = #()
	Outfile_S = #()
	Outfile_H = #()

	print Outfile_C
	print Outfile_C.count

-- Begin Render Loop

	local SessionCount = 0
	for i in Render_Array do
		(
		SessionCount += 1
		mvRender.mvRenderProgress.value = 100.0*SessionCount/Render_Array.count
		
		CurrentSession = i
		outPath = getFilenamePath outfile
		outfileName = getFilenameFile outfile
		outExten = getFilenameType outfile
		
		KalderaSession (CurrentSession)

	if mvMaps.mvLightingRenderCheck.checked == true do
	(
	if mvRender.mvUseGlobal.checked == true do
		(
		Sky_Color = mvRender.mvGlobalColor.color
		Sky_Light = Skylight name: "Global" position:[0,0,50] color: Sky_Color
		sceneradiosity.radiosity = Light_Tracer()
		)
	)
	-- Clear out / override Kaldera Panel 
		
		CurrentSession.save_complete = false
		CurrentSession.view_complete = false
		CurrentSession.name_complete = "Set File Name"
		CurrentSession.save_diffuse = false
		CurrentSession.view_diffuse = false
		CurrentSession.name_diffuse = "Set File Name"
		CurrentSession.save_normals = false
		CurrentSession.view_normals = false
		CurrentSession.name_normals = "Set File Name"
		CurrentSession.save_alpha = false
		CurrentSession.view_alpha = false
		CurrentSession.name_alpha = "Set File Name"
		CurrentSession.save_lighting = false
		CurrentSession.view_lighting = false
		CurrentSession.name_lighting = "Set File Name"
		CurrentSession.save_shadow = false
		CurrentSession.view_shadow = false
		CurrentSession.name_shadow = "Set File Name"
		SessionMgr.LiteralName.view_heights = false
		CurrentSession.name_heights = "Set File Name"
	
	-- Check for Base Path

		if outfile != undefined do
		(
			if mvMaps.mvCompleteRenderCheck.checked == true do
				(
				CurrentSession.save_complete = true
				CurrentSession.view_complete = true
				CurrentSession.name_complete = (outPath + outfileName + "_" + i.name + "_C" + outExten)
				KalderaUpdate (CurrentSession)
				append Outfile_C CurrentSession.name_complete
				)
			
			if mvMaps.mvDiffuseRenderCheck.checked == true do
				(
				CurrentSession.save_diffuse = true
				CurrentSession.view_diffuse = false
				CurrentSession.name_diffuse = (outPath + outfileName + "_" + i.name + "_D" + outExten)
				KalderaUpdate (CurrentSession)
				append Outfile_D CurrentSession.name_diffuse
				)
			
				if mvMaps.mvNormalRenderCheck.checked == true do
					(
					CurrentSession.save_normals = true
					CurrentSession.view_normals = false
					CurrentSession.name_normals = (outPath + outfileName + "_" + i.name + "_N" + outExten)
					KalderaUpdate (CurrentSession)
					append Outfile_N CurrentSession.name_normals
				if mvMaps.mvNormal_Tangent.state == 1 then
					(
					CurrentSession.normals_space = 0
					)
					else
					(
					CurrentSession.normals_space = 1 
					)
				if mvMaps.mvNormal_YSpace.state == 1 then
					(
					CurrentSession.green_up = false
					)
					else
					(
					CurrentSession.green_up = true
					)
				)
			if mvMaps.mvAlphaRenderCheck.checked == true do 
				(
				CurrentSession.save_alpha = true
				CurrentSession.view_alpha = false
				CurrentSession.name_alpha = (outPath + outfileName + "_" + i.name + "_A" + outExten)
				KalderaUpdate (CurrentSession)
				append Outfile_A CurrentSession.name_alpha
				)
			if mvMaps.mvLightingRenderCheck.checked == true do 
				(
				CurrentSession.save_lighting = true
				CurrentSession.view_lighting = false
				CurrentSession.name_lighting = (outPath + outfileName + "_" + i.name + "_L" + outExten)
				KalderaUpdate (CurrentSession)
				append Outfile_L CurrentSession.name_lighting
				)
			
			if mvMaps.mvShadowRenderCheck.checked == true do
				(
				CurrentSession.save_shadow = true
				CurrentSession.view_shadow = false
				CurrentSession.name_shadow = (outPath + outfileName + "_" + i.name + "_S" + outExten)
				KalderaUpdate (CurrentSession)
				append Outfile_S CurrentSession.name_shadow	
				)
			if mvMaps.mvHeightRenderCheck.checked == true do
				(
				CurrentSession.save_heights = true
				CurrentSession.view_heights = false
				CurrentSession.name_heights = (outPath + outfileName + "_" + i.name + "_H" + outExten)
				KalderaUpdate (CurrentSession)
				append Outfile_H CurrentSession.name_heights	
				)

			)
	-- Map Setup Complete... Start your Render
			
			kalderaRender CurrentSession
			KalderaUpdate (CurrentSession)
			if mvMaps.mvLightingRenderCheck.checked == true do
			(
			if mvRender.mvUseGlobal.checked == true do
				(
				sceneradiosity.radiosity = undefined
				delete Sky_Light
				)
			)
		)

	-- Refresh UI

		KalderaSession (SessionMgr.LiteralName)
		KalderaUpdate (SessionMgr.LiteralName)
		
-- Composit the Bitmap if asked to

	if mvRender.mvCompositeDO.checked == true do 
		(
		print "Compositing Final Maps!"
-- Reset Progress bar for composite tracking

		totalComposite = (Outfile_C.count + Outfile_D.count + Outfile_N.count + Outfile_A.count + Outfile_L.count + Outfile_S.count + Outfile_H.count)
		SessionCount = 0
		mvRender.mvRenderProgress.value = 100.0*SessionCount/totalComposite
		
-- Begin Composite Process

		if mvMaps.mvCompleteRenderCheck.checked == true do (Composite_C())
		SessionCount += 1
		mvRender.mvRenderProgress.value = 100.0*SessionCount/totalComposite
		if mvMaps.mvDiffuseRenderCheck.checked == true do (Composite_D())
		SessionCount += 1
		mvRender.mvRenderProgress.value = 100.0*SessionCount/totalComposite
		if mvMaps.mvNormalRenderCheck.checked == true do (Composite_N())
		SessionCount += 1
		mvRender.mvRenderProgress.value = 100.0*SessionCount/totalComposite
		if mvMaps.mvAlphaRenderCheck.checked == true do (Composite_A())
		SessionCount += 1
		mvRender.mvRenderProgress.value = 100.0*SessionCount/totalComposite
		if mvMaps.mvLightingRenderCheck.checked == true do (Composite_L())
		SessionCount += 1
		mvRender.mvRenderProgress.value = 100.0*SessionCount/totalComposite		
		if mvMaps.mvShadowRenderCheck.checked == true do (Composite_S())
		SessionCount += 1
		mvRender.mvRenderProgress.value = 100.0*SessionCount/totalComposite
		if mvMaps.mvHeightRenderCheck.checked == true do (Composite_H())
		SessionCount += 1
		mvRender.mvRenderProgress.value = 100.0*SessionCount/totalComposite
		print "Bitmaps have been created"

-- Clean up if asked to
			if mvRender.mvDeleteSourceDO.checked == true do
			(
			ComponentArray = #(Outfile_C,Outfile_D,Outfile_N,Outfile_A,Outfile_L,Outfile_S,Outfile_H)

				for item in ComponentArray do
				(
				if item != #() do 
					(
					for i in item do 
						(
						try deleteFile  i
						catch 
							(
							messagebox "Error Deleting Component Map!" title: "Critical Error" beep: true
							print "Unable To Delete Component Maps!"
							break
							)
						)
					)
				)	
			)
		)
	

-- Clear the progress bar

	SessionCount = 0
	mvRender.mvRenderProgress.value = 100.0*SessionCount/Session_Array.count
	)
)

	if RenderType == 1 do (RenderActive())
	if RenderType == 2 do (RenderAll())
	if RenderType == 3 do (RenderCustom())
