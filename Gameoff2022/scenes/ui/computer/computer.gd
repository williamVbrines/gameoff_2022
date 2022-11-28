extends Control

@onready var screen_effect: ColorRect = $ScreenEffect
@onready var login_screen: Control = $LoginScreen
@onready var turn_on_audio: AudioStreamPlayer = $TurnOnAudio
@onready var turn_off_audio: AudioStreamPlayer = $TurnOffAudio
@onready var input_stoper: ColorRect = $InputStoper
@onready var level_select: Control = $LevelSelect
@onready var credits: Control = $Credits
@onready var settings: Control = $Settings

func _ready() -> void:
	_make_connections();
	if SystemGlobals.play_start_anim == true:
		SystemGlobals.play_start_anim = false;
		_start_anim();
	else:
		screen_effect.material.set("shader_parameter/curve", 5.0);
		
		
func _make_connections() -> void:
	EventManager.icon_pressed.connect(_on_icon_pressed);
	
	
func _on_icon_pressed(action : String) -> void:
	match  action.to_upper():
		"QUIT":
			_play_quit_animation();
		"FAKE_GAME":
			input_stoper.show();
			SceneChanger.load_level("res://scenes/levels/village/village.tscn");
		"TODO":
			level_select.open_anim();
		"CREDITS":
			credits.open_anim();
		"SETTINGS":
			settings.open_anim();
			
func _play_quit_animation() -> void:
	var tween = create_tween();
	tween.stop();
	tween.tween_callback(input_stoper.show);
	tween.tween_callback(turn_off_audio.play)
	tween.tween_interval(1)
	tween.tween_property(screen_effect.material, "shader_parameter/curve", 0.28, 0.5);
	tween.tween_interval(0.05)
	tween.tween_property(screen_effect.material, "shader_parameter/curve", 0.00, 0.1);
	tween.tween_interval(1)
	tween.tween_callback(get_tree().quit)
	tween.play();
	
	
func _start_anim() -> void:
	var tween = create_tween();
	tween.stop();
	tween.tween_callback(input_stoper.show);
	tween.tween_interval(1.0)
	tween.tween_callback(turn_on_audio.play);
	tween.tween_property(screen_effect.material, "shader_parameter/curve", 5.0, 0.5);
	tween.tween_interval(0.5)
	tween.tween_callback(input_stoper.hide);
	tween.play();
	

