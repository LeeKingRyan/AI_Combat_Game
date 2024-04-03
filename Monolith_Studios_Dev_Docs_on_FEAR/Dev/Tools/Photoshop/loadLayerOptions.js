// Loads saved layersettings from selected text layer.

//Remember current unit settings and then set units to
//the value expected by this script.
var originalUnit = preferences.rulerUnits;
preferences.rulerUnits = Units.PIXELS;

if (documents.length > 0) 
{
	// Get Active Document
    var docRef = activeDocument;
	// Get Active Layer.  
	var activeLayerRef = docRef.activeLayer;

	var savedLayerSettingsExists = 0;
	//	Get All Layers
	var layerRef = docRef.layers;
	// Count All the Layers
	var layerCount = docRef.layers.length;
	// Get All Layer Names - this might speed up the script.
	var layerNamesRef = new Array(layerCount);
	for (i=0; i < layerCount ; i ++)
	{
		layerNamesRef[i] = layerRef[i].name;
	}


	// Check to see if active layer is text and that it's parent is savedLayerSettings.
	var activeLayerKindRef = activeLayerRef.kind;
	if ( activeLayerKindRef == LayerKind.TEXT )
	{
		var testRef = activeLayerRef.parent;
		if (testRef.name == 'savedLayerSettings')
		{
			// Go through the text file and apply the layer settings

			// Get the contents of the text layer
			var textLayerContents = activeLayerRef.textItem.contents;
			// Split it by return carriage
			var textLayerContentsArray = textLayerContents.split('\r');

			// need to have these variables available on this level.
			var layerExists = 0;
			var layerNumber = 0;

			for ( i=0 ; i < textLayerContentsArray.length ; i++ )
			{
				// split each line by tabs
				var arrayBuffer = textLayerContentsArray[i].split('\t');
				if (arrayBuffer[0] == 'Layer Name:')
				{
					// We don't know if this layer exists yet, so set to 0.
					var layerExists = 0;
					// Find the layer with this name.
					// Remember if it exists or not.
					for (x = 0; x < ( layerCount ) ; x++ )
					{
						if (layerNamesRef[x] == arrayBuffer[1])
						{
							//If the layer is locked, skip it.
							if (layerRef[x].allLocked == false)
							{						
							//remember if the layer exists.
							//remember the array index of the layer.
							layerExists = 1;
							layerNumber = x;
							}
						}
					}

				}
				if (arrayBuffer[0] == 'BlendMode:')
				{
					if (layerExists == 1)
					{
						// Set the blendMode.
						layerRef[layerNumber].blendMode = arrayBuffer[1];
					}

				}
				if (arrayBuffer[0] == 'Opacity:')
				{
					if (layerExists == 1)
					{
						//Set the opacity
						layerRef[layerNumber].opacity = arrayBuffer[1];
					}
				}

				if (arrayBuffer[0] == 'Visibility:')
				{
					if (layerExists == 1)
					{
						var visibility = true;
						// If true then true if false then false
						if (arrayBuffer[1] == 'false')
						{
							visibility = false;
						}
						if (arrayBuffer[1] == 'true')
						{
							visibility = true;
						}
						// Set the visibility.
						layerRef[layerNumber].visible = visibility;
					}
				}


			}
			
		}
		else
			alert ( 'The current layer\'s parent is not savedLayerSettings' ) ;
	}
	else
	{
		alert ( 'The current layer is not text.' ) ;
	}
}

else
{
	alert('There must be at least one open document.');
}
//restore original ruler unit setting
preferences.rulerUnits = originalUnit;