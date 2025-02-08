@tool
extends DialogicEditor

@onready var graph_edit = $GraphEdit

func _register() -> void:
	editors_manager.register_simple_editor(self)

func _get_title() -> String:
	return "Graph"

func _open(_extra_info:Variant = null) -> void:
	graph_edit.init()

func _ready():
	# initialize if run standalone
	if owner == null and not Engine.is_editor_hint():
		graph_edit.init()
