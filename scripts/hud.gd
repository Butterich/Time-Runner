extends CanvasLayer

@onready var vidas_label = $VidasLabel
@onready var tutorial_label = $TutorialLabel
@onready var player = $"../Player"
@onready var score_label = $Scorelabel

func _ready():
	tutorial_label.visible = true

	# No he conseguido mover  el ScoreLabel desde el editor,lo pongo por código aquí aunque es menos elegante
	vidas_label.position = Vector2(20, 20)
	score_label.position = Vector2(20, 55)

func _process(_delta): #hud básica
	vidas_label.text = "❤️ x" + str(player.vidas)

	# Sistema de puntuación, lo hacemos con la distancia recorrida + piezas recolectadas. Cada pieza vale 1000 puntos.
	var puntuacion = int(player.global_position.x + 2170) + (player.piezas_recolectadas * 1000) #le sumo 2170 por que como empezamos el juego en un eje negativo de X la puntuación empieza en negativo unos 2170 puntos.
	score_label.text = "🏆 " + str(puntuacion)

	if tutorial_label.visible: #esto es para tener el típico menú de tutorial con las teclas
		if Input.is_action_just_pressed("jump") \
		or Input.is_action_just_pressed("pasado") \
		or Input.is_action_just_pressed("presente") \
		or Input.is_action_just_pressed("futuro"):
			tutorial_label.visible = false

func actualizar_vidas(vidas: int) -> void: #para actualizar las vidas
	vidas_label.text = "❤️ x" + str(vidas)
