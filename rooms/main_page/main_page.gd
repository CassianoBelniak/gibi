extends Control

@onready var content = %Content
@onready var top_navigation = %TopNavigation
@onready var botton_navigation = %BottonNavigation

func _ready():
	Pages.pages_updated.connect(_on_pages_updated)
	Pages.page_changed.connect(_on_page_index_page_changed)

func _on_page_index_page_changed(page: Dictionary):
	_update_navigation()
	content.set_page(page)

func _update_navigation():
	top_navigation.set_next_visibility(Pages.can_navigate_to_next())
	top_navigation.set_previous_visibility(Pages.can_navigate_to_previous())
	botton_navigation.set_next_visibility(Pages.can_navigate_to_next())
	botton_navigation.set_previous_visibility(Pages.can_navigate_to_previous())

func _on_navigation_next_clicked():
	Pages.navigate_to_next_page()

func _on_navigation_previous_clicked():
	Pages.navigate_to_previous_page()

func _on_pages_updated():
	_update_navigation()

func _on_resized():
	await Utils.for_initialization(self)
	content.force_linear_content = size.x < 800
