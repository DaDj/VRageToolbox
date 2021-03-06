rollout VRage_Utils_sceneA  "Scene/Models" width:210 height:104
(

)

-- Scene Settings
rollout VrageUtils_Scene "Scene/Models" width:210 height:104
(		
	-- 	button 'Prep_scene' "Pepare scene" width:185 height:25 toolTip:"Generates the basic Setup for working with SE)" align:#center across:1
	-- 	on Prep_scene pressed do MySE.run "Scene_Setup.ms"		

	group "Scene"
	(
		label lblmdlname "Model name:" across: 3 align: #left
		edittext EditBlockName "" fieldWidth:125 labelOnTop:false text: "MyBlock" tooltip:"Name of the Model, also gonna be the Displayname ingame" align:#left bold: true height:20
		button btnApplyname "Apply" width:40 height:20 toolTip:"Apply new name" align:#right across:1


		label lblModeltype "Scene Type:" across: 3 align: #left
		dropdownlist dropdnMdlType "" items:#("Block","Character")   tooltip:"FF" across:1 labelOnTop: false  Width:183 enabled: false
		label fakelbl1 "" across: 1 align: #left
	)

	on btnApplyname pressed   do (

		MyVrageScene.OldModelname = MyVrageScene.ModelName
		MyVrageScene.ModelName = EditBlockName.text
		MyVrageLayers.CreatefromSetting()	
	)

	group "Settings"
	(
		label lbllodCount "Lods" across:3 offset:[0,10] align:#left 
		slider slidlodcount "" orient:#horizontal ticks:5 range:[0,5,1] type:#integer align:#right width:80
		spinner SpinLodCount "" fieldwidth:40 range:[0,6,1] type:#integer  across:3 align:#center offset:[0,10]

			
		label lblBSCount "Constructions" across:3 offset:[0,10] align:#left
		slider slidBScount "" orient:#horizontal ticks:3 range:[0,4,0] type:#integer align:#right width:80
		spinner SpinBSCount "" fieldwidth:40 range:[0,4,1] type:#integer  align:#center  offset:[0,10]

		label lblBSLodCount "Construction Lods" across:3 offset:[0,10] align:#left
		slider slidBSLodcount "" orient:#horizontal ticks:5 range:[0,5,0] type:#integer align:#right width:80
		spinner SpinBSLodCount "" fieldwidth:40 range:[0,5,1] type:#integer align:#center  offset:[0,10]
	)

    on SpinLodCount changed val do  (
		MyVrageScene.i_LODS = val
		slidlodcount.value = val
            --MyVrageScene.run "Scene_Setup.ms"	
	)		
	on slidlodcount changed val do  (
		MyVrageScene.i_LODS = val
		SpinLodCount.value = val
            --MyVrageScene.run "Scene_Setup.ms"	
	)		
	
    on SpinBSCount changed val do (
		 MyVrageScene.i_Construction = val
		 slidBScount.value = val
           -- MyVrageScene.run "Scene_Setup.ms"	
	)	
	
	on slidBScount changed val do (
		MyVrageScene.i_Construction = val
		SpinBSCount.value = val
		  -- MyVrageScene.run "Scene_Setup.ms"	
   )		
	
    on SpinBSLodCount changed val do (
		MyVrageScene.i_ConstructionLODS = val
		slidBSLodcount.value = val
            --MyVrageScene.run "Scene_Setup.ms"	
	)			
		
    on slidBSLodcount changed val do (
		MyVrageScene.i_ConstructionLODS = val
		SpinBSLodCount.value = val
            --MyVrageScene.run "Scene_Setup.ms"	
	)	
	
	on dropdnMdlType selected val do (
		if val == 1 then (
			SpinBSCount.visible = true
			slidBScount.visible = true
			lblBSCount.visible =true
			lblBSLodCount.visible = true
			SpinBSLodCount.visible = true
			slidBSLodcount.visible = true
		)
		else (
			SpinBSCount.visible = false
			slidBScount.visible = false
			lblBSCount.visible =false
			lblBSLodCount.visible = false
			SpinBSLodCount.visible = false
			slidBSLodcount.visible = false
		)
	)

	button 'Prep_scene' "Update Scene" width:120 height:25 toolTip:"Generates the basic Setup for working with SE)" align:#center across:1
	on Prep_scene pressed do MyVrageLayers.CreatefromSetting()	
	
	
	subrollout ExtendedSettings height:200 scrollbar:off
	on VrageUtils_Scene open  do 
	(
		VrageUtils_Scene.height -= 90;
		SpinLodCount.Value = slidlodcount.Value =  MyVrageScene.i_LODS
		SpinBSCount.Value = slidBScount.Value =  MyVrageScene.i_Construction
		SpinBSLodCount.Value = slidBSLodcount.Value =  MyVrageScene.i_ConstructionLODS
		EditBlockName.text  = MyVrageScene.ModelName

	)
)

