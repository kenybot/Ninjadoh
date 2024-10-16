extends CharacterBody2D
@onready var animated_sprite_2d = $AnimatedSprite2D

#mob info
@export var SPEED = 15
var player_position
var target_position
@onready var flying_mob = $AnimatedSprite2D

@onready var player = get_parent().get_node("Character")
var health



func damage(attack: Attack):
	health -= attack.attack_damage
	
	if health <= 0:
		queue_free()
	
	velocity = (global_position - attack.attack_position).normalized()*attack.knockback_force


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


func _on_health_health_depleted():
	player.is_Alive = false
	print("DEAD")
	queue_free()

func _on_health_health_changed(diff):
	animated_sprite_2d.play("Hurt")
