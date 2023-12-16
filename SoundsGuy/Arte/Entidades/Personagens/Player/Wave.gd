extends Area2D

class_name Enemy
var wave_damage = 1

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body:Node2D) -> void:
	if body is Bat:
		body.die()
	elif body is Reaper:
		body.apply_damage(wave_damage)
