extends RigidBody


func trigger_pressed():
	pass

func trigger_released():	
	pass

func change_to_rigid():
	mode = RigidBody.MODE_RIGID
	set_collision_layer_bit(2, true)
	set_collision_mask_bit(0, true)
	set_collision_mask_bit(1, true)
	set_collision_mask_bit(2, true)
	
func change_to_static():
	mode = RigidBody.MODE_STATIC
	collision_layer = 0
	collision_mask = 0

func _on_Weapon_sleeping_state_changed():
	return
#	print("sleeping: ", sleeping, " linear_velocity: ", linear_velocity," angular_velocity: ", angular_velocity)
	if mode == RigidBody.MODE_RIGID:
		if sleeping:
			# Stop collide with character
			set_collision_mask_bit(1, false)
			pass
		elif linear_velocity.length() > 0.1 or angular_velocity.length() > 0.1:
			# collide with character
			set_collision_mask_bit(1, true)
			pass
	pass # Replace with function body.
