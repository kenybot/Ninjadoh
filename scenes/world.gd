extends Node2D
var ALICE_BLUE = Color(0.941176, 0.972549, 1, 1)

var mobs = 1
@onready var world_sfx = $Save/Character/World_SFX
@onready var pause_menu = $Save/Character/PauseMenu
@onready var character = $Save/Character



var pause_SFX = preload("res://assets/SFX/092_Pause_04.wav")
var unpause_SFX = preload("res://assets/SFX/098_Unpause_04.wav")


var paused = false

func _physics_process(delta):
	if Input.is_action_just_pressed("pause"):
		pauseMenu()
	
func pauseMenu():
	if paused:
		world_sfx.stream = pause_SFX
		world_sfx.play()
		pause_menu.hide()
		Engine.time_scale = 1 
	else:
		world_sfx.stream = unpause_SFX
		world_sfx.play()
		pause_menu.show()
		Engine.time_scale = 0
		
	paused = !paused

func spawn(mobs):
	for i in mobs:
		var new_mob = preload("res://scenes/flying_demon.tscn").instantiate()
		%PathFollow2D.draw_circle(%PathFollow2D.global_position, 5.0, ALICE_BLUE)
		%PathFollow2D.progress_ratio = randf()
		new_mob.global_position = %PathFollow2D.global_position
		add_child(new_mob)
		
func spawn_harder(mobs):
	for i in mobs:
		var new_mob = preload("res://scenes/flying_demon.tscn").instantiate()
		new_mob.SPEED = 5
		%PathFollow2D.draw_circle(%PathFollow2D.global_position, 5.0, ALICE_BLUE)
		%PathFollow2D.progress_ratio = randf()
		new_mob.global_position = %PathFollow2D.global_position
		add_child(new_mob)

func spawn_hardest(mobs):
	for i in mobs:
		var new_mob = preload("res://scenes/flying_demon.tscn").instantiate()
		new_mob.SPEED = 8
		%PathFollow2D.draw_circle(%PathFollow2D.global_position, 5.0, ALICE_BLUE)
		%PathFollow2D.progress_ratio = randf()
		new_mob.global_position = %PathFollow2D.global_position
		add_child(new_mob)
		
func _on_timer_timeout():
	if character.global_position.x > 4000 and character.global_position.x < 10000:
		character.SPEED += 5
		spawn(1)
	elif(character.global_position.x > 10000 and character.global_position.x < 25000):
		character.SPEED += 10
		spawn(2)
	elif(character.global_position.x > 25000 and character.global_position.x < 35000):
		character.SPEED += 15
		spawn_harder(3)
	elif(character.global_position.x > 35000 and character.global_position.x < 45000):
		character.SPEED += 20
		spawn_hardest(4)
	elif(character.global_position.x > 45000):
		spawn_hardest(5)


