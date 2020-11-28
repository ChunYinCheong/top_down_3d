extends "res://weapons/Weapon.gd"

func trigger_released():
	$Timer.start()
	pass

func _on_Timer_timeout():
	queue_free()
	var effect = preload("res://weapons/Explosion.tscn").instance()
	get_tree().current_scene.add_child(effect)
	effect.global_transform = global_transform
	pass # Replace with function body.
