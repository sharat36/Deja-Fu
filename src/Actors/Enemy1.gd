extends "res://src/Actors/Actor.gd"

export (PackedScene) var Bullet

onready var Player = get_parent().get_node("player")

var vel = Vector2.ZERO
var react_time = 300
var dir = 0
var next_dir = 0
var next_dir_time = 0
var next_jump_time = -1

var target_player_dist = 300

var eye_reach = 90
var vision = 600
var reload_time = 3
var last_shot = OS.get_unix_time() - reload_time
var is_shooting = true
var dying = false

func sees_player():
	var eye_center = get_global_position()
	var eye_top = eye_center + Vector2(0, -eye_reach)
	var eye_left = eye_center +  Vector2(-eye_reach, 0)
	var eye_right = eye_center + Vector2(eye_reach, 0)
	
	var player_pos = Player.get_global_position()
	var player_extents = Player.get_node("CollisionShape2D").shape.extents - Vector2(1, 1)
	
	var top_left = player_pos + Vector2(-player_extents.x, -player_extents.y)
	var top_right = player_pos + Vector2(player_extents.x, -player_extents.y)
	var bottom_left = player_pos + Vector2(-player_extents.x, player_extents.y)
	var bottom_right = player_pos + Vector2(player_extents.x, player_extents.y)
	
	var space_state = get_world_2d().direct_space_state
	
	for eye in [eye_center, eye_top, eye_left, eye_right]:
		for corner in [top_left, top_right, bottom_left, bottom_right]:
			if (corner - eye).length() > vision:
				continue
			var collision = space_state.intersect_ray(eye, corner, [], 1)
			if collision and collision.collider.name == "player":
				return true
	return false

func set_dir(target_dir):
	if next_dir != target_dir:
		next_dir = target_dir
		next_dir_time = OS.get_ticks_msec() + react_time

func _physics_process(delta: float) -> void:
	if dying:
		return
	
	if abs(Player.position.x - position.x) <= target_player_dist and sees_player():
		shoot()
	if Player.position.x < position.x and sees_player():
		set_dir(-1)
		$AnimatedSprite.flip_h = true
	elif Player.position.x > position.x and sees_player():
		set_dir(1)
		$AnimatedSprite.flip_h = false
	else:
		set_dir(0)
	
	if OS.get_ticks_msec() > next_dir_time:
		dir = next_dir
	
	if OS.get_ticks_msec() > next_jump_time and next_jump_time != -1 and is_on_floor():
		if Player.position.y < position.y - 80 and sees_player():
			vel.y = -750
		next_jump_time = -1
	
	vel.x = dir * 100;
		
	if Player.position.y < position.y - 80 and next_jump_time == -1 and sees_player():
		next_jump_time = OS.get_ticks_msec() + react_time
	
	vel.y += gravity * delta
	if is_on_floor() and vel.y > 0:
		vel.y = 0
		
	if vel.x == 0 and vel.y == 0:
		$AnimatedSprite.play("idle")
	elif vel.x != 0 or vel.y != 0:
		$AnimatedSprite.play("run")
		
	vel = move_and_slide(vel, FLOOR_NORMAL)

func shoot():
	if OS.get_unix_time() - last_shot < reload_time:
		return
	last_shot = OS.get_unix_time()
	var bullet = Bullet.instance()
	var x = Player.transform.origin.x - transform.origin.x
	var y = Player.transform.origin.y - transform.origin.y
	bullet.transform.x = Vector2(x, y).normalized()
	bullet.transform.origin = transform.origin
	get_tree().get_root().add_child(bullet)
	
func _on_Area2D_area_entered(area: Area2D) -> void:
	if area.is_in_group("sword"):
		$AnimatedSprite.play("death")
		dying = true
		yield($AnimatedSprite, "animation_finished")
		queue_free()
