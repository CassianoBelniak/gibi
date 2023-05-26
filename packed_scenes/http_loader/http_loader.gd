extends Node

var _remaining_loads := 0.0

func load_image_into_texture(texture: Node, url: String):
	var http_request = HTTPRequest.new()
	add_child(http_request)
	print(url)
	http_request.request_completed.connect(
		func (result, _response_code, _headers, body): 
			_http_request_texture_completed(result, body, texture)
			)
	var error = http_request.request(url)
	if error != OK:
		push_error("An error occurred in the HTTP request.")
	_remaining_loads += 1

func has_pendings_requests() -> bool:
	return _remaining_loads > 0

func load_json_content(url: String, callback):
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(func (_result, _response_code, _headers, body): _page_load_result(body, callback))
	var error = http_request.request(url)
	if error != OK:
		push_error("An error occurred in the HTTP request.")

func _http_request_texture_completed(result, body, node):
	if result != HTTPRequest.RESULT_SUCCESS:
		push_error("Image couldn't be downloaded. Try a different image.")
	var image = Image.new()
	var error = image.load_png_from_buffer(body)
	if error != OK:
		push_error("Couldn't load the image.")
	var texture = ImageTexture.create_from_image(image)
	node.texture = texture
	_remaining_loads -= 1

func _page_load_result(body, callback: Callable):
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	var object = json.get_data()
	callback.call(object)
