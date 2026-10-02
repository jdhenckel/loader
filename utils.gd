class_name Utils

# The purpose of this is to drive the variable x to the target tx over time.
# the acc is the rate of acceration, it must be positive
class SmoothVar:
	var tx:float = 0
	var tv:float = 0
	var stopped:bool = false
	var x:float = 0
	var v:float = 0
	var acc:float = 1
	var maxv:float = 10
	func _init(max_a=1,max_v=10,target_x=0,target_v=0):
		acc = max_a
		maxv = max_v
		tx = target_x
		tv = target_v
		stopped = (target_v==0)
		
	func stop_at(target_x):
		stopped = true
		tx = target_x
		
	func stop_soon():
		stop_at(x + abs(v/2)*v/acc)

	func stop():
		stopped = true
		v = 0
		tv = 0
		tx = x

	func set_speed(target_v):
		stopped = false
		tv = target_v

	# direction is from -1 ... +1
	func spin(dir=1):
		set_speed(maxv*dir)
		
	func step_old():
		x += v/2
		var m = x + v + abs(v/2)*v/acc
		v = clamp(v + clamp(tx - m, -acc, acc), -maxv, maxv)
		x += v/2
		
	func step():
		x += v/2
		var dv = 0
		if stopped:	dv = tx - (x + v + abs(v/2)*v/acc)
		else:		dv = tv - v
		v = clamp(v + clamp(dv, -acc, acc), -maxv, maxv)
		x += v/2


class KeyState:
	# This stores a dictionary of int for each key. The int cycles thru 
	# 3 -> 2 -> 1 -> 0.  each key is two bits 1=recent, 2=pressed
	# Thus, 3=recently pressed, 2=down, 1=recently released, 0=up
	# You must call clear() once per frame, after doing your actions
	var data = {}
	func down(key): return data.get(key, 0) > 1
	func up(key): return data.get(key, 0) <= 1
	func pressed(key): return data.get(key, 0) == 3
	func released(key): return data.get(key, 0) == 1

	# value true=down, false=up
	func set_key(key, value:bool):
		data[key] = 3 if value else 1
	
	# this function clears all the recent flags
	func clear():
		for k in data:
			data[k] = data[k] & 2

static func create_wall(x,y,w,h) -> StaticBody2D:
	var wall = StaticBody2D.new()
	var shape = CollisionShape2D.new()
	var rect = RectangleShape2D.new()
	rect.size = Vector2(w,h)
	shape.shape = rect
	wall.add_child(shape)
	wall.position = Vector2(x+w/2,y+h/2)
	return wall


static func create_brick(x,y,w=20,h=15) -> StaticBody2D:
	var ball = RapierRigidBody2D.new()
	var shape = CollisionShape2D.new()
	var rect = RectangleShape2D.new()
	rect.size = Vector2(w,h)
	shape.shape = rect
	ball.add_child(shape)
	ball.position = Vector2(x,y)
	return ball


static func create_ball(x,y,r=20) -> RigidBody2D:
	var ball = RigidBody2D.new()
	var shape = CollisionShape2D.new()
	shape.shape = CircleShape2D.new()
	ball.add_child(shape)
	ball.position = Vector2(x,y)
	return ball


static func create_all_walls(node:Node, a=1, b=100, c=0):
	# params: node=self, a=inside thickness, b=outside thickness, c=left margin
	var size = node.get_viewport().get_visible_rect().size
	# Top, Left, Bottom, Right
	node.add_child(create_wall(c - b, -b, size.x + 2*b - c, a + b))
	node.add_child(create_wall(c - b, -b, a + b, size.y + 2*b))
	node.add_child(create_wall(c - b, size.y - a, size.x + 2*b - c, a + b))
	node.add_child(create_wall(size.x - a, -b, a + b, size.y + 2*b))


static func delete_walls(node:Node):
	for child in node.get_children():
		if child is StaticBody2D:
			child.queue_free()


static func rand_pos(vw_size:Vector2) -> Vector2:
	return Vector2(randf_range(200, vw_size.x),randf_range(0, vw_size.y))

static func rand_vel(speed=20) -> Vector2:
	return Vector2(speed,0).rotated(randf_range(0,TAU))


static func dump_physics_stuff(space):
	var world_linear_damp = PhysicsServer2D.area_get_param(space,
		PhysicsServer2D.AREA_PARAM_LINEAR_DAMP)
	var world_angular_damp = PhysicsServer2D.area_get_param(space,
		PhysicsServer2D.AREA_PARAM_ANGULAR_DAMP)
	print("World linear damp = ", world_linear_damp)
	print("World angular damp = ", world_angular_damp)
	var world_linear_damp2 = PhysicsServer2D.area_get_param(space,
		PhysicsServer2D.AREA_PARAM_LINEAR_DAMP_OVERRIDE_MODE)
	var world_angular_damp2 = PhysicsServer2D.area_get_param(space,
		PhysicsServer2D.AREA_PARAM_ANGULAR_DAMP_OVERRIDE_MODE)
	print("World linear damp mode = ", world_linear_damp2)
	print("World angular damp mode = ", world_angular_damp2)
	
