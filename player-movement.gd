extends CharacterBody3D

const SPEED = 1.0
const JUMP_VELOCITY = 0
const MOUSE_SENSITIVITY = 0.003

@onready var neck = $Neck
@onready var camera = $Neck/Camera3D

var pitch: float = 0.0
var MAX_PITCH := deg_to_rad(30.0)
var MIN_PITCH := deg_to_rad(-40.0)

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		# Rotate neck for yaw
		neck.rotate_y(-event.relative.x * MOUSE_SENSITIVITY)

		# Clamp and apply pitch to camera
		pitch = clamp(pitch - event.relative.y * MOUSE_SENSITIVITY, MIN_PITCH, MAX_PITCH)
		camera.rotation.x = pitch

func _physics_process(delta: float) -> void:
	# Apply gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Camera-relative movement
	var input_dir := Input.get_vector("left", "right", "for", "down")
	var direction: Vector3 = (neck.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if direction != Vector3.ZERO:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		
		
	move_and_slide()
	
	
