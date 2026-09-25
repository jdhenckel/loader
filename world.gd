extends Node2D
class_name World

@export var space:RID
@export var skid:SkidLoader
@export var myt:MyTest
@export var skm:Skidman

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	space = get_world_2d().get_space()
	Utils.create_all_walls(self)
	skm = Skidman.create()
	#skm.get_node('Chassis').transform = Transform2D(0, Vector2(500, 500))
	add_child(skm)

	#skid = SkidLoader.create()
	#add_child(skid)
	#myt = MyTest.create()
	#myt.transform = Transform2D(PI, Vector2(500, 500))
	#add_child(myt)
	var ball = Utils.create_ball(300,500)
	ball.linear_velocity.x = 50
	add_child(ball)
	Utils.dump_physics_stuff(get_world_2d().get_space())


func _input(event:InputEvent):
	if event is InputEventKey:
		pass
		#skid.input_key(event.as_text_keycode(), event.pressed)
		skm.input_key(event.as_text_keycode(), event.pressed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:
	pass
