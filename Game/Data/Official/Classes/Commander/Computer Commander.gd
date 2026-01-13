class_name ComputerCommander extends Commander


func _ready() -> void:
	commanders.push_back(self as ComputerCommander)
