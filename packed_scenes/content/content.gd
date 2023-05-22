extends Control

@onready var panels = %Panels
@onready var http_loader = %HttpLoader

func set_page(content: Dictionary):
	_clear_pages()
	http_loader.load_json_content(content.source, _on_page_content_loaded)
	
func _on_page_content_loaded(content):
	for panel in content.get("panels", []):
		_create_panel(panel)
		
func _clear_pages():
	for child in panels.get_children():
		child.queue_free()
	
func _create_panel(panel: Dictionary):
	var panel_control := Control.new()
	panel_control.clip_children = CanvasItem.CLIP_CHILDREN_AND_DRAW
	panel_control.custom_minimum_size.x = panel.dimensions.width
	panel_control.custom_minimum_size.y = panel.dimensions.heigth
	panels.add_child(panel_control)
	for content in panel.get('content',[]):
		_add_content(content, panel_control)
		
func _add_content(parent_content: Dictionary, parent: Control):
	var control := _get_content_control(parent_content)
	parent.add_child(control)
	for content in parent_content.get('content',[]):
		_add_content(content, control)

func _get_content_control(content: Dictionary) -> Control:
	match content.type:
		"texture": return _make_texture(content)
	return Control.new()
	
func _make_texture(content: Dictionary) -> TextureRect:
	var texture := TextureRect.new()
	http_loader.load_image_into_texture(texture, content.url)
	return texture
