extends Control

@onready var label: Label = $Options/Label
@onready var label_button: Button = $Options/Label/Background/Button
@onready var label_background: NinePatchRect = $Options/Label/Background

@onready var cancel_button: Button = $Options/CancelText/Background/Button
@onready var cancel_background: NinePatchRect = $Options/CancelText/Background

@onready var fade: ColorRect = $Fade

@export var hovor_color : Color = Color.WHITE;
@export var normal_color : Color  = Color.WHITE;
@export var pressed_color : Color  = Color.WHITE;
@onready var options: Control = $Options

@onready var monitor_camera: Camera3D = $"../../Room3D/MonitorCamera"
@onready var room_camera: Camera3D = $"../../Room3D/RoomCamera"

@onready var computer_on_audio: AudioStreamPlayer = $ComputerONAudio
@onready var door_audio: AudioStreamPlayer = $DoorAudio
@onready var bed_audio: AudioStreamPlayer = $bedAudio

var action : String = "";
const FADE_TIME : float = 0.5;
var in_use : bool = false;

func _ready() -> void:
	_make_connections();
	
	options.modulate = Color(Color.WHITE, 0.0);
	options.hide();
	
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
	
	EventManager.monitor_startup_complete.connect(_on_monitor_startup_complete);
	
	
func _on_monitor_startup_complete() -> void:
	var tween = create_tween();
	tween.stop();
	var end = SystemGlobals.bgmVol;
	var val = -80.0;
	for i in 50:
		val = -80  - (i * ((-80 - end)/50))
		tween.tween_callback(AudioServer.call_deferred.bind("set_bus_volume_db",AudioServer.get_bus_index("BGM"), val));
		tween.tween_interval(0.05);
	tween.play();
	
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
	tween.tween_callback(options.show);
	
	tween.stop();
	tween.tween_callback(on_label_resized);
	tween.tween_property(options, "modulate",Color(Color.WHITE, 1.0), FADE_TIME);
	
	tween.play();
	
	
func _hide_anim() -> void:
	var tween = create_tween();
	tween.stop();
	
	tween.tween_property(options, "modulate",Color(Color.WHITE, 0.0), FADE_TIME)
	tween.tween_callback(options.hide);
	tween.tween_callback(set_in_use.bind(false));
	tween.play();
	
func set_in_use(val : bool) ->void:
	in_use = val;
	
func _parce_action():
	
	match action.to_upper():
		"BED":
			bed_audio.play_rand();
		"MONITOR":
			
			EventManager.show_save_screen.emit();
			
			computer_on_audio.play_rand();
			Input.mouse_mode = Input.MOUSE_MODE_HIDDEN;
			
			_trans_to_monitor();
		"DOOR":
			door_audio.play();
	action = "";
	_hide_anim()
	
	
func _on_show_confirm(text : String, new_action : String) -> void:
	if in_use == false:
		action = new_action;
		label.set_text("");
		label.size.x = 1;
		label.set_text(text);
		_show_anim();
		in_use = true;
	
	
func on_label_resized() -> void:
	label.position.x = (1920/2.0) - (label.size.x / 2.0);
	
	
func _fade_out():
	var tween = create_tween();
	tween.stop();
	fade.show();
	tween.tween_property(fade, "modulate",Color(Color.BLACK, 1.0), FADE_TIME)
	tween.play();
	
	
func _fade_in():
	var tween = create_tween();
	tween.stop();

	tween.tween_property(fade, "modulate",Color(Color.BLACK, 0.0), FADE_TIME)
	tween.tween_callback(fade.hide);
	tween.play();
	
	
func _trans_to_monitor() -> void:

	
	var tween = create_tween();
	
	tween.stop();
	tween.tween_callback(_fade_out);
	tween.tween_interval(FADE_TIME);
	tween.tween_callback(monitor_camera.set_current.bind(true));
	tween.tween_callback(EventManager.call_deferred.bind("emit_signal", "moved_to_monitor"));
	tween.tween_callback(_fade_in);
	tween.tween_callback(set_in_use.bind(false));
	tween.play();

	
