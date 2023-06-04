extends Node

signal pages_updated

var cache := []

@onready var http_loader = %HttpLoader

func _ready():
	Config.config_loaded.connect(_queue_pages_load)
	
func _queue_pages_load():
	prints('Loading pages:', Config.cached.pagesURL)
	http_loader.load_json_content(Config.cached.pagesURL,_page_load_result)
	
func _page_load_result(pages):
	print('Pages loaded')
	cache = pages
	pages_updated.emit()

