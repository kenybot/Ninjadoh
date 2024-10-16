extends CanvasLayer

@onready var character = get_parent().get_node("Character")

@onready var pos = $MarginContainer/VBoxContainer/POS
@onready var fps = $MarginContainer/VBoxContainer/FPS
@onready var vel = $MarginContainer/VBoxContainer/VEL



func _physics_process(delta):
	
	var character_position = round(character.position)
	var character_vel = round(character.velocity)
	
	pos.text = "Pos" + str(character_position)
	fps.text = "FPS" + "(" +str(Engine.get_frames_per_second()) + ")"
	vel.text = "VEL" + str(character_vel)
		
