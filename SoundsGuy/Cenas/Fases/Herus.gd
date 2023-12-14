extends CharacterBody2D

var hurt = "no"
var enemy = null
@export var move_speed = 75
@onready var sprite = get_node("AnimatedSprite2D")
@export var roll_speed = 125
var input_direction= 0: get = _get_input_direction
var sprite_direction = "down": get = _get_sprite_direction
var last_direction = Vector2.ZERO
@export var busy = "no"
var rolling = "no"
var attacking = "no"
@export var vida = 5
var dead = "no"
var end = false

func _physics_process(_delta):
	_update_text()
	if end == true:
		sprite.play("dead")
		if Input.is_action_just_pressed("attack"):
			get_tree().reload_current_scene()
	elif dead == "no":
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
	elif dead == "yes":
		sprite.play("death")
		$Node2D/Background.stop()
		$Node2D/Death.play()
		await get_tree().create_timer(1).timeout
		end = true

func set_animation(animation):
	if dead == "no":
		if attacking == "no" and rolling == "no" and dead == "no":
			if Input.is_action_just_pressed("attack"):
				sprite.play("attack"+sprite_direction)
				_waveAttack()
			elif Input.is_action_just_pressed("roll"):
				sprite.play("roll"+sprite_direction)
				rolling = "yes"
				$Node2D/Roll.play()
				await get_tree().create_timer(0.65).timeout
				rolling = "no"
			elif velocity != Vector2.ZERO:
				sprite.play("walk"+sprite_direction)
			elif velocity == Vector2.ZERO:
				sprite.play("idle"+sprite_direction)

func _get_input_direction():
	if attacking == "no" and rolling == "no" and dead == "no":
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
	await get_tree().create_timer(0.45).timeout
	if sprite_direction == "Down":
		$Wave/CollisionDown.disabled = false;
		$Wave/CollisionDown/Sprite.visible = true;
		$Wave/CollisionDown/Sprite.play("blast")
		$Node2D/Attack.play()
		await get_tree().create_timer(0.29).timeout
		$Wave/CollisionDown.disabled = true;
		$Wave/CollisionDown/Sprite.visible = false;
	elif sprite_direction == "Up":
		$Wave/CollisionUp.disabled = false;
		$Wave/CollisionUp/Sprite.visible = true;
		$Wave/CollisionUp/Sprite.play("blast")
		$Node2D/Attack.play()
		await get_tree().create_timer(0.29).timeout
		$Wave/CollisionUp.disabled = true;
		$Wave/CollisionUp/Sprite.visible = false;
	elif sprite_direction == "Left":
		$Wave/CollisionLeft.disabled = false;
		$Wave/CollisionLeft/Sprite.visible = true;
		$Wave/CollisionLeft/Sprite.play("blast")
		$Node2D/Attack.play()
		await get_tree().create_timer(0.29).timeout
		$Wave/CollisionLeft.disabled = true;
		$Wave/CollisionLeft/Sprite.visible = false;
	elif sprite_direction == "Right":
		$Wave/CollisionRight.disabled = false;
		$Wave/CollisionRight/Sprite.visible = true;
		$Wave/CollisionRight/Sprite.play("blast")
		$Node2D/Attack.play()
		await get_tree().create_timer(0.2).timeout
		$Wave/CollisionRight.disabled = true;
		$Wave/CollisionRight/Sprite.visible = false;
	attacking = "no"

func _on_wave_body_entered(body):
	if body.is_in_group("Inimigos"):
		$Morcego/Death.play()
		body.queue_free()
	pass

func _on_enemy_collision_body_entered(body):
	if dead == "no" and hurt == "no":
		var angle = (body.global_position - global_position).normalized()
		if body.is_in_group("Morcego"):
			$Morcego/Bite.play()
			$Node2D/Hit.play()
			vida -= 1
			_push_hit(angle)
			if vida <= 0:
				dead = "yes"
			elif vida > 0:
				hurt = "yes"
				sprite.play("hurt"+sprite_direction)
				attacking = "yes"
				await get_tree().create_timer(0.2).timeout
				attacking = "no"
				await get_tree().create_timer(1).timeout
				hurt = "no"
		elif body.is_in_group("Chefes"):
			$Node2D/Hit.play()
			vida -= 1
			if vida <= 0:
				dead = "yes"
			elif vida > 0:
				hurt = "yes"
				sprite.play("hurt"+sprite_direction)
				attacking = "yes"
				await get_tree().create_timer(0.2).timeout
				attacking = "no"
				await get_tree().create_timer(1).timeout
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
	$Camera2D/Label.text = ("Vida:" + str(vida))
