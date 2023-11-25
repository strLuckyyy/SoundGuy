extends CharacterBody2D

@onready var sprite = get_node("AnimatedSprite2D")




func _physics_process(_delta):
	move_and_slide()
	_idle()

func _idle():
	sprite.play("idle")


func _on_area_2d_body_entered(body):
	if body.is_in_group("Herus"):
		get_tree().queue_delete(self)
	pass # Replace with function body.
