--
--	Kaldera Animator v1.15 for Max6, Kaldera plugin required (see www.Mankua.com).
--
--	Written by Wes Saulsberry (Monolith- mailto: wes@lith.com) with some fixes 
--  by Kevin Deadrick (Monolith) for F.E.A.R. project development.
--	based on the example script that came with Kaldera.
--
--	This script allows you to specify animation time and output for complete,
--	diffuse, and normal maps. Someday I'll add more map types
--
--	Unless otherwise stated, all the settings are inherited from the Kaldera 
--	session object. The ones listed are really just overrides.
--
--	The next step is to setup a cfg file so it remembers the input from last use.
--	Someday I'll have it automatically compile the targas into a movie.
--
--	v1.1 DEADRICK 
--
--	Re-ordered rollout definitions to fix GUI update bug
--	established variables as global 
--	ensured that sf and ef Var(s) were set properly at script start (fix render bug)
--	added selectByName function to Kaldera Object select button (changed to button from pick button)
--	Removed ParamUpdate function and moved code block into rollout def.  Solved several GUI update Issues.
--	Removed Tip label under help referencing old method of select by name.  No longer relevant.
--
--  v1.15 SAULSBERRY
--
--  updated the info/credits to include Kev.
--  found bug with help and resolved it with Kevin by making "floaterhelp" a global.
--

------------------------ Begin script

kalderastart 1

global outfile 
global kaldera_object
global floaterhelp

global sf = animationrange.start -- start time frame var
global ef = animationrange.end -- end time frame var
global st = 1 -- render step var

global total

fn totalmaps =
	(

	if kaldera_object.save_complete == false then a=0 else a=1
	if kaldera_object.save_diffuse == false then b=0 else b=1
	if kaldera_object.save_normals == false then c=0 else c=1
	if kaldera_object.save_alpha == false then d=0 else d=1
	if kaldera_object.save_lighting == false then e=0 else e=1
	if kaldera_object.save_heights == false then f=0 else f=1
	
	total = a + b + c + d + e + f
	)

