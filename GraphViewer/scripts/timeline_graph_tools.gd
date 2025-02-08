
class_name TimelineNodeTools

# Should be moved to it's own file, but here's where they're useful right now.
const COMMENT_COLOR: Color = Color("5f9ea0")
const LABEL_COLOR: Color = Color("008080")
const JUMP_COLOR: Color = Color("663399")
enum LabelType { COMMENT, LABEL, JUMP }

# Process TimelineView into TimelineGraphNode
static func create_timeline_node(view: TimelineView) -> GraphNode:
	var new_node: TimelineGraphNode = TimelineGraphNode.new()
	var current_input_port: int = 0
	var current_output_port: int = -1
	
	new_node.name = view.name
	new_node.title = view.name
	new_node.tooltip_text = view.path
	new_node.view = view
	
	# default entry for "begining" connection
	var default_input := Control.new()
	default_input.name = "begining"
	new_node.add_child(default_input)
	new_node.set_slot_enabled_left(0, true)
	current_input_port = 0
	new_node.inputs["begining"] = 0
	
	# keep count for naming purposes
	var comment_count: int = 0
	var label_count: int = 0
	var jump_count: int = 0
	
	# configure per event type
	for event in view.events:
		if event is DialogicCommentEvent:
			
			comment_count += 1
			
			var comment_panel = _get_event_panel(event.text, LabelType.COMMENT)
			comment_panel.name = "comment_%d" % comment_count 
			new_node.add_child(comment_panel)
			
		elif event is DialogicLabelEvent:
			
			label_count += 1
			
			var label_panel = _get_event_panel(event.name, LabelType.LABEL)
			label_panel.name = "label_%d" % label_count
			new_node.add_child(label_panel)
			
			_set_next_input(new_node, LABEL_COLOR)
			current_input_port += 1
			
			new_node.inputs[event.name] = current_input_port
			
		elif event is DialogicJumpEvent:
			# skip if jump within parent timeline
			if event.timeline == null: continue
			
			jump_count += 1
			
			var destination_txt: String = event.label_name if event.label_name.length() > 0 else "begining"
			var new_text = "Jump to:\n  %s\n  at: %s" % [event.timeline_identifier, destination_txt]
			var jump_panel = _get_event_panel(new_text, LabelType.JUMP)
			jump_panel.name = "jump_%d" % jump_count
			new_node.add_child(jump_panel)
			
			_set_next_output(new_node, JUMP_COLOR)
			current_output_port += 1
			
			new_node.outputs[current_output_port] = event.timeline_identifier + "/" + destination_txt
			
		else:
			# skip it
			pass
	
	return new_node


static func _set_next_input(node: TimelineGraphNode, color: Color) -> void:
	var slot = node.get_child_count() - 1
	node.set_slot_enabled_left(slot, true)
	node.set_slot_color_left(slot, color)

static func _set_next_output(node: TimelineGraphNode, color: Color) -> void:
	var slot = node.get_child_count() - 1
	node.set_slot_enabled_right(slot, true)
	node.set_slot_color_right(slot, color)
	#current_output_port += 1


# creates basic panel with style set based on event type, TODO: create a scene to instantiate more complex panels
static func _get_event_panel(text: String, type: LabelType) -> PanelContainer:
	var panel: PanelContainer = PanelContainer.new()
	
	var style_color: Color
	match type:
		LabelType.COMMENT:
			style_color = COMMENT_COLOR
		LabelType.LABEL:
			style_color = LABEL_COLOR
		LabelType.JUMP:
			style_color = JUMP_COLOR
		_:
			pass
	
	var style_box := StyleBoxFlat.new()
	style_box.bg_color = style_color
	panel.add_theme_stylebox_override("panel", style_box)
	
	var margin: MarginContainer = MarginContainer.new()
	margin.add_theme_constant_override('margin_left', 10)
	margin.add_theme_constant_override('margin_right', 10)
	margin.add_theme_constant_override('margin_top', 10)
	margin.add_theme_constant_override('margin_bottom', 10)
	
	var new_label: Label = Label.new()
	new_label.text = text
	
	margin.add_child(new_label)
	panel.add_child(margin)
	
	return panel
