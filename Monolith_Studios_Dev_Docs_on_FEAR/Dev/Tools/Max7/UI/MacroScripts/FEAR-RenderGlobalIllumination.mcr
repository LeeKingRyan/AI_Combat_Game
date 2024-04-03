macroScript RenderGlobal category:"FEAR" buttonText: "GI_Render"
(

-- Create Light and GI Settings

Sky_Light = Skylight name: "Global" position:[0,0,50] color: white
sceneradiosity.radiosity = Light_Tracer()

-- Render

max quick render
			
-- Clean Up
sceneradiosity.radiosity = undefined
delete Sky_Light
)