Rollout KParams "Kaldera Parameters" rolledup:true
	(
	group "Rendering"
			(	
			spinner swidth "Width" type:#integer fieldwidth:50 range:[0,4096,0] scale:128
			spinner sheight "Height" type:#integer fieldwidth:50 range:[0,4096,0] scale:128
			label blank1 ""
			spinner roffset "Ray Offset" type:#float fieldwidth:50 range:[0,4096,1] scale:10
			label blank2 ""
			spinner anti "Anti-aliasing" type:#integer fieldwidth:50 range:[1,8,1] scale:1
			spinner skirt "Skirt Filter" type:#integer fieldwidth:50 range:[0,64,8] scale:8
			)
				
			on swidth entered do
				(
				if kaldera_object == undefined then messagebox "Select a valid Kaldera Session First!"
				else
					(
					kaldera_object.rend_width = swidth.value
					Kalderaupdate 0
					)
				)
				
			on sheight entered do
				(
				if kaldera_object == undefined then messagebox "Select a valid Kaldera Session First!"
				else
					(
					kaldera_object.rend_height = sheight.value
					Kalderaupdate 0
					)
				)
			
			on roffset entered do
				(
				if kaldera_object == undefined then messagebox "Select a valid Kaldera Session First!"
				else
					(
					kaldera_object.ray_offset = roffset.value
					KalderaUpdate 0
					)
				)
			
			on anti entered do
				(
				if kaldera_object == undefined then messagebox "Select a valid Kaldera Session First!"
				else
					(
					kaldera_object.antialiasing = anti.value
					KalderaUpdate 0
					)
				)
			
			on skirt entered do
				(
				if kaldera_object == undefined then messagebox "Select a valid Kaldera Session First!"
				else
					(
					kaldera_object.prefiltering = skirt.value
					KalderaUpdate 0
					)
				)
	
	group "File Output"
		(
		checkbox SCmap "Save Complete Map Sequence"
		checkbox SDmap "Save Diffuse Map Sequence"
		checkbox SNmap "Save Normal Map Sequence"
		checkbox SAmap "Save Alpha Map Sequence"
		checkbox SLmap "Save Lighting Map Sequence"
		checkbox SHmap "Save Height Map Sequence"
		
		button bpath "Base File Name" width: 180
		)
		
		on SCmap changed state do 
			(
			if kaldera_object == undefined then messagebox "Select a valid Kaldera Session First!"
			else
				(
				if scmap.checked then 
					(
					kaldera_object.save_complete = on
					kaldera_object.view_complete = on
					KalderaUpdate 0
					)
				else 
					(
					kaldera_object.save_complete = off
					kaldera_object.view_complete = off
					KalderaUpdate 0
					)
				KalderaUpdate 0
				)
			)


		on SDmap changed state do 
			(
			if kaldera_object == undefined then messagebox "Select a valid Kaldera Session First!"
			else
				(
				if sdmap.checked then 
					(
					kaldera_object.save_diffuse = on
					kaldera_object.view_diffuse = on
					KalderaUpdate 0
					)
				else 
					(
					kaldera_object.save_diffuse = off
					kaldera_object.view_diffuse = off
					KalderaUpdate 0
					)
				KalderaUpdate 0
				)
			)
		
		on SNmap changed state do 
			(
			if kaldera_object == undefined then messagebox "Select a valid Kaldera Session First!"
			else
				(
				if snmap.checked then 
					(
					kaldera_object.save_normals = on
					kaldera_object.view_normals = on
					KalderaUpdate 0
					)
				else 
					(
					kaldera_object.save_normals = off
					kaldera_object.view_normals = off
					KalderaUpdate 0
					)
				KalderaUpdate 0
				)
			)
	
		on SAmap changed state do 
			(
			if kaldera_object == undefined then messagebox "Select a valid Kaldera Session First!"
			else
				(
				if samap.checked then 
					(
					kaldera_object.save_alpha = on
					kaldera_object.view_alpha = on
					KalderaUpdate 0
					)
				else 
					(
					kaldera_object.save_alpha = off
					kaldera_object.view_alpha = off
					KalderaUpdate 0
					)
				KalderaUpdate 0
				)
			)
				
		on SLmap changed state do 
			(
			if kaldera_object == undefined then messagebox "Select a valid Kaldera Session First!"
			else
				(
				if slmap.checked then 
					(
					kaldera_object.save_lighting = on
					kaldera_object.view_lighting = on
					KalderaUpdate 0
					)
				else 
					(
					kaldera_object.save_lighting = off
					kaldera_object.view_lighting = off
					KalderaUpdate 0
					)
				KalderaUpdate 0
				)
			)
			
		on SHmap changed state do 
			(
			if kaldera_object == undefined then messagebox "Select a valid Kaldera Session First!"
			else
				(
				if shmap.checked then 
					(
					kaldera_object.save_heights = on
					kaldera_object.view_heights = on
					KalderaUpdate 0
					)
				else 
					(
					kaldera_object.save_heights = off
					kaldera_object.view_heights = off
					KalderaUpdate 0
					)
				KalderaUpdate 0
				)
			)


		on bpath pressed do 
			(
			outfile = getsavefilename types: "Targa files (*.tga)|*.tga|"
			if outfile != undefined do bpath.caption = outfile
			)
		
	)
	
