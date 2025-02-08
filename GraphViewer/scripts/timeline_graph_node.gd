class_name TimelineGraphNode extends GraphNode

var view: TimelineView
var inputs: Dictionary = {}
var outputs: Dictionary = {}

func _ready():
	gui_input.connect(_on_gui_input)

#func _draw_port(slot_index, position, left, color):
	#var port_position: Vector2i = position
	#
	## example of filtering children to find slot node
	##var things = get_children()
	##var slots: Array = []
	##for thing in things:
		##if not thing.name.begins_with("comment"):
			##slots.append( thing )
	##print("slot %d: %s" % [slot_index, slots[slot_index].name])
	#
	#if slot_index == 0:
		## TODO: how to also move the location of connection line point
		##port_position -= Vector2i(,0)
		#draw_circle(port_position, 2.5, Color.WHITE)
	#else:
		#draw_circle(port_position, 7.5, color)

func _on_gui_input(event: InputEvent):
	# capture the input to prevent cascading down
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT:
		# TODO: context menu: "open timeline" -> Dialogic tab
		
		get_window().set_input_as_handled()
