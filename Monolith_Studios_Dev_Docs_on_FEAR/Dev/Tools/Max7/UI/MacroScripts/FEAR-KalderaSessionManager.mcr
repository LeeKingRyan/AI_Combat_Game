macroScript SessionManager category:"FEAR" buttonText: "KSM"
(
local Session_Test = #()
local AHelper_Array = $Helpers as array
for i in AHelper_Array do
	(
	HelperClass = ((classof i) as string) as name
	if HelperClass == #Kaldera_Session do append Session_Test i
	)
if Session_Test.count == 0 then 
(
messagebox "Session Manager REQUIRES at least one Kaldera Session to run!" title: "WARNING! No Kaldera Session(s) Found!"
)
else
(
fileIn "$scripts\FEAR\Kaldera_Session_Manager.ms"
)
)
