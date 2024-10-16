extends CharacterBody2D

@onready var main = $"."


@onready var projectile = load("res://scenes/projectile.tscn")
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var current_SFX = $Current_SFX

var jump_audio = preload("res://assets/SFX/30_Jump_03.wav")
var run_audio = preload("res://assets/SFX/Grass Running.wav")
var land_audio = preload("res://assets/SFX/45_Landing_01.wav")
var fire_audio = preload("res://assets/SFX/03_Claw_03.wav")
#player info
@export var SPEED = 300
@export var RUN_SPEED = 800
const JUMP_VELOCITY = -400.0
@export var RUN_JUMP = -.8
@export var HEALTH = 5
@onready var animation = $Animation

var current_animation = "" # track the current animation


var isLeft = velocity.x < 0
var running: bool = false
var landing: bool = false
var impact_played: bool = false
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


#flags
var is_attacking = false
var is_teleporting = false


func shoot():
	#handle sounds

	current_SFX.stream = fire_audio
	current_SFX.play()
	
	var instance = projectile.instantiate()
	var direction = Vector2(1, 0)
	if isLeft:
		direction = Vector2(-1, 0) 
	instance.dir = direction.angle()
	var offset = Vector2(30, -30) #value to offset
	
	if isLeft:
		offset.x = -offset.x
	
	instance.spawnPos = global_position + offset
	instance.spawnRot = instance.dir
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
	if Input.is_action_just_pressed("teleport"):
		shoot()
	
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
#		if !current_SFX.is_playing():
#				current_SFX.volume_db = -15
#				current_SFX.stream = run_audio
#				current_SFX.play()
		if Input.is_action_pressed("sprint"):
			if(running == true):
				play_animation("Run")
		else:
			
			play_animation("Walk")
	else:
		running = false
		if is_on_floor() and velocity.y == 0:
			play_animation("Idle")
	
#	if((velocity.x == 0 ) && (velocity.y == 0)):
#		running = false
#		if not animated_sprite_2d.is_playing():
#			play_animation("Idle")
#		if animated_sprite_2d.animation != "Idle":
#			animated_sprite_2d.play("Idle")
	
	#jump
	if((is_on_floor) and Input.is_action_just_pressed("jump") and global_position.y > 100):
		if Input.is_action_pressed("sprint"):
			velocity.y += abs(velocity.x) * RUN_JUMP #PROBLEM! -> FIXED BY ADDING abs
		else:
			velocity.y += JUMP_VELOCITY
		current_SFX.volume_db = 0
		current_SFX.stream = jump_audio
		current_SFX.play()
		play_animation("Jump")
#		if(is_on_floor):
#			landing_audio.play()
			
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
	
	
	if not is_on_floor():
		impact_played = false
		velocity.y += gravity * delta
		
	
	#attacking
#
#	if Input.is_action_just_pressed("attack"):
#		is_attacking = true
#		play_animation("Attack")
	
	
	#handles left  dir
	var isLeft = velocity.x < 0
	animated_sprite_2d.flip_h = isLeft
	
#	print(position)
	#handle tp
#	if Input.is_action_just_pressed("teleport"):
#		is_teleporting = true
#		play_animation("Teleport")
#		teleport()


	animation.text = animated_sprite_2d.animation
		
	move_and_slide()
#	print(Engine.get_frames_per_second())
	
