class_name Input_Hints extends Node3D

var controller_type : String = "keyboard"
#@onready var label_3d: Label3D = $Label3D

@onready var sprite_3d: Sprite3D = $Sprite3D

func _ready() -> void:
	visible = false
	Messages.input_hint_changed.connect(_on_hint_changed)
	pass



func _on_hint_changed( hint : String) -> void:
	if hint == "":
		visible = false
	else:
		visible = true
		await get_tree().create_timer(3.0).timeout
		visible = false
	pass
