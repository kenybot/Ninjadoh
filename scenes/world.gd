extends Node2D
var ALICE_BLUE = Color(0.941176, 0.972549, 1, 1)

var mobs = 1
@onready var world_sfx = $Save/Character/World_SFX
@onready var pause_menu = $Pause/PauseMenu
@onready var character = $Save/Character
var original_color = Color(.39,.39,.35,1.0)
var white = Color(1.0,1.0,1.0,1.0)
@onready var tips = $Tips
@onready var parallax_background_dark_: ParallaxBackground = $"ParallaxBackground(DARK)"
@onready var parallax_background: ParallaxBackground = $ParallaxBackground

var pause_SFX = preload("res://assets/SFX/092_Pause_04.wav")
var unpause_SFX = preload("res://assets/SFX/098_Unpause_04.wav")
@onready var announcement: Label = $Save/Character/Announcement

@onready var total_distance_label: Label = $Position/Total_Distance
@onready var upgrade: Control = $"Health Bar_Upgrade/UPGRADE"
@onready var plus_shuriken: Control = $"Health Bar_Upgrade/+1Shuriken"

var paused = false
var check_done = false
var check_done_two = false #second round of upgrade
var check_done_shu = false
var check_done_three = false


func _physics_process(delta):
	var max_jump = character.get_max_jump()
	var total_distance = round(character.get_total_distance())
	total_distance_label.text = "Total Distance: " + str(total_distance)
	if Input.is_action_just_pressed("pause"):
		tips.visible = !tips.visible
		pauseMenu()
		
	if total_distance > 10000 and check_done == false:
		print("upgrade available")
		upgrade.visible = true
		check_done = true
	
	if total_distance > 20000 and check_done_shu == false:
		print("+shuriken ready")
		plus_shuriken.visible = true
		check_done_shu = true
	
	if total_distance > 25000 and check_done_two == false:
		upgrade.visible = true
		check_done_two = true
	
	if total_distance > 32000 and check_done_three == false:
		upgrade.visible = true
		check_done_three = true
		
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
		


func _on_light_pressed() -> void:
	parallax_background.visible = true
	parallax_background_dark_.visible = false
	total_distance_label.set("theme_override_colors/font_color", original_color)

func _on_dark_pressed() -> void:
	parallax_background.visible = false
	parallax_background_dark_.visible = true
	total_distance_label.set("theme_override_colors/font_color", white)
	


func _on_plus_jump_pressed() -> void:
	character.add_max_jump(1)
	announcement.text = "+MAXJUMP!"
	upgrade.visible = false
	await get_tree().create_timer(3.0).timeout
	announcement.text = ""
	
	
func _on_speed_pressed() -> void:
	character.add_current_speed(50)
	announcement.text = "+SPEED!"
	upgrade.visible = false
	await get_tree().create_timer(3.0).timeout
	announcement.text = ""
	


func _on_1_shuriken_button_pressed() -> void:
	announcement.text = "+SHURIKEN!"
	plus_shuriken.visible = false
	character.set_plus_shuriken(true) #signaling the character to have the 2nd weapon on
	await get_tree().create_timer(3.0).timeout
	announcement.text = ""
