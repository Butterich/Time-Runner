extends Area2D

@onready var sprite = $Sprite
@onready var collision = $Collision

# Variables para hacer que el obstáculo flote un poco - le da un toque de peligrosidad
var tiempo := 0.0
var posicion_inicial : Vector2

func _ready():
	
	posicion_inicial = position

	
	body_entered.connect(_on_body_entered)

# Hace que el obstáculo se mueva para arriba y abajo y de color para indicar peligro
func _process(delta):
	tiempo += delta

	# Movimiento vertical 
	position.y = posicion_inicial.y + sin(tiempo * 4.0) * 2.0

	#  efecto rojo que hace que parezca peligroso
	var intensidad = 0.9 + (sin(tiempo * 3.0) + 1.0) * 0.05
	sprite.modulate = Color(1.0, intensidad, intensidad)

# Si el jugador toca el obstáculo recibe daño
func _on_body_entered(body):
	if body.is_in_group("player"):
		print("¡Colisión con obstáculo!")

		if body.has_method("recibir_dano"):
			body.recibir_dano()
