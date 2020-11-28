extends "res://weapons/Weapon.gd"

func trigger_pressed():
	var bullet = preload("res://weapons/Bullet.tscn").instance()
	get_tree().current_scene.add_child(bullet)
	bullet.global_transform = global_transform

	var ray_cast : RayCast = $RayCast
	ray_cast.force_raycast_update()
	if ray_cast.is_colliding():
		var collider = ray_cast.get_collider()
		var normal = ray_cast.get_collision_normal()
		var point = ray_cast.get_collision_point()
		
		var front : Vector3 = -ray_cast.global_transform.basis.z
		var dot = abs(front.dot(normal))
		
		if collider.has_method("hit_by_bullet"):
			collider.hit_by_bullet(100)
			pass
		
		var effect = preload("res://weapons/BulletHitEffect.tscn").instance()
		get_tree().current_scene.add_child(effect)
		effect.global_transform = collider.global_transform
		
		bullet.target_transform = collider.global_transform
		pass
	else:
		pass
	pass

func trigger_released():
	pass
