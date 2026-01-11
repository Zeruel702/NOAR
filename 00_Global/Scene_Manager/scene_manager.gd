extends CanvasLayer

signal Load_Scene_Started
signal New_Scene_Ready( Target_Name : String, Off_Set : Vector3 )
signal Load_Scene_Finished
signal Scene_Entered ( uid : String)
@onready var fade: Control = $fade/TextureRect

var Current_Scene_uid : String



func _ready() -> void:
	await get_tree().process_frame
	fade.visible = false
	Load_Scene_Finished.emit()
	var current_scene : String = get_tree().current_scene.scene_file_path
	Current_Scene_uid = ResourceUID.path_to_uid( current_scene )
	pass


func Transition_Scene( New_Scene : String, Target_Area : String, Player_Offset : Vector3, Dir : String) -> void:
	
	get_tree().paused = true
	var fade_pos : Vector2 = get_fade_pos( Dir )

	fade.visible = true
	
	Load_Scene_Started.emit()
	
	await fade_screen( fade_pos, Vector2.ZERO )
	await get_tree().process_frame
	
	
	
	
	
	get_tree().change_scene_to_file( New_Scene )
	Current_Scene_uid = ResourceUID.path_to_uid( New_Scene )
	Scene_Entered.emit( Current_Scene_uid )
	
	await get_tree().scene_changed
	
	New_Scene_Ready.emit(Target_Area, Player_Offset)
	
	await fade_screen( Vector2.ZERO, -fade_pos )
	
	await get_tree().process_frame
	get_tree().paused = false
	fade.visible = false
	
	Load_Scene_Finished.emit()
	pass

func fade_screen( from : Vector2, to : Vector2 ) -> Signal:
	fade.position = from
	var tween : Tween = create_tween()
	tween.tween_property( fade, "position", to, 0.2 )
	return tween.finished




func get_fade_pos( Dir : String ) -> Vector2:
	var pos : Vector2 = Vector2( 1152 * 2, 648 * 2)
	
	match Dir:
		"left":
			pos *= Vector2( -1, 0)
		"right":
			pos *= Vector2( 1, 0)
		"up":
			pos *= Vector2( 0, -1)
		"down":
			pos *= Vector2( 0, 1)
	return pos
