extends CharacterBody2D


@onready var save_node = $".."

@onready var main = $".."
@onready var projectile = load("res://scenes/projectile.tscn")
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var current_SFX = $Current_SFX
@onready var game_over = $"../../CanvasLayer/GameOver"
@onready var world__1_bg_music = $"World #1 BG Music"
var game_over_bg = preload("res://assets/Background Music/16-Bit Starter Pack/Towns/Returning Home.ogg")
var low_hp = preload("res://assets/Background Music/16-Bit Starter Pack/Battle/Battle Mage.ogg")

#AUDIO SFX
var jump_audio = preload("res://assets/SFX/30_Jump_03.wav")
var run_audio = preload("res://assets/SFX/Grass Running.wav")
var land_audio = preload("res://assets/SFX/45_Landing_01.wav")
var fire_audio = preload("res://assets/SFX/03_Claw_03.wav")
#player info
@export var SPEED = 300
var is_Alive = true
var RUN_SPEED
const JUMP_VELOCITY = -400.0
@export var RUN_JUMP = -.8
@onready var animation = $Animation
@onready var mark = $MARK
@export var LEVEL = 1

var current_animation = "" # track the current animation


@onready var health_node = get_node("Health")
var health_value = 0
var isLeft = velocity.x < 0
var running: bool = false
var landing: bool = false
var impact_played: bool = false
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

#flags
var is_attacking = false
var is_teleporting = false
var total_distance = 0
var previous_pos = Vector2.ZERO

#START OF FUNCTIONS -----------------------------------------------------------------------------------------------
func _ready():
	print(health_value)

#	
func shoot():
	#handle sounds

	current_SFX.stream = fire_audio
	current_SFX.play()
	var instance = projectile.instantiate()
	var direction = Vector2(1, 0)
	if isLeft:
		direction = Vector2(-1, 0) 
	instance.dir = direction
	var offset = Vector2(30, -30) #value to offset
	if isLeft:
		offset.x = -offset.x

	instance.spawnPos = global_position + offset
	instance.dir = direction
#	instance.spawnRot = direction.angle()
	instance.zdex = z_index -1
	main.add_child.call_deferred(instance)
	
func teleport():
	global_position.x += abs(500)
	print("tped")

func play_animation(anim_name: String):
	if animated_sprite_2d.animation != anim_name:
		animated_sprite_2d.play(anim_name)
		current_animation = anim_name


func _physics_process(delta):
	health_value = health_node.get_health()
	
	#make sure that the RUN_SPEED is constantly being recalculated everytime SPEED CHANGES
	RUN_SPEED = (SPEED + (SPEED/2)) * 1.5
#
#	var current_pos = get_global_position()
#	var distance_traveled = current_pos.distance_to(previous_pos)
#	total_distance += distance_traveled
#	previous_pos = current_pos
#	print(total_distance)
#	if global_position.x >= 5000: 
#		RUN_SPEED += 900
#		mark.show()
#experimenting position-based functions
#	if Input.is_action_just_pressed("teleport"):
#		shoot()
	
	var input_direction = Input.get_axis("left", "right")
	velocity.x = input_direction * SPEED
	
	if input_direction < 0:
		isLeft = true
	elif input_direction > 0:
		isLeft = false
	
	if Input.is_action_pressed("sprint"):
		velocity.x = input_direction * RUN_SPEED

	if(velocity.x > 1 || velocity.x < -1):
		#if were running
		running = true
		#sound
		if !current_SFX.is_playing():
				current_SFX.volume_db = -15
				current_SFX.stream = run_audio
				current_SFX.play()
		if Input.is_action_pressed("sprint"):
			if(running == true):
				play_animation("Run")
		else:
			play_animation("Walk")
	else:
		running = false
		if is_on_floor() and velocity.y == 0:
			play_animation("Idle")
	
	#JUMP
	if((is_on_floor) and Input.is_action_just_pressed("jump") and global_position.y > 100):
		if Input.is_action_pressed("sprint"):
			velocity.y += abs(velocity.x) * RUN_JUMP #PROBLEM! -> FIXED BY ADDING abs
		else:
			velocity.y = JUMP_VELOCITY
			
			
		current_SFX.volume_db = 0
		current_SFX.stream = jump_audio
		current_SFX.play()
		play_animation("Jump")
			
	#HANDLING SFX LANDING
	if is_on_floor():
		if landing and !impact_played:
			current_SFX.volume_db = 0
			current_SFX.stream = land_audio
			current_SFX.play()
			landing = false
			impact_played = true
		else:
			if !landing:
				landing = true
	
	#HANDLING GRAVITY
	if not is_on_floor():
		impact_played = false
		velocity.y += gravity * delta
	
	
	
	#HANDLING FLIPPING CHARACTER WHEN TURNING LEFT
	var isLeft = velocity.x < 0
	animated_sprite_2d.flip_h = isLeft
	
	animation.text = animated_sprite_2d.animation
	move_and_slide()

#	print(Engine.get_frames_per_second())
	


func _on_button_pressed():
	SPEED = SPEED + 25



func _on_health_health_depleted():
	world__1_bg_music.stream = game_over_bg
	world__1_bg_music.volume_db = -5
	world__1_bg_music.play()
	
	Engine.time_scale = 0
	game_over.show() 
	print("PLAYER DEAD!")
	
	

func _on_health_health_changed(diff):
	
	world__1_bg_music.stream = low_hp
	world__1_bg_music.volume_db = 5
	world__1_bg_music.play()

var pos_array = []


func save():
	
	pos_array.append(position.x)
	pos_array.append(position.y)
	save_node.pos_dict[name] = pos_array
	save_node.hp_dict[name] = health_value
	save_node.save_game()

func update_pos(p):
	position = p

func update_hp(hp):
	health_value = hp
	health_node.set_health(health_value)
