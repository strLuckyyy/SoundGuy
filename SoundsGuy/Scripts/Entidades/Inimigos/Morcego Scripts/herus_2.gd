extends CharacterBody2D

class_name Herus

var hurt = "no"
var enemy = null
@export var move_speed = 75
@onready var sprite = get_node("Protagonista")
@export var roll_speed = 125
var input_direction= 0: get = _get_input_direction
var sprite_direction = "Down": get = _get_sprite_direction
var last_direction = Vector2.ZERO
@export var busy = "no"
var rolling = "no"
var attacking = "no"
@export var health = 5
var dead = false
var end = false
var damage = 1

func _physics_process(_delta):
	_update_text()
	if end == true:
		sprite.play("dead")
		$EnemyCollision/EnemyCollision.disabled = true
		if Input.is_action_just_pressed("attack"):
			get_tree().reload_current_scene()
	elif dead == false:
		move_and_slide()
		if attacking == "no" and rolling == "no":
			velocity = input_direction * move_speed
			set_animation("idleDown")
		elif rolling == "yes":
			move_speed = roll_speed
			velocity = last_direction * move_speed
			await get_tree().create_timer(0.62).timeout
			move_speed = 75
		elif attacking == "yes":
			velocity = Vector2.ZERO
	elif dead == true:
		sprite.play("death")
		$Sounds/Background.stop()
		$Sounds/Death.play()
		await get_tree().create_timer(0.5).timeout
		end = true
		dead = false

func set_animation(animation):
	if dead == false:
		if attacking == "no" and rolling == "no" and dead == false:
			if Input.is_action_just_pressed("attack"):
				sprite.play("attack"+sprite_direction)
				_waveAttack()
			elif Input.is_action_just_pressed("roll"):
				sprite.play("roll"+sprite_direction)
				rolling = "yes"
				$Sounds/Roll.play()
				await get_tree().create_timer(0.65).timeout
				rolling = "no"
			elif velocity != Vector2.ZERO:
				sprite.play("walk"+sprite_direction)
			elif velocity == Vector2.ZERO:
				sprite.play("idle"+sprite_direction)

func _get_input_direction():
	if attacking == "no" and rolling == "no" and dead == false:
		var x = -int(Input.is_action_pressed("left")) + int(Input.is_action_pressed("right"))
		var y = -int(Input.is_action_pressed("up")) + int(Input.is_action_pressed("down"))
		input_direction = Vector2(x,y).normalized()
		if input_direction != Vector2.ZERO:
			last_direction = input_direction
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
	attacking = "yes"
	await get_tree().create_timer(0.3).timeout
	if sprite_direction == "Down":
		$Wave/CollisionDown.disabled = false;
		$Wave/CollisionDown/Sprite.visible = true;
		$Wave/CollisionDown/Sprite.play("blast")
		$Sounds/Attack.play()
		await get_tree().create_timer(0.29).timeout
		$Wave/CollisionDown.disabled = true;
		$Wave/CollisionDown/Sprite.visible = false;
	elif sprite_direction == "Up":
		$Wave/CollisionUp.disabled = false;
		$Wave/CollisionUp/Sprite.visible = true;
		$Wave/CollisionUp/Sprite.play("blast")
		$Sounds/Attack.play()
		await get_tree().create_timer(0.29).timeout
		$Wave/CollisionUp.disabled = true;
		$Wave/CollisionUp/Sprite.visible = false;
	elif sprite_direction == "Left":
		$Wave/CollisionLeft.disabled = false;
		$Wave/CollisionLeft/Sprite.visible = true;
		$Wave/CollisionLeft/Sprite.play("blast")
		$Sounds/Attack.play()
		await get_tree().create_timer(0.29).timeout
		$Wave/CollisionLeft.disabled = true;
		$Wave/CollisionLeft/Sprite.visible = false;
	elif sprite_direction == "Right":
		$Wave/CollisionRight.disabled = false;
		$Wave/CollisionRight/Sprite.visible = true;
		$Wave/CollisionRight/Sprite.play("blast")
		$Sounds/Attack.play()
		await get_tree().create_timer(0.29).timeout
		$Wave/CollisionRight.disabled = true;
		$Wave/CollisionRight/Sprite.visible = false;
	attacking = "no"

func _on_enemy_collision_body_entered(body):
	if dead == false and hurt == "no":
		var source = body
		if source.is_in_group("Morcego") or source.is_in_group("Chefes") or source.is_in_group("Ceifeiro"):
			apply_damage(damage,source)
			
func apply_damage(damage,source):
	health -= damage
	$Sounds/Hit.play()
	var angle = (source.global_position - global_position).normalized()
	_push_hit(angle)
	if health <= 0:
		dead = true
	elif health > 0:
		hurt = "yes"
		sprite.play("dmg"+sprite_direction)
		attacking = "yes"
		await get_tree().create_timer(0.4).timeout
		attacking = "no"
		await get_tree().create_timer(0.3).timeout
		hurt = "no"

func _push_hit(angle):
	velocity = -angle * 400
	await get_tree().create_timer(0.01).timeout
	velocity = -angle * 600
	await get_tree().create_timer(0.03).timeout
	velocity = -angle * 800
	await get_tree().create_timer(0.03).timeout
	velocity = -angle * 400
	await get_tree().create_timer(0.03).timeout

func _update_text():
	$Camera2D/Label.text = ("Vida:" + str(health))

