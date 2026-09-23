extends Node2D
class_name MyTest

const MyTestScene = preload("res://my_test.tscn")

#========== Local Data =========
var drive:float = 0
var angle1:float = 0
var angle2:float = 0
var angle3:float = 0
var jointlen:float = 24

static func create(pos=null) -> MyTest:
	var skid = MyTestScene.instantiate()
	if pos != null:skid.position = pos
	else: skid.position = Vector2(500,500)
	return skid


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


func drive_hinge(arm:RigidBody2D, new_angle:float):
	var h : PinJoint2D = arm.get_node("Hinge")
	#h.set_notify_transform()
	h.motor_position_target_angle = new_angle
	#print(new_angle)

func fix_hinge(arm:RigidBody2D, y:float):
	var h : PinJoint2D = arm.get_node("Hinge")
	h.transform.origin.y = y
	h.node_a = h.node_a
	h.node_b = h.node_b
	#h.set_joint_type()
	print(h.transform)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func input_key(ch: String, pressed:bool):
	if ch == 'A': drive = -1 * int(pressed)
	if ch == 'S': drive = 1 * int(pressed)
	if ch == 'J': if angle1<3: angle1 += .1
	if ch == 'U': if angle1>-1: angle1 -= .1
	if ch == 'K': if angle2<0: angle2 += .1
	if ch == 'I': if angle2>-6: angle2 -= .1
	if ch == 'L': if angle3<3.4: angle3 += .1
	if ch == 'O': if angle3>-1.1: angle3 -= .1
	if ch == 'P': jointlen += 1
	print(angle1,' ',angle2,' ',angle3)


func _physics_process(delta: float) -> void:
	pass
