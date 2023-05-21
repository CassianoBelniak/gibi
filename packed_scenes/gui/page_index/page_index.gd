extends Control

@onready var page_tree = %PageTree

func _ready():
	Pages.pages_updated.connect(_on_pages_updated)

func _update_pages():
	page_tree.clear()
	var root = page_tree.create_item()
	for page in Pages.cache:
		_add_subpage(root, page)

func _add_subpage(root, page):
	var subpage = page_tree.create_item(root)
	subpage.set_text(0, page.get('title', 'Missing title property'))
	for subpage_page in page.get('children', []):
		_add_subpage(subpage, subpage_page)

func _on_pages_updated():
	print('Pages reloaded')
	_update_pages()
