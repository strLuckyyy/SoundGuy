extends CharacterBody2D

@onready var sprite = get_node("AnimatedSprite2D")

var speed = 45
var player_chase = false
var player = null

func _physics_process(delta):
	if player_chase and player:
		var dir = (player.global_position - global_position).normalized()
		var col = move_and_collide(dir * speed * delta)
		sprite.play("idle")
	else:
		sprite.play("idle")

func _on_area_2d_body_entered(body):
	if body.has_method("player"):
		player = body
		player_chase = true
	pass

func _on_area_2d_body_exited(body):
	player = null
	player_chase = false
	pass
