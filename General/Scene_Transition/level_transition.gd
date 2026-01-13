@tool
extends Node3D
class_name LevelTransition 

enum SIDE { LEFT, RIGHT, TOP, BOTTOM }

@export_range( 5, 5, 1, "or_greater") var size : int = 5 :
	set( value ):
		size = value
		Apply_Area_Settings()

@export var location : SIDE = SIDE.LEFT :
	set( value ):
		location = value
		Apply_Area_Settings()

@export_file( "*.tscn" ) var Target_Level : String = ""
@export var Target_Area_Name : String = "LevelTransition"

@onready var Area_3D: Area3D = $Area3D

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	Apply_Area_Settings()
	SceneManager.New_Scene_Ready.connect( _On_New_Scene_Ready )
	SceneManager.Load_Scene_Finished.connect( _On_Load_Scene_Finished )
	pass

func _on_player_entered( _n : Node3D) -> void:
	SceneManager.Transition_Scene( Target_Level, Target_Area_Name, Get_Off_Set( _n ), Get_Transition_Direction() )
	pass

func _On_New_Scene_Ready( Target_Name : String, Off_Set : Vector3 ) -> void:
	if Target_Name == name:
		var player : Node = get_tree().get_first_node_in_group( "Player" )
		player.global_position = global_position + Off_Set
	pass

func _On_Load_Scene_Finished() -> void:
	Area_3D.body_entered.connect( _on_player_entered )
	Area_3D.monitoring = false
	await get_tree().physics_frame
	await get_tree().physics_frame
	Area_3D.monitoring = true
	pass


func Apply_Area_Settings() -> void:
	Area_3D = get_node_or_null( "Area3D")
	if not Area_3D:
		return
	if location == SIDE.LEFT or location == SIDE.RIGHT:
		Area_3D.scale.y = size
		if location == SIDE.LEFT:
			Area_3D.scale.z = 5
		else:
			Area_3D.scale.z = 5
	else:
		Area_3D.scale.x = size
		if location == SIDE.TOP:
			Area_3D.scale.z = 5
		else:
			Area_3D.scale.z = 5
	pass


func Get_Off_Set( _Player : Node3D, ) -> Vector3:
	var Off_Set : Vector3 = Vector3.ZERO
	if location == SIDE.LEFT or location == SIDE.RIGHT:
		if location == SIDE.LEFT:
			Off_Set.z = 5
		else:
			Off_Set.z = 5
	else:
		if location == SIDE.TOP:
			Off_Set.z = 5
		else:
			Off_Set.z = 5
	return Off_Set


func Get_Transition_Direction() -> String:
	match location:
		SIDE.LEFT:
			return "left"
		SIDE.RIGHT:
			return "right"
		SIDE.TOP:
			return "up"
		_:
			return "down"
