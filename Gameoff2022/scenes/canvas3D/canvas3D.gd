extends Node3D

var mesh_size = null;

@onready var area_3d: Area3D = $MeshInstance3D/Area3D
@onready var viewport: SubViewport = $SubViewport
@onready var mesh: MeshInstance3D = $MeshInstance3D

var display_y_scale := 0.68;

var is_mouse_held := false;
var is_mouse_inside := false : set = set_is_mouse_inside;
var last_mosue_pos3D = null
var last_mosue_pos2D = Vector2.ZERO;

func _ready() -> void:
	area_3d.mouse_entered.connect(_mouse_entered_area);
	
	for node in get_children():
		if !(node in [viewport,mesh]):
			remove_child(node);
			viewport.add_child(node);
	
	if viewport != null:
		set_panel_size(display_y_scale);
	
	
func _mouse_entered_area():
	is_mouse_inside = true;


func set_is_mouse_inside(val):
	is_mouse_inside = val;

func _input(event: InputEvent) -> void:
	if viewport != null:
		if mesh == null:
			set_panel_size(display_y_scale);
			mesh_size = mesh.mesh.size;
		var is_mouse_event = false;

		for mouse_evnet in [InputEventMouse, InputEventMouseMotion, InputEventMouseButton]:
			if event is mouse_evnet:
				is_mouse_event = true;
				break;
		
		if is_mouse_event and (is_mouse_inside or is_mouse_held):
			handel_mouse_event(event);
#		elif is_mouse_event == false:
#			viewport.push_input(event)

func handel_mouse_event(event) -> void:
	var new_event : InputEvent = event.duplicate(true);

	var mouse_pos3D = find_mouse(get_viewport().get_mouse_position());
	if event is InputEventMouseButton:
		new_event.pressed = event.pressed;
		is_mouse_held = event.pressed;
		
	if mouse_pos3D != null:
		mouse_pos3D = area_3d.global_transform.affine_inverse() * mouse_pos3D;
		last_mosue_pos3D = mouse_pos3D;
	else:
		mouse_pos3D = last_mosue_pos3D;
		if mouse_pos3D == null:
			mouse_pos3D = Vector3.ZERO;

	var mouse_pos2D = Vector2(mouse_pos3D.x, -mouse_pos3D.y);

	mouse_pos2D.x += mesh_size.x / 2;
	mouse_pos2D.y += mesh_size.y / 2;

	mouse_pos2D.x = mouse_pos2D.x / mesh_size.x;
	mouse_pos2D.y = mouse_pos2D.y / mesh_size.y;

	mouse_pos2D.x = mouse_pos2D.x * 1080; #1920#viewport.size.x;
	mouse_pos2D.y = mouse_pos2D.y * 1080; #1080#viewport.size.y;
	
	new_event.position = mouse_pos2D;
	new_event.global_position = mouse_pos2D;

	if event is InputEventMouseMotion:
		if last_mosue_pos2D == null:
			new_event.relative = Vector2.ZERO;
		else:
			new_event.relative = mouse_pos2D - last_mosue_pos2D;
		
		
		last_mosue_pos2D = mouse_pos2D;
		
	
		
	viewport.push_input(new_event);

func find_mouse(pos : Vector2):
	var mouse_pos = pos;
	var ray_length = 1000
	var from = get_viewport().get_camera_3d().project_ray_origin(mouse_pos)
	var to = get_viewport().get_camera_3d().project_ray_normal(mouse_pos) * ray_length
	var space = get_world_3d().direct_space_state
	var ray_query = PhysicsRayQueryParameters3D.new()
	ray_query.from = from
	ray_query.to = to
	ray_query.collide_with_areas = true;
	ray_query.collision_mask = area_3d.collision_layer;
	var raycast_result = space.intersect_ray(ray_query)
	
	if raycast_result.size() > 0:
		return raycast_result.position;
	else:
		return null;

func set_panel_size(y_scale):
	var area_shape = $MeshInstance3D/Area3D/CollisionShape3D;

	var view_h : float = 1080; #1080 #viewport.size.y;
	var view_w : float = 1080; #1920 #viewport.size.x;
	var x_scale = 0.0;
	var ratio = view_w / view_h;

	x_scale = y_scale * ratio;

	mesh.mesh.size.x = x_scale;
	mesh.mesh.size.y = y_scale;
	area_shape.shape.size.x = x_scale;
	area_shape.shape.size.y = y_scale;
	area_3d.position.z = 0.01
	
	mesh_size = Vector2(x_scale, y_scale);




