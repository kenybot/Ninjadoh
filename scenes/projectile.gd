extends CharacterBody2D

@export var SPEED = 300


var dir : Vector2 = Vector2(0,0)
var spawnPos : Vector2 = Vector2(0,0)
var zdex : int


func _ready():
	global_position = spawnPos
	z_index = zdex
	print("Spawned at", global_position, "with direction: ", dir)
	
	
func _physics_procesas(delta):
	print("Projectine is moving. Current position: ", global_position)
#	var collision_info = move_and_collide(velocity.normalized() * delta * SPEED)
	global_position += dir * SPEED * delta

	# Optional: Destroy projectile when it goes off-screen or hits something
	if global_position.x < 0 or global_position.x > get_viewport_rect().size.x:
		print("Queueing free...")
		queue_free()


