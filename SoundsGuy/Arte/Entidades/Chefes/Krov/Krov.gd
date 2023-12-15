extends CharacterBody2D

@onready var sprite = get_node("CollisionShape2D/AnimatedSprite2D")

var sprite_direction = "Down"
var speed = 38
var player_chase = false
var player = null
var dead = false
var attacking = "no"

func _kill_switch():
	self.queue_free()

func _physics_process(delta):
	if Input.is_action_pressed("kill vamp"):
		_kill_switch()
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
	if body.is_in_group("Herus"):
		player = body
		player_chase = true
	pass

func _on_right_area_body_entered(body):
	if speed > 0 and attacking == "no":
		attacking = "yes"
		speed = 0
		$right_area/right_area.disabled = false
		sprite.play("punchRight")
		await get_tree().create_timer(0.4).timeout
		$right_area/right_area.disabled = true
		speed = 38
		attacking = "no"

func _on_left_area_body_entered(body):
	if speed > 0 and attacking == "no":
		attacking = "yes"
		speed = 0
		$left_area/left_area.disabled = false
		sprite.play("punchLeft")
		await get_tree().create_timer(0.4).timeout
		$left_area/left_area.disabled = true
		speed = 38
		attacking = "no"

func _on_down_area_body_entered(body):
	if speed > 0 and attacking == "no":
		attacking = "yes"
		speed = 0
		$down_area/down_area.disabled = false
		sprite.play("punchDown")
		await get_tree().create_timer(0.4).timeout
		$down_area/down_area.disabled = true
		speed = 38
		attacking = "no"

func _on_up_area_body_entered(body):
	if speed > 0 and attacking == "no":
		attacking = "yes"
		speed = 0
		$up_area/up_area.disabled = false
		sprite.play("punchUp")
		await get_tree().create_timer(0.4).timeout
		$up_area/up_area.disabled = true
		speed = 38
		attacking = "no"
