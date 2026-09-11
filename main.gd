extends Node
class_name Main

#=========================================
# Class Member Data

@export var world:World

func _ready() -> void:
	world = $World
	Utils.create_all_walls(self)
	Utils.create_skid_loader(self)
	Utils.dump_physics_stuff(world.get_world_2d().get_space())

func _process(delta: float) -> void:
	pass


func _input(event:InputEvent):
	if not event is InputEventMouseButton: return
	print(event.position.x)


func _physics_process(delta):
	pass
	
func vw_size() -> Vector2:
	return get_viewport().get_visible_rect().size


func query_by_pos(pos: Vector2) -> RigidBody2D:
	var p = PhysicsPointQueryParameters2D.new()
	p.position = pos
	var hits = world.get_world_2d().direct_space_state.intersect_point(p)
	for h in hits:
		if h.collider is RigidBody2D:
			return h.collider
	return null
