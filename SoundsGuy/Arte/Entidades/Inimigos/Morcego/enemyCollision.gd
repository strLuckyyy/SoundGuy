extends Area2D

@onready var sprite = get_node("Morcego")

func _ready():
	pass

func _process(delta):
	
	pass

func _on_body_entered(body):
	if body.is_in_group("Attack"):
		_die()

func _die():
	self.queue_free()
	pass
