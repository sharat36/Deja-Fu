extends Control

onready var anim_player = $"Fade In/AnimationPlayer"

export var start_scene: PackedScene
export var levels_scene: PackedScene

func _ready() -> void:
	pass # Replace with function body.


func _on_NewGameButton_pressed() -> void:
	anim_player.play("fade_in")
	yield(anim_player, "animation_finished")
	get_tree().change_scene_to(start_scene)


func _on_LevelButton_pressed() -> void:
	anim_player.play("fade_in")
	yield(anim_player, "animation_finished")
	get_tree().change_scene_to(levels_scene)
