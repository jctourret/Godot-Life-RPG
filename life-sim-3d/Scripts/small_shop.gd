extends Node3D

class_name Portal

@export var scene : PackedScene

func Interact(body: Player) -> void:
	get_tree().change_scene_to_packed(scene)
	pass
