extends KinematicBody2D


# Declare member variables here. Examples:
export(float) var speed = 200

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += transform.x * speed * delta

func _on_Area2D_body_entered(body):
	if not body.get_name().begins_with("Enemy") \
	and not body.get_name().begins_with("player") \
	and not body.get_name().begins_with("Bullet"):
		queue_free()
