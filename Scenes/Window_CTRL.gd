extends Node2D

var mywin = preload("res://World_2.tscn")

func _ready():
	var d = mywin.instantiate()
	add_child(d)
	d.visible = true
	d.position = Vector2(800,800)
	d.title = "Window 2"
	d.size = Vector2(1200,800)
