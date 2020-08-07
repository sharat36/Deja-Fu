extends Area2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass



func _on_Door_area_entered(area):
	if area.is_in_group("sword"):
		if $KinematicBody2D != null:
			$KinematicBody2D.queue_free()
			get_node("DoorOpenAudio").play()
		$AnimatedSprite.play("open")
