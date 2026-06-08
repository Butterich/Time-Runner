extends Node2D

@onready var player = $Player
@onready var final_text = $CanvasLayer/FinalText

func _ready():
	add_to_group("game_manager")
	final_text.visible = false

func iniciar_final(frase: String):
	var puntuacion_final = int(player.global_position.x + 2170) + (player.piezas_recolectadas * 1000)

	final_text.text = frase + "\n\nPuntuación final: " + str(puntuacion_final)
	final_text.visible = true

	await get_tree().create_timer(7.0).timeout #esto hace que espera 7 segundos y ya vuelva a la página principal

	get_tree().change_scene_to_file("res://scenes/StartScene.tscn")
