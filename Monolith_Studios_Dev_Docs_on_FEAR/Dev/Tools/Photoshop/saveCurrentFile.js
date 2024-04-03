//Remember current unit settings and then set units to
//the value expected by this script.
var originalUnit = preferences.rulerUnits;
preferences.rulerUnits = Units.PIXELS;

if (documents.length > 0) 
{
    var docRef = activeDocument;
	var allDocumentsRef = documents;
	var activeLayerRef = docRef.activeLayer;
	var fileNameRef = activeLayerRef.name;
	var saveToDocumentRef;

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
			// Get the file info from the text layer.

			// Get the contents of the text layer
			var textLayerContents = activeLayerRef.textItem.contents;
			// Split it by return carriage
			var textLayerContentsArray = textLayerContents.split('\r');

			// need to have these variables available on this level.
			var fileName = '';
			var fileHeight = docRef.height;
			var fileWidth = docRef.width;
			var alphaChannel = '';

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

			// save the state of the file
			docRef = activeDocument;
			savedState = docRef.activeHistoryState;
			//Hide the text layers.
			testRef.visible = false;

			// Flatten the document.
			docRef.flatten();

			// Resize the document
			// Make sure those numbers actually numbers -
			// I about killed myself trying to figure this out.
			var newFileWidth = parseInt(fileWidth);
			var newFileHeight = parseInt(fileHeight);
			docRef.resizeImage(newFileWidth,newFileHeight);

			//SelectAll and copy.
			docRef.selection.selectAll();
			docRef.selection.copy();

			// Find out if the file to save to is open.

			// The saveTo document does not exist as far as we know yet.
			var saveToDocumentExists = false;
			for (i= 0; i < allDocumentsRef.length; i++)
			{
				if ( allDocumentsRef[i].fullName == fileNameRef )
				{
					// The document Exists.
					saveToDocumentExists = true;
					saveToDocumentRef = allDocumentsRef[i];
				}
			}

			if (saveToDocumentExists != true)
			{
				// Open the file.
				// Should add functionality to check if file exists and create it if it doesn't.
				// or just saveAs, overwriting the old one would be fine, but there's no support
				// for .dds files.
				if (fileName == '')
				{
					if(OpenFileDialog())
					{
						saveToDocumentRef = activeDocument;
					}
				}
				else
				{
					var fileRef = new File(fileName);
					saveToDocumentRef = open (fileRef);
				}

			}
			
			// Paste the shit.
			activeDocument = saveToDocumentRef;
			saveToDocumentRef.activeLayer = saveToDocumentRef.layers[0];
			var pastedLayer = saveToDocumentRef.paste();

			// return to previous state
			activeDocument = docRef;
			docRef.activeHistoryState = savedState;
			
			// Copy the alpha channel and save the mofo.
			// find the alpha channel
			if (alphaChannel != '')
			{
				theChannels = docRef.channels;
				for (i = 0; i < theChannels.length ; i ++)
				{
					if ( theChannels[i].name == alphaChannel)
					{
						theChannelWeWant = new Array ( theChannels[i] );
						docRef.activeChannels = theChannelWeWant;
						docRef.selection.selectAll();
						docRef.selection.copy();
					}
				}
				activeDocument = saveToDocumentRef;
				saveToDocumentRef.channels.removeAll();
				var newChannel = saveToDocumentRef.channels.add();
				saveToDocumentRef.activeChannel = newChannel;
				var pastedChannel = saveToDocumentRef.paste();
	//			saveToDocumentRef.activeLayer = saveToDocumentRef.layers("[Background]");
			}
			activeDocument = saveToDocumentRef;
			saveToDocumentRef.flatten();
			saveToDocumentRef.save();

		}
	}
	activeDocument = docRef;
	docRef.activeLayer = activeLayerRef;
}
else
{
	alert("There must be at least one open document.");
}

//restore original ruler unit setting
preferences.rulerUnits = originalUnit;

function OpenFileDialog()
{
	theActionDesc = executeAction(charIDToTypeID("Opn "),new ActionDescriptor(),DialogModes.ALL);

	try { theActionDesc.count;return true;}
	catch(err) { return false; }
} 