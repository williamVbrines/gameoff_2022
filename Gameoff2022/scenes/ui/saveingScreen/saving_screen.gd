extends Control

@onready var loading_lable: Label = $"Background/Loading Lable"
@onready var min_anim_timer: Timer = $MinAnimTimer

const FADE_TIME : float = 0.5;

var is_loading_complete : bool = false;

func _ready() -> void:
	_make_connections();
	
func _make_connections() -> void:
	EventManager.show_save_screen.connect(_start_saveing_anim);
	EventManager.saving_complete.connect(_on_saving_complete);
	
	
func _on_saving_complete() -> void:
	is_loading_complete = true;
	
	
func _start_saveing_anim() -> void:
	
	var tween = create_tween();
	
	is_loading_complete = false;
	min_anim_timer.start(3.0);
	show();
	tween.stop();
	tween.tween_callback(loading_lable.set_text.bind("Saving"));
	tween.tween_callback(loading_lable.show)
	
	tween.tween_callback(_saveing_anim);
	tween.tween_callback(EventManager.call_deferred.bind("emit_signal","save_file_data"))
	tween.play();
	
	
func _saveing_anim() -> void:
	var tween = create_tween();
	
	tween.finished.connect(_saveing_anim_finnished);
	var speed = 0.5;
	tween.stop();
	tween.tween_callback(loading_lable.set_text.bind("Saving"));
	tween.tween_interval(speed);
	tween.tween_callback(loading_lable.set_text.bind("Saving."));
	tween.tween_interval(speed);
	tween.tween_callback(loading_lable.set_text.bind("Saving.."));
	tween.tween_interval(speed);
	tween.tween_callback(loading_lable.set_text.bind("Saving..."));
	tween.tween_interval(speed);
	tween.tween_callback(loading_lable.set_text.bind("Saving .."));
	tween.tween_interval(speed);
	tween.tween_callback(loading_lable.set_text.bind("Saving  ."));
	tween.tween_interval(speed);
	tween.play();
	
	
func _saveing_anim_finnished() -> void:
	if min_anim_timer.is_stopped() == false || is_loading_complete == false:
		_saveing_anim();
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
	tween.play();
	
	
