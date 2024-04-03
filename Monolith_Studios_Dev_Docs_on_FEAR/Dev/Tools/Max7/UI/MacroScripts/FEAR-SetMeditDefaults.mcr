macroScript SetMeditDefaults
buttontext:"Set Default MEdit State" category:"FEAR"
(
	max mtledit
	default_lib = (getDir #defaults+"/medit.mat")
	loadMaterialLibrary default_lib
	for i = 1 to 24 do currentMaterialLibrary[i] = meditmaterials[i]
	copyfile default_lib (getDir #defaults+"/Medit.bak")
	saveMaterialLibrary default_lib
	loadMaterialLibrary (getDir #matlib+"/3dsmax.mat:")
) -- End Script
