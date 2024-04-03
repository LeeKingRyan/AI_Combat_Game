--	Multi Noise v1.0
--
--	Written by Kevin Deadrick (Monolith) for F.E.A.R. project development.
-- 

rollout mnNoiseMaster "Master Controls"
(
	group "Generator Controls"
	(
	button mnModify "Generate Multi Noise" width: 160
	)
	group "Randomize"
	(
	spinner MasterSeed "Seed: " range: [0,10000,0] type: #integer width: 80 align: #right
	spinner MaxVal "Max Value: " range: [0,10000,0] type: #integer width: 100 align: #right
	spinner MinVal "Min Value: " range: [0,10000,0] type: #integer width: 97 align: #right
	button mnRandomize "Randomize Fields" width: 160
	)

)
rollout mnNoise_01 "Noise Layer - 01"
(
	group "Noise: "
	(
	spinner mnSeed_01 "Seed: " range: [0,10000,0] type: #integer width: 80 offset: [20,0] 
	spinner mnScale_01 "Scale: " range: [0,10000,100] type: #float width: 80 offset: [20,0] 
	checkbox mnFract_01 "Fractal" align: #Right offset: [0,0]
	spinner mnRough_01 "Roughness: " range: [0,10000,0] type: #float width: 100 offset: [22,0] 
	spinner mnIterat_01 "Iterations: " range: [0,10,.6] type: #float width: 90 offset: [21,0]
	)
	group "Strength:"
	(
	spinner mnXStrength_01 "X: " range: [-10000,10000,0] type: #float width: 80 align: #center
	spinner mnYStrength_01 "Y: " range: [-10000,10000,0] type: #float width: 80 align: #center
	spinner mnZStrength_01 "Z: " range: [-10000,10000,0] type: #float width: 80 align: #center
	)
	group "Animation:"
	(
	spinner mnFreq_01 "Frequency: " range: [0,10000,0] type: #float width: 120 align: #right
	spinner mnPhase_01 "Phase: " range: [0,10000,0] type: #integer width: 104 align: #right
	checkbox mnAnimate_01 "Animate Noise" align: #left
	)
	group "Multi Noise:"
	(
	checkbutton mnUseNoise_01 "Enable Noise Layer" width: 160
	)
)

rollout mnNoise_02 "Noise Layer - 02"
(
	group "Noise: "
	(
	spinner mnSeed_02 "Seed: " range: [0,10000,0] type: #integer width: 80 offset: [20,0] 
	spinner mnScale_02 "Scale: " range: [0,10000,100] type: #float width: 80 offset: [20,0] 
	checkbox mnFract_02 "Fractal" align: #Right offset: [0,0]
	spinner mnRough_02 "Roughness: " range: [0,10000,0] type: #float width: 100 offset: [22,0] 
	spinner mnIterat_02 "Iterations: " range: [0,10,.6] type: #float width: 90 offset: [21,0]
	)
	group "Strength:"
	(
	spinner mnXStrength_02 "X: " range: [-10000,10000,0] type: #float width: 80 align: #center
	spinner mnYStrength_02 "Y: " range: [-10000,10000,0] type: #float width: 80 align: #center
	spinner mnZStrength_02 "Z: " range: [-10000,10000,0] type: #float width: 80 align: #center
	)
	group "Animation:"
	(
	spinner mnFreq_02 "Frequency: " range: [0,10000,0] type: #float width: 120 align: #right
	spinner mnPhase_02 "Phase: " range: [0,10000,0] type: #integer width: 104 align: #right
	checkbox mnAnimate_02 "Animate Noise" align: #left
	)
	group "Multi Noise:"
	(
	checkbutton mnUseNoise_02 "Enable Noise Layer" width: 160
	)
)

rollout mnNoise_03 "Noise Layer - 03"
(
	group "Noise: "
	(
	spinner mnSeed_03 "Seed: " range: [0,10000,0] type: #integer width: 80 offset: [20,0] 
	spinner mnScale_03 "Scale: " range: [0,10000,100] type: #float width: 80 offset: [20,0] 
	checkbox mnFract_03 "Fractal" align: #Right offset: [0,0]
	spinner mnRough_03 "Roughness: " range: [0,10000,0] type: #float width: 100 offset: [22,0] 
	spinner mnIterat_03 "Iterations: " range: [0,10,.6] type: #float width: 90 offset: [21,0]
	)
	group "Strength:"
	(
	spinner mnXStrength_03 "X: " range: [-10000,10000,0] type: #float width: 80 align: #center
	spinner mnYStrength_03 "Y: " range: [-10000,10000,0] type: #float width: 80 align: #center
	spinner mnZStrength_03 "Z: " range: [-10000,10000,0] type: #float width: 80 align: #center
	)
	group "Animation:"
	(
	spinner mnFreq_03 "Frequency: " range: [0,10000,0] type: #float width: 120 align: #right
	spinner mnPhase_03 "Phase: " range: [0,10000,0] type: #integer width: 104 align: #right
	checkbox mnAnimate_03 "Animate Noise" align: #left
	)
	group "Multi Noise:"
	(
	checkbutton mnUseNoise_03 "Enable Noise Layer" width: 160
	)
)

rollout mnNoise_04 "Noise Layer - 04"
(
	group "Noise: "
	(
	spinner mnSeed_04 "Seed: " range: [0,10000,0] type: #integer width: 80 offset: [20,0] 
	spinner mnScale_04 "Scale: " range: [0,10000,100] type: #float width: 80 offset: [20,0] 
	checkbox mnFract_04 "Fractal" align: #Right offset: [0,0]
	spinner mnRough_04 "Roughness: " range: [0,10000,0] type: #float width: 100 offset: [22,0] 
	spinner mnIterat_04 "Iterations: " range: [0,10,.6] type: #float width: 90 offset: [21,0]
	)
	group "Strength:"
	(
	spinner mnXStrength_04 "X: " range: [-10000,10000,0] type: #float width: 80 align: #center
	spinner mnYStrength_04 "Y: " range: [-10000,10000,0] type: #float width: 80 align: #center
	spinner mnZStrength_04 "Z: " range: [-10000,10000,0] type: #float width: 80 align: #center
	)
	group "Animation:"
	(
	spinner mnFreq_04 "Frequency: " range: [0,10000,0] type: #float width: 120 align: #right
	spinner mnPhase_04 "Phase: " range: [0,10000,0] type: #integer width: 104 align: #right
	checkbox mnAnimate_04 "Animate Noise" align: #left
	)
	group "Multi Noise:"
	(
	checkbutton mnUseNoise_04 "Enable Noise Layer" width: 160
	)
)

rollout mnNudgeHelp "Help"
(
	label mvAbout_01 "Multi Noise v1.0"
	label mvAbout_02 "Writen for F.E.A.R"
	label mvAbout_03 "Copyright 2004 Monolith Productions"
	label mvAbout_04 "Support email: kevind@lith.com"
	label mvAbout_05 "DO NOT DISTRIBUTE"
)

if mnPanel != undefined do (closeRolloutFloater mnPanel)

mnPanel = newRolloutFloater "Multi Noise v1.0" 200 800

addRollout mnNoiseMaster mnPanel
addRollout mnNoise_01 mnPanel
addRollout mnNoise_02 mnPanel rolledUp: true
addRollout mnNoise_03 mnPanel rolledUp: true
addRollout mnNoise_04 mnPanel rolledUp: true
addRollout mnNudgeHelp mnPanel rolledUp: true

global mndebug = false
