extends Control

@onready var label: Label = $Label
@onready var label_button: Button = $Label/Background/Button
@onready var label_background: NinePatchRect = $Label/Background

@onready var cancel_button: Button = $CancelTexy/Background/Button
@onready var cancel_background: NinePatchRect = $CancelTexy/Background

@export var hovor_color : Color = Color.WHITE;
@export var normal_color : Color  = Color.WHITE;
@export var pressed_color : Color  = Color.WHITE;

var action : String = "";
const FADE_TIME : float = 0.5;

func _ready() -> void:
	_make_connections();
	
	modulate = Color(Color.WHITE, 0.0);
	hide();
	
	cancel_background.modulate = normal_color;
	label_background.modulate = normal_color;
	
	
func _make_connections() -> void:
	EventManager.room_show_confirm.connect(_on_show_confirm);
	
	cancel_button.pressed.connect(_on_cancel_pressed);
	cancel_button.mouse_entered.connect(_on_cancel_mouse_entered);
	cancel_button.mouse_exited.connect(_on_cancel_mouse_exited);
	cancel_button.button_down.connect(_on_cancel_down);
	cancel_button.button_up.connect(_on_cancel_up);
	
	label_button.pressed.connect(_on_label_button_pressed);
	label_button.mouse_entered.connect(_on_label_button_mouse_entered);
	label_button.mouse_exited.connect(_on_label_button_mouse_exited);
	label_button.button_down.connect(_on_label_button_down);
	label_button.button_up.connect(_on_label_button_up);
	
func _on_label_button_down() -> void:
	label_background.modulate = pressed_color;

func _on_label_button_up() -> void:
	label_background.modulate = normal_color;
	
func _on_label_button_mouse_entered() ->void:
	label_background.modulate = hovor_color;
	
func _on_label_button_mouse_exited() -> void:
	label_background.modulate = normal_color;
	
func _on_label_button_pressed() -> void:
	_parce_action();
	
func _on_cancel_down() -> void:
	cancel_background.modulate = pressed_color;

func _on_cancel_up() -> void:
	cancel_background.modulate = normal_color;
	
func _on_cancel_mouse_entered() ->void:
	cancel_background.modulate = hovor_color;
	
func _on_cancel_mouse_exited() -> void:
	cancel_background.modulate = normal_color;
	
func _on_cancel_pressed() -> void:
	action = "";
	_hide_anim();
	
	
func _show_anim() -> void:
	var tween = create_tween();
	tween.tween_callback(show);
	
	tween.stop();
	
	tween.tween_property(self, "modulate",Color(Color.WHITE, 1.0), FADE_TIME);
	
	tween.play();
	
	
func _hide_anim() -> void:
	var tween = create_tween();
	tween.stop();
	
	tween.tween_property(self, "modulate",Color(Color.WHITE, 0.0), FADE_TIME)
	tween.tween_callback(hide);
	tween.play();
	
	
func _parce_action():
	
	match action.to_upper():
		"SLEEP":
			pass
			
	action = "";
	_hide_anim()
	
func _on_show_confirm(text : String) -> void:
	_show_anim();

