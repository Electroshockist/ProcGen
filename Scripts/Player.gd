class_name Player
extends CharacterBody3D

@export var accel := 1.0
@export var rotation_sensitivity :float = 1.0
@export var max_pitch :float
@export var min_pitch :float

@onready var camera := $Camera3D

var mouse_captured = true

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):	
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		var rot: Vector2 = Vector2(event.relative.y * rotation_sensitivity * 0.001, -event.relative.x * rotation_sensitivity * 0.001)
		
		$Camera3D.rotation.x = clamp($Camera3D.rotation.x - rot.x, deg_to_rad(min_pitch), deg_to_rad(max_pitch))
		rotate_y(rot.y)
		
	if event.is_action_pressed("Toggle Mouse Lock"):
		mouse_captured = !mouse_captured
		if mouse_captured:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)	

#func _process(delta):
#	var input := Vector3(Input.get_axis("Right", "Left"), Input.get_axis("Down", "Up"), Input.get_axis("Back", "Forward"), )
#
#	var aim = camera.get_global_transform().basis
#	var forward = -aim.z
#	velocity = (Vector3(input.x, 0, input.z)  * forward + Vector3(0, input.y, 0)) * accel * delta
#
#	move_and_slide()
func _physics_process(delta):
	var input := Vector2(Input.get_axis("Left", "Right"), -Input.get_axis("Back", "Forward"))
	input = input.normalized() if input.length() > 1 else  input
	
	var final_input = Vector3(input.x, 0, input.y) * transform.basis.inverse()
	
	velocity = (final_input + Vector3(0,  Input.get_axis("Down", "Up") ,0))* accel * delta
	
	move_and_slide()
