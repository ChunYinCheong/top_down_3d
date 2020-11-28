extends KinematicBody

var health = 1000

func hit_by_bullet(damage):
	health -= damage
	if health <= 0:
		queue_free()
	pass

func hit_by_projectile(damage):
	health -= damage
	if health <= 0:
		queue_free()
	pass
