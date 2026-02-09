extends Node2D

var mywin = preload("res://Scenes/World_2.tscn")

func _ready():
	var d = mywin.instantiate()
	add_child(d)
	d.visible = true
	d.position = Vector2(600,600)
	d.title = "Window 2"
	d.size = Vector2(640,480)
