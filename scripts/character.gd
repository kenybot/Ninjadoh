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
var attack_audio = preload("res://assets/SFX/22_Slash_04.wav")
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
@export var MAX_JUMP_COUNTS = 1
var JUMP_COUNT = 0
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
var distance_traveled 
var previous_pos = Vector2.ZERO
var current_pos 
var total_distance = 0

var plus_shuriken = false
#START OF FUNCTIONS -----------------------------------------------------------------------------------------------
func _ready():
	print(health_value)
	
func get_current_speed():
	return SPEED

func add_current_speed(int):
	SPEED += int

func get_max_jump():
	return MAX_JUMP_COUNTS

func add_max_jump(int):
	MAX_JUMP_COUNTS += int

func set_plus_shuriken(bool):
	plus_shuriken = bool

func shoot():
	
	current_SFX.stream = attack_audio
	current_SFX.play()
	
	const SHURIKEN = preload("res://scenes/shuriken.tscn")
	
	var new_shuriken = SHURIKEN.instantiate()
	var shuriken_point = $ShurikenPoint
	
	
	if shuriken_point and new_shuriken:
		new_shuriken.global_position = shuriken_point.global_position
		new_shuriken.global_rotation = shuriken_point.global_rotation
		
		get_parent().add_child(new_shuriken)
	else:
		print("Error: shuriken spawn point or projectile instantiation failed")
	if plus_shuriken == true:
		var new_shuriken2 = SHURIKEN.instantiate()
		var shuriken_point2 = $ShurikenPoint2
		if shuriken_point2 and new_shuriken2:
			new_shuriken2.global_position = shuriken_point2.global_position
			new_shuriken2.global_rotation = shuriken_point2.global_rotation
			
			get_parent().add_child(new_shuriken2)
		else:
			print("Error: shuriken spawn point or projectile instantiation failed2")
	
func teleport():
	
	global_position.x += abs(500)
	print("tped")

func play_animation(anim_name: String):
	if animated_sprite_2d.animation != anim_name:
		animated_sprite_2d.play(anim_name)
		current_animation = anim_name


func get_total_distance():
	return abs(total_distance)

func _physics_process(delta):
	
	current_pos = get_global_position()
	
	if current_pos.x > previous_pos.x:
		distance_traveled = current_pos.distance_to(previous_pos)
		total_distance = total_distance + distance_traveled
	previous_pos = current_pos

	
	#distance = speed x time

	health_value = health_node.get_health()
	
	#make sure that the RUN_SPEED is constantly being recalculated everytime SPEED CHANGES
	RUN_SPEED = (SPEED + (SPEED/2)) * 1.5

	var input_direction = Input.get_axis("left", "right")
	velocity.x = input_direction * SPEED
	
	if input_direction < 0:
		isLeft = true
	elif input_direction > 0:
		isLeft = false
		
	if Input.is_action_just_pressed("teleport"):
		
		shoot()
		
	
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
	if((is_on_floor) and Input.is_action_just_pressed("jump") and (JUMP_COUNT < MAX_JUMP_COUNTS)):
		if Input.is_action_pressed("sprint"):
			velocity.y += abs(velocity.x) * RUN_JUMP #PROBLEM! -> FIXED BY ADDING abs
		else:
			velocity.y = JUMP_VELOCITY
		
		#everytime we jump we increment the JUMP-COUNT
		
		JUMP_COUNT += 1
		current_SFX.volume_db = 0
		current_SFX.stream = jump_audio
		current_SFX.play()
		play_animation("Jump")
			
	#HANDLING SFX LANDING
	if is_on_floor():
		JUMP_COUNT = 0 #set the jump count back to 0
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


	


func _on_button_pressed():
	SPEED = SPEED + 25



func _on_health_health_depleted():

	
	world__1_bg_music.stream = game_over_bg
	world__1_bg_music.volume_db = -5
	world__1_bg_music.play()
	
	Engine.time_scale = 0
	game_over.show() 
	
	
	

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
