extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

@onready var cam = $Camera3D
@onready var light = $SpotLight3D

var colors = [
	Color.RED,
	Color.GREEN,
	Color.BLUE,
	Color.YELLOW,
	Color.PURPLE,
	Color.CYAN,
	Color.WHITE
]

var index := 0

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var raw_input := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var input_dir = Vector2(raw_input.x, -raw_input.y)

	if input_dir.length() > 0:
		var cam_forward = -cam.global_transform.basis.z
		cam_forward.y = 0
		cam_forward = cam_forward.normalized()

		var cam_right = cam.global_transform.basis.x
		cam_right.y = 0
		cam_right = cam_right.normalized()

		var move_dir = (cam_forward * input_dir.y) + (cam_right * input_dir.x)
		move_dir = move_dir.normalized()

		velocity.x = move_dir.x * SPEED
		velocity.z = move_dir.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()


func _input(event):
	if event is InputEventMouseButton and event.pressed:
		light.visible = true
		light.light_color = colors[index]
		index = (index + 1) % colors.size()
