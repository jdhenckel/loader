extends Node2D
class_name SkidLoader

const SkidLoaderScene = preload("res://skid_loader.tscn")

#========== Local Data =========
var drive:float = 0
var angle1:= Utils.SmoothVar.new(.001, .02).set_limits(-1,3)
var angle2:= Utils.SmoothVar.new(.003, .02).set_limits(-6,.01)
var angle3:= Utils.SmoothVar.new(.005, .02).set_limits(-1.1,4.1)


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
	#print(h.transform)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
var key = Utils.KeyState.new()

func input_key(ch: String, pressed:bool):
	key.action(ch, pressed)
	if not pressed: return
	if ch=='Q': get_tree().quit()
	if ch=='P': angle1.maxv *= 2
	if ch=='Semicolon': angle1.maxv /= 2


func handle_keys():
	drive = -1 if key.down('A') else 1 if key.down('S') else 0
	if key.pressed ('J'): angle1.spin(1)
	if key.released('J'): 
		if key.down('U'): angle1.spin(-1) 
		else: angle1.stop_soon()
	if key.pressed ('U'): angle1.spin(-1)
	if key.released('U'):
		if key.down('J'): angle1.spin(1)
		else: angle1.stop_soon()
	if key.pressed ('K'): angle2.spin(1)
	if key.released('K'):
		if key.down('I'): angle2.spin(-1)
		else: angle2.stop_soon()
	if key.pressed ('I'): angle2.spin(-1)
	if key.released('I'):
		if key.down('K'): angle2.spin(1)
		else: angle2.stop_soon()
	if key.pressed ('L'): angle3.spin(1)
	if key.released('L'):
		if key.down('O'): angle3.spin(-1)
		else: angle3.stop_soon()
	if key.pressed ('O'): angle3.spin(-1)
	if key.released('O'):
		if key.down('L'): angle3.spin(1)
		else: angle3.stop_soon()


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
