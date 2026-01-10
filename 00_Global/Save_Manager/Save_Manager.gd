 # SaveManager Script
extends Node
 
const SLOTS : Array [String] =[
	"Save_01", "Save_02", "Save_03"
]

var Current_Slot : int = 0
var Save_Data : Dictionary
var Discovered_Areas : Array = []
var Persistent_Data : Dictionary = {}



func _ready() -> void:
	pass



func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_F5:
			save_game( )
		elif  event.keycode == KEY_F7:
			load_game( Current_Slot )
	pass

func Create_New_Game_Save( slot : int) -> void:
	Current_Slot = slot
	Discovered_Areas.clear()
	Persistent_Data.clear()
	var New_Game_Scene : String = "uid://c7ctc6j6yvi0f"
	Discovered_Areas.append ( New_Game_Scene )
	Save_Data = {
		"Scene_Path" : New_Game_Scene,
		"x" : 0,
		"y" : 0,
		"z" : 0,
		"Health" : 20,
		"Max_Health" : 20,
		"Double_Jump" : false,
		"Discovered_Areas" : Discovered_Areas,
		"Persistent_Data" : Persistent_Data,
	}
	# Save Game Data
	var Save_File: = FileAccess.open(Get_File_Name( Current_Slot ),FileAccess.WRITE)
	Save_File.store_line(JSON.stringify(Save_Data))
	
	Save_File.close()
	
	load_game( slot )
	
	
	pass



func save_game() -> void:
	var player : Player = get_tree().get_first_node_in_group( "Player" )
	Save_Data = {
		"Scene_Path" : SceneManager.Current_Scene_uid,
		"x" : player.global_position.x,
		"y" : player.global_position.y,
		"z" : player.global_position.z,
		"Health" : player.Health,
		"Max_Health" : player.Max_Health,
		"Double_Jump" : player.Double_Jump,
		"Discovered_Areas" : Discovered_Areas,
		"Persistent_Data" : Persistent_Data,
	}
	var Save_File: = FileAccess.open(Get_File_Name( Current_Slot ),FileAccess.WRITE)
	Save_File.store_line(JSON.stringify(Save_Data))
	pass



func load_game( slot : int) -> void:
	if not FileAccess.file_exists(Get_File_Name( Current_Slot )):
		return
	
	Current_Slot = slot
	
	var Save_File := FileAccess.open(Get_File_Name( Current_Slot ), FileAccess.READ)
	Save_Data = JSON.parse_string(Save_File.get_line())
	
	Persistent_Data = Save_Data.get("Persistent_Data", {})
	Discovered_Areas = Save_Data.get("Discovered_Areas", [])
	var Scene_Path : String = Save_Data.get("Scene_Path", "uid://c7ctc6j6yvi0f")
	SceneManager.Transition_Scene( Scene_Path, "", Vector3.ZERO,"up")
	await SceneManager.New_Scene_Ready
	setup_player()
	pass

func setup_player() -> void:
	var player : Player = null
	while not player:
		player = get_tree().get_first_node_in_group( "Player")
		await get_tree().process_frame
	
	player.Max_Health = Save_Data.get("Max_Health", 20)
	player.Health = Save_Data.get( "Health", 20)
	
	player.Double_Jump = Save_Data.get( "Double_Jump", false)
	
	player.global_position = Vector3(
			Save_Data.get( "x",0),
			Save_Data.get( "y",0),
			Save_Data.get( "z",0),
		)
	pass


func Get_File_Name ( slot : int ) -> String:
	
	return "user://" + SLOTS [ slot ] + ".sav"

func Save_File_Exists ( slot : int ) -> bool:
	
	return FileAccess.file_exists(Get_File_Name ( slot ) )
