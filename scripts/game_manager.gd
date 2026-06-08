extends Node2D

@onready var player = $Player
@onready var hud = $HUD

func _ready():
	# Conectamos la señal de vidas del jugador con el HUD
	player.vidas_cambiadas.connect(hud.actualizar_vidas)
	
	# Inicializamos el contador en pantalla
	hud.actualizar_vidas(player.vidas)
