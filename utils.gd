class_name Utils

const SkidLoaderScene = preload("res://skid_loader.tscn")


static func create_wall(x,y,w,h) -> StaticBody2D:
	var wall = StaticBody2D.new()
	var shape = CollisionShape2D.new()
	var rect = RectangleShape2D.new()
	rect.size = Vector2(w,h)
	shape.shape = rect
	wall.add_child(shape)
	wall.position = Vector2(x+w/2,y+h/2)
	return wall


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

static func create_skid_loader(node, pos=null):
	var mag = SkidLoaderScene.instantiate()
	if pos != null:
		mag.position = pos
	node.add_child(mag)


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
	
