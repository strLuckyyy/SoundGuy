extends CharacterBody2D

@export var move_speed = 75

@onready var sprite = get_node("AnimatedSprite2D")

var input_direction: get = _get_input_direction
var sprite_direction = "down": get = _get_sprite_direction
@export var attacking = "no"
var can_attack

func _physics_process(_delta):
	velocity = input_direction * move_speed
	move_and_slide()
	set_animation("idleDown")
	
func set_animation(animation):
	if Input.is_action_just_pressed("attack") and attacking == "no":
		sprite.play("attack")
		attacking = "yes"
		await get_tree().create_timer(0.83).timeout
		_waveAttack()
		attacking = "no"
	if velocity != Vector2.ZERO and attacking ==  "no":
		animation = "walking"
		sprite.play("walk"+sprite_direction)
	elif velocity == Vector2.ZERO and attacking == "no":
		sprite.play("idle"+sprite_direction)

func _get_input_direction():
	var x = -int(Input.is_action_pressed("left")) + int(Input.is_action_pressed("right"))
	var y = -int(Input.is_action_pressed("up")) + int(Input.is_action_pressed("down"))
	input_direction = Vector2(x,y).normalized()
	return input_direction

func _get_sprite_direction():
	match input_direction:
		Vector2.LEFT:
			sprite_direction = "Left"
		Vector2.RIGHT:
			sprite_direction = "Right"
		Vector2.UP:
			sprite_direction = "Up"
		Vector2.DOWN:
			sprite_direction = "Down"
	return sprite_direction

func _waveAttack():
	$Wave/CollisionShape2D.disabled = false;
	$Wave/AnimatedSprite2D.visible = true;
	$Wave/AnimatedSprite2D.play("blast")
	await get_tree().create_timer(0.47).timeout
	$Wave/CollisionShape2D.disabled = true;
	$Wave/AnimatedSprite2D.visible = false;
