@icon ( "uid://cyivaem45aydy" )
class_name player_spawner extends Node3D


func _ready() -> void:
	
	visible = false
	
	await get_tree().process_frame
	
	if get_tree().get_first_node_in_group( "Player" ):
		print (" We have a player ")
		return
	
	print ("No player was found")
	
	var player : Player = load( "uid://cl7ctby2wmu0e" ).instantiate()
	get_tree().root.add_child( player )
	
	player.global_position = self.global_position
	pass
