extends CharacterBody2D
@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var audio_stream_player_2d = $AudioStreamPlayer2D
var death = preload("res://assets/SFX/69_Enemy_death_01.wav")
var flying_mobs_killed = 0
@export var SPEED = 2
var player_position
var target_position
var is_dead = false
@onready var flying_mob = $AnimatedSprite2D
@onready var death_timer: Timer = $"death timer"

@onready var player = get_parent().get_node("Save/Character")
var health
@onready var label: Label = $Label
var demon_count = 0
var bounce_force = 300
func damage(attack: Attack):
	health -= attack.attack_damage
	if health <= 0:
		is_dead = true
		velocity = Vector2.ZERO
		
		audio_stream_player_2d.stream = death
		audio_stream_player_2d.play()
		play_death_sfx()
	
	velocity = (global_position - attack.attack_position).normalized()*attack.knockback_force
	await get_tree().create_timer(0.5).timeout 
	queue_free()

var rng = RandomNumberGenerator.new()

func _ready():
	var random_number = rng.randf_range(0,100)
	label.text = "Mob #" + str(round(random_number))
	

func _physics_process(delta):
	flying_mobs_killed = flying_mobs_killed
	if is_dead:
		return

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
	
	#handles if mob hit the ground.
	if is_on_floor() and velocity.y > 0:
		velocity.y = -bounce_force
		

func _on_health_health_depleted():
	player.is_Alive = false
	#queue_free()
	
func get_mobs_killed():
	return flying_mobs_killed
	
func _on_health_health_changed(diff):
	play_death_sfx()
	animated_sprite_2d.play("Hurt")


func play_death_sfx():
	audio_stream_player_2d.stream = death
	audio_stream_player_2d.play()
	
	death_timer.wait_time = 0.1
	death_timer.start()
	




func _on_death_timer_timeout() -> void:
	queue_free()
