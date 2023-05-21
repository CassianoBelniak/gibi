extends Control

signal next_clicked
signal previous_clicked
signal index_clicked

@onready var left_button = $LeftButton
@onready var right_button = $RightButton

func set_next_visibility(next_visible: bool):
	right_button.visible = next_visible

func set_previous_visibility(previous_visible: bool):
	left_button.visible = previous_visible

func _on_left_button_pressed():
	previous_clicked.emit()


func _on_index_button_pressed():
	index_clicked.emit()


func _on_right_button_pressed():
	next_clicked.emit()
