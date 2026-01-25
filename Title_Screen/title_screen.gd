extends CanvasLayer

#region /// onready variables
@onready var Main_Menu: VBoxContainer = %Main_Menu
@onready var New_Game_Menu: VBoxContainer = %New_Game_Menu
@onready var Load_Game_Menu: VBoxContainer = %Load_Game_Menu

##Buttons
@onready var Start_Game_Button: Button = %Start_Game_Button
@onready var Load_Game_Button:Button = %Load_Game_Button
@onready var Quit_Button: Button = %Quit_Button

@onready var New_Slot1: Button = %New_Slot1
@onready var New_Slot2: Button = %New_Slot2
@onready var New_Slot3: Button = %New_Slot3

@onready var Load_Slot1: Button = %Load_Slot1
@onready var Load_Slot2: Button = %Load_Slot2
@onready var Load_Slot3: Button = %Load_Slot3

@onready var Animation_Player: AnimationPlayer = $Control/Main_Menu/Logo/AnimationPlayer
#endregion

func _ready() -> void:
	Start_Game_Button.grab_focus()
	Start_Game_Button.pressed.connect( show_New_Game_Menu)
	Load_Game_Button.pressed.connect( show_Load_Game_Menu)
	Quit_Button.pressed.connect( _on_Quit_Pressed ) 
	
	New_Slot1.pressed.connect( _On_New_Game_Pressed.bind( 0 ) )
	New_Slot2.pressed.connect( _On_New_Game_Pressed.bind( 1 ) )
	New_Slot3.pressed.connect( _On_New_Game_Pressed.bind( 2 ) )
	
	Load_Slot1.pressed.connect(_On_Load_Game_Pressed.bind( 0 ) )
	Load_Slot2.pressed.connect(_On_Load_Game_Pressed.bind( 1 ) )
	Load_Slot3.pressed.connect(_On_Load_Game_Pressed.bind( 2 ) )
	
	show_Main_Menu()
	Animation_Player.animation_finished.connect( _on_animation_finished )
	pass
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed( "ui_cancel" ):
		if Main_Menu.visible == false:
			#Audio
			show_Main_Menu()
	pass


func show_Main_Menu() -> void:
	Main_Menu.visible = true
	New_Game_Menu.visible = false
	Load_Game_Menu.visible = false
	
	Start_Game_Button.grab_focus()
	pass

func show_New_Game_Menu() -> void:
	Main_Menu.visible = false
	New_Game_Menu.visible = true
	Load_Game_Menu.visible = false
	
	New_Slot1.grab_focus()
	
	if SaveManager.Save_File_Exists( 0 ):
		New_Slot1.text = "REPLACE SLOT 01"
		
	if SaveManager.Save_File_Exists( 1 ):
		New_Slot2.text = "REPLACE SLOT 02"
		
	if SaveManager.Save_File_Exists( 2 ):
		New_Slot3.text = "REPLACE SLOT 03"
		
	pass

func show_Load_Game_Menu() -> void:
	Main_Menu.visible = false
	New_Game_Menu.visible = false
	Load_Game_Menu.visible = true
	
	Load_Slot1.grab_focus()
	Load_Slot1.disabled = not SaveManager.Save_File_Exists( 0 )
	Load_Slot2.disabled = not SaveManager.Save_File_Exists( 1 )
	Load_Slot3.disabled = not SaveManager.Save_File_Exists( 2 )
	pass

func _On_New_Game_Pressed( slot : int) -> void:
	SaveManager.Create_New_Game_Save( slot )
	SceneManager.Transition_Scene(
		"uid://c7ctc6j6yvi0f",
		"", Vector3.ZERO, "up"
	)
	pass


func _On_Load_Game_Pressed( slot : int) -> void:
	SaveManager.load_game( slot )
	pass


func _on_Quit_Pressed() -> void:
	get_tree().quit()
	pass


func _on_animation_finished( anim_name :  String ) -> void:
	if anim_name == "Start":
		Animation_Player.play("Start")
	pass
