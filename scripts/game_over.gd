extends Control
@onready var game_over_sfx = $"GameOver SFX"
@onready var game_over_bgm = $"GameOver BGM"
@onready var player = get_node("/root/World/Save/Character")
var hover_SFX = preload("res://assets/SFX/001_Hover_01.wav")
var confirm_SFX = preload("res://assets/SFX/013_Confirm_03.wav")
@onready var total_distance_text: Label = $"Details/VBoxContainer/Total Distance"
@onready var character: CharacterBody2D = $"../../Save/Character"
var total_distance 

func _physics_process(delta: float) -> void:
	total_distance = abs(round(character.get_total_distance()))
	
	total_distance_text.text = "Total Distance Travelled: " + str(total_distance)

func _on_restart_mouse_entered():
	game_over_sfx.stream = hover_SFX
	game_over_sfx.play()

func _on_exit_mouse_entered():
	game_over_sfx.stream = hover_SFX
	game_over_sfx.play()


func _on_restart_pressed():
	game_over_sfx.stream = confirm_SFX
	game_over_sfx.play()
	get_tree().reload_current_scene()
	Engine.time_scale = 1


func _on_exit_pressed():
	game_over_sfx.stream = confirm_SFX
	game_over_sfx.play()
	get_tree().quit()
