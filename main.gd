extends Node
class_name Main

#=========================================
# Class Member Data

@export var world:World

func _ready() -> void:
	world = $World

func _process(delta: float) -> void:
	pass


func _input(event:InputEvent):
	if event is InputEventMouseButton: 
		pass
	if event is InputEventKey:
		var c = event.as_text_keycode()
		pass
		
func _physics_process(delta):
	pass
	

func query_by_pos(pos: Vector2) -> RigidBody2D:
	var p = PhysicsPointQueryParameters2D.new()
	p.position = pos
	var hits = world.get_world_2d().direct_space_state.intersect_point(p)
	for h in hits:
		if h.collider is RigidBody2D:
			return h.collider
	return null
