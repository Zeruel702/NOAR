class_name BasePlayerState
extends RefCounted

## called when we first enter this state.
func enter(_player: Player) -> void:
	pass
	

##Called when we exit this state.
func exit(_player: Player) -> void:
	pass

## Called before update is called, allows for state changes.
func pre_update(_player: Player) -> void:
	pass

## Called for every physics frame we're in this state.
func update(_player: Player, _delta: float) -> void:
	pass
