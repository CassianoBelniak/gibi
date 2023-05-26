extends Control

@export var zoom := 1.0 : set = _set_zoom

@onready var origin : Node2D = %Origin

func load_content(content, http_loader):
	await Utils.for_initialization(self)
	var children = Render.get_rendered_children(content, http_loader)
	for child in children:
		origin.add_child(child)

func _set_zoom(ammount: float):
	await Utils.for_initialization(self)
	origin.scale = Vector2(1/ammount, 1/ammount)
