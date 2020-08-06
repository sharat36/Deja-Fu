extends KinematicBody2D

export(float) var speed = 0.02
export(float) var left = 5 
export(float) var right = 10

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var left_pos = null
var right_pos = null
var is_right = true

# Called when the node enters the scene tree for the first time.
func _ready():
	left_pos = transform.origin - transform.x*left
	right_pos = transform.origin + transform.x*right
	print(left_pos)
	print(right_pos)

func _process(delta):
	
	if is_right and transform.origin.x > right_pos.x:
		is_right = false
	elif not is_right and transform.origin.x < left_pos.x:
		is_right = true

	if is_right:
		position += speed*transform.x
	else:
		position -= speed*transform.x
