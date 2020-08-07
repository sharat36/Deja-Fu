extends Control

export var level1: PackedScene
export var level2: PackedScene
export var level3: PackedScene
export var level4: PackedScene
export var level5: PackedScene
export var level6: PackedScene
export var level7: PackedScene
export var level8: PackedScene
export var TitleScreen: PackedScene

onready var anim_player = $"Fade In/AnimationPlayer"

func _ready() -> void:
	pass # Replace with function body.

func _on_Level_1_pressed() -> void:
	anim_player.play("fade_in")
	yield(anim_player, "animation_finished")
	get_tree().change_scene_to(level1)


func _on_Level_2_pressed() -> void:
	anim_player.play("fade_in")
	yield(anim_player, "animation_finished")
	get_tree().change_scene_to(level2)

func _on_Level_3_pressed() -> void:
	anim_player.play("fade_in")
	yield(anim_player, "animation_finished")
	get_tree().change_scene_to(level3)

func _on_Level_4_pressed() -> void:
	anim_player.play("fade_in")
	yield(anim_player, "animation_finished")
	get_tree().change_scene_to(level4)


func _on_Level_5_pressed() -> void:
	anim_player.play("fade_in")
	yield(anim_player, "animation_finished")
	get_tree().change_scene_to(level5)


func _on_Level_6_pressed() -> void:
	anim_player.play("fade_in")
	yield(anim_player, "animation_finished")
	get_tree().change_scene_to(level6)

func _on_Level_7_pressed() -> void:
	anim_player.play("fade_in")
	yield(anim_player, "animation_finished")
	get_tree().change_scene_to(level7)


func _on_Level_8_pressed() -> void:
	anim_player.play("fade_in")
	yield(anim_player, "animation_finished")
	get_tree().change_scene_to(level8)


func _on_Back_pressed() -> void:
	anim_player.play("fade_in")
	yield(anim_player, "animation_finished")
	get_tree().change_scene_to(TitleScreen)
