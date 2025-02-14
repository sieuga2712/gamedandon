extends Node

static func get_random_position_in_area(collision_shape:CollisionShape2D,position:Vector2) -> Vector2:
	var circle_shape = collision_shape.shape as CircleShape2D
	var radius = circle_shape.radius
	var random_angle = randf_range(0, 2 * PI)
	var random_radius = randf_range(0, radius)
	var random_x = random_radius * cos(random_angle)
	var random_y = random_radius * sin(random_angle)
	return Vector2(random_x+position.x, random_y+position.y)
static func find_node_count(node:Node2D)->bool:
	if node.get_child_count() >0:
		return true
	return false
