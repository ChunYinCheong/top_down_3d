extends Spatial


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var w = $Player.weapon[0]
	$CanvasLayer/PanelContainer/VBoxContainer/Label.text = "0: " + w.name if w else "Empty"
	w = $Player.weapon[1]
	$CanvasLayer/PanelContainer/VBoxContainer/Label2.text = "1: " + w.name if w else "Empty"
	w = $Player.weapon[2]
	$CanvasLayer/PanelContainer/VBoxContainer/Label3.text = "2: " + w.name if w else "Empty"
	w = $Player.weapon[3]
	$CanvasLayer/PanelContainer/VBoxContainer/Label4.text = "3: " + w.name if w else "Empty"
	
	$CanvasLayer/PanelContainer/VBoxContainer/Label5.text = "left_index:" + str($Player.left_index)
	$CanvasLayer/PanelContainer/VBoxContainer/Label6.text = "right_index:" + str($Player.right_index)
	
	pass
