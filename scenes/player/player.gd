extends CharacterBody2D

const SPEED = 400.0
const JUMP_VELOCITY = -1000.0
const GRAVITY = 4200.0
const LIMITE_CAIDA = 1200

signal vidas_cambiadas(vidas_actuales)

@export var vidas = 15
var es_invulnerable = false

var punto_respawn: Vector2
var checkpoint_actual = 0
var juego_completado = false

enum Era { PASADO, PRESENTE, FUTURO }
var current_era = Era.PASADO

@onready var sprite = $Sprite
@onready var hit_sound = $HitSound
@onready var era_sound = $EraSound
@onready var jump_sound = $JumpSound
@onready var music_player = get_parent().get_node("MusicPlayer")
@onready var jump_particles = $JumpParticles
@onready var era_particles = $EraParticles


func _ready():
	punto_respawn = global_position

	sprite.play("idle")
	add_to_group("player")

	# Música única para toda la partida.
	# Sustituye a las tres canciones por era, si dejamos una canción por era en zonas de cambio rápidas se hace muy pesado. Se puede volver a habiltiar muy rápido
	music_player.stream = load("res://assets/audio/Time_Runner Ost.ogg")
	music_player.play()

	change_era(Era.PASADO)
	vidas_cambiadas.emit(vidas)


func _physics_process(delta):
	if juego_completado:
		return

	if Input.is_action_just_pressed("pasado"):
		change_era(Era.PASADO)
	elif Input.is_action_just_pressed("presente"):
		change_era(Era.PRESENTE)
	elif Input.is_action_just_pressed("futuro"):
		change_era(Era.FUTURO)

	if not is_on_floor():
		velocity.y += GRAVITY * delta

	velocity.x = SPEED

	if Input.is_action_just_pressed("jump") and is_on_floor():
		jump_sound.play()
		jump_particles.restart() #esto gestiona que las particulas salgan al pulsar salto Y que esté en el suelo, así evitamos spams locos
		jump_particles.emitting = true 
		velocity.y = JUMP_VELOCITY

	if global_position.y > LIMITE_CAIDA:
		respawn_por_caida()

	move_and_slide()


func change_era(new_era: Era):
	era_sound.play()

	era_particles.restart() #lo mismo que con las otras partículas me gestiona el cambio de era
	era_particles.emitting = true

	current_era = new_era

	match current_era:
		Era.PASADO:
			sprite.modulate = Color(1.0, 0.9, 0.7)
		Era.PRESENTE:
			sprite.modulate = Color(0.8, 1.0, 0.8)
		Era.FUTURO:
			sprite.modulate = Color(0.7, 0.9, 1.0)

	get_tree().call_group("obstacles", "update_visibility", current_era)

	# Cambiar música de fondo según era
	# INVALIDADO POR USABILIDAD:
	# El cambio de música en cada salto temporal resultaba molesto,
	# especialmente cuando el jugador cambiaba rápidamente entre
	# pasado, presente y futuro.
	# Se ha optado por utilizar una única pista musical continua
	# para mejorar la experiencia de juego.
	#
	# match current_era:
	# 	Era.PASADO:
	# 		music_player.stream = load("res://assets/audio/pasado.wav")
	# 	Era.PRESENTE:
	# 		music_player.stream = load("res://assets/audio/presente.wav")
	# 	Era.FUTURO:
	# 		music_player.stream = load("res://assets/audio/futuro.wav")
	#
	# music_player.play()


func recibir_dano():
	if es_invulnerable:
		return

	hit_sound.play()

	vidas -= 1
	vidas_cambiadas.emit(vidas)

	print("Jugador recibe daño. Vidas restantes: ", vidas)

	if vidas <= 0:
		morir()
	else:
		activar_invulnerabilidad()


func respawn_por_caida():
	vidas -= 1
	vidas_cambiadas.emit(vidas)

	print("Jake cae. Vidas restantes: ", vidas)
	print("Respawneando en: ", punto_respawn)

	if vidas <= 0:
		morir()
		return

	global_position = punto_respawn
	velocity = Vector2.ZERO


func activar_invulnerabilidad():
	es_invulnerable = true
	sprite.modulate.a = 0.5

	await get_tree().create_timer(1.0).timeout

	sprite.modulate.a = 1.0
	es_invulnerable = false


func morir():
	get_tree().change_scene_to_file("res://scenes/GameOver.tscn")


var piezas_recolectadas = 0
var total_piezas = 10

func recolectar_pieza(puntos_valor):
	piezas_recolectadas += 1
	print("¡Pieza recolectada! +", puntos_valor, " puntos")
	print("Piezas: ", piezas_recolectadas, "/", total_piezas)

	if piezas_recolectadas >= total_piezas:
		print("=== ¡MÁQUINA REPARADA! ===")
		print("¡VICTORIA!")
