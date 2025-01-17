extends CharacterBody2D

# Character control parameters
@export var ground_speed: float = 200.0  # Ground speed (m/s)
@export var air_speed: float = 150.0     # Air speed (m/s)
@export var ground_acceleration: float = 1000.0  # Ground acceleration (m/s^2)
@export var aerial_acceleration: float = 600.0   # Aerial acceleration (m/s^2)
@export var jump_height: float = 400.0   # Jump height (pixels)
@export var max_fall_speed: float = 1200.0 # Maximum fall speed (m/s)
@export var gravity_accel: float = 2000.0 # Gravity acceleration (m/s^2)

# State variables
var is_grounded: bool = false
var on_backpad: bool = false

func _ready():
	# Set custom gravity (if needed)
	# In Godot 4, gravity is handled automatically, but you can still apply custom gravity logic.
	# If you want to tweak it, modify the default gravity setting in the "Project Settings > Physics > 2d > Default Gravity" option
	# For now, gravity is handled during _physics_process()
	pass

func _physics_process(delta):
	# Update grounded state
	is_grounded = is_on_floor()

	# Horizontal movement logic
	var target_speed = ground_speed if is_grounded else air_speed
	var acceleration = ground_acceleration if is_grounded else aerial_acceleration

	# Horizontal movement logic (smooth acceleration)
	var target_velocity_x = target_speed * (Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left"))
	if !on_backpad: velocity.x = move_toward(velocity.x, target_velocity_x, acceleration * delta)

	# Vertical movement (jumping and falling)
	if is_grounded and Input.is_action_just_pressed("ui_accept"):
		velocity.y = -jump_height  # Apply jump velocity
	elif not is_grounded:
		# Apply gravity manually for falling
		velocity.y = min(velocity.y + gravity_accel * delta, max_fall_speed)  # Apply gravity and limit fall speed

	# Apply velocity to the character and slide
	move_and_slide()

# Helper function to smoothly move towards a target value



func _on_static_body_2d_touched_pad() -> void:
	#velocity.x = -10
	on_backpad = false 


func _on_static_body_2d_off_pad() -> void:
	on_backpad = false
