extends Control

@onready var main = $"../../.."
@onready var pause_sounds = $"Pause Sounds"
@onready var save_node = $"../.."
@onready var character = $"../../Save/Character"

var hover_SFX = preload("res://assets/SFX/001_Hover_01.wav")
var confirm_SFX = preload("res://assets/SFX/013_Confirm_03.wav")
@onready var settings = $Settings

var settings_visible = false


func _on_exit_pressed():
	pause_sounds.stream = confirm_SFX
	pause_sounds.play()
	get_tree().quit()


func _on_exit_mouse_entered():
	pause_sounds.stream = hover_SFX
	pause_sounds.play()
	




func _on_continue_pressed():
	pause_sounds.stream = confirm_SFX
	pause_sounds.play()
	main.pauseMenu()


func _on_continue_mouse_entered():
	pause_sounds.stream = hover_SFX
	pause_sounds.play()
	


func _on_options_pressed():
	pause_sounds.stream = confirm_SFX
	pause_sounds.play()
	
	#if the settings is currently not shown
	if(settings_visible == false):
		settings.show()
		settings_visible = true
	else:
		settings.hide()
		settings_visible = false



func _on_options_mouse_entered():
	pause_sounds.stream = hover_SFX
	pause_sounds.play()


func _on_save_mouse_entered():
	pause_sounds.stream = hover_SFX
	pause_sounds.play()
	

func _on_save_pressed():
	pause_sounds.stream = confirm_SFX
	pause_sounds.play()
	character.save()
	
