extends "res://characters/Character.gd"


var weapon = [null,null,null,null]
var left_index = 0
var right_index = 1
var max_weapon = 4
var left_symbol = []
var right_symbol = []

var mp = 1000
var mp_max = 1000

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	var move_down = Input.get_action_strength("move_down")
	var move_up = Input.get_action_strength("move_up")
	var move_left = Input.get_action_strength("move_left")
	var move_right = Input.get_action_strength("move_right")
	
	var h = move_right - move_left
	var v = move_up - move_down
	var move_direction = Vector3(h,0,-v).normalized()
	var move_strength = max(abs(h),abs(v))

	var move_vector = move_direction * (12 if move_strength >= 1 else 5)
	move_vector.y = -9.8
	move_and_slide(move_vector, Vector3(0, 1, 0))
	
	var aim_down = Input.get_action_strength("aim_down")
	var aim_up = Input.get_action_strength("aim_up")
	var aim_left = Input.get_action_strength("aim_left")
	var aim_right = Input.get_action_strength("aim_right")
			
	h = aim_right - aim_left
	v = aim_down - aim_up
	var aim_vector = Vector2(h,v)
	aim_vector += Input.get_action_strength("aim_top_left") * Vector2(-1,-1)
	aim_vector += Input.get_action_strength("aim_top_right") * Vector2(1,-1)
	aim_vector += Input.get_action_strength("aim_bottom_left") * Vector2(-1,1)
	aim_vector += Input.get_action_strength("aim_bottom_right") * Vector2(1,1)
	aim_vector = aim_vector.normalized()
	var aim_strength = max(abs(h),abs(v))	
	
	if Input.is_action_pressed("aim_mouse"):
		var ray_length = 1000
		var camera = get_viewport().get_camera()
		var from = camera.project_ray_origin(get_viewport().get_mouse_position())
		var to = from + camera.project_ray_normal(get_viewport().get_mouse_position()) * ray_length
		var space_state = get_world().get_direct_space_state()
		var hit = space_state.intersect_ray(from, to, [], 1)
		if hit.size() != 0:
			var p = hit.position
			var hit_vec = Vector2(p.x,p.z)
			var tran_vec = Vector2(global_transform.origin.x,global_transform.origin.z)
			var dir = hit_vec - tran_vec
			aim_vector = dir.normalized()
			aim_strength = dir.length()
	
	if aim_vector.length() > 0 :
		var front = -global_transform.basis.z
		var front_vector = Vector2(front.x,front.z).normalized()
		var target = front_vector.angle_to(aim_vector)
		var c = delta * PI * 5 #aim_turn_speed
		var a = clamp(target, -c, c)
#		print(front_vector,"/",aim_vector,"/",target)
		global_rotate(Vector3(0,1,0), -a)
		transform = transform.orthonormalized()
	elif move_direction.length() > 0:
		var front = -global_transform.basis.z
		var front_vector = Vector2(front.x,-front.z).normalized()
		var target = front_vector.angle_to(Vector2(move_direction.x, -move_direction.z))
		var c = delta * PI * 10 #walk_turn_speed
		var a = clamp(target, -c, c)
		global_rotate(Vector3(0,1,0),a)
		pass

	pass


