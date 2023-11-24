extends CharacterBody2D

var state_machine

@export var speed = 30
@export var friction = 0.4
@export var accelerate = 0.4

@export var tree: AnimationTree = null

func ready():
	state_machine = tree['parameters/playback']


func move():
	var getMove = Vector2(
		Input.get_axis('left', 'right'),
		Input.get_axis('up', 'down')
	)
	velocity = getMove * speed
	
	if getMove != Vector2.ZERO:
		tree['parameters/move/blend_position'] = getMove
		
		velocity.x = lerp(velocity.x, getMove.normalized().x * speed, accelerate)
		velocity.y = lerp(velocity.y, getMove.normalized().y * speed, accelerate)
		return
	
	velocity.x = lerp(velocity.x, getMove.normalized().x * speed, friction)
	velocity.x = lerp(velocity.y, getMove.normalized().y * speed, friction)


func animation() -> void:
	ready()
	if velocity.length() > 2:
		state_machine.travel('move')
		return
	pass


func _process(_delta):
	move()
	animation()
	move_and_slide()
