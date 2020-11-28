extends "res://characters/Character.gd"

var is_player_in_range = false
var attack_charge = 0


func hit_by_bullet(damage):
	health -= damage
	if health <= 0:
		queue_free()
	pass

func _process(delta):
	if is_player_in_range:
		attack_charge += delta
		if attack_charge >= 1:
			attack_charge -= 1
			for b in $Area.get_overlapping_bodies():
				var projectile = preload("res://characters/EnemyProjectile.tscn").instance()
				get_tree().current_scene.add_child(projectile)
				projectile.global_transform = global_transform
				var dir = b.global_transform.origin
				dir.y = global_transform.origin.y
				projectile.look_at(dir, Vector3(0,1,0))
				pass
	pass


func _on_Area_body_entered(body):
	is_player_in_range = true
	pass # Replace with function body.
