extends Control

const ComicPanel = preload("res://packed_scenes/comic_panel/comic_panel.tscn")

@export var force_linear_content := false

@onready var http_loader = %HttpLoader
@onready var sections = %Sections

func set_page(content: Dictionary):
	_clear_pages()
	if content.has('source'):
		http_loader.load_json_content(Config.cached.baseURL + content.source, _on_page_content_loaded)
	
func _on_page_content_loaded(content):
	for section in content.get('sections', []):
		_create_section(section)
	await get_tree().process_frame
	custom_minimum_size.y = sections.size.y
	
func _create_section(content: Dictionary):
	var section := _get_section_container(content)
	sections.add_child(section)
	for panel in content.get("panels", []):
		_create_panel(panel, section)
		
func _get_section_container(content: Dictionary) -> Control:
	if force_linear_content or content.get('direction', 'horizontal') == 'linear':
		var section = VBoxContainer.new()
		return section
	var section := FlowContainer.new()
	section.custom_minimum_size.y = content.get('dimensions', {}).get('heigth',0) + 5
	section.vertical = content.get('direction', 'horizontal') == 'vertical'
	section.size_flags_vertical = Control.SIZE_SHRINK_CENTER
	return section
		
func _clear_pages():
	for child in sections.get_children():
		child.queue_free()
	
func _create_panel(content: Dictionary, section: Control):
	var panel := ComicPanel.instantiate()
	panel.custom_minimum_size.x = content.dimensions.width
	panel.custom_minimum_size.y = content.dimensions.heigth
	if section is VBoxContainer:
		var panel_scale = panel.custom_minimum_size.x / 800.0
		panel.custom_minimum_size.x = 800.0
		panel.custom_minimum_size.y /= panel_scale
		panel.zoom = panel_scale
	panel.load_content(content.get('content',[]), http_loader)
	section.add_child(panel)



