extends CharacterBody2D

class_name Bat

@onready var sprite = get_node("Morcego")

var sprite_direction = "Down"
var speed = 45
var player_chase = false
var player = null
var dead = false
var angle = 0
var attacking = "no"
var out_dir = 0
var delta_out
var health = 1
var hurt = false

func _physics_process(delta):
	if Input.is_action_pressed("kill bats"):
		die()
	if player_chase and player and dead == false and hurt == false:
		var dir = (player.global_position - global_position).normalized()
		var col = move_and_collide(dir * speed * delta)
		angle = dir.normalized().snapped(Vector2.ONE)
		var value = get_angle(angle)
		sprite_direction = get_direction(value)
		out_dir = dir
		delta_out = delta
		set_animation("idle")

func get_direction(angle):
	if angle == 0:
		return "Right"
	elif angle == 1:
		return "Down"
	elif angle == 2:
		return "Left"
	elif angle == 3:
		return "Up"

func get_angle(dir: Vector2) -> int:
	match dir:
		Vector2(1, 0):
			return 0
		Vector2(0 ,1):
			return 1
		Vector2(1 ,1):
			return 1
		Vector2(-1,0):
			return 2
		Vector2(-1,1):
			return 1
		Vector2(-1,-1):
			return 3
		Vector2(0,-1):
			return 3
		Vector2(1,-1):
			return 3
	return 3

func _on_detection_area_body_entered(body):
	if body.is_in_group("Herus"):
		player = body
		player_chase = true
	pass

func _on_detection_area_body_exited(player):
	player = null
	player_chase = false
	pass

func set_animation(action):
	sprite.play(action+sprite_direction)

func attack():
	speed = 100
	$Sounds/Bite.play()
	set_animation("attack")
	await get_tree().create_timer(0.2).timeout
	speed = 45

func _on_attack_area_body_entered(body):
	if body == player:
		attack() 

func die():
	dead = true
	sprite.stop()
	sprite.play("death")
	$Sounds/Death.play()
	await get_tree().create_timer(0.3).timeout
	queue_free()

func apply_damage(damage):
	health -= damage
	if health <= 0:
		die()
	else:
		hurt = true
		sprite.stop()
		set_animation("hurt")
		await get_tree().create_timer(0.3).timeout
		hurt = false
