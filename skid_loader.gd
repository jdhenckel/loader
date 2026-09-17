extends Node2D
class_name SkidLoader

const SkidLoaderScene = preload("res://skid_loader.tscn")

#========== Local Data =========
var drive:float = 0
var angle1:float = 0
var angle2:float = 0
var angle3:float = 0

static func create(pos=null) -> SkidLoader:
	var skid = SkidLoaderScene.instantiate()
	if pos != null:skid.position = pos
	else: skid.position = Vector2(500,500)
	return skid


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	drive_hinge($Chassis/Arm1, angle1)


func drive_hinge(arm:RigidBody2D, new_angle:float):
	var h : RapierPinJoint2D = arm.get_node("Hinge")
	h.motor_position_target_angle = new_angle
	#print(new_angle)


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
	print(angle1,' ',angle2,' ',angle3)


func _physics_process(delta: float) -> void:
	var b = 10000
	if drive:
		$Chassis/RearWheel.apply_torque(drive * b)
		$Chassis/FrontWheel.apply_torque(drive * b)
	drive_hinge($Chassis/Arm1, angle1)
	drive_hinge($Chassis/Arm1/Arm2, angle2)
	drive_hinge($Chassis/Arm1/Arm2/Bucket, angle3)
