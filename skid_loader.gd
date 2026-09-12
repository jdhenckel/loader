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
	#$Hinge1.angular_limit_enabled = true
	$Hinge1.angular_limit_lower = 0
	$Hinge1.angular_limit_upper = 0.001
	$Hinge1.motor_enabled = true
	$Hinge1.motor_target_velocity = -10
	$Hinge1.softness = 0

func drive_hinge(hinge:PinJoint2D, new_angle:float):
	var body_a = $Chassis
	var body_b = $Arm1
	var angle = body_b.global_rotation - body_a.global_rotation
	print('angle ',angle, '  new angle ',new_angle)
	if angle != new_angle:
		hinge.motor_target_velocity = (new_angle - angle) * 100
		body_a.sleeping = false
	

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
		$RearWheel.apply_torque(drive * b)
		$FrontWheel.apply_torque(drive * b)
	drive_hinge($Hinge1, angle1)
