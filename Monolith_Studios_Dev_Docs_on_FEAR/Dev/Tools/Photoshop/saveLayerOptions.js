// Saves the settings on all layers into the selected text layer.
// Saves the name of the text layer as the file name.  This will be
// used in another script to save the file.

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

	// Check to make sure active layer is in savedLayerSettings and is text.
	// If it's not and does not exist, create a new text layer under savedLayerSettings
	// use that layer to save the settings to.

	var savedLayerSettingsExists = 0;
	//	Get All Layers
	var layerRef = docRef.layers;
	// Count All the Layers
	var layerCount = docRef.layers.length;

	// Check to see if active layer is text and that it's parent is savedLayerSettings.
	var activeLayerKindRef = activeLayerRef.kind;
	if ( activeLayerKindRef == LayerKind.TEXT )
	{
		var testRef = activeLayerRef.parent;
		if (testRef.name == 'savedLayerSettings')
		{
			doTheStuff();
		}
		else
			alert ( 'The current layer\'s parent is not savedLayerSettings' ) ;
	}
	else
	{
		var result = confirm ( 'The current layer is not text.\rWould you like me to make one for you?' ) ;
		if (result == 1)
		{
			var layerSetRef;
			for ( i=0; i < layerCount; i++ )
			{
				if (layerRef[i].name == 'savedLayerSettings')
				{
					savedLayerSettingsExists = 1;
					layerSetRef = layerRef[i];
				}
			}
			if (savedLayerSettingsExists == 1)
			{
				var newArtLayerRef = docRef.artLayers.add();
				newArtLayerRef.name = 'newfile';
				newArtLayerRef.kind = LayerKind.TEXT ;
				newArtLayerRef.moveToEnd (layerSetRef);
				// offset the text to be in the top left corner
				var myTextRef = newArtLayerRef.textItem;
				myTextRef.position = new Array( 12, 20 );
				if(OpenFileDialog())
				{
					theDoc = activeDocument;
					var docWidth = theDoc.width;
					var docHeight = theDoc.height;
					activeDocument = docRef;
					newArtLayerRef.name = theDoc.name.toString();
					newArtLayerRef.textItem.contents = 'File Name:\t' + theDoc.fullName.toString() + '\rFile Width:\t' + docWidth + '\rFile Height:\t' + docHeight ;
					doTheStuff();
				}

			}
			else
			{
				var newLayerSetRef = docRef.layerSets.add();
				newLayerSetRef.name = 'savedLayerSettings';
				newLayerSetRef.visible = false;

				var newArtLayerRef = docRef.artLayers.add();
				newArtLayerRef.name = 'newfile';
				newArtLayerRef.kind = LayerKind.TEXT ;
				newArtLayerRef.moveToEnd (newLayerSetRef);
				// offset the text to be in the top left corner
				var myTextRef = newArtLayerRef.textItem;
				myTextRef.position = new Array( 12, 20 );
				if(OpenFileDialog())
				{
					theDoc = activeDocument;
					activeDocument = docRef;
					newArtLayerRef.name = theDoc.name.toString();
					newArtLayerRef.textItem.contents = 'File Name:\t' + theDoc.fullName.toString();
					doTheStuff();
				}

			}
		}
	}
}

else
{
	alert('There must be at least one open document.');
}
//restore original ruler unit setting
preferences.rulerUnits = originalUnit;

function OpenFileDialog()
{
	theActionDesc = executeAction(charIDToTypeID("Opn "),new ActionDescriptor(),DialogModes.ALL);

	try { theActionDesc.count;return true;}
	catch(err) { return false; }
}

function doTheStuff()
{
	// Get Active Document
    var docRef = activeDocument;
	// Get Active Layer.  
	var activeLayerRef = docRef.activeLayer;

	//	Get All Layers
	var layerRef = docRef.layers;
	// Count All the Layers
	var layerCount = docRef.layers.length;

	// Create some variables.
	var fileName = '';
	var fileHeight = docRef.height;
	var fileWidth = docRef.width;
	var alphaChannel = '';

	// Get file info from the text layer.  If there is none, then that's ok.

	var textLayerContents = activeLayerRef.textItem.contents;
	// Split it by return carriage
	var textLayerContentsArray = textLayerContents.split('\r');

	for ( i=0 ; i < textLayerContentsArray.length ; i++ )
	{
		// split each line by tabs
		var arrayBuffer = textLayerContentsArray[i].split('\t');
		if (arrayBuffer[0] == 'File Name:')
		{
			fileName = arrayBuffer[1];
		}
		if (arrayBuffer[0] == 'File Height:')
		{
			fileHeight = arrayBuffer[1];
		}
		if (arrayBuffer[0] == 'File Width:')
		{
			fileWidth = arrayBuffer[1];
		}
		if (arrayBuffer[0] == 'Alpha Channel:')
		{
			alphaChannel = arrayBuffer[1];
		}
		
	}

	// Go through each layer and save their settings into a string
	// Save the File Name as the name of the text layer.
	var layerContents = "";
	for (i = 0; i < ( layerCount ) ; i++ )
	{
		var layerName = layerRef[i].name ;
		var layerVisibility = layerRef[i].visible ;
		var layerBlendMode = layerRef[i].blendMode ;
		var layerOpacity = layerRef[i].opacity ;
		if (layerContents == "" )
		{
			layerContents = 'File Name:\t' + fileName + '\rFile Height:\t' + fileHeight + '\rFile Width:\t' + fileWidth + '\rAlpha Channel:\t' + alphaChannel + '\rLayer Name:\t' + layerName + '\rBlendMode:\t' + layerBlendMode + '\rOpacity:\t' + layerOpacity + '\rVisibility:\t' + layerVisibility;
		}
		else
			layerContents = layerContents + '\rLayer Name:\t' + layerName + '\rBlendMode:\t' + layerBlendMode + '\rOpacity:\t' + layerOpacity + '\rVisibility:\t' + layerVisibility;
	}
	// Print the settings into the text layer
	activeLayerRef.textItem.contents = layerContents;
}