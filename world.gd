extends Node2D
class_name World

@export var space:RID

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	space = get_world_2d().get_space()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	pass
