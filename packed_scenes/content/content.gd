extends Control

@onready var http_loader = %HttpLoader
@onready var sections = %Sections

func set_page(content: Dictionary):
	_clear_pages()
	if content.has('source'):
		http_loader.load_json_content(content.source, _on_page_content_loaded)
	
func _on_page_content_loaded(content):
	for section in content.get('sections', []):
		_create_section(section)
	
func _create_section(content: Dictionary):
	var section := FlowContainer.new()
	section.custom_minimum_size.y = content.get('dimensions', {}).get('heigth',0) + 5
	section.vertical = content.get('direction', 'horizontal') == 'vertical'
	section.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	sections.add_child(section)
	for panel in content.get("panels", []):
		_create_panel(panel, section)
		
func _clear_pages():
	for child in sections.get_children():
		child.queue_free()
	
func _create_panel(content: Dictionary, section: FlowContainer):
	var panel := ColorRect.new()
	# panel.clip_children = CanvasItem.CLIP_CHILDREN_AND_DRAW
	panel.custom_minimum_size.x = content.dimensions.width
	panel.custom_minimum_size.y = content.dimensions.heigth
	section.add_child(panel)
	return
	for element in content.get('elements',[]):
		_add_content(element, panel)
		
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
