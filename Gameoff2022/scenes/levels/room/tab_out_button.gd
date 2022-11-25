extends Button

@export var cam : Camera3D;
@onready var fade: ColorRect = $Fade

const FADE_SPEED : float = 0.5;

func _ready() -> void:
	self_modulate = Color(Color.WHITE, 0.0);
	fade.modulate = Color(Color.WHITE, 0.0);
	disabled = true;
	hide();
	fade.modulate = Color(Color.WHITE, 0.0);
	_make_connections();

func _make_connections() -> void:
	pressed.connect(_on_pressed);
	EventManager.monitor_startup_complete.connect(_show_anim);
	EventManager.moved_to_monitor.connect(_show_anim);
	
	
func _show_anim() -> void:
	var tween = create_tween();
	tween.stop();
	tween.tween_callback(show);
	tween.tween_property(self, "self_modulate", Color(Color.WHITE, 1.0), FADE_SPEED);
	tween.tween_callback(set_disabled.bind(false));
	tween.play();
	
	
func _on_pressed() -> void:
	disabled = true;
	_trans_to_room_anim();
	
	
func _trans_to_room_anim() -> void:
	var tween = create_tween();
	tween.stop();
	tween.tween_property(self, "self_modulate", Color(Color.WHITE, 0.0), FADE_SPEED);
	tween.tween_property(fade, "modulate", Color(Color.WHITE, 1.0), FADE_SPEED);
	tween.tween_callback(cam.set_current.bind(true));
	tween.tween_property(fade, "modulate", Color(Color.WHITE, 0.0), FADE_SPEED);
	tween.tween_callback(hide);
	tween.play();
	
	
func _input(event: InputEvent) -> void:
	if disabled == false:
		if event.is_action_pressed("tabout"):
			_on_pressed();
