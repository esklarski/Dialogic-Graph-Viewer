@tool
extends GraphEdit

const NODE_PREFIX: String =  "Node%d"

## Add timeline filepath here to have the viewer load it.
const PATHS: Array[String] = [
	"res://testing/timeline_graphing/timelines/timeline_graphing_1.dtl",
	"res://testing/timeline_graphing/timelines/timeline_graphing_2.dtl",
	"res://testing/timeline_graphing/timelines/timeline_graphing_3.dtl",
	"res://testing/timeline_graphing/timelines/timeline_graphing_4.dtl",
]

var initialized: bool = false
var node_count: int = 0
var timeline_nodes: Array[TimelineGraphNode] = []


func init():
	if initialized: return
	
	print("Initializing graph view.")
	gui_input.connect(_on_gui_input) # does nothing
	popup_request.connect(_on_popup_requested) # triggers creating linked nodes
	
	var directory: Dictionary = ProjectSettings.get_setting("dialogic/directories/dtl_directory", {})
	var timelines: Array[String]
	
	for file in directory:
		timelines.append(directory[file])
	
	_load_timelines(timelines)
	_connect_timelines()
	arrange_nodes()
	
	initialized = true

# take timeline filepaths and process them into TimelineGraphNodes
func _load_timelines(files: Array[String]) -> void:
	var timelines: Array[TimelineView] = []
	
	for path in files:
		var next_timeline := TimelineView.procress_timeline(path)
		if not next_timeline == null: # and next_timeline.events.size() > 0:
			timelines.append(next_timeline)
	
	for timeline in timelines:
		var timeline_node: TimelineGraphNode = TimelineNodeTools.create_timeline_node(timeline)
		add_child(timeline_node)
		timeline_nodes.append(timeline_node)

# connect all node ports
func _connect_timelines() -> void:
	for timeline in timeline_nodes:
		_connect_timeline(timeline)

# connect output ports of TimelineGraphNode
func _connect_timeline(timeline: TimelineGraphNode) -> void:
	for output in timeline.outputs:
		var temp = timeline.outputs[output].split("/")
		var node_title: String = temp[0]
		var port_name: String = temp[1]
		var destination_port: int = -1
		
		if port_name.ends_with("begining"):
			destination_port = 0
		else:
			var destination_node: TimelineGraphNode = _get_timeline_by_title(node_title)
			if not destination_node == null:
				destination_port = destination_node.inputs[port_name]
			
		connect_node(timeline.title, output, node_title, destination_port)

#
func _get_timeline_by_title(title: String) -> TimelineGraphNode:
	for timeline in timeline_nodes:
		if timeline.title == title:
			return timeline
	
	return null


func _on_gui_input(event: InputEvent) -> void:
	pass

func _on_popup_requested(clicked_position: Vector2) -> void:
	var new_node = _create_new_linked_node()
	
	add_child(new_node)
	new_node.position_offset = (clicked_position + scroll_offset) / zoom


#region linked node creation
func _create_new_linked_node() -> GraphNode:
	var new_node: GraphNode = GraphNode.new()
	new_node.name = NODE_PREFIX % node_count
	new_node.title = new_node.name
	
	var node_input = Label.new()
	node_input.text = "Input"
	new_node.add_child(node_input)
	new_node.set_slot_enabled_left(0,true)
	
	var node_output = Label.new()
	node_output.text = "Output"
	new_node.add_child(node_output)
	new_node.set_slot_enabled_right(1,true)
	
	if node_count > 0:
		var last_node: String = NODE_PREFIX % (node_count - 1)
		connect_node(last_node, 0, new_node.name, 0)
	
	node_count += 1
	
	return new_node
#endregion
