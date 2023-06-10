extends Node

signal pages_updated
signal page_changed(page)

var cache := []
var mapped_pages := {}
var current_page_key := "loading"

@onready var http_loader = %HttpLoader

func _ready():
	Config.config_loaded.connect(_queue_pages_load)
	
func navigate_to_next_page():
	var current_page = mapped_pages.get("current_page_key", {})
	if current_page["next_page_key"]:
		navigate_to(current_page["next_page_key"])

func navigate_to_previous_page():
	var current_page = mapped_pages.get("current_page_key", {})
	if current_page["prev_page_key"]:
		navigate_to(current_page["prev_page_key"])

func can_navigate_to_next() -> bool:
	var current_page = mapped_pages.get("current_page_key", {})
	return current_page.has("next_page_key")

func can_navigate_to_previous() -> bool:
	var current_page = mapped_pages.get("current_page_key", {})
	return current_page.has("prev_page_key")

func navigate_to(page_key: String):
	prints("Navigated to", page_key)
	var page = mapped_pages.get(page_key, mapped_pages.get("not-found", mapped_pages.get("home", {})))
	page_changed.emit(page.page)
	
func _queue_pages_load():
	prints('Loading pages:', Config.cached.pagesURL)
	http_loader.load_json_content(Config.cached.pagesURL,_page_load_result)
	
func _page_load_result(pages):
	print('Pages loaded')
	cache = pages
	_on_pages_updated()
	pages_updated.emit()

func _update_pages():
	mapped_pages.clear()
	_register_archive()
	for page in Pages.cache:
		_add_subpage(page)

func _register_archive():
	mapped_pages["archive"] = { "page": { "path": "res://packed_scenes/special_pages/index_content/index_content.tscn" } }

func _add_subpage(page: Dictionary, prev_page_key = null, next_page_key = null):
	var key = page.get("key", null)
	if key:
		mapped_pages[key] = {"page": page, "prev_page_key": prev_page_key, "next_page_key": next_page_key }
	var subpages : Array = page.get('children', [])
	var index := 0
	for subpage in subpages:
		var prev_subpage_key
		if index > 0:
			prev_subpage_key = subpages[index-1].get("key", null)
		var next_subpage_key
		if index < subpages.size() - 1:
			next_subpage_key = subpages[index+1].get("key", null)
		_add_subpage(subpage, prev_subpage_key, next_subpage_key)
		index += 1

func _on_pages_updated():
	_update_pages()
	if current_page_key == "loading":
		navigate_to("home")
