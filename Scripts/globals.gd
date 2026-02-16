extends Node
var POSITION = Vector2(3,0)
var PLAYER1
var PLAYER2
var ACTIVE1 = true
var ACTIVE2 = false
var SWITCHABLE = true
var HOLDING1 = false
var HOLDING2 = false
var HELD1
var HELD2
@onready var OBJECTHELD

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func Switch(Oldplayer, Newplayer, Group):
	if SWITCHABLE == false:
		return
	ACTIVE1 =! ACTIVE1
	ACTIVE2 =! ACTIVE2
	print(Oldplayer)
	print(Newplayer)
	print(HELD1)
	print(HELD2)
	Newplayer.position = Oldplayer.position
	if HOLDING1:
		print("Player 1 holding")
		OBJECTHELD  = Group
	if HOLDING2:
		print("Player 2 holding")
		OBJECTHELD = Group
	SWITCHABLE = false
	get_tree().create_timer(0.1).timeout.connect(EndSwitch)

func EndSwitch():
	SWITCHABLE = true
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
