extends Button

@export var action : String = "NOTHING";
@export var icon_texture : Texture;

@export var label_text = "Test Example";
@onready var label: Label = $Texture/Label
@onready var timer: Timer = $Timer

@onready var texture: TextureRect = $Texture;
const PRESSED_SCALE : Vector2 = Vector2(0.2,0.2);

var is_draging : bool = false;
	
var click_cout : int = 0;

var double_click_time = 0.5
var bounds : Vector2 = Vector2(1080 - 120, 1080 - 120 );

func _ready() -> void:
	flat = true;
	focus_mode = Control.FOCUS_NONE;
	
	if icon_texture != null:
		texture.set_texture(icon_texture);
		
	label.set_text(label_text);
	
	size = texture.size;
	texture.scale = Vector2(1,1);
	texture.position = -(texture.size * texture.scale)/2 + size/2
	_make_connections();
	
	
func _make_connections() -> void:
	button_down.connect(_on_pressed);
	button_up.connect(_on_released);
	mouse_exited.connect(_on_mouse_exitend);
	timer.timeout.connect(_on_timer_stoped);
	
	
func _on_pressed() -> void:
	click_cout += 1;
	is_draging = true;
	texture.scale += PRESSED_SCALE;
	texture.position = -(texture.size * texture.scale)/2 + size/2
	
	if click_cout == 2:
		EventManager.icon_pressed.emit(action);
	elif click_cout <= 1:
		timer.stop();
		timer.start(double_click_time);
	
func _on_released() ->void:
	
	is_draging = false;
	texture.scale = Vector2(1,1);
	texture.position = -(texture.size * texture.scale)/2 + size/2
	
	
func _input(event: InputEvent) -> void:
	if is_draging:
		if event is InputEventMouseMotion:
			global_position = event.position - size/2;
			global_position.x = clamp(global_position.x,0,bounds.x);
			global_position.y = clamp(global_position.y,0,bounds.y);
			
func store_data() -> void:
	pass
	
	
func load_data() -> void:
	pass


func _on_mouse_exitend() -> void:
	click_cout = 0;

func _on_timer_stoped() -> void:
	click_cout = 0;
