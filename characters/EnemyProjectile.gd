extends Area


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	translate_object_local(Vector3(0,0,-10*delta))
	pass


func _on_EnemyProjectile_body_entered(body):
	if body.has_method("hit_by_projectile"):
		body.hit_by_projectile(100)
		pass
	queue_free()
	pass # Replace with function body.


func _on_Timer_timeout():
	queue_free()
	pass # Replace with function body.
