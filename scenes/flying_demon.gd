extends CharacterBody2D

#mob info
@export var SPEED = 15
@export var HEALTH = 2
var player_position
var target_position
@onready var flying_mob = $AnimatedSprite2D

@onready var player = get_parent().get_node("Character")



func _physics_process(delta):
	
	player_position = player.position
	target_position = (player_position - position).normalized()
	
	if position.distance_to(player_position) > 3:
		move_and_collide(target_position * SPEED)
#		look_at(player_position)

	#handles which way the mob is facing
	
	
	if target_position.x < 0:
		flying_mob.flip_h = false
	else:
		flying_mob.flip_h = true
