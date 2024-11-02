extends Interactive

@onready var collision:= $StaticBody3D/CollisionShape3D
@onready var area:=  $CollisionShape3D

func Interact(body: Player) -> void:
	if body is Player:
		Deactivate()
		body.PickUpItem(self)
		pass
	pass

func Deactivate() -> void:
	collision.disabled = true
	area.disabled = true
	pass


func Activate() -> void:
	collision.disabled = false
	area.disabled = false
	pass
