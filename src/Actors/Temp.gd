extends "res://src/Actors/Actor.gd"

onready var Player = get_parent().get_node("player")

var vel = Vector2.ZERO
var react_time = 400
var dir = 0
var next_dir = 0
var next_dir_time = 0
var next_jump_time = -1

var target_player_dist = 100

func set_dir(target_dir):
	if next_dir != target_dir:
		next_dir = target_dir
		next_dir_time = OS.get_ticks_msec() + react_time

func _physics_process(delta: float) -> void:
	if Player.position.x < position.x - target_player_dist:
		set_dir(-1)
	elif Player.position.x > position.x + target_player_dist:
		set_dir(1)
	else:
		set_dir(0)
	
	if OS.get_ticks_msec() > next_dir_time:
		dir = next_dir
	
	if OS.get_ticks_msec() > next_jump_time and next_jump_time != -1 and is_on_floor():
		if Player.position.y < position.y:
			vel.y = -100
		next_jump_time = -1
	
	vel.x = dir * 150;
		
	if Player.position.y < position.y and next_jump_time == -1:
		next_jump_time = OS.get_ticks_msec() + react_time
	
	vel.y += max(gravity * delta, speed.y)
	
	if is_on_floor() and vel.y > 0:
		vel.y = 0
	
	vel = move_and_slide(vel, FLOOR_NORMAL)

func _on_Area2D_area_entered(area: Area2D) -> void:
	area.is_in_group("sword")
	queue_free()

