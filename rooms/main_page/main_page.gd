extends Control

@onready var page_index = %PageIndex
@onready var navigation = %Navigation


func _on_navigation_index_clicked():
	page_index.visible = not page_index.visible


func _on_page_index_page_changed(_page):
	navigation.set_next_visibility(page_index.can_navigate_to_next())
	navigation.set_previous_visibility(page_index.can_navigate_to_previous())


func _on_navigation_next_clicked():
	page_index.navigate_to_next_page()


func _on_navigation_previous_clicked():
	page_index.navigate_to_previous_page()
