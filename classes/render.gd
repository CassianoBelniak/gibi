class_name Render

static func get_rendered_children(content: Array, http_loader) -> Array:
	return content.map(func (element): return _get_element(element, http_loader))

static func _get_element(content: Dictionary, http_loader) -> Node:
	match content.get('type'):
		"texture": return _make_texture(content, http_loader)
		"button": return _make_button(content)
	return Node.new()

static func _make_texture(content: Dictionary, http_loader) -> Sprite2D:
	var texture := Sprite2D.new()
	texture.position.x = content.position.x
	texture.position.y = content.position.y
	http_loader.load_image_into_texture(texture, Config.cached.baseURL + content.url)
	return texture
	
static func _make_button(content: Dictionary) -> Button:
	var button := Button.new()
	button.position.x = content.position.x
	button.position.y = content.position.y
	button.text = content.label
	if content.get("action", {}).get("goToPage", false):
		button.pressed.connect(func(): Pages.navigate_to(content.action.goToPage))
	return button
