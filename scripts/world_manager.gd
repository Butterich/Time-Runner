extends Node2D

@export var past_world: PackedScene
@export var present_world: PackedScene
@export var future_world: PackedScene

var current_world: Node2D

func _ready() -> void: #esto nos permite cambiar de mundo
	change_world(past_world)

func _input(event: InputEvent) -> void: #esto crea el desplegable. He intentado que se cargasen los tres "mundos" a la vez pero da muchísimos problemas de solapamiento. El resultado es un ligero lag al cambiar de era pero hemos decidido que queda incluso bien
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_1:
			change_world(past_world)
		elif event.keycode == KEY_2:
			change_world(present_world)
		elif event.keycode == KEY_3:
			change_world(future_world)

func change_world(world_scene: PackedScene) -> void:
	if current_world != null:
		current_world.queue_free()

	current_world = world_scene.instantiate()
	current_world.position = Vector2.ZERO #para cuadrar vectores
	add_child(current_world)
