extends CharacterBody2D
@onready var animated_sprite_2d = $AnimatedSprite2D


@export var SPEED = 300
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	var input_direction = Input.get_axis("left", "right")
	velocity.x = input_direction * SPEED
	
	if(velocity.x > 1 || velocity.x < -1):
		animated_sprite_2d.play("Run")
	
	
	if((velocity.x == 0 ) && (velocity.y == 0)):
		animated_sprite_2d.play("Idle")
	
	move_and_slide()
	
	var isLeft = velocity.x < 0
	animated_sprite_2d.flip_h = isLeft
	

