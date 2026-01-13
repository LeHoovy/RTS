class_name PlayerCommander extends Commander


func _ready() -> void:
	commanders.push_back(self as PlayerCommander)
