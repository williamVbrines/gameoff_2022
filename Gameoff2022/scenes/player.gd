extends CharacterBody3D

@onready var boomarm : SpringArm3D = $Boomarm;
@onready var camera : Camera3D = $Boomarm/Camera;
@onready var look_cast: RayCast3D = $Boomarm/LookCast
@onready var look_ball: MeshInstance3D = $LookBall

@export_range(0.0,1.0,0.001) var zoom_step : float = 0.1;
@export_range(0.0,30.0,0.1) var default_move_speed : float = 10;
@export_range(0.0,100,0.000001) var turn_speed  : float = PI/32 * 100;

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

var acceleration: Vector3 = Vector3.ZERO;
var drag_orgin =  Vector2.ZERO;

func _input(event: InputEvent) -> void:
	camera_event(event);
	look_event(event);

func _physics_process(delta: float) -> void:
	
	if look_cast.is_colliding():
		look_ball.global_position = look_cast.get_collision_point()
	
	turn(delta);
	movement(delta);
	
	move_and_slide()
	
	
func turn(delta : float) -> void:
	var rot_dir : float = \
	Input.get_action_strength("rotate_anticlockwise") \
	- Input.get_action_strength("rotate_clockwise");
	
	if !Input.is_action_pressed("mouse_left") && Input.is_action_pressed("foward") &&  boomarm.rotation.y != 0.0:
		rotation.y += boomarm.rotation.y;
		boomarm.rotation.y = 0.0;
	
	
	rotation.y = lerp(rotation.y , rot_dir * turn_speed + rotation.y, .2  * delta);
	rotation.y = wrapf(rotation.y, 0, 2 * PI);
	
	
func movement(_delta : float) -> void:
	var input_dir := Input.get_vector("left", "right", "foward", "backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	var movment := direction * default_move_speed;
	
	# Add the gravity if not on ground
	if !is_on_floor():
		movment.y -= gravity ;
		
	velocity = lerp(velocity, movment, .2 );
	pass
	
	
func camera_event(event : InputEvent) -> void:
	if event.is_action_pressed("zoom_in"):
		boomarm.spring_length = max(0,boomarm.spring_length - zoom_step);
		
		
	if event.is_action_pressed("zoom_out"):
		boomarm.spring_length += zoom_step;
		
	if event.is_action_pressed("mouse_left"):
		drag_orgin = get_viewport().get_mouse_position();
		
	if event is InputEventMouseMotion:
		
		if Input.is_action_pressed("mouse_left"): 
			
			boomarm.rotation.y -= (get_viewport().get_mouse_position() - drag_orgin ).x / 100;
			boomarm.rotation.x -= (get_viewport().get_mouse_position() - drag_orgin ).y / 100;
			drag_orgin = get_viewport().get_mouse_position();
	
	
func look_event(event : InputEvent) -> void:
	if event is InputEventMouseMotion:
		var pos = event.position;
		
		look_cast.global_rotation = Vector3.ZERO;
		look_cast.target_position = camera.project_ray_normal(pos) * 2000;
		


