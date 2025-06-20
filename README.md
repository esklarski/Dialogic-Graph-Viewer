# Dialogic Graph Viewer

An experiment using Godot's GraphEdit system to create a tree visualization for the Dialogic plugin.
![image](https://github.com/user-attachments/assets/38427911-490a-4406-ad7b-a469d914935f)

For now I'm implementing this as a macro viewer, less concerned with timeline inner workings and focusing (for now) on the connections between timelines.
My team and I have decided to proceed this way for now because:
  (a) it is the simpler route to get a high level view, and
  (b) we feel any single timeline shouldn't ever get so complicated (or long) that it becomes unweildy in the current timeline editor.

We've talked about making comment events editable though for now I'm keeping this a read only viewer until I get the hang of GraphEdit.


# Instalation

The files here need to reside in the folder: `res://addons/dialogic_additions/`

Like:
```
res://
  -addons/
    -dialogic/
    -dialogic_additions/
      -GraphViewer (*this addon*)
        - scripts/
          - ...
        - index.gd
        - timeline_graphing.tscn
```

Then reload the current project and you should see the viewer.


# Further Information

Uses the Dialogic Plugin and the Godot Engine:
- https://godotengine.org/
- https://github.com/dialogic-godot/dialogic

Dialogic issue:
- https://github.com/dialogic-godot/dialogic/issues/2081
