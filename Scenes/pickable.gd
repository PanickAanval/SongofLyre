extends CharacterBody2D
class_name Pickable

func _ready() -> void:
	Globals.ALL_PICKUPS.append(self)
