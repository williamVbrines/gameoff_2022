extends Control
@export var button: TextureButton

@export var hovor_color : Color = Color.WHITE;
@export var normal_color : Color  = Color.WHITE;
@export var pressed_color : Color  = Color.WHITE;

const FADE_TIME : float = 0.5;

signal start_pressed();

func _ready() -> void:
	_make_connections();
	
	button.modulate = normal_color;
	
	
func _make_connections() -> void:
	button.pressed.connect(_on_button_pressed);
	button.mouse_entered.connect(_on_button_mouse_entered);
	button.mouse_exited.connect(_on_button_mouse_exited);
	button.button_down.connect(_on_button_down);
	button.button_up.connect(_on_button_up);
	
	
func _on_button_down() -> void:
	button.modulate = pressed_color;
	
	
func _on_button_up() -> void:
	button.modulate = normal_color;
	
	
func _on_button_mouse_entered() ->void:
	button.modulate = hovor_color;
	
	
func _on_button_mouse_exited() -> void:
	button.modulate = normal_color;
	
	
func _on_button_pressed() -> void:
	start_pressed.emit();
