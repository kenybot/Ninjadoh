extends CanvasLayer
@onready var upgrade_sfx = $"Upgrade SFX"
var hover_SFX = preload("res://assets/SFX/001_Hover_01.wav")




func _on_button_mouse_entered():
	upgrade_sfx.stream = hover_SFX
	upgrade_sfx.play()


func _on_button_2_mouse_entered():
	upgrade_sfx.stream = hover_SFX
	upgrade_sfx.play()



