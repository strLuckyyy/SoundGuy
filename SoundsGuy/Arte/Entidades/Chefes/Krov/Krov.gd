extends CharacterBody2D

class_name Boss

@onready var sprite = get_node("Vampiro")
@onready var projectileUp = get_node("punch_attack/attack_up/AnimatedSprite2D")
@onready var projectileDown = get_node("punch_attack/attack_down/AnimatedSprite2D")
@onready var projectileLeft = get_node("punch_attack/attack_left/AnimatedSprite2D")
@onready var projectileRight = get_node("punch_attack/attack_right/AnimatedSprite2D")

var sprite_direction = "Down"
var speed = 38
var player_chase = false
var player = null
var dead = false
var attacking = "no"
var angle = 0


func die():
	pass

func _physics_process(delta):
	if attacking == "no":
		if Input.is_action_pressed("kill vamp"):
			die()
		if player_chase == true:
			var dir = (player.global_position - global_position).normalized()
			var col = move_and_collide(dir * speed * delta)
			angle = dir.normalized().snapped(Vector2.ONE)
			var value = get_angle(angle)
			sprite_direction = get_direction(value)
			set_animation("walk")
		else:
			set_animation("idle")

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

func get_direction(angle):
	if angle == 0:
		return "Right"
	elif angle == 1:
		return "Down"
	elif angle == 2:
		return "Left"
	elif angle == 3:
		return "Up"

func set_animation(action):
	sprite.play(action+sprite_direction)

func _on_detection_body_entered(body):
	if body.is_in_group("Herus"):
		player = body
		player_chase = true
	pass

func _on_right_area_body_entered(body):
	if attacking == "no":
		print("right")
		$right_area/right_area.disabled = false
		$punch_attack/attack_right.disabled = false
		$punch_attack/attack_right/AnimatedSprite2D.visible = true
		projectileRight.play("default")
		punch_attack()
		$punch_attack/attack_right.disabled = false
		$punch_attack/attack_right/AnimatedSprite2D.visible = true
		$right_area/right_area.disabled = true

func _on_left_area_body_entered(body):
	if attacking == "no":
		$left_area/left_area.disabled = false
		$punch_attack/attack_left.disabled = false
		$punch_attack/attack_left/AnimatedSprite2D.visible = true
		projectileLeft.play("default")
		punch_attack()
		$punch_attack/attack_left.disabled = false
		$punch_attack/attack_left/AnimatedSprite2D.visible = true
		$left_area/left_area.disabled = true

func _on_down_area_body_entered(body):
	if attacking == "no":
		$down_area/down_area.disabled = false
		$punch_attack/attack_down.disabled = false
		$punch_attack/attack_down/AnimatedSprite2D.visible = true
		projectileDown.play("default")
		punch_attack()
		$punch_attack/attack_down.disabled = true
		$punch_attack/attack_down/AnimatedSprite2D.visible = false
		$down_area/down_area.disabled = true

func _on_up_area_body_entered(body):
	if attacking == "no":
		$up_area/up_area.disabled = false
		$punch_attack/attack_up.disabled = false
		$punch_attack/attack_up/AnimatedSprite2D.visible = true
		projectileUp.play("default")
		punch_attack()
		$punch_attack/attack_up.disabled = true
		$punch_attack/attack_up/AnimatedSprite2D.visible = false
		$up_area/up_area.disabled = true

func punch_attack():
	if attacking == "no":
		attacking = "yes"
		speed = 0
		sprite.play("attack"+sprite_direction)
		await get_tree().create_timer(0.3).timeout
		speed = 38
		attacking = "no"
