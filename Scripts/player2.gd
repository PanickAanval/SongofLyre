extends CharacterBody2D


const SPEED = 260.0
const JUMP_VELOCITY = -650.0
var DIR_X = 0
var DASH_DIR = 0
var LAST_DIR = 1
var CHECKED_DASH_DIR = false
const DASH_SPEED = 1000.0
var DASH_TIME = 0.25
var ACTIVE = Globals.ACTIVE2

var IN_RANGE : bool = false
var TARGET_OBJ : CharacterBody2D
var HELD_OBJ : CharacterBody2D
@onready var HAND_POS: Marker2D = $HandPos

enum States {Move, Dash}
var state = States.Move

func _ready() -> void:
	Globals.PLAYER2 = self

func change_state(newstate):
	state = newstate 

func _physics_process(delta: float) -> void:
	if Globals.ACTIVE2 == false:
		return
	check_object()
	pickup_object()
	drop_object()
	SwitchData()
	DIR_X = Input.get_axis("move_left", "move_right")
	if DIR_X:
		LAST_DIR = DIR_X
	match state:
		States.Move:
			MoveData(delta)
		States.Dash:
			DashData(delta)

func MoveData(delta: float):
	# Check for statechanges
	if Input.is_action_just_pressed("dash"):
		velocity.y = 0
		change_state(States.Dash)

	if DIR_X:
		velocity.x = DIR_X * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		print(Globals.POSITION)
	move_and_slide()

func SwitchData():
	if Input.is_action_just_pressed("switch"):
		Globals.Switch(self, Globals.PLAYER1)
		print ("Player2")
		print(ACTIVE)

func DashData(delta: float):
	print(velocity)
	
	if !CHECKED_DASH_DIR:
		DASH_DIR = DIR_X
		CHECKED_DASH_DIR = true
	
	if DASH_DIR:
		velocity.x = DASH_DIR * DASH_SPEED
	else:
		velocity.x = LAST_DIR * DASH_SPEED
	
	move_and_slide()
	get_tree().create_timer(DASH_TIME).timeout.connect(_end_dash)


func _end_dash() -> void:
	CHECKED_DASH_DIR = false
	change_state(States.Move)
	
func pickup_object() -> void:
	if IN_RANGE:
		if Input.is_action_just_pressed("pickup") and !HELD_OBJ:
			HELD_OBJ = TARGET_OBJ
			HELD_OBJ.reparent(HAND_POS)
			HELD_OBJ.position = HAND_POS.position
			Globals.HELD_OBJ_G = HELD_OBJ

func drop_object() -> void:
	if Input.is_action_just_pressed("drop") and HELD_OBJ:
		HELD_OBJ.reparent(get_parent())
		HELD_OBJ.position = position
		HELD_OBJ = null	
		Globals.HELD_OBJ_G = null

func check_object() -> void:
	if Globals.HELD_OBJ_G != null:
		HELD_OBJ = Globals.HELD_OBJ_G
		HELD_OBJ.reparent(get_parent())
		HELD_OBJ.reparent(HAND_POS)
		HELD_OBJ.position = HAND_POS.position
	if Globals.HELD_OBJ_G == null and HELD_OBJ != null:
		HELD_OBJ = null	

func _on_range_body_entered(body: Node2D) -> void:
	if body is Pickable:
		IN_RANGE = true
		TARGET_OBJ = body


func _on_range_body_exited(body: Node2D) -> void:
	if body is Pickable:
		IN_RANGE = false
		TARGET_OBJ = null
		
