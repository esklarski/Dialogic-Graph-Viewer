
class_name TimelineView
## Experimental Class!
##
## Use at your own peril.
## Used to filter [DialogicTimeline]'s into something usable by the timeline GraphEdit project.

var name: String = ""
var path: String = ""
var events: Array = []
#var outputs: Dictionary = {}

func as_string() -> String:
	var event_string = "%s: " % name
	
	for event in events:
		var view: String = "%s" % event
		view = view.lstrip("[").rstrip("]")
		view = view.split(":")[0]
		
		event_string += "%s" % view
		
		if events.find(event) < events.size() - 1:
			event_string += ", "
	
	return event_string

static func procress_timeline(timeline_filename: String) -> TimelineView:
	var timeline: DialogicTimeline = ResourceLoader.load(timeline_filename)
	
	if timeline == null:
		print("Not a Timeline file: %s" % timeline_filename)
		return null
	
	timeline.process()
	
	var new_view: TimelineView = TimelineView.new()
	new_view.name = timeline_filename.get_file().trim_suffix(".dtl")
	new_view.path = timeline_filename
	
	for event in timeline.events:
		if event is DialogicCommentEvent: pass
		elif event is DialogicLabelEvent: pass
		#elif event is DialogicChoiceEvent: pass
		#elif event is HasFlagConditionEvent: pass
		elif event is DialogicJumpEvent:
			if event.timeline == null: continue;
			else: pass
		elif event is DialogicEndTimelineEvent: pass
		else: continue
		
		new_view.events.append(event)
	
	return new_view
