extends Control

@onready var boton_reintentar = $Button

func _ready():
	boton_reintentar.pressed.connect(_on_reintentar_pressed)

func _on_reintentar_pressed():
	print("Reintentando partida...")
	get_tree().change_scene_to_file("res://main.tscn")


func _on_button_pressed(): #esto lo vuelve al principio
	get_tree().change_scene_to_file("res://main.tscn")
