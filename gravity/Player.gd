extends CharacterBody2D


@export var max_spd = 300.0
@export var accel = 20
@export var decel = 20
@export var JUMP_VELOCITY = -400.0
@export var push_spd = 50

var speed = 0
var sprite
var jump_count
var cam_sprite
var toggle
var goal_text
var timer

func _ready() -> void:
	sprite = $AnimatedSprite2D
	cam_sprite = $Camera2D/AnimatedSprite2D
	goal_text = $Camera2D/TextEdit
	timer = $Timer
	jump_count = 0
	toggle = 0


func _process(delta: float) -> void:
	if goal_text.visible:
		pass


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		cam_sprite.play("blank")

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		push_spd += 25
		push_spd = clamp(push_spd, 0, max_spd)
		jump_count += 1
		jump_count = clamp(jump_count, 0, 10)
		if toggle == 0: cam_sprite.play("jump")
		if toggle == 1: cam_sprite.play("warrior run")
		toggle = 1 - toggle
 
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		speed += accel
		speed = clamp(speed, 0, max_spd)
		if not is_on_floor(): 
			if jump_count < 5: velocity.x = direction * speed
			if jump_count == 5: velocity.x = direction * (speed + (push_spd * (0.05)))
			if jump_count == 10: velocity.x = direction * (speed + (push_spd * (0.1)))
		else: velocity.x = direction * (speed + push_spd)
		
		if is_on_floor(): sprite.play("move")
		if direction > 0: sprite.flip_h = false
		if direction < 0: sprite.flip_h = true
	else:
		speed = move_toward(speed, 0, decel)
		if not is_on_floor(): velocity.x = move_toward(velocity.x, 0, decel)
		else: velocity.x = push_spd
		
		if is_on_floor(): sprite.play("idle")
	
	#print(velocity.x)
	
	if velocity.y > 0: sprite.play("fall2")
	if velocity.y == JUMP_VELOCITY: sprite.play("jump")
	
	print(push_spd)
	print(velocity.x)
	move_and_slide()


func _on_goal_body_entered(body: Node2D) -> void:
	goal_text.visible = true
	timer.start()


func _on_area_2d_body_entered(body: Node2D) -> void:
	get_tree().reload_current_scene()


func _on_timer_timeout() -> void:
	get_tree().reload_current_scene()
