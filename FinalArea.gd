extends Area2D

@export_multiline var frase_final := "Has cruzado todas las eras.\nEl tiempo vuelve a estar en equilibrio."

var activado = false

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if activado:
		return

	if body.is_in_group("player"):
		activado = true
		get_tree().call_group("game_manager", "iniciar_final", frase_final)
