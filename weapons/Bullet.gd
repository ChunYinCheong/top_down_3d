extends Spatial

var target_transform

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
#	translate(Vector3(0,0,-1*delta))
	translate_object_local(Vector3(0,0,-100*delta))
	if target_transform:
		var d = target_transform.origin - global_transform.origin
		if d.length() <= 100*delta:
			queue_free()
	pass


func _on_Timer_timeout():
	queue_free()
	pass # Replace with function body.
