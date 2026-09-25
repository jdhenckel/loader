extends Node
class_name Skidman

const SkidmanScene = preload("res://skidman.tscn")

#========== Local Data =========
var drive:float = 0
var angle1:float = 0
var angle2:float = 0
var angle3:float = 0
var jointlen:float = 24

static func create(pos=null) -> Skidman:
	var skid = SkidmanScene.instantiate()
	if pos != null:skid.get_node('Chassis').position = pos
	else: skid.get_node('Chassis').position = Vector2(500,500)
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
	if not pressed: return
	var sp = .05
	if ch == 'A': drive = -1 * int(pressed)
	if ch == 'S': drive = 1 * int(pressed)
	if ch == 'J': if angle1<1.4: angle1 += sp
	if ch == 'U': if angle1>-3: angle1 -= sp
	if ch == 'K': if angle2<2.8: angle2 += sp
	if ch == 'I': if angle2>-2.8: angle2 -= sp
	if ch == 'L': if angle3<2.8: angle3 += sp
	if ch == 'O': if angle3>-2.8: angle3 -= sp
	print(angle1,' ',angle2,' ',angle3)


func move_arm(node:StaticBody2D, a:float):
	var p = Vector2.from_angle(a) * 64
	node.transform = Transform2D(a, p)


func _physics_process(delta: float) -> void:
	move_arm($Chassis/Drive1, angle1)
	move_arm($Chassis/Drive1/Drive2, angle2)
	move_arm($Chassis/Drive1/Drive2/Drive3, angle3)