rollout VRageUtils_extBlocksets "Extended Settings" height:100
(
	spinner SpinLod1Dist "Lod1 Distance 0" fieldwidth:45 range:[1,200,1] type:#integer  align:#center 
	spinner SpinLod2Dist "Lod2 Distance 1" fieldwidth:45 range:[1,200,1] type:#integer  align:#center 
	spinner SpinLod3Dist "Lod3 Distance 2" fieldwidth:45 range:[1,200,1] type:#integer  align:#center 
	spinner SpinLod4Dist "Lod4 Distance 3" fieldwidth:45 range:[1,200,1] type:#integer  align:#center 
	spinner SpinLod5Dist "Lod5 Distance 4" fieldwidth:45 range:[1,200,1] type:#integer  align:#center 
	spinner SpinLod6Dist "Lod6 Distance 5" fieldwidth:45 range:[1,200,1] type:#integer  align:#center 

	
	on VRageUtils_extBlocksets open do(
	SpinLod1Dist.value = MyVrageScene.LodDistance1
	SpinLod2Dist.value = MyVrageScene.LodDistance2
	SpinLod3Dist.value = MyVrageScene.LodDistance3
	SpinLod4Dist.value = MyVrageScene.LodDistance4
	SpinLod5Dist.value = MyVrageScene.LodDistance5
	SpinLod6Dist.value = MyVrageScene.LodDistance6
	)
	
	on VRageUtils_extBlocksets rolledUp state do
	if state then
	(
		VrageUtils_Scene.ExtendedSettings.height += 180;
		VrageUtils_Scene.height  +=180;
	)		
		else
	(
		VrageUtils_Scene.ExtendedSettings.height -= 180;
		VrageUtils_Scene.height -=180;
	)
)

rollout VRageUtils_Dimensions "Dimensions" height:240
(		
	--dropdownlist scale_dd "Blocksize" items:#("Large","Small")   tooltip:"FF" across:1 labelOnTop: false
	label lblsize "Grid Size:" across:2 align:#left  height:30
	radiobuttons rad_buttons "" labels:#("Large  ","Small  ")  columns:2 labelOnTop: false offset:[-80,0] 
	spinner  bound_leng "X" fieldwidth:45 range:[1,100,1] type:#integer across: 3 align:#center
	spinner bound_width "Y" fieldwidth:45 range:[1,100,1] type:#integer align:#center
	spinner  bound_height "Z" fieldwidth:45 range:[1,100,1] type:#integer align:#center
)

rollout VRageUtils_Subparts "Subparts" height:140
(
	button btnAddSubpart "Add" width:60 height:20 toolTip:"Generates the basic Setup for working with SE)" align:#left offset:[0,0] across:1
	button btnDelteSubpart "Delete" width:60 height:20 toolTip:"Generates the basic Setup for working with SE)" align:#left offset:[0,0]
	button btnRenameSubpart "Rename" width:60 height:20 toolTip:"Generates the basic Setup for working with SE)" align:#left offset:[0,0]
	listbox listSubparts "" items:#(" edf", "df") height:5 offset:[0,-75] width:180 align:#right 		
)

