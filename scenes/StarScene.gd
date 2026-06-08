extends Control

func _on_pressed() -> void:
	print("Botón JUGAR pulsado")
	get_tree().change_scene_to_file("res://main.tscn")
