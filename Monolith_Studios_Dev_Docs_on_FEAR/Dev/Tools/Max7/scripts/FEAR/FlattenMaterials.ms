--For max7 ONLY!!
clearlistener()

global floatermats
global outfile = undefined
global foundmaterial = 0
global curmat
global oldmat
global hold = materiallibrary()

Rollout fparams "Parameters" 
(
group ""
	(
	label L1 "Output file destination:" align:#left
	button bpath "Browse" width: 180
	label L2 ""
	radiobuttons normals labels:#("Dump Normal Maps","Save Normal Maps as 32-bit TGA","Save Normals as compressed JPEG")
	label L3 ""
	label L4 "Normal plugin:" align:#left
	radiobuttons normplugin labels:#("Kaldera Normal Map","Max7 Normal Bump")
	label L5 ""
	spinner normamount "Normal Bump Amount  " align:#left fieldwidth:50 type:#integer scale:5 range:[0,400,100]
	label L6 ""
	label L7 "Normal output size:" align:#left
	radiobuttons normalsize labels:#("100%","50%","25%")
	label L8 "Diffuse output size" align:#left
	radiobuttons diffusesize labels:#("100%","50%","25%")
	label L9 ""
	spinner jopt "Jpeg Quality  " align:#left fieldwidth:50 type:#integer scale:5 range:[0,100,(jpeg.ijpegio.getquality())]  
	label L10 ""
	button launch "Execute" width: 100
	)
	
	on bpath pressed do 
		(
		outfile = getsavepath()
		if outfile != undefined do bpath.caption = outfile
		)
	
	on jopt entered do 
		(
		jpeg.ijpegio.setquality jopt.value
		jpeg.ijpegio.getquality()
		)
	
	on launch pressed do
		(
		if outfile == undefined then messagebox "Select a valid destination folder first!"
		if outfile != undefined then
			(
			clearlistener()
			print ("Jpeg Quality set to " + (jpeg.ijpegio.getquality() as string) + "")
			print ("Save path set to " + outfile)

			if normals.state == 1 do (print "Normal Maps will not be saved")
			if normals.state == 2 do (print "Normal Maps will be saved as 32-bit TGA")	
			if normals.state == 3 do (print "Normal Maps will be saved as compressed Jpegs")
				
			print "\r"
			
			for o in geometry do -- build the temporary material library of FEAR materials
				(
				i = o.material
				case of
					(
						(classof i == multimaterial): 
							(
							--print i.name
							for s in i.materiallist do
								(
								--print ( i.name + " __ " + s.name)
								if classof s.diffusemap == bitmaptexture do
									(
									dx = getFilenameType s.diffusemap.filename
									if matchpattern dx pattern:".dds" do 
										(
										foundmaterial = 1
										if finditem hold s == 0 do -- to weed out duplicates, it works!!!
											(
											append hold s
											--print s.diffusemap.filename
											print ( s.name + " __ has been added to materiallibrary")
											)
										)--end match pattern
									)
								)
							)--classof multi
							
						(classof i == standardmaterial):if classof i.diffusemap == bitmaptexture do
							(
							dx = getFilenameType i.diffusemap.filename
							if matchpattern dx pattern:".dds" do 
								(
								foundmaterial = 1 -- found a FEAR material successfully
								if finditem hold i == 0 do -- to weed out duplicates, it works!!!
									(
									append hold i
									print ( i.name + " __ has been added to flatten task")
									)
								
								)
							)--classof standard
					
					)	--case of
					
				)-- for geometry do
					
				if foundmaterial == 0 then messagebox "Cannot detect F.E.A.R. game materials" else 
					
					(
					print "\r"
					for h in hold do
						(
						-- start diffuse transfer
						diffbasename = h.diffusemap.name + "_flat"
						olddiff = openbitmap h.diffusemap.filename
						case of
							(
								(diffusesize.state == 1):
									(
									dw = olddiff.width
									dh = olddiff.height
									)
								(diffusesize.state == 2):
									(
									dw = olddiff.width * 0.5
									dh = olddiff.height * 0.5
									)							
								(diffusesize.state == 3):
									(
									dw = olddiff.width * 0.25
									dh = olddiff.height * 0.25
									)
							)		
						newdiff = bitmap (dw as integer) (dh as integer)
						copy olddiff newdiff
						newdiff.filename = outfile + "\\" + diffbasename + ".jpeg"
						save newdiff
						close olddiff
						close newdiff
						print ""
						print ("Saved file:  " + newdiff.filename)
						-- end diffuse transfer
						
						-- start normal map tga transfer
						if normals.state == 2 do
							(
							normbasename = h.bumpmap.name + "_flat"
							oldnorm = openbitmap h.bumpmap.filename
							case of
								(
									(normalsize.state == 1):
										(
										nw = oldnorm.width
										nh = oldnorm.height
										)
									(normalsize.state == 2):
										(
										nw = oldnorm.width * 0.5
										nh = oldnorm.height * 0.5
										)							
									(normalsize.state == 3):
										(
										nw = oldnorm.width * 0.25
										nh = oldnorm.height * 0.25
										)
								)	
							newnorm = bitmap (nw as integer) (nh as integer)
							copy oldnorm newnorm
							newnorm.filename = outfile + "\\" + normbasename + ".tga"
							save newnorm
							close oldnorm
							close newnorm
							print ""
							print ("Saved file:  " + newnorm.filename)
							)
						-- end normal map tga transfer
						
						-- start normal map jpeg transfer
						if normals.state == 3 do
							(
							normbasename = h.bumpmap.name + "_flat"
							oldnorm = openbitmap h.bumpmap.filename
							case of
								(
									(normalsize.state == 1):
										(
										nw = oldnorm.width
										nh = oldnorm.height
										)
									(normalsize.state == 2):
										(
										nw = oldnorm.width * 0.5
										nh = oldnorm.height * 0.5
										)							
									(normalsize.state == 3):
										(
										nw = oldnorm.width * 0.25
										nh = oldnorm.height * 0.25
										)
								)
							newnorm = bitmap (nw as integer) (nh as integer)
							copy oldnorm newnorm
							newnorm.filename = outfile + "\\" + normbasename + ".jpg"
							save newnorm
							close oldnorm
							close newnorm
							print ""
							print ("Saved file:  " + newnorm.filename)
							)
						-- end normal map jpeg transfer
						
						-- start clone h materials as
						curmat = standardmaterial name:(h.name + "_flat") showinviewport:true
						curmat.diffusemap = bitmaptexture filename:newdiff.filename name:diffbasename
						if normals.state > 1 do 
							(
							case of 
								(
									(normplugin.state == 1): 
										(
										curmat.bumpmap = normal_map()
										curmat.bumpmap.normalmap = newnorm 
										)
									(normplugin.state == 2): 
										(
										curmat.bumpmap = normal_bump()
										curmat.bumpmap.normal_map = bitmaptexture filename:newnorm.filename name:normbasename
										--curmat.bumpmap.normal_map.bitmap = newnorm
										)
								)
							curmat.bumpmapAmount = normamount.value
							)
						oldmat = h.name
						print ( "Created copy of " + h.name + " F.E.A.R. material as flattened material: " + curmat.name)
						--end new material

						--start search on all 3d objects in scene and replace old standard materials and sub-materials
						for j in geometry do
							(
							if j.material != undefined do 
								case of
								(
								(classof j.material == standardmaterial):
									if j.material.name == oldmat do 
										(
										j.material = curmat
										print ("Replaced " + oldmat + " on " + j.name + " with " + curmat.name)
										)
								(classof j.material == multimaterial):
									for k in j.material.materialIDlist do
										(
										d = getsubmtl j.material k
										if d.name == oldmat do
											(
											setsubmtl j.material k curmat
											print ("Replaced sub-material " + oldmat + " on " + j.name + " with " + curmat.name)
											)
										)
								)--case of
										
							)--for j in geometry
						
						for i in meditmaterials do 
							(
							if i.name == oldmat do 
								(
								--m = getmeditmaterial i
								a = finditem meditmaterials i
								meditmaterials [a] = curmat
								)
							)	
								
						)-- end h material loop	
						
					)-- if found material do		
		)--	if outfile
	freescenebitmaps()
	closerolloutfloater FloaterMats
	gc()
	messagebox "Done converting materials/maps!" title:" A word from our sponsor:  "
	)-- on launch pressed do
)---------------------------end rollout fparams
if FloaterMats != undefined do (closerolloutfloater FloaterMats)		
FloaterMats = newRolloutFloater "Flatten F.E.A.R. Materials" 220 465
addRollout fparams FloaterMats
----------------------------end Main Floater