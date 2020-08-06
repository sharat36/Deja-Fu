extends Actor

var is_attacking: bool = false
var is_gripping: bool = false
var dying: bool = false
onready var Player = get_parent().get_node("player")
var prev = 0
var pos = []
var rewind_max_time = 6000
var rewind_gap = 100
var rewind_max_elems = rewind_max_time / rewind_gap
var rewind_rate = 1.5
var is_teleporting = false
var teleport_time

func _process(delta: float) -> void:
	store_pos()

func _physics_process(delta: float) -> void:
	if dying:
		return
	var is_jump_interrupted: = Input.is_action_just_released("jump") and _velocity.y < 0.0 
	var direction: = get_direction()
	
	_velocity = calculate_move_velocity(_velocity, direction, speed, is_jump_interrupted)
	if not is_on_floor()  and ($LeftRayCast1.is_colliding() or $LeftRayCast2.is_colliding() or $RightRayCast1.is_colliding() or $RightRayCast2.is_colliding()):
		_velocity.y = 100
		is_gripping = true
		$AnimatedSprite.play("wallgrip")
	else:
		is_gripping = false
	set_animation()
	check_teleport()
	_velocity = move_and_slide(_velocity, FLOOR_NORMAL)

func get_direction() -> Vector2:
	if dying:
		return Vector2(0.0, 0.0)
	var dir: = Vector2(0.0, 1.0)
	
	if Input.is_action_pressed("move_right"):
		dir.x = 1.0
	if Input.is_action_pressed("move_left"):
		dir.x = -1.0
	if Input.is_action_pressed("jump") and (is_on_floor() or is_gripping):
		if is_gripping:
			if Input.is_action_pressed("move_right"):
				dir.x = -2.0
			elif Input.is_action_pressed("move_left"):
				dir.x = 2.0
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
	if not is_on_floor() and ($LeftRayCast1.is_colliding() or $LeftRayCast2.is_colliding()):
		out.x += 300
		out.y = -1000
	elif not is_on_floor() and ($RightRayCast1.is_colliding() or $RightRayCast2.is_colliding()):
		out.x -= 300
		out.y = -1000
	elif is_jump_interrupted:
		out.y = 0.0
	elif is_attacking:
		out.x = 0.0
	
	return out
	
func set_animation() -> void:
	if dying:
		return
	if is_gripping:
		return
	if Input.is_action_pressed("move_right") and not is_attacking:
		$AnimatedSprite.flip_h = false
		$AttackArea.scale = Vector2(1, 1)
		if Input.is_action_pressed("jump"):
			$AnimatedSprite.play("jump")
		else:
			$AnimatedSprite.play("run")
	elif Input.is_action_pressed("move_left") and not is_attacking:
		$AnimatedSprite.flip_h = true
		$AttackArea.scale = Vector2(-1, 1)
		if Input.is_action_pressed("jump"):
			$AnimatedSprite.play("jump")
		else:
			$AnimatedSprite.play("run")	
	elif Input.is_action_pressed("jump"):
		$AnimatedSprite.play("jump")
	elif Input.is_action_pressed("attack"):
		$AttackArea/CollisionShape2D.disabled = false;
		$AnimatedSprite.play("attack")
		is_attacking = true
		yield($AnimatedSprite, "animation_finished")
		is_attacking = false
		$AttackArea/CollisionShape2D.disabled = true;
	elif is_on_floor() and not is_attacking:
		$AnimatedSprite.play("idle")

func store_pos():
	if not is_teleporting:
		var cur = OS.get_ticks_msec()
		
		if pos.size() == 0 :
			pos.append([cur, Player.position, _velocity])
		elif cur - pos[pos.size() - 1][0] > rewind_gap :
			if pos.size() > rewind_max_elems :
				pos.remove(0)
			pos.append([cur, Player.position, _velocity])

func check_teleport():
	if Input.is_action_pressed("teleport") and pos.size() > 0:
		if not is_teleporting :
			teleport_time = OS.get_ticks_msec()
			
		is_teleporting = true
	
		while(pos[pos.size() - 1][0] > teleport_time - rewind_rate * (OS.get_ticks_msec() - teleport_time) and pos.size() > 1):
			show_clock(pos[pos.size() - 1])
			pos.remove(pos.size() - 1)
		if pos.size() == 1 :
			teleport(pos[0])

	else:
		if is_teleporting :
			teleport(pos[pos.size() - 1])
		is_teleporting = false
		$Clock.visible = false


func show_clock(pos):
	$Clock.position = pos[1] - Player.position
	$Clock.visible = true
func teleport(pos):
	Player.position = pos[1]
	_velocity = pos[2]
	$Clock.visible = false

func _on_PlayerArea_body_entered(body):
	if body.is_in_group("damage"):
		dying = true
		$AnimatedSprite.play("death")
		get_tree().reload_current_scene()