func _unhandled_input(event):
	if event.is_action_pressed("pick_up"):
		if not $Area.get_overlapping_bodies().empty():
			var new_weapon : RigidBody = $Area.get_overlapping_bodies().front()
			var current_weapon = weapon[right_index]
			if current_weapon:
				current_weapon.drop()
			weapon[right_index] = new_weapon
			new_weapon.change_to_static()
			new_weapon.get_parent().remove_child(new_weapon)
			$Position3D.add_child(new_weapon)
			new_weapon.global_transform = $Position3D.global_transform
		pass
		
	if event.is_action_pressed("trigger_left"):
		trigger_pressed(left_index)
	if event.is_action_released("trigger_left"):
		trigger_released(left_index, left_symbol)
	if event.is_action_pressed("switch_left"):
		left_index = switch(left_index, right_index)
	if event.is_action_pressed("drop_left"):
		drop(left_index)
		
	if event.is_action_pressed("trigger_right"):
		trigger_pressed(right_index)
	if event.is_action_released("trigger_right"):
		trigger_released(right_index, right_symbol)
	if event.is_action_pressed("switch_right"):
		right_index = switch(right_index, left_index)
	if event.is_action_pressed("drop_right"):
		drop(right_index)
	
	var is_left = Input.is_action_pressed("trigger_left") and weapon[left_index] == null
	if is_left:
		if event.is_action_pressed("alchemy_left"):
			left_symbol.append("left")
		if event.is_action_pressed("alchemy_right"):
			left_symbol.append("right")
		if event.is_action_pressed("alchemy_up"):
			left_symbol.append("up")
		if event.is_action_pressed("alchemy_down"):
			left_symbol.append("down")
			
	var is_right = Input.is_action_pressed("trigger_right") and weapon[right_index] == null
	if is_right:
		if event.is_action_pressed("alchemy_left"):
			right_symbol.append("left")
		if event.is_action_pressed("alchemy_right"):
			right_symbol.append("right")
		if event.is_action_pressed("alchemy_up"):
			right_symbol.append("up")
		if event.is_action_pressed("alchemy_down"):
			right_symbol.append("down")
	pass





func trigger_pressed(index: int) -> void:
	var current_weapon = weapon[index]
	if current_weapon:
		current_weapon.trigger_pressed()
	else:
		pass
func trigger_released(index: int, symbol: Array) -> void:
	var current_weapon = weapon[index]
	if current_weapon:
		current_weapon.trigger_released()
		if current_weapon is preload("res://weapons/Grenade.gd"):
			weapon[index] = null
			current_weapon.change_to_rigid()
			current_weapon.get_parent().remove_child(current_weapon)
			get_tree().current_scene.add_child(current_weapon)
			current_weapon.global_transform = $Position3D.global_transform
			var front = -global_transform.basis.z
			var impulse = front * 10
			impulse.y = 2.5
			current_weapon.apply_central_impulse(impulse)
			pass
	else:
		if mp >= 0:
			symbol_match(symbol, index)
		symbol.clear()
		
func switch(index: int, another_index: int) -> int:
	var next_index
	var current_weapon = weapon[index]
	if current_weapon:
		current_weapon.get_parent().remove_child(current_weapon)
		$StandbyPosition.add_child(current_weapon)
		current_weapon.global_transform = $StandbyPosition.global_transform
	index = (index + 1) % max_weapon
	if index == another_index:
		index = (index + 1) % max_weapon
	current_weapon = weapon[index]
	if current_weapon:
		current_weapon.get_parent().remove_child(current_weapon)
		$Position3D.add_child(current_weapon)
		current_weapon.global_transform = $Position3D.global_transform
	return index
func drop(index: int) -> void:
	var current_weapon : RigidBody = weapon[index]
	if current_weapon:
		weapon[index] = null
		current_weapon.change_to_rigid()
		current_weapon.get_parent().remove_child(current_weapon)
		get_tree().current_scene.add_child(current_weapon)
		current_weapon.global_transform = $Position3D.global_transform
	
func symbol_match(symbol :Array, index: int) -> void:
	match symbol:
		["right","right","right"]:
			print("grenade")
			var new_weapon = preload("res://weapons/Grenade.tscn").instance()
			weapon[index] = new_weapon
			new_weapon.change_to_static()
			$Position3D.add_child(new_weapon)
			new_weapon.global_transform = $Position3D.global_transform
		["right","right","up"]:
			print("gun")
			var new_weapon = preload("res://weapons/Gun.tscn").instance()
			weapon[index] = new_weapon
			new_weapon.change_to_static()
			$Position3D.add_child(new_weapon)
			new_weapon.global_transform = $Position3D.global_transform
	
	pass
