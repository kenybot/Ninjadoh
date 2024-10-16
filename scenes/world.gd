extends Node2D
var ALICE_BLUE = Color(0.941176, 0.972549, 1, 1)
var MAX_MOBS = 1
var MOB_COUNT = 0

@onready var pause_menu = $Character/PauseMenu
@onready var character = $Character

var paused = false
# Called when the node enters the scene tree for the first time.

# Called every frame. 'delta' is the elapsed time since the previous frame.
   

func _ready():
	pass

func _physics_process(delta):
	if Input.is_action_just_pressed("pause"):
		pauseMenu()
	
func pauseMenu():
	if paused:
		pause_menu.hide()
		Engine.time_scale = 1 
	else:
		pause_menu.show()
		Engine.time_scale = 0
		
	paused = !paused

func spawn():
	for i in MAX_MOBS:
		var new_mob = preload("res://scenes/flying_demon.tscn").instantiate()
		%PathFollow2D.draw_circle(%PathFollow2D.global_position, 5.0, ALICE_BLUE)
		%PathFollow2D.progress_ratio = randf()
		new_mob.global_position = %PathFollow2D.global_position
		add_child(new_mob)
		MOB_COUNT += 1
		print(MOB_COUNT)


func _on_timer_timeout():
	if character.global_position.x > 4000 and MOB_COUNT < 5:
		spawn()
