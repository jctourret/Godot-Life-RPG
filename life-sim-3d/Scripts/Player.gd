extends CharacterBody3D

class_name Player

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const ROTATION_SPEED = 10

@onready var animTree:= $"character-male-d2/AnimationTree"
@onready var speech:= $Label3D
@onready var intIcon:= $Sprite3D
@onready var heldItem:= $HeldItem

var interactable

var isHolding:bool

func _ready() -> void:
	intIcon.hide()
	speech.hide()
	pass

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Interact"):
		if interactable != null:
			if interactable.has_method("Interact"):
				interactable.Interact(self)
				pass
			pass
		else:
			DropItem()
			pass
	pass

func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := Vector3(input_dir.x, 0,input_dir.y).normalized()
	if direction:
		velocity.x = (direction.x - direction.z) * SPEED
		velocity.z = (direction.z + direction.x) * SPEED
		
		var target_rotation = atan2(-velocity.z,velocity.x)
		var current_rotation = transform.basis.get_euler().y
		var new_rotation = lerp_angle(current_rotation, target_rotation, delta * ROTATION_SPEED)
		# Update the lever's transform with the new basis
		transform.basis = Basis().rotated(Vector3.UP, new_rotation) # Apply the new rotation to the lever's transform
		pass
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		pass
	UpdateAnimations()
	move_and_slide()

func UpdateAnimations() -> void:
	if velocity == Vector3.ZERO:
		animTree["parameters/conditions/isIdle"] = true
		animTree["parameters/conditions/isWalking"] = false 
		pass
	else:
		animTree["parameters/conditions/isIdle"] = false
		animTree["parameters/conditions/isWalking"] = true
		pass
		
	if isHolding:
		animTree["parameters/conditions/isHolding"] = true
		animTree["parameters/conditions/notHolding"] = false
		pass
	else:
		animTree["parameters/conditions/isHolding"] = false
		animTree["parameters/conditions/notHolding"] = true
		pass
	pass

func _on_interaction_area_entered(area: Area3D) -> void:
	print("interacting with " + area.name + " area")
	if area.is_in_group("Interactable"):
		interactable = area
		print("got interactable " + interactable.name)
		intIcon.show()
		pass
	pass # Replace with function body.

func _on_interaction_area_exited(area: Area3D) -> void:
	print("Not interacting with " + area.name + " area anymore")
	if area == interactable:
		interactable = null
		intIcon.hide()
		pass
	pass # Replace with function body.

func _on_interaction_body_entered(body: Node3D) -> void:
	print("interacting with " + body.name + " body")
	pass # Replace with function body.

func _on_interaction_body_exited(body: Node3D) -> void:
	print("Not interacting with " + body.name + " body anymore")
	pass # Replace with function body.

func PickUpItem(body: Node3D) -> void:
	if heldItem.get_child_count() == 0:
		body.reparent(heldItem,false)
		body.position = heldItem.position
		isHolding = true
		pass
	pass

func DropItem() -> void:
	print("Trying to drop.")
	if heldItem.get_child_count() > 0:
		print("Dropping " + heldItem.get_child(0).name)
		var droppedItem := heldItem.get_child(0)
		droppedItem.reparent(get_tree().current_scene)
		
		droppedItem.position = Vector3(droppedItem.position.x,0,droppedItem.position.z)
		
		if droppedItem.has_method("Activate"):
			droppedItem.Activate()
			isHolding = false
			pass
		pass
	pass
