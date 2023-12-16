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
var health = 6
var hurt = false

func die():
	dead = true
	sprite.stop()
	sprite.play("death")
	await get_tree().create_timer(1.6).timeout
	queue_free()

func _physics_process(delta):
	if attacking == "no" and hurt == false and dead == false:
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
		attacking = "yes"
		$punch_attack/attack_right.disabled = false
		$punch_attack/attack_right.visible = true
		$punch_attack/attack_right/AnimatedSprite2D.visible = true
		projectileRight.play("default")
		punch_attack()
		await get_tree().create_timer(0.3).timeout
		projectileRight.stop()
		$punch_attack/attack_right.disabled = false
		$punch_attack/attack_right.visible = false
		$punch_attack/attack_right/AnimatedSprite2D.visible = true
		laugh()
		attacking = "no"

func _on_left_area_body_entered(body):
	if attacking == "no":
		attacking = "yes"
		$punch_attack/attack_left.disabled = false
		$punch_attack/attack_left.visible = true
		$punch_attack/attack_left/AnimatedSprite2D.visible = true
		projectileLeft.play("default")
		punch_attack()
		await get_tree().create_timer(0.3).timeout
		projectileLeft.stop()
		$punch_attack/attack_left.disabled = false
		$punch_attack/attack_left.visible = false
		$punch_attack/attack_left/AnimatedSprite2D.visible = true
		laugh()
		attacking = "no"

func _on_down_area_body_entered(body):
	if attacking == "no":
		attacking = "yes"
		$punch_attack/attack_down.disabled = false
		$punch_attack/attack_down.visible = true
		$punch_attack/attack_down/AnimatedSprite2D.visible = true
		projectileDown.play("default")
		punch_attack()
		await get_tree().create_timer(0.3).timeout
		projectileDown.stop()
		$punch_attack/attack_down.disabled = true
		$punch_attack/attack_down.visible = false
		$punch_attack/attack_down/AnimatedSprite2D.visible = false
		laugh()
		attacking = "no"

func _on_up_area_body_entered(body):
	if attacking == "no":
		attacking = "yes"
		$punch_attack/attack_up.disabled = false
		$punch_attack/attack_up.visible = true
		$punch_attack/attack_up/AnimatedSprite2D.visible = true
		projectileUp.play("default")
		punch_attack()
		await get_tree().create_timer(0.3).timeout
		projectileUp.stop()
		$punch_attack/attack_up.disabled = true
		$punch_attack/attack_up.visible = false
		$punch_attack/attack_up/AnimatedSprite2D.visible = false
		laugh()
		attacking = "no"

func apply_damage(damage):
	health -= damage
	if health <= 0:
		die()
	else:
		hurt = true
		sprite.stop()
		set_animation("dmg")
		await get_tree().create_timer(0.3).timeout
		hurt = false

func punch_attack():
	speed = 0
	sprite.play("attack"+sprite_direction)
	speed = 38

func laugh ():
	attacking = "yes"
	sprite.stop()
	sprite.play("laugh")
	$Sound/Laugh.play()
	await get_tree().create_timer(1).timeout
	attacking = "no"
