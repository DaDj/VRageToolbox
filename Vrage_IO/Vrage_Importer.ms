if MyVRageCfg == undefined do (
	root = pathConfig.removePathLeaf (getSourceFileName());
	
	if matchpattern (toLower root) pattern:"*vragetoolbox*" then (
		while toLower (a = filterString root "\\")[a.count] != "vragetoolbox" do (
			root = getfilenamepath (trimright root "\\")
		)
		
		fileIn (root + "Vrage_Startup.ms")
	)
	else (
		MessageBox "Vrage Toolbox can not be initialised!"
	)
)

struct VrageFBXImporter (

	filename = undefined,
	import_subparts = True,
	import_construction = True,
	import_LODs = True,

	fn showCurrentSettings =(

		Settings = #(
			"Animation",
			"AxisConversion",
			"BakeAnimationLayers",
			"Cameras",
			"ConvertUnit",
			"FillTimeline",
			"FilterKeyReducer",
			"FilterKeySync",
			"GenerateLog",
			"ImportBoneAsDummy",
			"KeepFrameRate",
			"Lights",
			"LoadImportPresetFile",
			"Markers",
			"Mode",
			"PopSettings",
			"PushSettings",
			"PointCache",
			"Resampling",
			"ResetImport",
			"ScaleConversion",
			"ScaleFactor",
			"Shape",
			"Skin",
			"SmoothingGroups",
			"TakeCount",
			"TakeIndex",
			"UpAxis"
		)
		
		for setting in Settings do format "FbxImporterSetParam \"%\" %\n" setting (FbxImporterGetParam setting)
	),

	fn SetImportSettings =(
		
		FbxImporterSetParam "Animation" true
		FbxImporterSetParam "AxisConversion" true
		FbxImporterSetParam "BakeAnimationLayers" true
		FbxImporterSetParam "Cameras" true
		FbxImporterSetParam "ConvertUnit" #custom_unit
		FbxImporterSetParam "FillTimeline" false
		FbxImporterSetParam "FilterKeyReducer" false
		FbxImporterSetParam "FilterKeySync" false
		FbxImporterSetParam "GenerateLog" true
		FbxImporterSetParam "ImportBoneAsDummy" true
		FbxImporterSetParam "KeepFrameRate" false
		FbxImporterSetParam "Lights" true
		FbxImporterSetParam "Markers" false
		FbxImporterSetParam "Mode" #merge
		FbxImporterSetParam "PointCache" true
		FbxImporterSetParam "Resampling" 30.0
		FbxImporterSetParam "ScaleConversion" true
		FbxImporterSetParam "ScaleFactor" 1.0
		FbxImporterSetParam "Shape" true
		FbxImporterSetParam "Skin" true
		FbxImporterSetParam "SmoothingGroups" false
		FbxImporterSetParam "UpAxis" #z
		
	),
	
	fn importFBX file root_layer:(LayerManager.getLayer 0) parent_layer:undefined parent_node:undefined = (
		
		local fname = filenameFromPath file --getFilenameFile
		local name = getFilenameFile file
		
		local old_objects = objects as array
		
		importfile file #noPrompt using:FBXIMP
		
		local imported = for o in objects where findItem old_objects o == 0 collect o
		
		if parent_layer == undefined then (
			local parent_layer = layermanager.newLayerFromName name
			parent_layer.setParent root_layer
			local lod0_layer = layermanager.newLayerFromName (name + " #LOD0")
			lod0_layer.setParent parent_layer
			--local dummy_layer = layermanager.newLayerFromName (name + " #Dummies")
			--dummy_layer.setParent parent_layer
			
			for o in imported do (
				case (superclassOf o) of (
					GeometryClass: lod0_layer.addNode o
					helper: lod0_layer.addNode o--dummy_layer.addNode o
				)
				
				o.name += "#" + lod0_layer.name
			)
			
			if import_subparts and not matchpattern name pattern:"*construction*" do (
				local subparts = for o in imported where (superclassOf o == helper) and (isProperty o "file") collect o
				
				if subparts.count > 0 do (
					local sub_layer = layermanager.newLayerFromName (name + " #Subparts")
					sub_layer.setParent parent_layer
					
					for sub in subparts do (
						local sub_file = getFilenamePath file + sub.file as string + ".fbx"
						if doesFileExist sub_file do (
							local sub_imports = importFBX sub_file root_layer:sub_layer parent_node:sub
							join imported sub_imports
						)
					)
				)
			)
			
			if import_LODs do (
				local lod_files = getFiles (getFilenamePath file + name + "_LOD*.FBX")
				
				for lod_file in lod_files do (
					local lod_imports = importFBX lod_file parent_layer:parent_layer parent_node:parent_node
					
					join imported lod_imports
				)
			)

			if import_construction do (
				local construction_files = getFiles (getFilenamePath file + getFilenameFile file + "Construction*.FBX") + getFiles (getFilenamePath file + getFilenameFile file + "_Construction*.FBX")
				
				construction_files = makeUniqueArray construction_files
				
				if construction_files.count > 0 do (
					local constr_layer = layermanager.newLayerFromName (name + " #Construction")
					constr_layer.setParent parent_layer
					constr_layer.ishidden  = True
					
					for constr in construction_files where not matchpattern constr pattern:"*_LOD*" do (
						
						if constr == @"E:\Program Files (x86)\Steam\SteamApps\common\SpaceEngineersModSDK\OriginalContent\Models\Cubes\large\PistonSubpart3Construction_1.fbx" do (
							break()
						)
						
						constr_imports = importFBX constr root_layer:constr_layer parent_node:parent_node
						join imported constr_imports
					)
					
				)
			)
			
			if parent_node != undefined do (
				for o in imported where o.parent == undefined do (
					o.position = parent_node.position
					o.parent = parent_node
				)
			)
		)
		else (
			lod_file_name = getFilenameFile file
			lod_name_index = FindString lod_file_name "_LOD"
			lod_name = subString lod_file_name (lod_name_index + 1) -1
			lod_owner = subString lod_file_name 1 (lod_name_index - 1)

			lod_layer = layermanager.newLayerFromName (lod_owner + " #" + lod_name)
			lod_layer.setParent parent_layer
			lod_layer.ishidden  = True
			
			for i = imported.count to 1 by -1 do (
				o = imported[i]
				case (superclassOf o) of (
					GeometryClass: lod_layer.addNode o
					helper: delete o
				)
				
				if not isdeleted o do o.name += "#" + lod_layer.name
				
			)
		)
		
		imported
	),

	fn import =(

		if doesFileExist filename then (
			max create mode
			--SetImportSettings()
			with redraw off (
				LastImport = importFBX filename
				
				LastImport = for o in lastimport where not isdeleted o collect o
			)

			Vrage_cleanLayers()
			with redraw off (	
				if Vrage_cleanMats == undefined do (
					fileIn (MyVRageRoot + "\\Vrage_IO\\VRage_MaterialLibrary.ms")
				)
				
				for o in LastImport do (
					o.name = trimright (filterstring o.name "#")[1]
				)
				
				Vrage_cleanMats LastImport
			)
			
			forceCompleteRedraw()
		)
		else (
			msg = "File \"" + filename + "\" does not exist and can not be imported"
			messageBox 
		)
	),

	fn ShowUI = 
	(
		rollout rollIMUI "VRage Import Scene" width:400 height:200
		(
			button Btn_import "Import" width:200 height:40 toolTip:"Import .Fbx Block/s" align:#center  across:1
			--button Btn_exportsel "Export Selected only" width:200 height:40 toolTip:"Generates  MWM file/s from the selected Block/s" align:#center 
			

			checkbutton Chkb_ImpSubparts "Import Subparts."   checked:true  width:130  height:25\
			tooltip:" "  across:3 align:#center 

			checkbutton ChkExp_IMPConst "Import Constructions"   checked:false  width:130  height:25\
			tooltip:" "  align:#center 

			checkbutton ChkExp_IMPLODs "Import LODS"   checked:false  width:130  height:25\
			tooltip:""  align:#center 

			on Btn_import pressed do 
			(

			f = getOpenFileName caption:"Open A Test File:" filename: (MyVRageCfg.PathModSDK + "\\") types:"Fbx(*.fbx)|*.fbx"
				if f != undefined then 
				(
					Test = VrageFBXImporter filename:f
					Test.import_LODs = ChkExp_IMPLODs.checked
					Test.import_subparts = Chkb_ImpSubparts.checked
					Test.import_construction = ChkExp_IMPConst.checked
					Test.import()
				)
			)

		--	on rollExpUI open do ()
		)

		try (cui.UnRegisterDialogBar IMP_UI) catch () 
		try (DestroyDialog  IMP_UI) catch ()

		IMP_UI = newRolloutFloater "VRAGE Import" 500 200
		addRollout rollIMUI IMP_UI
	

		cui.RegisterDialogBar IMP_UI  style:#(#cui_floatable)

	)
)