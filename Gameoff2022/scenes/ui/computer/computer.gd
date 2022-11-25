extends Control

@onready var screen_effect: ColorRect = $ScreenEffect
@onready var login_screen: Control = $LoginScreen

func _ready() -> void:
	_make_connections();
	
	
func _make_connections() -> void:
	EventManager.icon_pressed.connect(_on_icon_pressed);
	login_screen.start_pressed.connect(_on_start_pressed)
	
	
func _on_icon_pressed(action : String) -> void:
	print(action);
	match  action.to_upper():
		"QUIT":
			_play_quit_animation();
			
	
	
func _play_quit_animation() -> void:
	var tween = create_tween();
	tween.stop();
	tween.tween_property(screen_effect.material, "shader_parameter/curve", 0.28, 0.5);
	tween.tween_interval(0.05)
	tween.tween_property(screen_effect.material, "shader_parameter/curve", 0.00, 0.1);
	tween.tween_interval(0.5)
	tween.tween_callback(get_tree().quit)
	tween.play();
	
	
func _on_start_pressed() -> void:
	print("hello")
	