rollout Main "Main Parameters" 
	(
	
		fn session obj = classof obj.baseObject == Kaldera_Session
		
		group "Kaldera Session"
			(
			button Kobj "None Selected" width: 180 filter:session 
			)
			
			on Kobj pressed do
			(
			obj = selectByName title: "Select Session" filter:session single: true showHidden: true
				if obj != undefined do
				(
				kaldera_object = obj
				KalderaSession (kaldera_object)		
				KalderaUpdate 0
				Kobj.text = obj.name
-- Run ParamUpdate

				Kparams.swidth.value = kaldera_object.rend_width
				Kparams.sheight.value = kaldera_object.rend_height
				Kparams.roffset.value = kaldera_object.ray_offset
				
				Kparams.anti.value = kaldera_object.antialiasing
				Kparams.skirt.value = kaldera_object.prefiltering
				
				Kparams.scmap.checked = kaldera_object.save_complete
				Kparams.sdmap.checked = kaldera_object.save_diffuse
				Kparams.snmap.checked = kaldera_object.save_normals
				Kparams.samap.checked = kaldera_object.save_alpha
				Kparams.slmap.checked = kaldera_object.save_lighting
				Kparams.shmap.checked = kaldera_object.save_heights
				)
			)
		
		group "Animation"
			(
			spinner Sframe "Start Frame" type:#integer fieldwidth:50 range:[0,100000,(animationrange.start)] scale:30
			spinner Eframe "End Frame" type:#integer fieldwidth:50 range:[0,100000,(animationrange.end)] scale:30
			spinner Step "Render Step (F)" type:#integer fieldwidth:50 range:[1,100000,1]
			spinner Dur "Seconds" type:#float fieldwidth:50 range:[0,100000,((animationrange.end-animationrange.start)/30)] 	
			)
			on Sframe entered do
				(
				sf = Sframe.value as integer
				ef = Eframe.value as integer
				rtime = ef-sf
				Dur.value = rtime/30 as float
				)	
				
			on Eframe entered do
				(
				sf = Sframe.value as integer
				ef = Eframe.value as integer
				rtime = ef-sf
				Dur.value = rtime/30 as float
				)	
			
			on Step entered do
				(
				st = Step.value as integer
				)	
			
			on Dur entered do
				(
				Eframe.value = Sframe.value + (Dur.value*30)
				)				
			
	)

