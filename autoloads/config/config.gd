extends Node
const EditorConfig = preload("res://env/editor_config.gd")

signal config_loaded

@onready var http_loader = %HttpLoader

var cached := {}

func _ready():
	var config_url 
	if OS.has_feature('editor'):
		config_url = EditorConfig.CONFIG_URL
	else:
		config_url = JavaScriptBridge.eval("GIBI_CONFIG_URL")
	prints('Loading config:', config_url)
	http_loader.load_json_content(config_url, _on_config_loaded)

func _on_config_loaded(json: Dictionary):
	prints('Config loaded')
	cached = json
	config_loaded.emit()
