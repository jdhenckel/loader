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


#static func change_angle(hinge:PinJoint2D, angle:float):
	#hinge.angular_limit_lower += angle
	#hinge.angular_limit_upper += angle
	#hinge.motor_target_velocity = angle * 10


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


func drive_hinge(arm:RigidBody2D, new_angle:float):
	var h = arm.get_node("Hinge")
	var d = h.get_node("Drive")
	var r = Vector2.from_angle(new_angle + PI/2)
	print(d.position, ' ',new_angle,arm.position)
	d.position = r * 56
	arm.position = r * 24 + Vector2(40,0)
	arm.rotation = new_angle + PI/2
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func input_key(ch: String, pressed:bool):
	if ch == 'A': drive = -1 * int(pressed)
	if ch == 'S': drive = 1 * int(pressed)
	if ch == 'U': angle1 += .1
	if ch == 'J': angle1 -= .1


func _physics_process(delta: float) -> void:
	var b = 10000
	if drive:
		print(drive)
		$Chassis/RearWheel.apply_torque(drive * b)
		$Chassis/FrontWheel.apply_torque(drive * b)
	drive_hinge($Chassis/Arm1, angle1)
