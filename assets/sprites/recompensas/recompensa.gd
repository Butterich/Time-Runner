extends Area2D

# Valor de puntos que da este item
@export var puntos = 10

func _ready():
	# Conectar señal de cuando un cuerpo entra
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	# DEBUG: Ver qué detecta
	print("¡COLISIÓN DETECTADA! Cuerpo: ", body.name)
	print("¿Es player?: ", body.is_in_group("player"))
	
	# Verificar que es el jugador
	if body.is_in_group("player"):
		print("¡ES EL JUGADOR! Recolectando...")
		recolectar(body)

func recolectar(player):
	# Llamar función del jugador
	if player.has_method("recolectar_pieza"):
		player.recolectar_pieza(puntos)
	
	# Desaparecer
	queue_free()
