extends CharacterBody2D

@onready var sprite = get_node("CollisionShape2D/AnimatedSprite2D")

var sprite_direction = "Down"
var speed = 45
var player_chase = false
var player = null
var dead = false

func _physics_process(delta):
	if player_chase and player:
		var dir = (player.global_position - global_position).normalized()
		var col = move_and_collide(dir * speed * delta)
		match dir:
			Vector2.LEFT:
				sprite_direction = "Left"
				print('left')
			Vector2.RIGHT:
				sprite_direction = "Right"
				print('right')
			Vector2.UP:
				sprite_direction = "Up"
				print("up")
			Vector2.DOWN:
				sprite_direction = "Down"
				print('down')
		set_animation("move",sprite_direction)
	else:
		set_animation("idle",sprite_direction)
	
func set_animation(move,sprite_direction):
	sprite.play(move+sprite_direction)

func _on_detection_body_entered(body):
	if body.has_method("player"):
		player = body
		player_chase = true
	pass

func _on_detection_body_exited(body):
	player = null
	player_chase = false
	pass