Rollout rend "Render" rolledup:true
	(
	group "BEWARE"
		(
		label tex1 "You CANNOT escape the rendering Sequence! \r\rBe sure to check your settings first!" width: 180 height: 60 align:#center
		button Doit "R E N D E R" width: 180
		)
		
		on Doit pressed do
			(
			
			Totalmaps()
			
			if kaldera_object == undefined then messagebox "Select a valid Kaldera Session First!"
			
			else
				(
				Totalmaps()
					
				if outfile == undefined then messagebox "Select a base name!"
				
				else if total == 0 then messagebox "Set at least one file to save!"
					
				else
					(
					the_file_path = getFilenamePath outfile
					the_file_name = getFilenameFile outfile
					the_extension = getFilenameType outfile
				
					for time in sf to ef by st do
						(
						slidertime = time
						aval = slidertime as integer/160
						
							if aval<10 
							then 
								(
								kaldera_object.name_complete = the_file_path + the_file_name + "_C_" + "00" + ( aval as string ) + the_extension
								kaldera_object.name_diffuse = the_file_path + the_file_name + "_D_" + "00" + ( aval as string ) + the_extension
								kaldera_object.name_normals = the_file_path + the_file_name + "_N_" + "00" + ( aval as string ) + the_extension
								kaldera_object.name_alpha = the_file_path + the_file_name + "_A_" + "00" + ( aval as string ) + the_extension
								kaldera_object.name_lighting = the_file_path + the_file_name + "_L_" + "00" + ( aval as string ) + the_extension
								kaldera_object.name_heights = the_file_path + the_file_name + "_H_" + "00" + ( aval as string ) + the_extension
								)
							else if aval<100 
							then 
								(
								kaldera_object.name_complete = the_file_path + the_file_name + "_C_" + "0" + ( aval as string ) + the_extension
								kaldera_object.name_diffuse = the_file_path + the_file_name + "_D_" + "0" + ( aval as string ) + the_extension
								kaldera_object.name_normals = the_file_path + the_file_name + "_N_" + "0" + ( aval as string ) + the_extension
								kaldera_object.name_alpha = the_file_path + the_file_name + "_A_" + "0" + ( aval as string ) + the_extension
								kaldera_object.name_lighting = the_file_path + the_file_name + "_L_" + "0" + ( aval as string ) + the_extension
								kaldera_object.name_heights = the_file_path + the_file_name + "_H_" + "0" + ( aval as string ) + the_extension
								)
			
							else 
								(
								kaldera_object.name_complete = the_file_path + the_file_name + "_C_" + ( aval as string ) + the_extension
								kaldera_object.name_diffuse = the_file_path + the_file_name + "_D_" + ( aval as string ) + the_extension
								kaldera_object.name_normals = the_file_path + the_file_name + "_N_" + ( aval as string ) + the_extension
								kaldera_object.name_alpha = the_file_path + the_file_name + "_A_" + ( aval as string ) + the_extension
								kaldera_object.name_lighting = the_file_path + the_file_name + "_L_" + ( aval as string ) + the_extension
								kaldera_object.name_heights = the_file_path + the_file_name + "_H_" + ( aval as string ) + the_extension
								)
						
						kalderaRender 0
						KalderaUpdate 0
						)
					)
				)
			)

	)

		Rollout newhelp ""
			(
			label helptext1 "Step 1: First, setup your scene with at least one Kaldera session setup correctly." align:#left
			label helptext1b "" align:#left width: 440
			
			label helptext2 "Step 2: Under \"Main Parameters\", choose the Kaldera Session you wish to work with." align:#left width: 440
		
			label helptext3b "" align:#left width: 440
			
			label helptext4 "Step 3: Set the number of frames you want Kaldera to render." align:#left
			label helptext5 "	> Notice that when starting the tool that it will inherit the current track length." align:#left width: 440
			label helptext6 "	> The \"Seconds\" parameter will keep your Start frame and adjust your End frame." align:#left width: 440
			label helptext7	"	> You can use the \"Render Step\" to render frames at nth intervals." align:#left width: 440
			label helptext7b "" 
			
			label helptext8 "Step 4: Open the \"Kaldera Parameters\" Rollout and configure your settings." align:#left width: 440
			label helptext9 "	> Once a Session is chosen all the parameters are inherited from that session." align:#left width: 440
			label helptext10 "	> You can adjust the Rendering/Output paramaters and it will update the utility bar." align:#left width: 440
			label helptext10b "	+++ Any other Kaldera parameters not in this tool are still inherited at render. +++" align:#left width: 440
			label helptext11 "" align:#left width: 440
			
			label helptext12 "Step 5: Click on \"Base File Name\" to set the filepath and base name for all maps." align:#left width: 440
			label helptext13 "	> Other than animation, this is the one parameter that doesn't inherit from the utility." align:#left width: 440
			label helptext14 "	> Just enter a base name, the script will append _C for complete, etc for you." align:#left width: 440
			label helptext14b "" align:#left width: 440
			
			label helptext15 "Step 6: Click on the \"Render\" button and go home!" align:#left width: 440
			label helptext16 "	> Be VERY SURE that your settings are correct, there is no escaping the rendering!!!" align:#left width: 440
			label helptext16b "" align:#left width: 440
			label helptext16c ""
			)
			
Rollout info "Help/About" rolledup:true
	(
	label tex2 "Wrtten by Wes Saulsberry of Monolith\r     (mail: wes@lith.com)\rWith some fixes by Kevin Deadrick\r     (mail: kevind@lith.com)\rFor F.E.A.R. game development.\r\rLoosely based on the example script that came with Kaldera." width: 180 height: 120 align:#center
	Button help "    Help    "
	
	on help pressed do
		( 
		--print ("floater = " + floaterhelp as string)
		if FloaterHelp != undefined do
				(
				closerolloutfloater FloaterHelp
				)	
		
		FloaterHelp = newRolloutFloater "Kaldera Animator Help" 480 220 5 100
		addRollout newhelp FloaterHelp
				--print ("floater = " + floaterhelp as string)
		
		)
	)



---------------------------end rollouts

if FloaterMain != undefined do
				(
				closerolloutfloater FloaterMain
				)		
FloaterMain = newRolloutFloater "Kaldera Animator v1.15" 220 650 


addRollout info FloaterMain
addRollout Main FloaterMain
addRollout KParams FloaterMain
addRollout rend FloaterMain

		


----------------------------end Main Floater
