extends Node2D
class_name World

@export var space:RID
@export var skid:SkidLoader

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	space = get_world_2d().get_space()
	Utils.create_all_walls(self)
	skid = SkidLoader.create()
	add_child(skid)
	Utils.dump_physics_stuff(get_world_2d().get_space())


func _input(event:InputEvent):
	if event is InputEventKey:
		skid.input_key(event.as_text_keycode(), event.pressed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	pass
