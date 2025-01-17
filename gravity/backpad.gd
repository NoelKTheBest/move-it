extends StaticBody2D

signal touched_pad
signal off_pad

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
 

func _on_area_2d_body_entered(body: Node2D) -> void:
	touched_pad.emit()


func _on_area_2d_body_exited(body: Node2D) -> void:
	off_pad.emit()
