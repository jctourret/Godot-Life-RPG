extends Area3D

const ROTATION_SPEED = 1

func _physics_process(delta: float) -> void:
	var target_rotation = atan2(90,0)
	var current_rotation = transform.basis.get_euler().y
	var new_rotation = lerp_angle(current_rotation, target_rotation, delta * ROTATION_SPEED)
	# Update the lever's transform with the new basis
	transform.basis = Basis().rotated(Vector3.UP, new_rotation) # Apply the new rotation to the lever's transform
