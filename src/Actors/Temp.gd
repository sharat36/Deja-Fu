extends Area2D




func _on_Area2D_area_entered(area: Area2D) -> void:
	area.is_in_group("sword")
	queue_free()
