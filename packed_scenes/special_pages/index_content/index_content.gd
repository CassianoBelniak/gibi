extends Control

signal page_changed(page)

@onready var page_tree : Tree = %PageTree

func _ready():
	_update_pages()
	Pages.pages_updated.connect(_on_pages_updated)

func _update_pages():
	page_tree.clear()
	var root = page_tree.create_item()
	for page in Pages.cache:
		_add_subpage(root, page)

func _add_subpage(root: TreeItem, page: Dictionary):
	var subpage := page_tree.create_item(root)
	subpage.set_text(0, page.get('title', 'Missing title property'))
	var key = page.get("key", null)
	subpage.set_metadata(0, {"content": page, "key": key})
	for subpage_page in page.get('children', []):
		_add_subpage(subpage, subpage_page)

func _on_pages_updated():
	_update_pages()

func _on_page_tree_item_selected():
	var item = page_tree.get_selected()
	var metadata = item.get_metadata(0)
	Pages.navigate_to(metadata.content.key)

