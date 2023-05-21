extends Node

var cache := []

signal pages_updated

func _ready():
	await get_tree().create_timer(1).timeout
	_queue_pages_load()

func _queue_pages_load():
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(_page_load_result)
	var error = http_request.request("http://127.0.0.1:5500/debug_server/pages.json")
	if error != OK:
		push_error("An error occurred in the HTTP request.")

func _page_load_result(_result, _response_code, _headers, body):
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	cache = json.get_data()
	pages_updated.emit()

