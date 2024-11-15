extends Node2D
var world_scene = preload("res://scenes/world.tscn").instantiate()
var hover_SFX = preload("res://assets/SFX/001_Hover_01.wav")
var confirm_SFX = preload("res://assets/SFX/013_Confirm_03.wav")

@onready var parallax_background: ParallaxBackground = $ParallaxBackground
@onready var parallax_background_dark_: ParallaxBackground = $"ParallaxBackground(DARK)"

@onready var save_load: Node2D = $Save_Load


@onready var menu_sounds = $"Menu Sounds"
@onready var settings = $Settings

var settings_visible = false

# Called when the node enters the scene tree for the first time.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
		

func _on_play_mouse_entered():
	menu_sounds.stream = hover_SFX
	menu_sounds.play()


func _on_options_pressed():
	#check if its first off
	if(settings_visible == false): # if settings is visible, we will hide
	
		settings.show()
		settings_visible = true
	else:
		settings.hide()
		settings_visible = false

func _on_exit_pressed():
	get_tree().quit()


func _on_play_pressed():
	menu_sounds.stream = confirm_SFX
	menu_sounds.play()
	
	save_load.load_game()
	get_tree().change_scene_to_file("res://scenes/world.tscn")
	

func _on_button_mouse_entered():
	menu_sounds.stream = hover_SFX
	menu_sounds.play()

func _on_button_pressed():
	menu_sounds.stream = confirm_SFX
	menu_sounds.play()
	


func _on_light_pressed() -> void:
	parallax_background.visible = true
	parallax_background_dark_.visible = false
	
	


func _on_dark_pressed() -> void:
	parallax_background.visible = false
	parallax_background_dark_.visible = true
