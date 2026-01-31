class_name SavePoint extends Node3D

@onready var animation_player: AnimationPlayer = $Sketchfab_model/Node3D/AnimationPlayer
@onready var area_3d: Area3D = $Area3D


func _ready() -> void:
	area_3d.body_entered.connect( _on_player_entered )
	area_3d.body_exited.connect( _on_player_exited )
	pass



func _on_player_entered( _n : Node3D ) -> void:
	Messages.player_interacted.connect(_on_player_interacted)
	Messages.input_hint_changed.emit( "ui_select" )
	pass




func _on_player_exited( _n : Node3D ) -> void:
	Messages.player_interacted.disconnect(_on_player_interacted)
	Messages.input_hint_changed.emit( "" )
	pass


func _on_player_interacted( player : Player ) -> void:
	Messages.player_healed.emit( 999 )
	SaveManager.save_game()
	animation_player.play("Game_Saved" )
	animation_player.seek( 0 )
	#Audio
	pass
