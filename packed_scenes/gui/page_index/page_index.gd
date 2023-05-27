extends Control

signal page_changed(page)

@onready var page_tree : Tree = %PageTree
@onready var content = %Content

func _ready():
	Pages.pages_updated.connect(_on_pages_updated)

func _update_pages():
	page_tree.clear()
	var root = page_tree.create_item()
	for page in Pages.cache:
		_add_subpage(root, page)

func _add_subpage(root: TreeItem, page: Dictionary):
	var subpage := page_tree.create_item(root)
	subpage.set_text(0, page.get('title', 'Missing title property'))
	subpage.set_metadata(0, {"content": page})
	for subpage_page in page.get('children', []):
		_add_subpage(subpage, subpage_page)

func _on_pages_updated():
	_update_pages()

func navigate_to_next_page():
	var item := page_tree.get_selected()
	var next := item.get_next()
	page_tree.set_selected(next, 0)
	page_tree.ensure_cursor_is_visible()

func navigate_to_previous_page():
	var item = page_tree.get_selected()
	var prev = item.get_prev()
	page_tree.set_selected(prev, 0)
	page_tree.ensure_cursor_is_visible()

func can_navigate_to_next() -> bool:
	var item := page_tree.get_selected()
	if item:
		return item.get_next() != null
	return false

func can_navigate_to_previous() -> bool:
	var item = page_tree.get_selected()
	if item:
		return item.get_prev() != null
	return false

func _on_page_tree_item_selected():
	var item = page_tree.get_selected()
	var metadata = item.get_metadata(0)
	page_changed.emit(metadata.content)


func _on_close_button_pressed():
	content.visible = not content.visible
	if content.visible:
		custom_minimum_size.x = 300
	else:
		custom_minimum_size.x = 0
