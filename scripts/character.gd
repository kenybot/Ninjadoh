extends CharacterBody2D
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var current_SFX = $Current_SFX

var jump_audio = preload("res://assets/SFX/30_Jump_03.wav")
var run_audio = preload("res://assets/SFX/Grass Running.wav")
var land_audio = preload("res://assets/SFX/45_Landing_01.wav")


@export var SPEED = 300
@export var RUN_SPEED = 800
const JUMP_VELOCITY = -400.0
@export var RUN_JUMP = -1

var running: bool = false
var landing: bool = false
var impact_played: bool = false
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	var input_direction = Input.get_axis("left", "right")
	velocity.x = input_direction * SPEED
	
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
			animated_sprite_2d.play("Run")
		else:
			
			animated_sprite_2d.play("Walk")
	
	
	
	if((velocity.x == 0 ) && (velocity.y == 0)):
		running = false
		animated_sprite_2d.play("Idle")
	
	#jump
	if((is_on_floor) && Input.is_action_just_pressed("jump")):
		if Input.is_action_pressed("sprint"):
			velocity.y += (velocity.x * RUN_JUMP )
		else:
			velocity.y += JUMP_VELOCITY
		current_SFX.volume_db = 0
		current_SFX.stream = jump_audio
		current_SFX.play()
		animated_sprite_2d.play("Jump")
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
		
	
	move_and_slide()
	
	#handles left 
	var isLeft = velocity.x < 0
	animated_sprite_2d.flip_h = isLeft
	
	print(position)