rollout VrageUtils_Mountpoints "Mountpoints" width:210 height:504
(
	button btn_StartMountpoints "Start Mountpoints Mode" width:185 height:25 toolTip:" " align:#center
	on btn_StartMountpoints pressed do filein "Mountpoint_GUI.ms"
)

rollout VrageUtils_Collision "Collisions" width:330 height:504
(	
	group "Create RigidBodies"	
	(
		button btn_RigidBox "Box" width:30 height:30 toolTip:"Box" align:#center across:5 
		button btn_RigidSphere "Sphere" width:30 height:30 toolTip:"Sphere" align:#center
		button btn_RigidCylinder "Cylinder" width:30 height:30 toolTip:"Cylinder" align:#center
		button btn_RigidMesh "Hull" width:30 height:30 toolTip:"Hull" align:#center
		button btn_RigidCapsule "Capsule" width:30 height:30 toolTip:"Capsule" align:#center enabled:false
		
		on VrageUtils_Collision open do 
		(
		btn_RigidBox.images = #("Standard_24i.bmp", undefined,11, 1, 1,1, 1, true, true)
		btn_RigidSphere.images = #("Standard_24i.bmp", undefined,11, 2, 2,2, 2, false, true)
		btn_RigidCylinder.images = #("Standard_24i.bmp", undefined,11, 3, 3,3, 3, false, true)
		btn_RigidMesh.images = #("Extended_24i.bmp", undefined,12, 5, 5,5, 5, false, true)
		btn_RigidCapsule.images = #("Extended_24i.bmp", undefined,12, 9, 9,9, 9, false, true)
		)

		checkbox chbox_FitSelec "Fit to Selection" align:#center tooltip:"Fits the generated Rididbody to the selected Object. Generates an Convex Hull if mesh is choosen,"
			
		on btn_RigidBox pressed do  CreateRigidBodyObject   "Box" chbox_FitSelec.checked 
		on btn_RigidSphere pressed do  CreateRigidBodyObject "Sphere"  chbox_FitSelec.checked 
		on btn_RigidCylinder pressed do  CreateRigidBodyObject "Cylinder" chbox_FitSelec.checked 
		on btn_RigidMesh pressed do  CreateRigidBodyObject "Hull" chbox_FitSelec.checked 
	)

)

rollout VrageUtils_Settings"VRage Utilities Settings" width:210 height:504
(
	button btn_Settings "Open Settings" width:120 height:25 toolTip:" " align:#center across:2
	on btn_Settings pressed do OpenSettings()
	
	button btn_LOg "Open Log" width:120 height:25 toolTip:" " align:#center
	on btn_LOg pressed do VRageLog_Show()
)


rollout VRageUtils_Export"VRage I/O"
(
	button 'Btn_Import' "Import" width:120 height:25 toolTip:"Imports an Fbx from the ModSDK" align:#center across:2
	--on Prep_scene pressed do MySE.run "Scene_Setup.ms"	

	button 'Btn_export' "Export" width:120 height:25 toolTip:"Generates  MWM file/s from the selected Block/s" align:#center 
	on Btn_export pressed do OpenVrageExport()
)


try (closeRolloutFloater VrageFloater1) catch () 
VrageFloater1 = newRolloutFloater  "VRage Utilies"300 800 300 300 
--clearListener()

addRollout VrageUtils_Scene VrageFloater1
addRollout VRageUtils_Dimensions VrageFloater1
addRollout VRageUtils_Subparts VrageFloater1
addRollout VrageUtils_Collision VrageFloater1
addRollout VrageUtils_Mountpoints VrageFloater1  rolledUp:true
addRollout VRageUtils_Export VrageFloater1
addRollout VrageUtils_Settings VrageFloater1  rolledUp:true

AddSubRollout VrageUtils_Scene .ExtendedSettings VRageUtils_extBlocksets rolledUp:true



-- cui.RegisterDialogBar VrageFloater1 style:#(#cui_floatable, #cui_dock_right) --minSize:[236,100] maxSize:[236,1600]
-- cui.DockDialogBar VrageFloater1 #cui_dock_right