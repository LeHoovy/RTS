extends Window


func _ready() -> void:
	print("Window loaded")


func _on_cancel_pressed() -> void:
	self.queue_free()
