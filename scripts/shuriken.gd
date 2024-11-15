
extends Area2D
var travelled_distance = 0
@onready var animation_player: AnimationPlayer = $"01/AnimationPlayer"
@onready var shuriken_object: Sprite2D = $"01"

func _physics_process(delta: float):
	animation_player.play("Spinning")
	const SPEED = 1500
	const RANGE = 1500
	const ROTATION_SPEED = 720

	
	var direction = Vector2.RIGHT.rotated(rotation)
	position += direction * SPEED * delta
	travelled_distance += SPEED * delta
	
	shuriken_object.rotation += deg_to_rad(ROTATION_SPEED * delta)
	if travelled_distance > RANGE:
		queue_free()
