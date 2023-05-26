class_name Render

static func get_rendered_children(content: Array, http_loader) -> Array:
	return content.map(func (element): return _get_element(element, http_loader))

static func _get_element(content: Dictionary, http_loader) -> Node:
	match content.get('type'):
		"texture": return _make_texture(content, http_loader)
	return Node.new()

	
static func _make_texture(content: Dictionary, http_loader) -> Sprite2D:
	var texture := Sprite2D.new()
	http_loader.load_image_into_texture(texture, content.url)
	return texture
