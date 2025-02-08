@tool
extends DialogicIndexer

func _get_editors() -> Array:
	return [
		this_folder.path_join('timeline_graphing.tscn')
	]
