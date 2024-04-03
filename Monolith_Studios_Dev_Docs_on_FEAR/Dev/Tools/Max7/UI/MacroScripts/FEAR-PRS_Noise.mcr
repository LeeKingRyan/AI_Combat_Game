macroScript PRS_Noise 
	ButtonText:"PRS_Noise"
	Category:"FEAR" 
	Tooltip:"PRS_Noise"

(

on isEnabled return selection.count > 0

on execute do
(
fileIn "$scripts\FEAR\TranslateNoise.ms"
)
)
