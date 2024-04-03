macroscript GetMEditDefaults
buttontext:"Get Default Medit State" category:"FEAR"
(
	max mtledit
	loadMaterialLibrary (getDir #defaults+"/medit.mat")
	for i = 1 to 24 do meditmaterials[i] = currentMaterialLibrary[i]
	loadMaterialLibrary (getDir #matlib+"/3dsmax.mat")
) --End Script

