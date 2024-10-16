extends Control

@onready var main = $"../../"
@onready var pause_sounds = $"Pause Sounds"

var hover_SFX = preload("res://assets/SFX/001_Hover_01.wav")
var confirm_SFX = preload("res://assets/SFX/013_Confirm_03.wav")
@onready var settings = $Settings

var settings_on = false

func _on_continue_pressed():
	pause_sounds.stream = confirm_SFX
	pause_sounds.play()
	main.pauseMenu()


func _on_exit_pressed():
	pause_sounds.stream = confirm_SFX
	pause_sounds.play()
	get_tree().quit()



func _on_continue_mouse_entered():
	pause_sounds.stream = hover_SFX
	pause_sounds.play()
	


func _on_options_mouse_entered():
	pause_sounds.stream = hover_SFX
	pause_sounds.play()
	


func _on_exit_mouse_entered():
	pause_sounds.stream = hover_SFX
	pause_sounds.play()


func _on_options_pressed():
	settings_on = true
	pause_sounds.stream = confirm_SFX
	pause_sounds.play()
	
	if(!settings_on == false):
		
		settings.show()
	else:
		settings.hide()
