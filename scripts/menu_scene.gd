extends Node2D
var world_scene = preload("res://scenes/world.tscn").instantiate()
var hover_SFX = preload("res://assets/SFX/001_Hover_01.wav")
var confirm_SFX = preload("res://assets/SFX/013_Confirm_03.wav")

@onready var play_button = $Play
@onready var menu_sounds = $"Menu Sounds"

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
		

func _on_play_pressed():
	menu_sounds.stream = confirm_SFX
	menu_sounds.play()
	get_tree().change_scene_to_file("res://scenes/world.tscn")


func _on_play_mouse_entered():
	menu_sounds.stream = hover_SFX
	menu_sounds.play()


func _on_options_pressed():
	pass # Replace with function body.


func _on_exit_pressed():
	get_tree().quit()
