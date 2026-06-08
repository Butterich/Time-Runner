extends Area2D

#Con este comando hacemos que los enemigos sean configurables desde el Inspector y me hago la vida más facil
@export var velocidad = 50.0
@export var distancia_patrulla = 100.0

var posicion_inicial
var direccion = 1

func _ready():
	body_entered.connect(_on_body_entered)

	posicion_inicial = global_position

func _process(delta):
	# Movimiento izquierda-derecha
	position.x += velocidad * direccion * delta

	# Cambiar dirección al llegar al límite
	if position.x > posicion_inicial.x + distancia_patrulla:
		direccion = -1

	elif position.x < posicion_inicial.x - distancia_patrulla:
		direccion = 1

func _on_body_entered(body):
	if body.is_in_group("player"):
		if body.has_method("recibir_dano"):
			body.recibir_dano()
