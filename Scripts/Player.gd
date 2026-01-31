class_name Player
extends CharacterBody3D

## Reference To The Animation Tree Node For The Player
@onready var anim_tree: AnimationTree = $AnimationTree

## Tracks The Last Lean Value For Adding Leaning To Our Running Animation
var last_lean := 0.0

## Determines How Fast The Player Moves
@export var base_speed := 5.0

## Jump Velocity Applied When The Player Jumps
const JUMP_VELOCITY = 8


#region /// PLAYER STATS
var Health : float = 20
var Max_Health : float = 20
var Double_Jump : bool = false
#endregion




## Reference To The Camera For Adjustin Movement Direction.
@onready var camera: Node3D = $CameraRig/Camera3D

## Speed that the player is considered running.
const RUN_SPEED = 3.5

## The current state that the player is in.
var state: BasePlayerState = PlayerStates.IDLE

## Player's Movement Input For The Current Physic's Frame
var move_input: Vector2 = Vector2.ZERO

## Player's Movement Input, Adjusted for the Camera Direction
## This will usually be a normalized Vector or Zero
var move_direction: Vector3 = Vector3.ZERO

## Called When The Node Is Added To The Scene
func _ready() -> void:
	if get_tree().get_first_node_in_group( "Player" ) != self:
		queue_free()
	state.enter(self)
	self.call_deferred("reparent", get_tree().root )
	
	Messages.player_healed.connect( _on_player_healed )
	pass



## Changes the current player state and runs the current functions.
func change_state_to(next_state: BasePlayerState) -> void:
	state.exit(self)
	state = next_state
	state.enter(self)


## Called Every Physics Frame. Delegates Update Logic To The Current State.
func _physics_process(delta: float) -> void:
	## Read Movement Input And Store It On The Player
	move_input = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")

	## Calculate Adjusted movement Direction Based On Camera.
	move_direction = (camera.global_basis * Vector3(move_input.x, 0, move_input.y))
	move_direction = Vector3(move_direction.x, 0, move_direction.z).normalized()

	## Delegates to Current state
	state.pre_update(self)
	state.update(self, delta)


## Rotates the player to face thew given direction
func turn_to(direction: Vector3) -> void:
	if direction.length() > 0:
		var yaw:= atan2(-direction.x,-direction.z)
		yaw = lerp_angle(rotation.y, yaw, .25)
		rotation.y = yaw

## Returns the player's current speed.
func get_current_speed() -> float:
	return velocity.length()

## Applies velocity based on directional movement input
func update_velocity_using_direction(direction: Vector3, speed: float = base_speed) -> void:
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed( "ui_select" ):
		Messages.player_interacted.emit(self )
	pass


func _on_player_healed( amount : float ) -> void:
	Health += amount
	print( "HEALED JABRONI" )
	#Audio/Visual
	pass
