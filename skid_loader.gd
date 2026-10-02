extends Node2D
class_name SkidLoader

const SkidLoaderScene = preload("res://skid_loader.tscn")

#========== Local Data =========
var drive:float = 0
var angle1:= Utils.SmoothVar.new(.005)
var angle2:= Utils.SmoothVar.new(.005)
var angle3:= Utils.SmoothVar.new(.005)


static func create(pos=null) -> SkidLoader:
	var skid = SkidLoaderScene.instantiate()
	if pos != null:skid.position = pos
	else: skid.position = Vector2(500,500)
	return skid


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#drive_hinge($Chassis/Arm1, angle1)
	pass


func drive_hinge(arm:RigidBody2D, new_angle:float):
	var h : RapierPinJoint2D = arm.get_node("Hinge")
	h.motor_position_target_angle = new_angle
	#print(new_angle)

func fix_hinge(arm:RigidBody2D, y:float):
	var h : RapierPinJoint2D = arm.get_node("Hinge")
	h.transform.origin.y = y
	h.node_a = h.node_a
	h.node_b = h.node_b
	#h.set_joint_type()
	print(h.transform)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
var key = Utils.KeyState.new()

func input_key(ch: String, pressed:bool):
	key.set_value(ch, pressed)
	if not pressed: return
	if ch=='Q': get_tree().quit()
	if ch=='P': angle1.maxv *= 2
	if ch=='Semicolon': angle1.maxv /= 2
	print(angle1.x, ' ', angle1.tx, ' ', angle1.acc, ' ', angle1.maxv, ' ch=',ch)


func handle_keys():
	drive = -1 if key['A'] else 1 if key['S'] else 0
	if key['J']: if angle1.tx<3: angle1.tx += .1
	if key['U']: if angle1.tx>-1: angle1.tx -= .1
	if key['K']: if angle2.tx<0: angle2.tx += .1
	if key['I']: if angle2.tx>-6: angle2.tx -= .1
	if key['L']: if angle3.tx<3.4: angle3.tx += .1
	if key['O']: if angle3.tx>-1.1: angle3.tx -= .1


func _physics_process(delta: float) -> void:
	handle_keys()
	var b = 10000
	if drive:
		$Chassis/RearWheel.apply_torque(drive * b)
		$Chassis/FrontWheel.apply_torque(drive * b)
	angle1.step()
	angle2.step()
	angle3.step()
	drive_hinge($Chassis/Boom, angle1.x)
	drive_hinge($Chassis/Boom/Stick, angle2.x)
	drive_hinge($Chassis/Boom/Stick/Bucket, angle3.x)
