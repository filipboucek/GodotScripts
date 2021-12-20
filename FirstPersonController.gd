# Things that do not work:	Jump, walk acceleration and deceleration
# Things to add:		Crouch
#
# Filip Bouček - 2021
#
# Keep in mind, this is an early prototype. It is messy and kinda awfull

extends KinematicBody

var direction = Vector3.ZERO

#Sprinting
var defaultSpeed = 7
var speed = 7
var sprintSpeed = 10

#Movement and camera
var sens = 0.2 #camera sensitivity
var acceleration = 20
var gravity = 9.2
var jump = 10
var gravityVector = Vector3()
onready var head = $head

#IDK what this is, but it's probably important
onready var node = get_node("KinematicBody")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * sens))
		head.rotate_z(deg2rad(-event.relative.y * sens))
		head.rotation.z = clamp(head.rotation.z, deg2rad(-90), deg2rad(90)) 

func _get_input():
	if(Input.is_action_pressed("W")):
		direction += global_transform.basis.x
	if(Input.is_action_pressed("S")):
		direction -= global_transform.basis.x
	if(Input.is_action_pressed("A")):
		direction -= global_transform.basis.z
	if(Input.is_action_pressed("D")):
		direction += global_transform.basis.z
	
	if Input.is_action_pressed("sprint"):
		speed = 15
	if Input.is_action_just_released("sprint"):
		speed = defaultSpeed

	
	direction = direction.normalized()

func _process(delta):
	_get_input()
	gravityVector.y -= gravity * delta
#	if Input.is_action_just_pressed("jump") and is_on_floor():
#		gravityVector = jump
	gravityVector = move_and_slide(gravityVector, Vector3.UP)
	direction = direction.linear_interpolate(direction * speed,acceleration * delta)
	direction = move_and_slide(direction * speed)
	direction = Vector3.ZERO
	if Input.is_key_pressed(KEY_ESCAPE):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
