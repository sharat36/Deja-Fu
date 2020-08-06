extends KinematicBody2D

export(float) var speed = 20
export(float) var left = 5 
export(float) var right = 10

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var left_pos = null
var right_pos = null
var is_right = true
var buzz_gap = 2.5
var last_buzz = OS.get_unix_time() - buzz_gap + randf()*buzz_gap

# Called when the node enters the scene tree for the first time.
func _ready():
	left_pos = transform.origin - transform.x*left
	right_pos = transform.origin + transform.x*right

func _process(delta):
	if OS.get_unix_time() - last_buzz >= buzz_gap:
		last_buzz = OS.get_unix_time()
		$BuzzSound.play()
		
	if is_right and transform.origin.x > right_pos.x:
		is_right = false
	elif not is_right and transform.origin.x < left_pos.x:
		is_right = true

	if is_right:
		position += speed*transform.x*delta
	else:
		position -= speed*transform.x*delta
