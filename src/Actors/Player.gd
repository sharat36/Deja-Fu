extends Actor

func _physics_process(delta: float) -> void:
	var is_jump_interrupted: = Input.is_action_just_released("jump") and _velocity.y < 0.0
	var direction: = get_direction()
	set_animation()
	_velocity = calculate_move_velocity(_velocity, direction, speed, is_jump_interrupted)
	_velocity = move_and_slide(_velocity, FLOOR_NORMAL)

func get_direction() -> Vector2:
	var dir: = Vector2(0.0, 1.0)
	
	if Input.is_action_pressed("move_right"):
		dir.x = 1.0
	if Input.is_action_pressed("move_left"):
		dir.x = -1.0
	if Input.is_action_pressed("jump") and is_on_floor():
		dir.y = -1.0
	
	return dir
	
func calculate_move_velocity(
		linear_velocity: Vector2,
		direction: Vector2,
		speed: Vector2,
		is_jump_interrupted: bool
	) -> Vector2:
	var out: = linear_velocity
	out.x = speed.x * direction.x
	out.y += gravity * get_physics_process_delta_time() 
	if direction.y == -1.0:
		out.y = speed.y * direction.y
	if is_jump_interrupted:
		out.y = 0.0
	return out
func set_animation() -> void:
	if Input.is_action_pressed("move_right") and not Input.is_action_pressed("roll"):
		$AnimatedSprite.flip_h = false
		$AnimatedSprite.play("run")
	elif Input.is_action_pressed("move_left") and not Input.is_action_pressed("roll"):
		$AnimatedSprite.flip_h = true
		$AnimatedSprite.play("run")	
	elif Input.is_action_pressed("jump"):
		$AnimatedSprite.play("jump")
	elif Input.is_action_pressed("roll") and Input.is_action_pressed("move_right"):
		$AnimatedSprite.flip_h = false
		$AnimatedSprite.play("roll")
	elif Input.is_action_pressed("roll") and Input.is_action_pressed("move_left"):
		$AnimatedSprite.flip_h = true
		$AnimatedSprite.play("roll")
	elif Input.is_action_pressed("attack"):
		$AnimatedSprite.play("attack")	
	elif is_on_floor():
		$AnimatedSprite.play("idle")
