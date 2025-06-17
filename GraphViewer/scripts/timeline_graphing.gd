@tool
class_name DialogicGraphViewer
extends DialogicEditor

@onready var graph_edit: GraphEdit = $GraphEdit
@onready var refresh_button: Button = %RefreshButton
@onready var clear_button: Button = %ClearButton
@onready var folder_line_edit: LineEdit = %FolderLineEdit
@onready var pick_folder_button: Button = %PickFolderButton

var default_file_path: String = "res://dialog/timelines/"

# Declare a reference to the file dialog
var folder_dialog: FileDialog

func _register() -> void:
	editors_manager.register_simple_editor(self)

func _get_title() -> String:
	return "Graph"

func _open(_extra_info:Variant = null) -> void:
	graph_edit.init()

func _ready():
	refresh_button.pressed.connect( _on_refresh_pressed )
	clear_button.pressed.connect( _on_clear_pressed )
	pick_folder_button.pressed.connect( _on_pick_folder_pressed )
	
	_setup_folder_dialog()
	
	# initialize if run standalone
	if owner == null and not Engine.is_editor_hint():
		_open()

func _setup_folder_dialog() -> void:
	folder_dialog = FileDialog.new()
	folder_dialog.access = FileDialog.ACCESS_RESOURCES
	folder_dialog.file_mode = FileDialog.FILE_MODE_OPEN_DIR
	folder_dialog.dir_selected.connect( _on_folder_selected )
	
	add_child(folder_dialog)

func _on_refresh_pressed() -> void:
	graph_edit.refresh_timelines(folder_line_edit.text)
	refresh_button.release_focus()

func _on_clear_pressed() -> void:
	graph_edit.clear_nodes()
	folder_line_edit.text = ""
	folder_line_edit.placeholder_text = "please choose a folder"
	clear_button.release_focus()

func _on_pick_folder_pressed() -> void:
	print("Something should happen...")
	var window_size: Vector2 = Vector2(300,600)
	var mouse_position: Vector2 = get_viewport().get_mouse_position()
	mouse_position.x -= window_size.x * 0.5
	folder_dialog.popup(Rect2i(mouse_position, window_size))

func _on_folder_selected(dir_path: String):
	print("Folder selected: ", dir_path)
	folder_line_edit.text = dir_path
