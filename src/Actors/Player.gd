extends Actor

var is_attacking: bool = false
var is_rolling: bool = false
func _physics_process(delta: float) -> void:
	var is_jump_interrupted: = Input.is_action_just_released("jump") and _velocity.y < 0.0 
	var direction: = get_direction()
	_velocity = calculate_move_velocity(_velocity, direction, speed, is_jump_interrupted)
	_velocity = move_and_slide(_velocity, FLOOR_NORMAL)
	set_animation()

func get_direction() -> Vector2:
	var dir: = Vector2(0.0, 1.0)
	
	if Input.is_action_pressed("move_right"):
		dir.x = 1.0
	if Input.is_action_pressed("move_left"):
		dir.x = -1.0
	if Input.is_action_pressed("jump") and is_on_floor():
		dir.y = -1.0
	if Input.is_action_pressed("roll") and $AnimatedSprite.flip_h == false:
		dir.x = 1.0
	if Input.is_action_pressed("roll") and $AnimatedSprite.flip_h == true:
		dir.x = -1.0
		
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
	if is_attacking or is_rolling:
		out.x = 0.0
	return out
	
func set_animation() -> void:
	if Input.is_action_pressed("move_right") and not is_attacking:
		$AnimatedSprite.flip_h = false
		$AnimatedSprite.play("run")
	elif Input.is_action_pressed("move_left") and not is_attacking:
		$AnimatedSprite.flip_h = true
		$AnimatedSprite.play("run")	
	elif Input.is_action_pressed("jump"):
		$AnimatedSprite.play("jump")
	elif Input.is_action_pressed("roll"):
		$AnimatedSprite.play("roll")
		is_rolling = true;
	elif Input.is_action_just_released("roll"):
		is_rolling = false;
	elif Input.is_action_pressed("attack"):
		$AttackArea/CollisionShape2D.disabled = false;
		$AnimatedSprite.play("attack")	
		is_attacking = true
	elif Input.is_action_just_released("attack"):
		$AttackArea/CollisionShape2D.disabled = true;
		is_attacking = false;
	
	elif is_on_floor():
		$AnimatedSprite.play("idle")

