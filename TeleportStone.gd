extends StaticBody

var activated = false
var charged = false
var progress = 0
var required = 9.0


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if charged:
		return
	if activated:
		progress += delta
		if progress >= required:
			charged = true
			$Particles.emitting = false
	elif progress > 0:
		progress -= delta	
	var c = 1 - progress / required
	$MeshInstance.material_override.albedo_color = Color(1,1,c)
	pass


func _on_Area_body_entered(body):
	if charged:
		return
	activated = true
	$Particles.emitting = true
	pass # Replace with function body.


func _on_Area_body_exited(body):
	if charged:
		return
	activated = false
	$Particles.emitting = false
	pass # Replace with function body.


func _on_Area2_body_entered(body):
	if charged:
		get_tree().change_scene("res://Main.tscn")
		pass
	pass # Replace with function body.
