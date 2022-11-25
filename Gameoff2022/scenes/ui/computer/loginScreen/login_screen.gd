extends Control
@export var button: TextureButton

@export var hovor_color : Color = Color.WHITE;
@export var normal_color : Color  = Color.WHITE;
@export var pressed_color : Color  = Color.WHITE;
@onready var panel: Control = $Background/Panel
@onready var loading_lable: Label = $"Background/Loading Lable"
@onready var min_anim_timer: Timer = $MinAnimTimer

const FADE_TIME : float = 0.5;

var is_loading_complete : bool = false;

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
	EventManager.loading_complete.connect(_on_loading_complete);
	
	
func _on_loading_complete() -> void:
	is_loading_complete = true;
	
	
func _on_button_down() -> void:
	button.modulate = pressed_color;
	
	
func _on_button_up() -> void:
	button.modulate = normal_color;
	
	
func _on_button_mouse_entered() ->void:
	button.modulate = hovor_color;
	
	
func _on_button_mouse_exited() -> void:
	button.modulate = normal_color;
	
	
func _on_button_pressed() -> void:
	button.disabled = true;
	_start_loading_anim();
	
	
func _start_loading_anim() -> void:
	
	var tween = create_tween();
	
	is_loading_complete = false;
	min_anim_timer.start(3.0);
	
	tween.stop();
	tween.tween_callback(loading_lable.show)
	tween.tween_callback(panel.set_modulate.bind(Color(Color.WHITE,0.75)))
	tween.tween_interval(0.1);
	tween.tween_callback(panel.set_modulate.bind(Color(Color.WHITE,0.50)))
	tween.tween_interval(0.1);
	tween.tween_callback(panel.set_modulate.bind(Color(Color.WHITE,0.25)))
	tween.tween_interval(0.1);
	tween.tween_callback(panel.set_modulate.bind(Color(Color.WHITE,0.0)))
	tween.tween_callback(panel.hide);
	
	tween.tween_callback(_loading_anim);
	tween.tween_callback(EventManager.call_deferred.bind("emit_signal","load_file_data"))
	tween.play();
	
	
func _loading_anim() -> void:
	var tween = create_tween();
	
	tween.finished.connect(_loading_anim_finnished);
	var speed = 0.5;
	tween.stop();
	tween.tween_callback(loading_lable.set_text.bind("Loading"));
	tween.tween_interval(speed);
	tween.tween_callback(loading_lable.set_text.bind("Loading."));
	tween.tween_interval(speed);
	tween.tween_callback(loading_lable.set_text.bind("Loading.."));
	tween.tween_interval(speed);
	tween.tween_callback(loading_lable.set_text.bind("Loading..."));
	tween.tween_interval(speed);
	tween.tween_callback(loading_lable.set_text.bind("Loading .."));
	tween.tween_interval(speed);
	tween.tween_callback(loading_lable.set_text.bind("Loading  ."));
	tween.tween_interval(speed);
	tween.play();
	
	
func _loading_anim_finnished() -> void:
	if min_anim_timer.is_stopped() == false || is_loading_complete == false:
		_loading_anim();
	else:
		_close_anim();
	
func _close_anim() -> void:
	var tween = create_tween();
	
	is_loading_complete = false;
	min_anim_timer.start(3.0);
	
	tween.stop();
	tween.tween_callback(set_modulate.bind(Color(Color.WHITE,0.75)))
	tween.tween_interval(0.1);
	tween.tween_callback(set_modulate.bind(Color(Color.WHITE,0.50)))
	tween.tween_interval(0.1);
	tween.tween_callback(set_modulate.bind(Color(Color.WHITE,0.25)))
	tween.tween_interval(0.1);
	tween.tween_callback(set_modulate.bind(Color(Color.WHITE,0.0)))
	tween.tween_callback(hide);
	tween.tween_callback(EventManager.call_deferred.bind("emit_signal", "monitor_startup_complete"));
	tween.play();
