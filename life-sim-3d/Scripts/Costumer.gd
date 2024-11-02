extends Node3D

@export var goodOrder : String
@onready var label : = $Label3D

func _ready() -> void:
	label.text = " "
	pass
	
func Interact(body: Player) -> void:
	label.text = goodOrder
	pass
