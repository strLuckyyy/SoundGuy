extends CharacterBody2D

@onready var sprite = get_node("AnimatedSprite2D")

var speed = 20
var player_chase = false
var motion = Vector2(0,0)
@onready var player = $"../../../Personagens/Herus/CharacterBody2D"


func _physics_process(delta: float) -> void:
	_idle()
	
func _idle():
	sprite.play("idle")

func _on_area_2d_body_entered(body):
	if body.has_method("player"):
		print("sim")
		motion = motion.move_toward(body.position,speed)
	pass
